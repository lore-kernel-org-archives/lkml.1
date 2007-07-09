Return-Path: <linux-kernel-owner+w=401wt.eu-S1757781AbXGINe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757781AbXGINe0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 09:34:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755207AbXGINeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 09:34:00 -0400
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:17320 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754509AbXGINd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 09:33:59 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>
Subject: [PATCH 13/13] IB/ehca: Improve latency by unlocking the SQ/RQ after triggering the hardware
User-Agent: KMail/1.8.2
Cc: "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
References: <200707091502.22407.fenkes@de.ibm.com>
In-Reply-To: <200707091502.22407.fenkes@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 1748
Date: Mon, 9 Jul 2007 15:33:52 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200707091533.53383.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hoang-Nam Nguyen <hnguyen@de.ibm.com>

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_reqs.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_reqs.c b/drivers/infiniband/hw/ehca/ehca_reqs.c
index fd3ba22..61da65e 100644
--- a/drivers/infiniband/hw/ehca/ehca_reqs.c
+++ b/drivers/infiniband/hw/ehca/ehca_reqs.c
@@ -407,10 +407,9 @@ int ehca_post_send(struct ib_qp *qp,
 	} /* eof for cur_send_wr */
 
 post_send_exit0:
-	/* UNLOCK the QUEUE */
-	spin_unlock_irqrestore(&my_qp->spinlock_s, flags);
 	iosync(); /* serialize GAL register access */
 	hipz_update_sqa(my_qp, wqe_cnt);
+	spin_unlock_irqrestore(&my_qp->spinlock_s, flags);
 	return ret;
 }
 
@@ -473,9 +472,9 @@ static int internal_post_recv(struct ehca_qp *my_qp,
 	} /* eof for cur_recv_wr */
 
 post_recv_exit0:
-	spin_unlock_irqrestore(&my_qp->spinlock_r, flags);
 	iosync(); /* serialize GAL register access */
 	hipz_update_rqa(my_qp, wqe_cnt);
+	spin_unlock_irqrestore(&my_qp->spinlock_r, flags);
 	return ret;
 }
 
-- 
1.5.2


