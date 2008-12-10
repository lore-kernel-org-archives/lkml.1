Return-Path: <linux-kernel-owner+w=401wt.eu-S1755134AbYLJLcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755134AbYLJLcs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 06:32:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753702AbYLJLcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 06:32:23 -0500
Received: from an-out-0708.google.com ([209.85.132.250]:5083 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753485AbYLJLcV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 06:32:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=BuTTMQzIYryL5ABaTHSML/c/+87BRUQDGnNpXevA8zfAmPNFSFZLmN5cT4uOBS6yAA
         wfeSxgAYF5VcWWP9hcFOVpcH/ggJTVaexQKJAl23XMzLCh7Ahj/jGdi8haujDNJRYa/d
         9Fs5ayXkOU2RUaq26HEX0viprH5XeJZBoVDnM=
Message-ID: <b0438a630812100332vc979b4uf32ccd6e61c9c89@mail.gmail.com>
Date: Wed, 10 Dec 2008 12:32:20 +0100
From: "=?ISO-8859-1?Q?Miguel_=C1ngel_=C1lvarez?=" <gotzoncabanes@gmail.com>
To: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       "Krzysztof Halasa" <khc@pm.waw.pl>, "Karl Hiramoto" <karl@hiramoto.org>
Subject: [PATCH] ixp4xx_qmgr: support 64 queues
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I have read Karl Hiramoto's patch for supporting 64 queues in
ixp4xx_qmgr, and the comments from Krzysztof Halasa.

I am not sure of some of the features implemented by Karl, but I think
that the work in supporting 64 queues is quite valuable.

I have remade the patch so that this "minimal" functionallity can be
analysed. Here it is.


diff -urN linux-2.6.26.7_hssorig/arch/arm/mach-ixp4xx/ixp4xx_qmgr.c
linux-2.6.26.7/arch/arm/mach-ixp4xx/ixp4xx_qmgr.c
--- linux-2.6.26.7_hssorig/arch/arm/mach-ixp4xx/ixp4xx_qmgr.c	2008-10-22
23:46:18.000000000 +0200
+++ linux-2.6.26.7/arch/arm/mach-ixp4xx/ixp4xx_qmgr.c	2008-12-10
11:26:28.000000000 +0100
@@ -26,13 +26,21 @@
 void qmgr_set_irq(unsigned int queue, int src,
 		  void (*handler)(void *pdev), void *pdev)
 {
-	u32 __iomem *reg = &qmgr_regs->irqsrc[queue / 8]; /* 8 queues / u32 */
-	int bit = (queue % 8) * 4; /* 3 bits + 1 reserved bit per queue */
+	u32 __iomem *reg;
+	int bit;
 	unsigned long flags;

-	src &= 7;
+	BUG_ON(queue >= HALF_QUEUES && src != QUEUE_IRQ_SRC_NOT_EMPTY);
+
 	spin_lock_irqsave(&qmgr_lock, flags);
-	__raw_writel((__raw_readl(reg) & ~(7 << bit)) | (src << bit), reg);
+
+	if (queue < HALF_QUEUES) {
+		src &= 7;
+		reg = &qmgr_regs->irqsrc[queue / 8];
+		bit = (queue % 8) * 4; /* 3 bits + 1 reserved bit per queue */	
+		__raw_writel((__raw_readl(reg) & ~(7 << bit)) | (src << bit), reg);
+	}
+
 	irq_handlers[queue] = handler;
 	irq_pdevs[queue] = pdev;
 	spin_unlock_irqrestore(&qmgr_lock, flags);
@@ -53,13 +61,31 @@
 }


+static irqreturn_t qmgr_irq2(int irq, void *pdev)
+{
+	int i;
+	u32 val = __raw_readl(&qmgr_regs->irqstat[1]);
+	__raw_writel(val, &qmgr_regs->irqstat[1]); /* ACK */
+
+	for (i = HALF_QUEUES; i < QUEUES; i++)
+		if (val & (1 << i))
+			irq_handlers[i](irq_pdevs[i]);
+
+	return val ? IRQ_HANDLED : 0;
+}
+
+
 void qmgr_enable_irq(unsigned int queue)
 {
 	unsigned long flags;

 	spin_lock_irqsave(&qmgr_lock, flags);
-	__raw_writel(__raw_readl(&qmgr_regs->irqen[0]) | (1 << queue),
-		     &qmgr_regs->irqen[0]);
+	if (queue < HALF_QUEUES)
+		__raw_writel(__raw_readl(&qmgr_regs->irqen[0]) | (1 << queue),
+			     &qmgr_regs->irqen[0]);
+	else
+		__raw_writel(__raw_readl(&qmgr_regs->irqen[1]) |
+				(1 << (queue - HALF_QUEUES)), &qmgr_regs->irqen[1]);
 	spin_unlock_irqrestore(&qmgr_lock, flags);
 }

@@ -68,8 +94,12 @@
 	unsigned long flags;

 	spin_lock_irqsave(&qmgr_lock, flags);
-	__raw_writel(__raw_readl(&qmgr_regs->irqen[0]) & ~(1 << queue),
-		     &qmgr_regs->irqen[0]);
+	if (queue < HALF_QUEUES)
+		__raw_writel(__raw_readl(&qmgr_regs->irqen[0]) & ~(1 << queue),
+			     &qmgr_regs->irqen[0]);
+	else
+		__raw_writel(__raw_readl(&qmgr_regs->irqen[1]) &
+				~(1 << (queue - HALF_QUEUES)), &qmgr_regs->irqen[1]);
 	spin_unlock_irqrestore(&qmgr_lock, flags);
 }

@@ -88,7 +118,7 @@
 	u32 cfg, addr = 0, mask[4]; /* in 16-dwords */
 	int err;

-	if (queue >= HALF_QUEUES)
+	if (queue >= QUEUES)
 		return -ERANGE;

 	if ((nearly_empty_watermark | nearly_full_watermark) & ~7)
@@ -169,7 +199,7 @@
 {
 	u32 cfg, addr, mask[4];

-	BUG_ON(queue >= HALF_QUEUES); /* not in valid range */
+	BUG_ON(queue >= QUEUES); /* not in valid range */

 	spin_lock_irq(&qmgr_lock);
 	cfg = __raw_readl(&qmgr_regs->sram[queue]);
@@ -234,20 +264,32 @@
 		__raw_writel(0, &qmgr_regs->sram[i]);

 	err = request_irq(IRQ_IXP4XX_QM1, qmgr_irq1, 0,
-			  "IXP4xx Queue Manager", NULL);
+			  "IXP4xx Queue Manager QM1", NULL);
 	if (err) {
 		printk(KERN_ERR "qmgr: failed to request IRQ%i\n",
 		       IRQ_IXP4XX_QM1);
-		goto error_irq;
+		goto error_irq1;
+	}
+
+	err = request_irq(IRQ_IXP4XX_QM2, qmgr_irq2, 0,
+			  "IXP4xx Queue Manager QM2", NULL);
+	if (err) {
+		printk(KERN_ERR "qmgr: failed to request IRQ%i\n",
+		       IRQ_IXP4XX_QM2);
+		goto error_irq2;
 	}

+
 	used_sram_bitmap[0] = 0xF; /* 4 first pages reserved for config */
 	spin_lock_init(&qmgr_lock);

 	printk(KERN_INFO "IXP4xx Queue Manager initialized.\n");
 	return 0;

-error_irq:
+error_irq2:
+	free_irq(IRQ_IXP4XX_QM1, NULL);
+	synchronize_irq(IRQ_IXP4XX_QM2);
+error_irq1:
 	iounmap(qmgr_regs);
 error_map:
 	release_mem_region(IXP4XX_QMGR_BASE_PHYS, IXP4XX_QMGR_REGION_SIZE);
@@ -257,7 +299,9 @@
 static void qmgr_remove(void)
 {
 	free_irq(IRQ_IXP4XX_QM1, NULL);
+	free_irq(IRQ_IXP4XX_QM2, NULL);
 	synchronize_irq(IRQ_IXP4XX_QM1);
+	synchronize_irq(IRQ_IXP4XX_QM2);
 	iounmap(qmgr_regs);
 	release_mem_region(IXP4XX_QMGR_BASE_PHYS, IXP4XX_QMGR_REGION_SIZE);
 }
diff -urN linux-2.6.26.7_hssorig/include/asm-arm/arch-ixp4xx/qmgr.h
linux-2.6.26.7/include/asm-arm/arch-ixp4xx/qmgr.h
--- linux-2.6.26.7_hssorig/include/asm-arm/arch-ixp4xx/qmgr.h	2008-10-22
23:46:18.000000000 +0200
+++ linux-2.6.26.7/include/asm-arm/arch-ixp4xx/qmgr.h	2008-12-10
11:31:00.000000000 +0100
@@ -1,5 +1,7 @@
 /*
  * Copyright (C) 2007 Krzysztof Halasa <khc@pm.waw.pl>
+ * Portions Copyright (C) 2008 Karl Hiramoto <karl@hiramoto.org>
+ * Portions Copyright (C) 2008 Miguel Angel Alvarez <gotzoncabanes@gmail.com>
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License
@@ -82,6 +84,7 @@
 static inline int qmgr_get_stat1(unsigned int queue)
 {
 	extern struct qmgr_regs __iomem *qmgr_regs;
+	BUG_ON(queue >= HALF_QUEUES);
 	return (__raw_readl(&qmgr_regs->stat1[queue >> 3])
 		>> ((queue & 7) << 2)) & 0xF;
 }
@@ -89,37 +92,52 @@
 static inline int qmgr_get_stat2(unsigned int queue)
 {
 	extern struct qmgr_regs __iomem *qmgr_regs;
+	BUG_ON(queue >= HALF_QUEUES);
 	return (__raw_readl(&qmgr_regs->stat2[queue >> 4])
 		>> ((queue & 0xF) << 1)) & 0x3;
 }

 static inline int qmgr_stat_empty(unsigned int queue)
 {
+	BUG_ON(queue >= HALF_QUEUES);
 	return !!(qmgr_get_stat1(queue) & QUEUE_STAT1_EMPTY);
 }

 static inline int qmgr_stat_nearly_empty(unsigned int queue)
 {
-	return !!(qmgr_get_stat1(queue) & QUEUE_STAT1_NEARLY_EMPTY);
+	extern struct qmgr_regs __iomem *qmgr_regs;
+	if (queue < HALF_QUEUES)
+		return !!(qmgr_get_stat1(queue) & QUEUE_STAT1_NEARLY_EMPTY);
+	else
+		return !!((__raw_readl(&qmgr_regs->statne_h)
+			>> (queue - HALF_QUEUES)) & 0x1);
 }

 static inline int qmgr_stat_nearly_full(unsigned int queue)
 {
+	BUG_ON(queue >= HALF_QUEUES);
 	return !!(qmgr_get_stat1(queue) & QUEUE_STAT1_NEARLY_FULL);
 }

 static inline int qmgr_stat_full(unsigned int queue)
 {
-	return !!(qmgr_get_stat1(queue) & QUEUE_STAT1_FULL);
+	extern struct qmgr_regs __iomem *qmgr_regs;
+	if (queue < HALF_QUEUES)
+		return !!(qmgr_get_stat1(queue) & QUEUE_STAT1_FULL);
+	else
+		return !!((__raw_readl(&qmgr_regs->statf_h)
+			>> (queue - HALF_QUEUES)) & 0x1);
 }

 static inline int qmgr_stat_underflow(unsigned int queue)
 {
+	BUG_ON(queue >= HALF_QUEUES);
 	return !!(qmgr_get_stat2(queue) & QUEUE_STAT2_UNDERFLOW);
 }

 static inline int qmgr_stat_overflow(unsigned int queue)
 {
+	BUG_ON(queue >= HALF_QUEUES);
 	return !!(qmgr_get_stat2(queue) & QUEUE_STAT2_OVERFLOW);
 }


I think it could be quite useful to add it to the mainstream.

Thanks

Miguel Ángel Álvarez
