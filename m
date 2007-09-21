Return-Path: <linux-kernel-owner+w=401wt.eu-S1755816AbXIUB2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816AbXIUB2Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 21:28:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754800AbXIUB1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 21:27:51 -0400
Received: from mga01.intel.com ([192.55.52.88]:13952 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754182AbXIUB1q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 21:27:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,280,1186383600"; 
   d="scan'208";a="316022770"
From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 2.6.23-rc7 2/3] async_tx: fix dma_wait_for_async_tx
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.de
Cc: akpm@linux-foundation.org, yur@emcraft.com, saeed.bishara@gmail.com,
       shannon.nelson@intel.com
Date: Thu, 20 Sep 2007 18:27:45 -0700
Message-ID: <20070921012745.17157.18043.stgit@dwillia2-linux.ch.intel.com>
In-Reply-To: <20070921012141.17157.65717.stgit@dwillia2-linux.ch.intel.com>
References: <20070921012141.17157.65717.stgit@dwillia2-linux.ch.intel.com>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix dma_wait_for_async_tx to not loop forever in the case where a
dependency chain is longer than two entries.  This condition will not
happen with current in-kernel drivers, but fix it for future drivers.

Found-by: Saeed Bishara <saeed.bishara@gmail.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 crypto/async_tx/async_tx.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/crypto/async_tx/async_tx.c b/crypto/async_tx/async_tx.c
index 0350071..bc18cbb 100644
--- a/crypto/async_tx/async_tx.c
+++ b/crypto/async_tx/async_tx.c
@@ -80,6 +80,7 @@ dma_wait_for_async_tx(struct dma_async_tx_descriptor *tx)
 {
 	enum dma_status status;
 	struct dma_async_tx_descriptor *iter;
+	struct dma_async_tx_descriptor *parent;
 
 	if (!tx)
 		return DMA_SUCCESS;
@@ -87,8 +88,15 @@ dma_wait_for_async_tx(struct dma_async_tx_descriptor *tx)
 	/* poll through the dependency chain, return when tx is complete */
 	do {
 		iter = tx;
-		while (iter->cookie == -EBUSY)
-			iter = iter->parent;
+
+		/* find the root of the unsubmitted dependency chain */
+		while (iter->cookie == -EBUSY) {
+			parent = iter->parent;
+			if (parent && parent->cookie == -EBUSY)
+				iter = iter->parent;
+			else
+				break;
+		}
 
 		status = dma_sync_wait(iter->chan, iter->cookie);
 	} while (status == DMA_IN_PROGRESS || (iter != tx));
