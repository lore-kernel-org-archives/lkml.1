Return-Path: <linux-kernel-owner+w=401wt.eu-S1752394AbYHLMuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394AbYHLMuc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 08:50:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752382AbYHLMt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 08:49:56 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:63156 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154AbYHLMtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 08:49:55 -0400
Date: Tue, 12 Aug 2008 14:49:46 +0200
From: Alexander Schmidt <alexs@linux.vnet.ibm.com>
To: linuxppc-dev <linuxppc-dev@ozlabs.org>,
       lkml <linux-kernel@vger.kernel.org>, of-ewg <ewg@lists.openfabrics.org>,
       of-general <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>
Cc: Christoph Raisch <raisch@de.ibm.com>,
       Hoang-Nam Nguyen <HNGUYEN@de.ibm.com>,
       Joachim Fenkes <fenkes@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
Subject: [PATCH 4/5] ib/ehca: check idr_find() return value
Message-ID: <20080812144946.5e2499f8@BL3D1974.boeblingen.de.ibm.com>
In-Reply-To: <20080812143542.0cbde755@BL3D1974.boeblingen.de.ibm.com>
References: <20080812143542.0cbde755@BL3D1974.boeblingen.de.ibm.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The idr_find() function may fail when trying to get the QP that is
associated with a CQE, e.g. when a QP has been destroyed between the
generation of a CQE and the poll request for it. In consequence, the
return value of idr_find() must be checked and the CQE must be
discarded when the QP cannot be found.

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
