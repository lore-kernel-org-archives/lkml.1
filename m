Return-Path: <linux-kernel-owner+w=401wt.eu-S1757256AbYAJBQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757256AbYAJBQR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 20:16:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753115AbYAJBQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 20:16:07 -0500
Received: from mga03.intel.com ([143.182.124.21]:19157 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026AbYAJBQF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 20:16:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,264,1196668800"; 
   d="scan'208";a="363059112"
Subject: Re: [PATCH v2] Add DMA engine driver for Freescale MPC85xx
	processors.
From: Dan Williams <dan.j.williams@intel.com>
To: Zhang Wei <wei.zhang@freescale.com>
Cc: linux-kernel@vger.kernel.org, Ebony Zhu <ebony.zhu@freescale.com>
In-Reply-To: <11937363043862-git-send-email-wei.zhang@freescale.com>
References: <11937363043862-git-send-email-wei.zhang@freescale.com>
Content-Type: text/plain
Date: Wed, 09 Jan 2008 17:55:10 -0700
Message-Id: <1199926510.18882.30.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-10-30 at 02:25 -0700, Zhang Wei wrote:
> The driver implements DMA engine API for Freescale MPC85xx DMA 
> controller, which could be used by devices in the silicon. 
> The driver supports the Basic mode of Freescale MPC85xx DMA
> controller. 
> The MPC85xx processors supported include MPC8540/60, MPC8555,
> MPC8548, 
> MPC8641 and so on. 
> The MPC83xx(MPC8349, MPC8360) are also supported.
> 
> Signed-off-by: Zhang Wei <wei.zhang@freescale.com> 
> Signed-off-by: Ebony Zhu <ebony.zhu@freescale.com> 
> --- 

Hello Wei,

Since the fixups were straightforward I went ahead and pulled this patch
out of -mm and rebased it on my async-tx patch queue for 2.6.25.  Could
you double check the result, I have only compile tested it?

	git pull git://lost.foo-projects.org/~dwillia2/git/iop md-for-linus

I also came across two more review items:
1/ Is there any issue with getting rid of CONFIG_FSL_DMA_SELFTEST?  It
is always on in iop-adma and ioatdma.

2/ I get the following compile warning:
drivers/dma/fsldma.c:731: warning: 'fsl_dma_callback_test' defined but not used

For reference the changes I made when I rebased are appended below.

Thanks,
Dan

 fsldma.c |   66 +++++++++++++++++++--------------------------------------------
 1 file changed, 20 insertions(+), 46 deletions(-)

diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index 899b0c0..902e852 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -302,30 +302,6 @@ static void fsl_chan_toggle_ext_start(struct fsl_dma_chan *fsl_chan, int enable)
 		fsl_chan->feature &= ~FSL_DMA_CHAN_START_EXT;
 }
 
-static void fsl_dma_set_src(dma_addr_t addr,
-				struct dma_async_tx_descriptor *tx, int index)
-{
-	struct fsl_desc_sw *desc_node, *desc = tx_to_fsl_desc(tx);
-	struct fsl_dma_chan *fsl_chan = to_fsl_chan(tx->chan);
-
-	list_for_each_entry(desc_node, &desc->async_tx.tx_list, node) {
-		set_desc_src(fsl_chan, &desc_node->hw, addr);
-		addr += FSL_DMA_BCR_MAX_CNT;
-	}
-}
-
-static void fsl_dma_set_dest(dma_addr_t addr,
-				struct dma_async_tx_descriptor *tx, int index)
-{
-	struct fsl_desc_sw *desc_node, *desc = tx_to_fsl_desc(tx);
-	struct fsl_dma_chan *fsl_chan = to_fsl_chan(tx->chan);
-
-	list_for_each_entry(desc_node, &desc->async_tx.tx_list, node) {
-		set_desc_dest(fsl_chan, &desc_node->hw, addr);
-		addr += FSL_DMA_BCR_MAX_CNT;
-	}
-}
-
 static dma_cookie_t fsl_dma_tx_submit(struct dma_async_tx_descriptor *tx)
 {
 	struct fsl_desc_sw *desc = tx_to_fsl_desc(tx);
@@ -368,8 +344,6 @@ static struct fsl_desc_sw *fsl_dma_alloc_descriptor(
 		memset(desc_sw, 0, sizeof(struct fsl_desc_sw));
 		dma_async_tx_descriptor_init(&desc_sw->async_tx,
 						&fsl_chan->common);
-		desc_sw->async_tx.tx_set_src = fsl_dma_set_src;
-		desc_sw->async_tx.tx_set_dest = fsl_dma_set_dest;
 		desc_sw->async_tx.tx_submit = fsl_dma_tx_submit;
 		INIT_LIST_HEAD(&desc_sw->async_tx.tx_list);
 		desc_sw->async_tx.phys = pdesc;
@@ -433,7 +407,8 @@ static void fsl_dma_free_chan_resources(struct dma_chan *chan)
 }
 
 static struct dma_async_tx_descriptor *fsl_dma_prep_memcpy(
-				struct dma_chan *chan, size_t len, int int_en)
+	struct dma_chan *chan, dma_addr_t dma_dest, dma_addr_t dma_src,
+	size_t len, unsigned long flags)
 {
 	struct fsl_dma_chan *fsl_chan;
 	struct fsl_desc_sw *first = NULL, *prev = NULL, *new;
@@ -464,6 +439,8 @@ static struct dma_async_tx_descriptor *fsl_dma_prep_memcpy(
 		copy = min(len, FSL_DMA_BCR_MAX_CNT);
 
 		set_desc_cnt(fsl_chan, &new->hw, copy);
+		set_desc_src(fsl_chan, &new->hw, dma_src);
+		set_desc_dest(fsl_chan, &new->hw, dma_dest);
 
 		if (!first)
 			first = new;
@@ -475,6 +452,8 @@ static struct dma_async_tx_descriptor *fsl_dma_prep_memcpy(
 
 		prev = new;
 		len -= copy;
+		dma_src += copy;
+		dma_dest += copy;
 
 		/* Insert the link descriptor to the LD ring */
 		list_add_tail(&new->node, &first->async_tx.tx_list);
@@ -758,7 +737,7 @@ static int fsl_dma_self_test(struct fsl_dma_chan *fsl_chan)
 {
 	struct dma_chan *chan;
 	int err = 0;
-	dma_addr_t addr;
+	dma_addr_t dma_dest, dma_src;
 	dma_cookie_t cookie;
 	u8 *src, *dest;
 	int i;
@@ -790,13 +769,12 @@ static int fsl_dma_self_test(struct fsl_dma_chan *fsl_chan)
 	}
 
 	/* TX 1 */
-	tx1 = fsl_dma_prep_memcpy(chan, test_size / 2, 0);
+	dma_src = dma_map_single(fsl_chan->dev, src, test_size / 2,
+				 DMA_TO_DEVICE);
+	dma_dest = dma_map_single(fsl_chan->dev, dest, test_size / 2,
+				  DMA_FROM_DEVICE);
+	tx1 = fsl_dma_prep_memcpy(chan, dma_dest, dma_src, test_size / 2, 0);
 	async_tx_ack(tx1);
-	addr = dma_map_single(fsl_chan->dev, src, test_size / 2, DMA_TO_DEVICE);
-	fsl_dma_set_src(addr, tx1, 0);
-	addr = dma_map_single(fsl_chan->dev, dest, test_size / 2,
-							DMA_FROM_DEVICE);
-	fsl_dma_set_dest(addr, tx1, 0);
 
 	cookie = fsl_dma_tx_submit(tx1);
 	fsl_dma_memcpy_issue_pending(chan);
@@ -821,24 +799,20 @@ static int fsl_dma_self_test(struct fsl_dma_chan *fsl_chan)
 	/* Continue to test
 	 * TX 2
 	 */
-	tx2 = fsl_dma_prep_memcpy(chan, test_size / 4, 0);
-	async_tx_ack(tx2);
-	addr = dma_map_single(fsl_chan->dev, src + test_size / 2,
+	dma_src = dma_map_single(fsl_chan->dev, src + test_size / 2,
 					test_size / 4, DMA_TO_DEVICE);
-	fsl_dma_set_src(addr, tx2, 0);
-	addr = dma_map_single(fsl_chan->dev, dest + test_size / 2,
+	dma_dest = dma_map_single(fsl_chan->dev, dest + test_size / 2,
 					test_size / 4, DMA_FROM_DEVICE);
-	fsl_dma_set_dest(addr, tx2, 0);
+	tx2 = fsl_dma_prep_memcpy(chan, dma_dest, dma_src, test_size / 4, 0);
+	async_tx_ack(tx2);
 
 	/* TX 3 */
-	tx3 = fsl_dma_prep_memcpy(chan, test_size / 4, 0);
-	async_tx_ack(tx3);
-	addr = dma_map_single(fsl_chan->dev, src + test_size * 3 / 4,
+	dma_src = dma_map_single(fsl_chan->dev, src + test_size * 3 / 4,
 					test_size / 4, DMA_TO_DEVICE);
-	fsl_dma_set_src(addr, tx3, 0);
-	addr = dma_map_single(fsl_chan->dev, dest + test_size * 3 / 4,
+	dma_dest = dma_map_single(fsl_chan->dev, dest + test_size * 3 / 4,
 					test_size / 4, DMA_FROM_DEVICE);
-	fsl_dma_set_dest(addr, tx3, 0);
+	tx3 = fsl_dma_prep_memcpy(chan, dma_dest, dma_src, test_size / 4, 0);
+	async_tx_ack(tx3);
 
 	/* Test exchanging the prepared tx sort */
 	cookie = fsl_dma_tx_submit(tx3);


