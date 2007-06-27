Return-Path: <linux-kernel-owner+w=401wt.eu-S1760202AbXF0F1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760202AbXF0F1V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 01:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753944AbXF0F1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 01:27:12 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44905 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755891AbXF0F1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 01:27:11 -0400
Date: Tue, 26 Jun 2007 22:26:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "kuan luo" <kuanluo@gmail.com>
Cc: linux-kernel@vger.kernel.org, jeff@garzik.org, pchen@nvidia.com,
       kluo@nvidia.com
Subject: Re: [PATCH] ata: Add the SW NCQ support to sata_nv for
 MCP51/MCP55/MCP61
Message-Id: <20070626222655.0270c7b7.akpm@linux-foundation.org>
In-Reply-To: <53f198c00706262004v27c80134m892dcf89d6c48e00@mail.gmail.com>
References: <53f198c00706262004v27c80134m892dcf89d6c48e00@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jun 2007 11:04:44 +0800 "kuan luo" <kuanluo@gmail.com> wrote:

> Add the Software NCQ support to sata_nv.c for MCP51/MCP55/MCP61 SATA controller.
> NCQ function is disable by default, you can enable it with 'swncq=1'
> 

This patch adds a large amount of new trailing whitespace.

> ---
> diff -Nurp a/sata_nv.c b/sata_nv.c
> --- a/sata_nv.c	2007-06-13 10:15:07.000000000 -0400
> +++ b/sata_nv.c	2007-06-26 12:52:27.000000000 -0400

Please prepare patches in `pathc -p1' form.

> +typedef struct {
> + 	u32		defer_bits;
> + 	u8		front;
> +	u8		rear;
> +	unsigned int	tag[ATA_MAX_QUEUE + 1];
> +}defer_queue_t;

Avoid adding typedefs.

> +static int swncq_enabled = 0;

Don't initialise static storage to zero: it needlessly increases the
vmlinux size.

>  			   nv_hardreset, ata_std_postreset);
>  }
> 
> +static void nv_swncq_qc_to_dq(struct ata_port *ap, struct ata_queued_cmd *qc)
> +{
> +	struct nv_swncq_port_priv *pp = ap->private_data;
> +	defer_queue_t	*dq = &pp->defer_queue;
> +	
> +	/* queue is full */
> +	WARN_ON((dq->rear + 1) % (ATA_MAX_QUEUE + 1) == dq->front);

This is peculiar.  The array is sized ATA_MAX_QUEUE+1 (ie: 33) and the code
uses ATA_MAX_QUEUE+1 everywhere.

It looks to me like the ata code was designed to queue up to 32 elements
and all this code has taken that to 33.  What exactly is going on here?  

> +
> +	dq->defer_bits |= (1 << qc->tag);
> +	
> +	dq->tag[dq->rear] = qc->tag;
> +	dq->rear = (dq->rear + 1) % (ATA_MAX_QUEUE + 1);
> +	
> +}
> +
> +static struct ata_queued_cmd *nv_swncq_qc_from_dq(struct ata_port *ap)
> +{
> +	struct nv_swncq_port_priv *pp = ap->private_data;
> +	defer_queue_t	*dq = &pp->defer_queue;
> +	unsigned int tag;
> +	
> +	if (dq->front == dq->rear) /* null queue */
> +		return NULL;
> +			
> +	tag = dq->tag[dq->front];
> +	dq->tag[dq->front] = ATA_TAG_POISON;
> +	dq->front = (dq->front + 1) % (ATA_MAX_QUEUE + 1);

etc.

> +	WARN_ON(!(dq->defer_bits & (1 << tag)));
> +	dq->defer_bits &= ~(1 << tag);
> +
> +	return ata_qc_from_tag(ap, tag);
> +}
> +
> +	dq->front = dq->rear = 0;
> +	dq->defer_bits = 0;
> +	pp->qc_active = 0;
> +	pp->last_issue_tag = ATA_TAG_POISON;
> +	nv_swncq_fis_reinit(ap);
> +}
> +
> +static void nv_swncq_irq_clear(struct ata_port *ap, u32 val)
> +{
> +	void __iomem *mmio = ap->host->iomap[NV_MMIO_BAR];
> +	u32  flags = (val << (ap->port_no * NV_INT_PORT_SHIFT_MCP55));

I hope we'll never need to support more than two ports...

> +	writel(flags, mmio + NV_INT_STATUS_MCP55);
> +}
> +
> +static void nv_swncq_ncq_stop(struct ata_port *ap)
> +{
> +	struct nv_swncq_port_priv *pp = ap->private_data;
> +	unsigned int i;				
> +	u32 sactive;
> +	u32 done_mask;
> +
> +	ata_port_printk(ap, KERN_ERR,
> +		"EH in SWNCQ mode,QC:qc_active 0x%X sactive 0x%X\n",
> +		ap->qc_active, ap->sactive);
> +	ata_port_printk(ap, KERN_ERR,
> +		"SWNCQ:qc_active 0x%X defer_bits 0x%X last_issue_tag 0x%x\n  "
> +		 "dhfis 0x%X dmafis 0x%X sdbfis 0x%X\n",
> +		pp->qc_active, pp->defer_queue.defer_bits, pp->last_issue_tag,
> +		pp->dhfis_bits, pp->dmafis_bits,
> +		pp->sdbfis_bits);
> +	
> +	ata_port_printk(ap, KERN_ERR, "ATA_REG 0x%X ERR_REG 0x%X\n",
> +		ap->ops->check_status(ap), ioread8(ap->ioaddr.error_addr));
> +	
> +	sactive = readl(pp->sactive_block);
> +	done_mask = pp->qc_active ^ sactive;
> +	
> +	ata_port_printk(ap, KERN_ERR, "tag : dhfis dmafis sdbfis sacitve\n");
> +	for (i=0; i < ATA_MAX_QUEUE; i++) {

Missing spaces around the "=".

We have a script in scripts/checkpatch.pl which will inform you about many
of these little things.  Please familiarise yourself with it.

> +		u8 err = 0;
> +		if (pp->qc_active & (1 << i))
> +			err = 0;
> +		else if (done_mask & (1 << i))
> +			err = 1;
> +		else
> +			continue;
> +			
> +		ata_port_printk(ap, KERN_ERR,
> +		"tag 0x%x: %01x %01x %01x %01x %s\n", i,
> +		(pp->dhfis_bits >> i) & 0x1,
> +		(pp->dmafis_bits >> i) & 0x1 , (pp->sdbfis_bits >> i) & 0x1,
> +		(sactive >> i) & 0x1,
> +		(err ? "error!tag doesn't exit, but sactive bit is set" : " "));
> +	}
> +
> +	nv_swncq_pp_reinit(ap);
> +	ap->ops->irq_clear(ap);
> +	nv_swncq_bmdma_stop(ap);
> +	nv_swncq_irq_clear(ap, 0xffff);
> +}
>
> ...
>
> +
> +static void nv_swncq_fill_sg(struct ata_queued_cmd *qc)
> +{
> +	struct ata_port *ap = qc->ap;
> +	struct scatterlist *sg;
> +	unsigned int idx;
> +	
> +	struct nv_swncq_port_priv *pp = ap->private_data;
> +	
> +	struct ata_prd *prd;
> +
> +	WARN_ON(qc->__sg == NULL);
> +	WARN_ON(qc->n_elem == 0 && qc->pad_len == 0);
> +	
> +	prd = (void*)pp->prd + (ATA_PRD_TBL_SZ * qc->tag);

Are you sure that should have been ATA_PRD_TBL_SZ and not ATA_PRD_SZ?

Can this expression be done in a more type-friendly way?

> +	idx = 0;
> +	ata_for_each_sg(sg, qc) {
> +		u32 addr, offset;
> +		u32 sg_len, len;
> +
> +		addr = (u32) sg_dma_address(sg);
> +		sg_len = sg_dma_len(sg);
> +
> +		while (sg_len) {
> +			offset = addr & 0xffff;
> +			len = sg_len;
> +			if ((offset + sg_len) > 0x10000)
> +				len = 0x10000 - offset;
> +
> +			prd[idx].addr = cpu_to_le32(addr);
> +			prd[idx].flags_len = cpu_to_le32(len & 0xffff);
> +
> +			idx++;
> +			sg_len -= len;
> +			addr += len;
> +		}
> +	}
> +
> +	if (idx)
> +		prd[idx - 1].flags_len |= cpu_to_le32(ATA_PRD_EOT);
> +}
> +

Various fixlets:

From: Andrew Morton <akpm@linux-foundation.org>

- remove new typedef

- use bss: it's already initialised to zero

- cleanups

Cc: Kuan Luo <kluo@nvidia.com>
Cc: Peer Chen <pchen@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/sata_nv.c |   30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

diff -puN drivers/ata/sata_nv.c~ata-add-the-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61-fix drivers/ata/sata_nv.c
--- a/drivers/ata/sata_nv.c~ata-add-the-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61-fix
+++ a/drivers/ata/sata_nv.c
@@ -255,12 +255,12 @@ struct nv_host_priv {
 	unsigned long		type;
 };
 
-typedef struct {
+struct defer_queue {
  	u32		defer_bits;
  	u8		front;
 	u8		rear;
 	unsigned int	tag[ATA_MAX_QUEUE + 1];
-}defer_queue_t;
+};
 
 struct nv_swncq_port_priv {
 	struct ata_prd	*prd;	 /* our SG list */
@@ -270,7 +270,7 @@ struct nv_swncq_port_priv {
 	unsigned int	last_issue_tag;
  	spinlock_t	lock;
  	/* fifo loop queue  to store deferral command */
-	defer_queue_t	defer_queue;
+	struct defer_queue defer_queue;
 
  	/* for NCQ interrupt analysis */
 	u32		dhfis_bits;
@@ -637,7 +637,7 @@ MODULE_DEVICE_TABLE(pci, nv_pci_tbl);
 MODULE_VERSION(DRV_VERSION);
 
 static int adma_enabled = 1;
-static int swncq_enabled = 0;
+static int swncq_enabled;
 
 static void nv_adma_register_mode(struct ata_port *ap)
 {
@@ -1705,7 +1705,7 @@ static void nv_adma_error_handler(struct
 static void nv_swncq_qc_to_dq(struct ata_port *ap, struct ata_queued_cmd *qc)
 {
 	struct nv_swncq_port_priv *pp = ap->private_data;
-	defer_queue_t	*dq = &pp->defer_queue;
+	struct defer_queue *dq = &pp->defer_queue;
 
 	/* queue is full */
 	WARN_ON((dq->rear + 1) % (ATA_MAX_QUEUE + 1) == dq->front);
@@ -1720,7 +1720,7 @@ static void nv_swncq_qc_to_dq(struct ata
 static struct ata_queued_cmd *nv_swncq_qc_from_dq(struct ata_port *ap)
 {
 	struct nv_swncq_port_priv *pp = ap->private_data;
-	defer_queue_t	*dq = &pp->defer_queue;
+	struct defer_queue *dq = &pp->defer_queue;
 	unsigned int tag;
 
 	if (dq->front == dq->rear) /* null queue */
@@ -1760,7 +1760,7 @@ static void nv_swncq_fis_reinit(struct a
 static void nv_swncq_pp_reinit(struct ata_port *ap)
 {
 	struct nv_swncq_port_priv *pp = ap->private_data;
-	defer_queue_t		*dq = &pp->defer_queue;
+	struct defer_queue *dq = &pp->defer_queue;
 
 	dq->front = dq->rear = 0;
 	dq->defer_bits = 0;
@@ -1801,7 +1801,7 @@ static void nv_swncq_ncq_stop(struct ata
 	done_mask = pp->qc_active ^ sactive;
 
 	ata_port_printk(ap, KERN_ERR, "tag : dhfis dmafis sdbfis sacitve\n");
-	for (i=0; i < ATA_MAX_QUEUE; i++) {
+	for (i = 0; i < ATA_MAX_QUEUE; i++) {
 		u8 err = 0;
 		if (pp->qc_active & (1 << i))
 			err = 0;
@@ -1912,7 +1912,7 @@ static void nv_swncq_host_init(struct at
 	writel(~0x0, mmio + NV_INT_STATUS_MCP55);
 }
 
-static int  nv_swncq_port_start(struct ata_port *ap)
+static int nv_swncq_port_start(struct ata_port *ap)
 {
 	struct device *dev = ap->host->dev;
 	void __iomem *mmio = ap->host->iomap[NV_MMIO_BAR];
@@ -1957,9 +1957,7 @@ static void nv_swncq_fill_sg(struct ata_
 	struct ata_port *ap = qc->ap;
 	struct scatterlist *sg;
 	unsigned int idx;
-
 	struct nv_swncq_port_priv *pp = ap->private_data;
-
 	struct ata_prd *prd;
 
 	WARN_ON(qc->__sg == NULL);
@@ -1972,7 +1970,7 @@ static void nv_swncq_fill_sg(struct ata_
 		u32 addr, offset;
 		u32 sg_len, len;
 
-		addr = (u32) sg_dma_address(sg);
+		addr = (u32)sg_dma_address(sg);
 		sg_len = sg_dma_len(sg);
 
 		while (sg_len) {
@@ -2051,7 +2049,6 @@ static void nv_swncq_hotplug(struct ata_
 	/* analyze @irq_stat */
 	if (fis & NV_SWNCQ_IRQ_ADDED)
 		ata_ehi_push_desc(ehi, "hot plug");
-
 	else if (fis & NV_SWNCQ_IRQ_REMOVED)
 		ata_ehi_push_desc(ehi, "hot unplug");
 
@@ -2122,7 +2119,7 @@ static int nv_swncq_sdbfis(struct ata_po
 	}
 
 	if (pp->qc_active & pp->dhfis_bits)
-			return nr_done;
+		return nr_done;
 
 	if (pp->ncq_saw_backout || (pp->qc_active ^pp->dhfis_bits))
 		 /* if the controller cann't get a device to host register FIS,
@@ -2181,7 +2178,7 @@ static int nv_swncq_dmafis(struct ata_po
 	if (unlikely(!qc))
 		return 0;
 
-	rw  =  ((qc->tf.flags) & ATA_TFLAG_WRITE);
+	rw = qc->tf.flags & ATA_TFLAG_WRITE;
 
 	/* load PRD table addr. */
 	iowrite32(pp->prd_dma + ATA_PRD_TBL_SZ * qc->tag,
@@ -2189,7 +2186,7 @@ static int nv_swncq_dmafis(struct ata_po
 
 	/* specify data direction, triple-check start bit is clear */
 	dmactl = ioread8(ap->ioaddr.bmdma_addr + ATA_DMA_CMD);
-	dmactl &= ~(ATA_DMA_WR);
+	dmactl &= ~ATA_DMA_WR;
 	if (!rw)
 		dmactl |= ATA_DMA_WR;
 
@@ -2305,6 +2302,7 @@ static irqreturn_t nv_swncq_interrupt(in
 	unsigned int handled = 0;
 	unsigned long flags;
 	u32 irq_stat;
+
 	spin_lock_irqsave(&host->lock, flags);
 
 	irq_stat = readl(host->iomap[NV_MMIO_BAR] + NV_INT_STATUS_MCP55);
_

