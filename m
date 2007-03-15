Return-Path: <linux-kernel-owner+w=401wt.eu-S1422978AbXCOWT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422978AbXCOWT3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 18:19:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932229AbXCOWT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 18:19:26 -0400
Received: from mx.pathscale.com ([198.186.3.68]:33720 "EHLO mx.pathscale.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753426AbXCOWP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 18:15:28 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 28 of 33] IB/ipath - Don't allow QP's 0 and 1 to be opened
	multiple times
X-Mercurial-Node: b436c73d4fe312c3cba092d5f642de5c0ff6aa91
Message-Id: <b436c73d4fe312c3cba0.1173995112@iqa-25.internal.keyresearch.com>
In-Reply-To: <patchbomb.1173995084@iqa-25.internal.keyresearch.com>
Date: Thu, 15 Mar 2007 14:45:12 -0700
From: "Bryan O'Sullivan" <bos@pathscale.com>
To: rdreier@cisco.com
Cc: openib-general@openfabrics.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

# HG changeset patch
# User Bryan O'Sullivan <bos@pathscale.com>
# Date 1173994465 25200
# Node ID b436c73d4fe312c3cba092d5f642de5c0ff6aa91
# Parent  fddf5d03720ca586054b66d250d84233bdb3bf86
IB/ipath - Don't allow QP's 0 and 1 to be opened multiple times

Signed-off-by: Robert Walsh <robert.walsh@qlogic.com>
Signed-off-by: Bryan O'Sullivan <bryan.osullivan@qlogic.com>

diff -r fddf5d03720c -r b436c73d4fe3 drivers/infiniband/hw/ipath/ipath_qp.c
--- a/drivers/infiniband/hw/ipath/ipath_qp.c	Thu Mar 15 14:34:25 2007 -0700
+++ b/drivers/infiniband/hw/ipath/ipath_qp.c	Thu Mar 15 14:34:25 2007 -0700
@@ -81,11 +81,51 @@ static u32 credit_table[31] = {
 	32768			/* 1E */
 };
 
-static u32 alloc_qpn(struct ipath_qp_table *qpt)
+
+static void get_map_page(struct ipath_qp_table *qpt, struct qpn_map *map)
+{
+	unsigned long page = get_zeroed_page(GFP_KERNEL);
+	unsigned long flags;
+
+	/*
+	 * Free the page if someone raced with us installing it.
+	 */
+
+	spin_lock_irqsave(&qpt->lock, flags);
+	if (map->page)
+		free_page(page);
+	else
+		map->page = (void *)page;
+	spin_unlock_irqrestore(&qpt->lock, flags);
+}
+
+
+static int alloc_qpn(struct ipath_qp_table *qpt, enum ib_qp_type type)
 {
 	u32 i, offset, max_scan, qpn;
 	struct qpn_map *map;
-	u32 ret;
+	u32 ret = -1;
+
+	if (type == IB_QPT_SMI)
+		ret = 0;
+	else if (type == IB_QPT_GSI)
+		ret = 1;
+
+	if (ret != -1) {
+		map = &qpt->map[0];
+		if (unlikely(!map->page)) {
+			get_map_page(qpt, map);
+			if (unlikely(!map->page)) {
+				ret = -ENOMEM;
+				goto bail;
+			}
+		}
+		if (!test_and_set_bit(ret, map->page))
+			atomic_dec(&map->n_free);
+		else
+			ret = -EBUSY;
+		goto bail;
+	}
 
 	qpn = qpt->last + 1;
 	if (qpn >= QPN_MAX)
@@ -95,19 +135,7 @@ static u32 alloc_qpn(struct ipath_qp_tab
 	max_scan = qpt->nmaps - !offset;
 	for (i = 0;;) {
 		if (unlikely(!map->page)) {
-			unsigned long page = get_zeroed_page(GFP_KERNEL);
-			unsigned long flags;
-
-			/*
-			 * Free the page if someone raced with us
-			 * installing it:
-			 */
-			spin_lock_irqsave(&qpt->lock, flags);
-			if (map->page)
-				free_page(page);
-			else
-				map->page = (void *)page;
-			spin_unlock_irqrestore(&qpt->lock, flags);
+			get_map_page(qpt, map);
 			if (unlikely(!map->page))
 				break;
 		}
@@ -151,7 +179,7 @@ static u32 alloc_qpn(struct ipath_qp_tab
 		qpn = mk_qpn(qpt, map, offset);
 	}
 
-	ret = 0;
+	ret = -ENOMEM;
 
 bail:
 	return ret;
@@ -180,29 +208,19 @@ static int ipath_alloc_qpn(struct ipath_
 			   enum ib_qp_type type)
 {
 	unsigned long flags;
-	u32 qpn;
 	int ret;
 
-	if (type == IB_QPT_SMI)
-		qpn = 0;
-	else if (type == IB_QPT_GSI)
-		qpn = 1;
-	else {
-		/* Allocate the next available QPN */
-		qpn = alloc_qpn(qpt);
-		if (qpn == 0) {
-			ret = -ENOMEM;
-			goto bail;
-		}
-	}
-	qp->ibqp.qp_num = qpn;
+	ret = alloc_qpn(qpt, type);
+	if (ret < 0)
+		goto bail;
+	qp->ibqp.qp_num = ret;
 
 	/* Add the QP to the hash table. */
 	spin_lock_irqsave(&qpt->lock, flags);
 
-	qpn %= qpt->max;
-	qp->next = qpt->table[qpn];
-	qpt->table[qpn] = qp;
+	ret %= qpt->max;
+	qp->next = qpt->table[ret];
+	qpt->table[ret] = qp;
 	atomic_inc(&qp->refcount);
 
 	spin_unlock_irqrestore(&qpt->lock, flags);
@@ -245,9 +263,7 @@ static void ipath_free_qp(struct ipath_q
 	if (!fnd)
 		return;
 
-	/* If QPN is not reserved, mark QPN free in the bitmap. */
-	if (qp->ibqp.qp_num > 1)
-		free_qpn(qpt, qp->ibqp.qp_num);
+	free_qpn(qpt, qp->ibqp.qp_num);
 
 	wait_event(qp->wait, !atomic_read(&qp->refcount));
 }
@@ -270,8 +286,7 @@ void ipath_free_all_qps(struct ipath_qp_
 
 		while (qp) {
 			nqp = qp->next;
-			if (qp->ibqp.qp_num > 1)
-				free_qpn(qpt, qp->ibqp.qp_num);
+			free_qpn(qpt, qp->ibqp.qp_num);
 			if (!atomic_dec_and_test(&qp->refcount) ||
 			    !ipath_destroy_qp(&qp->ibqp))
 				ipath_dbg("QP memory leak!\n");
