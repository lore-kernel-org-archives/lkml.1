Return-Path: <linux-kernel-owner+w=401wt.eu-S1756625AbZKTHGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625AbZKTHGi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 02:06:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755540AbZKTHGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 02:06:37 -0500
Received: from mga02.intel.com ([134.134.136.20]:36615 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756379AbZKTHGe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 02:06:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,776,1249282800"; 
   d="scan'208";a="571400405"
Subject: [PATCH 5/8] ioat2,3: report all uncorrectable errors
To: linux-kernel@vger.kernel.org
From: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org, maciej.sosnowski@intel.com
Date: Fri, 20 Nov 2009 00:06:39 -0700
Message-ID: <20091120070639.13478.27278.stgit@dwillia2-linux.ch.intel.com>
In-Reply-To: <20091120070506.13478.77838.stgit@dwillia2-linux.ch.intel.com>
References: <20091120070506.13478.77838.stgit@dwillia2-linux.ch.intel.com>
User-Agent: StGit/0.14.3.289.g7daff
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modify is_ioat_bug() to catch all errors that are uncorrectable, or not
currently handled.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dma/ioat/dma.h    |    4 +---
 drivers/dma/ioat/dma_v2.c |    2 ++
 drivers/dma/ioat/dma_v3.c |    2 ++
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/ioat/dma.h b/drivers/dma/ioat/dma.h
index c14fdfe..45edde9 100644
--- a/drivers/dma/ioat/dma.h
+++ b/drivers/dma/ioat/dma.h
@@ -297,9 +297,7 @@ static inline bool is_ioat_suspended(unsigned long status)
 /* channel was fatally programmed */
 static inline bool is_ioat_bug(unsigned long err)
 {
-	return !!(err & (IOAT_CHANERR_SRC_ADDR_ERR|IOAT_CHANERR_DEST_ADDR_ERR|
-			 IOAT_CHANERR_NEXT_ADDR_ERR|IOAT_CHANERR_CONTROL_ERR|
-			 IOAT_CHANERR_LENGTH_ERR));
+	return !!err;
 }
 
 static inline void ioat_unmap(struct pci_dev *pdev, dma_addr_t addr, size_t len,
diff --git a/drivers/dma/ioat/dma_v2.c b/drivers/dma/ioat/dma_v2.c
index 96ffab7..8f1f7f0 100644
--- a/drivers/dma/ioat/dma_v2.c
+++ b/drivers/dma/ioat/dma_v2.c
@@ -279,6 +279,8 @@ void ioat2_timer_event(unsigned long data)
 			u32 chanerr;
 
 			chanerr = readl(chan->reg_base + IOAT_CHANERR_OFFSET);
+			dev_err(to_dev(chan), "%s: Channel halted (%x)\n",
+				__func__, chanerr);
 			BUG_ON(is_ioat_bug(chanerr));
 		}
 
diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
index fad2e9f..252cf2d 100644
--- a/drivers/dma/ioat/dma_v3.c
+++ b/drivers/dma/ioat/dma_v3.c
@@ -378,6 +378,8 @@ static void ioat3_timer_event(unsigned long data)
 			u32 chanerr;
 
 			chanerr = readl(chan->reg_base + IOAT_CHANERR_OFFSET);
+			dev_err(to_dev(chan), "%s: Channel halted (%x)\n",
+				__func__, chanerr);
 			BUG_ON(is_ioat_bug(chanerr));
 		}
 

