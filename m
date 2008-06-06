Return-Path: <linux-kernel-owner+w=401wt.eu-S1764192AbYFFS0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764192AbYFFS0j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 14:26:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762886AbYFFS0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 14:26:16 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:43174 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762733AbYFFS0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 14:26:13 -0400
X-IronPort-AV: E=Sophos;i="4.27,601,1204531200"; 
   d="scan'208";a="109527402"
From: Roland Dreier <rdreier@cisco.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
Date: Fri, 06 Jun 2008 11:26:11 -0700
Message-ID: <adad4muctdo.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 06 Jun 2008 18:26:12.0293 (UTC) FILETIME=[CC49AF50:01C8C802]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get some small fixes for various low-level driver issues:

Chien Tung (1):
      MAINTAINERS: Update NetEffect (iw_nes) entry

Joachim Fenkes (1):
      IB/ehca: Reject send WRs only for RESET, INIT and RTR state

Ralph Campbell (2):
      IB/ipath: Fix device capability flags
      IB/ipath: Fix SM trap forwarding

Roland Dreier (1):
      IB/ipath: Avoid test_bit() on u64 SDMA status value

 MAINTAINERS                                |    4 ++--
 drivers/infiniband/hw/ehca/ehca_reqs.c     |    6 ++++--
 drivers/infiniband/hw/ipath/ipath_kernel.h |    5 +++++
 drivers/infiniband/hw/ipath/ipath_mad.c    |    4 ++++
 drivers/infiniband/hw/ipath/ipath_sdma.c   |   12 ++++--------
 drivers/infiniband/hw/ipath/ipath_verbs.c  |    3 ++-
 6 files changed, 21 insertions(+), 13 deletions(-)


diff --git a/MAINTAINERS b/MAINTAINERS
index 0a6d2ca..bd3badb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2866,8 +2866,8 @@ S:	Maintained
 NETEFFECT IWARP RNIC DRIVER (IW_NES)
 P:	Faisal Latif
 M:	flatif@neteffect.com
-P:	Nishi Gupta
-M:	ngupta@neteffect.com
+P:	Chien Tung
+M:	ctung@neteffect.com
 P:	Glenn Streiff
 M:	gstreiff@neteffect.com
 L:	general@lists.openfabrics.org
diff --git a/drivers/infiniband/hw/ehca/ehca_reqs.c b/drivers/infiniband/hw/ehca/ehca_reqs.c
index bbe0436..f093b00 100644
--- a/drivers/infiniband/hw/ehca/ehca_reqs.c
+++ b/drivers/infiniband/hw/ehca/ehca_reqs.c
@@ -421,8 +421,10 @@ int ehca_post_send(struct ib_qp *qp,
 	int ret = 0;
 	unsigned long flags;
 
-	if (unlikely(my_qp->state != IB_QPS_RTS)) {
-		ehca_err(qp->device, "QP not in RTS state  qpn=%x", qp->qp_num);
+	/* Reject WR if QP is in RESET, INIT or RTR state */
+	if (unlikely(my_qp->state < IB_QPS_RTS)) {
+		ehca_err(qp->device, "Invalid QP state  qp_state=%d qpn=%x",
+			 my_qp->state, qp->qp_num);
 		return -EINVAL;
 	}
 
diff --git a/drivers/infiniband/hw/ipath/ipath_kernel.h b/drivers/infiniband/hw/ipath/ipath_kernel.h
index 59a8b25..0bd8bcb 100644
--- a/drivers/infiniband/hw/ipath/ipath_kernel.h
+++ b/drivers/infiniband/hw/ipath/ipath_kernel.h
@@ -232,6 +232,11 @@ struct ipath_sdma_desc {
 #define IPATH_SDMA_TXREQ_S_ABORTED   2
 #define IPATH_SDMA_TXREQ_S_SHUTDOWN  3
 
+#define IPATH_SDMA_STATUS_SCORE_BOARD_DRAIN_IN_PROG	(1ull << 63)
+#define IPATH_SDMA_STATUS_ABORT_IN_PROG			(1ull << 62)
+#define IPATH_SDMA_STATUS_INTERNAL_SDMA_ENABLE		(1ull << 61)
+#define IPATH_SDMA_STATUS_SCB_EMPTY			(1ull << 30)
+
 /* max dwords in small buffer packet */
 #define IPATH_SMALLBUF_DWORDS (dd->ipath_piosize2k >> 2)
 
diff --git a/drivers/infiniband/hw/ipath/ipath_mad.c b/drivers/infiniband/hw/ipath/ipath_mad.c
index 1ff46ae..5f9315d 100644
--- a/drivers/infiniband/hw/ipath/ipath_mad.c
+++ b/drivers/infiniband/hw/ipath/ipath_mad.c
@@ -1492,6 +1492,10 @@ static int process_subn(struct ib_device *ibdev, int mad_flags,
 			goto bail;
 		}
 
+	case IB_MGMT_METHOD_TRAP:
+	case IB_MGMT_METHOD_REPORT:
+	case IB_MGMT_METHOD_REPORT_RESP:
+	case IB_MGMT_METHOD_TRAP_REPRESS:
 	case IB_MGMT_METHOD_GET_RESP:
 		/*
 		 * The ib_mad module will call us to process responses
diff --git a/drivers/infiniband/hw/ipath/ipath_sdma.c b/drivers/infiniband/hw/ipath/ipath_sdma.c
index 0a8c1b8..eaba032 100644
--- a/drivers/infiniband/hw/ipath/ipath_sdma.c
+++ b/drivers/infiniband/hw/ipath/ipath_sdma.c
@@ -263,14 +263,10 @@ static void sdma_abort_task(unsigned long opaque)
 		hwstatus = ipath_read_kreg64(dd,
 				dd->ipath_kregs->kr_senddmastatus);
 
-		if (/* ScoreBoardDrainInProg */
-		    test_bit(63, &hwstatus) ||
-		    /* AbortInProg */
-		    test_bit(62, &hwstatus) ||
-		    /* InternalSDmaEnable */
-		    test_bit(61, &hwstatus) ||
-		    /* ScbEmpty */
-		    !test_bit(30, &hwstatus)) {
+		if ((hwstatus & (IPATH_SDMA_STATUS_SCORE_BOARD_DRAIN_IN_PROG |
+				 IPATH_SDMA_STATUS_ABORT_IN_PROG	     |
+				 IPATH_SDMA_STATUS_INTERNAL_SDMA_ENABLE)) ||
+		    !(hwstatus & IPATH_SDMA_STATUS_SCB_EMPTY)) {
 			if (dd->ipath_sdma_reset_wait > 0) {
 				/* not done shutting down sdma */
 				--dd->ipath_sdma_reset_wait;
diff --git a/drivers/infiniband/hw/ipath/ipath_verbs.c b/drivers/infiniband/hw/ipath/ipath_verbs.c
index e0ec540..7779165 100644
--- a/drivers/infiniband/hw/ipath/ipath_verbs.c
+++ b/drivers/infiniband/hw/ipath/ipath_verbs.c
@@ -1494,7 +1494,8 @@ static int ipath_query_device(struct ib_device *ibdev,
 
 	props->device_cap_flags = IB_DEVICE_BAD_PKEY_CNTR |
 		IB_DEVICE_BAD_QKEY_CNTR | IB_DEVICE_SHUTDOWN_PORT |
-		IB_DEVICE_SYS_IMAGE_GUID;
+		IB_DEVICE_SYS_IMAGE_GUID | IB_DEVICE_RC_RNR_NAK_GEN |
+		IB_DEVICE_PORT_ACTIVE_EVENT | IB_DEVICE_SRQ_RESIZE;
 	props->page_size_cap = PAGE_SIZE;
 	props->vendor_id = dev->dd->ipath_vendorid;
 	props->vendor_part_id = dev->dd->ipath_deviceid;
