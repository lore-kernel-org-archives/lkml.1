Return-Path: <linux-kernel-owner+w=401wt.eu-S1754705AbYCQMtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705AbYCQMtR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 08:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752451AbYCQMtF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 08:49:05 -0400
Received: from sacred.ru ([62.205.161.221]:45483 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751946AbYCQMtC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 08:49:02 -0400
Message-ID: <47DE6899.7000903@openvz.org>
Date: Mon, 17 Mar 2008 15:48:25 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Roland Dreier <rolandd@cisco.com>, Sean Hefty <sean.hefty@intel.com>,
       Hal Rosenstock <hal.rosenstock@gmail.com>
CC: general@lists.openfabrics.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Hoang-Nam Nguyen <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>
Subject: [PATCH 2/3] Infiniband: make ehca_cq use struct pid pointer rather
 than pid_t
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Mon, 17 Mar 2008 15:48:17 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The task_struct->tgid field is about to become deprecated, due to
pid namespaces make tasks have many pids, not one. The infiniband
driver is one of the code, that still uses it in some places.

Now make struct ehca_cq use a struct pid pointer and consolidate
owners check into one call.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---

 drivers/infiniband/hw/ehca/ehca_classes.h |    2 +-
 drivers/infiniband/hw/ehca/ehca_cq.c      |   30 ++++++++++++++++++------------
 drivers/infiniband/hw/ehca/ehca_tools.h   |    2 ++
 drivers/infiniband/hw/ehca/ehca_uverbs.c  |    7 +------
 4 files changed, 22 insertions(+), 19 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_classes.h b/drivers/infiniband/hw/ehca/ehca_classes.h
index 92cce8a..29004cb 100644
--- a/drivers/infiniband/hw/ehca/ehca_classes.h
+++ b/drivers/infiniband/hw/ehca/ehca_classes.h
@@ -215,7 +215,7 @@ struct ehca_cq {
 	atomic_t nr_events; /* #events seen */
 	wait_queue_head_t wait_completion;
 	spinlock_t task_lock;
-	u32 ownpid;
+	struct pid *ownpid;
 	/* mmap counter for resources mapped into user space */
 	u32 mm_count_queue;
 	u32 mm_count_galpa;
diff --git a/drivers/infiniband/hw/ehca/ehca_cq.c b/drivers/infiniband/hw/ehca/ehca_cq.c
index 0467c15..db25056 100644
--- a/drivers/infiniband/hw/ehca/ehca_cq.c
+++ b/drivers/infiniband/hw/ehca/ehca_cq.c
@@ -113,6 +113,19 @@ struct ehca_qp *ehca_cq_get_qp(struct ehca_cq *cq, int real_qp_num)
 	return ret;
 }
 
+int ehca_check_cq_owner(struct ib_device *device, struct ehca_cq *cq)
+{
+	struct pid *cur_pid = task_tgid(current);
+
+	if (likely(cur_pid == cq->ownpid))
+		return 0;
+
+	ehca_err(device, "Invalid caller pid=%x ownpid=%x "
+			"cq_num=%x",
+			pid_nr(cur_pid), pid_nr(cq->ownpid), cq->cq_number);
+	return -EINVAL;
+}
+
 struct ib_cq *ehca_create_cq(struct ib_device *device, int cqe, int comp_vector,
 			     struct ib_ucontext *context,
 			     struct ib_udata *udata)
@@ -148,7 +161,7 @@ struct ib_cq *ehca_create_cq(struct ib_device *device, int cqe, int comp_vector,
 	spin_lock_init(&my_cq->task_lock);
 	atomic_set(&my_cq->nr_events, 0);
 	init_waitqueue_head(&my_cq->wait_completion);
-	my_cq->ownpid = current->tgid;
+	my_cq->ownpid = get_pid(task_tgid(current));
 
 	cq = &my_cq->ib_cq;
 
@@ -306,6 +319,7 @@ create_cq_exit2:
 	write_unlock_irqrestore(&ehca_cq_idr_lock, flags);
 
 create_cq_exit1:
+	put_pid(my_cq->ownpid);
 	kmem_cache_free(cq_cache, my_cq);
 
 	return cq;
@@ -320,7 +334,6 @@ int ehca_destroy_cq(struct ib_cq *cq)
 	struct ehca_shca *shca = container_of(device, struct ehca_shca,
 					      ib_device);
 	struct ipz_adapter_handle adapter_handle = shca->ipz_hca_handle;
-	u32 cur_pid = current->tgid;
 	unsigned long flags;
 
 	if (cq->uobject) {
@@ -329,12 +342,8 @@ int ehca_destroy_cq(struct ib_cq *cq)
 				 "user space cq_num=%x", my_cq->cq_number);
 			return -EINVAL;
 		}
-		if (my_cq->ownpid != cur_pid) {
-			ehca_err(device, "Invalid caller pid=%x ownpid=%x "
-				 "cq_num=%x",
-				 cur_pid, my_cq->ownpid, my_cq->cq_number);
+		if (ehca_check_cq_owner(device, my_cq))
 			return -EINVAL;
-		}
 	}
 
 	/*
@@ -367,6 +376,7 @@ int ehca_destroy_cq(struct ib_cq *cq)
 		return ehca2ib_return_code(h_ret);
 	}
 	ipz_queue_dtor(NULL, &my_cq->ipz_queue);
+	put_pid(my_cq->ownpid);
 	kmem_cache_free(cq_cache, my_cq);
 
 	return 0;
@@ -375,13 +385,9 @@ int ehca_destroy_cq(struct ib_cq *cq)
 int ehca_resize_cq(struct ib_cq *cq, int cqe, struct ib_udata *udata)
 {
 	struct ehca_cq *my_cq = container_of(cq, struct ehca_cq, ib_cq);
-	u32 cur_pid = current->tgid;
 
-	if (cq->uobject && my_cq->ownpid != cur_pid) {
-		ehca_err(cq->device, "Invalid caller pid=%x ownpid=%x",
-			 cur_pid, my_cq->ownpid);
+	if (cq->uobject && ehca_check_cq_owner(cq->device, my_cq))
 		return -EINVAL;
-	}
 
 	/* TODO: proper resize needs to be done */
 	ehca_err(cq->device, "not implemented yet");
diff --git a/drivers/infiniband/hw/ehca/ehca_tools.h b/drivers/infiniband/hw/ehca/ehca_tools.h
index 4a8346a..0e59891 100644
--- a/drivers/infiniband/hw/ehca/ehca_tools.h
+++ b/drivers/infiniband/hw/ehca/ehca_tools.h
@@ -154,8 +154,10 @@ extern int ehca_debug_level;
 int ehca2ib_return_code(u64 ehca_rc);
 
 struct ib_device;
+struct ehca_cq;
 struct ehca_pd;
 
+int ehca_check_cq_owner(struct ib_device *device, struct ehca_cq *cq);
 int ehca_check_pd_owner(struct ib_device *device, struct ehca_pd *pd);
 
 #endif /* EHCA_TOOLS_H */
diff --git a/drivers/infiniband/hw/ehca/ehca_uverbs.c b/drivers/infiniband/hw/ehca/ehca_uverbs.c
index 5234d6c..82746da 100644
--- a/drivers/infiniband/hw/ehca/ehca_uverbs.c
+++ b/drivers/infiniband/hw/ehca/ehca_uverbs.c
@@ -253,7 +253,6 @@ int ehca_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
 	u32 idr_handle = fileoffset & 0x1FFFFFF;
 	u32 q_type = (fileoffset >> 27) & 0x1;	  /* CQ, QP,...        */
 	u32 rsrc_type = (fileoffset >> 25) & 0x3; /* sq,rq,cmnd_window */
-	u32 cur_pid = current->tgid;
 	u32 ret;
 	struct ehca_cq *cq;
 	struct ehca_qp *qp;
@@ -270,12 +269,8 @@ int ehca_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
 		if (!cq)
 			return -EINVAL;
 
-		if (cq->ownpid != cur_pid) {
-			ehca_err(cq->ib_cq.device,
-				 "Invalid caller pid=%x ownpid=%x",
-				 cur_pid, cq->ownpid);
+		if (ehca_check_cq_owner(cq->ib_cq.device, cq))
 			return -ENOMEM;
-		}
 
 		if (!cq->ib_cq.uobject || cq->ib_cq.uobject->context != context)
 			return -EINVAL;

