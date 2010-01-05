Return-Path: <linux-kernel-owner+w=401wt.eu-S1754939Ab0AEAum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939Ab0AEAum (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:50:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755134Ab0AEAuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:50:06 -0500
Received: from kroah.org ([198.145.64.141]:34225 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754291Ab0AEAfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:35:09 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Dan Williams <dan.j.williams@intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 35/97] ioat3: fix p-disabled q-continuation
Date: Mon,  4 Jan 2010 16:32:48 -0800
Message-Id: <1262651630-7354-35-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Williams <dan.j.williams@intel.com>

commit cd78809f6191485a90ea6c92c2b58900ab5c156f upstream.

When continuing a pq calculation the driver needs 3 extra sources.  The
driver can perform a 3 source calculation with a single descriptor, but
needs an extended descriptor to process up to 8 sources in one
operation.  However, in the p-disabled case only one extra source is
needed.  When continuing a p-disabled operation there are occasions
(i.e. 0 < src_cnt % 8 < 3) where the tail operation does not need an
extended descriptor.  Properly account for this fact otherwise invalid
'dmacount' values will be written to hardware usually causing the
channel to halt with 'invalid descriptor' errors.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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
-- 
1.6.6

