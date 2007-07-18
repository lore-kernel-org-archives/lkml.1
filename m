Return-Path: <linux-kernel-owner+w=401wt.eu-S934783AbXGRRh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934783AbXGRRh2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 13:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760391AbXGRRhQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 13:37:16 -0400
Received: from sj-iport-1-in.cisco.com ([171.71.176.70]:28903 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759804AbXGRRhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 13:37:12 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CABPtnUarR7O6/2dsb2JhbAA
X-IronPort-AV: i="4.16,551,1175497200"; 
   d="scan'208"; a="9253398:sNHT16293156"
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Garzik <jeff@garzik.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       chas@cmf.nrl.navy.mil, rolandd@cisco.com, dwmw2@infradead.org,
       gregkh@suse.de
Subject: Re: [git patches 1/2] warnings: attack valid cases spotted by warnings
X-Message-Flag: Warning: May contain useful information
References: <20070717214239.GF28448@devserv.devel.redhat.com>
	<ada8x9epuip.fsf@cisco.com> <469D3E66.3010502@garzik.org>
	<adamyxuo2w6.fsf@cisco.com> <adair8io2de.fsf@cisco.com>
	<alpine.LFD.0.999.0707171957300.27353@woody.linux-foundation.org>
	<adabqeamjjs.fsf@cisco.com>
	<alpine.LFD.0.999.0707172205270.27353@woody.linux-foundation.org>
From: Roland Dreier <rdreier@cisco.com>
Date: Wed, 18 Jul 2007 10:37:09 -0700
In-Reply-To: <alpine.LFD.0.999.0707172205270.27353@woody.linux-foundation.org> (Linus Torvalds's message of "Tue, 17 Jul 2007 22:12:09 -0700 (PDT)")
Message-ID: <adaodi9lika.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 18 Jul 2007 17:37:10.0210 (UTC) FILETIME=[44D47220:01C7C962]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > Hey, I appreciate it, but I really do have to warn you that I did this all 
 > blind, and just meant for it to be a "I think this kind of direction is 
 > more productive" thing. I'm not going to guarantee that it works at all.

Oh, understood, and I'm definitely planning on taking your patch as
inspiration and a kick in the pants to finally clean up the code
rather than trying to use it as is.  Obviously it was a quick hack
from someone that doesn't know the hardware -- for example
handle_raddr_seg() is at least misnamed, since UD work requests don't
have raddr segments.

But if you're going to take the time to work on the code, then I feel
like it's only polite not to drop your work on the floor.  Just like I
hope someone who works on IB and who is usually sending me stuff to
merge would give a patch from me some attention.

BTW, I noticed one interesting thing while starting on this cleanup.
I wanted to make sure that the generated code didn't change with the
first step, and I actually discovered that the patch below seems to
make the generated code *better*, maybe because some gcc alias
analysis doesn't get as paranoid without the void *:

add/remove: 0/0 grow/shrink: 0/7 up/down: 0/-85 (-85)
function                                     old     new   delta
mthca_arbel_post_srq_recv                    373     369      -4
mthca_arbel_post_receive                     570     562      -8
mthca_tavor_post_srq_recv                    520     508     -12
mthca_tavor_post_send                       1344    1330     -14
mthca_arbel_post_send                       1481    1467     -14
mlx4_ib_post_send                           1598    1582     -16
mthca_tavor_post_receive                     792     775     -17

And here's the patch itself -- I think this is a reasonable size step
to break things up into.  I assume that this is the basic form of the
cleanup that you're proposing?

diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 8d09aa3..a59c7f0 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -1183,6 +1183,14 @@ static int mlx4_wq_overflow(struct mlx4_ib_wq *wq, int nreq, struct ib_cq *ib_cq
 	return cur + nreq >= wq->max_post;
 }
 
+static void set_data_seg(struct mlx4_wqe_data_seg *dseg,
+			 struct ib_sge *sg)
+{
+	dseg->byte_count = cpu_to_be32(sg->length);
+	dseg->lkey       = cpu_to_be32(sg->lkey);
+	dseg->addr       = cpu_to_be64(sg->addr);
+}
+
 int mlx4_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 		      struct ib_send_wr **bad_wr)
 {
@@ -1313,12 +1321,7 @@ int mlx4_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 		}
 
 		for (i = 0; i < wr->num_sge; ++i) {
-			((struct mlx4_wqe_data_seg *) wqe)->byte_count =
-				cpu_to_be32(wr->sg_list[i].length);
-			((struct mlx4_wqe_data_seg *) wqe)->lkey =
-				cpu_to_be32(wr->sg_list[i].lkey);
-			((struct mlx4_wqe_data_seg *) wqe)->addr =
-				cpu_to_be64(wr->sg_list[i].addr);
+			set_data_seg(wqe, wr->sg_list + i);
 
 			wqe  += sizeof (struct mlx4_wqe_data_seg);
 			size += sizeof (struct mlx4_wqe_data_seg) / 16;
diff --git a/drivers/infiniband/hw/mthca/mthca_qp.c b/drivers/infiniband/hw/mthca/mthca_qp.c
index 0e9ef24..2548250 100644
--- a/drivers/infiniband/hw/mthca/mthca_qp.c
+++ b/drivers/infiniband/hw/mthca/mthca_qp.c
@@ -1740,13 +1740,8 @@ int mthca_tavor_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 		}
 
 		for (i = 0; i < wr->num_sge; ++i) {
-			((struct mthca_data_seg *) wqe)->byte_count =
-				cpu_to_be32(wr->sg_list[i].length);
-			((struct mthca_data_seg *) wqe)->lkey =
-				cpu_to_be32(wr->sg_list[i].lkey);
-			((struct mthca_data_seg *) wqe)->addr =
-				cpu_to_be64(wr->sg_list[i].addr);
-			wqe += sizeof (struct mthca_data_seg);
+			mthca_set_data_seg(wqe, wr->sg_list + i);
+			wqe  += sizeof (struct mthca_data_seg);
 			size += sizeof (struct mthca_data_seg) / 16;
 		}
 
@@ -1869,13 +1864,8 @@ int mthca_tavor_post_receive(struct ib_qp *ibqp, struct ib_recv_wr *wr,
 		}
 
 		for (i = 0; i < wr->num_sge; ++i) {
-			((struct mthca_data_seg *) wqe)->byte_count =
-				cpu_to_be32(wr->sg_list[i].length);
-			((struct mthca_data_seg *) wqe)->lkey =
-				cpu_to_be32(wr->sg_list[i].lkey);
-			((struct mthca_data_seg *) wqe)->addr =
-				cpu_to_be64(wr->sg_list[i].addr);
-			wqe += sizeof (struct mthca_data_seg);
+			mthca_set_data_seg(wqe, wr->sg_list + i);
+			wqe  += sizeof (struct mthca_data_seg);
 			size += sizeof (struct mthca_data_seg) / 16;
 		}
 
@@ -2125,13 +2115,8 @@ int mthca_arbel_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 		}
 
 		for (i = 0; i < wr->num_sge; ++i) {
-			((struct mthca_data_seg *) wqe)->byte_count =
-				cpu_to_be32(wr->sg_list[i].length);
-			((struct mthca_data_seg *) wqe)->lkey =
-				cpu_to_be32(wr->sg_list[i].lkey);
-			((struct mthca_data_seg *) wqe)->addr =
-				cpu_to_be64(wr->sg_list[i].addr);
-			wqe += sizeof (struct mthca_data_seg);
+			mthca_set_data_seg(wqe, wr->sg_list + i);
+			wqe  += sizeof (struct mthca_data_seg);
 			size += sizeof (struct mthca_data_seg) / 16;
 		}
 
@@ -2253,20 +2238,12 @@ int mthca_arbel_post_receive(struct ib_qp *ibqp, struct ib_recv_wr *wr,
 		}
 
 		for (i = 0; i < wr->num_sge; ++i) {
-			((struct mthca_data_seg *) wqe)->byte_count =
-				cpu_to_be32(wr->sg_list[i].length);
-			((struct mthca_data_seg *) wqe)->lkey =
-				cpu_to_be32(wr->sg_list[i].lkey);
-			((struct mthca_data_seg *) wqe)->addr =
-				cpu_to_be64(wr->sg_list[i].addr);
+			mthca_set_data_seg(wqe, wr->sg_list + i);
 			wqe += sizeof (struct mthca_data_seg);
 		}
 
-		if (i < qp->rq.max_gs) {
-			((struct mthca_data_seg *) wqe)->byte_count = 0;
-			((struct mthca_data_seg *) wqe)->lkey = cpu_to_be32(MTHCA_INVAL_LKEY);
-			((struct mthca_data_seg *) wqe)->addr = 0;
-		}
+		if (i < qp->rq.max_gs)
+			mthca_set_data_seg_inval(wqe);
 
 		qp->wrid[ind] = wr->wr_id;
 
diff --git a/drivers/infiniband/hw/mthca/mthca_srq.c b/drivers/infiniband/hw/mthca/mthca_srq.c
index b8f05a5..88d219e 100644
--- a/drivers/infiniband/hw/mthca/mthca_srq.c
+++ b/drivers/infiniband/hw/mthca/mthca_srq.c
@@ -543,20 +543,12 @@ int mthca_tavor_post_srq_recv(struct ib_srq *ibsrq, struct ib_recv_wr *wr,
 		}
 
 		for (i = 0; i < wr->num_sge; ++i) {
-			((struct mthca_data_seg *) wqe)->byte_count =
-				cpu_to_be32(wr->sg_list[i].length);
-			((struct mthca_data_seg *) wqe)->lkey =
-				cpu_to_be32(wr->sg_list[i].lkey);
-			((struct mthca_data_seg *) wqe)->addr =
-				cpu_to_be64(wr->sg_list[i].addr);
+			mthca_set_data_seg(wqe, wr->sg_list + i);
 			wqe += sizeof (struct mthca_data_seg);
 		}
 
-		if (i < srq->max_gs) {
-			((struct mthca_data_seg *) wqe)->byte_count = 0;
-			((struct mthca_data_seg *) wqe)->lkey = cpu_to_be32(MTHCA_INVAL_LKEY);
-			((struct mthca_data_seg *) wqe)->addr = 0;
-		}
+		if (i < srq->max_gs)
+			mthca_set_data_seg_inval(wqe);
 
 		((struct mthca_next_seg *) prev_wqe)->nda_op =
 			cpu_to_be32((ind << srq->wqe_shift) | 1);
@@ -662,20 +654,12 @@ int mthca_arbel_post_srq_recv(struct ib_srq *ibsrq, struct ib_recv_wr *wr,
 		}
 
 		for (i = 0; i < wr->num_sge; ++i) {
-			((struct mthca_data_seg *) wqe)->byte_count =
-				cpu_to_be32(wr->sg_list[i].length);
-			((struct mthca_data_seg *) wqe)->lkey =
-				cpu_to_be32(wr->sg_list[i].lkey);
-			((struct mthca_data_seg *) wqe)->addr =
-				cpu_to_be64(wr->sg_list[i].addr);
+			mthca_set_data_seg(wqe, wr->sg_list + i);
 			wqe += sizeof (struct mthca_data_seg);
 		}
 
-		if (i < srq->max_gs) {
-			((struct mthca_data_seg *) wqe)->byte_count = 0;
-			((struct mthca_data_seg *) wqe)->lkey = cpu_to_be32(MTHCA_INVAL_LKEY);
-			((struct mthca_data_seg *) wqe)->addr = 0;
-		}
+		if (i < srq->max_gs)
+			mthca_set_data_seg_inval(wqe);
 
 		srq->wrid[ind]  = wr->wr_id;
 		srq->first_free = next_ind;
diff --git a/drivers/infiniband/hw/mthca/mthca_wqe.h b/drivers/infiniband/hw/mthca/mthca_wqe.h
index e7d2c1e..f6a66fe 100644
--- a/drivers/infiniband/hw/mthca/mthca_wqe.h
+++ b/drivers/infiniband/hw/mthca/mthca_wqe.h
@@ -113,4 +113,19 @@ struct mthca_mlx_seg {
 	__be16 vcrc;
 };
 
+static __always_inline void mthca_set_data_seg(struct mthca_data_seg *dseg,
+					       struct ib_sge *sg)
+{
+	dseg->byte_count = cpu_to_be32(sg->length);
+	dseg->lkey       = cpu_to_be32(sg->lkey);
+	dseg->addr       = cpu_to_be64(sg->addr);
+}
+
+static __always_inline void mthca_set_data_seg_inval(struct mthca_data_seg *dseg)
+{
+	dseg->byte_count = 0;
+	dseg->lkey       = cpu_to_be32(MTHCA_INVAL_LKEY);
+	dseg->addr       = 0;
+}
+
 #endif /* MTHCA_WQE_H */
