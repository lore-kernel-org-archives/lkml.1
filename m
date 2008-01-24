Return-Path: <linux-kernel-owner+w=401wt.eu-S1752532AbYAZPya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532AbYAZPya (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 10:54:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752300AbYAZPyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 10:54:10 -0500
Received: from 206-47-31-89.wifiinternet.cz ([89.31.47.206]:1177 "EHLO
	monstr.monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752673AbYAZPxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 10:53:48 -0500
From: monstr@monstr.eu
To: monstr@monstr.eu
Cc: linux-kernel@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       john.williams@petalogix.com, microblaze-uclinux@itee.uq.edu.au
Subject: [PATCH 18/52] [microblaze] early_printk support
Date: Thu, 24 Jan 2008 16:02:53 +0100
Message-Id: <eb28582e845efb4f2f26054630895f26fa69866e.1201107832.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.rc4.14.g6fc74
In-Reply-To: <4b7d90fc1b9bcb3c0b1b308c6460390f7bdf3824.1201107832.git.monstr@monstr.eu>
References: <1201187014-3979-1-git-send-email-monstr@monstr.eu>
 <dbff6b883dbcb108db53e5093994c473946e1240.1201107832.git.monstr@monstr.eu>
 <ac0947adfe718fcb4c0dc5f6f7ab64f8155541fb.1201107832.git.monstr@monstr.eu>
 <873c2bf1f67696aa11014886470f6ba46f04e8d2.1201107832.git.monstr@monstr.eu>
 <516d173b1789ea533431e8f5ad05751c6a353c88.1201107832.git.monstr@monstr.eu>
 <068508828aac6298b4cc65b0cd7b2737a61c466c.1201107832.git.monstr@monstr.eu>
 <010fc233f82a8f7a591c9f8315ae03f9951139aa.1201107832.git.monstr@monstr.eu>
 <68faaf69ea03196d4a56a263707355e7e7eb5c6a.1201107832.git.monstr@monstr.eu>
 <4b7d90fc1b9bcb3c0b1b308c6460390f7bdf3824.1201107832.git.monstr@monstr.eu>
In-Reply-To: <8051f6df628e1ff896ec7d580b613da50f718fb4.1201107832.git.monstr@monstr.eu>
References: <8051f6df628e1ff896ec7d580b613da50f718fb4.1201107832.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/kernel/early_printk.c |  115 +++++++++++++++++++++++++++++++++
 1 files changed, 115 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/kernel/early_printk.c

diff --git a/arch/microblaze/kernel/early_printk.c b/arch/microblaze/kernel/early_printk.c
new file mode 100644
index 0000000..0f533ff
--- /dev/null
+++ b/arch/microblaze/kernel/early_printk.c
@@ -0,0 +1,115 @@
+/*
+ * arch/microblaze/kernel/early_printk.c
+ *
+ * Copyright (C) 2007 Michal Simek <monstr@monstr.eu>
+ * Copyright (C) 2003-2006 Yasushi SHOJI <yashi@atmark-techno.com>
+ *
+ * Early printk support for Microblaze.
+ *
+ * Once we got some system without uart light, we need to refactor.
+ */
+
+#include <linux/console.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/string.h>
+#include <linux/tty.h>
+#include <asm/io.h>
+#include <asm/processor.h>
+#include <asm/fcntl.h>
+#include <asm/setup.h>
+
+#ifdef CONFIG_EARLY_PRINTK
+#define BASE_ADDR ((unsigned char *)CONFIG_EARLY_PRINTK_UARTLITE_ADDRESS)
+
+#define RX_FIFO	BASE_ADDR
+#define TX_FIFO	((unsigned long *)(BASE_ADDR + 4))
+#define STATUS	((unsigned long *)(BASE_ADDR + 8))
+#define CONTROL	((unsigned long *)(BASE_ADDR + 12))
+
+static void early_printk_putc(char c)
+{
+	while (ioread32(STATUS) & (1<<3));
+	iowrite32((c & 0xff), TX_FIFO);
+}
+
+static void early_printk_write(struct console *unused,
+					const char *s, unsigned n)
+{
+	while (*s && n-- > 0) {
+		early_printk_putc(*s);
+		if (*s == '\n')
+			early_printk_putc('\r');
+		s++;
+	}
+}
+
+static struct console early_serial_console = {
+	.name = "earlyser",
+	.write = early_printk_write,
+	.flags = CON_PRINTBUFFER,
+	.index = -1,
+};
+
+/* Direct interface for emergencies */
+static struct console *early_console = &early_serial_console;
+static int early_console_initialized;
+
+void early_printk(const char *fmt, ...)
+{
+	char buf[512];
+	int n;
+	va_list ap;
+
+	if (early_console_initialized) {
+		va_start(ap, fmt);
+		n = vscnprintf(buf, 512, fmt, ap);
+		early_console->write(early_console, buf, n);
+		va_end(ap);
+	}
+}
+
+static int __initdata keep_early;
+
+int __init setup_early_printk(char *opt)
+{
+	char *space;
+	char buf[256];
+
+	if (early_console_initialized)
+		return 1;
+
+	strlcpy(buf, opt, sizeof(buf));
+	space = strchr(buf, ' ');
+	if (space)
+		*space = 0;
+
+	if (strstr(buf, "keep"))
+		keep_early = 1;
+
+	early_console = &early_serial_console;
+	early_console_initialized = 1;
+	register_console(early_console);
+	return 0;
+}
+#if 0
+static void __init disable_early_printk(void)
+{
+	if (!early_console_initialized || !early_console)
+		return;
+	if (!keep_early) {
+		printk(KERN_INFO "disabling early console\n");
+		unregister_console(early_console);
+		early_console_initialized = 0;
+	} else
+		printk(KERN_INFO "keeping early console\n");
+}
+#endif
+
+__setup("earlyprintk=", setup_early_printk);
+
+#else
+void early_printk(const char *fmt, ...)
+{
+}
+#endif
-- 
1.5.4.rc4.14.g6fc74

