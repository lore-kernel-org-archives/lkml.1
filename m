Return-Path: <linux-kernel-owner+w=401wt.eu-S933926AbXCOWQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933926AbXCOWQ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 18:16:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933877AbXCOWPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 18:15:35 -0400
Received: from mx.pathscale.com ([198.186.3.68]:33693 "EHLO mx.pathscale.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753409AbXCOWP0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 18:15:26 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 33 of 33] IB/ipath - fix drift between WCs in user and kernel
	space
X-Mercurial-Node: e61b0123190cfbc01cc34d1c648d1752a89f8f3d
Message-Id: <e61b0123190cfbc01cc3.1173995117@iqa-25.internal.keyresearch.com>
In-Reply-To: <patchbomb.1173995084@iqa-25.internal.keyresearch.com>
Date: Thu, 15 Mar 2007 14:45:17 -0700
From: "Bryan O'Sullivan" <bos@pathscale.com>
To: rdreier@cisco.com
Cc: openib-general@openfabrics.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

# HG changeset patch
# User Robert Walsh <robert.walsh@qlogic.com>
# Date 1173994466 25200
# Node ID e61b0123190cfbc01cc34d1c648d1752a89f8f3d
# Parent  c3b5b279bc90e5758da2ac382cbff4ee0245e84b
IB/ipath - fix drift between WCs in user and kernel space

The kernel ib_wc structure now uses a QP pointer, but the user space
equivalent uses a QP number instead.  This means we can no longer use
a simple structure copy to copy stuff into user space.

Signed-off-by: Bryan O'Sullivan <bryan.osullivan@qlogic.com>

diff -r c3b5b279bc90 -r e61b0123190c drivers/infiniband/hw/ipath/ipath_cq.c
--- a/drivers/infiniband/hw/ipath/ipath_cq.c	Thu Mar 15 14:34:26 2007 -0700
+++ b/drivers/infiniband/hw/ipath/ipath_cq.c	Thu Mar 15 14:34:26 2007 -0700
@@ -76,7 +76,20 @@ void ipath_cq_enter(struct ipath_cq *cq,
 		}
 		return;
 	}
-	wc->queue[head] = *entry;
+	wc->queue[head].wr_id = entry->wr_id;
+	wc->queue[head].status = entry->status;
+	wc->queue[head].opcode = entry->opcode;
+	wc->queue[head].vendor_err = entry->vendor_err;
+	wc->queue[head].byte_len = entry->byte_len;
+	wc->queue[head].imm_data = (__u32 __force)entry->imm_data;
+	wc->queue[head].qp_num = entry->qp->qp_num;
+	wc->queue[head].src_qp = entry->src_qp;
+	wc->queue[head].wc_flags = entry->wc_flags;
+	wc->queue[head].pkey_index = entry->pkey_index;
+	wc->queue[head].slid = entry->slid;
+	wc->queue[head].sl = entry->sl;
+	wc->queue[head].dlid_path_bits = entry->dlid_path_bits;
+	wc->queue[head].port_num = entry->port_num;
 	wc->head = next;
 
 	if (cq->notify == IB_CQ_NEXT_COMP ||
@@ -122,9 +135,30 @@ int ipath_poll_cq(struct ib_cq *ibcq, in
 	if (tail > (u32) cq->ibcq.cqe)
 		tail = (u32) cq->ibcq.cqe;
 	for (npolled = 0; npolled < num_entries; ++npolled, ++entry) {
+		struct ipath_qp *qp;
+
 		if (tail == wc->head)
 			break;
-		*entry = wc->queue[tail];
+
+		qp = ipath_lookup_qpn(&to_idev(cq->ibcq.device)->qp_table,
+				      wc->queue[tail].qp_num);
+		entry->qp = &qp->ibqp;
+		if (atomic_dec_and_test(&qp->refcount))
+			wake_up(&qp->wait);
+
+		entry->wr_id = wc->queue[tail].wr_id;
+		entry->status = wc->queue[tail].status;
+		entry->opcode = wc->queue[tail].opcode;
+		entry->vendor_err = wc->queue[tail].vendor_err;
+		entry->byte_len = wc->queue[tail].byte_len;
+		entry->imm_data = wc->queue[tail].imm_data;
+		entry->src_qp = wc->queue[tail].src_qp;
+		entry->wc_flags = wc->queue[tail].wc_flags;
+		entry->pkey_index = wc->queue[tail].pkey_index;
+		entry->slid = wc->queue[tail].slid;
+		entry->sl = wc->queue[tail].sl;
+		entry->dlid_path_bits = wc->queue[tail].dlid_path_bits;
+		entry->port_num = wc->queue[tail].port_num;
 		if (tail >= cq->ibcq.cqe)
 			tail = 0;
 		else
diff -r c3b5b279bc90 -r e61b0123190c drivers/infiniband/hw/ipath/ipath_verbs.h
--- a/drivers/infiniband/hw/ipath/ipath_verbs.h	Thu Mar 15 14:34:26 2007 -0700
+++ b/drivers/infiniband/hw/ipath/ipath_verbs.h	Thu Mar 15 14:34:26 2007 -0700
@@ -40,6 +40,7 @@
 #include <linux/interrupt.h>
 #include <linux/kref.h>
 #include <rdma/ib_pack.h>
+#include <rdma/ib_user_verbs.h>
 
 #include "ipath_layer.h"
 
@@ -188,7 +189,7 @@ struct ipath_cq_wc {
 struct ipath_cq_wc {
 	u32 head;		/* index of next entry to fill */
 	u32 tail;		/* index of next ib_poll_cq() entry */
-	struct ib_wc queue[1];	/* this is actually size ibcq.cqe + 1 */
+	struct ib_uverbs_wc queue[1]; /* this is actually size ibcq.cqe + 1 */
 };
 
 /*
