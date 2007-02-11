Return-Path: <linux-kernel-owner+w=401wt.eu-S932584AbXBKWXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932584AbXBKWXv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 17:23:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932588AbXBKWXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 17:23:51 -0500
Received: from mail.gmx.net ([213.165.64.20]:46853 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932584AbXBKWXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 17:23:50 -0500
X-Provags-ID: V01U2FsdGVkX1+nERoU42ynaaxauwRj6wPem0LWCjpszjexPJpDkT
	d4tw==
Date: Sun, 11 Feb 2007 23:23:45 +0100
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Neil Schemenauer <nas@arctrix.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: sata_nv - ADMA issues with 2.6.20
Message-ID: <20070211222345.GC17919@atjola.homenet>
Mail-Followup-To: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
	Neil Schemenauer <nas@arctrix.com>, linux-kernel@vger.kernel.org
References: <fa.uoZWqSFxPjjB7zobQOwk/2zqG5A@ifi.uio.no> <45CD20DB.9030808@shaw.ca> <eqnsbp$5fn$1@sea.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <eqnsbp$5fn$1@sea.gmane.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007.02.11 19:55:37 +0000, Neil Schemenauer wrote:
> > David R wrote:
> >>>> Feb  9 18:40:29 server kernel: ata7: Resetting port
> >>>> Feb  9 18:40:29 server kernel: ata7.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x2 frozen
> >>>> Feb  9 18:40:29 server kernel: ata7.00: cmd 61/08:00:1f:e4:50/00:00:09:00:00/40 tag 0 cdb 0x0 data 4096 out
> >>>> Feb  9 18:40:29 server kernel:          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> 
> I'm setting similar errors on my machine (AMD64 CPU, MSI board with
> NForce chipset).  Linux 2.6.19.2 seems to be okay.

If the look like this, you might want to try a few patches that are in
-mm.

ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata1.00: cmd e7/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata1: soft resetting port

We thought that Robert had fixed these with some changes that went into
-rc6. But they reappeared a few days later, the -mm patches seem to have
 finally cured it.

The original patches are here:

http://www2.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20-rc6/2.6.20-rc6-mm3/broken-out/sata_nv-cleanup-adma-error-handling-v2.patch
http://www2.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20-rc6/2.6.20-rc6-mm3/broken-out/sata_nv-cleanup-adma-error-handling-v2-cleanup.patch
http://www2.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20-rc6/2.6.20-rc6-mm3/broken-out/sata_nv-use-adma-for-nodata-commands.patch

As they had a few rejects against 2.6.20-rc7, I'm attaching my fixed all-in-one version of these patches, I guess it should apply to 2.6.20 just fine.

HTH
Björn


diff -NurpP --minimal a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
--- a/drivers/ata/sata_nv.c	2007-01-26 19:25:31.000000000 +0100
+++ b/drivers/ata/sata_nv.c	2007-02-04 01:49:54.000000000 +0100
@@ -648,53 +648,62 @@ static unsigned int nv_adma_tf_to_cpb(st
 	return idx;
 }
 
-static void nv_adma_check_cpb(struct ata_port *ap, int cpb_num, int force_err)
+static int nv_adma_check_cpb(struct ata_port *ap, int cpb_num, int force_err)
 {
 	struct nv_adma_port_priv *pp = ap->private_data;
-	int complete = 0, have_err = 0;
 	u8 flags = pp->cpb[cpb_num].resp_flags;
 
 	VPRINTK("CPB %d, flags=0x%x\n", cpb_num, flags);
 
-	if (flags & NV_CPB_RESP_DONE) {
-		VPRINTK("CPB flags done, flags=0x%x\n", flags);
-		complete = 1;
-	}
-	if (flags & NV_CPB_RESP_ATA_ERR) {
-		ata_port_printk(ap, KERN_ERR, "CPB flags ATA err, flags=0x%x\n", flags);
-		have_err = 1;
-		complete = 1;
-	}
-	if (flags & NV_CPB_RESP_CMD_ERR) {
-		ata_port_printk(ap, KERN_ERR, "CPB flags CMD err, flags=0x%x\n", flags);
-		have_err = 1;
-		complete = 1;
-	}
-	if (flags & NV_CPB_RESP_CPB_ERR) {
-		ata_port_printk(ap, KERN_ERR, "CPB flags CPB err, flags=0x%x\n", flags);
-		have_err = 1;
-		complete = 1;
+	if (unlikely((force_err ||
+		     flags & (NV_CPB_RESP_ATA_ERR |
+			      NV_CPB_RESP_CMD_ERR |
+			      NV_CPB_RESP_CPB_ERR)))) {
+		struct ata_eh_info *ehi = &ap->eh_info;
+		int freeze = 0;
+
+		ata_ehi_clear_desc(ehi);
+		ata_ehi_push_desc(ehi, "CPB resp_flags 0x%x", flags );
+		if (flags & NV_CPB_RESP_ATA_ERR) {
+			ata_ehi_push_desc(ehi, ": ATA error");
+			ehi->err_mask |= AC_ERR_DEV;
+		} else if (flags & NV_CPB_RESP_CMD_ERR) {
+			ata_ehi_push_desc(ehi, ": CMD error");
+			ehi->err_mask |= AC_ERR_DEV;
+		} else if (flags & NV_CPB_RESP_CPB_ERR) {
+			ata_ehi_push_desc(ehi, ": CPB error");
+			ehi->err_mask |= AC_ERR_SYSTEM;
+			freeze = 1;
+		} else {
+			/* notifier error, but no error in CPB flags? */
+			ehi->err_mask |= AC_ERR_OTHER;
+			freeze = 1;
+		}
+		/* Kill all commands. EH will determine what actually failed. */
+		if (freeze)
+			ata_port_freeze(ap);
+		else
+			ata_port_abort(ap);
+		return 1;
 	}
-	if(complete || force_err)
-	{
+
+	if (flags & NV_CPB_RESP_DONE) {
 		struct ata_queued_cmd *qc = ata_qc_from_tag(ap, cpb_num);
-		if(likely(qc)) {
-			u8 ata_status = 0;
-			/* Only use the ATA port status for non-NCQ commands.
+		VPRINTK("CPB flags done, flags=0x%x\n", flags);
+		if (likely(qc)) {
+			/* Grab the ATA port status for non-NCQ commands.
 			   For NCQ commands the current status may have nothing to do with
 			   the command just completed. */
-			if(qc->tf.protocol != ATA_PROT_NCQ)
-				ata_status = readb(nv_adma_ctl_block(ap) + (ATA_REG_STATUS * 4));
-
-			if(have_err || force_err)
-				ata_status |= ATA_ERR;
-
-			qc->err_mask |= ac_err_mask(ata_status);
+			if (qc->tf.protocol != ATA_PROT_NCQ) {
+				u8 ata_status = readb(nv_adma_ctl_block(ap) + (ATA_REG_STATUS * 4));
+				qc->err_mask |= ac_err_mask(ata_status);
+			}
 			DPRINTK("Completing qc from tag %d with err_mask %u\n",cpb_num,
 				qc->err_mask);
 			ata_qc_complete(qc);
 		}
 	}
+	return 0;
 }
 
 static int nv_host_intr(struct ata_port *ap, u8 irq_stat)
@@ -738,7 +747,6 @@ static irqreturn_t nv_adma_interrupt(int
 			void __iomem *mmio = nv_adma_ctl_block(ap);
 			u16 status;
 			u32 gen_ctl;
-			int have_global_err = 0;
 			u32 notifier, notifier_error;
 
 			/* if in ATA register mode, use standard ata interrupt handler */
@@ -774,42 +782,50 @@ static irqreturn_t nv_adma_interrupt(int
 			readw(mmio + NV_ADMA_STAT); /* flush posted write */
 			rmb();
 
-			/* freeze if hotplugged */
-			if (unlikely(status & (NV_ADMA_STAT_HOTPLUG | NV_ADMA_STAT_HOTUNPLUG))) {
-				ata_port_printk(ap, KERN_NOTICE, "Hotplug event, freezing\n");
+			handled++; /* irq handled if we got here */
+
+			/* freeze if hotplugged or controller error */
+			if (unlikely(status & (NV_ADMA_STAT_HOTPLUG |
+					       NV_ADMA_STAT_HOTUNPLUG |
+					       NV_ADMA_STAT_TIMEOUT))) {
+				struct ata_eh_info *ehi = &ap->eh_info;
+
+				ata_ehi_clear_desc(ehi);
+				ata_ehi_push_desc(ehi, "ADMA status 0x%08x", status );
+				if (status & NV_ADMA_STAT_TIMEOUT) {
+					ehi->err_mask |= AC_ERR_SYSTEM;
+					ata_ehi_push_desc(ehi, ": timeout");
+				} else if (status & NV_ADMA_STAT_HOTPLUG) {
+					ata_ehi_hotplugged(ehi);
+					ata_ehi_push_desc(ehi, ": hotplug");
+				} else if (status & NV_ADMA_STAT_HOTUNPLUG) {
+					ata_ehi_hotplugged(ehi);
+					ata_ehi_push_desc(ehi, ": hot unplug");
+				}
 				ata_port_freeze(ap);
-				handled++;
 				continue;
 			}
 
-			if (status & NV_ADMA_STAT_TIMEOUT) {
-				ata_port_printk(ap, KERN_ERR, "timeout, stat=0x%x\n", status);
-				have_global_err = 1;
-			}
-			if (status & NV_ADMA_STAT_CPBERR) {
-				ata_port_printk(ap, KERN_ERR, "CPB error, stat=0x%x\n", status);
-				have_global_err = 1;
-			}
-			if ((status & NV_ADMA_STAT_DONE) || have_global_err) {
+			if (status & (NV_ADMA_STAT_DONE |
+				      NV_ADMA_STAT_CPBERR)) {
 				/** Check CPBs for completed commands */
 
-				if(ata_tag_valid(ap->active_tag))
+				if (ata_tag_valid(ap->active_tag)) {
 					/* Non-NCQ command */
-					nv_adma_check_cpb(ap, ap->active_tag, have_global_err ||
-						(notifier_error & (1 << ap->active_tag)));
-				else {
-					int pos;
+					nv_adma_check_cpb(ap, ap->active_tag,
+						notifier_error & (1 << ap->active_tag));
+				} else {
+					int pos, error = 0;
 					u32 active = ap->sactive;
-					while( (pos = ffs(active)) ) {
+
+					while ((pos = ffs(active)) && !error) {
 						pos--;
-						nv_adma_check_cpb(ap, pos, have_global_err ||
-							(notifier_error & (1 << pos)) );
+						error = nv_adma_check_cpb(ap, pos,
+							notifier_error & (1 << pos) );
 						active &= ~(1 << pos );
 					}
 				}
 			}
-
-			handled++; /* irq handled if we got here */
 		}
 	}
 	
@@ -1110,18 +1126,33 @@ static void nv_adma_fill_sg(struct ata_q
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
 
 	VPRINTK("qc->flags = 0x%lx\n", qc->flags);
 
-	if (!(qc->flags & ATA_QCFLAG_DMAMAP) ||
-	     (pp->flags & NV_ADMA_ATAPI_SETUP_COMPLETE)) {
+	if (nv_adma_use_reg_mode(qc)) {
 		nv_adma_register_mode(qc->ap);
 		ata_qc_prep(qc);
 		return;
@@ -1139,7 +1170,11 @@ static void nv_adma_qc_prep(struct ata_q
 
 	nv_adma_tf_to_cpb(&qc->tf, cpb->tf);
 
-	nv_adma_fill_sg(qc, cpb);
+	if(qc->flags & ATA_QCFLAG_DMAMAP) {
+		nv_adma_fill_sg(qc, cpb);
+		ctl_flags |= NV_CPB_CTL_APRD_VALID;
+	} else
+		memset(&cpb->aprd[0], 0, sizeof(struct nv_adma_prd) * 5);
 
 	/* Be paranoid and don't let the device see NV_CPB_CTL_CPB_VALID until we are
 	   finished filling in all of the contents */
@@ -1154,10 +1189,9 @@ static unsigned int nv_adma_qc_issue(str
 
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
@@ -1339,28 +1373,9 @@ static void nv_adma_error_handler(struct
 		int i;
 		u16 tmp;
 
-		u32 notifier = readl(mmio + NV_ADMA_NOTIFIER);
-		u32 notifier_error = readl(mmio + NV_ADMA_NOTIFIER_ERROR);
-		u32 gen_ctl = readl(nv_adma_gen_block(ap) + NV_ADMA_GEN_CTL);
-		u32 status = readw(mmio + NV_ADMA_STAT);
-
-		ata_port_printk(ap, KERN_ERR, "EH in ADMA mode, notifier 0x%X "
-			"notifier_error 0x%X gen_ctl 0x%X status 0x%X\n",
-			notifier, notifier_error, gen_ctl, status);
-
-		for( i=0;i<NV_ADMA_MAX_CPBS;i++) {
-			struct nv_adma_cpb *cpb = &pp->cpb[i];
-			if( cpb->ctl_flags || cpb->resp_flags )
-				ata_port_printk(ap, KERN_ERR,
-					"CPB %d: ctl_flags 0x%x, resp_flags 0x%x\n",
-					i, cpb->ctl_flags, cpb->resp_flags);
-		}
-
 		/* Push us back into port register mode for error handling. */
 		nv_adma_register_mode(ap);
 
-		ata_port_printk(ap, KERN_ERR, "Resetting port\n");
-
 		/* Mark all of the CPBs as invalid to prevent them from being executed */
 		for( i=0;i<NV_ADMA_MAX_CPBS;i++)
 			pp->cpb[i].ctl_flags &= ~NV_CPB_CTL_CPB_VALID;
