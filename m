Return-Path: <linux-kernel-owner+w=401wt.eu-S1761653AbXF0PwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761653AbXF0PwQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 11:52:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760150AbXF0Pvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 11:51:31 -0400
Received: from rrcs-71-42-183-126.sw.biz.rr.com ([71.42.183.126]:39343 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759869AbXF0Pv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 11:51:28 -0400
From: Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH 2/6] iw_cxgb3: TERMINATE WRs can hang the tx ofld queue.
Date: Wed, 27 Jun 2007 10:51:30 -0500
To: rdreier@cisco.com
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, divy@chelsio.com
Message-Id: <20070627155130.24944.55771.stgit@dell3.ogc.int>
In-Reply-To: <20070627155119.24944.44172.stgit@dell3.ogc.int>
References: <20070627155119.24944.44172.stgit@dell3.ogc.int>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
User-Agent: StGIT/0.10
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


iw_cxgb3: TERMINATE WRs can hang the tx ofld queue.

Don't set the gen bits nor length bits in the terminate wr.  This is
done by the LLD driver.

Signed-off-by: Steve Wise <swise@opengridcomputing.com>
---

 drivers/infiniband/hw/cxgb3/iwch_qp.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb3/iwch_qp.c b/drivers/infiniband/hw/cxgb3/iwch_qp.c
index 679b7c1..dd89b6b 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_qp.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_qp.c
@@ -628,9 +628,9 @@ int iwch_post_terminate(struct iwch_qp *
 	/* immediate data starts here. */
 	term = (struct terminate_message *)wqe->send.sgl;
 	build_term_codes(rsp_msg, &term->layer_etype, &term->ecode);
-	build_fw_riwrh((void *)wqe, T3_WR_SEND,
-		       T3_COMPLETION_FLAG | T3_NOTIFY_FLAG, 1,
-		       qhp->ep->hwtid, 5);
+	wqe->send.wrh.op_seop_flags = cpu_to_be32(V_FW_RIWR_OP(T3_WR_SEND) |
+			 V_FW_RIWR_FLAGS(T3_COMPLETION_FLAG | T3_NOTIFY_FLAG));
+	wqe->send.wrh.gen_tid_len = cpu_to_be32(V_FW_RIWR_TID(qhp->ep->hwtid));
 	skb->priority = CPL_PRIORITY_DATA;
 	return cxgb3_ofld_send(qhp->rhp->rdev.t3cdev_p, skb);
 }
