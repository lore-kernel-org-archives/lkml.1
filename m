Return-Path: <linux-kernel-owner+w=401wt.eu-S1759896AbZCRTVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759896AbZCRTVc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 15:21:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757783AbZCRTUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 15:20:34 -0400
Received: from mga02.intel.com ([134.134.136.20]:16947 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759516AbZCRTU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 15:20:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,385,1233561600"; 
   d="scan'208";a="395601873"
Subject: [PATCH 02/13] async_tx: don't use src_list argument of async_xor()
	for dma addresses
To: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
From: Dan Williams <dan.j.williams@intel.com>
Cc: neilb@suse.de, maciej.sosnowski@intel.com, Yuri Tikhonov <yur@emcraft.com>,
       Ilya Yanok <yanok@emcraft.com>
Date: Wed, 18 Mar 2009 12:20:26 -0700
Message-ID: <20090318192026.20375.3053.stgit@dwillia2-linux.ch.intel.com>
In-Reply-To: <20090318191248.20375.40560.stgit@dwillia2-linux.ch.intel.com>
References: <20090318191248.20375.40560.stgit@dwillia2-linux.ch.intel.com>
User-Agent: StGit/0.14.3.289.g7daff
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yuri Tikhonov <yur@emcraft.com>

Using src_list argument of async_xor() as a storage for dma addresses
implies sizeof(dma_addr_t) <= sizeof(struct page *) restriction which is
not always true (e.g. ppc440spe).

Signed-off-by: Ilya Yanok <yanok@emcraft.com>
Signed-off-by: Yuri Tikhonov <yur@emcraft.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 crypto/async_tx/async_xor.c |   14 ++------------
 1 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/crypto/async_tx/async_xor.c b/crypto/async_tx/async_xor.c
index 595b786..e1f1f28 100644
--- a/crypto/async_tx/async_xor.c
+++ b/crypto/async_tx/async_xor.c
@@ -42,7 +42,7 @@ do_async_xor(struct dma_chan *chan, struct page *dest, struct page **src_list,
 	     dma_async_tx_callback cb_fn, void *cb_param)
 {
 	struct dma_device *dma = chan->device;
-	dma_addr_t *dma_src = (dma_addr_t *) src_list;
+	dma_addr_t dma_src[src_cnt];
 	struct dma_async_tx_descriptor *tx = NULL;
 	int src_off = 0;
 	int i;
@@ -254,7 +254,7 @@ async_xor_zero_sum(struct page *dest, struct page **src_list,
 	BUG_ON(src_cnt <= 1);
 
 	if (device && src_cnt <= device->max_xor) {
-		dma_addr_t *dma_src = (dma_addr_t *) src_list;
+		dma_addr_t dma_src[src_cnt];
 		unsigned long dma_prep_flags = cb_fn ? DMA_PREP_INTERRUPT : 0;
 		int i;
 
@@ -303,16 +303,6 @@ EXPORT_SYMBOL_GPL(async_xor_zero_sum);
 
 static int __init async_xor_init(void)
 {
-	#ifdef CONFIG_DMA_ENGINE
-	/* To conserve stack space the input src_list (array of page pointers)
-	 * is reused to hold the array of dma addresses passed to the driver.
-	 * This conversion is only possible when dma_addr_t is less than the
-	 * the size of a pointer.  HIGHMEM64G is known to violate this
-	 * assumption.
-	 */
-	BUILD_BUG_ON(sizeof(dma_addr_t) > sizeof(struct page *));
-	#endif
-
 	return 0;
 }
 

