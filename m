Return-Path: <linux-kernel-owner+w=401wt.eu-S1757179AbXGINax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757179AbXGINax (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 09:30:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752635AbXGINap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 09:30:45 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:34406 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbXGINao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 09:30:44 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>
Subject: [PATCH 09/13] IB/ehca: Refactor synchronization between completions and destroy_cq using atomic_t
User-Agent: KMail/1.8.2
Cc: "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
References: <200707091502.22407.fenkes@de.ibm.com>
In-Reply-To: <200707091502.22407.fenkes@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 1748
Date: Mon, 9 Jul 2007 15:30:39 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200707091530.40581.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

- ehca_cq.nr_events is made an atomic_t, eliminating a lot of locking.
- The CQ is removed from the CQ idr first now to make sure no more
  completions are scheduled on that CQ. The "wait for all completions to
  end" code becomes much simpler this way.

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_classes.h |    4 +-
 drivers/infiniband/hw/ehca/ehca_cq.c      |   26 +++++++-------------
 drivers/infiniband/hw/ehca/ehca_irq.c     |   36 +++++++++++++---------------
 drivers/infiniband/hw/ehca/ehca_irq.h     |    1 -
 drivers/infiniband/hw/ehca/ehca_tools.h   |    1 +
 5 files changed, 29 insertions(+), 39 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_classes.h b/drivers/infiniband/hw/ehca/ehca_classes.h
index 3550047..8580f2a 100644
--- a/drivers/infiniband/hw/ehca/ehca_classes.h
+++ b/drivers/infiniband/hw/ehca/ehca_classes.h
@@ -174,8 +174,8 @@ struct ehca_cq {
 	spinlock_t cb_lock;
 	struct hlist_head qp_hashtab[QP_HASHTAB_LEN];
 	struct list_head entry;
-	u32 nr_callbacks; /* #events assigned to cpu by scaling code */
-	u32 nr_events;    /* #events seen */
+	u32 nr_callbacks;   /* #events assigned to cpu by scaling code */
+	atomic_t nr_events; /* #events seen */
 	wait_queue_head_t wait_completion;
 	spinlock_t task_lock;
 	u32 ownpid;
diff --git a/drivers/infiniband/hw/ehca/ehca_cq.c b/drivers/infiniband/hw/ehca/ehca_cq.c
index 94bad27..3729997 100644
--- a/drivers/infiniband/hw/ehca/ehca_cq.c
+++ b/drivers/infiniband/hw/ehca/ehca_cq.c
@@ -146,6 +146,7 @@ struct ib_cq *ehca_create_cq(struct ib_device *device, int cqe, int comp_vector,
 	spin_lock_init(&my_cq->spinlock);
 	spin_lock_init(&my_cq->cb_lock);
 	spin_lock_init(&my_cq->task_lock);
+	atomic_set(&my_cq->nr_events, 0);
 	init_waitqueue_head(&my_cq->wait_completion);
 	my_cq->ownpid = current->tgid;
 
@@ -303,16 +304,6 @@ create_cq_exit1:
 	return cq;
 }
 
-static int get_cq_nr_events(struct ehca_cq *my_cq)
-{
-	int ret;
-	unsigned long flags;
-	spin_lock_irqsave(&ehca_cq_idr_lock, flags);
-	ret = my_cq->nr_events;
-	spin_unlock_irqrestore(&ehca_cq_idr_lock, flags);
-	return ret;
-}
-
 int ehca_destroy_cq(struct ib_cq *cq)
 {
 	u64 h_ret;
@@ -339,17 +330,18 @@ int ehca_destroy_cq(struct ib_cq *cq)
 		}
 	}
 
+	/*
+	 * remove the CQ from the idr first to make sure
+	 * no more interrupt tasklets will touch this CQ
+	 */
 	spin_lock_irqsave(&ehca_cq_idr_lock, flags);
-	while (my_cq->nr_events) {
-		spin_unlock_irqrestore(&ehca_cq_idr_lock, flags);
-		wait_event(my_cq->wait_completion, !get_cq_nr_events(my_cq));
-		spin_lock_irqsave(&ehca_cq_idr_lock, flags);
-		/* recheck nr_events to assure no cqe has just arrived */
-	}
-
 	idr_remove(&ehca_cq_idr, my_cq->token);
 	spin_unlock_irqrestore(&ehca_cq_idr_lock, flags);
 
+	/* now wait until all pending events have completed */
+	wait_event(my_cq->wait_completion, !atomic_read(&my_cq->nr_events));
+
+	/* nobody's using our CQ any longer -- we can destroy it */
 	h_ret = hipz_h_destroy_cq(adapter_handle, my_cq, 0);
 	if (h_ret == H_R_STATE) {
 		/* cq in err: read err data and destroy it forcibly */
diff --git a/drivers/infiniband/hw/ehca/ehca_irq.c b/drivers/infiniband/hw/ehca/ehca_irq.c
index 100329b..3e790a3 100644
--- a/drivers/infiniband/hw/ehca/ehca_irq.c
+++ b/drivers/infiniband/hw/ehca/ehca_irq.c
@@ -5,6 +5,8 @@
  *
  *  Authors: Heiko J Schick <schickhj@de.ibm.com>
  *           Khadija Souissi <souissi@de.ibm.com>
+ *           Hoang-Nam Nguyen <hnguyen@de.ibm.com>
+ *           Joachim Fenkes <fenkes@de.ibm.com>
  *
  *  Copyright (c) 2005 IBM Corporation
  *
@@ -212,6 +214,8 @@ static void cq_event_callback(struct ehca_shca *shca,
 
 	spin_lock_irqsave(&ehca_cq_idr_lock, flags);
 	cq = idr_find(&ehca_cq_idr, token);
+	if (cq)
+		atomic_inc(&cq->nr_events);
 	spin_unlock_irqrestore(&ehca_cq_idr_lock, flags);
 
 	if (!cq)
@@ -219,6 +223,9 @@ static void cq_event_callback(struct ehca_shca *shca,
 
 	ehca_error_data(shca, cq, cq->ipz_cq_handle.handle);
 
+	if (atomic_dec_and_test(&cq->nr_events))
+		wake_up(&cq->wait_completion);
+
 	return;
 }
 
@@ -414,25 +421,22 @@ static inline void process_eqe(struct ehca_shca *shca, struct ehca_eqe *eqe)
 		token = EHCA_BMASK_GET(EQE_CQ_TOKEN, eqe_value);
 		spin_lock_irqsave(&ehca_cq_idr_lock, flags);
 		cq = idr_find(&ehca_cq_idr, token);
+		if (cq)
+			atomic_inc(&cq->nr_events);
+		spin_unlock_irqrestore(&ehca_cq_idr_lock, flags);
 		if (cq == NULL) {
-			spin_unlock_irqrestore(&ehca_cq_idr_lock, flags);
 			ehca_err(&shca->ib_device,
 				 "Invalid eqe for non-existing cq token=%x",
 				 token);
 			return;
 		}
 		reset_eq_pending(cq);
-		cq->nr_events++;
-		spin_unlock_irqrestore(&ehca_cq_idr_lock, flags);
 		if (ehca_scaling_code)
 			queue_comp_task(cq);
 		else {
 			comp_event_callback(cq);
-			spin_lock_irqsave(&ehca_cq_idr_lock, flags);
-			cq->nr_events--;
-			if (!cq->nr_events)
+			if (atomic_dec_and_test(&cq->nr_events))
 				wake_up(&cq->wait_completion);
-			spin_unlock_irqrestore(&ehca_cq_idr_lock, flags);
 		}
 	} else {
 		ehca_dbg(&shca->ib_device, "Got non completion event");
@@ -478,15 +482,15 @@ void ehca_process_eq(struct ehca_shca *shca, int is_irq)
 			token = EHCA_BMASK_GET(EQE_CQ_TOKEN, eqe_value);
 			spin_lock(&ehca_cq_idr_lock);
 			eqe_cache[eqe_cnt].cq = idr_find(&ehca_cq_idr, token);
+			if (eqe_cache[eqe_cnt].cq)
+				atomic_inc(&eqe_cache[eqe_cnt].cq->nr_events);
+			spin_unlock(&ehca_cq_idr_lock);
 			if (!eqe_cache[eqe_cnt].cq) {
-				spin_unlock(&ehca_cq_idr_lock);
 				ehca_err(&shca->ib_device,
 					 "Invalid eqe for non-existing cq "
 					 "token=%x", token);
 				continue;
 			}
-			eqe_cache[eqe_cnt].cq->nr_events++;
-			spin_unlock(&ehca_cq_idr_lock);
 		} else
 			eqe_cache[eqe_cnt].cq = NULL;
 		eqe_cnt++;
@@ -517,11 +521,8 @@ void ehca_process_eq(struct ehca_shca *shca, int is_irq)
 			else {
 				struct ehca_cq *cq = eq->eqe_cache[i].cq;
 				comp_event_callback(cq);
-				spin_lock(&ehca_cq_idr_lock);
-				cq->nr_events--;
-				if (!cq->nr_events)
+				if (atomic_dec_and_test(&cq->nr_events))
 					wake_up(&cq->wait_completion);
-				spin_unlock(&ehca_cq_idr_lock);
 			}
 		} else {
 			ehca_dbg(&shca->ib_device, "Got non completion event");
@@ -621,13 +622,10 @@ static void run_comp_task(struct ehca_cpu_comp_task* cct)
 	while (!list_empty(&cct->cq_list)) {
 		cq = list_entry(cct->cq_list.next, struct ehca_cq, entry);
 		spin_unlock_irqrestore(&cct->task_lock, flags);
-		comp_event_callback(cq);
 
-		spin_lock_irqsave(&ehca_cq_idr_lock, flags);
-		cq->nr_events--;
-		if (!cq->nr_events)
+		comp_event_callback(cq);
+		if (atomic_dec_and_test(&cq->nr_events))
 			wake_up(&cq->wait_completion);
-		spin_unlock_irqrestore(&ehca_cq_idr_lock, flags);
 
 		spin_lock_irqsave(&cct->task_lock, flags);
 		spin_lock(&cq->task_lock);
diff --git a/drivers/infiniband/hw/ehca/ehca_irq.h b/drivers/infiniband/hw/ehca/ehca_irq.h
index 6ed06ee..3346cb0 100644
--- a/drivers/infiniband/hw/ehca/ehca_irq.h
+++ b/drivers/infiniband/hw/ehca/ehca_irq.h
@@ -47,7 +47,6 @@ struct ehca_shca;
 
 #include <linux/interrupt.h>
 #include <linux/types.h>
-#include <asm/atomic.h>
 
 int ehca_error_data(struct ehca_shca *shca, void *data, u64 resource);
 
diff --git a/drivers/infiniband/hw/ehca/ehca_tools.h b/drivers/infiniband/hw/ehca/ehca_tools.h
index 973c4b5..03b185f 100644
--- a/drivers/infiniband/hw/ehca/ehca_tools.h
+++ b/drivers/infiniband/hw/ehca/ehca_tools.h
@@ -59,6 +59,7 @@
 #include <linux/cpu.h>
 #include <linux/device.h>
 
+#include <asm/atomic.h>
 #include <asm/abs_addr.h>
 #include <asm/ibmebus.h>
 #include <asm/io.h>
-- 
1.5.2


