Return-Path: <linux-kernel-owner+w=401wt.eu-S1755184AbZEVKrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184AbZEVKrp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 06:47:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751894AbZEVKri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 06:47:38 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:16857 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbZEVKrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 06:47:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:cc:content-type:content-transfer-encoding;
        b=vZfKF6haPh5y1y9dWEicOdK7uCUNkRyYQHhLp7ldrch+aJ0BBM7GzXL4PixY6VLGfC
         zx1SyCA8WI55cO/pbUq/OfW/xW16KDWbfHhD0dcFPQGKFzbjwH6V1Y6uFduS7sCB25SF
         7n0LiTzKr54oRJXjL2EFZjYhRhawjcdzSVwkI=
MIME-Version: 1.0
Date: Fri, 22 May 2009 18:47:38 +0800
X-Google-Sender-Auth: e8d2adaa51d76b58
Message-ID: <2a27d3730905220347s59dbd152kc69c8399693ae307@mail.gmail.com>
Subject: [GIT PULL] fsldma driver fixes
From: Li Yang <leoli@freescale.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       linuxppc-dev Development <linuxppc-dev@ozlabs.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

Here are fixes for Freescale DMA engine driver.

Thanks,
- Leo


The following changes since commit 5805977e63a36ad56594a623f3bd2bebcb7db233:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../jbarnes/drm-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/leo/fsl-soc.git fsldma

Ira Snyder (4):
      fsldma: fix "DMA halt timeout!" errors
      fsldma: fix infinite loop on multi-descriptor DMA chain completion
      fsldma: snooping is not enabled for last entry in descriptor chain
      fsldma: fix memory leak on error path in fsl_dma_prep_memcpy()

Li Yang (1):
      fsldma: update mailling list address in MAINTAINERS

Roel Kluin (1):
      fsldma: fix check on potential fdev->chan[] overflow

 MAINTAINERS          |    2 +-
 drivers/dma/fsldma.c |   58 ++++++++++++++++++++++++++++++++++---------------
 2 files changed, 41 insertions(+), 19 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 2b349ba..cac3e3b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2241,7 +2241,7 @@ P:	Li Yang
 M:	leoli@freescale.com
 P:	Zhang Wei
 M:	zw@zh-kernel.org
-L:	linuxppc-embedded@ozlabs.org
+L:	linuxppc-dev@ozlabs.org
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	drivers/dma/fsldma.*
diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index da8a8ed..1578310 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -179,9 +179,14 @@ static void dma_halt(struct fsl_dma_chan *fsl_chan)
 static void set_ld_eol(struct fsl_dma_chan *fsl_chan,
 			struct fsl_desc_sw *desc)
 {
+	u64 snoop_bits;
+
+	snoop_bits = ((fsl_chan->feature & FSL_DMA_IP_MASK) == FSL_DMA_IP_83XX)
+		? FSL_DMA_SNEN : 0;
+
 	desc->hw.next_ln_addr = CPU_TO_DMA(fsl_chan,
-		DMA_TO_CPU(fsl_chan, desc->hw.next_ln_addr, 64)	| FSL_DMA_EOL,
-		64);
+		DMA_TO_CPU(fsl_chan, desc->hw.next_ln_addr, 64) | FSL_DMA_EOL
+			| snoop_bits, 64);
 }

 static void append_ld_queue(struct fsl_dma_chan *fsl_chan,
@@ -313,8 +318,8 @@ static void fsl_chan_toggle_ext_start(struct
fsl_dma_chan *fsl_chan, int enable)

 static dma_cookie_t fsl_dma_tx_submit(struct dma_async_tx_descriptor *tx)
 {
-	struct fsl_desc_sw *desc = tx_to_fsl_desc(tx);
 	struct fsl_dma_chan *fsl_chan = to_fsl_chan(tx->chan);
+	struct fsl_desc_sw *desc;
 	unsigned long flags;
 	dma_cookie_t cookie;

@@ -322,14 +327,17 @@ static dma_cookie_t fsl_dma_tx_submit(struct
dma_async_tx_descriptor *tx)
 	spin_lock_irqsave(&fsl_chan->desc_lock, flags);

 	cookie = fsl_chan->common.cookie;
-	cookie++;
-	if (cookie < 0)
-		cookie = 1;
-	desc->async_tx.cookie = cookie;
-	fsl_chan->common.cookie = desc->async_tx.cookie;
+	list_for_each_entry(desc, &tx->tx_list, node) {
+		cookie++;
+		if (cookie < 0)
+			cookie = 1;

-	append_ld_queue(fsl_chan, desc);
-	list_splice_init(&desc->async_tx.tx_list, fsl_chan->ld_queue.prev);
+		desc->async_tx.cookie = cookie;
+	}
+
+	fsl_chan->common.cookie = cookie;
+	append_ld_queue(fsl_chan, tx_to_fsl_desc(tx));
+	list_splice_init(&tx->tx_list, fsl_chan->ld_queue.prev);

 	spin_unlock_irqrestore(&fsl_chan->desc_lock, flags);

@@ -454,8 +462,8 @@ static struct dma_async_tx_descriptor *fsl_dma_prep_memcpy(
 {
 	struct fsl_dma_chan *fsl_chan;
 	struct fsl_desc_sw *first = NULL, *prev = NULL, *new;
+	struct list_head *list;
 	size_t copy;
-	LIST_HEAD(link_chain);

 	if (!chan)
 		return NULL;
@@ -472,7 +480,7 @@ static struct dma_async_tx_descriptor *fsl_dma_prep_memcpy(
 		if (!new) {
 			dev_err(fsl_chan->dev,
 					"No free memory for link descriptor\n");
-			return NULL;
+			goto fail;
 		}
 #ifdef FSL_DMA_LD_DEBUG
 		dev_dbg(fsl_chan->dev, "new link desc alloc %p\n", new);
@@ -507,7 +515,19 @@ static struct dma_async_tx_descriptor *fsl_dma_prep_memcpy(
 	/* Set End-of-link to the last link descriptor of new list*/
 	set_ld_eol(fsl_chan, new);

-	return first ? &first->async_tx : NULL;
+	return &first->async_tx;
+
+fail:
+	if (!first)
+		return NULL;
+
+	list = &first->async_tx.tx_list;
+	list_for_each_entry_safe_reverse(new, prev, list, node) {
+		list_del(&new->node);
+		dma_pool_free(fsl_chan->desc_pool, new, new->async_tx.phys);
+	}
+
+	return NULL;
 }

 /**
@@ -598,15 +618,16 @@ static void fsl_chan_xfer_ld_queue(struct
fsl_dma_chan *fsl_chan)
 	dma_addr_t next_dest_addr;
 	unsigned long flags;

+	spin_lock_irqsave(&fsl_chan->desc_lock, flags);
+
 	if (!dma_is_idle(fsl_chan))
-		return;
+		goto out_unlock;

 	dma_halt(fsl_chan);

 	/* If there are some link descriptors
 	 * not transfered in queue. We need to start it.
 	 */
-	spin_lock_irqsave(&fsl_chan->desc_lock, flags);

 	/* Find the first un-transfer desciptor */
 	for (ld_node = fsl_chan->ld_queue.next;
@@ -617,8 +638,6 @@ static void fsl_chan_xfer_ld_queue(struct
fsl_dma_chan *fsl_chan)
 				fsl_chan->common.cookie) == DMA_SUCCESS);
 		ld_node = ld_node->next);

-	spin_unlock_irqrestore(&fsl_chan->desc_lock, flags);
-
 	if (ld_node != &fsl_chan->ld_queue) {
 		/* Get the ld start address from ld_queue */
 		next_dest_addr = to_fsl_desc(ld_node)->async_tx.phys;
@@ -630,6 +649,9 @@ static void fsl_chan_xfer_ld_queue(struct
fsl_dma_chan *fsl_chan)
 		set_cdar(fsl_chan, 0);
 		set_ndar(fsl_chan, 0);
 	}
+
+out_unlock:
+	spin_unlock_irqrestore(&fsl_chan->desc_lock, flags);
 }

 /**
@@ -830,7 +852,7 @@ static int __devinit fsl_dma_chan_probe(struct
fsl_dma_device *fdev,
 			new_fsl_chan->reg.end - new_fsl_chan->reg.start + 1);

 	new_fsl_chan->id = ((new_fsl_chan->reg.start - 0x100) & 0xfff) >> 7;
-	if (new_fsl_chan->id > FSL_DMA_MAX_CHANS_PER_DEVICE) {
+	if (new_fsl_chan->id >= FSL_DMA_MAX_CHANS_PER_DEVICE) {
 		dev_err(fdev->dev, "There is no %d channel!\n",
 				new_fsl_chan->id);
 		err = -EINVAL;
