Return-Path: <linux-kernel-owner+w=401wt.eu-S1757443AbYEDOEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443AbYEDOEc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 10:04:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753524AbYEDOEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 10:04:23 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:36072 "EHLO
	seznam.cz" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751441AbYEDOEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 10:04:22 -0400
From: monstr@seznam.cz
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linux-arch@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       John.Linn@xilinx.com, john.williams@petalogix.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       Michal Simek <monstr@monstr.eu>
Subject: [PATCH 18/56] microblaze_v2: early_printk support
Date: Sun,  4 May 2008 13:41:07 +0200
Message-Id: <378157891bac535dbc55e658d5f03fdd332e85cf.1209897266.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <b5067a1846075ddd1035966ea1edc908579e2e88.1209897266.git.monstr@monstr.eu>
References: <1209901305-6404-1-git-send-email-monstr@seznam.cz>
 <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
 <c805caeb1dd7f6d1349c4a463cb88a5342a170d2.1209897266.git.monstr@monstr.eu>
 <f120ababf2bade9aab7199bffb3014aa606e5a1c.1209897266.git.monstr@monstr.eu>
 <684c36e5ad3f598e5079e88ec195545c4a7150c2.1209897266.git.monstr@monstr.eu>
 <ed3695121faf485d491cecdd96d5d4dcc498411d.1209897266.git.monstr@monstr.eu>
 <0674b1f7abb9a3d564b68c95bc28adc2c2fe9551.1209897266.git.monstr@monstr.eu>
 <9a7c6646e5dd9724c1cf34767adec181481fa3ef.1209897266.git.monstr@monstr.eu>
 <932956128c9c655a218a940eaf02017a5dd0bdf9.1209897266.git.monstr@monstr.eu>
 <2f801c33caee22e112af51ae927c264ce99ead01.1209897266.git.monstr@monstr.eu>
 <2391e49379fb6639f57d9d6e5811f3d49a4c6fda.1209897266.git.monstr@monstr.eu>
 <0873f3a1f3b72591735c6461b51964693cac52e5.1209897266.git.monstr@monstr.eu>
 <0ba1f259d3c17eba54e334622493577493f5065f.1209897266.git.monstr@monstr.eu>
 <694451053534fea7b78fb9d618b53a2b5ebeb602.1209897266.git.monstr@monstr.eu>
 <f0c837df4106a31c1a81917596603918f722ea7b.1209897266.git.monstr@monstr.eu>
 <d883a8d8da812d77fefd47730d28d0bdb7b504e0.1209897266.git.monstr@monstr.eu>
 <625ef466cf121d655539eedc919dd39166087e0c.1209897266.git.monstr@monstr.eu>
 <b5067a1846075ddd1035966ea1edc908579e2e88.1209897266.git.monstr@monstr.eu>
In-Reply-To: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
References: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
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
1.5.4.GIT

