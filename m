Return-Path: <linux-kernel-owner+w=401wt.eu-S1757966AbYAUUnF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757966AbYAUUnF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 15:43:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754889AbYAUUmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 15:42:14 -0500
Received: from 209-198-142-2-host.prismnet.net ([209.198.142.2]:50214 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754748AbYAUUmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 15:42:13 -0500
From: Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH RESEND 3/3] RDMA/cxgb3: Mark qp as privileged based on user capabilities.
Date: Mon, 21 Jan 2008 14:42:13 -0600
To: rdreier@cisco.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org
Message-Id: <20080121204213.3820.12396.stgit@dell3.ogc.int>
In-Reply-To: <20080121204130.3820.11053.stgit@dell3.ogc.int>
References: <20080121204130.3820.11053.stgit@dell3.ogc.int>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
User-Agent: StGIT/0.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


RDMA/cxgb3: Mark qp as privileged based on user capabilities.

This is needed for zero-stag support.

Signed-off-by: Steve Wise <swise@opengridcomputing.com>
---

 drivers/infiniband/hw/cxgb3/cxio_wr.h |    3 ++-
 drivers/infiniband/hw/cxgb3/iwch_qp.c |    1 +
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb3/cxio_wr.h b/drivers/infiniband/hw/cxgb3/cxio_wr.h
index c84d4ac..d72b584 100644
--- a/drivers/infiniband/hw/cxgb3/cxio_wr.h
+++ b/drivers/infiniband/hw/cxgb3/cxio_wr.h
@@ -324,7 +324,8 @@ struct t3_genbit {
 };
 
 enum rdma_init_wr_flags {
-	RECVS_POSTED = 1,
+	RECVS_POSTED = (1<<0),
+	PRIV_QP = (1<<1),
 };
 
 union t3_wr {
diff --git a/drivers/infiniband/hw/cxgb3/iwch_qp.c b/drivers/infiniband/hw/cxgb3/iwch_qp.c
index 7681fdc..ea2cdd7 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_qp.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_qp.c
@@ -717,6 +717,7 @@ static int rdma_init(struct iwch_dev *rhp, struct iwch_qp *qhp,
 	init_attr.qp_dma_addr = qhp->wq.dma_addr;
 	init_attr.qp_dma_size = (1UL << qhp->wq.size_log2);
 	init_attr.flags = rqes_posted(qhp) ? RECVS_POSTED : 0;
+	init_attr.flags |= capable(CAP_NET_BIND_SERVICE) ? PRIV_QP : 0;
 	init_attr.irs = qhp->ep->rcv_seq;
 	PDBG("%s init_attr.rq_addr 0x%x init_attr.rq_size = %d "
 	     "flags 0x%x qpcaps 0x%x\n", __FUNCTION__,
