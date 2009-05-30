Return-Path: <linux-kernel-owner+w=401wt.eu-S1755530AbZE3ATr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530AbZE3ATr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 20:19:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753086AbZE3ATk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 20:19:40 -0400
Received: from mga14.intel.com ([143.182.124.37]:46618 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753002AbZE3ATj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 20:19:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,273,1241420400"; 
   d="scan'208";a="148564092"
Subject: [git pull] dmaengine fixes for 2.6.30-rc8
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: "Ira W. Snyder" <iws@ovro.caltech.edu>, Li Yang <leoli@freescale.com>,
       Roel Kluin <roel.kluin@gmail.com>,
       Kumar Gala <galak@kernel.crashing.org>, linuxppc-dev@ozlabs.org,
       Maciej Sosnowski <maciej.sosnowski@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 29 May 2009 17:19:40 -0700
Message-Id: <1243642780.22337.10.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus, please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/async_tx.git fixes

...to receive:

Ira Snyder (4):
      fsldma: fix "DMA halt timeout!" errors
      fsldma: fix infinite loop on multi-descriptor DMA chain completion
      fsldma: snooping is not enabled for last entry in descriptor chain
      fsldma: fix memory leak on error path in fsl_dma_prep_memcpy()

Kumar Gala (1):
      fsldma: Fix compile warnings

Li Yang (1):
      fsldma: update mailling list address in MAINTAINERS

Roel Kluin (1):
      fsldma: fix check on potential fdev->chan[] overflow

 MAINTAINERS          |    2 +-
 drivers/dma/fsldma.c |   71 +++++++++++++++++++++++++++++++++-----------------
 2 files changed, 48 insertions(+), 25 deletions(-)

This is a collection of fsldma fixes primarily from Ira that have come
through Li Yang, fsldma maintainer.  I took the fix from Kumar as
obviously correct.  It has been in linux-next for at least one release.

Thanks,
Dan

commit b787f2e2a37a373a045f4d9b9bed941ccff01663
Author: Kumar Gala <galak@kernel.crashing.org>
Date:   Wed May 13 16:25:57 2009 -0500

    fsldma: Fix compile warnings
    
    We we build with dma_addr_t as a 64-bit quantity we get:
    
    drivers/dma/fsldma.c: In function 'fsl_chan_xfer_ld_queue':
    drivers/dma/fsldma.c:625: warning: cast to pointer from integer of different size
    drivers/dma/fsldma.c: In function 'fsl_dma_chan_do_interrupt':
    drivers/dma/fsldma.c:737: warning: cast to pointer from integer of different size
    drivers/dma/fsldma.c:737: warning: cast to pointer from integer of different size
    drivers/dma/fsldma.c: In function 'of_fsl_dma_probe':
    drivers/dma/fsldma.c:927: warning: cast to pointer from integer of different
    
    Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 2e077f8e8337e52eef3c39c24c31e103b11a0326
Author: Ira Snyder <iws@ovro.caltech.edu>
Date:   Fri May 15 09:59:46 2009 -0700

    fsldma: fix memory leak on error path in fsl_dma_prep_memcpy()
    
    When preparing a memcpy operation, if the kernel fails to allocate memory
    for a link descriptor after the first link descriptor has already been
    allocated, then some memory will never be released. Fix the problem by
    walking the list of allocated descriptors backwards, and freeing the
    allocated descriptors back into the DMA pool.
    
    Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
    Signed-off-by: Li Yang <leoli@freescale.com>

commit 776c8943f2766f2819fafd88fdfbaf418ecd6e41
Author: Ira Snyder <iws@ovro.caltech.edu>
Date:   Fri May 15 11:33:20 2009 -0700

    fsldma: snooping is not enabled for last entry in descriptor chain
    
    On the 83xx controller, snooping is necessary for the DMA controller to
    ensure cache coherence with the CPU when transferring to/from RAM.
    
    The last descriptor in a chain will always have the End-of-Chain interrupt
    bit set, so we can set the snoop bit while adding the End-of-Chain
    interrupt bit.
    
    Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
    Signed-off-by: Li Yang <leoli@freescale.com>

commit bcfb7465c03a8c62c89da374677df56f6b894d44
Author: Ira Snyder <iws@ovro.caltech.edu>
Date:   Fri May 15 14:27:16 2009 -0700

    fsldma: fix infinite loop on multi-descriptor DMA chain completion
    
    When creating a DMA transaction with multiple descriptors, the async_tx
    cookie is set to 0 for each descriptor in the chain, excluding the last
    descriptor, whose cookie is set to -EBUSY.
    
    When fsl_dma_tx_submit() is run, it only assigns a cookie to the first
    descriptor. All of the remaining descriptors keep their original value,
    including the last descriptor, which is set to -EBUSY.
    
    After the DMA completes, the driver will update the last completed cookie
    to be -EBUSY, which is an error code instead of a valid cookie. This causes
    dma_async_is_complete() to always return DMA_IN_PROGRESS.
    
    This causes the fsldma driver to never cleanup the queue of link
    descriptors, and the driver will re-run the DMA transaction on the hardware
    each time it receives the End-of-Chain interrupt. This causes an infinite
    loop.
    
    With this patch, fsl_dma_tx_submit() is changed to assign a cookie to every
    descriptor in the chain. The rest of the code then works without problems.
    
    Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
    Signed-off-by: Li Yang <leoli@freescale.com>

commit 138ef0185177a6d221d24b6aa8f12d867fbbef90
Author: Ira Snyder <iws@ovro.caltech.edu>
Date:   Tue May 19 15:42:13 2009 -0700

    fsldma: fix "DMA halt timeout!" errors
    
    When using the DMA controller from multiple threads at the same time, it is
    possible to get lots of "DMA halt timeout!" errors printed to the kernel
    log.
    
    This occurs due to a race between fsl_dma_memcpy_issue_pending() and the
    interrupt handler, fsl_dma_chan_do_interrupt(). Both call the
    fsl_chan_xfer_ld_queue() function, which does not protect against
    concurrent accesses to dma_halt() and dma_start().
    
    The existing spinlock is moved to cover the dma_halt() and dma_start()
    functions. Testing shows that the "DMA halt timeout!" errors disappear.
    
    Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
    Signed-off-by: Li Yang <leoli@freescale.com>

commit f47edc6dab11801c2e97088ba7bbce042ded867c
Author: Roel Kluin <roel.kluin@gmail.com>
Date:   Fri May 22 16:46:52 2009 +0800

    fsldma: fix check on potential fdev->chan[] overflow
    
    Fix the check of potential array overflow when using corrupted channel
    device tree nodes.
    
    Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
    Signed-off-by: Li Yang <leoli@freescale.com>

commit 0899d6349c60e4021224b51c8c97f49b829dfefd
Author: Li Yang <leoli@freescale.com>
Date:   Fri May 22 16:39:59 2009 +0800

    fsldma: update mailling list address in MAINTAINERS
    
    linuxppc-embedded has been merged into linuxppc-dev.
    
    Signed-off-by: Li Yang <leoli@freescale.com>

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
index da8a8ed..f18d1bd 100644
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
@@ -313,8 +318,8 @@ static void fsl_chan_toggle_ext_start(struct fsl_dma_chan *fsl_chan, int enable)
 
 static dma_cookie_t fsl_dma_tx_submit(struct dma_async_tx_descriptor *tx)
 {
-	struct fsl_desc_sw *desc = tx_to_fsl_desc(tx);
 	struct fsl_dma_chan *fsl_chan = to_fsl_chan(tx->chan);
+	struct fsl_desc_sw *desc;
 	unsigned long flags;
 	dma_cookie_t cookie;
 
@@ -322,14 +327,17 @@ static dma_cookie_t fsl_dma_tx_submit(struct dma_async_tx_descriptor *tx)
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
@@ -598,15 +618,16 @@ static void fsl_chan_xfer_ld_queue(struct fsl_dma_chan *fsl_chan)
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
@@ -617,19 +638,20 @@ static void fsl_chan_xfer_ld_queue(struct fsl_dma_chan *fsl_chan)
 				fsl_chan->common.cookie) == DMA_SUCCESS);
 		ld_node = ld_node->next);
 
-	spin_unlock_irqrestore(&fsl_chan->desc_lock, flags);
-
 	if (ld_node != &fsl_chan->ld_queue) {
 		/* Get the ld start address from ld_queue */
 		next_dest_addr = to_fsl_desc(ld_node)->async_tx.phys;
-		dev_dbg(fsl_chan->dev, "xfer LDs staring from %p\n",
-				(void *)next_dest_addr);
+		dev_dbg(fsl_chan->dev, "xfer LDs staring from 0x%llx\n",
+				(unsigned long long)next_dest_addr);
 		set_cdar(fsl_chan, next_dest_addr);
 		dma_start(fsl_chan);
 	} else {
 		set_cdar(fsl_chan, 0);
 		set_ndar(fsl_chan, 0);
 	}
+
+out_unlock:
+	spin_unlock_irqrestore(&fsl_chan->desc_lock, flags);
 }
 
 /**
@@ -734,8 +756,9 @@ static irqreturn_t fsl_dma_chan_do_interrupt(int irq, void *data)
 	 */
 	if (stat & FSL_DMA_SR_EOSI) {
 		dev_dbg(fsl_chan->dev, "event: End-of-segments INT\n");
-		dev_dbg(fsl_chan->dev, "event: clndar %p, nlndar %p\n",
-			(void *)get_cdar(fsl_chan), (void *)get_ndar(fsl_chan));
+		dev_dbg(fsl_chan->dev, "event: clndar 0x%llx, nlndar 0x%llx\n",
+			(unsigned long long)get_cdar(fsl_chan),
+			(unsigned long long)get_ndar(fsl_chan));
 		stat &= ~FSL_DMA_SR_EOSI;
 		update_cookie = 1;
 	}
@@ -830,7 +853,7 @@ static int __devinit fsl_dma_chan_probe(struct fsl_dma_device *fdev,
 			new_fsl_chan->reg.end - new_fsl_chan->reg.start + 1);
 
 	new_fsl_chan->id = ((new_fsl_chan->reg.start - 0x100) & 0xfff) >> 7;
-	if (new_fsl_chan->id > FSL_DMA_MAX_CHANS_PER_DEVICE) {
+	if (new_fsl_chan->id >= FSL_DMA_MAX_CHANS_PER_DEVICE) {
 		dev_err(fdev->dev, "There is no %d channel!\n",
 				new_fsl_chan->id);
 		err = -EINVAL;
@@ -925,8 +948,8 @@ static int __devinit of_fsl_dma_probe(struct of_device *dev,
 	}
 
 	dev_info(&dev->dev, "Probe the Freescale DMA driver for %s "
-			"controller at %p...\n",
-			match->compatible, (void *)fdev->reg.start);
+			"controller at 0x%llx...\n",
+			match->compatible, (unsigned long long)fdev->reg.start);
 	fdev->reg_base = ioremap(fdev->reg.start, fdev->reg.end
 						- fdev->reg.start + 1);
 


