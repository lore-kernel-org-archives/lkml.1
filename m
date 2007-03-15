Return-Path: <linux-kernel-owner+w=401wt.eu-S1753414AbXCOWPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414AbXCOWPZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 18:15:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753410AbXCOWPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 18:15:25 -0400
Received: from mx.pathscale.com ([198.186.3.68]:33685 "EHLO mx.pathscale.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753397AbXCOWPY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 18:15:24 -0400
X-Greylist: delayed 1792 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Mar 2007 18:15:24 EDT
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 13 of 33] IB/ipath - Fix CQ flushing when QP is modified to
	error state
X-Mercurial-Node: aaee8124e3bc44ec423b5e1c46ef90ede9f21483
Message-Id: <aaee8124e3bc44ec423b.1173995097@iqa-25.internal.keyresearch.com>
In-Reply-To: <patchbomb.1173995084@iqa-25.internal.keyresearch.com>
Date: Thu, 15 Mar 2007 14:44:57 -0700
From: "Bryan O'Sullivan" <bos@pathscale.com>
To: rdreier@cisco.com
Cc: openib-general@openfabrics.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

# HG changeset patch
# User Bryan O'Sullivan <bos@pathscale.com>
# Date 1173994465 25200
# Node ID aaee8124e3bc44ec423b5e1c46ef90ede9f21483
# Parent  84a9691cf7ff54ce76de402d2353a451ba9c555b
IB/ipath - Fix CQ flushing when QP is modified to error state

If a receive work request has been removed from the queue but
has not had a CQ entry generated for it and the QP is modified
to the error state, the completion entry generated is
incorrect.  This patch fixes the problem.

Signed-off-by: Ralph Campbell <ralph.campbell@qlogic.com>
Signed-off-by: Bryan O'Sullivan <bryan.osullivan@qlogic.com>

diff -r 84a9691cf7ff -r aaee8124e3bc drivers/infiniband/hw/ipath/ipath_qp.c
--- a/drivers/infiniband/hw/ipath/ipath_qp.c	Thu Mar 15 14:34:25 2007 -0700
+++ b/drivers/infiniband/hw/ipath/ipath_qp.c	Thu Mar 15 14:34:25 2007 -0700
@@ -519,7 +519,7 @@ int ipath_modify_qp(struct ib_qp *ibqp, 
 		break;
 
 	case IB_QPS_ERR:
-		ipath_error_qp(qp, IB_WC_GENERAL_ERR);
+		ipath_error_qp(qp, IB_WC_WR_FLUSH_ERR);
 		break;
 
 	default:
diff -r 84a9691cf7ff -r aaee8124e3bc drivers/infiniband/hw/ipath/ipath_ud.c
--- a/drivers/infiniband/hw/ipath/ipath_ud.c	Thu Mar 15 14:34:25 2007 -0700
+++ b/drivers/infiniband/hw/ipath/ipath_ud.c	Thu Mar 15 14:34:25 2007 -0700
@@ -647,6 +647,7 @@ void ipath_ud_rcv(struct ipath_ibdev *de
 		ipath_skip_sge(&qp->r_sge, sizeof(struct ib_grh));
 	ipath_copy_sge(&qp->r_sge, data,
 		       wc.byte_len - sizeof(struct ib_grh));
+	qp->r_wrid_valid = 0;
 	wc.wr_id = qp->r_wr_id;
 	wc.status = IB_WC_SUCCESS;
 	wc.opcode = IB_WC_RECV;
