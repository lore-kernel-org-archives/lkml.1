Return-Path: <linux-kernel-owner+w=401wt.eu-S932069AbZKTHH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932069AbZKTHH1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 02:07:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755502AbZKTHHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 02:07:25 -0500
Received: from mga14.intel.com ([143.182.124.37]:12461 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757148AbZKTHHU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 02:07:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,776,1249282800"; 
   d="scan'208";a="213750612"
Subject: [PATCH 8/8] ioat3: fix pq completion versus channel deallocation race
To: linux-kernel@vger.kernel.org
From: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org, maciej.sosnowski@intel.com
Date: Fri, 20 Nov 2009 00:06:54 -0700
Message-ID: <20091120070654.13478.57156.stgit@dwillia2-linux.ch.intel.com>
In-Reply-To: <20091120070506.13478.77838.stgit@dwillia2-linux.ch.intel.com>
References: <20091120070506.13478.77838.stgit@dwillia2-linux.ch.intel.com>
User-Agent: StGit/0.14.3.289.g7daff
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The completion of a pq operation is notified with a null descriptor
appended to the end of the chain.  This descriptor needs to be visible
to dma clients otherwise the client is precluded from ensuring all
operations are quiesced before freeing channel resources, i.e. due to
descriptor polling it may get the completion notification ahead of the
interrupt delivered by the null descriptor.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dma/ioat/dma_v3.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
index 189788f..e30e0ac 100644
--- a/drivers/dma/ioat/dma_v3.c
+++ b/drivers/dma/ioat/dma_v3.c
@@ -730,7 +730,7 @@ __ioat3_prep_pq_lock(struct dma_chan *c, enum sum_check_flags *result,
 	dump_desc_dbg(ioat, compl_desc);
 
 	/* we leave the channel locked to ensure in order submission */
-	return &desc->txd;
+	return &compl_desc->txd;
 }
 
 static struct dma_async_tx_descriptor *

