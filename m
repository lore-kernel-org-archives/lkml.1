Return-Path: <linux-kernel-owner+w=401wt.eu-S1758107AbXJ3WR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758107AbXJ3WR1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 18:17:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752059AbXJ3WRR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 18:17:17 -0400
Received: from sj-iport-2-in.cisco.com ([171.71.176.71]:58944 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111AbXJ3WRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 18:17:15 -0400
X-IronPort-AV: E=Sophos;i="4.21,349,1188802800"; 
   d="scan'208";a="411834351"
To: torvalds@linux-foundation.org
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 30 Oct 2007 15:17:10 -0700
Message-ID: <adar6jci6xl.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 30 Oct 2007 22:17:11.0315 (UTC) FILETIME=[9E079E30:01C81B42]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will pull some fixes for 2.6.24:

Anton Blanchard (1):
      IB/fmr_pool: Stop ib_fmr threads from contributing to load average

Dave Olson (1):
      IB/ipath: Fix incorrect use of sizeof on msg buffer (function argument)

Michael Albaugh (1):
      IB/ipath: Limit length checksummed in eeprom

Ralph Campbell (1):
      IB/ipath: Fix a race where s_last is updated without lock held

Roland Dreier (2):
      IPoIB/cm: Fix receive QP cleanup
      IB/mlx4: Lock SQ lock in mlx4_ib_post_send()

 drivers/infiniband/core/fmr_pool.c         |    8 ++++----
 drivers/infiniband/hw/ipath/ipath_eeprom.c |   10 +++++++++-
 drivers/infiniband/hw/ipath/ipath_intr.c   |   18 +++++++++---------
 drivers/infiniband/hw/ipath/ipath_ruc.c    |   14 +++++++++-----
 drivers/infiniband/hw/mlx4/qp.c            |    4 ++--
 drivers/infiniband/ulp/ipoib/ipoib_cm.c    |    2 +-
 6 files changed, 34 insertions(+), 22 deletions(-)


diff --git a/drivers/infiniband/core/fmr_pool.c b/drivers/infiniband/core/fmr_pool.c
index d7f6452..e8d5f6b 100644
--- a/drivers/infiniband/core/fmr_pool.c
+++ b/drivers/infiniband/core/fmr_pool.c
@@ -291,10 +291,10 @@ struct ib_fmr_pool *ib_create_fmr_pool(struct ib_pd             *pd,
 	atomic_set(&pool->flush_ser, 0);
 	init_waitqueue_head(&pool->force_wait);
 
-	pool->thread = kthread_create(ib_fmr_cleanup_thread,
-				      pool,
-				      "ib_fmr(%s)",
-				      device->name);
+	pool->thread = kthread_run(ib_fmr_cleanup_thread,
+				   pool,
+				   "ib_fmr(%s)",
+				   device->name);
 	if (IS_ERR(pool->thread)) {
 		printk(KERN_WARNING PFX "couldn't start cleanup thread\n");
 		ret = PTR_ERR(pool->thread);
diff --git a/drivers/infiniband/hw/ipath/ipath_eeprom.c b/drivers/infiniband/hw/ipath/ipath_eeprom.c
index bcfa3cc..e7c25db 100644
--- a/drivers/infiniband/hw/ipath/ipath_eeprom.c
+++ b/drivers/infiniband/hw/ipath/ipath_eeprom.c
@@ -538,7 +538,15 @@ static u8 flash_csum(struct ipath_flash *ifp, int adjust)
 	u8 *ip = (u8 *) ifp;
 	u8 csum = 0, len;
 
-	for (len = 0; len < ifp->if_length; len++)
+	/*
+	 * Limit length checksummed to max length of actual data.
+	 * Checksum of erased eeprom will still be bad, but we avoid
+	 * reading past the end of the buffer we were passed.
+	 */
+	len = ifp->if_length;
+	if (len > sizeof(struct ipath_flash))
+		len = sizeof(struct ipath_flash);
+	while (len--)
 		csum += *ip++;
 	csum -= ifp->if_csum;
 	csum = ~csum;
diff --git a/drivers/infiniband/hw/ipath/ipath_intr.c b/drivers/infiniband/hw/ipath/ipath_intr.c
index 6a5dd5c..c61f9da 100644
--- a/drivers/infiniband/hw/ipath/ipath_intr.c
+++ b/drivers/infiniband/hw/ipath/ipath_intr.c
@@ -453,7 +453,7 @@ skip_ibchange:
 }
 
 static void handle_supp_msgs(struct ipath_devdata *dd,
-			     unsigned supp_msgs, char msg[512])
+			     unsigned supp_msgs, char *msg, int msgsz)
 {
 	/*
 	 * Print the message unless it's ibc status change only, which
@@ -461,9 +461,9 @@ static void handle_supp_msgs(struct ipath_devdata *dd,
 	 */
 	if (dd->ipath_lasterror & ~INFINIPATH_E_IBSTATUSCHANGED) {
 		int iserr;
-		iserr = ipath_decode_err(msg, sizeof msg,
-				dd->ipath_lasterror &
-				~INFINIPATH_E_IBSTATUSCHANGED);
+		iserr = ipath_decode_err(msg, msgsz,
+					 dd->ipath_lasterror &
+					 ~INFINIPATH_E_IBSTATUSCHANGED);
 		if (dd->ipath_lasterror &
 			~(INFINIPATH_E_RRCVEGRFULL |
 			INFINIPATH_E_RRCVHDRFULL | INFINIPATH_E_PKTERRS))
@@ -492,8 +492,8 @@ static void handle_supp_msgs(struct ipath_devdata *dd,
 }
 
 static unsigned handle_frequent_errors(struct ipath_devdata *dd,
-				       ipath_err_t errs, char msg[512],
-				       int *noprint)
+				       ipath_err_t errs, char *msg,
+				       int msgsz, int *noprint)
 {
 	unsigned long nc;
 	static unsigned long nextmsg_time;
@@ -512,7 +512,7 @@ static unsigned handle_frequent_errors(struct ipath_devdata *dd,
 				nextmsg_time = nc + HZ * 3;
 		}
 		else if (supp_msgs) {
-			handle_supp_msgs(dd, supp_msgs, msg);
+			handle_supp_msgs(dd, supp_msgs, msg, msgsz);
 			supp_msgs = 0;
 			nmsgs = 0;
 		}
@@ -525,14 +525,14 @@ static unsigned handle_frequent_errors(struct ipath_devdata *dd,
 
 static int handle_errors(struct ipath_devdata *dd, ipath_err_t errs)
 {
-	char msg[512];
+	char msg[128];
 	u64 ignore_this_time = 0;
 	int i, iserr = 0;
 	int chkerrpkts = 0, noprint = 0;
 	unsigned supp_msgs;
 	int log_idx;
 
-	supp_msgs = handle_frequent_errors(dd, errs, msg, &noprint);
+	supp_msgs = handle_frequent_errors(dd, errs, msg, sizeof msg, &noprint);
 
 	/* don't report errors that are masked */
 	errs &= ~dd->ipath_maskederrs;
diff --git a/drivers/infiniband/hw/ipath/ipath_ruc.c b/drivers/infiniband/hw/ipath/ipath_ruc.c
index 4b6b7ee..54c61a9 100644
--- a/drivers/infiniband/hw/ipath/ipath_ruc.c
+++ b/drivers/infiniband/hw/ipath/ipath_ruc.c
@@ -630,11 +630,8 @@ bail:;
 void ipath_send_complete(struct ipath_qp *qp, struct ipath_swqe *wqe,
 			 enum ib_wc_status status)
 {
-	u32 last = qp->s_last;
-
-	if (++last == qp->s_size)
-		last = 0;
-	qp->s_last = last;
+	unsigned long flags;
+	u32 last;
 
 	/* See ch. 11.2.4.1 and 10.7.3.1 */
 	if (!(qp->s_flags & IPATH_S_SIGNAL_REQ_WR) ||
@@ -658,4 +655,11 @@ void ipath_send_complete(struct ipath_qp *qp, struct ipath_swqe *wqe,
 		wc.port_num = 0;
 		ipath_cq_enter(to_icq(qp->ibqp.send_cq), &wc, 0);
 	}
+
+	spin_lock_irqsave(&qp->s_lock, flags);
+	last = qp->s_last;
+	if (++last >= qp->s_size)
+		last = 0;
+	qp->s_last = last;
+	spin_unlock_irqrestore(&qp->s_lock, flags);
 }
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 6b33224..8cba9c5 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -1282,7 +1282,7 @@ int mlx4_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 	int size;
 	int i;
 
-	spin_lock_irqsave(&qp->rq.lock, flags);
+	spin_lock_irqsave(&qp->sq.lock, flags);
 
 	ind = qp->sq.head;
 
@@ -1448,7 +1448,7 @@ out:
 			       (qp->sq.wqe_cnt - 1));
 	}
 
-	spin_unlock_irqrestore(&qp->rq.lock, flags);
+	spin_unlock_irqrestore(&qp->sq.lock, flags);
 
 	return err;
 }
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
index 8761077..059cf92 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -60,7 +60,7 @@ static struct ib_qp_attr ipoib_cm_err_attr = {
 	.qp_state = IB_QPS_ERR
 };
 
-#define IPOIB_CM_RX_DRAIN_WRID 0x7fffffff
+#define IPOIB_CM_RX_DRAIN_WRID 0xffffffff
 
 static struct ib_send_wr ipoib_cm_rx_drain_wr = {
 	.wr_id = IPOIB_CM_RX_DRAIN_WRID,
