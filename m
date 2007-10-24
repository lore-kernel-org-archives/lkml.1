Return-Path: <linux-kernel-owner+w=401wt.eu-S1757473AbXJXTcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757473AbXJXTcc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 15:32:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754079AbXJXTcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 15:32:22 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:38198 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754075AbXJXTcU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 15:32:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=DTcJOoJQ+i0Kh0zcMo8lbuKGPC4S5FiXSzAZpVlxMqbakGDGYfKLseFHYmoEl7EKYnxn09Lf0Wc+KJ/Ap+LfpP3plm9g1nr+uBlkJWC8/T/uRGsH2QAWjgNXQ4ugtQN/my/ykCgUa2czWCPnWXtJfX2qr37quynTqHV/tXvLL90=
From: Miguel =?iso-8859-1?q?Bot=F3n?= <mboton.lkml@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] b44: power down PHY when interface down
Date: Wed, 24 Oct 2007 20:31:52 +0200
User-Agent: KMail/1.9.7
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200710242031.52610.mboton.lkml@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is just http://lkml.org/lkml/2007/7/1/51 but adapted to b44 ssb driver.

I couldn't test it as I don't have a b44 ethernet device.


diff -ruN linux-2.6.23.orig/drivers/net/b44.c linux-2.6.23/drivers/net/b44.c
--- linux-2.6.23.orig/drivers/net/b44.c	2007-10-24 19:02:33.000000000 +0200
+++ linux-2.6.23/drivers/net/b44.c	2007-10-24 19:50:46.000000000 +0200
@@ -113,6 +113,8 @@ static void b44_init_rings(struct b44 *);
 #define B44_FULL_RESET		1
 #define B44_FULL_RESET_SKIP_PHY	2
 #define B44_PARTIAL_RESET	3
+#define B44_CHIP_RESET_FULL     4
+#define B44_CHIP_RESET_PARTIAL  5

 static void b44_init_hw(struct b44 *, int);

@@ -1283,7 +1285,7 @@ static void b44_clear_stats(struct b44 *bp)
 }

 /* bp->lock is held. */
-static void b44_chip_reset(struct b44 *bp)
+static void b44_chip_reset(struct b44 *bp, int reset_kind)
 {
 	if (ssb_is_core_up(bp)) {
 		bw32(bp, B44_RCV_LAZY, 0);
@@ -1307,6 +1309,13 @@ static void b44_chip_reset(struct b44 *bp)
 	ssb_device_enable(bp->sdev, 0);
 	b44_clear_stats(bp);

+	/*
+	 * Don't enable PHY if we are doing a partial reset
+	 * we are probably going to power down
+	 */
+	if (reset_kind == B44_CHIP_RESET_PARTIAL)
+		return;
+
 	switch (sdev->bus->bustype) {
 	case SSB_BUSTYPE_SSB:
 		bw32(bp, B44_MDIO_CTRL, (MDIO_CTRL_PREAMBLE |
@@ -1332,7 +1341,14 @@ static void b44_chip_reset(struct b44 *bp)
 static void b44_halt(struct b44 *bp)
 {
 	b44_disable_ints(bp);
-	b44_chip_reset(bp);
+	/* reset PHY */
+	b44_phy_reset(bp);
+	/* power down PHY */
+	printk(KERN_INFO PFX "%s: powering down PHY\n", bp->dev->name);
+	bw32(bp, B44_MAC_CTRL, MAC_CTRL_PHY_PDOWN);
+	/* now reset the chip, but without enabling the MAC&PHY
+	 * part of it. This has to be done _after_ we shut down the PHY */
+	b44_chip_reset(bp, B44_CHIP_RESET_PARTIAL);
 }

 /* bp->lock is held. */
@@ -1376,7 +1392,7 @@ static void b44_init_hw(struct b44 *bp, int reset_kind)
 {
 	u32 val;

-	b44_chip_reset(bp);
+	b44_chip_reset(bp, B44_CHIP_RESET_FULL);
 	if (reset_kind == B44_FULL_RESET) {
 		b44_phy_reset(bp);
 		b44_setup_phy(bp);
@@ -1430,7 +1446,7 @@ static int b44_open(struct net_device *dev)

 	err = request_irq(dev->irq, b44_interrupt, IRQF_SHARED, dev->name, dev);
 	if (unlikely(err < 0)) {
-		b44_chip_reset(bp);
+		b44_chip_reset(bp, B44_CHIP_RESET_PARTIAL);
 		b44_free_rings(bp);
 		b44_free_consistent(bp);
 		goto out;
@@ -2250,7 +2266,7 @@ static int __devinit b44_init_one(struct pci_dev *pdev,
 	/* Chip reset provides power to the b44 MAC & PCI cores, which
 	 * is necessary for MAC register access.
 	 */
-	b44_chip_reset(bp);
+	b44_chip_reset(bp, B44_CHIP_RESET_FULL);

 	printk(KERN_INFO "%s: Broadcom 4400 10/100BaseT Ethernet ", dev->name);
 	for (i = 0; i < 6; i++)
@@ -2284,4 +2300,5 @@ static void __devexit b44_remove_one(struct ssb_dev 
*sdev)
 	free_netdev(dev);
+	ssb_pci_set_power_state(sdev, PCI_D3hot);
 	ssb_set_drvdata(sdev, NULL);
 }

@@ -2312,6 +2329,7 @@ static int b44_suspend(struct ssb_dev *sdev, 
pm_message_t state)
 		b44_setup_wol(bp);
 	}
 
+	ssb_pci_set_power_state(sdev, PCI_D3hot);
 	return 0;
 }



-- 
	Miguel Botón
