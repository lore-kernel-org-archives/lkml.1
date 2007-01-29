Return-Path: <linux-kernel-owner+w=401wt.eu-S933032AbXA2BVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933032AbXA2BVi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 20:21:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933053AbXA2BVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 20:21:38 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:49179 "EHLO
	pd4mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933032AbXA2BVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 20:21:36 -0500
Date: Sun, 28 Jan 2007 19:20:38 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: [PATCH -mm] sata_nv: use ADMA for NODATA commands
To: linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@osdl.org>
Message-id: <45BD4BE6.3010109@shaw.ca>
MIME-version: 1.0
Content-type: multipart/mixed; boundary=------------060507030002050506000108
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060507030002050506000108
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Patch is against 2.6.20-rc6-mm1, though will also apply to 2.6.20-rc6 if 
sata_nv-cleanup-adma-error-handling-v2.patch and 
sata_nv-cleanup-adma-error-handling-v2-cleanup.patch from -mm are 
applied first. Testing from those who experienced the previous cache 
flush timeout problem, in particular, would be appreciated.

---

Some problems showed up recently with cache flush commands timing out on 
sata_nv. Previously these commands were always handled by transitioning 
to legacy mode from ADMA mode first. The timeout problem was worked 
around already by a change to the interrupt handling code for legacy 
mode, but for non-data commands like these it appears we can handle them 
in ADMA mode, so the switch to legacy mode is not needed.

This patch changes the behavior so that we use ADMA mode to submit 
interrupt-driven commands with ATA_PROT_NODATA protocol. In addition to 
avoiding the problem mentioned above entirely, this avoids the overhead 
of switching to legacy mode and back to ADMA mode for handling cache 
flushes. When handling non-DMA-mapped commands, we leave the APRD blank 
and clear the NV_CPB_CTL_APRD_VALID field in the CPB so the controller 
does not attempt to read it.

Signed-off-by: Robert Hancock <hancockr@shaw.ca>

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/


--------------060507030002050506000108
Content-Type: text/plain;
 name="sata_nv-use-adma-for-nodata-commands.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sata_nv-use-adma-for-nodata-commands.patch"

--- linux-2.6.20-rc6nv/drivers/ata/sata_nv.c	2007-01-28 17:05:27.000000000 -0600
+++ linux-2.6.20-rc6nvedit/drivers/ata/sata_nv.c	2007-01-28 17:20:11.000000000 -0600
@@ -1172,16 +1172,31 @@ static void nv_adma_fill_sg(struct ata_q
 		cpb->next_aprd = cpu_to_le64(((u64)(pp->aprd_dma + NV_ADMA_SGTBL_SZ * qc->tag)));
 }
 
+static int nv_adma_use_reg_mode(struct ata_queued_cmd *qc)
+{
+	struct nv_adma_port_priv *pp = qc->ap->private_data;
+	
+	/* ADMA engine can only be used for non-ATAPI DMA commands,
+	   or interrupt-driven no-data commands. */
+	if((pp->flags & NV_ADMA_ATAPI_SETUP_COMPLETE) ||
+	   (qc->tf.flags & ATA_TFLAG_POLLING))
+		return 1;
+
+	if((qc->flags & ATA_QCFLAG_DMAMAP) ||
+	   (qc->tf.protocol == ATA_PROT_NODATA))
+		return 0;
+	
+	return 1;
+}
+
 static void nv_adma_qc_prep(struct ata_queued_cmd *qc)
 {
 	struct nv_adma_port_priv *pp = qc->ap->private_data;
 	struct nv_adma_cpb *cpb = &pp->cpb[qc->tag];
 	u8 ctl_flags = NV_CPB_CTL_CPB_VALID |
-		       NV_CPB_CTL_APRD_VALID |
 		       NV_CPB_CTL_IEN;
 
-	if (!(qc->flags & ATA_QCFLAG_DMAMAP) ||
-	     (pp->flags & NV_ADMA_ATAPI_SETUP_COMPLETE)) {
+	if (nv_adma_use_reg_mode(qc)) {
 		nv_adma_register_mode(qc->ap);
 		ata_qc_prep(qc);
 		return;
@@ -1200,8 +1215,12 @@ static void nv_adma_qc_prep(struct ata_q
 	VPRINTK("qc->flags = 0x%lx\n", qc->flags);
 
 	nv_adma_tf_to_cpb(&qc->tf, cpb->tf);
-
-	nv_adma_fill_sg(qc, cpb);
+	
+	if(qc->flags & ATA_QCFLAG_DMAMAP) {
+		nv_adma_fill_sg(qc, cpb);
+		ctl_flags |= NV_CPB_CTL_APRD_VALID;
+	} else
+		memset(&cpb->aprd[0], 0, sizeof(struct nv_adma_prd) * 5);
 
 	/* Be paranoid and don't let the device see NV_CPB_CTL_CPB_VALID until we are
 	   finished filling in all of the contents */
@@ -1216,10 +1235,9 @@ static unsigned int nv_adma_qc_issue(str
 
 	VPRINTK("ENTER\n");
 
-	if (!(qc->flags & ATA_QCFLAG_DMAMAP) ||
-	     (pp->flags & NV_ADMA_ATAPI_SETUP_COMPLETE)) {
+	if (nv_adma_use_reg_mode(qc)) {
 		/* use ATA register mode */
-		VPRINTK("no dmamap or ATAPI, using ATA register mode: 0x%lx\n", qc->flags);
+		VPRINTK("using ATA register mode: 0x%lx\n", qc->flags);
 		nv_adma_register_mode(qc->ap);
 		return ata_qc_issue_prot(qc);
 	} else

--------------060507030002050506000108--

