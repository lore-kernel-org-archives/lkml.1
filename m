Return-Path: <linux-kernel-owner+w=401wt.eu-S1755696AbZESBAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755696AbZESBAn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 21:00:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754893AbZESA7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 20:59:47 -0400
Received: from mga02.intel.com ([134.134.136.20]:52302 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755257AbZESA7q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 20:59:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,212,1241420400"; 
   d="scan'208";a="516745842"
Subject: [PATCH v2 04/11] async_xor: permit callers to pass in a 'dma/page
	scribble' region
To: neilb@suse.de, linux-raid@vger.kernel.org
From: Dan Williams <dan.j.williams@intel.com>
Cc: maan@systemlinux.org, linux-kernel@vger.kernel.org, yur@emcraft.com,
       hpa@zytor.com
Date: Mon, 18 May 2009 17:59:46 -0700
Message-ID: <20090519005946.4104.28803.stgit@dwillia2-linux.ch.intel.com>
In-Reply-To: <20090519005647.4104.81119.stgit@dwillia2-linux.ch.intel.com>
References: <20090519005647.4104.81119.stgit@dwillia2-linux.ch.intel.com>
User-Agent: StGit/0.14.3.289.g7daff
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

async_xor() needs space to perform dma and page address conversions.  In
most cases the code can simply reuse the struct page * array because the
size of the native pointer matches the size of a dma/page address.  In
order to support archs where sizeof(dma_addr_t) is larger than
sizeof(struct page *), or to preserve the input parameters, we utilize a
memory region passed in by the caller.

Since the code is now prepared to handle the case where it cannot
perform address conversions on the stack, we no longer need the
!HIGHMEM64G dependency in drivers/dma/Kconfig.

[ Impact: don't clobber input buffers for address conversions ]

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 crypto/async_tx/async_xor.c |   59 ++++++++++++++++++++-----------------------
 drivers/dma/Kconfig         |    2 +
 2 files changed, 29 insertions(+), 32 deletions(-)

diff --git a/crypto/async_tx/async_xor.c b/crypto/async_tx/async_xor.c
index 6290d05..3caecdd 100644
--- a/crypto/async_tx/async_xor.c
+++ b/crypto/async_tx/async_xor.c
@@ -33,11 +33,10 @@
 /* do_async_xor - dma map the pages and perform the xor with an engine */
 static __async_inline struct dma_async_tx_descriptor *
 do_async_xor(struct dma_chan *chan, struct page *dest, struct page **src_list,
-	     unsigned int offset, int src_cnt, size_t len,
+	     unsigned int offset, int src_cnt, size_t len, dma_addr_t *dma_src,
 	     struct async_submit_ctl *submit)
 {
 	struct dma_device *dma = chan->device;
-	dma_addr_t *dma_src = (dma_addr_t *) src_list;
 	struct dma_async_tx_descriptor *tx = NULL;
 	int src_off = 0;
 	int i;
@@ -125,9 +124,14 @@ do_sync_xor(struct page *dest, struct page **src_list, unsigned int offset,
 	int xor_src_cnt;
 	int src_off = 0;
 	void *dest_buf;
-	void **srcs = (void **) src_list;
+	void **srcs;
 
-	/* reuse the 'src_list' array to convert to buffer pointers */
+	if (submit->scribble)
+		srcs = (void **) submit->scribble;
+	else
+		srcs = (void **) src_list;
+
+	/* convert to buffer pointers */
 	for (i = 0; i < src_cnt; i++)
 		srcs[i] = page_address(src_list[i]) + offset;
 
@@ -171,17 +175,26 @@ async_xor(struct page *dest, struct page **src_list, unsigned int offset,
 	struct dma_chan *chan = async_tx_find_channel(submit, DMA_XOR,
 						      &dest, 1, src_list,
 						      src_cnt, len);
+	dma_addr_t *dma_src = NULL;
+
 	BUG_ON(src_cnt <= 1);
 
-	if (chan) {
+	if (submit->scribble)
+		dma_src = submit->scribble;
+	else if (sizeof(dma_addr_t) <= sizeof(struct page *))
+		dma_src = (dma_addr_t *) src_list;
+
+	if (dma_src && chan) {
 		/* run the xor asynchronously */
 		pr_debug("%s (async): len: %zu\n", __func__, len);
 
 		return do_async_xor(chan, dest, src_list, offset, src_cnt, len,
-				    submit);
+				    dma_src, submit);
 	} else {
 		/* run the xor synchronously */
 		pr_debug("%s (sync): len: %zu\n", __func__, len);
+		WARN_ONCE(chan, "%s: no space for dma address conversion\n",
+			  __func__);
 
 		/* in the sync case the dest is an implied source
 		 * (assumes the dest is the first source)
@@ -229,11 +242,16 @@ async_xor_val(struct page *dest, struct page **src_list, unsigned int offset,
 						      src_cnt, len);
 	struct dma_device *device = chan ? chan->device : NULL;
 	struct dma_async_tx_descriptor *tx = NULL;
+	dma_addr_t *dma_src = NULL;
 
 	BUG_ON(src_cnt <= 1);
 
-	if (device && src_cnt <= device->max_xor) {
-		dma_addr_t *dma_src = (dma_addr_t *) src_list;
+	if (submit->scribble)
+		dma_src = submit->scribble;
+	else if (sizeof(dma_addr_t) <= sizeof(struct page *))
+		dma_src = (dma_addr_t *) src_list;
+
+	if (dma_src && device && src_cnt <= device->max_xor) {
 		unsigned long dma_prep_flags;
 		int i;
 
@@ -263,6 +281,8 @@ async_xor_val(struct page *dest, struct page **src_list, unsigned int offset,
 		enum async_tx_flags flags_orig = submit->flags;
 
 		pr_debug("%s: (sync) len: %zu\n", __func__, len);
+		WARN_ONCE(device && src_cnt <= device->max_xor,
+			  "%s: no space for dma address conversion\n", __func__);
 
 		submit->flags |= ASYNC_TX_XOR_DROP_DST;
 		submit->flags &= ~ASYNC_TX_ACK;
@@ -281,29 +301,6 @@ async_xor_val(struct page *dest, struct page **src_list, unsigned int offset,
 }
 EXPORT_SYMBOL_GPL(async_xor_val);
 
-static int __init async_xor_init(void)
-{
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
-	return 0;
-}
-
-static void __exit async_xor_exit(void)
-{
-	do { } while (0);
-}
-
-module_init(async_xor_init);
-module_exit(async_xor_exit);
-
 MODULE_AUTHOR("Intel Corporation");
 MODULE_DESCRIPTION("asynchronous xor/xor-zero-sum api");
 MODULE_LICENSE("GPL");
diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index 3b3c01b..912a51b 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -4,7 +4,7 @@
 
 menuconfig DMADEVICES
 	bool "DMA Engine support"
-	depends on !HIGHMEM64G && HAS_DMA
+	depends on HAS_DMA
 	help
 	  DMA engines can do asynchronous data transfers without
 	  involving the host CPU.  Currently, this framework can be

