Return-Path: <linux-kernel-owner+w=401wt.eu-S1752945AbZKTLoB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945AbZKTLoB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 06:44:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752824AbZKTLoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 06:44:00 -0500
Received: from havoc.gtf.org ([69.61.125.42]:46769 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752015AbZKTLn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 06:43:59 -0500
Date: Fri, 20 Nov 2009 06:44:05 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patch] libata fix
Message-ID: <20091120114404.GA23315@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A fix for a platform driver that was a bit overdue, and needs
to be in 2.6.32.


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/sata_fsl.c |   84 +++++++++++++++++++++++++-----------------------
 1 files changed, 44 insertions(+), 40 deletions(-)

    sata_fsl: Split hard and soft reset
    
    Split sata_fsl_softreset() into hard and soft resets to make
    error-handling more efficient & device and PMP detection more
    reliable.
    
    Also includes fix for PMP support, driver tested with Sil3726,
    Sil4726 & Exar PMP controllers.
    
    [AV: Also fixes resuming from deep sleep on MPC8315 CPUs]
    
    Signed-off-by: Jiang Yutang <b14898@freescale.com>
    Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
    Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

diff --git a/drivers/ata/sata_fsl.c b/drivers/ata/sata_fsl.c
index d344db4..172b57e 100644
--- a/drivers/ata/sata_fsl.c
+++ b/drivers/ata/sata_fsl.c
@@ -707,34 +707,17 @@ static unsigned int sata_fsl_dev_classify(struct ata_port *ap)
 	return ata_dev_classify(&tf);
 }
 
-static int sata_fsl_prereset(struct ata_link *link, unsigned long deadline)
-{
-	/* FIXME: Never skip softreset, sata_fsl_softreset() is
-	 * combination of soft and hard resets.  sata_fsl_softreset()
-	 * needs to be splitted into soft and hard resets.
-	 */
-	return 0;
-}
-
-static int sata_fsl_softreset(struct ata_link *link, unsigned int *class,
+static int sata_fsl_hardreset(struct ata_link *link, unsigned int *class,
 					unsigned long deadline)
 {
 	struct ata_port *ap = link->ap;
-	struct sata_fsl_port_priv *pp = ap->private_data;
 	struct sata_fsl_host_priv *host_priv = ap->host->private_data;
 	void __iomem *hcr_base = host_priv->hcr_base;
-	int pmp = sata_srst_pmp(link);
 	u32 temp;
-	struct ata_taskfile tf;
-	u8 *cfis;
-	u32 Serror;
 	int i = 0;
 	unsigned long start_jiffies;
 
-	DPRINTK("in xx_softreset\n");
-
-	if (pmp != SATA_PMP_CTRL_PORT)
-		goto issue_srst;
+	DPRINTK("in xx_hardreset\n");
 
 try_offline_again:
 	/*
@@ -749,7 +732,7 @@ try_offline_again:
 
 	if (temp & ONLINE) {
 		ata_port_printk(ap, KERN_ERR,
-				"Softreset failed, not off-lined %d\n", i);
+				"Hardreset failed, not off-lined %d\n", i);
 
 		/*
 		 * Try to offline controller atleast twice
@@ -761,7 +744,7 @@ try_offline_again:
 			goto try_offline_again;
 	}
 
-	DPRINTK("softreset, controller off-lined\n");
+	DPRINTK("hardreset, controller off-lined\n");
 	VPRINTK("HStatus = 0x%x\n", ioread32(hcr_base + HSTATUS));
 	VPRINTK("HControl = 0x%x\n", ioread32(hcr_base + HCONTROL));
 
@@ -786,11 +769,11 @@ try_offline_again:
 
 	if (!(temp & ONLINE)) {
 		ata_port_printk(ap, KERN_ERR,
-				"Softreset failed, not on-lined\n");
+				"Hardreset failed, not on-lined\n");
 		goto err;
 	}
 
-	DPRINTK("softreset, controller off-lined & on-lined\n");
+	DPRINTK("hardreset, controller off-lined & on-lined\n");
 	VPRINTK("HStatus = 0x%x\n", ioread32(hcr_base + HSTATUS));
 	VPRINTK("HControl = 0x%x\n", ioread32(hcr_base + HCONTROL));
 
@@ -806,7 +789,7 @@ try_offline_again:
 				"No Device OR PHYRDY change,Hstatus = 0x%x\n",
 				ioread32(hcr_base + HSTATUS));
 		*class = ATA_DEV_NONE;
-		goto out;
+		return 0;
 	}
 
 	/*
@@ -819,11 +802,44 @@ try_offline_again:
 	if ((temp & 0xFF) != 0x18) {
 		ata_port_printk(ap, KERN_WARNING, "No Signature Update\n");
 		*class = ATA_DEV_NONE;
-		goto out;
+		goto do_followup_srst;
 	} else {
 		ata_port_printk(ap, KERN_INFO,
 				"Signature Update detected @ %d msecs\n",
 				jiffies_to_msecs(jiffies - start_jiffies));
+		*class = sata_fsl_dev_classify(ap);
+		return 0;
+	}
+
+do_followup_srst:
+	/*
+	 * request libATA to perform follow-up softreset
+	 */
+	return -EAGAIN;
+
+err:
+	return -EIO;
+}
+
+static int sata_fsl_softreset(struct ata_link *link, unsigned int *class,
+					unsigned long deadline)
+{
+	struct ata_port *ap = link->ap;
+	struct sata_fsl_port_priv *pp = ap->private_data;
+	struct sata_fsl_host_priv *host_priv = ap->host->private_data;
+	void __iomem *hcr_base = host_priv->hcr_base;
+	int pmp = sata_srst_pmp(link);
+	u32 temp;
+	struct ata_taskfile tf;
+	u8 *cfis;
+	u32 Serror;
+
+	DPRINTK("in xx_softreset\n");
+
+	if (ata_link_offline(link)) {
+		DPRINTK("PHY reports no device\n");
+		*class = ATA_DEV_NONE;
+		return 0;
 	}
 
 	/*
@@ -834,7 +850,6 @@ try_offline_again:
 	 * reached here, we can send a command to the target device
 	 */
 
-issue_srst:
 	DPRINTK("Sending SRST/device reset\n");
 
 	ata_tf_init(link->device, &tf);
@@ -860,6 +875,8 @@ issue_srst:
 		ioread32(CA + hcr_base), ioread32(CC + hcr_base));
 
 	iowrite32(0xFFFF, CC + hcr_base);
+	if (pmp != SATA_PMP_CTRL_PORT)
+		iowrite32(pmp, CQPMP + hcr_base);
 	iowrite32(1, CQ + hcr_base);
 
 	temp = ata_wait_register(CQ + hcr_base, 0x1, 0x1, 1, 5000);
@@ -926,7 +943,6 @@ issue_srst:
 		VPRINTK("cereg = 0x%x\n", ioread32(hcr_base + CE));
 	}
 
-out:
 	return 0;
 
 err:
@@ -988,18 +1004,6 @@ static void sata_fsl_error_intr(struct ata_port *ap)
 		ehi->err_mask |= AC_ERR_ATA_BUS;
 		ehi->action |= ATA_EH_SOFTRESET;
 
-		/*
-		 * Ignore serror in case of fatal errors as we always want
-		 * to do a soft-reset of the FSL SATA controller. Analyzing
-		 * serror may cause libata to schedule a hard-reset action,
-		 * and hard-reset currently does not do controller
-		 * offline/online, causing command timeouts and leads to an
-		 * un-recoverable state, hence make libATA ignore
-		 * autopsy in case of fatal errors.
-		 */
-
-		ehi->flags |= ATA_EHI_NO_AUTOPSY;
-
 		freeze = 1;
 	}
 
@@ -1267,8 +1271,8 @@ static struct ata_port_operations sata_fsl_ops = {
 
 	.freeze = sata_fsl_freeze,
 	.thaw = sata_fsl_thaw,
-	.prereset = sata_fsl_prereset,
 	.softreset = sata_fsl_softreset,
+	.hardreset = sata_fsl_hardreset,
 	.pmp_softreset = sata_fsl_softreset,
 	.error_handler = sata_fsl_error_handler,
 	.post_internal_cmd = sata_fsl_post_internal_cmd,
