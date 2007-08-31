Return-Path: <linux-kernel-owner+w=401wt.eu-S965742AbXHaODS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965742AbXHaODS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 10:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965323AbXHaODF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 10:03:05 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:36341 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965320AbXHaODC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 10:03:02 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>
Subject: [PATCH 1/2] IB/ehca: fix Small QP regressions
Date: Fri, 31 Aug 2007 16:02:59 +0200
User-Agent: KMail/1.8.2
Cc: "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
References: <200708311601.42220.fenkes@de.ibm.com>
In-Reply-To: <200708311601.42220.fenkes@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708311602.59890.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Roscher <stefan.roscher@de.ibm.com>

The new Small QP code had a few bugs that would also trigger for non-Small
QPs. Fix them.

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_qp.c   |   10 ++++++----
 drivers/infiniband/hw/ehca/ipz_pt_fn.c |    2 +-
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_qp.c b/drivers/infiniband/hw/ehca/ehca_qp.c
index b178cba..84d435a 100644
--- a/drivers/infiniband/hw/ehca/ehca_qp.c
+++ b/drivers/infiniband/hw/ehca/ehca_qp.c
@@ -600,10 +600,12 @@ static struct ehca_qp *internal_create_qp(
 
 	if (EHCA_BMASK_GET(HCA_CAP_MINI_QP, shca->hca_cap)
 	    && !(context && udata)) { /* no small QP support in userspace ATM */
-		ehca_determine_small_queue(
-			&parms.squeue, max_send_sge, is_llqp);
-		ehca_determine_small_queue(
-			&parms.rqueue, max_recv_sge, is_llqp);
+		if (HAS_SQ(my_qp))
+			ehca_determine_small_queue(
+				&parms.squeue, max_send_sge, is_llqp);
+		if (HAS_RQ(my_qp))
+			ehca_determine_small_queue(
+				&parms.rqueue, max_recv_sge, is_llqp);
 		parms.qp_storage =
 			(parms.squeue.is_small || parms.rqueue.is_small);
 	}
diff --git a/drivers/infiniband/hw/ehca/ipz_pt_fn.c b/drivers/infiniband/hw/ehca/ipz_pt_fn.c
index a090c67..29bd476 100644
--- a/drivers/infiniband/hw/ehca/ipz_pt_fn.c
+++ b/drivers/infiniband/hw/ehca/ipz_pt_fn.c
@@ -172,7 +172,7 @@ static void free_small_queue_page(struct ipz_queue *queue, struct ehca_pd *pd)
 	unsigned long bit;
 	int free_page = 0;
 
-	bit = ((unsigned long)queue->queue_pages[0] & PAGE_MASK)
+	bit = ((unsigned long)queue->queue_pages[0] & ~PAGE_MASK)
 		>> (order + 9);
 
 	mutex_lock(&pd->lock);
-- 
1.5.2


