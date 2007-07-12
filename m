Return-Path: <linux-kernel-owner+w=401wt.eu-S934886AbXGLPvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934886AbXGLPvY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 11:51:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758339AbXGLPvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 11:51:11 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:27912 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758288AbXGLPvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 11:51:09 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>
Subject: [PATCH 05/10] IB/ehca: use #define for "pages per register_rpage" instead of hardcoded value
User-Agent: KMail/1.8.2
Cc: "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
References: <200707121745.27592.fenkes@de.ibm.com>
In-Reply-To: <200707121745.27592.fenkes@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 25418
Date: Thu, 12 Jul 2007 17:51:04 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200707121751.05587.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hoang-Nam Nguyen <hnguyen@de.ibm.com>

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_mrmw.c |   19 +++++++++++--------
 1 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_mrmw.c b/drivers/infiniband/hw/ehca/ehca_mrmw.c
index 7c1656a..1fe4f72 100644
--- a/drivers/infiniband/hw/ehca/ehca_mrmw.c
+++ b/drivers/infiniband/hw/ehca/ehca_mrmw.c
@@ -48,6 +48,9 @@
 #include "hcp_if.h"
 #include "hipz_hw.h"
 
+/* max number of rpages (per hcall register_rpages) */
+#define MAX_RPAGES 512
+
 static struct kmem_cache *mr_cache;
 static struct kmem_cache *mw_cache;
 
@@ -1027,14 +1030,14 @@ int ehca_reg_mr_rpages(struct ehca_shca *shca,
 	}
 
 	/* max 512 pages per shot */
-	for (i = 0; i < ((pginfo->num_4k + 512 - 1) / 512); i++) {
+	for (i = 0; i < ((pginfo->num_4k + MAX_RPAGES - 1) / MAX_RPAGES); i++) {
 
-		if (i == ((pginfo->num_4k + 512 - 1) / 512) - 1) {
-			rnum = pginfo->num_4k % 512; /* last shot */
+		if (i == ((pginfo->num_4k + MAX_RPAGES - 1) / MAX_RPAGES) - 1) {
+			rnum = pginfo->num_4k % MAX_RPAGES; /* last shot */
 			if (rnum == 0)
-				rnum = 512;      /* last shot is full */
+				rnum = MAX_RPAGES;      /* last shot is full */
 		} else
-			rnum = 512;
+			rnum = MAX_RPAGES;
 
 		if (rnum > 1) {
 			ret = ehca_set_pagebuf(e_mr, pginfo, rnum, kpage);
@@ -1066,7 +1069,7 @@ int ehca_reg_mr_rpages(struct ehca_shca *shca,
 						 0, /* pagesize 4k */
 						 0, rpage, rnum);
 
-		if (i == ((pginfo->num_4k + 512 - 1) / 512) - 1) {
+		if (i == ((pginfo->num_4k + MAX_RPAGES - 1) / MAX_RPAGES) - 1) {
 			/*
 			 * check for 'registration complete'==H_SUCCESS
 			 * and for 'page registered'==H_PAGE_REGISTERED
@@ -1215,7 +1218,7 @@ int ehca_rereg_mr(struct ehca_shca *shca,
 	int rereg_3_hcall = 0; /* 1: use 3 hipz calls for reregistration */
 
 	/* first determine reregistration hCall(s) */
-	if ((pginfo->num_4k > 512) || (e_mr->num_4k > 512) ||
+	if ((pginfo->num_4k > MAX_RPAGES) || (e_mr->num_4k > MAX_RPAGES) ||
 	    (pginfo->num_4k > e_mr->num_4k)) {
 		ehca_dbg(&shca->ib_device, "Rereg3 case, pginfo->num_4k=%lx "
 			 "e_mr->num_4k=%x", pginfo->num_4k, e_mr->num_4k);
@@ -1306,7 +1309,7 @@ int ehca_unmap_one_fmr(struct ehca_shca *shca,
 	struct ehca_mr_hipzout_parms hipzout = {{0},0,0,0,0,0};
 
 	/* first check if reregistration hCall can be used for unmap */
-	if (e_fmr->fmr_max_pages > 512) {
+	if (e_fmr->fmr_max_pages > MAX_RPAGES) {
 		rereg_1_hcall = 0;
 		rereg_3_hcall = 1;
 	}
-- 
1.5.2


