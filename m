Return-Path: <linux-kernel-owner+w=401wt.eu-S933862AbXCOW1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933862AbXCOW1z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 18:27:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422986AbXCOW1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 18:27:33 -0400
Received: from mx.pathscale.com ([198.186.3.68]:33700 "EHLO mx.pathscale.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753417AbXCOWP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 18:15:27 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 19 of 33] IB/ipath - Discard multicast packets without a GRH
X-Mercurial-Node: c96d13efde155eb60dc0eca0bd56e81ecd36281b
Message-Id: <c96d13efde155eb60dc0.1173995103@iqa-25.internal.keyresearch.com>
In-Reply-To: <patchbomb.1173995084@iqa-25.internal.keyresearch.com>
Date: Thu, 15 Mar 2007 14:45:03 -0700
From: "Bryan O'Sullivan" <bos@pathscale.com>
To: rdreier@cisco.com
Cc: openib-general@openfabrics.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

# HG changeset patch
# User Bryan O'Sullivan <bos@pathscale.com>
# Date 1173994465 25200
# Node ID c96d13efde155eb60dc0eca0bd56e81ecd36281b
# Parent  878b6054e9ca5327db9c9438f66265afaf88b055
IB/ipath - Discard multicast packets without a GRH

This patch fixes a bug where multicast packets without a GRH
were not being dropped as per the IB spec.

Signed-off-by: Ralph Campbell <ralph.campbell@qlogic.com>
Signed-off-by: Bryan O'Sullivan <bryan.osullivan@qlogic.com>

diff -r 878b6054e9ca -r c96d13efde15 drivers/infiniband/hw/ipath/ipath_verbs.c
--- a/drivers/infiniband/hw/ipath/ipath_verbs.c	Thu Mar 15 14:34:25 2007 -0700
+++ b/drivers/infiniband/hw/ipath/ipath_verbs.c	Thu Mar 15 14:34:25 2007 -0700
@@ -438,6 +438,10 @@ void ipath_ib_rcv(struct ipath_ibdev *de
 		struct ipath_mcast *mcast;
 		struct ipath_mcast_qp *p;
 
+		if (lnh != IPATH_LRH_GRH) {
+			dev->n_pkt_drops++;
+			goto bail;
+		}
 		mcast = ipath_mcast_find(&hdr->u.l.grh.dgid);
 		if (mcast == NULL) {
 			dev->n_pkt_drops++;
@@ -445,8 +449,7 @@ void ipath_ib_rcv(struct ipath_ibdev *de
 		}
 		dev->n_multicast_rcv++;
 		list_for_each_entry_rcu(p, &mcast->qp_list, list)
-			ipath_qp_rcv(dev, hdr, lnh == IPATH_LRH_GRH, data,
-				     tlen, p->qp);
+			ipath_qp_rcv(dev, hdr, 1, data, tlen, p->qp);
 		/*
 		 * Notify ipath_multicast_detach() if it is waiting for us
 		 * to finish.
