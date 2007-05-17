Return-Path: <linux-kernel-owner+w=401wt.eu-S1757126AbXEQUPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757126AbXEQUPv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 16:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759532AbXEQUPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 16:15:44 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33093 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757552AbXEQUPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 16:15:43 -0400
Date: Thu, 17 May 2007 13:12:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Peer Chen" <pchen@nvidia.com>
Cc: <linux-kernel@vger.kernel.org>, "Jeff Garzik" <jeff@garzik.org>,
       "Robert Hancock" <hancockr@shaw.ca>, "Kuan Luo" <kluo@nvidia.com>
Subject: Re: [PATCH] drivers/ata: Add the SW NCQ support to sata_nv for
 MCP51/MCP55/MCP61
Message-Id: <20070517131235.8f9445cc.akpm@linux-foundation.org>
In-Reply-To: <15F501D1A78BD343BE8F4D8DB854566B13F197C0@hkemmail01.nvidia.com>
References: <15F501D1A78BD343BE8F4D8DB854566B13CD8F45@hkemmail01.nvidia.com>
	<464A94D7.30300@garzik.org>
	<15F501D1A78BD343BE8F4D8DB854566B13F197C0@hkemmail01.nvidia.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 May 2007 18:15:45 +0800
"Peer Chen" <pchen@nvidia.com> wrote:

>  Add the Software NCQ support to sata_nv.c for MCP51/MCP55/MCP61 SATA
> controller.
> 
> This patch base on sata_nv.c file from kernel 2.6.22-rc1
> 
> See attachment for the patch.
> 
> Signed-off-by: Kuan Luo <kluo@nvidia.com>
> Signed-off-by: Peer Chen <pchen@nvidia.com>

Please don't send patches as application/octet-stream attachments.  Inlined
in the body is preferred, or at least text/plain attachments.

The patch generates warnings:

drivers/ata/sata_nv.c:2118: warning: cast from pointer to integer of different size
drivers/ata/sata_nv.c:2118: warning: cast to pointer from integer of different size

due to some quite suspicious-looknig code:

        prd = (struct ata_prd*)((u64)pp->prd + ATA_PRD_TBL_SZ*qc->tag);

we have

struct ata_prd {
	        u32                     addr;
	        u32                     flags_len;
};

and the code is casting a pointer to this into a pointer to u64, then
adding stuff to it, then casting it back to the correct type.

Can't we simply do this?

--- a/drivers/ata/sata_nv.c~drivers-ata-add-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61-fix
+++ a/drivers/ata/sata_nv.c
@@ -2115,7 +2115,7 @@ static void nv_fill_sg(struct ata_queued
 	WARN_ON(qc->__sg == NULL);
 	WARN_ON(qc->n_elem == 0 && qc->pad_len == 0);
 
-	prd = (struct ata_prd*)((u64)pp->prd + ATA_PRD_TBL_SZ*qc->tag);
+	prd = pp->prd + ATA_PRD_TBL_SZ*qc->tag;
 
 	idx = 0;
 	ata_for_each_sg(sg, qc) {
_


Also, please please please do not do this:

static void nv_fill_sg(struct ata_queued_cmd *qc)
{
	struct ata_port *ap = qc->ap;
	struct scatterlist *sg;
	unsigned int idx;

	struct nv_port_priv *pp = ap->private_data;

	struct ata_prd *prd;

	WARN_ON(qc->__sg == NULL);
	WARN_ON(qc->n_elem == 0 && qc->pad_len == 0);


the random meaningless blank lines between the definitions of the local
variables makes it quite hard to read the code.  I actually had to do a
text search to find the definition of "pp" because that trick hid it so
well.

Your patch added tremendous amounts of new trailing whitespace.

One function was indented an extra tabstop.

Some whitespace was broken.




diff -puN drivers/ata/sata_nv.c~drivers-ata-add-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61-fix-tidy drivers/ata/sata_nv.c
--- a/drivers/ata/sata_nv.c~drivers-ata-add-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61-fix-tidy
+++ a/drivers/ata/sata_nv.c
@@ -2107,9 +2107,7 @@ static void nv_fill_sg(struct ata_queued
 	struct ata_port *ap = qc->ap;
 	struct scatterlist *sg;
 	unsigned int idx;
-
 	struct nv_port_priv *pp = ap->private_data;
-
 	struct ata_prd *prd;
 
 	WARN_ON(qc->__sg == NULL);
@@ -2194,11 +2192,10 @@ static unsigned int nv_qc_issue_prot(str
 {
 	struct ata_port *ap = qc->ap;
 	struct nv_port_priv *pp = ap->private_data;
-
 	struct ata_taskfile	*tf = &(qc->tf);
 	struct ata_taskfile *ttf, rtf;
-
 	u32 fis, stat0, stat1;
+
 	ttf = &rtf;
 
 	if (qc->tf.protocol != ATA_PROT_NCQ)
@@ -2338,32 +2335,29 @@ static void fis_dump(struct ata_port *ap
 
 void ncq_hotplug(struct ata_port *ap, u32 fis)
 {
+	u32 serror;
+	struct ata_eh_info *ehi = &ap->eh_info;
 
-		u32 serror;
-		struct ata_eh_info *ehi = &ap->eh_info;
+	ata_ehi_clear_desc(ehi);
 
-		ata_ehi_clear_desc(ehi);
-
-		/* AHCI needs SError cleared; otherwise, it might lock up */
-		sata_scr_read(ap, SCR_ERROR, &serror);
-		sata_scr_write(ap, SCR_ERROR, serror);
+	/* AHCI needs SError cleared; otherwise, it might lock up */
+	sata_scr_read(ap, SCR_ERROR, &serror);
+	sata_scr_write(ap, SCR_ERROR, serror);
 
-		/* analyze @irq_stat */
-		ata_ehi_push_desc(ehi, "fis_stat 0x%08x", fis);
+	/* analyze @irq_stat */
+	ata_ehi_push_desc(ehi, "fis_stat 0x%08x", fis);
 
-		ata_ehi_hotplugged(ehi);
+	ata_ehi_hotplugged(ehi);
 
-		/* okay, let's hand over to EH */
-		ehi->serror |= serror;
+	/* okay, let's hand over to EH */
+	ehi->serror |= serror;
 
-		ata_port_freeze(ap);
+	ata_port_freeze(ap);
 }
 
-
 static int ncq_interrupt(struct ata_port *ap, u32 fis)
 {
 	struct nv_port_priv *pp = ap->private_data;
-
 	u32 rc = 0;
 	u32 tag;
 	u8 ata_stat;
@@ -2371,7 +2365,6 @@ static int ncq_interrupt(struct ata_port
 	if (!fis)
 		return 0;
 
-
 	ata_stat = ap->ops->check_status(ap);
 
 	ap->ops->irq_clear(ap); /* clear bm irq */
@@ -2398,7 +2391,7 @@ static int ncq_interrupt(struct ata_port
 		set_back_byte(pp, pp->current_tag);
 		NPRINTK("BACK OUT FIS:%x \n", fis);
 		rc = 1;
-	 } /* first handle back out */
+	} /* first handle back out */
 
 	if (fis & NV_INT_SDBFIS_MCP55) {
 		pp->ops->clear_singlefis(ap, NV_INT_SDBFIS_MCP55 | NV_INT_DEV_MCP55);
_

