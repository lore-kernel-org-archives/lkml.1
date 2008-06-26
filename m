Return-Path: <linux-kernel-owner+w=401wt.eu-S1759677AbYFZNUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759677AbYFZNUz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 09:20:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752553AbYFZNUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 09:20:43 -0400
Received: from 238.225.broadband7.iol.cz ([88.102.225.238]:24042 "EHLO
	monstr.eu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752195AbYFZNUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 09:20:42 -0400
From: monstr@seznam.cz
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linux-arch@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       John.Linn@xilinx.com, john.williams@petalogix.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       linuxppc-dev@ozlabs.org, vapier.adi@gmail.com, alan@lxorguk.ukuu.org.uk,
       hpa@zytor.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 20/60] microblaze_v4: early_printk support
Date: Thu, 26 Jun 2008 14:29:49 +0200
Message-Id: <1214483429-32360-21-git-send-email-monstr@seznam.cz>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <1214483429-32360-20-git-send-email-monstr@seznam.cz>
References: <1214483429-32360-1-git-send-email-monstr@seznam.cz>
 <1214483429-32360-2-git-send-email-monstr@seznam.cz>
 <1214483429-32360-3-git-send-email-monstr@seznam.cz>
 <1214483429-32360-4-git-send-email-monstr@seznam.cz>
 <1214483429-32360-5-git-send-email-monstr@seznam.cz>
 <1214483429-32360-6-git-send-email-monstr@seznam.cz>
 <1214483429-32360-7-git-send-email-monstr@seznam.cz>
 <1214483429-32360-8-git-send-email-monstr@seznam.cz>
 <1214483429-32360-9-git-send-email-monstr@seznam.cz>
 <1214483429-32360-10-git-send-email-monstr@seznam.cz>
 <1214483429-32360-11-git-send-email-monstr@seznam.cz>
 <1214483429-32360-12-git-send-email-monstr@seznam.cz>
 <1214483429-32360-13-git-send-email-monstr@seznam.cz>
 <1214483429-32360-14-git-send-email-monstr@seznam.cz>
 <1214483429-32360-15-git-send-email-monstr@seznam.cz>
 <1214483429-32360-16-git-send-email-monstr@seznam.cz>
 <1214483429-32360-17-git-send-email-monstr@seznam.cz>
 <1214483429-32360-18-git-send-email-monstr@seznam.cz>
 <1214483429-32360-19-git-send-email-monstr@seznam.cz>
 <1214483429-32360-20-git-send-email-monstr@seznam.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/kernel/early_printk.c |  130 +++++++++++++++++++++++++++++++++
 1 files changed, 130 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/kernel/early_printk.c

diff --git a/arch/microblaze/kernel/early_printk.c b/arch/microblaze/kernel/early_printk.c
new file mode 100644
index 0000000..6da0fd9
--- /dev/null
+++ b/arch/microblaze/kernel/early_printk.c
@@ -0,0 +1,130 @@
+/*
+ * Early printk support for Microblaze.
+ *
+ * Copyright (C) 2007-2008 Michal Simek <monstr@monstr.eu>
+ * Copyright (C) 2003-2006 Yasushi SHOJI <yashi@atmark-techno.com>
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+/* FIXME Once we got some system without uart light, we need to refactor */
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
+	/*
+	 * Limit how many times we'll spin waiting for TX FIFO status.
+	 * This will prevent lockups if the base address is incorrectly
+	 * set, or any other issue on the UARTLITE.
+	 * This limit is pretty arbitrary, unless we are at about 10 baud
+	 * we'll never timeout on a working UART.
+	 */
+
+	unsigned retries = 10000;
+	while (retries-- && (ioread32(STATUS) & (1<<3)))
+		;
+
+	/* Only attempt the iowrite if we didn't timeout */
+	if (retries)
+		iowrite32((c & 0xff), TX_FIFO);
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
1.5.4.GIT

