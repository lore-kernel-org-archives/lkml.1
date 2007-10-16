Return-Path: <linux-kernel-owner+w=401wt.eu-S934402AbXJPP1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934402AbXJPP1P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 11:27:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933211AbXJPP06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 11:26:58 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:6276 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932831AbXJPP05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 11:26:57 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       "OF-EWG" <ewg@lists.openfabrics.org>
Subject: [PATCH 3/5] IB/ehca: Fix ehca_encode_hwpage_size() and alloc_fmr()
User-Agent: KMail/1.9.1
Cc: Roland Dreier <rolandd@cisco.com>, "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
References: <200710161722.29144.fenkes@de.ibm.com>
In-Reply-To: <200710161722.29144.fenkes@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 1982
Date: Tue, 16 Oct 2007 17:26:54 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200710161726.54648.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify ehca_encode_hwpage_size(), fixing an infinite loop for pgsize == 0
in the process. Fix the bug in alloc_fmr() that triggered the loop.

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_mrmw.c |   15 ++++-----------
 1 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_mrmw.c b/drivers/infiniband/hw/ehca/ehca_mrmw.c
index 16c9efd..b9a788c 100644
--- a/drivers/infiniband/hw/ehca/ehca_mrmw.c
+++ b/drivers/infiniband/hw/ehca/ehca_mrmw.c
@@ -72,17 +72,9 @@ enum ehca_mr_pgsize {
 
 static u32 ehca_encode_hwpage_size(u32 pgsize)
 {
-	u32 idx = 0;
-	pgsize >>= 12;
-	/*
-	 * map mr page size into hw code:
-	 * 0, 1, 2, 3 for 4K, 64K, 1M, 64M
-	 */
-	while (!(pgsize & 1)) {
-		idx++;
-		pgsize >>= 4;
-	}
-	return idx;
+	int log = ilog2(pgsize);
+	WARN_ON(log < 12 || log > 24 || log & 3);
+	return (log - 12) / 4;
 }
 
 static u64 ehca_get_max_hwpage_size(struct ehca_shca *shca)
@@ -826,6 +818,7 @@ struct ib_fmr *ehca_alloc_fmr(struct ib_pd *pd,
 
 	/* register MR on HCA */
 	memset(&pginfo, 0, sizeof(pginfo));
+	pginfo.hwpage_size = hw_pgsize;
 	/*
 	 * pginfo.num_hwpages==0, ie register_rpages() will not be called
 	 * but deferred to map_phys_fmr()
-- 
1.5.2


