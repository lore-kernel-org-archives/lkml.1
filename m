Return-Path: <linux-kernel-owner+w=401wt.eu-S1758069AbYAXRGG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758069AbYAXRGG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 12:06:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758516AbYAXQ7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 11:59:13 -0500
Received: from mtagate4.de.ibm.com ([195.212.29.153]:43171 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757179AbYAXQ7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 11:59:12 -0500
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>, "OF-EWG" <ewg@lists.openfabrics.org>
Subject: [PATCH] IB/ehca: Prevent sending UD packets to QP0
User-Agent: KMail/1.8.2
Cc: "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 2328
Date: Thu, 24 Jan 2008 17:59:08 +0100
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200801241759.09065.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IB spec doesn't allow packets to QP0 sent on any other VL than VL15.
Hardware doesn't filter those packets on the send side, so we need to do
this in the driver and firmware.

As eHCA doesn't support QP0, we can just filter out all traffic going to
QP0, regardless of SL or VL.

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_reqs.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_reqs.c b/drivers/infiniband/hw/ehca/ehca_reqs.c
index 3aacc8c..2ce8cff 100644
--- a/drivers/infiniband/hw/ehca/ehca_reqs.c
+++ b/drivers/infiniband/hw/ehca/ehca_reqs.c
@@ -209,6 +209,10 @@ static inline int ehca_write_swqe(struct ehca_qp *qp,
 			ehca_gen_err("wr.ud.ah is NULL. qp=%p", qp);
 			return -EINVAL;
 		}
+		if (unlikely(send_wr->wr.ud.remote_qpn == 0)) {
+			ehca_gen_err("dest QP# is 0. qp=%x", qp->real_qp_num);
+			return -EINVAL;
+		}
 		my_av = container_of(send_wr->wr.ud.ah, struct ehca_av, ib_ah);
 		wqe_p->u.ud_av.ud_av = my_av->av;
 
-- 
1.5.2


