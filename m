Return-Path: <linux-kernel-owner+w=401wt.eu-S1031294AbXDJRnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031294AbXDJRnq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 13:43:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031285AbXDJRnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 13:43:46 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:5701 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031294AbXDJRnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 13:43:45 -0400
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 10 Apr 2007 10:43:44 -0700
Message-ID: <ada1wisqg4v.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 10 Apr 2007 17:43:43.0810 (UTC) FILETIME=[C889CA20:01C77B97]
Authentication-Results: sj-dkim-8; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim8002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will two small post-rc6 fixes for crasher bugs:

Erez Zilber (1):
      IB/iser: Don't defer connection failure notification to workqueue

Michael S. Tsirkin (1):
      IPoIB/cm: Fix DMA direction typo

 drivers/infiniband/ulp/ipoib/ipoib_cm.c  |    2 +-
 drivers/infiniband/ulp/iser/iscsi_iser.h |    1 -
 drivers/infiniband/ulp/iser/iser_verbs.c |   40 ++++++++++++------------------
 3 files changed, 17 insertions(+), 26 deletions(-)


diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
index e70492d..2b242a4 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -131,7 +131,7 @@ static struct sk_buff *ipoib_cm_alloc_rx_skb(struct net_device *dev, int id, int
 		skb_fill_page_desc(skb, i, page, 0, PAGE_SIZE);
 
 		mapping[i + 1] = ib_dma_map_page(priv->ca, skb_shinfo(skb)->frags[i].page,
-						 0, PAGE_SIZE, DMA_TO_DEVICE);
+						 0, PAGE_SIZE, DMA_FROM_DEVICE);
 		if (unlikely(ib_dma_mapping_error(priv->ca, mapping[i + 1])))
 			goto partial_error;
 	}
diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index cae8c96..8960196 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -245,7 +245,6 @@ struct iser_conn {
 	wait_queue_head_t	     wait;          /* waitq for conn/disconn  */
 	atomic_t                     post_recv_buf_count; /* posted rx count   */
 	atomic_t                     post_send_buf_count; /* posted tx count   */
-	struct work_struct           comperror_work; /* conn term sleepable ctx*/
 	char 			     name[ISER_OBJECT_NAME_SIZE];
 	struct iser_page_vec         *page_vec;     /* represents SG to fmr maps*
 						     * maps serialized as tx is*/
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 693b770..1fc9674 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -48,7 +48,6 @@
 
 static void iser_cq_tasklet_fn(unsigned long data);
 static void iser_cq_callback(struct ib_cq *cq, void *cq_context);
-static void iser_comp_error_worker(struct work_struct *work);
 
 static void iser_cq_event_callback(struct ib_event *cause, void *context)
 {
@@ -480,7 +479,6 @@ int iser_conn_init(struct iser_conn **ibconn)
 	init_waitqueue_head(&ib_conn->wait);
 	atomic_set(&ib_conn->post_recv_buf_count, 0);
 	atomic_set(&ib_conn->post_send_buf_count, 0);
-	INIT_WORK(&ib_conn->comperror_work, iser_comp_error_worker);
 	INIT_LIST_HEAD(&ib_conn->conn_list);
 	spin_lock_init(&ib_conn->lock);
 
@@ -753,26 +751,6 @@ int iser_post_send(struct iser_desc *tx_desc)
 	return ret_val;
 }
 
-static void iser_comp_error_worker(struct work_struct *work)
-{
-	struct iser_conn *ib_conn =
-		container_of(work, struct iser_conn, comperror_work);
-
-	/* getting here when the state is UP means that the conn is being *
-	 * terminated asynchronously from the iSCSI layer's perspective.  */
-	if (iser_conn_state_comp_exch(ib_conn, ISER_CONN_UP,
-				      ISER_CONN_TERMINATING))
-		iscsi_conn_failure(ib_conn->iser_conn->iscsi_conn,
-					ISCSI_ERR_CONN_FAILED);
-
-	/* complete the termination process if disconnect event was delivered *
-	 * note there are no more non completed posts to the QP               */
-	if (ib_conn->disc_evt_flag) {
-		ib_conn->state = ISER_CONN_DOWN;
-		wake_up_interruptible(&ib_conn->wait);
-	}
-}
-
 static void iser_handle_comp_error(struct iser_desc *desc)
 {
 	struct iser_dto  *dto     = &desc->dto;
@@ -791,8 +769,22 @@ static void iser_handle_comp_error(struct iser_desc *desc)
 	}
 
 	if (atomic_read(&ib_conn->post_recv_buf_count) == 0 &&
-	    atomic_read(&ib_conn->post_send_buf_count) == 0)
-		schedule_work(&ib_conn->comperror_work);
+	    atomic_read(&ib_conn->post_send_buf_count) == 0) {
+		/* getting here when the state is UP means that the conn is *
+		 * being terminated asynchronously from the iSCSI layer's   *
+		 * perspective.                                             */
+		if (iser_conn_state_comp_exch(ib_conn, ISER_CONN_UP,
+		    ISER_CONN_TERMINATING))
+			iscsi_conn_failure(ib_conn->iser_conn->iscsi_conn,
+					   ISCSI_ERR_CONN_FAILED);
+
+		/* complete the termination process if disconnect event was delivered *
+		 * note there are no more non completed posts to the QP               */
+		if (ib_conn->disc_evt_flag) {
+			ib_conn->state = ISER_CONN_DOWN;
+			wake_up_interruptible(&ib_conn->wait);
+		}
+	}
 }
 
 static void iser_cq_tasklet_fn(unsigned long data)
