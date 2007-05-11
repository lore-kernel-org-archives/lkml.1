Return-Path: <linux-kernel-owner+w=401wt.eu-S1760955AbXEKGuF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760955AbXEKGuF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 02:50:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752694AbXEKGt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 02:49:57 -0400
Received: from pythia.bakeyournoodle.com ([203.82.209.197]:59650 "EHLO
	pythia.bakeyournoodle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856AbXEKGt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 02:49:56 -0400
Date: Fri, 11 May 2007 16:49:54 +1000
To: Linux Kernel ML <linux-kernel@vger.kernel.org>
Cc: Tejun Heo <htejun@gmail.com>, Akira Iguchi <akira2.iguchi@toshiba.co.jp>,
       Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
       cbe-oss-dev@ozlabs.org
Subject: [PATCH/RFC] Fix build failure for drivers/ata/pata_scc.c
Message-ID: <20070511064954.GE15955@bakeyournoodle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
From: tony@bakeyournoodle.com (Tony Breeds)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The commit d4b2bab4f26345ea1803feb23ea92fbe3f6b77bc added deadline support to
prereset and reset methods to libbata the pata_scc driver wasn't converted.
This patch is a naive attempt to bring this driver up to scratch.

Build failures are:
drivers/ata/pata_scc.c: In function 'scc_pata_prereset':
drivers/ata/pata_scc.c:870: error: too few arguments to function 'ata_std_prereset'
drivers/ata/pata_scc.c: In function 'scc_error_handler':
drivers/ata/pata_scc.c:916: warning: passing argument 2 of 'ata_bmdma_drive_eh' from incompatible pointer type
drivers/ata/pata_scc.c:916: warning: passing argument 3 of 'ata_bmdma_drive_eh' from incompatible pointer type
drivers/ata/pata_scc.c: In function 'scc_pata_prereset':
drivers/ata/pata_scc.c:871: warning: control reaches end of non-void function

On a releated note scc_bus_post_reset() is (AFACT) identical to
ata_bus_post_reset(), would a patch to make ata_bus_post_reset() assesable to
drivers be accepted?


Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>
CC: Tejun Heo <htejun@gmail.com>
CC: Akira Iguchi <akira2.iguchi@toshiba.co.jp>
CC: Jeff Garzik <jgarzik@pobox.com>
CC: linux-ide@vger.kernel.org
---

 drivers/ata/pata_scc.c |   48 ++++++++++++++++++++++++-----------------
 1 file changed, 29 insertions(+), 19 deletions(-)

Index: working/drivers/ata/pata_scc.c
===================================================================
--- working.orig/drivers/ata/pata_scc.c
+++ working/drivers/ata/pata_scc.c
@@ -489,23 +489,26 @@ static unsigned int scc_devchk (struct a
  *	Note: Original code is ata_bus_post_reset().
  */
 
-static void scc_bus_post_reset (struct ata_port *ap, unsigned int devmask)
+static int scc_bus_post_reset(struct ata_port *ap, unsigned int devmask,
+                              unsigned long deadline)
 {
 	struct ata_ioports *ioaddr = &ap->ioaddr;
 	unsigned int dev0 = devmask & (1 << 0);
 	unsigned int dev1 = devmask & (1 << 1);
-	unsigned long timeout;
+	int rc;
 
 	/* if device 0 was found in ata_devchk, wait for its
 	 * BSY bit to clear
 	 */
-	if (dev0)
-		ata_busy_sleep(ap, ATA_TMOUT_BOOT_QUICK, ATA_TMOUT_BOOT);
+	if (dev0) {
+		rc = ata_wait_ready(ap, deadline);
+		if (rc && rc != -ENODEV)
+			return rc;
+	}
 
 	/* if device 1 was found in ata_devchk, wait for
 	 * register access, then wait for BSY to clear
 	 */
-	timeout = jiffies + ATA_TMOUT_BOOT;
 	while (dev1) {
 		u8 nsect, lbal;
 
@@ -514,14 +517,15 @@ static void scc_bus_post_reset (struct a
 		lbal = in_be32(ioaddr->lbal_addr);
 		if ((nsect == 1) && (lbal == 1))
 			break;
-		if (time_after(jiffies, timeout)) {
-			dev1 = 0;
-			break;
-		}
+		if (time_after(jiffies, deadline))
+			return -EBUSY;
 		msleep(50);	/* give drive a breather */
 	}
-	if (dev1)
-		ata_busy_sleep(ap, ATA_TMOUT_BOOT_QUICK, ATA_TMOUT_BOOT);
+	if (dev1) {
+		rc = ata_wait_ready(ap, deadline);
+		if (rc && rc != -ENODEV)
+			return rc;
+	}
 
 	/* is all this really necessary? */
 	ap->ops->dev_select(ap, 0);
@@ -529,6 +533,8 @@ static void scc_bus_post_reset (struct a
 		ap->ops->dev_select(ap, 1);
 	if (dev0)
 		ap->ops->dev_select(ap, 0);
+
+	return 0;
 }
 
 /**
@@ -537,8 +543,8 @@ static void scc_bus_post_reset (struct a
  *	Note: Original code is ata_bus_softreset().
  */
 
-static unsigned int scc_bus_softreset (struct ata_port *ap,
-				       unsigned int devmask)
+static unsigned int scc_bus_softreset(struct ata_port *ap, unsigned int devmask,
+                                      unsigned long deadline)
 {
 	struct ata_ioports *ioaddr = &ap->ioaddr;
 
@@ -570,7 +576,7 @@ static unsigned int scc_bus_softreset (s
 	if (scc_check_status(ap) == 0xFF)
 		return 0;
 
-	scc_bus_post_reset(ap, devmask);
+	scc_bus_post_reset(ap, devmask, deadline);
 
 	return 0;
 }
@@ -579,11 +585,13 @@ static unsigned int scc_bus_softreset (s
  *	scc_std_softreset - reset host port via ATA SRST
  *	@ap: port to reset
  *	@classes: resulting classes of attached devices
+ *	@deadline: deadline jiffies for the operation
  *
  *	Note: Original code is ata_std_softreset().
  */
 
-static int scc_std_softreset (struct ata_port *ap, unsigned int *classes)
+static int scc_std_softreset (struct ata_port *ap, unsigned int *classes,
+                              unsigned long deadline)
 {
 	unsigned int slave_possible = ap->flags & ATA_FLAG_SLAVE_POSS;
 	unsigned int devmask = 0, err_mask;
@@ -607,7 +615,7 @@ static int scc_std_softreset (struct ata
 
 	/* issue bus reset */
 	DPRINTK("about to softreset, devmask=%x\n", devmask);
-	err_mask = scc_bus_softreset(ap, devmask);
+	err_mask = scc_bus_softreset(ap, devmask, deadline);
 	if (err_mask) {
 		ata_port_printk(ap, KERN_ERR, "SRST failed (err_mask=0x%x)\n",
 				err_mask);
@@ -676,10 +684,11 @@ static void scc_bmdma_stop (struct ata_q
 
 		if (reg & INTSTS_BMSINT) {
 			unsigned int classes;
+			unsigned long deadline = jiffies + ATA_TMOUT_BOOT;
 			printk(KERN_WARNING "%s: Internal Bus Error\n", DRV_NAME);
 			out_be32(bmid_base + SCC_DMA_INTST, INTSTS_BMSINT);
 			/* TBD: SW reset */
-			scc_std_softreset(ap, &classes);
+			scc_std_softreset(ap, &classes, deadline);
 			continue;
 		}
 
@@ -862,12 +871,13 @@ static void scc_bmdma_freeze (struct ata
 /**
  *	scc_pata_prereset - prepare for reset
  *	@ap: ATA port to be reset
+ *	@deadline: deadline jiffies for the operation
  */
 
-static int scc_pata_prereset (struct ata_port *ap)
+static int scc_pata_prereset (struct ata_port *ap, unsigned long deadline)
 {
 	ap->cbl = ATA_CBL_PATA80;
-	return ata_std_prereset(ap);
+	return ata_std_prereset(ap, deadline);
 }
 
 /**
Yours Tony

  linux.conf.au        http://linux.conf.au/ || http://lca2008.linux.org.au/
  Jan 28 - Feb 02 2008 The Australian Linux Technical Conference!

