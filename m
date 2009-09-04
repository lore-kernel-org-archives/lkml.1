Return-Path: <linux-kernel-owner+w=401wt.eu-S932887AbZIDCeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932887AbZIDCeu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 22:34:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932773AbZIDCcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 22:32:24 -0400
Received: from mga11.intel.com ([192.55.52.93]:52747 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932762AbZIDCcU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 22:32:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,329,1249282800"; 
   d="scan'208";a="490400530"
Subject: [PATCH 22/29] net_dma: poll for a descriptor after allocation failure
To: linux-kernel@vger.kernel.org
From: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org, netdev@vger.kernel.org,
       maciej.sosnowski@intel.com
Date: Thu, 03 Sep 2009 19:32:22 -0700
Message-ID: <20090904023221.32667.70000.stgit@dwillia2-linux.ch.intel.com>
In-Reply-To: <20090904022733.32667.77626.stgit@dwillia2-linux.ch.intel.com>
References: <20090904022733.32667.77626.stgit@dwillia2-linux.ch.intel.com>
User-Agent: StGit/0.14.3.289.g7daff
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Handle descriptor allocation failures by polling for a descriptor.  The
driver will force forward progress when polled.  In the best case this
polling interval will be the time it takes for one dma memcpy
transaction to complete.  In the worst case, channel hang, we will need
to wait 100ms for the cleanup watchdog to fire (ioatdma driver).

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dma/iovlock.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/iovlock.c b/drivers/dma/iovlock.c
index 9f6fe46..c0a272c 100644
--- a/drivers/dma/iovlock.c
+++ b/drivers/dma/iovlock.c
@@ -183,6 +183,11 @@ dma_cookie_t dma_memcpy_to_iovec(struct dma_chan *chan, struct iovec *iov,
 					iov_byte_offset,
 					kdata,
 					copy);
+			/* poll for a descriptor slot */
+			if (unlikely(dma_cookie < 0)) {
+				dma_async_issue_pending(chan);
+				continue;
+			}
 
 			len -= copy;
 			iov[iovec_idx].iov_len -= copy;
@@ -248,6 +253,11 @@ dma_cookie_t dma_memcpy_pg_to_iovec(struct dma_chan *chan, struct iovec *iov,
 					page,
 					offset,
 					copy);
+			/* poll for a descriptor slot */
+			if (unlikely(dma_cookie < 0)) {
+				dma_async_issue_pending(chan);
+				continue;
+			}
 
 			len -= copy;
 			iov[iovec_idx].iov_len -= copy;

