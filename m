Return-Path: <linux-kernel-owner+w=401wt.eu-S1756904AbZCRVmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756904AbZCRVmf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 17:42:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754841AbZCRVmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 17:42:00 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:54475 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751734AbZCRVl7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 17:41:59 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 19/57] microblaze_v7: early_printk support
Date: Wed, 18 Mar 2009 21:30:46 +0100
Message-Id: <b726b7b271cf303c36af54c4e155140541a6769b.1237407249.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <75127eae09c978220d452d92f95763dde24f1d52.1237407249.git.monstr@monstr.eu>
References: <1237408284-8674-1-git-send-email-monstr@monstr.eu>
 <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
 <c1bdfabf85ce10babc3aa38d3bb7558a093bc49e.1237407249.git.monstr@monstr.eu>
 <4b5aee01d11fc790c7842838ea63a82ee3273003.1237407249.git.monstr@monstr.eu>
 <af309ba8e95f503b7990461384d9f8453f45dbbd.1237407249.git.monstr@monstr.eu>
 <5f8b2a60496983f572ef6d3b4e2f986c167a8336.1237407249.git.monstr@monstr.eu>
 <fbef554ff1d05fa50312d91e61a0d63d3207076c.1237407249.git.monstr@monstr.eu>
 <dad2353f129217470f0595eeed98412b4c84ed6b.1237407249.git.monstr@monstr.eu>
 <20fd42a1e8837c7352d35d157aa3393e88152c32.1237407249.git.monstr@monstr.eu>
 <f7c1685bd3f387be8633db5fb3dd4cb5e7c2d792.1237407249.git.monstr@monstr.eu>
 <2f48efc353c11dfdfc7b052bdfe052b71c09ab23.1237407249.git.monstr@monstr.eu>
 <f7f2d17e21a3df9931c75976c37a003d11190cc9.1237407249.git.monstr@monstr.eu>
 <58cf06c85e07477170677b72ce3437af10476bec.1237407249.git.monstr@monstr.eu>
 <eaa0169a360a328883ab0eabd2a189c21bad4c30.1237407249.git.monstr@monstr.eu>
 <20227d6f2615060d6560785090513e251cbe2654.1237407249.git.monstr@monstr.eu>
 <69ef4f976d86c870a97fbe4974c242c74acc477d.1237407249.git.monstr@monstr.eu>
 <eb4ccc67cf39abc816c8d7653fdc7561d14c1da2.1237407249.git.monstr@monstr.eu>
 <1477ec41e7ba0ec847a064e1f8e422dc2a5dcc9f.1237407249.git.monstr@monstr.eu>
 <75127eae09c978220d452d92f95763dde24f1d52.1237407249.git.monstr@monstr.eu>
In-Reply-To: <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
References: <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/kernel/early_printk.c |  106 +++++++++++++++++++++++++++++++++
 1 files changed, 106 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/kernel/early_printk.c

diff --git a/arch/microblaze/kernel/early_printk.c b/arch/microblaze/kernel/early_printk.c
new file mode 100644
index 0000000..4e2083b
--- /dev/null
+++ b/arch/microblaze/kernel/early_printk.c
@@ -0,0 +1,106 @@
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
+#include <linux/console.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/string.h>
+#include <linux/tty.h>
+#include <linux/io.h>
+#include <asm/processor.h>
+#include <linux/fcntl.h>
+#include <asm/setup.h>
+#include <asm/prom.h>
+
+static u32 early_console_initialized;
+static u32 base_addr;
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
+	/* read status bit - 0x8 offset */
+	while (retries-- && (in_be32(base_addr + 8) & (1 << 3)))
+		;
+
+	/* Only attempt the iowrite if we didn't timeout */
+	/* write to TX_FIFO - 0x4 offset */
+	if (retries)
+		out_be32(base_addr + 4, c & 0xff);
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
+static struct console *early_console = &early_serial_console;
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
+int __init setup_early_printk(char *opt)
+{
+	if (early_console_initialized)
+		return 1;
+
+	base_addr = early_uartlite_console();
+	if (base_addr) {
+		early_console_initialized = 1;
+		early_printk("early_printk_console is enabled at 0x%08x\n",
+							base_addr);
+
+		/* register_console(early_console); */
+
+		return 0;
+	} else
+		return 1;
+}
+
+void __init disable_early_printk(void)
+{
+	if (!early_console_initialized || !early_console)
+		return;
+	printk(KERN_WARNING "disabling early console\n");
+	unregister_console(early_console);
+	early_console_initialized = 0;
+}
-- 
1.5.5.1

