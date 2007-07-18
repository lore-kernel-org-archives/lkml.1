Return-Path: <linux-kernel-owner+w=401wt.eu-S1752279AbXGREA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752279AbXGREA7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 00:00:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750762AbXGREAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 00:00:49 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32848 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750727AbXGREAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 00:00:48 -0400
Date: Tue, 17 Jul 2007 21:00:10 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Roland Dreier <rdreier@cisco.com>
cc: Jeff Garzik <jeff@garzik.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       chas@cmf.nrl.navy.mil, rolandd@cisco.com, dwmw2@infradead.org,
       gregkh@suse.de
Subject: Re: [git patches 1/2] warnings: attack valid cases spotted by
 warnings
In-Reply-To: <adair8io2de.fsf@cisco.com>
Message-ID: <alpine.LFD.0.999.0707171957300.27353@woody.linux-foundation.org>
References: <20070717214239.GF28448@devserv.devel.redhat.com>
 <ada8x9epuip.fsf@cisco.com> <469D3E66.3010502@garzik.org> <adamyxuo2w6.fsf@cisco.com>
 <adair8io2de.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 17 Jul 2007, Roland Dreier wrote:
>
> I think this patch (on top of the previous one) actually makes the
> code clearer

Quite frankly, calling this "making the code clearer" is a bit ridiculous.

That code still is absolute *crap* from a readability angle. It doesn't 
follow any sane coding standards, and certainly not the most important 
ones ("keep the function small", "don't have tons of local variables"), 
and it has absolutely ridiculously ugly casts that get repeated over and 
over and over again.

Quite frankly, I don't quite understand where you get those enormous balls 
you have, that you can then talk about how ugly it is to just add a "= 0" 
that shuts up a compiler warning. That's the _least_ ugly part of the 
whole damn function!

So rather than sending out that idiotic patch, look at that code for five 
seconds, and ponder whether it really needs to be that ugly.

Here's a few things that you could *really* do to make it somewhat more 
readable:

 - make that whole "switch()" statement from hell another function 
   entirely, and have it return the size of the thing, so that you don't 
   need to have

	wqe += xxx
	size += xxx / 16;

   repeated fifty times (and so that it's also obvious that the xxxx 
   always matches).

 - make each switch case actually call a small function with the argument 
   cast to the right pointer type, so that you need *one* cast per case, 
   rather than a handful.

End result? More readable source code, with functions that are 20 lines 
long (or less), rather than 200 lines of spagetti-coding.

And you know what? That's actually more important than 16 bytes of object 
code, although looking at the size of the infiniband code, I *seriously* 
doubt any infiniband person has ever cared about object code size in their 
life. That thing is not for weak machines or stomachs.

The warnign (and fixing it up) is the _least_ of the problems in that 
code, methinks.

Anyway, here's a totally untested cleanup that compiles but probably 
doesn't work, because I didn't check that I did the right thing with all 
the pointer arithmetic (ie when I change "wqe" to a real structure pointer 
instead of just a "void *", maybe I left some pointer arithmetic around 
that expected it to work as a byte pointer, but now really works on the 
whole structure size instead).

So this patch is NOT meant to be applied, but it is meant to teach people 
how things like this should be done. They should *not* be one big function 
with lots of case statements. They should be lots of small functions!

		Linus
---
 drivers/infiniband/hw/mthca/mthca_qp.c |  236 ++++++++++++++++---------------
 1 files changed, 122 insertions(+), 114 deletions(-)

diff --git a/drivers/infiniband/hw/mthca/mthca_qp.c b/drivers/infiniband/hw/mthca/mthca_qp.c
index 11f1d99..74da9bc 100644
--- a/drivers/infiniband/hw/mthca/mthca_qp.c
+++ b/drivers/infiniband/hw/mthca/mthca_qp.c
@@ -1578,6 +1578,113 @@ static inline int mthca_wq_overflow(struct mthca_wq *wq, int nreq,
 	return cur + nreq >= wq->max;
 }
 
+static int handle_next_seg(struct ib_send_wr *wr, struct mthca_next_seg * wqe)
+{
+	wqe->nda_op = 0;
+	wqe->ee_nds = 0;
+	wqe->flags =	((wr->send_flags & IB_SEND_SIGNALED) ?
+			 cpu_to_be32(MTHCA_NEXT_CQ_UPDATE) : 0) |
+			((wr->send_flags & IB_SEND_SOLICITED) ?
+			 cpu_to_be32(MTHCA_NEXT_SOLICIT) : 0)   |
+			cpu_to_be32(1);
+
+	if (wr->opcode == IB_WR_SEND_WITH_IMM ||
+	    wr->opcode == IB_WR_RDMA_WRITE_WITH_IMM)
+		wqe->imm = wr->imm_data;
+
+	return sizeof(struct mthca_next_seg);
+}
+
+static int handle_raddr_seg(struct mthca_dev *dev, struct mthca_qp *qp, struct ib_send_wr *wr,
+	struct mthca_raddr_seg *wqe, int ind)
+{
+	switch (qp->transport) {
+	case RC:
+		switch (wr->opcode) {
+		case IB_WR_ATOMIC_CMP_AND_SWP:
+		case IB_WR_ATOMIC_FETCH_AND_ADD: {
+			struct mthca_atomic_seg *atomic;
+
+			wqe->raddr = cpu_to_be64(wr->wr.atomic.remote_addr);
+			wqe->rkey = cpu_to_be32(wr->wr.atomic.rkey);
+			wqe->reserved = 0;
+
+			atomic = (struct mthca_atomic_seg *) (wqe+1);
+
+			if (wr->opcode == IB_WR_ATOMIC_CMP_AND_SWP) {
+				atomic->swap_add = cpu_to_be64(wr->wr.atomic.swap);
+				atomic->compare = cpu_to_be64(wr->wr.atomic.compare_add);
+			} else {
+				atomic->swap_add = cpu_to_be64(wr->wr.atomic.compare_add);
+				atomic->compare = 0;
+			}
+
+			return sizeof (struct mthca_raddr_seg) +
+				sizeof (struct mthca_atomic_seg);
+		}
+
+		case IB_WR_RDMA_WRITE:
+		case IB_WR_RDMA_WRITE_WITH_IMM:
+		case IB_WR_RDMA_READ:
+			wqe->raddr = cpu_to_be64(wr->wr.rdma.remote_addr);
+			wqe->rkey = cpu_to_be32(wr->wr.rdma.rkey);
+			wqe->reserved = 0;
+			return sizeof (struct mthca_raddr_seg);
+
+		default:
+			/* No extra segments required for sends */
+			break;
+		}
+		return 0;
+
+	case UC:
+		switch (wr->opcode) {
+		case IB_WR_RDMA_WRITE:
+		case IB_WR_RDMA_WRITE_WITH_IMM:
+			wqe->raddr = cpu_to_be64(wr->wr.rdma.remote_addr);
+			wqe->rkey = cpu_to_be32(wr->wr.rdma.rkey);
+			wqe->reserved = 0;
+			return sizeof (struct mthca_raddr_seg);
+
+		default:
+			/* No extra segments required for sends */
+			break;
+		}
+
+		break;
+
+	case UD: {
+		struct mthca_tavor_ud_seg *ud = (void *)wqe;
+
+		ud->lkey = cpu_to_be32(to_mah(wr->wr.ud.ah)->key);
+		ud->av_addr = cpu_to_be64(to_mah(wr->wr.ud.ah)->avdma);
+		ud->dqpn = cpu_to_be32(wr->wr.ud.remote_qpn);
+		ud->qkey = cpu_to_be32(wr->wr.ud.remote_qkey);
+
+		return sizeof (struct mthca_tavor_ud_seg);
+	}
+
+	case MLX: {
+		int err = build_mlx_header(dev, to_msqp(qp), ind, wr,
+				       (void *) wqe - sizeof (struct mthca_next_seg),
+				       (void *) wqe);
+		if (err)
+			return err;
+
+		return sizeof (struct mthca_data_seg);
+	}
+	}
+	return 0;
+}
+
+static int handle_data_seg(struct mthca_data_seg *wqe, struct ib_sge *sge)
+{
+	wqe->byte_count = cpu_to_be32(sge->length);
+	wqe->lkey = cpu_to_be32(sge->lkey);
+	wqe->addr = cpu_to_be64(sge->addr);
+	return sizeof(struct mthca_data_seg);
+}
+
 int mthca_tavor_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 			  struct ib_send_wr **bad_wr)
 {
@@ -1616,115 +1723,18 @@ int mthca_tavor_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 		prev_wqe = qp->sq.last;
 		qp->sq.last = wqe;
 
-		((struct mthca_next_seg *) wqe)->nda_op = 0;
-		((struct mthca_next_seg *) wqe)->ee_nds = 0;
-		((struct mthca_next_seg *) wqe)->flags =
-			((wr->send_flags & IB_SEND_SIGNALED) ?
-			 cpu_to_be32(MTHCA_NEXT_CQ_UPDATE) : 0) |
-			((wr->send_flags & IB_SEND_SOLICITED) ?
-			 cpu_to_be32(MTHCA_NEXT_SOLICIT) : 0)   |
-			cpu_to_be32(1);
-		if (wr->opcode == IB_WR_SEND_WITH_IMM ||
-		    wr->opcode == IB_WR_RDMA_WRITE_WITH_IMM)
-			((struct mthca_next_seg *) wqe)->imm = wr->imm_data;
+		err = handle_next_seg(wr, (struct mthca_next_seg *) wqe);
 
-		wqe += sizeof (struct mthca_next_seg);
-		size = sizeof (struct mthca_next_seg) / 16;
+		wqe += err;
+		size = err / 16;
 
-		switch (qp->transport) {
-		case RC:
-			switch (wr->opcode) {
-			case IB_WR_ATOMIC_CMP_AND_SWP:
-			case IB_WR_ATOMIC_FETCH_AND_ADD:
-				((struct mthca_raddr_seg *) wqe)->raddr =
-					cpu_to_be64(wr->wr.atomic.remote_addr);
-				((struct mthca_raddr_seg *) wqe)->rkey =
-					cpu_to_be32(wr->wr.atomic.rkey);
-				((struct mthca_raddr_seg *) wqe)->reserved = 0;
-
-				wqe += sizeof (struct mthca_raddr_seg);
-
-				if (wr->opcode == IB_WR_ATOMIC_CMP_AND_SWP) {
-					((struct mthca_atomic_seg *) wqe)->swap_add =
-						cpu_to_be64(wr->wr.atomic.swap);
-					((struct mthca_atomic_seg *) wqe)->compare =
-						cpu_to_be64(wr->wr.atomic.compare_add);
-				} else {
-					((struct mthca_atomic_seg *) wqe)->swap_add =
-						cpu_to_be64(wr->wr.atomic.compare_add);
-					((struct mthca_atomic_seg *) wqe)->compare = 0;
-				}
-
-				wqe += sizeof (struct mthca_atomic_seg);
-				size += (sizeof (struct mthca_raddr_seg) +
-					 sizeof (struct mthca_atomic_seg)) / 16;
-				break;
-
-			case IB_WR_RDMA_WRITE:
-			case IB_WR_RDMA_WRITE_WITH_IMM:
-			case IB_WR_RDMA_READ:
-				((struct mthca_raddr_seg *) wqe)->raddr =
-					cpu_to_be64(wr->wr.rdma.remote_addr);
-				((struct mthca_raddr_seg *) wqe)->rkey =
-					cpu_to_be32(wr->wr.rdma.rkey);
-				((struct mthca_raddr_seg *) wqe)->reserved = 0;
-				wqe += sizeof (struct mthca_raddr_seg);
-				size += sizeof (struct mthca_raddr_seg) / 16;
-				break;
-
-			default:
-				/* No extra segments required for sends */
-				break;
-			}
-
-			break;
-
-		case UC:
-			switch (wr->opcode) {
-			case IB_WR_RDMA_WRITE:
-			case IB_WR_RDMA_WRITE_WITH_IMM:
-				((struct mthca_raddr_seg *) wqe)->raddr =
-					cpu_to_be64(wr->wr.rdma.remote_addr);
-				((struct mthca_raddr_seg *) wqe)->rkey =
-					cpu_to_be32(wr->wr.rdma.rkey);
-				((struct mthca_raddr_seg *) wqe)->reserved = 0;
-				wqe += sizeof (struct mthca_raddr_seg);
-				size += sizeof (struct mthca_raddr_seg) / 16;
-				break;
-
-			default:
-				/* No extra segments required for sends */
-				break;
-			}
-
-			break;
-
-		case UD:
-			((struct mthca_tavor_ud_seg *) wqe)->lkey =
-				cpu_to_be32(to_mah(wr->wr.ud.ah)->key);
-			((struct mthca_tavor_ud_seg *) wqe)->av_addr =
-				cpu_to_be64(to_mah(wr->wr.ud.ah)->avdma);
-			((struct mthca_tavor_ud_seg *) wqe)->dqpn =
-				cpu_to_be32(wr->wr.ud.remote_qpn);
-			((struct mthca_tavor_ud_seg *) wqe)->qkey =
-				cpu_to_be32(wr->wr.ud.remote_qkey);
-
-			wqe += sizeof (struct mthca_tavor_ud_seg);
-			size += sizeof (struct mthca_tavor_ud_seg) / 16;
-			break;
-
-		case MLX:
-			err = build_mlx_header(dev, to_msqp(qp), ind, wr,
-					       wqe - sizeof (struct mthca_next_seg),
-					       wqe);
-			if (err) {
-				*bad_wr = wr;
-				goto out;
-			}
-			wqe += sizeof (struct mthca_data_seg);
-			size += sizeof (struct mthca_data_seg) / 16;
-			break;
+		err = handle_raddr_seg(dev, qp, wr, wqe, ind);
+		if (err < 0) {
+			*bad_wr = wr;
+			goto out;
 		}
+		wqe += err;
+		size += err / 16;
 
 		if (wr->num_sge > qp->sq.max_gs) {
 			mthca_err(dev, "too many gathers\n");
@@ -1734,14 +1744,12 @@ int mthca_tavor_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 		}
 
 		for (i = 0; i < wr->num_sge; ++i) {
-			((struct mthca_data_seg *) wqe)->byte_count =
-				cpu_to_be32(wr->sg_list[i].length);
-			((struct mthca_data_seg *) wqe)->lkey =
-				cpu_to_be32(wr->sg_list[i].lkey);
-			((struct mthca_data_seg *) wqe)->addr =
-				cpu_to_be64(wr->sg_list[i].addr);
-			wqe += sizeof (struct mthca_data_seg);
-			size += sizeof (struct mthca_data_seg) / 16;
+			struct ib_sge *sge = wr->sg_list + i;
+			err = handle_data_seg((struct mthca_data_seg *) wqe, sge);
+
+			/* No errors possible */
+			wqe += err;
+			size += err / 16;
 		}
 
 		/* Add one more inline data segment for ICRC */
