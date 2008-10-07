Return-Path: <linux-kernel-owner+w=401wt.eu-S1761447AbYJGBIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761447AbYJGBIa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 21:08:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759945AbYJGBEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 21:04:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:37805 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759130AbYJGBES (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 21:04:18 -0400
Message-ID: <48EAB535.8010203@kernel.org>
Date: Tue, 07 Oct 2008 10:02:45 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: SATA Cold Boot problems on >2.6.25 with NV
References: <20080829212146.GA4321@anita> <48B90F7F.8040308@kernel.org> <48D89C85.2080104@panasas.com> <20080924084846.GA2094@anita> <48DA0A2C.8010008@kernel.org> <48E890B9.6050307@gmail.com> <48E8947A.5020608@kernel.org> <48E89839.5030307@panasas.com> <48E899F9.9040206@kernel.org> <20081006211906.GA31148@anita.doom> <20081006212307.GA881@anita.doom>
In-Reply-To: <20081006212307.GA881@anita.doom>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/mixed;
 boundary="------------030807060007090608090404"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 07 Oct 2008 01:04:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030807060007090608090404
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Konstantin Kletschke wrote:
> What I forgot is, that the 
> 
> ata2: EH pending after 5 tries, giving up
> ata2: EH complete
> ata2: EH pending after 5 tries, giving up
> ata2: EH complete
> ata2: EH complete
> ata2: EH complete
> ata2: EH complete
> ata2: EH complete
> ata2: EH complete
> ata2: EH complete
> ata2: EH complete
> ata2: EH complete
> ata2: EH complete
> 
> is away now and tomorrow morning I will take care if it 
> manages to do a cold boot after it was switched of this night.
> 

Hmm... strange.  Can you please try the attached patch?  It's basically
the same with a bit more debug information.

Thanks.

-- 
tejun

--------------030807060007090608090404
Content-Type: text/x-patch;
 name="sata_nv-nf2-hrst-debug.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sata_nv-nf2-hrst-debug.patch"

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 79e3a8e..ba71469 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -1099,6 +1099,7 @@ unsigned int ata_dev_classify(const struct ata_taskfile *tf)
 	 * We follow the current spec and consider that 0x69/0x96
 	 * identifies a port multiplier and 0x3c/0xc3 a SEMB device.
 	 */
+	printk("XXX CLASSIFY %02x:%02x:%02x\n", tf->lbal, tf->lbam, tf->lbah);
 	if ((tf->lbam == 0) && (tf->lbah == 0)) {
 		DPRINTK("found ATA device by sig\n");
 		return ATA_DEV_ATA;
@@ -5673,7 +5674,7 @@ int ata_host_register(struct ata_host *host, struct scsi_host_template *sht)
 
 			ehi->probe_mask |= ATA_ALL_DEVICES;
 			ehi->action |= ATA_EH_RESET | ATA_EH_LPM;
-			ehi->flags |= ATA_EHI_NO_AUTOPSY | ATA_EHI_QUIET;
+			ehi->flags |= ATA_EHI_NO_AUTOPSY/* | ATA_EHI_QUIET*/;
 
 			ap->pflags &= ~ATA_PFLAG_INITIALIZING;
 			ap->pflags |= ATA_PFLAG_LOADING;
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index 14601dc..ce77619 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -309,8 +309,6 @@ static void nv_nf2_freeze(struct ata_port *ap);
 static void nv_nf2_thaw(struct ata_port *ap);
 static void nv_ck804_freeze(struct ata_port *ap);
 static void nv_ck804_thaw(struct ata_port *ap);
-static int nv_hardreset(struct ata_link *link, unsigned int *class,
-			unsigned long deadline);
 static int nv_adma_slave_config(struct scsi_device *sdev);
 static int nv_adma_check_atapi_dma(struct ata_queued_cmd *qc);
 static void nv_adma_qc_prep(struct ata_queued_cmd *qc);
@@ -405,17 +403,8 @@ static struct scsi_host_template nv_swncq_sht = {
 	.slave_configure	= nv_swncq_slave_config,
 };
 
-/* OSDL bz3352 reports that some nv controllers can't determine device
- * signature reliably and nv_hardreset is implemented to work around
- * the problem.  This was reported on nf3 and it's unclear whether any
- * other controllers are affected.  However, the workaround has been
- * applied to all variants and there isn't much to gain by trying to
- * find out exactly which ones are affected at this point especially
- * because NV has moved over to ahci for newer controllers.
- */
 static struct ata_port_operations nv_common_ops = {
 	.inherits		= &ata_bmdma_port_ops,
-	.hardreset		= nv_hardreset,
 	.scr_read		= nv_scr_read,
 	.scr_write		= nv_scr_write,
 };
@@ -429,12 +418,17 @@ static struct ata_port_operations nv_generic_ops = {
 	.hardreset		= ATA_OP_NULL,
 };
 
+/* OSDL bz3352 reports that nf2/3 controllers can't determine device
+ * signature reliably.  Use sata_std_hardreset().
+ */
 static struct ata_port_operations nv_nf2_ops = {
 	.inherits		= &nv_common_ops,
 	.freeze			= nv_nf2_freeze,
 	.thaw			= nv_nf2_thaw,
+	.hardreset		= sata_std_hardreset,
 };
 
+/* CK804 finally gets hardreset right */
 static struct ata_port_operations nv_ck804_ops = {
 	.inherits		= &nv_common_ops,
 	.freeze			= nv_ck804_freeze,
@@ -443,7 +437,7 @@ static struct ata_port_operations nv_ck804_ops = {
 };
 
 static struct ata_port_operations nv_adma_ops = {
-	.inherits		= &nv_common_ops,
+	.inherits		= &nv_ck804_ops,
 
 	.check_atapi_dma	= nv_adma_check_atapi_dma,
 	.sff_tf_read		= nv_adma_tf_read,
@@ -467,7 +461,7 @@ static struct ata_port_operations nv_adma_ops = {
 };
 
 static struct ata_port_operations nv_swncq_ops = {
-	.inherits		= &nv_common_ops,
+	.inherits		= &nv_generic_ops,
 
 	.qc_defer		= ata_std_qc_defer,
 	.qc_prep		= nv_swncq_qc_prep,
@@ -1605,21 +1599,6 @@ static void nv_mcp55_thaw(struct ata_port *ap)
 	ata_sff_thaw(ap);
 }
 
-static int nv_hardreset(struct ata_link *link, unsigned int *class,
-			unsigned long deadline)
-{
-	int rc;
-
-	/* SATA hardreset fails to retrieve proper device signature on
-	 * some controllers.  Request follow up SRST.  For more info,
-	 * see http://bugzilla.kernel.org/show_bug.cgi?id=3352
-	 */
-	rc = sata_sff_hardreset(link, class, deadline);
-	if (rc)
-		return rc;
-	return -EAGAIN;
-}
-
 static void nv_adma_error_handler(struct ata_port *ap)
 {
 	struct nv_adma_port_priv *pp = ap->private_data;

--------------030807060007090608090404--
