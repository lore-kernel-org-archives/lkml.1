Return-Path: <linux-kernel-owner+w=401wt.eu-S933576AbZINUT6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933576AbZINUT6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:19:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757158AbZINUT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:19:57 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:54060 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933531AbZINUIf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:08:35 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Robin Getz <robin.getz@analog.com>
Subject: [PATCH 27/72] Blackfin: add an early shadow console
Date: Mon, 14 Sep 2009 16:07:31 -0400
Message-Id: <1252958896-25150-28-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
References: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robin Getz <robin.getz@analog.com>

Add a memory based shadow console to keep a copy of the printk buffer in a
location which can be found externally.  This allows bootloaders to locate
and utilize the log buffer in case of silent (early/resume/etc...) crashes.

Signed-off-by: Robin Getz <robin.getz@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/include/asm/early_printk.h |    2 +
 arch/blackfin/kernel/Makefile            |    1 +
 arch/blackfin/kernel/setup.c             |    2 +
 arch/blackfin/kernel/shadow_console.c    |   78 ++++++++++++++++++++++++++++++
 4 files changed, 83 insertions(+), 0 deletions(-)
 create mode 100644 arch/blackfin/kernel/shadow_console.c

diff --git a/arch/blackfin/include/asm/early_printk.h b/arch/blackfin/include/asm/early_printk.h
index 110f1c1..f5b6b7d 100644
--- a/arch/blackfin/include/asm/early_printk.h
+++ b/arch/blackfin/include/asm/early_printk.h
@@ -23,6 +23,8 @@
 
 #ifdef CONFIG_EARLY_PRINTK
 extern int setup_early_printk(char *);
+extern void enable_shadow_console(void);
 #else
 #define setup_early_printk(fmt) do { } while (0)
+#define enable_shadow_console(fmt)  do { } while (0)
 #endif /* CONFIG_EARLY_PRINTK */
diff --git a/arch/blackfin/kernel/Makefile b/arch/blackfin/kernel/Makefile
index 141d928..a8ddbc8 100644
--- a/arch/blackfin/kernel/Makefile
+++ b/arch/blackfin/kernel/Makefile
@@ -26,6 +26,7 @@ obj-$(CONFIG_MODULES)                += module.o
 obj-$(CONFIG_KGDB)                   += kgdb.o
 obj-$(CONFIG_KGDB_TESTS)             += kgdb_test.o
 obj-$(CONFIG_EARLY_PRINTK)           += early_printk.o
+obj-$(CONFIG_EARLY_PRINTK)           += shadow_console.o
 obj-$(CONFIG_STACKTRACE)             += stacktrace.o
 
 # the kgdb test puts code into L2 and without linker
diff --git a/arch/blackfin/kernel/setup.c b/arch/blackfin/kernel/setup.c
index 6dbf219..3974764 100644
--- a/arch/blackfin/kernel/setup.c
+++ b/arch/blackfin/kernel/setup.c
@@ -810,6 +810,8 @@ void __init setup_arch(char **cmdline_p)
 {
 	unsigned long sclk, cclk;
 
+	enable_shadow_console();
+
 	/* Check to make sure we are running on the right processor */
 	if (unlikely(CPUID != bfin_cpuid()))
 		printk(KERN_ERR "ERROR: Not running on ADSP-%s: unknown CPUID 0x%04x Rev 0.%d\n",
diff --git a/arch/blackfin/kernel/shadow_console.c b/arch/blackfin/kernel/shadow_console.c
new file mode 100644
index 0000000..15819ff
--- /dev/null
+++ b/arch/blackfin/kernel/shadow_console.c
@@ -0,0 +1,78 @@
+/*
+ * manage a small early shadow of the log buffer which we can pass between the
+ * bootloader so early crash messages are communicated properly and easily
+ *
+ * Copyright 2009 Analog Devices Inc.
+ *
+ * Enter bugs at http://blackfin.uclinux.org/
+ *
+ * Licensed under the GPL-2 or later.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/console.h>
+#include <linux/string.h>
+#include <asm/blackfin.h>
+#include <asm/irq_handler.h>
+#include <asm/early_printk.h>
+
+#define SHADOW_CONSOLE_START		(0x500)
+#define SHADOW_CONSOLE_END		(0x1000)
+#define SHADOW_CONSOLE_MAGIC_LOC	(0x4F0)
+#define SHADOW_CONSOLE_MAGIC		(0xDEADBEEF)
+
+static __initdata char *shadow_console_buffer = (char *)SHADOW_CONSOLE_START;
+
+static __init void early_shadow_write(struct console *con, const char *s,
+				unsigned int n)
+{
+	/*
+	 * save 2 bytes for the double null at the end
+	 * once we fail on a long line, make sure we don't write a short line afterwards
+	 */
+	if ((shadow_console_buffer + n) <= (char *)(SHADOW_CONSOLE_END - 2)) {
+		memcpy(shadow_console_buffer, s, n);
+		shadow_console_buffer += n;
+		shadow_console_buffer[0] = 0;
+		shadow_console_buffer[1] = 0;
+	} else
+		shadow_console_buffer = (char *)SHADOW_CONSOLE_END;
+}
+
+static __initdata struct console early_shadow_console = {
+	.name = "early_shadow",
+	.write = early_shadow_write,
+	.flags = CON_BOOT | CON_PRINTBUFFER,
+	.index = -1,
+	.device = 0,
+};
+
+__init void enable_shadow_console(void)
+{
+	int *loc = (int *)SHADOW_CONSOLE_MAGIC_LOC;
+
+	if (!(early_shadow_console.flags & CON_ENABLED)) {
+		register_console(&early_shadow_console);
+		/* for now, assume things are going to fail */
+		*loc = SHADOW_CONSOLE_MAGIC;
+		loc++;
+		*loc = SHADOW_CONSOLE_START;
+	}
+}
+
+static __init int disable_shadow_console(void)
+{
+	/*
+	 * by the time pure_initcall runs, the standard console is enabled,
+	 * and the early_console is off, so unset the magic numbers
+	 * unregistering the console is taken care of in common code (See
+	 * ./kernel/printk:disable_boot_consoles() )
+	 */
+	int *loc = (int *)SHADOW_CONSOLE_MAGIC_LOC;
+
+	*loc = 0;
+
+	return 0;
+}
+pure_initcall(disable_shadow_console);
-- 
1.6.4.2

