Return-Path: <linux-kernel-owner+w=401wt.eu-S1754979AbYHLNsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979AbYHLNsK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 09:48:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754435AbYHLNqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 09:46:47 -0400
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:26505 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754412AbYHLNqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 09:46:46 -0400
From: Alexander Schmidt <alexs@linux.vnet.ibm.com>
To: Roland Dreier <rolandd@cisco.com>, "of-ewg" <ewg@lists.openfabrics.org>,
       "of-general" <general@lists.openfabrics.org>,
       lkml <linux-kernel@vger.kernel.org>,
       "linuxppc-dev" <linuxppc-dev@ozlabs.org>
Subject: [PATCH 4/5 try2] ib/ehca: check idr_find() return value
Date: Tue, 12 Aug 2008 15:46:27 +0200
User-Agent: KMail/1.9.9
Cc: Stefan Roscher <stefan.roscher@de.ibm.com>,
       "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Joachim Fenkes <fenkes@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200808121546.27705.alexs@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The idr_find() function may fail when trying to get the QP that is associated
with a CQE, e.g. when a QP has been destroyed between the generation of a CQE
and the poll request for it. In consequence, the return value of idr_find()
must be checked and the CQE must be discarded when the QP cannot be found.

Signed-off-by: Alexander Schmidt <alexs@linux.vnet.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_reqs.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- infiniband.git.orig/drivers/infiniband/hw/ehca/ehca_reqs.c
+++ infiniband.git/drivers/infiniband/hw/ehca/ehca_reqs.c
@@ -680,8 +680,10 @@ repoll:
 
 	read_lock(&ehca_qp_idr_lock);
 	my_qp = idr_find(&ehca_qp_idr, cqe->qp_token);
-	wc->qp = &my_qp->ib_qp;
 	read_unlock(&ehca_qp_idr_lock);
+	if (!my_qp)
+		goto repoll;
+	wc->qp = &my_qp->ib_qp;
 
 	wc->byte_len = cqe->nr_bytes_transferred;
 	wc->pkey_index = cqe->pkey_index;
