Return-Path: <linux-kernel-owner+w=401wt.eu-S1753494AbXDIVxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494AbXDIVxY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 17:53:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753071AbXDIVxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 17:53:23 -0400
Received: from nlpi015.sbcis.sbc.com ([207.115.36.44]:27198 "EHLO
	nlpi015.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965578AbXDIVXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 17:23:42 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
       Juha Yrjola <juha.yrjola@solidboot.com>,
       Tony Lindgren <tony@atomide.com>
Subject: [PATCH 8/18] ARM: OMAP: Add mailbox support for IVA
Date: Mon,  9 Apr 2007 17:22:13 -0400
Message-Id: <11761537743905-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <1176153771729-git-send-email-tony@atomide.com>
References: <11761537431635-git-send-email-tony@atomide.com> <117615374683-git-send-email-tony@atomide.com> <11761537491968-git-send-email-tony@atomide.com> <11761537522665-git-send-email-tony@atomide.com> <11761537563620-git-send-email-tony@atomide.com> <11761537613625-git-send-email-tony@atomide.com> <11761537672719-git-send-email-tony@atomide.com> <1176153771729-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>

This patch adds a generic mailbox interface for for DSP and IVA
(Image Video Accelerator). This patch itself doesn't contain
any IVA driver.

Signed-off-by: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
Signed-off-by: Juha Yrjola <juha.yrjola@solidboot.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap1/mailbox.c       |  206 ++++++++++++++++++++
 arch/arm/mach-omap2/mailbox.c       |  310 ++++++++++++++++++++++++++++++
 arch/arm/plat-omap/mailbox.c        |  352 +++++++++++++++++++++++++++++++++++
 arch/arm/plat-omap/mailbox.h        |  193 +++++++++++++++++++
 include/asm-arm/arch-omap/mailbox.h |   68 +++++++
 5 files changed, 1129 insertions(+), 0 deletions(-)

--- /dev/null
+++ b/arch/arm/mach-omap1/mailbox.c
@@ -0,0 +1,206 @@
+/*
+ * Mailbox reservation modules for DSP
+ *
+ * Copyright (C) 2006 Nokia Corporation
+ * Written by: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/resource.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <asm/arch/mailbox.h>
+#include <asm/arch/irqs.h>
+#include <asm/io.h>
+
+#define MAILBOX_ARM2DSP1		0x00
+#define MAILBOX_ARM2DSP1b		0x04
+#define MAILBOX_DSP2ARM1		0x08
+#define MAILBOX_DSP2ARM1b		0x0c
+#define MAILBOX_DSP2ARM2		0x10
+#define MAILBOX_DSP2ARM2b		0x14
+#define MAILBOX_ARM2DSP1_Flag		0x18
+#define MAILBOX_DSP2ARM1_Flag		0x1c
+#define MAILBOX_DSP2ARM2_Flag		0x20
+
+unsigned long mbox_base;
+
+struct omap_mbox1_fifo {
+	unsigned long cmd;
+	unsigned long data;
+	unsigned long flag;
+};
+
+struct omap_mbox1_priv {
+	struct omap_mbox1_fifo tx_fifo;
+	struct omap_mbox1_fifo rx_fifo;
+};
+
+static inline int mbox_read_reg(unsigned int reg)
+{
+	return __raw_readw(mbox_base + reg);
+}
+
+static inline void mbox_write_reg(unsigned int val, unsigned int reg)
+{
+	__raw_writew(val, mbox_base + reg);
+}
+
+/* msg */
+static inline mbox_msg_t omap1_mbox_fifo_read(struct omap_mbox *mbox)
+{
+	struct omap_mbox1_fifo *fifo =
+		&((struct omap_mbox1_priv *)mbox->priv)->rx_fifo;
+	mbox_msg_t msg;
+
+	msg = mbox_read_reg(fifo->data);
+	msg |= ((mbox_msg_t) mbox_read_reg(fifo->cmd)) << 16;
+
+	return msg;
+}
+
+static inline void
+omap1_mbox_fifo_write(struct omap_mbox *mbox, mbox_msg_t msg)
+{
+	struct omap_mbox1_fifo *fifo =
+		&((struct omap_mbox1_priv *)mbox->priv)->tx_fifo;
+
+	mbox_write_reg(msg & 0xffff, fifo->data);
+	mbox_write_reg(msg >> 16, fifo->cmd);
+}
+
+static inline int omap1_mbox_fifo_empty(struct omap_mbox *mbox)
+{
+	return 0;
+}
+
+static inline int omap1_mbox_fifo_full(struct omap_mbox *mbox)
+{
+	struct omap_mbox1_fifo *fifo =
+		&((struct omap_mbox1_priv *)mbox->priv)->rx_fifo;
+
+	return (mbox_read_reg(fifo->flag));
+}
+
+/* irq */
+static inline void
+omap1_mbox_enable_irq(struct omap_mbox *mbox, omap_mbox_type_t irq)
+{
+	if (irq == IRQ_RX)
+		enable_irq(mbox->irq);
+}
+
+static inline void
+omap1_mbox_disable_irq(struct omap_mbox *mbox, omap_mbox_type_t irq)
+{
+	if (irq == IRQ_RX)
+		disable_irq(mbox->irq);
+}
+
+static inline int
+omap1_mbox_is_irq(struct omap_mbox *mbox, omap_mbox_type_t irq)
+{
+	if (irq == IRQ_TX)
+		return 0;
+	return 1;
+}
+
+struct omap_mbox_ops omap1_mbox_ops = {
+	.type = OMAP_MBOX_TYPE1,
+	.fifo_read = omap1_mbox_fifo_read,
+	.fifo_write = omap1_mbox_fifo_write,
+	.fifo_empty = omap1_mbox_fifo_empty,
+	.fifo_full = omap1_mbox_fifo_full,
+	.enable_irq = omap1_mbox_enable_irq,
+	.disable_irq = omap1_mbox_disable_irq,
+	.is_irq = omap1_mbox_is_irq,
+};
+
+/* FIXME: the following struct should be created automatically by the user id  */
+
+/* DSP */
+static struct omap_mbox1_priv omap1_mbox_dsp_priv = {
+	.tx_fifo = {
+		.cmd  = MAILBOX_ARM2DSP1b,
+		.data =	MAILBOX_ARM2DSP1,
+		.flag =	MAILBOX_ARM2DSP1_Flag,
+	},
+	.rx_fifo = {
+		.cmd  = MAILBOX_DSP2ARM1b,
+		.data =	MAILBOX_DSP2ARM1,
+		.flag =	MAILBOX_DSP2ARM1_Flag,
+	},
+};
+
+struct omap_mbox mbox_dsp_info = {
+	.name = "dsp",
+	.ops  = &omap1_mbox_ops,
+	.priv = &omap1_mbox_dsp_priv,
+};
+EXPORT_SYMBOL(mbox_dsp_info);
+
+static int __init omap1_mbox_probe(struct platform_device *pdev)
+{
+	struct resource *res;
+	int ret = 0;
+
+	if (pdev->num_resources != 2) {
+		dev_err(&pdev->dev, "invalid number of resources: %d\n",
+			pdev->num_resources);
+		return -ENODEV;
+	}
+
+	/* MBOX base */
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (unlikely(!res)) {
+		dev_err(&pdev->dev, "invalid mem resource\n");
+		return -ENODEV;
+	}
+	mbox_base = res->start;
+
+	/* DSP IRQ */
+	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (unlikely(!res)) {
+		dev_err(&pdev->dev, "invalid irq resource\n");
+		return -ENODEV;
+	}
+	mbox_dsp_info.irq = res->start;
+
+	ret = omap_mbox_register(&mbox_dsp_info);
+
+	return ret;
+}
+
+static int omap1_mbox_remove(struct platform_device *pdev)
+{
+	omap_mbox_unregister(&mbox_dsp_info);
+
+	return 0;
+}
+
+static struct platform_driver omap1_mbox_driver = {
+	.probe	= omap1_mbox_probe,
+	.remove = omap1_mbox_remove,
+	.driver = {
+		.name = "mailbox",
+	},
+};
+
+static int __init omap1_mbox_init(void)
+{
+	return platform_driver_register(&omap1_mbox_driver);
+}
+
+static void __exit omap1_mbox_exit(void)
+{
+	platform_driver_unregister(&omap1_mbox_driver);
+}
+
+module_init(omap1_mbox_init);
+module_exit(omap1_mbox_exit);
+
+MODULE_LICENSE("GPL");
--- /dev/null
+++ b/arch/arm/mach-omap2/mailbox.c
@@ -0,0 +1,310 @@
+/*
+ * Mailbox reservation modules for OMAP2
+ *
+ * Copyright (C) 2006 Nokia Corporation
+ * Written by: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
+ *        and  Paul Mundt <paul.mundt@nokia.com>
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/clk.h>
+#include <linux/err.h>
+#include <linux/platform_device.h>
+#include <asm/arch/mailbox.h>
+#include <asm/arch/irqs.h>
+#include <asm/io.h>
+
+#define MAILBOX_REVISION		0x00
+#define MAILBOX_SYSCONFIG		0x10
+#define MAILBOX_SYSSTATUS		0x14
+#define MAILBOX_MESSAGE_0		0x40
+#define MAILBOX_MESSAGE_1		0x44
+#define MAILBOX_MESSAGE_2		0x48
+#define MAILBOX_MESSAGE_3		0x4c
+#define MAILBOX_MESSAGE_4		0x50
+#define MAILBOX_MESSAGE_5		0x54
+#define MAILBOX_FIFOSTATUS_0		0x80
+#define MAILBOX_FIFOSTATUS_1		0x84
+#define MAILBOX_FIFOSTATUS_2		0x88
+#define MAILBOX_FIFOSTATUS_3		0x8c
+#define MAILBOX_FIFOSTATUS_4		0x90
+#define MAILBOX_FIFOSTATUS_5		0x94
+#define MAILBOX_MSGSTATUS_0		0xc0
+#define MAILBOX_MSGSTATUS_1		0xc4
+#define MAILBOX_MSGSTATUS_2		0xc8
+#define MAILBOX_MSGSTATUS_3		0xcc
+#define MAILBOX_MSGSTATUS_4		0xd0
+#define MAILBOX_MSGSTATUS_5		0xd4
+#define MAILBOX_IRQSTATUS_0		0x100
+#define MAILBOX_IRQENABLE_0		0x104
+#define MAILBOX_IRQSTATUS_1		0x108
+#define MAILBOX_IRQENABLE_1		0x10c
+#define MAILBOX_IRQSTATUS_2		0x110
+#define MAILBOX_IRQENABLE_2		0x114
+#define MAILBOX_IRQSTATUS_3		0x118
+#define MAILBOX_IRQENABLE_3		0x11c
+
+unsigned long mbox_base;
+
+#define MAILBOX_IRQ_NOTFULL(n)		(1 << (2 * (n) + 1))
+#define MAILBOX_IRQ_NEWMSG(n)		(1 << (2 * (n)))
+
+struct omap_mbox2_fifo {
+	unsigned long msg;
+	unsigned long fifo_stat;
+	unsigned long msg_stat;
+};
+
+struct omap_mbox2_priv {
+	struct omap_mbox2_fifo tx_fifo;
+	struct omap_mbox2_fifo rx_fifo;
+	unsigned long irqenable;
+	unsigned long irqstatus;
+	u32 newmsg_bit;
+	u32 notfull_bit;
+};
+
+struct clk *mbox_ick_handle;
+
+static inline unsigned int mbox_read_reg(unsigned int reg)
+{
+	return __raw_readl(mbox_base + reg);
+}
+
+static inline void mbox_write_reg(unsigned int val, unsigned int reg)
+{
+	__raw_writel(val, mbox_base + reg);
+}
+
+/* Mailbox H/W preparations */
+static inline int omap2_mbox_startup(struct omap_mbox *mbox)
+{
+	unsigned int l;
+
+	mbox_ick_handle = clk_get(NULL, "mailboxes_ick");
+	if (IS_ERR(mbox_ick_handle)) {
+		printk("Could not get mailboxes_ick\n");
+		return -ENODEV;
+	}
+	clk_enable(mbox_ick_handle);
+
+	/* set smart-idle & autoidle */
+	l = mbox_read_reg(MAILBOX_SYSCONFIG);
+	l |= 0x00000011;
+	mbox_write_reg(l, MAILBOX_SYSCONFIG);
+
+	return 0;
+}
+
+static inline void omap2_mbox_shutdown(struct omap_mbox *mbox)
+{
+	clk_disable(mbox_ick_handle);
+	clk_put(mbox_ick_handle);
+}
+
+/* Mailbox FIFO handle functions */
+static inline mbox_msg_t omap2_mbox_fifo_read(struct omap_mbox *mbox)
+{
+	struct omap_mbox2_fifo *fifo = &((struct omap_mbox2_priv *)mbox->priv)->rx_fifo;
+	return (mbox_msg_t) mbox_read_reg(fifo->msg);
+}
+
+static inline void omap2_mbox_fifo_write(struct omap_mbox *mbox, mbox_msg_t msg)
+{
+	struct omap_mbox2_fifo *fifo = &((struct omap_mbox2_priv *)mbox->priv)->tx_fifo;
+	mbox_write_reg(msg, fifo->msg);
+}
+
+static inline int omap2_mbox_fifo_empty(struct omap_mbox *mbox)
+{
+	struct omap_mbox2_fifo *fifo = &((struct omap_mbox2_priv *)mbox->priv)->rx_fifo;
+	return (mbox_read_reg(fifo->msg_stat) == 0);
+}
+
+static inline int omap2_mbox_fifo_full(struct omap_mbox *mbox)
+{
+	struct omap_mbox2_fifo *fifo = &((struct omap_mbox2_priv *)mbox->priv)->tx_fifo;
+	return (mbox_read_reg(fifo->fifo_stat));
+}
+
+/* Mailbox IRQ handle functions */
+static inline void omap2_mbox_enable_irq(struct omap_mbox *mbox, omap_mbox_type_t irq)
+{
+	struct omap_mbox2_priv *p = (struct omap_mbox2_priv *)mbox->priv;
+	u32 l, bit = (irq == IRQ_TX) ? p->notfull_bit : p->newmsg_bit;
+
+	l = mbox_read_reg(p->irqenable);
+	l |= bit;
+	mbox_write_reg(l, p->irqenable);
+}
+
+static inline void omap2_mbox_disable_irq(struct omap_mbox *mbox, omap_mbox_type_t irq)
+{
+	struct omap_mbox2_priv *p = (struct omap_mbox2_priv *)mbox->priv;
+	u32 l, bit = (irq == IRQ_TX) ? p->notfull_bit : p->newmsg_bit;
+
+	l = mbox_read_reg(p->irqenable);
+	l &= ~bit;
+	mbox_write_reg(l, p->irqenable);
+}
+
+static inline void omap2_mbox_ack_irq(struct omap_mbox *mbox, omap_mbox_type_t irq)
+{
+	struct omap_mbox2_priv *p = (struct omap_mbox2_priv *)mbox->priv;
+	u32 bit = (irq == IRQ_TX) ? p->notfull_bit : p->newmsg_bit;
+
+	mbox_write_reg(bit, p->irqstatus);
+}
+
+static inline int omap2_mbox_is_irq(struct omap_mbox *mbox, omap_mbox_type_t irq)
+{
+	struct omap_mbox2_priv *p = (struct omap_mbox2_priv *)mbox->priv;
+	u32 bit = (irq == IRQ_TX) ? p->notfull_bit : p->newmsg_bit;
+	u32 enable = mbox_read_reg(p->irqenable);
+	u32 status = mbox_read_reg(p->irqstatus);
+
+	return (enable & status & bit);
+}
+
+struct omap_mbox_ops omap2_mbox_ops = {
+	.type = OMAP_MBOX_TYPE2,
+	.startup = omap2_mbox_startup,
+	.shutdown = omap2_mbox_shutdown,
+	.fifo_read = omap2_mbox_fifo_read,
+	.fifo_write = omap2_mbox_fifo_write,
+	.fifo_empty = omap2_mbox_fifo_empty,
+	.fifo_full = omap2_mbox_fifo_full,
+	.enable_irq = omap2_mbox_enable_irq,
+	.disable_irq = omap2_mbox_disable_irq,
+	.ack_irq = omap2_mbox_ack_irq,
+	.is_irq = omap2_mbox_is_irq,
+};
+
+/*
+ * MAILBOX 0: ARM -> DSP,
+ * MAILBOX 1: ARM <- DSP.
+ * MAILBOX 2: ARM -> IVA,
+ * MAILBOX 3: ARM <- IVA.
+ */
+
+/* FIXME: the following structs should be filled automatically by the user id */
+
+/* DSP */
+static struct omap_mbox2_priv omap2_mbox_dsp_priv = {
+	.tx_fifo = {
+		.msg = MAILBOX_MESSAGE_0,
+		.fifo_stat = MAILBOX_FIFOSTATUS_0,
+	},
+	.rx_fifo = {
+		.msg = MAILBOX_MESSAGE_1,
+		.msg_stat = MAILBOX_MSGSTATUS_1,
+	},
+	.irqenable = MAILBOX_IRQENABLE_0,
+	.irqstatus = MAILBOX_IRQSTATUS_0,
+	.notfull_bit = MAILBOX_IRQ_NOTFULL(0),
+	.newmsg_bit = MAILBOX_IRQ_NEWMSG(1),
+};
+
+struct omap_mbox mbox_dsp_info = {
+	.name = "dsp",
+	.ops = &omap2_mbox_ops,
+	.priv = &omap2_mbox_dsp_priv,
+};
+EXPORT_SYMBOL(mbox_dsp_info);
+
+/* IVA */
+static struct omap_mbox2_priv omap2_mbox_iva_priv = {
+	.tx_fifo = {
+		.msg = MAILBOX_MESSAGE_2,
+		.fifo_stat = MAILBOX_FIFOSTATUS_2,
+	},
+	.rx_fifo = {
+		.msg = MAILBOX_MESSAGE_3,
+		.msg_stat = MAILBOX_MSGSTATUS_3,
+	},
+	.irqenable = MAILBOX_IRQENABLE_3,
+	.irqstatus = MAILBOX_IRQSTATUS_3,
+	.notfull_bit = MAILBOX_IRQ_NOTFULL(2),
+	.newmsg_bit = MAILBOX_IRQ_NEWMSG(3),
+};
+
+static struct omap_mbox mbox_iva_info = {
+	.name = "iva",
+	.ops = &omap2_mbox_ops,
+	.priv = &omap2_mbox_iva_priv,
+};
+
+static int __init omap2_mbox_probe(struct platform_device *pdev)
+{
+	struct resource *res;
+	int ret = 0;
+
+	if (pdev->num_resources != 3) {
+		dev_err(&pdev->dev, "invalid number of resources: %d\n",
+			pdev->num_resources);
+		return -ENODEV;
+	}
+
+	/* MBOX base */
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (unlikely(!res)) {
+		dev_err(&pdev->dev, "invalid mem resource\n");
+		return -ENODEV;
+	}
+	mbox_base = res->start;
+
+	/* DSP IRQ */
+	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (unlikely(!res)) {
+		dev_err(&pdev->dev, "invalid irq resource\n");
+		return -ENODEV;
+	}
+	mbox_dsp_info.irq = res->start;
+
+	ret = omap_mbox_register(&mbox_dsp_info);
+
+	/* IVA IRQ */
+	res = platform_get_resource(pdev, IORESOURCE_IRQ, 1);
+	if (unlikely(!res)) {
+		dev_err(&pdev->dev, "invalid irq resource\n");
+		return -ENODEV;
+	}
+	mbox_iva_info.irq = res->start;
+
+	ret = omap_mbox_register(&mbox_iva_info);
+
+	return ret;
+}
+
+static int omap2_mbox_remove(struct platform_device *pdev)
+{
+	omap_mbox_unregister(&mbox_dsp_info);
+	return 0;
+}
+
+static struct platform_driver omap2_mbox_driver = {
+	.probe = omap2_mbox_probe,
+	.remove = omap2_mbox_remove,
+	.driver = {
+		.name = "mailbox",
+	},
+};
+
+int __init omap2_mbox_init(void)
+{
+	return platform_driver_register(&omap2_mbox_driver);
+}
+
+static void __exit omap2_mbox_exit(void)
+{
+	platform_driver_unregister(&omap2_mbox_driver);
+}
+
+module_init(omap2_mbox_init);
+module_exit(omap2_mbox_exit);
+
+MODULE_LICENSE("GPL");
--- /dev/null
+++ b/arch/arm/plat-omap/mailbox.c
@@ -0,0 +1,352 @@
+/*
+ * OMAP mailbox driver
+ *
+ * Copyright (C) 2006 Nokia Corporation. All rights reserved.
+ *
+ * Contact: Toshihiro Kobayashi <toshihiro.kobayashi@nokia.com>
+ *		Restructured by Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/interrupt.h>
+#include <linux/device.h>
+#include <linux/err.h>
+#include <linux/delay.h>
+#include <asm/io.h>
+#include <asm/arch/mailbox.h>
+#include "mailbox.h"
+
+static struct omap_mbox *mboxes;
+static DEFINE_RWLOCK(mboxes_lock);
+
+static struct omap_mbox **find_mboxes(const char *name)
+{
+	struct omap_mbox **p;
+
+	for (p = &mboxes; *p; p = &(*p)->next) {
+		if (strcmp((*p)->name, name) == 0)
+			break;
+	}
+
+	return p;
+}
+
+struct omap_mbox *omap_mbox_get(const char *name)
+{
+	struct omap_mbox *mbox;
+
+	read_lock(&mboxes_lock);
+	mbox = *(find_mboxes(name));
+	read_unlock(&mboxes_lock);
+
+	return mbox;
+}
+EXPORT_SYMBOL(omap_mbox_get);
+
+/* Mailbox Sequence Bit function */
+void omap_mbox_init_seq(struct omap_mbox *mbox)
+{
+	mbox_seq_init(mbox);
+}
+EXPORT_SYMBOL(omap_mbox_init_seq);
+
+/*
+ * message sender
+ */
+int omap_mbox_msg_send(struct omap_mbox *mbox, mbox_msg_t msg, void* arg)
+{
+	int ret;
+	int i = 1000;
+	static DEFINE_MUTEX(msg_send_lock);
+
+	while (mbox_fifo_full(mbox)) {
+		if (mbox->ops->type == OMAP_MBOX_TYPE2) {
+			enable_mbox_irq(mbox, IRQ_TX);
+			wait_event_interruptible(mbox->tx_waitq,
+						 !mbox_fifo_full(mbox));
+		} else
+			udelay(1);
+
+		if (--i == 0)
+			return -1;
+	}
+
+
+	mutex_lock(&msg_send_lock);
+
+	if (mbox->msg_sender_cb && arg) {
+		ret = mbox->msg_sender_cb(arg);
+		if (ret)
+			goto out;
+	}
+
+	mbox_seq_toggle(mbox, &msg);
+	mbox_fifo_write(mbox, msg);
+ out:
+	mutex_unlock(&msg_send_lock);
+
+	return 0;
+}
+EXPORT_SYMBOL(omap_mbox_msg_send);
+
+/*
+ * Message receiver(workqueue)
+ */
+static void mbox_msg_receiver(void *p)
+{
+	struct omap_mbox *mbox = (struct omap_mbox *)p;
+	struct omap_mbq *mbq = mbox->mbq;
+	mbox_msg_t msg;
+	int was_full;
+
+	while (!mbq_empty(mbq)) {
+		was_full = mbq_full(mbq);
+		msg = mbq_get(mbq);
+		if (was_full)	/* now we have a room in the mbq. */
+			enable_mbox_irq(mbox, IRQ_RX);
+
+		if (unlikely(mbox_seq_test(mbox, msg))) {
+			printk(KERN_ERR
+			       "mbox: illegal seq bit! ignoring this command. "
+			       "(%08x)\n", msg);
+			continue;
+		}
+
+		if (likely(mbox->msg_receive_cb))
+			mbox->msg_receive_cb(msg);
+	}
+}
+
+/*
+ * Mailbox interrupt handler
+ */
+static irqreturn_t mbox_interrupt(int irq, void *p)
+{
+	mbox_msg_t msg;
+	struct omap_mbox *mbox = (struct omap_mbox *)p;
+
+	if (is_mbox_irq(mbox, IRQ_TX)) {
+		disable_mbox_irq(mbox, IRQ_TX);
+		/*
+		 * NOTE: this doesn't seeem to work as explained in the manual.
+		 * IRQSTATUS:NOTFULL can't be cleared even we write 1 to that bit.
+		 * It is always set when it's not full, regardless of IRQENABLE setting.
+		 */
+		ack_mbox_irq(mbox, IRQ_TX);
+		wake_up_interruptible_all(&mbox->tx_waitq);
+	}
+
+	if (!is_mbox_irq(mbox, IRQ_RX))
+		return IRQ_HANDLED;
+
+	while (!mbox_fifo_empty(mbox)) {
+		msg = mbox_fifo_read(mbox);
+		if (mbq_add(mbox->mbq, msg)) {	/* mbq full */
+			disable_mbox_irq(mbox, IRQ_RX);
+			goto flush_queue;
+		}
+		if (mbox->ops->type == OMAP_MBOX_TYPE1)
+			break;
+	}
+
+	/* no more messages in the fifo. clear IRQ source. */
+	ack_mbox_irq(mbox, IRQ_RX);
+ flush_queue:
+	schedule_work(&mbox->msg_receive);
+
+	return IRQ_HANDLED;
+}
+
+/*
+ * sysfs files
+ */
+static ssize_t mbox_attr_write(struct class_device *dev, const char *buf,
+			      size_t count)
+{
+	int ret;
+	mbox_msg_t msg;
+	struct omap_mbox *mbox = class_get_devdata(dev);
+
+	msg = (mbox_msg_t) simple_strtoul(buf, NULL, 16);
+
+	ret = omap_mbox_msg_send(mbox, msg, NULL);
+	if (ret)
+		return -1;
+
+	return count;
+}
+
+static ssize_t mbox_attr_read(struct class_device *dev, char *buf)
+{
+	struct omap_mbox *mbox = class_get_devdata(dev);
+
+	return sprintf(buf, mbox->name);
+}
+
+static CLASS_DEVICE_ATTR(mbox, S_IALLUGO, mbox_attr_read, mbox_attr_write);
+
+static ssize_t mbox_show(struct class *class, char *buf)
+{
+	return sprintf(buf, "mbox");
+}
+
+static CLASS_ATTR(mbox, S_IRUGO, mbox_show, NULL);
+
+static struct class omap_mbox_class = {
+	.name = "mbox",
+};
+
+static int omap_mbox_init(struct omap_mbox *mbox)
+{
+	int ret;
+
+	if (likely(mbox->ops->startup)) {
+		ret = mbox->ops->startup(mbox);
+		if (unlikely(ret))
+			return ret;
+	}
+
+	mbox->class_dev.class = &omap_mbox_class;
+	strlcpy(mbox->class_dev.class_id, mbox->name, KOBJ_NAME_LEN);
+	class_set_devdata(&mbox->class_dev, mbox);
+
+	ret = class_device_register(&mbox->class_dev);
+	if (unlikely(ret))
+		return ret;
+
+	ret = class_device_create_file(&mbox->class_dev, &class_device_attr_mbox);
+	if (unlikely(ret)) {
+		printk(KERN_ERR
+		       "class_device_create_file failed: %d\n", ret);
+		goto fail1;
+	}
+
+	spin_lock_init(&mbox->lock);
+	INIT_WORK(&mbox->msg_receive, mbox_msg_receiver, mbox);
+	init_waitqueue_head(&mbox->tx_waitq);
+
+	ret = mbq_init(&mbox->mbq);
+	if (unlikely(ret))
+		goto fail2;
+
+	ret = request_irq(mbox->irq, mbox_interrupt, SA_INTERRUPT,
+			  mbox->name, mbox);
+	if (unlikely(ret)) {
+		printk(KERN_ERR
+		       "failed to register mailbox interrupt:%d\n", ret);
+		goto fail3;
+	}
+	disable_mbox_irq(mbox, IRQ_RX);
+	enable_mbox_irq(mbox, IRQ_RX);
+
+	return 0;
+
+ fail3:
+	kfree(mbox->mbq);
+ fail2:
+	class_remove_file(&omap_mbox_class, &class_attr_mbox);
+ fail1:
+	class_unregister(&omap_mbox_class);
+	if (unlikely(mbox->ops->shutdown))
+		mbox->ops->shutdown(mbox);
+
+	return ret;
+}
+
+static void omap_mbox_shutdown(struct omap_mbox *mbox)
+{
+	free_irq(mbox->irq, mbox);
+	kfree(mbox->mbq);
+	class_remove_file(&omap_mbox_class, &class_attr_mbox);
+	class_unregister(&omap_mbox_class);
+
+	if (unlikely(mbox->ops->shutdown))
+		mbox->ops->shutdown(mbox);
+}
+
+int omap_mbox_register(struct omap_mbox *mbox)
+{
+	int ret = 0;
+	struct omap_mbox **tmp;
+
+	if (!mbox)
+		return -EINVAL;
+	if (mbox->next)
+		return -EBUSY;
+
+	ret = omap_mbox_init(mbox);
+	if (ret)
+		return ret;
+
+	write_lock(&mboxes_lock);
+	tmp = find_mboxes(mbox->name);
+	if (*tmp)
+		ret = -EBUSY;
+	else
+		*tmp = mbox;
+	write_unlock(&mboxes_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL(omap_mbox_register);
+
+int omap_mbox_unregister(struct omap_mbox *mbox)
+{
+	struct omap_mbox **tmp;
+
+	write_lock(&mboxes_lock);
+	tmp = &mboxes;
+	while (*tmp) {
+		if (mbox == *tmp) {
+			*tmp = mbox->next;
+			mbox->next = NULL;
+			write_unlock(&mboxes_lock);
+
+			omap_mbox_shutdown(mbox);
+
+			return 0;
+		}
+		tmp = &(*tmp)->next;
+	}
+	write_unlock(&mboxes_lock);
+
+	return -EINVAL;
+}
+EXPORT_SYMBOL(omap_mbox_unregister);
+
+static int __init omap_mbox_class_init(void)
+{
+	int ret = class_register(&omap_mbox_class);
+	if (!ret)
+		ret = class_create_file(&omap_mbox_class, &class_attr_mbox);
+
+	return ret;
+}
+
+static void __exit omap_mbox_class_exit(void)
+{
+	class_remove_file(&omap_mbox_class, &class_attr_mbox);
+	class_unregister(&omap_mbox_class);
+}
+
+subsys_initcall(omap_mbox_class_init);
+module_exit(omap_mbox_class_exit);
+
+MODULE_LICENSE("GPL");
--- /dev/null
+++ b/arch/arm/plat-omap/mailbox.h
@@ -0,0 +1,193 @@
+/*
+ * Mailbox internal functions
+ *
+ * Copyright (C) 2006 Nokia Corporation
+ * Written by: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef __ARCH_ARM_PLAT_MAILBOX_H
+#define __ARCH_ARM_PLAT_MAILBOX_H
+
+/*
+ * Mailbox queue handling API
+ */
+
+#define MBQ_DEPTH	16
+struct omap_mbq {
+	rwlock_t lock;
+	mbox_msg_t msg[MBQ_DEPTH];
+	mbox_msg_t *rp, *wp;
+	int cnt;
+};
+
+static inline int mbq_init(struct omap_mbq **addr)
+{
+	struct omap_mbq *m = kmalloc(sizeof(struct omap_mbq), GFP_KERNEL);
+	if (!m)
+		return -ENOMEM;
+
+	rwlock_init(&m->lock);
+
+	write_lock_irq(&m->lock);
+	m->rp = m->wp = &m->msg[0];
+	m->cnt = 0;
+	write_unlock_irq(&m->lock);
+
+	*addr = m;
+
+	return 0;
+}
+
+static inline int mbq_empty(struct omap_mbq *mbq)
+{
+	int ret;
+
+	read_lock_irq(&mbq->lock);
+	ret = (mbq->cnt == 0);
+	read_unlock_irq(&mbq->lock);
+
+	return ret;
+}
+
+static inline int mbq_full(struct omap_mbq *mbq)
+{
+	int ret;
+
+	read_lock_irq(&mbq->lock);
+	ret = (mbq->cnt == MBQ_DEPTH);
+	read_unlock_irq(&mbq->lock);
+
+	return ret;
+}
+
+static inline int mbq_add(struct omap_mbq *mbq, mbox_msg_t msg)
+{
+	int ret = 0;
+
+	write_lock_irq(&mbq->lock);
+
+	*mbq->wp = msg;
+	if (++mbq->wp == &mbq->msg[MBQ_DEPTH])
+		mbq->wp = &mbq->msg[0];
+
+	if (++mbq->cnt == MBQ_DEPTH)	/* full */
+		ret = -1;
+
+	write_unlock_irq(&mbq->lock);
+
+	return ret;
+}
+
+static inline mbox_msg_t mbq_get(struct omap_mbq *mbq)
+{
+	mbox_msg_t msg;
+
+	write_lock_irq(&mbq->lock);
+
+	msg = *mbq->rp;
+
+	if (++mbq->rp == &mbq->msg[MBQ_DEPTH])
+		mbq->rp = &mbq->msg[0];
+	mbq->cnt--;
+
+	write_unlock_irq(&mbq->lock);
+
+	return msg;
+}
+
+static inline void mbq_exit(struct omap_mbq **addr)
+{
+	if (*addr)
+		kfree(*addr);
+}
+
+/*
+ * Mailbox sequence bit API
+ */
+#if defined(CONFIG_ARCH_OMAP1)
+#  define MBOX_USE_SEQ_BIT
+#elif defined(CONFIG_ARCH_OMAP2)
+#  define MBOX_USE_SEQ_BIT
+#endif
+
+#ifdef MBOX_USE_SEQ_BIT
+/* seq_rcv should be initialized with any value other than
+ * 0 and 1 << 31, to allow either value for the first
+ * message.  */
+static inline void mbox_seq_init(struct omap_mbox *mbox)
+{
+	/* any value other than 0 and 1 << 31 */
+	mbox->seq_rcv = 0xffffffff;
+}
+
+static inline void mbox_seq_toggle(struct omap_mbox *mbox, mbox_msg_t * msg)
+{
+	/* add seq_snd to msg */
+	*msg = (*msg & 0x7fffffff) | mbox->seq_snd;
+	/* flip seq_snd */
+	mbox->seq_snd ^= 1 << 31;
+}
+
+static inline int mbox_seq_test(struct omap_mbox *mbox, mbox_msg_t msg)
+{
+	mbox_msg_t seq = msg & (1 << 31);
+	if (seq == mbox->seq_rcv)
+		return -1;
+	mbox->seq_rcv = seq;
+	return 0;
+}
+#else
+static inline void mbox_seq_init(struct omap_mbox *mbox)
+{
+}
+static inline void mbox_seq_toggle(struct omap_mbox *mbox, mbox_msg_t * msg)
+{
+}
+static inline int mbox_seq_test(struct omap_mbox *mbox, mbox_msg_t msg)
+{
+	return 0;
+}
+#endif
+
+/* Mailbox FIFO handle functions */
+static inline mbox_msg_t mbox_fifo_read(struct omap_mbox *mbox)
+{
+	return mbox->ops->fifo_read(mbox);
+}
+static inline void mbox_fifo_write(struct omap_mbox *mbox, mbox_msg_t msg)
+{
+	mbox->ops->fifo_write(mbox, msg);
+}
+static inline int mbox_fifo_empty(struct omap_mbox *mbox)
+{
+	return mbox->ops->fifo_empty(mbox);
+}
+static inline int mbox_fifo_full(struct omap_mbox *mbox)
+{
+	return mbox->ops->fifo_full(mbox);
+}
+
+/* Mailbox IRQ handle functions */
+static inline void enable_mbox_irq(struct omap_mbox *mbox, omap_mbox_irq_t irq)
+{
+	mbox->ops->enable_irq(mbox, irq);
+}
+static inline void disable_mbox_irq(struct omap_mbox *mbox, omap_mbox_irq_t irq)
+{
+	mbox->ops->disable_irq(mbox, irq);
+}
+static inline void ack_mbox_irq(struct omap_mbox *mbox, omap_mbox_irq_t irq)
+{
+	if (mbox->ops->ack_irq)
+		mbox->ops->ack_irq(mbox, irq);
+}
+static inline int is_mbox_irq(struct omap_mbox *mbox, omap_mbox_irq_t irq)
+{
+	return mbox->ops->is_irq(mbox, irq);
+}
+
+#endif				/* __ARCH_ARM_PLAT_MAILBOX_H */
--- /dev/null
+++ b/include/asm-arm/arch-omap/mailbox.h
@@ -0,0 +1,68 @@
+/* mailbox.h */
+
+#ifndef MAILBOX_H
+#define MAILBOX_H
+
+#include <linux/wait.h>
+#include <linux/workqueue.h>
+
+typedef u32 mbox_msg_t;
+typedef void (mbox_receiver_t)(mbox_msg_t msg);
+struct omap_mbox;
+struct omap_mbq;
+
+typedef int __bitwise omap_mbox_irq_t;
+#define IRQ_TX ((__force omap_mbox_irq_t) 1)
+#define IRQ_RX ((__force omap_mbox_irq_t) 2)
+
+typedef int __bitwise omap_mbox_type_t;
+#define OMAP_MBOX_TYPE1 ((__force omap_mbox_type_t) 1)
+#define OMAP_MBOX_TYPE2 ((__force omap_mbox_type_t) 2)
+
+struct omap_mbox_ops {
+	omap_mbox_type_t	type;
+	int (*startup)(struct omap_mbox *mbox);
+	void (*shutdown)(struct omap_mbox *mbox);
+	/* fifo */
+	mbox_msg_t (*fifo_read)(struct omap_mbox *mbox);
+	void (*fifo_write)(struct omap_mbox *mbox, mbox_msg_t msg);
+	int (*fifo_empty)(struct omap_mbox *mbox);
+	int (*fifo_full)(struct omap_mbox *mbox);
+	/* irq */
+	void (*enable_irq)(struct omap_mbox *mbox, omap_mbox_irq_t irq);
+	void (*disable_irq)(struct omap_mbox *mbox, omap_mbox_irq_t irq);
+	void (*ack_irq)(struct omap_mbox *mbox, omap_mbox_irq_t irq);
+	int (*is_irq)(struct omap_mbox *mbox, omap_mbox_irq_t irq);
+};
+
+struct omap_mbox {
+	char *name;
+	spinlock_t lock;
+	unsigned int irq;
+	struct omap_mbox_ops *ops;
+
+	wait_queue_head_t tx_waitq;
+
+	struct work_struct msg_receive;
+	void (*msg_receive_cb)(mbox_msg_t);
+	struct omap_mbq *mbq;
+
+	int (*msg_sender_cb)(void*);
+
+	mbox_msg_t seq_snd, seq_rcv;
+
+	struct class_device class_dev;
+
+	void *priv;
+
+	struct omap_mbox *next;
+};
+
+int omap_mbox_msg_send(struct omap_mbox *mbox_h, mbox_msg_t msg, void* arg);
+void omap_mbox_init_seq(struct omap_mbox *mbox);
+
+struct omap_mbox *omap_mbox_get(const char *name);
+int omap_mbox_register(struct omap_mbox *mbox);
+int omap_mbox_unregister(struct omap_mbox *mbox);
+
+#endif /* MAILBOX_H */
-- 
1.4.4.2

