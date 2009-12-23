Return-Path: <linux-kernel-owner+w=401wt.eu-S1755324AbZLWA1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324AbZLWA1Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 19:27:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753299AbZLWA1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 19:27:10 -0500
Received: from mga01.intel.com ([192.55.52.88]:49511 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751548AbZLWA1H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 19:27:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,438,1257148800"; 
   d="scan'208";a="525596091"
From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 1/3] ioat3: fix p-disabled q-continuation
To: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: maciej.sosnowski@intel.com, <stable@kernel.org>,
       Dan Williams <dan.j.williams@intel.com>
Date: Tue, 22 Dec 2009 17:25:55 -0700
Message-ID: <20091223002555.32335.85860.stgit@dwillia2-linux.ch.intel.com>
In-Reply-To: <20091223002518.32335.27768.stgit@dwillia2-linux.ch.intel.com>
References: <20091223002518.32335.27768.stgit@dwillia2-linux.ch.intel.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When continuing a pq calculation the driver needs 3 extra sources.  The
driver can perform a 3 source calculation with a single descriptor, but
needs an extended descriptor to process up to 8 sources in one
operation.  However, in the p-disabled case only one extra source is
needed.  When continuing a p-disabled operation there are occasions
(i.e. 0 < src_cnt % 8 < 3) where the tail operation does not need an
extended descriptor.  Properly account for this fact otherwise invalid
'dmacount' values will be written to hardware usually causing the
channel to halt with 'invalid descriptor' errors.

Cc: <stable@kernel.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 drivers/dma/ioat/dma_v3.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
index 42f6f10..e58ecb2 100644
--- a/drivers/dma/ioat/dma_v3.c
+++ b/drivers/dma/ioat/dma_v3.c
@@ -650,9 +650,11 @@ __ioat3_prep_pq_lock(struct dma_chan *c, enum sum_check_flags *result,
 
 	num_descs = ioat2_xferlen_to_descs(ioat, len);
 	/* we need 2x the number of descriptors to cover greater than 3
-	 * sources
+	 * sources (we need 1 extra source in the q-only continuation
+	 * case and 3 extra sources in the p+q continuation case.
 	 */
-	if (src_cnt > 3 || flags & DMA_PREP_CONTINUE) {
+	if (src_cnt + dmaf_p_disabled_continue(flags) > 3 ||
+	    (dmaf_continue(flags) && !dmaf_p_disabled_continue(flags))) {
 		with_ext = 1;
 		num_descs *= 2;
 	} else

