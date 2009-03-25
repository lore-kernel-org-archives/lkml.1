Return-Path: <linux-kernel-owner+w=401wt.eu-S1759981AbZCYKtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759981AbZCYKtW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 06:49:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756273AbZCYKsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 06:48:19 -0400
Received: from mx1.emlix.com ([193.175.82.87]:34895 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754704AbZCYKsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 06:48:16 -0400
From: Oskar Schirmer <os@emlix.com>
To: Chris Zankel <chris@zankel.net>
Cc: linux-kernel@vger.kernel.org, linux-xtensa@linux-xtensa.org,
       Oskar Schirmer <os@emlix.com>
Subject: [patch 3/4] xtensa: s6000 isef driver
Date: Wed, 25 Mar 2009 11:49:17 +0100
Message-Id: <1237978158-23603-3-git-send-email-os@emlix.com>
In-Reply-To: <1237978158-23603-1-git-send-email-os@emlix.com>
References: <1237978158-23603-1-git-send-email-os@emlix.com>
Organization: emlix gmbh, Goettingen, Germany"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Think of the ISEF as a freely programmable coprocessor, with its ALU
replaced by an FPGA.

This driver allows providing multiple functionality bitstreams to the
engine and enables explicit and implicit use through special coprocessor
opcodes.

Signed-off-by: Oskar Schirmer <os@emlix.com>
---
 arch/xtensa/variants/s6000/Makefile |    2 +-
 arch/xtensa/variants/s6000/isef.c   |  444 +++++++++++++++++++++++++++++++++++
 2 files changed, 445 insertions(+), 1 deletions(-)
 create mode 100644 arch/xtensa/variants/s6000/isef.c

diff --git a/arch/xtensa/variants/s6000/Makefile b/arch/xtensa/variants/s6000/Makefile
index ddfa415..5f1429d 100644
--- a/arch/xtensa/variants/s6000/Makefile
+++ b/arch/xtensa/variants/s6000/Makefile
@@ -1,3 +1,3 @@
 # s6000 Makefile
 
-obj-y		+= irq.o gpio.o dmac.o
+obj-y		+= irq.o gpio.o dmac.o isef.o
diff --git a/arch/xtensa/variants/s6000/isef.c b/arch/xtensa/variants/s6000/isef.c
new file mode 100644
index 0000000..a034ba3
--- /dev/null
+++ b/arch/xtensa/variants/s6000/isef.c
@@ -0,0 +1,444 @@
+/*
+ * Copyright (C) 2006 Tensilica Inc.
+ * (c) 2008 emlix GmbH http://www.emlix.com
+ * Author:	Oskar Schirmer <os@emlix.com>
+ *		Daniel Gloeckner <dg@emlix.com>
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/interrupt.h>
+#include <linux/types.h>
+#include <linux/errno.h>
+#include <linux/spinlock.h>
+#include <linux/wait.h>
+#include <linux/sched.h>
+#include <linux/cdev.h>
+#include <linux/poll.h>
+#include <linux/uaccess.h>
+#include <linux/miscdevice.h>
+#include <linux/platform_device.h>
+#include <asm/regs.h>
+#include <variant/dmac.h>
+#include <platform/ioctl.h>
+
+#define S6_ISEF_IRAM128		0x00000
+#define S6_ISEF_EFICTRL		0x60000
+#define S6_ISEF_CFGBITS		0x70000
+
+#define S6_ISEF_EFICTRL_STATUS	0x020
+#define S6_ISEF_EFICTRL_IRAMENA	0x028
+
+#define S6_ISEF_CFG_NB		127
+#define S6_ISEF_IOP_NB		16
+#define S6_ISEF_NAME_SIZE	64
+#define S6_ISEF_IRAM_SIZE	(1 << 16)
+#define S6_ISEF_BITS_SIZE	(1 << 16)
+#define S6_ISEF_IRAM_ALIGN	128
+#define S6_ISEF_BITS_ALIGN	64
+
+#define S6_XLMI_CLOCKRATIO	0x010
+#define S6_XLMI_CONFIG		0x200
+
+#define S6_ISEF_XADCFG_CLOCKR	35
+#define S6_ISEF_XADCFG_HEX	36
+#define S6_ISEF_XADCFG_SIZE	37
+
+struct s6_isef_config {
+	u32 len;
+	u32 hashval;
+	u32 resetdelay;
+	u8 *iram;
+	u8 *bits;
+	u32 iops;
+	u32 xadcfg[S6_ISEF_XADCFG_SIZE];
+};
+
+
+/* original cfgdata format */
+
+#define S6_ISEFCFG_LEN		0
+#define S6_ISEFCFG_HASHVAL	1
+#define S6_ISEFCFG_XADCFG	2
+#define S6_ISEFCFG_RESETDELAY	39
+#define S6_ISEFCFG_IRAMDATA	40
+#define S6_ISEFCFG_CFGBITS	48
+
+
+static struct {
+	struct s6_isef_config *cur;
+	char loading;
+	char chan;
+	char opens;
+	char irq;
+	spinlock_t lock;
+	wait_queue_head_t wait;
+	u32 dma;
+	u32 efi;
+	u32 xlmi;
+	struct s6_isef_config *cfg[S6_ISEF_CFG_NB][S6_ISEF_IOP_NB];
+} isef;
+
+
+static inline void s6_isef_loadhex_sync(u32 hex)
+{
+	asm volatile(
+	"	loadhex %0 ;"
+	"	isync ;"
+	: : "a"(hex));
+}
+
+static inline void s6_isef_invalhex_sync(void)
+{
+	asm volatile(
+	"	isef_sync ;"
+	"	invalhex ;"
+	"	isync ;"
+	);
+}
+
+static inline int eval_hex_iop(struct s6_isef_config *cfg)
+{
+	if (!cfg)
+		return -1;
+	return cfg->xadcfg[S6_ISEF_XADCFG_HEX] * S6_ISEF_IOP_NB
+		+ ffs(cfg->iops) - 1;
+}
+
+static inline void drop_cfg(struct s6_isef_config **cfg, int iop)
+{
+	struct s6_isef_config *c = *cfg;
+	if (c) {
+		c->iops &= ~(1 << iop);
+		if (!c->iops)
+			kfree(c);
+		*cfg = 0;
+	}
+}
+
+static inline void add_cfg(struct s6_isef_config *cfg, int hex, int iop)
+{
+	struct s6_isef_config **l = &isef.cfg[hex][iop];
+	drop_cfg(l, iop);
+	*l = cfg;
+	cfg->iops |= (1 << iop);
+}
+
+static void isef_start_load(struct s6_isef_config *cfg)
+{
+	int i;
+	s6_isef_invalhex_sync();
+	s6dmac_put_fifo_cache(isef.dma, isef.chan,
+			(u32)cfg->bits, isef.efi + S6_ISEF_CFGBITS, cfg->len);
+	isef.cur = cfg;
+	isef.loading = 1;
+	if (cfg->iram) {
+		writel(~0,
+			isef.efi + S6_ISEF_EFICTRL + S6_ISEF_EFICTRL_IRAMENA);
+		s6dmac_put_fifo_cache(isef.dma, isef.chan, (u32)cfg->iram,
+			isef.efi + S6_ISEF_IRAM128, S6_ISEF_IRAM_SIZE);
+	}
+	writel(cfg->xadcfg[S6_ISEF_XADCFG_CLOCKR],
+		isef.xlmi + S6_XLMI_CLOCKRATIO);
+	for (i = 0; i < S6_ISEF_XADCFG_CLOCKR; i++)
+		writel(cfg->xadcfg[i], isef.xlmi + S6_XLMI_CONFIG + 4*i);
+}
+
+static void isef_finish_load(struct s6_isef_config *cfg)
+{
+	static const u32 efi_reset_value[4] __attribute__ ((aligned(16))) =
+			{63, 0, 0, 7 << 28};
+	u32 saved[4] __attribute__ ((aligned(16)));
+	u32 addr = isef.efi + S6_ISEF_CFGBITS;
+	u32 status;
+	asm volatile(
+	"	xsr %3, CPENABLE     ;"
+	"	wras128i wra0, %0, 0 ;"
+	"	wral128i wra0, %1, 0 ;"
+	"	wras128i wra0, %2, 0 ;"
+	"	wral128i wra0, %0, 0 ;"
+	"	wsr %3, CPENABLE     ;"
+	: : "a"(&saved[0]),
+		"a"(&efi_reset_value[0]),
+		"a"(addr),
+		"a"(1 << XCHAL_CP_ID_XAD));
+	s6_isef_loadhex_sync(cfg->xadcfg[S6_ISEF_XADCFG_HEX]);
+	status = readl(isef.efi + S6_ISEF_EFICTRL + S6_ISEF_EFICTRL_STATUS);
+	if ((status & 0x0f) || (((status >> 5) & 0x3) == 3)) {
+		printk(KERN_ERR "s6 isef load: EFI error\n");
+		BUG();
+	}
+	isef.loading = 0;
+}
+
+void s6_isef_autoload(struct pt_regs *regs, unsigned long exccause)
+{
+	u8 *pc = (u8 *)regs->pc;
+	u32 hex, iop;
+	struct s6_isef_config *cfg;
+	hex = ((pc[4] << 8) | pc[3]) >> 4;
+	iop = (hex >> 7) & 0xf;
+	hex &= 0x7f;
+	cfg = isef.cfg[hex][iop];
+#if 0
+	printk(KERN_ERR "AUTOLOAD PC=%08lx EXCC=%08lx IOP/HEX=%1x/%02x "
+		"OPC=%02x%02x%02x%02x%02x%02x%02x%02x\n",
+		regs->pc, exccause, iop, hex,
+		pc[7], pc[6], pc[5], pc[4], pc[3], pc[2], pc[1], pc[0]);
+#endif
+	if (!cfg) {
+		printk(KERN_ERR "s6 autoload: no config found (%1x/%02x)\n",
+			iop, hex);
+		BUG();
+	}
+	if (cfg != isef.cur) {
+		while (s6dmac_pending_count(isef.dma, isef.chan))
+			;
+		isef_start_load(cfg);
+	}
+	while (s6dmac_pending_count(isef.dma, isef.chan))
+		;
+	isef_finish_load(cfg);
+	wake_up_interruptible(&isef.wait);
+}
+
+static irqreturn_t s6isef_interrupt(int irq, void *dev_id)
+{
+	spin_lock(&isef.lock);
+	if (s6dmac_pendcnt_irq(isef.dma, isef.chan) &&
+			!s6dmac_pending_count(isef.dma, isef.chan)) {
+		if (isef.loading)
+			isef_finish_load(isef.cur);
+		wake_up_interruptible(&isef.wait);
+	}
+	spin_unlock(&isef.lock);
+	return IRQ_HANDLED;
+}
+
+static void user_start_load(struct s6_isef_config *cfg, u32 arg)
+{
+	unsigned long flags;
+	spin_lock_irqsave(&isef.lock, flags);
+	while (s6dmac_pending_count(isef.dma, isef.chan)) {
+		spin_unlock_irqrestore(&isef.lock, flags);
+		schedule();
+		spin_lock_irqsave(&isef.lock, flags);
+	}
+	if (arg != eval_hex_iop(isef.cur))
+		isef_start_load(cfg);
+	spin_unlock_irqrestore(&isef.lock, flags);
+}
+
+static void user_finish_load(struct s6_isef_config *cfg, u32 arg)
+{
+	unsigned long flags;
+	spin_lock_irqsave(&isef.lock, flags);
+	while (s6dmac_pending_count(isef.dma, isef.chan)) {
+		spin_unlock_irqrestore(&isef.lock, flags);
+		schedule();
+		spin_lock_irqsave(&isef.lock, flags);
+	}
+	if (isef.loading && (arg == eval_hex_iop(isef.cur)))
+		isef_finish_load(cfg);
+	spin_unlock_irqrestore(&isef.lock, flags);
+	wake_up_interruptible(&isef.wait);
+}
+
+static ssize_t s6isef_write(struct file *filp, const char __user *buf,
+		size_t count, loff_t *ppos)
+{
+	unsigned long flags;
+	u32 hex, iop;
+	struct s6_isef_config *cfg;
+	u32 tmp[S6_ISEFCFG_IRAMDATA + 1];
+	if (copy_from_user(&tmp[0], buf, sizeof(tmp)))
+		return -EIO;
+	hex = tmp[S6_ISEFCFG_XADCFG + S6_ISEF_XADCFG_HEX];
+	if (hex >= S6_ISEF_CFG_NB)
+		return -EINVAL;
+	cfg = kmalloc(sizeof(struct s6_isef_config) +
+		tmp[S6_ISEFCFG_LEN] + S6_ISEF_BITS_ALIGN - 1 +
+		(tmp[S6_ISEFCFG_IRAMDATA] ?
+			S6_ISEF_IRAM_SIZE + S6_ISEF_IRAM_ALIGN - 1 : 0) +
+		S6_ISEF_XADCFG_SIZE * sizeof(u32), GFP_KERNEL);
+	if (!cfg)
+		return -ENOMEM;
+	cfg->len = tmp[S6_ISEFCFG_LEN];
+	cfg->hashval = tmp[S6_ISEFCFG_HASHVAL];
+	cfg->resetdelay = tmp[S6_ISEFCFG_RESETDELAY];
+	memcpy(cfg->xadcfg, &tmp[S6_ISEFCFG_XADCFG],
+			S6_ISEF_XADCFG_SIZE * sizeof(u32));
+	cfg->bits = (u8 *)PTR_ALIGN(cfg + 1, S6_ISEF_BITS_ALIGN);
+	copy_from_user(cfg->bits, &(((u32 *)buf)[S6_ISEFCFG_CFGBITS]),
+			tmp[S6_ISEFCFG_LEN]);
+	if (tmp[S6_ISEFCFG_IRAMDATA]) {
+		cfg->iram = PTR_ALIGN(cfg->bits + tmp[S6_ISEFCFG_LEN],
+			S6_ISEF_IRAM_ALIGN);
+		copy_from_user(cfg->iram, (void *)tmp[S6_ISEFCFG_IRAMDATA],
+			S6_ISEF_IRAM_SIZE);
+	} else {
+		cfg->iram = 0;
+	}
+	cfg->iops = 0;
+	spin_lock_irqsave(&isef.lock, flags);
+	for (iop = 0; iop < S6_ISEF_IOP_NB; iop++)
+		if (cfg->xadcfg[2*iop] & 1)
+			add_cfg(cfg, hex, iop);
+	spin_unlock_irqrestore(&isef.lock, flags);
+	return count;
+}
+
+static unsigned int s6isef_poll(struct file *filp, poll_table *wait)
+{
+	poll_wait(filp, &isef.wait, wait);
+	return isef.loading ? 0 : POLLIN | POLLRDNORM;
+}
+
+static int s6isef_ioctl(struct inode *inode, struct file *filp,
+		unsigned int cmd, unsigned long arg)
+{
+	struct s6_isef_config *cfg;
+	switch (cmd) {
+	case S6IOCTL_ISEF_PRELOAD:
+		if (arg >= S6_ISEF_CFG_NB*S6_ISEF_IOP_NB)
+			return -EINVAL;
+		cfg = isef.cfg[0][arg];
+		if (!cfg)
+			return -ENOENT;
+		if (isef.loading && (filp->f_flags & O_NONBLOCK))
+			return -EAGAIN;
+		if (arg == eval_hex_iop(isef.cur)) {
+			while (isef.loading)
+				schedule();
+			return 0;
+		}
+		user_start_load(cfg, arg);
+		if (!(filp->f_flags & O_NONBLOCK))
+			user_finish_load(cfg, arg);
+		return 0;
+	case S6IOCTL_ISEF_INVALIDATE:
+		user_finish_load(isef.cur, eval_hex_iop(isef.cur));
+		s6_isef_invalhex_sync();
+		return 0;
+	}
+	return -EINVAL;
+}
+
+static int s6isef_open(struct inode *inode, struct file *filp)
+{
+	unsigned long flags;
+	spin_lock_irqsave(&isef.lock, flags);
+	if (isef.opens) {
+		spin_unlock_irqrestore(&isef.lock, flags);
+		return -EBUSY;
+	}
+	isef.opens += 1;
+	spin_unlock_irqrestore(&isef.lock, flags);
+	filp->private_data = &isef;
+	return 0;
+}
+
+static int s6isef_release(struct inode *inode, struct file *filp)
+{
+	unsigned long flags;
+	int h, i;
+	user_finish_load(isef.cur, eval_hex_iop(isef.cur));
+	spin_lock_irqsave(&isef.lock, flags);
+	for (h = 0; h < S6_ISEF_CFG_NB; h++)
+		for (i = 0; i < S6_ISEF_IOP_NB; i++)
+			drop_cfg(&isef.cfg[h][i], i);
+	s6_isef_invalhex_sync();
+	isef.cur = 0;
+	isef.opens = 0;
+	spin_unlock_irqrestore(&isef.lock, flags);
+	return 0;
+}
+
+static const struct file_operations s6isef_fops = {
+	.owner		= THIS_MODULE,
+	.write		= s6isef_write,
+	.poll		= s6isef_poll,
+	.ioctl		= s6isef_ioctl,
+	.open		= s6isef_open,
+	.release	= s6isef_release,
+};
+
+static struct miscdevice s6isef_misc_device = {
+	.minor		= MISC_DYNAMIC_MINOR,
+	.name		= "s6isef",
+	.fops		= &s6isef_fops,
+};
+
+static int __devinit s6isef_probe(struct platform_device *pdev)
+{
+	unsigned long i;
+	int res;
+
+	spin_lock_init(&isef.lock);
+	init_waitqueue_head(&isef.wait);
+	isef.irq = platform_get_irq(pdev, 0);
+	res = request_irq(isef.irq, &s6isef_interrupt, 0, "isef",  &isef);
+	if (res) {
+		printk(KERN_ERR "isef: irq request failed: %d\n", isef.irq);
+		goto errirq;
+	}
+	i = platform_get_resource(pdev, IORESOURCE_DMA, 0)->start;
+	isef.dma = DMA_MASK_DMAC(i);
+	res = s6dmac_request_chan(isef.dma, DMA_INDEX_CHNL(i), 0,
+				-1, 1, 1, 0, 0, 0, 7, -1, 1, 0, 1);
+	if (res < 0) {
+		printk(KERN_ERR "isef: dma channel #%d not available\n", res);
+		res = -EBUSY;
+		goto errdma;
+	}
+	isef.chan = res;
+	isef.efi = platform_get_resource(pdev, IORESOURCE_MEM, 0)->start;
+	isef.xlmi = platform_get_resource(pdev, IORESOURCE_MEM, 1)->start;
+	res = misc_register(&s6isef_misc_device);
+	if (res) {
+		printk(KERN_ERR "isef: failed to register minor device\n");
+		goto errreg;
+	}
+	return 0;
+errreg:
+	s6dmac_release_chan(isef.dma, isef.chan);
+errdma:
+	free_irq(isef.irq, &isef);
+errirq:
+	return res;
+}
+
+static int __devexit s6isef_remove(struct platform_device *pdev)
+{
+	misc_deregister(&s6isef_misc_device);
+	s6dmac_release_chan(isef.dma, isef.chan);
+	free_irq(isef.irq, &isef);
+	return 0;
+}
+
+static struct platform_driver s6isef_driver = {
+	.probe = s6isef_probe,
+	.remove = __devexit_p(s6isef_remove),
+	.driver = {
+		.name = "s6isef",
+		.owner = THIS_MODULE,
+	},
+};
+
+static int __init s6isef_init(void)
+{
+	return platform_driver_register(&s6isef_driver);
+}
+
+static void __exit s6isef_exit(void)
+{
+	platform_driver_unregister(&s6isef_driver);
+}
+
+module_init(s6isef_init);
+module_exit(s6isef_exit);
-- 
1.6.2.107.ge47ee

