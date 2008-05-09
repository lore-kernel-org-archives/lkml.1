Return-Path: <linux-kernel-owner+w=401wt.eu-S1756168AbYEIUTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168AbYEIUTU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 16:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753030AbYEIUTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 16:19:06 -0400
Received: from smtp.opengridcomputing.com ([209.198.142.2]:60353 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751412AbYEIUTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 16:19:04 -0400
From: Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH 2.6.26] RDMA/cxgb3: Wrap the software sq ptr as needed on flush.
Date: Fri, 09 May 2008 15:19:02 -0500
To: rdreier@cisco.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       general@lists.openfabrics.org
Message-Id: <20080509201902.13077.53047.stgit@dell3.ogc.int>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
User-Agent: StGIT/0.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


cxio_flush_sq() was failing to wrap around the sw-sq causing garbage
completion entries on a flush operation.

Signed-off-by: Steve Wise <swise@opengridcomputing.com>
---

 drivers/infiniband/hw/cxgb3/cxio_hal.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb3/cxio_hal.c b/drivers/infiniband/hw/cxgb3/cxio_hal.c
index 5fd8506..20a6326 100644
--- a/drivers/infiniband/hw/cxgb3/cxio_hal.c
+++ b/drivers/infiniband/hw/cxgb3/cxio_hal.c
@@ -405,11 +405,11 @@ int cxio_flush_sq(struct t3_wq *wq, struct t3_cq *cq, int count)
 	struct t3_swsq *sqp = wq->sq + Q_PTR2IDX(wq->sq_rptr, wq->sq_size_log2);
 
 	ptr = wq->sq_rptr + count;
-	sqp += count;
+	sqp = wq->sq + Q_PTR2IDX(ptr, wq->sq_size_log2);
 	while (ptr != wq->sq_wptr) {
 		insert_sq_cqe(wq, cq, sqp);
-		sqp++;
 		ptr++;
+		sqp = wq->sq + Q_PTR2IDX(ptr, wq->sq_size_log2);
 		flushed++;
 	}
 	return flushed;
