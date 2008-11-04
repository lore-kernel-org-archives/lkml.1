Return-Path: <linux-kernel-owner+w=401wt.eu-S1756414AbYKDPAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756414AbYKDPAe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 10:00:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755829AbYKDO4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 09:56:19 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:36751 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755818AbYKDO4R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 09:56:17 -0500
From: Stefan Roscher <ossrosch@linux.vnet.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       Roland Dreier <rolandd@cisco.com>, LKML <linux-kernel@vger.kernel.org>,
       "OF-EWG" <ewg@lists.openfabrics.org>
Subject: [PATCH] IB/ehca: remove reference to the QP in case of port activation failure
Date: Tue, 4 Nov 2008 15:54:43 +0100
User-Agent: KMail/1.9.9
Cc: raisch@de.ibm.com, hnguyen@de.ibm.com, fenkes@de.ibm.com,
       stefan.roscher@de.ibm.com, alexschm@de.ibm.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811041554.45560.ossrosch@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the initialization of a special QP (e.g. AQP1) fails due to a software timeout,
we have to remove the reference to that special QP struct from the port struct
preventing the driver to access the QP, since it will be/has been destroyed
by the caller, ie in this case ib_mad.
This patch will apply cleanly on top of 2.6.28 git tree.

Signed-off-by: Stefan Roscher <stefan.roscher@de.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_irq.c |    7 +++++--
 drivers/infiniband/hw/ehca/ehca_qp.c  |    5 +++++
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_irq.c b/drivers/infiniband/hw/ehca/ehca_irq.c
index cb55be0..9e43459 100644
--- a/drivers/infiniband/hw/ehca/ehca_irq.c
+++ b/drivers/infiniband/hw/ehca/ehca_irq.c
@@ -370,6 +370,10 @@ static void parse_ec(struct ehca_shca *shca, u64 eqe)
 	switch (ec) {
 	case 0x30: /* port availability change */
 		if (EHCA_BMASK_GET(NEQE_PORT_AVAILABILITY, eqe)) {
+			/* only for autodetect mode important */
+			if (ehca_nr_ports >= 0)
+				break;
+
 			int suppress_event;
 			/* replay modify_qp for sqps */
 			spin_lock_irqsave(&sport->mod_sqp_lock, flags);
@@ -387,8 +391,7 @@ static void parse_ec(struct ehca_shca *shca, u64 eqe)
 			sport->port_state = IB_PORT_ACTIVE;
 			dispatch_port_event(shca, port, IB_EVENT_PORT_ACTIVE,
 					    "is active");
-			ehca_query_sma_attr(shca, port,
-					    &sport->saved_attr);
+			ehca_query_sma_attr(shca, port, &sport->saved_attr);
 		} else {
 			sport->port_state = IB_PORT_DOWN;
 			dispatch_port_event(shca, port, IB_EVENT_PORT_ERR,
diff --git a/drivers/infiniband/hw/ehca/ehca_qp.c b/drivers/infiniband/hw/ehca/ehca_qp.c
index 4d54b9f..9e05ee2 100644
--- a/drivers/infiniband/hw/ehca/ehca_qp.c
+++ b/drivers/infiniband/hw/ehca/ehca_qp.c
@@ -860,6 +860,11 @@ static struct ehca_qp *internal_create_qp(
 	if (qp_type == IB_QPT_GSI) {
 		h_ret = ehca_define_sqp(shca, my_qp, init_attr);
 		if (h_ret != H_SUCCESS) {
+			kfree(my_qp->mod_qp_parm);
+			my_qp->mod_qp_parm = NULL;
+			/* the QP pointer is no longer valid */
+			shca->sport[init_attr->port_num - 1].ibqp_sqp[qp_type] =
+				NULL;
 			ret = ehca2ib_return_code(h_ret);
 			goto create_qp_exit6;
 		}
-- 
1.5.5

