Return-Path: <linux-kernel-owner+w=401wt.eu-S1753018AbZGBPUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018AbZGBPUp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 11:20:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750822AbZGBPUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 11:20:35 -0400
Received: from ey-out-1920.google.com ([74.125.78.150]:22853 "EHLO
	ey-out-1920.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbZGBPUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 11:20:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=PhfHUoL6M1BwwR7KkK5jw3CvNcNjxO0pZz3XqaibvLrjzhzIrvGk7OmPOjX9cWNLVy
         b3r2j8PKajO5VROpc9nfYlJ8pcW80GlTR/dzEPwo+QJIiOGsI5ehioDdYkTcXH5ffX5u
         5zrl6IPE/bzECqfzwnPrHWpLMAujYbvmXCQOY=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
       ralf@linux-mips.org, Jason Wessel <jason.wessel@windriver.com>
Cc: Wu Zhangjin <wuzj@lemote.com>, Yan Hua <yanh@lemote.com>,
       Philippe Vachon <philippe@cowpig.ca>, Zhang Le <r0bertz@gentoo.org>,
       Zhang Fuxin <zhangfx@lemote.com>,
       loongson-dev <loongson-dev@googlegroups.com>,
       Liu Junliang <liujl@lemote.com>, Erwan Lerale <erwan@thiscow.com>,
       Arnaud Patard <apatard@mandriva.com>
Subject: [PATCH v4 03/16] [loongson] early_printk: add new implmentation
Date: Thu,  2 Jul 2009 23:20:20 +0800
Message-Id: <9e23b4150f183c0817f2abbb95525279c2006a83.1246546684.git.wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <cover.1246546684.git.wuzhangjin@gmail.com>
References: <cover.1246546684.git.wuzhangjin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Zhangjin <wuzj@lemote.com>

This patch is based on the implementation in the lm2e-fixes branch of
Philippe's git://git.linux-cisco.org/linux-mips.git and the
malta-specific early_printk implementation.

Signed-off-by: Wu Zhangjin <wuzj@lemote.com>
---
 arch/mips/lemote/lm2e/Makefile       |    5 ++++
 arch/mips/lemote/lm2e/early_printk.c |   41 ++++++++++++++++++++++++++++++++++
 2 files changed, 46 insertions(+), 0 deletions(-)
 create mode 100644 arch/mips/lemote/lm2e/early_printk.c

diff --git a/arch/mips/lemote/lm2e/Makefile b/arch/mips/lemote/lm2e/Makefile
index b0c0339..f191732 100644
--- a/arch/mips/lemote/lm2e/Makefile
+++ b/arch/mips/lemote/lm2e/Makefile
@@ -4,4 +4,9 @@
 
 obj-y += setup.o prom.o reset.o irq.o pci.o bonito-irq.o mem.o
 
+#
+# Early printk support
+#
+obj-$(CONFIG_EARLY_PRINTK) += early_printk.o
+
 EXTRA_CFLAGS += -Werror
diff --git a/arch/mips/lemote/lm2e/early_printk.c b/arch/mips/lemote/lm2e/early_printk.c
new file mode 100644
index 0000000..811c7de
--- /dev/null
+++ b/arch/mips/lemote/lm2e/early_printk.c
@@ -0,0 +1,41 @@
+/*  early printk support
+ *
+ *  Copyright (c) 2009 Philippe Vachon <philippe@cowpig.ca>
+ *  Copyright (C) 2009 Lemote Inc. & Insititute of Computing Technology
+ *  Author: Wu Zhangjin, wuzj@lemote.com
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ */
+#include <linux/io.h>
+#include <linux/init.h>
+#include <linux/serial_reg.h>
+
+#include <asm/mips-boards/bonito64.h>
+
+#define UART_BASE (BONITO_PCIIO_BASE + 0x3f8)
+
+#define PORT(base, offset) (u8 *)(base + offset)
+
+static inline unsigned int serial_in(phys_addr_t base, int offset)
+{
+	return readb(PORT(base, offset));
+}
+
+static inline void serial_out(phys_addr_t base, int offset, int value)
+{
+	writeb(value, PORT(base, offset));
+}
+
+void prom_putchar(char c)
+{
+	phys_addr_t uart_base =
+		(phys_addr_t) ioremap_nocache(UART_BASE, 8);
+
+	while ((serial_in(uart_base, UART_LSR) & UART_LSR_THRE) == 0)
+		;
+
+	serial_out(uart_base, UART_TX, c);
+}
-- 
1.6.2.1

