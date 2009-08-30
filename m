Return-Path: <linux-kernel-owner+w=401wt.eu-S1753272AbZH3CbL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272AbZH3CbL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 22:31:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753269AbZH3CbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 22:31:08 -0400
Received: from mga03.intel.com ([143.182.124.21]:13436 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752360AbZH3CbF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 22:31:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,271,1249282800"; 
   d="scan'208";a="182006404"
Subject: [PATCH v3 13/14] dmatest: add pq support
To: neilb@suse.de
From: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org, Andre Noll <maan@systemlinux.org>,
       Maciej Sosnowski <maciej.sosnowski@intel.com>,
       linux-kernel@vger.kernel.org
Date: Sat, 29 Aug 2009 19:31:07 -0700
Message-ID: <20090830023107.5934.16509.stgit@dwillia2-linux.ch.intel.com>
In-Reply-To: <20090830022908.5934.72142.stgit@dwillia2-linux.ch.intel.com>
References: <20090830022908.5934.72142.stgit@dwillia2-linux.ch.intel.com>
User-Agent: StGit/0.14.3.289.g7daff
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Test raid6 p+q operations with a simple "always multiply by 1" q
calculation to fit into dmatest's current destination verification
scheme.

Reviewed-by: Andre Noll <maan@systemlinux.org>
Acked-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dma/dmatest.c |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index a27c0fb..a5ee541 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -43,6 +43,11 @@ module_param(xor_sources, uint, S_IRUGO);
 MODULE_PARM_DESC(xor_sources,
 		"Number of xor source buffers (default: 3)");
 
+static unsigned int pq_sources = 3;
+module_param(pq_sources, uint, S_IRUGO);
+MODULE_PARM_DESC(pq_sources,
+		"Number of p+q source buffers (default: 3)");
+
 /*
  * Initialization patterns. All bytes in the source buffer has bit 7
  * set, all bytes in the destination buffer has bit 7 cleared.
@@ -227,6 +232,7 @@ static int dmatest_func(void *data)
 	dma_cookie_t		cookie;
 	enum dma_status		status;
 	enum dma_ctrl_flags 	flags;
+	u8			pq_coefs[pq_sources];
 	int			ret;
 	int			src_cnt;
 	int			dst_cnt;
@@ -243,6 +249,11 @@ static int dmatest_func(void *data)
 	else if (thread->type == DMA_XOR) {
 		src_cnt = xor_sources | 1; /* force odd to ensure dst = src */
 		dst_cnt = 1;
+	} else if (thread->type == DMA_PQ) {
+		src_cnt = pq_sources | 1; /* force odd to ensure dst = src */
+		dst_cnt = 2;
+		for (i = 0; i < pq_sources; i++)
+			pq_coefs[i] = 1;
 	} else
 		goto err_srcs;
 
@@ -310,6 +321,15 @@ static int dmatest_func(void *data)
 						      dma_dsts[0] + dst_off,
 						      dma_srcs, xor_sources,
 						      len, flags);
+		else if (thread->type == DMA_PQ) {
+			dma_addr_t dma_pq[dst_cnt];
+
+			for (i = 0; i < dst_cnt; i++)
+				dma_pq[i] = dma_dsts[i] + dst_off;
+			tx = dev->device_prep_dma_pq(chan, dma_pq, dma_srcs,
+						     pq_sources, pq_coefs,
+						     len, flags);
+		}
 
 		if (!tx) {
 			for (i = 0; i < src_cnt; i++)
@@ -446,6 +466,8 @@ static int dmatest_add_threads(struct dmatest_chan *dtc, enum dma_transaction_ty
 		op = "copy";
 	else if (type == DMA_XOR)
 		op = "xor";
+	else if (type == DMA_PQ)
+		op = "pq";
 	else
 		return -EINVAL;
 
@@ -501,6 +523,10 @@ static int dmatest_add_channel(struct dma_chan *chan)
 		cnt = dmatest_add_threads(dtc, DMA_XOR);
 		thread_count += cnt > 0 ?: 0;
 	}
+	if (dma_has_cap(DMA_PQ, dma_dev->cap_mask)) {
+		cnt = dmatest_add_threads(dtc, DMA_PQ);
+		thread_count += cnt > 0 ?: 0;
+	}
 
 	pr_info("dmatest: Started %u threads using %s\n",
 		thread_count, dma_chan_name(chan));

