Return-Path: <linux-kernel-owner+w=401wt.eu-S1754270AbYCQMrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270AbYCQMrd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 08:47:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752953AbYCQMr0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 08:47:26 -0400
Received: from sacred.ru ([62.205.161.221]:45045 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752451AbYCQMrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 08:47:24 -0400
Message-ID: <47DE683E.3050005@openvz.org>
Date: Mon, 17 Mar 2008 15:46:54 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Roland Dreier <rolandd@cisco.com>, Sean Hefty <sean.hefty@intel.com>,
       Hal Rosenstock <hal.rosenstock@gmail.com>
CC: general@lists.openfabrics.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Hoang-Nam Nguyen <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>
Subject: [PATCH 1/3] Infiniband: make ehca_pd use struct pid pointer rather
 than pid_t
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Mon, 17 Mar 2008 15:46:49 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The task_struct->tgid field is about to become deprecated, due to
pid namespaces make tasks have many pids, not one. The infiniband
driver is one of the code, that still uses it in some places.

First make struct ehca_pd use a struct pid pointer and consolidate
owners check into one call (saves space).

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---

 drivers/infiniband/hw/ehca/ehca_av.c      |   18 +++---------------
 drivers/infiniband/hw/ehca/ehca_classes.h |    2 +-
 drivers/infiniband/hw/ehca/ehca_mrmw.c    |   15 +++------------
 drivers/infiniband/hw/ehca/ehca_pd.c      |   22 ++++++++++++++++------
 drivers/infiniband/hw/ehca/ehca_qp.c      |   30 +++++-------------------------
 drivers/infiniband/hw/ehca/ehca_tools.h   |    5 +++++
 drivers/infiniband/hw/ehca/ehca_uverbs.c  |    6 +-----
 7 files changed, 34 insertions(+), 64 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_av.c b/drivers/infiniband/hw/ehca/ehca_av.c
index 194c1c3..b5be661 100644
--- a/drivers/infiniband/hw/ehca/ehca_av.c
+++ b/drivers/infiniband/hw/ehca/ehca_av.c
@@ -173,14 +173,10 @@ int ehca_modify_ah(struct ib_ah *ah, struct ib_ah_attr *ah_attr)
 	struct ehca_pd *my_pd = container_of(ah->pd, struct ehca_pd, ib_pd);
 	struct ehca_shca *shca = container_of(ah->pd->device, struct ehca_shca,
 					      ib_device);
-	u32 cur_pid = current->tgid;
 
 	if (my_pd->ib_pd.uobject && my_pd->ib_pd.uobject->context &&
-	    my_pd->ownpid != cur_pid) {
-		ehca_err(ah->device, "Invalid caller pid=%x ownpid=%x",
-			 cur_pid, my_pd->ownpid);
+			ehca_check_pd_owner(ah->device, my_pd))
 		return -EINVAL;
-	}
 
 	memset(&new_ehca_av, 0, sizeof(new_ehca_av));
 	new_ehca_av.sl = ah_attr->sl;
@@ -243,14 +239,10 @@ int ehca_query_ah(struct ib_ah *ah, struct ib_ah_attr *ah_attr)
 {
 	struct ehca_av *av = container_of(ah, struct ehca_av, ib_ah);
 	struct ehca_pd *my_pd = container_of(ah->pd, struct ehca_pd, ib_pd);
-	u32 cur_pid = current->tgid;
 
 	if (my_pd->ib_pd.uobject && my_pd->ib_pd.uobject->context &&
-	    my_pd->ownpid != cur_pid) {
-		ehca_err(ah->device, "Invalid caller pid=%x ownpid=%x",
-			 cur_pid, my_pd->ownpid);
+			ehca_check_pd_owner(ah->device, my_pd))
 		return -EINVAL;
-	}
 
 	memcpy(&ah_attr->grh.dgid, &av->av.grh.word_3,
 	       sizeof(ah_attr->grh.dgid));
@@ -274,14 +266,10 @@ int ehca_query_ah(struct ib_ah *ah, struct ib_ah_attr *ah_attr)
 int ehca_destroy_ah(struct ib_ah *ah)
 {
 	struct ehca_pd *my_pd = container_of(ah->pd, struct ehca_pd, ib_pd);
-	u32 cur_pid = current->tgid;
 
 	if (my_pd->ib_pd.uobject && my_pd->ib_pd.uobject->context &&
-	    my_pd->ownpid != cur_pid) {
-		ehca_err(ah->device, "Invalid caller pid=%x ownpid=%x",
-			 cur_pid, my_pd->ownpid);
+			ehca_check_pd_owner(ah->device, my_pd))
 		return -EINVAL;
-	}
 
 	kmem_cache_free(av_cache, container_of(ah, struct ehca_av, ib_ah));
 
diff --git a/drivers/infiniband/hw/ehca/ehca_classes.h b/drivers/infiniband/hw/ehca/ehca_classes.h
index 92cce8a..29004cb 100644
--- a/drivers/infiniband/hw/ehca/ehca_classes.h
+++ b/drivers/infiniband/hw/ehca/ehca_classes.h
@@ -132,7 +132,7 @@ struct ehca_shca {
 struct ehca_pd {
 	struct ib_pd ib_pd;
 	struct ipz_pd fw_pd;
-	u32 ownpid;
+	struct pid *ownpid;
 	/* small queue mgmt */
 	struct mutex lock;
 	struct list_head free[2];
diff --git a/drivers/infiniband/hw/ehca/ehca_mrmw.c b/drivers/infiniband/hw/ehca/ehca_mrmw.c
index e239bbf..ebd034f 100644
--- a/drivers/infiniband/hw/ehca/ehca_mrmw.c
+++ b/drivers/infiniband/hw/ehca/ehca_mrmw.c
@@ -429,12 +429,9 @@ int ehca_rereg_phys_mr(struct ib_mr *mr,
 	u32 num_kpages = 0;
 	u32 num_hwpages = 0;
 	struct ehca_mr_pginfo pginfo;
-	u32 cur_pid = current->tgid;
 
 	if (my_pd->ib_pd.uobject && my_pd->ib_pd.uobject->context &&
-	    (my_pd->ownpid != cur_pid)) {
-		ehca_err(mr->device, "Invalid caller pid=%x ownpid=%x",
-			 cur_pid, my_pd->ownpid);
+			ehca_check_pd_owner(mr->device, my_pd)) {
 		ret = -EINVAL;
 		goto rereg_phys_mr_exit0;
 	}
@@ -578,14 +575,11 @@ int ehca_query_mr(struct ib_mr *mr, struct ib_mr_attr *mr_attr)
 		container_of(mr->device, struct ehca_shca, ib_device);
 	struct ehca_mr *e_mr = container_of(mr, struct ehca_mr, ib.ib_mr);
 	struct ehca_pd *my_pd = container_of(mr->pd, struct ehca_pd, ib_pd);
-	u32 cur_pid = current->tgid;
 	unsigned long sl_flags;
 	struct ehca_mr_hipzout_parms hipzout;
 
 	if (my_pd->ib_pd.uobject && my_pd->ib_pd.uobject->context &&
-	    (my_pd->ownpid != cur_pid)) {
-		ehca_err(mr->device, "Invalid caller pid=%x ownpid=%x",
-			 cur_pid, my_pd->ownpid);
+			ehca_check_pd_owner(mr->device, my_pd)) {
 		ret = -EINVAL;
 		goto query_mr_exit0;
 	}
@@ -635,12 +629,9 @@ int ehca_dereg_mr(struct ib_mr *mr)
 		container_of(mr->device, struct ehca_shca, ib_device);
 	struct ehca_mr *e_mr = container_of(mr, struct ehca_mr, ib.ib_mr);
 	struct ehca_pd *my_pd = container_of(mr->pd, struct ehca_pd, ib_pd);
-	u32 cur_pid = current->tgid;
 
 	if (my_pd->ib_pd.uobject && my_pd->ib_pd.uobject->context &&
-	    (my_pd->ownpid != cur_pid)) {
-		ehca_err(mr->device, "Invalid caller pid=%x ownpid=%x",
-			 cur_pid, my_pd->ownpid);
+			ehca_check_pd_owner(mr->device, my_pd)) {
 		ret = -EINVAL;
 		goto dereg_mr_exit0;
 	}
diff --git a/drivers/infiniband/hw/ehca/ehca_pd.c b/drivers/infiniband/hw/ehca/ehca_pd.c
index 43bcf08..742bf17 100644
--- a/drivers/infiniband/hw/ehca/ehca_pd.c
+++ b/drivers/infiniband/hw/ehca/ehca_pd.c
@@ -45,6 +45,19 @@
 
 static struct kmem_cache *pd_cache;
 
+int ehca_check_pd_owner(struct ib_device *device, struct ehca_pd *pd)
+{
+	struct pid *cur_pid;
+
+	cur_pid = task_tgid(current);
+	if (likely(pd->ownpid == cur_pid))
+		return 0;
+
+	ehca_err(device, "Invalid caller pid=%x ownpid=%x",
+			pid_nr(cur_pid), pid_nr(pd->ownpid));
+	return -EINVAL;
+}
+
 struct ib_pd *ehca_alloc_pd(struct ib_device *device,
 			    struct ib_ucontext *context, struct ib_udata *udata)
 {
@@ -58,7 +71,7 @@ struct ib_pd *ehca_alloc_pd(struct ib_device *device,
 		return ERR_PTR(-ENOMEM);
 	}
 
-	pd->ownpid = current->tgid;
+	pd->ownpid = get_pid(task_tgid(current));
 	for (i = 0; i < 2; i++) {
 		INIT_LIST_HEAD(&pd->free[i]);
 		INIT_LIST_HEAD(&pd->full[i]);
@@ -85,17 +98,13 @@ struct ib_pd *ehca_alloc_pd(struct ib_device *device,
 
 int ehca_dealloc_pd(struct ib_pd *pd)
 {
-	u32 cur_pid = current->tgid;
 	struct ehca_pd *my_pd = container_of(pd, struct ehca_pd, ib_pd);
 	int i, leftovers = 0;
 	struct ipz_small_queue_page *page, *tmp;
 
 	if (my_pd->ib_pd.uobject && my_pd->ib_pd.uobject->context &&
-	    my_pd->ownpid != cur_pid) {
-		ehca_err(pd->device, "Invalid caller pid=%x ownpid=%x",
-			 cur_pid, my_pd->ownpid);
+			ehca_check_pd_owner(pd->device, my_pd))
 		return -EINVAL;
-	}
 
 	for (i = 0; i < 2; i++) {
 		list_splice(&my_pd->full[i], &my_pd->free[i]);
@@ -110,6 +119,7 @@ int ehca_dealloc_pd(struct ib_pd *pd)
 		ehca_warn(pd->device,
 			  "Some small queue pages were not freed");
 
+	put_pid(my_pd->ownpid);
 	kmem_cache_free(pd_cache, my_pd);
 
 	return 0;
diff --git a/drivers/infiniband/hw/ehca/ehca_qp.c b/drivers/infiniband/hw/ehca/ehca_qp.c
index 1012f15..cc11097 100644
--- a/drivers/infiniband/hw/ehca/ehca_qp.c
+++ b/drivers/infiniband/hw/ehca/ehca_qp.c
@@ -1528,14 +1528,10 @@ int ehca_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr, int attr_mask,
 	struct ehca_qp *my_qp = container_of(ibqp, struct ehca_qp, ib_qp);
 	struct ehca_pd *my_pd = container_of(my_qp->ib_qp.pd, struct ehca_pd,
 					     ib_pd);
-	u32 cur_pid = current->tgid;
 
 	if (my_pd->ib_pd.uobject && my_pd->ib_pd.uobject->context &&
-	    my_pd->ownpid != cur_pid) {
-		ehca_err(ibqp->pd->device, "Invalid caller pid=%x ownpid=%x",
-			 cur_pid, my_pd->ownpid);
+			ehca_check_pd_owner(ibqp->pd->device, my_pd))
 		return -EINVAL;
-	}
 
 	/* The if-block below caches qp_attr to be modified for GSI and SMI
 	 * qps during the initialization by ib_mad. When the respective port
@@ -1642,16 +1638,12 @@ int ehca_query_qp(struct ib_qp *qp,
 					      ib_device);
 	struct ipz_adapter_handle adapter_handle = shca->ipz_hca_handle;
 	struct hcp_modify_qp_control_block *qpcb;
-	u32 cur_pid = current->tgid;
 	int cnt, ret = 0;
 	u64 h_ret;
 
 	if (my_pd->ib_pd.uobject  && my_pd->ib_pd.uobject->context  &&
-	    my_pd->ownpid != cur_pid) {
-		ehca_err(qp->device, "Invalid caller pid=%x ownpid=%x",
-			 cur_pid, my_pd->ownpid);
+			ehca_check_pd_owner(qp->device, my_pd))
 		return -EINVAL;
-	}
 
 	if (qp_attr_mask & QP_ATTR_QUERY_NOT_SUPPORTED) {
 		ehca_err(qp->device, "Invalid attribute mask "
@@ -1806,13 +1798,9 @@ int ehca_modify_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr,
 	u64 h_ret;
 	int ret = 0;
 
-	u32 cur_pid = current->tgid;
 	if (my_pd->ib_pd.uobject && my_pd->ib_pd.uobject->context &&
-	    my_pd->ownpid != cur_pid) {
-		ehca_err(ibsrq->pd->device, "Invalid caller pid=%x ownpid=%x",
-			 cur_pid, my_pd->ownpid);
+			ehca_check_pd_owner(ibsrq->pd->device, my_pd))
 		return -EINVAL;
-	}
 
 	mqpcb = ehca_alloc_fw_ctrlblock(GFP_KERNEL);
 	if (!mqpcb) {
@@ -1869,16 +1857,12 @@ int ehca_query_srq(struct ib_srq *srq, struct ib_srq_attr *srq_attr)
 					      ib_device);
 	struct ipz_adapter_handle adapter_handle = shca->ipz_hca_handle;
 	struct hcp_modify_qp_control_block *qpcb;
-	u32 cur_pid = current->tgid;
 	int ret = 0;
 	u64 h_ret;
 
 	if (my_pd->ib_pd.uobject  && my_pd->ib_pd.uobject->context  &&
-	    my_pd->ownpid != cur_pid) {
-		ehca_err(srq->device, "Invalid caller pid=%x ownpid=%x",
-			 cur_pid, my_pd->ownpid);
+			ehca_check_pd_owner(srq->device, my_pd))
 		return -EINVAL;
-	}
 
 	qpcb = ehca_alloc_fw_ctrlblock(GFP_KERNEL);
 	if (!qpcb) {
@@ -1919,7 +1903,6 @@ static int internal_destroy_qp(struct ib_device *dev, struct ehca_qp *my_qp,
 	struct ehca_pd *my_pd = container_of(my_qp->ib_qp.pd, struct ehca_pd,
 					     ib_pd);
 	struct ehca_sport *sport = &shca->sport[my_qp->init_attr.port_num - 1];
-	u32 cur_pid = current->tgid;
 	u32 qp_num = my_qp->real_qp_num;
 	int ret;
 	u64 h_ret;
@@ -1934,11 +1917,8 @@ static int internal_destroy_qp(struct ib_device *dev, struct ehca_qp *my_qp,
 				 "user space qp_num=%x", qp_num);
 			return -EINVAL;
 		}
-		if (my_pd->ownpid != cur_pid) {
-			ehca_err(dev, "Invalid caller pid=%x ownpid=%x",
-				 cur_pid, my_pd->ownpid);
+		if (ehca_check_pd_owner(dev, my_pd))
 			return -EINVAL;
-		}
 	}
 
 	if (my_qp->send_cq) {
diff --git a/drivers/infiniband/hw/ehca/ehca_tools.h b/drivers/infiniband/hw/ehca/ehca_tools.h
index 4a8346a..0e59891 100644
--- a/drivers/infiniband/hw/ehca/ehca_tools.h
+++ b/drivers/infiniband/hw/ehca/ehca_tools.h
@@ -154,4 +154,9 @@ extern int ehca_debug_level;
 /* Converts ehca to ib return code */
 int ehca2ib_return_code(u64 ehca_rc);
 
+struct ib_device;
+struct ehca_pd;
+
+int ehca_check_pd_owner(struct ib_device *device, struct ehca_pd *pd);
+
 #endif /* EHCA_TOOLS_H */
diff --git a/drivers/infiniband/hw/ehca/ehca_uverbs.c b/drivers/infiniband/hw/ehca/ehca_uverbs.c
index 5234d6c..82746da 100644
--- a/drivers/infiniband/hw/ehca/ehca_uverbs.c
+++ b/drivers/infiniband/hw/ehca/ehca_uverbs.c
@@ -299,12 +294,8 @@ int ehca_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
 			return -EINVAL;
 
 		pd = container_of(qp->ib_qp.pd, struct ehca_pd, ib_pd);
-		if (pd->ownpid != cur_pid) {
-			ehca_err(qp->ib_qp.device,
-				 "Invalid caller pid=%x ownpid=%x",
-				 cur_pid, pd->ownpid);
+		if (ehca_check_pd_owner(qp->ib_qp.device, pd))
 			return -ENOMEM;
-		}
 
 		uobject = IS_SRQ(qp) ? qp->ib_srq.uobject : qp->ib_qp.uobject;
 		if (!uobject || uobject->context != context)

