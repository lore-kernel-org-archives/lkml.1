Return-Path: <linux-kernel-owner+w=401wt.eu-S932688AbZIDGpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932688AbZIDGpn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 02:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932654AbZIDGpj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 02:45:39 -0400
Received: from mga09.intel.com ([134.134.136.24]:12570 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756668AbZIDGpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 02:45:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,330,1249282800"; 
   d="scan'208";a="547726321"
Subject: [PATCH 05/18] ioat2+: add fence support
To: linux-kernel@vger.kernel.org
From: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org, maciej.sosnowski@intel.com
Date: Thu, 03 Sep 2009 23:45:00 -0700
Message-ID: <20090904064500.7141.60154.stgit@dwillia2-linux.ch.intel.com>
In-Reply-To: <20090904064308.7141.30576.stgit@dwillia2-linux.ch.intel.com>
References: <20090904064308.7141.30576.stgit@dwillia2-linux.ch.intel.com>
User-Agent: StGit/0.14.3.289.g7daff
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for adding more operation types to the ioat3 path the
driver needs to honor the DMA_PREP_FENCE flag.  For example the async_tx api
will hand xor->memcpy->xor chains to the driver with the 'fence' flag set on
the first xor and the memcpy operation.  This flag in turn sets the 'fence'
flag in the descriptor control field telling the hardware that future
descriptors in the chain depend on the result of the current descriptor, so
wait for all writes to complete before starting the next operation.

Note that ioat1 does not prefetch the descriptor chain, so does not
require/support fenced operations.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dma/ioat/dma_v2.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/ioat/dma_v2.c b/drivers/dma/ioat/dma_v2.c
index c4d8a6a..b3a1f81 100644
--- a/drivers/dma/ioat/dma_v2.c
+++ b/drivers/dma/ioat/dma_v2.c
@@ -711,6 +711,7 @@ ioat2_dma_prep_memcpy_lock(struct dma_chan *c, dma_addr_t dma_dest,
 	desc->txd.flags = flags;
 	desc->len = total_len;
 	hw->ctl_f.int_en = !!(flags & DMA_PREP_INTERRUPT);
+	hw->ctl_f.fence = !!(flags & DMA_PREP_FENCE);
 	hw->ctl_f.compl_write = 1;
 	dump_desc_dbg(ioat, desc);
 	/* we leave the channel locked to ensure in order submission */

