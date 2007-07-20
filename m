Return-Path: <linux-kernel-owner+w=401wt.eu-S932227AbXGTNug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932227AbXGTNug (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 09:50:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757787AbXGTNu1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 09:50:27 -0400
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:26954 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756801AbXGTNuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 09:50:25 -0400
From: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>
To: Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, openib-general@openib.org
Subject: [PATCH 1/5] ehca: Supports large page MRs
Date: Fri, 20 Jul 2007 16:01:51 +0200
User-Agent: KMail/1.8.2
Cc: raisch@de.ibm.com, stefan.roscher@de.ibm.com, fenkes@de.ibm.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707201601.52277.hnguyen@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hoang-Nam Nguyen <hnguyen@de.ibm.com>
Date: Thu, 19 Jul 2007 20:48:04 +0200
Subject: [PATCH 1/5] IB/ehca: Support large page MRs

Add support for MR pages larger than 4K on eHCA2. This reduces firmware
memory consumption. If enabled via the mr_largepage module parameter, the MR
page size will be determined based on the MR length and the hardware
capabilities - if the MR is >= 16M, 16M pages are used, for example.

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_classes.h |    9 +
 drivers/infiniband/hw/ehca/ehca_main.c    |   18 ++-
 drivers/infiniband/hw/ehca/ehca_mrmw.c    |  371 ++++++++++++++++++++++++-----
 drivers/infiniband/hw/ehca/ehca_mrmw.h    |    2 +-
 drivers/infiniband/hw/ehca/hcp_if.c       |   20 ++-
 5 files changed, 357 insertions(+), 63 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_classes.h b/drivers/infiniband/hw/ehca/ehca_classes.h
index 043e4fb..63b8b9f 100644
--- a/drivers/infiniband/hw/ehca/ehca_classes.h
+++ b/drivers/infiniband/hw/ehca/ehca_classes.h
@@ -100,6 +100,11 @@ struct ehca_sport {
 	struct ehca_sma_attr saved_attr;
 };
 
+#define HCA_CAP_MR_PGSIZE_4K  1
+#define HCA_CAP_MR_PGSIZE_64K 2
+#define HCA_CAP_MR_PGSIZE_1M  4
+#define HCA_CAP_MR_PGSIZE_16M 8
+
 struct ehca_shca {
 	struct ib_device ib_device;
 	struct ibmebus_dev *ibmebus_dev;
@@ -115,6 +120,8 @@ struct ehca_shca {
 	struct h_galpas galpas;
 	struct mutex modify_mutex;
 	u64 hca_cap;
+	/* MR pgsize: bit 0-3 means 4K, 64K, 1M, 16M respectively */
+	u32 hca_cap_mr_pgsize;
 	int max_mtu;
 };
 
@@ -206,6 +213,7 @@ struct ehca_mr {
 	enum ehca_mr_flag flags;
 	u32 num_kpages;		/* number of kernel pages */
 	u32 num_hwpages;	/* number of hw pages to form MR */
+	u64 hwpage_size;	/* hw page size used for this MR */
 	int acl;		/* ACL (stored here for usage in reregister) */
 	u64 *start;		/* virtual start address (stored here for */
 				/* usage in reregister) */
@@ -240,6 +248,7 @@ struct ehca_mr_pginfo {
 	enum ehca_mr_pgi_type type;
 	u64 num_kpages;
 	u64 kpage_cnt;
+	u64 hwpage_size;     /* hw page size used for this MR */
 	u64 num_hwpages;     /* number of hw pages */
 	u64 hwpage_cnt;      /* counter for hw pages */
 	u64 next_hwpage;     /* next hw page in buffer/chunk/listelem */
diff --git a/drivers/infiniband/hw/ehca/ehca_main.c b/drivers/infiniband/hw/ehca/ehca_main.c
index 36377c6..34661c3 100644
--- a/drivers/infiniband/hw/ehca/ehca_main.c
+++ b/drivers/infiniband/hw/ehca/ehca_main.c
@@ -63,6 +63,7 @@ int ehca_port_act_time = 30;
 int ehca_poll_all_eqs  = 1;
 int ehca_static_rate   = -1;
 int ehca_scaling_code  = 0;
+int ehca_mr_largepage  = 0;
 
 module_param_named(open_aqp1,     ehca_open_aqp1,     int, 0);
 module_param_named(debug_level,   ehca_debug_level,   int, 0);
@@ -72,7 +73,8 @@ module_param_named(use_hp_mr,     ehca_use_hp_mr,     int, 0);
 module_param_named(port_act_time, ehca_port_act_time, int, 0);
 module_param_named(poll_all_eqs,  ehca_poll_all_eqs,  int, 0);
 module_param_named(static_rate,   ehca_static_rate,   int, 0);
-module_param_named(scaling_code,   ehca_scaling_code,   int, 0);
+module_param_named(scaling_code,  ehca_scaling_code,  int, 0);
+module_param_named(mr_largepage,  ehca_mr_largepage,  int, 0);
 
 MODULE_PARM_DESC(open_aqp1,
 		 "AQP1 on startup (0: no (default), 1: yes)");
@@ -95,6 +97,9 @@ MODULE_PARM_DESC(static_rate,
 		 "set permanent static rate (default: disabled)");
 MODULE_PARM_DESC(scaling_code,
 		 "set scaling code (0: disabled/default, 1: enabled)");
+MODULE_PARM_DESC(mr_largepage,
+		 "use large page for MR (0: use PAGE_SIZE (default), "
+		 "1: use large page depending on MR size");
 
 DEFINE_RWLOCK(ehca_qp_idr_lock);
 DEFINE_RWLOCK(ehca_cq_idr_lock);
@@ -295,6 +300,8 @@ int ehca_sense_attributes(struct ehca_shca *shca)
 		if (EHCA_BMASK_GET(hca_cap_descr[i].mask, shca->hca_cap))
 			ehca_gen_dbg("   %s", hca_cap_descr[i].descr);
 
+	shca->hca_cap_mr_pgsize = rblock->memory_page_size_supported;
+
 	port = (struct hipz_query_port *)rblock;
 	h_ret = hipz_h_query_port(shca->ipz_hca_handle, 1, port);
 	if (h_ret != H_SUCCESS) {
@@ -590,6 +597,14 @@ static ssize_t ehca_show_adapter_handle(struct device *dev,
 }
 static DEVICE_ATTR(adapter_handle, S_IRUGO, ehca_show_adapter_handle, NULL);
 
+static ssize_t ehca_show_mr_largepage(struct device *dev,
+				      struct device_attribute *attr,
+				      char *buf)
+{
+	return sprintf(buf, "%d\n", ehca_mr_largepage);
+}
+static DEVICE_ATTR(mr_largepage, S_IRUGO, ehca_show_mr_largepage, NULL);
+
 static struct attribute *ehca_dev_attrs[] = {
 	&dev_attr_adapter_handle.attr,
 	&dev_attr_num_ports.attr,
@@ -606,6 +621,7 @@ static struct attribute *ehca_dev_attrs[] = {
 	&dev_attr_cur_mw.attr,
 	&dev_attr_max_pd.attr,
 	&dev_attr_max_ah.attr,
+	&dev_attr_mr_largepage.attr,
 	NULL
 };
 
diff --git a/drivers/infiniband/hw/ehca/ehca_mrmw.c b/drivers/infiniband/hw/ehca/ehca_mrmw.c
index 6262c54..ba28783 100644
--- a/drivers/infiniband/hw/ehca/ehca_mrmw.c
+++ b/drivers/infiniband/hw/ehca/ehca_mrmw.c
@@ -5,6 +5,7 @@
  *
  *  Authors: Dietmar Decker <ddecker@de.ibm.com>
  *           Christoph Raisch <raisch@de.ibm.com>
+ *           Hoang-Nam Nguyen <hnguyen@de.ibm.com>
  *
  *  Copyright (c) 2005 IBM Corporation
  *
@@ -56,6 +57,37 @@
 static struct kmem_cache *mr_cache;
 static struct kmem_cache *mw_cache;
 
+enum ehca_mr_pgsize {
+	EHCA_MR_PGSIZE4K  = 0x1000L,
+	EHCA_MR_PGSIZE64K = 0x10000L,
+	EHCA_MR_PGSIZE1M  = 0x100000L,
+	EHCA_MR_PGSIZE16M = 0x1000000L
+};
+
+extern int ehca_mr_largepage;
+
+static u32 ehca_encode_hwpage_size(u32 pgsize)
+{
+	u32 idx = 0;
+	pgsize >>= 12;
+	/*
+	 * map mr page size into hw code:
+	 * 0, 1, 2, 3 for 4K, 64K, 1M, 64M
+	 */
+	while (!(pgsize & 1)) {
+		idx++;
+		pgsize >>= 4;
+	}
+	return idx;
+}
+
+static u64 ehca_get_max_hwpage_size(struct ehca_shca *shca)
+{
+	if (shca->hca_cap_mr_pgsize & HCA_CAP_MR_PGSIZE_16M)
+		return EHCA_MR_PGSIZE16M;
+	return EHCA_MR_PGSIZE4K;
+}
+
 static struct ehca_mr *ehca_mr_new(void)
 {
 	struct ehca_mr *me;
@@ -207,19 +239,23 @@ struct ib_mr *ehca_reg_phys_mr(struct ib_pd *pd,
 		struct ehca_mr_pginfo pginfo;
 		u32 num_kpages;
 		u32 num_hwpages;
+		u64 hw_pgsize;
 
 		num_kpages = NUM_CHUNKS(((u64)iova_start % PAGE_SIZE) + size,
 					PAGE_SIZE);
-		num_hwpages = NUM_CHUNKS(((u64)iova_start % EHCA_PAGESIZE) +
-					 size, EHCA_PAGESIZE);
+		/* for kernel space we try most possible pgsize */
+		hw_pgsize = ehca_get_max_hwpage_size(shca);
+		num_hwpages = NUM_CHUNKS(((u64)iova_start % hw_pgsize) + size,
+					 hw_pgsize);
 		memset(&pginfo, 0, sizeof(pginfo));
 		pginfo.type = EHCA_MR_PGI_PHYS;
 		pginfo.num_kpages = num_kpages;
+		pginfo.hwpage_size = hw_pgsize;
 		pginfo.num_hwpages = num_hwpages;
 		pginfo.u.phy.num_phys_buf = num_phys_buf;
 		pginfo.u.phy.phys_buf_array = phys_buf_array;
-		pginfo.next_hwpage = (((u64)iova_start & ~PAGE_MASK) /
-				      EHCA_PAGESIZE);
+		pginfo.next_hwpage =
+			((u64)iova_start & ~(hw_pgsize - 1)) / hw_pgsize;
 
 		ret = ehca_reg_mr(shca, e_mr, iova_start, size, mr_access_flags,
 				  e_pd, &pginfo, &e_mr->ib.ib_mr.lkey,
@@ -259,6 +295,7 @@ struct ib_mr *ehca_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	int ret;
 	u32 num_kpages;
 	u32 num_hwpages;
+	u64 hwpage_size;
 
 	if (!pd) {
 		ehca_gen_err("bad pd=%p", pd);
@@ -309,16 +346,32 @@ struct ib_mr *ehca_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 
 	/* determine number of MR pages */
 	num_kpages = NUM_CHUNKS((virt % PAGE_SIZE) + length, PAGE_SIZE);
-	num_hwpages = NUM_CHUNKS((virt % EHCA_PAGESIZE) + length,
-				 EHCA_PAGESIZE);
+	/* select proper hw_pgsize */
+	if (ehca_mr_largepage &&
+	    (shca->hca_cap_mr_pgsize & HCA_CAP_MR_PGSIZE_16M)) {
+		if (length <= EHCA_MR_PGSIZE4K
+		    && PAGE_SIZE == EHCA_MR_PGSIZE4K)
+			hwpage_size = EHCA_MR_PGSIZE4K;
+		else if (length <= EHCA_MR_PGSIZE64K)
+			hwpage_size = EHCA_MR_PGSIZE64K;
+		else if (length <= EHCA_MR_PGSIZE1M)
+			hwpage_size = EHCA_MR_PGSIZE1M;
+		else
+			hwpage_size = EHCA_MR_PGSIZE16M;
+	} else
+		hwpage_size = EHCA_MR_PGSIZE4K;
+	ehca_dbg(pd->device, "hwpage_size=%lx", hwpage_size);
 
+reg_user_mr_fallback:
+	num_hwpages = NUM_CHUNKS((virt % hwpage_size) + length, hwpage_size);
 	/* register MR on HCA */
 	memset(&pginfo, 0, sizeof(pginfo));
 	pginfo.type = EHCA_MR_PGI_USER;
+	pginfo.hwpage_size = hwpage_size;
 	pginfo.num_kpages = num_kpages;
 	pginfo.num_hwpages = num_hwpages;
 	pginfo.u.usr.region = e_mr->umem;
-	pginfo.next_hwpage = e_mr->umem->offset / EHCA_PAGESIZE;
+	pginfo.next_hwpage = e_mr->umem->offset / hwpage_size;
 	pginfo.u.usr.next_chunk = list_prepare_entry(pginfo.u.usr.next_chunk,
 						     (&e_mr->umem->chunk_list),
 						     list);
@@ -326,6 +379,18 @@ struct ib_mr *ehca_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	ret = ehca_reg_mr(shca, e_mr, (u64 *)virt, length, mr_access_flags,
 			  e_pd, &pginfo, &e_mr->ib.ib_mr.lkey,
 			  &e_mr->ib.ib_mr.rkey);
+	if (ret == -EINVAL && pginfo.hwpage_size > PAGE_SIZE) {
+		ehca_warn(pd->device, "failed to register mr "
+			  "with hwpage_size=%lx", hwpage_size);
+		ehca_info(pd->device, "try to register mr with "
+			  "kpage_size=%lx", PAGE_SIZE);
+		/*
+		 * this means kpages are not contiguous for a hw page
+		 * try kernel page size as fallback solution
+		 */
+		hwpage_size = PAGE_SIZE;
+		goto reg_user_mr_fallback;
+	}
 	if (ret) {
 		ib_mr = ERR_PTR(ret);
 		goto reg_user_mr_exit2;
@@ -452,6 +517,8 @@ int ehca_rereg_phys_mr(struct ib_mr *mr,
 	new_pd = container_of(mr->pd, struct ehca_pd, ib_pd);
 
 	if (mr_rereg_mask & IB_MR_REREG_TRANS) {
+		u64 hw_pgsize = ehca_get_max_hwpage_size(shca);
+
 		new_start = iova_start;	/* change address */
 		/* check physical buffer list and calculate size */
 		ret = ehca_mr_chk_buf_and_calc_size(phys_buf_array,
@@ -468,16 +535,17 @@ int ehca_rereg_phys_mr(struct ib_mr *mr,
 		}
 		num_kpages = NUM_CHUNKS(((u64)new_start % PAGE_SIZE) +
 					new_size, PAGE_SIZE);
-		num_hwpages = NUM_CHUNKS(((u64)new_start % EHCA_PAGESIZE) +
-					 new_size, EHCA_PAGESIZE);
+		num_hwpages = NUM_CHUNKS(((u64)new_start % hw_pgsize) +
+					 new_size, hw_pgsize);
 		memset(&pginfo, 0, sizeof(pginfo));
 		pginfo.type = EHCA_MR_PGI_PHYS;
 		pginfo.num_kpages = num_kpages;
+		pginfo.hwpage_size = hw_pgsize;
 		pginfo.num_hwpages = num_hwpages;
 		pginfo.u.phy.num_phys_buf = num_phys_buf;
 		pginfo.u.phy.phys_buf_array = phys_buf_array;
-		pginfo.next_hwpage = (((u64)iova_start & ~PAGE_MASK) /
-				      EHCA_PAGESIZE);
+		pginfo.next_hwpage =
+			((u64)iova_start & ~(hw_pgsize - 1)) / hw_pgsize;
 	}
 	if (mr_rereg_mask & IB_MR_REREG_ACCESS)
 		new_acl = mr_access_flags;
@@ -709,6 +777,7 @@ struct ib_fmr *ehca_alloc_fmr(struct ib_pd *pd,
 	int ret;
 	u32 tmp_lkey, tmp_rkey;
 	struct ehca_mr_pginfo pginfo;
+	u64 hw_pgsize;
 
 	/* check other parameters */
 	if (((mr_access_flags & IB_ACCESS_REMOTE_WRITE) &&
@@ -738,8 +807,8 @@ struct ib_fmr *ehca_alloc_fmr(struct ib_pd *pd,
 		ib_fmr = ERR_PTR(-EINVAL);
 		goto alloc_fmr_exit0;
 	}
-	if (((1 << fmr_attr->page_shift) != EHCA_PAGESIZE) &&
-	    ((1 << fmr_attr->page_shift) != PAGE_SIZE)) {
+	hw_pgsize = ehca_get_max_hwpage_size(shca);
+	if ((1 << fmr_attr->page_shift) != hw_pgsize) {
 		ehca_err(pd->device, "unsupported fmr_attr->page_shift=%x",
 			 fmr_attr->page_shift);
 		ib_fmr = ERR_PTR(-EINVAL);
@@ -755,6 +824,10 @@ struct ib_fmr *ehca_alloc_fmr(struct ib_pd *pd,
 
 	/* register MR on HCA */
 	memset(&pginfo, 0, sizeof(pginfo));
+	/*
+	 * pginfo.num_hwpages==0, ie register_rpages() will not be called
+	 * but deferred to map_phys_fmr()
+	 */
 	ret = ehca_reg_mr(shca, e_fmr, NULL,
 			  fmr_attr->max_pages * (1 << fmr_attr->page_shift),
 			  mr_access_flags, e_pd, &pginfo,
@@ -765,6 +838,7 @@ struct ib_fmr *ehca_alloc_fmr(struct ib_pd *pd,
 	}
 
 	/* successful */
+	e_fmr->hwpage_size = hw_pgsize;
 	e_fmr->fmr_page_size = 1 << fmr_attr->page_shift;
 	e_fmr->fmr_max_pages = fmr_attr->max_pages;
 	e_fmr->fmr_max_maps = fmr_attr->max_maps;
@@ -822,10 +896,12 @@ int ehca_map_phys_fmr(struct ib_fmr *fmr,
 	memset(&pginfo, 0, sizeof(pginfo));
 	pginfo.type = EHCA_MR_PGI_FMR;
 	pginfo.num_kpages = list_len;
-	pginfo.num_hwpages = list_len * (e_fmr->fmr_page_size / EHCA_PAGESIZE);
+	pginfo.hwpage_size = e_fmr->hwpage_size;
+	pginfo.num_hwpages =
+		list_len * e_fmr->fmr_page_size / pginfo.hwpage_size;
 	pginfo.u.fmr.page_list = page_list;
-	pginfo.next_hwpage = ((iova & (e_fmr->fmr_page_size-1)) /
-			      EHCA_PAGESIZE);
+	pginfo.next_hwpage =
+		(iova & (e_fmr->fmr_page_size-1)) / pginfo.hwpage_size;
 	pginfo.u.fmr.fmr_pgsize = e_fmr->fmr_page_size;
 
 	ret = ehca_rereg_mr(shca, e_fmr, (u64 *)iova,
@@ -964,7 +1040,7 @@ int ehca_reg_mr(struct ehca_shca *shca,
 	struct ehca_mr_hipzout_parms hipzout;
 
 	ehca_mrmw_map_acl(acl, &hipz_acl);
-	ehca_mrmw_set_pgsize_hipz_acl(&hipz_acl);
+	ehca_mrmw_set_pgsize_hipz_acl(pginfo->hwpage_size, &hipz_acl);
 	if (ehca_use_hp_mr == 1)
 		hipz_acl |= 0x00000001;
 
@@ -987,6 +1063,7 @@ int ehca_reg_mr(struct ehca_shca *shca,
 	/* successful registration */
 	e_mr->num_kpages = pginfo->num_kpages;
 	e_mr->num_hwpages = pginfo->num_hwpages;
+	e_mr->hwpage_size = pginfo->hwpage_size;
 	e_mr->start = iova_start;
 	e_mr->size = size;
 	e_mr->acl = acl;
@@ -1029,6 +1106,9 @@ int ehca_reg_mr_rpages(struct ehca_shca *shca,
 	u32 i;
 	u64 *kpage;
 
+	if (!pginfo->num_hwpages) /* in case of fmr */
+		return 0;
+
 	kpage = ehca_alloc_fw_ctrlblock(GFP_KERNEL);
 	if (!kpage) {
 		ehca_err(&shca->ib_device, "kpage alloc failed");
@@ -1036,7 +1116,7 @@ int ehca_reg_mr_rpages(struct ehca_shca *shca,
 		goto ehca_reg_mr_rpages_exit0;
 	}
 
-	/* max 512 pages per shot */
+	/* max MAX_RPAGES ehca mr pages per register call */
 	for (i = 0; i < NUM_CHUNKS(pginfo->num_hwpages, MAX_RPAGES); i++) {
 
 		if (i == NUM_CHUNKS(pginfo->num_hwpages, MAX_RPAGES) - 1) {
@@ -1049,8 +1129,8 @@ int ehca_reg_mr_rpages(struct ehca_shca *shca,
 		ret = ehca_set_pagebuf(pginfo, rnum, kpage);
 		if (ret) {
 			ehca_err(&shca->ib_device, "ehca_set_pagebuf "
-					 "bad rc, ret=%x rnum=%x kpage=%p",
-					 ret, rnum, kpage);
+				 "bad rc, ret=%x rnum=%x kpage=%p",
+				 ret, rnum, kpage);
 			goto ehca_reg_mr_rpages_exit1;
 		}
 
@@ -1065,9 +1145,10 @@ int ehca_reg_mr_rpages(struct ehca_shca *shca,
 		} else
 			rpage = *kpage;
 
-		h_ret = hipz_h_register_rpage_mr(shca->ipz_hca_handle, e_mr,
-						 0, /* pagesize 4k */
-						 0, rpage, rnum);
+		h_ret = hipz_h_register_rpage_mr(
+			shca->ipz_hca_handle, e_mr,
+			ehca_encode_hwpage_size(pginfo->hwpage_size),
+			0, rpage, rnum);
 
 		if (i == NUM_CHUNKS(pginfo->num_hwpages, MAX_RPAGES) - 1) {
 			/*
@@ -1131,7 +1212,7 @@ inline int ehca_rereg_mr_rereg1(struct ehca_shca *shca,
 	struct ehca_mr_hipzout_parms hipzout;
 
 	ehca_mrmw_map_acl(acl, &hipz_acl);
-	ehca_mrmw_set_pgsize_hipz_acl(&hipz_acl);
+	ehca_mrmw_set_pgsize_hipz_acl(pginfo->hwpage_size, &hipz_acl);
 
 	kpage = ehca_alloc_fw_ctrlblock(GFP_KERNEL);
 	if (!kpage) {
@@ -1182,6 +1263,7 @@ inline int ehca_rereg_mr_rereg1(struct ehca_shca *shca,
 		 */
 		e_mr->num_kpages = pginfo->num_kpages;
 		e_mr->num_hwpages = pginfo->num_hwpages;
+		e_mr->hwpage_size = pginfo->hwpage_size;
 		e_mr->start = iova_start;
 		e_mr->size = size;
 		e_mr->acl = acl;
@@ -1268,13 +1350,14 @@ int ehca_rereg_mr(struct ehca_shca *shca,
 
 		/* set some MR values */
 		e_mr->flags = save_mr.flags;
+		e_mr->hwpage_size = save_mr.hwpage_size;
 		e_mr->fmr_page_size = save_mr.fmr_page_size;
 		e_mr->fmr_max_pages = save_mr.fmr_max_pages;
 		e_mr->fmr_max_maps = save_mr.fmr_max_maps;
 		e_mr->fmr_map_cnt = save_mr.fmr_map_cnt;
 
 		ret = ehca_reg_mr(shca, e_mr, iova_start, size, acl,
-				      e_pd, pginfo, lkey, rkey);
+				  e_pd, pginfo, lkey, rkey);
 		if (ret) {
 			u32 offset = (u64)(&e_mr->flags) - (u64)e_mr;
 			memcpy(&e_mr->flags, &(save_mr.flags),
@@ -1355,6 +1438,7 @@ int ehca_unmap_one_fmr(struct ehca_shca *shca,
 
 	/* set some MR values */
 	e_fmr->flags = save_fmr.flags;
+	e_fmr->hwpage_size = save_fmr.hwpage_size;
 	e_fmr->fmr_page_size = save_fmr.fmr_page_size;
 	e_fmr->fmr_max_pages = save_fmr.fmr_max_pages;
 	e_fmr->fmr_max_maps = save_fmr.fmr_max_maps;
@@ -1363,8 +1447,6 @@ int ehca_unmap_one_fmr(struct ehca_shca *shca,
 
 	memset(&pginfo, 0, sizeof(pginfo));
 	pginfo.type = EHCA_MR_PGI_FMR;
-	pginfo.num_kpages = 0;
-	pginfo.num_hwpages = 0;
 	ret = ehca_reg_mr(shca, e_fmr, NULL,
 			  (e_fmr->fmr_max_pages * e_fmr->fmr_page_size),
 			  e_fmr->acl, e_pd, &pginfo, &tmp_lkey,
@@ -1373,7 +1455,6 @@ int ehca_unmap_one_fmr(struct ehca_shca *shca,
 		u32 offset = (u64)(&e_fmr->flags) - (u64)e_fmr;
 		memcpy(&e_fmr->flags, &(save_mr.flags),
 		       sizeof(struct ehca_mr) - offset);
-		goto ehca_unmap_one_fmr_exit0;
 	}
 
 ehca_unmap_one_fmr_exit0:
@@ -1401,7 +1482,7 @@ int ehca_reg_smr(struct ehca_shca *shca,
 	struct ehca_mr_hipzout_parms hipzout;
 
 	ehca_mrmw_map_acl(acl, &hipz_acl);
-	ehca_mrmw_set_pgsize_hipz_acl(&hipz_acl);
+	ehca_mrmw_set_pgsize_hipz_acl(e_origmr->hwpage_size, &hipz_acl);
 
 	h_ret = hipz_h_register_smr(shca->ipz_hca_handle, e_newmr, e_origmr,
 				    (u64)iova_start, hipz_acl, e_pd->fw_pd,
@@ -1420,6 +1501,7 @@ int ehca_reg_smr(struct ehca_shca *shca,
 	/* successful registration */
 	e_newmr->num_kpages = e_origmr->num_kpages;
 	e_newmr->num_hwpages = e_origmr->num_hwpages;
+	e_newmr->hwpage_size   = e_origmr->hwpage_size;
 	e_newmr->start = iova_start;
 	e_newmr->size = e_origmr->size;
 	e_newmr->acl = acl;
@@ -1452,6 +1534,7 @@ int ehca_reg_internal_maxmr(
 	struct ib_phys_buf ib_pbuf;
 	u32 num_kpages;
 	u32 num_hwpages;
+	u64 hw_pgsize;
 
 	e_mr = ehca_mr_new();
 	if (!e_mr) {
@@ -1468,13 +1551,15 @@ int ehca_reg_internal_maxmr(
 	ib_pbuf.size = size_maxmr;
 	num_kpages = NUM_CHUNKS(((u64)iova_start % PAGE_SIZE) + size_maxmr,
 				PAGE_SIZE);
-	num_hwpages = NUM_CHUNKS(((u64)iova_start % EHCA_PAGESIZE) + size_maxmr,
-				 EHCA_PAGESIZE);
+	hw_pgsize = ehca_get_max_hwpage_size(shca);
+	num_hwpages = NUM_CHUNKS(((u64)iova_start % hw_pgsize) + size_maxmr,
+				 hw_pgsize);
 
 	memset(&pginfo, 0, sizeof(pginfo));
 	pginfo.type = EHCA_MR_PGI_PHYS;
 	pginfo.num_kpages = num_kpages;
 	pginfo.num_hwpages = num_hwpages;
+	pginfo.hwpage_size = hw_pgsize;
 	pginfo.u.phy.num_phys_buf = 1;
 	pginfo.u.phy.phys_buf_array = &ib_pbuf;
 
@@ -1523,7 +1608,7 @@ int ehca_reg_maxmr(struct ehca_shca *shca,
 	struct ehca_mr_hipzout_parms hipzout;
 
 	ehca_mrmw_map_acl(acl, &hipz_acl);
-	ehca_mrmw_set_pgsize_hipz_acl(&hipz_acl);
+	ehca_mrmw_set_pgsize_hipz_acl(e_origmr->hwpage_size, &hipz_acl);
 
 	h_ret = hipz_h_register_smr(shca->ipz_hca_handle, e_newmr, e_origmr,
 				    (u64)iova_start, hipz_acl, e_pd->fw_pd,
@@ -1539,6 +1624,7 @@ int ehca_reg_maxmr(struct ehca_shca *shca,
 	/* successful registration */
 	e_newmr->num_kpages = e_origmr->num_kpages;
 	e_newmr->num_hwpages = e_origmr->num_hwpages;
+	e_newmr->hwpage_size = e_origmr->hwpage_size;
 	e_newmr->start = iova_start;
 	e_newmr->size = e_origmr->size;
 	e_newmr->acl = acl;
@@ -1684,6 +1770,7 @@ static int ehca_set_pagebuf_user1(struct ehca_mr_pginfo *pginfo,
 	u64 pgaddr;
 	u32 i = 0;
 	u32 j = 0;
+	int hwpages_per_kpage = PAGE_SIZE / pginfo->hwpage_size;
 
 	/* loop over desired chunk entries */
 	chunk      = pginfo->u.usr.next_chunk;
@@ -1695,7 +1782,7 @@ static int ehca_set_pagebuf_user1(struct ehca_mr_pginfo *pginfo,
 				<< PAGE_SHIFT ;
 			*kpage = phys_to_abs(pgaddr +
 					     (pginfo->next_hwpage *
-					      EHCA_PAGESIZE));
+					      pginfo->hwpage_size));
 			if ( !(*kpage) ) {
 				ehca_gen_err("pgaddr=%lx "
 					     "chunk->page_list[i]=%lx "
@@ -1708,8 +1795,7 @@ static int ehca_set_pagebuf_user1(struct ehca_mr_pginfo *pginfo,
 			(pginfo->hwpage_cnt)++;
 			(pginfo->next_hwpage)++;
 			kpage++;
-			if (pginfo->next_hwpage %
-			    (PAGE_SIZE / EHCA_PAGESIZE) == 0) {
+			if (pginfo->next_hwpage % hwpages_per_kpage == 0) {
 				(pginfo->kpage_cnt)++;
 				(pginfo->u.usr.next_nmap)++;
 				pginfo->next_hwpage = 0;
@@ -1738,6 +1824,143 @@ static int ehca_set_pagebuf_user1(struct ehca_mr_pginfo *pginfo,
 	return ret;
 }
 
+/*
+ * check given pages for contiguous layout
+ * last page addr is returned in prev_pgaddr for further check
+ */
+static int ehca_check_kpages_per_ate(struct scatterlist *page_list,
+				     int start_idx, int end_idx,
+				     u64 *prev_pgaddr)
+{
+	int t;
+	for (t = start_idx; t <= end_idx; t++) {
+		u64 pgaddr = page_to_pfn(page_list[t].page) << PAGE_SHIFT;
+		ehca_gen_dbg("chunk_page=%lx value=%016lx", pgaddr,
+			     *(u64 *)abs_to_virt(phys_to_abs(pgaddr)));
+		if (pgaddr - PAGE_SIZE != *prev_pgaddr) {
+			ehca_gen_err("uncontiguous page found pgaddr=%lx "
+				     "prev_pgaddr=%lx page_list_i=%x",
+				     pgaddr, *prev_pgaddr, t);
+			return -EINVAL;
+		}
+		*prev_pgaddr = pgaddr;
+	}
+	return 0;
+}
+
+/* PAGE_SIZE < pginfo->hwpage_size */
+static int ehca_set_pagebuf_user2(struct ehca_mr_pginfo *pginfo,
+				  u32 number,
+				  u64 *kpage)
+{
+	int ret = 0;
+	struct ib_umem_chunk *prev_chunk;
+	struct ib_umem_chunk *chunk;
+	u64 pgaddr, prev_pgaddr;
+	u32 i = 0;
+	u32 j = 0;
+	int kpages_per_hwpage = pginfo->hwpage_size / PAGE_SIZE;
+	int nr_kpages = kpages_per_hwpage;
+
+	/* loop over desired chunk entries */
+	chunk      = pginfo->u.usr.next_chunk;
+	prev_chunk = pginfo->u.usr.next_chunk;
+	list_for_each_entry_continue(
+		chunk, (&(pginfo->u.usr.region->chunk_list)), list) {
+		for (i = pginfo->u.usr.next_nmap; i < chunk->nmap; ) {
+			if (nr_kpages == kpages_per_hwpage) {
+				pgaddr = ( page_to_pfn(chunk->page_list[i].page)
+					   << PAGE_SHIFT );
+				*kpage = phys_to_abs(pgaddr);
+				if ( !(*kpage) ) {
+					ehca_gen_err("pgaddr=%lx i=%x",
+						     pgaddr, i);
+					ret = -EFAULT;
+					return ret;
+				}
+				/*
+				 * The first page in a hwpage must be aligned;
+				 * the first MR page is exempt from this rule.
+				 */
+				if (pgaddr & (pginfo->hwpage_size - 1)) {
+					if (pginfo->hwpage_cnt) {
+						ehca_gen_err(
+							"invalid alignment "
+							"pgaddr=%lx i=%x "
+							"mr_pgsize=%lx",
+							pgaddr, i,
+							pginfo->hwpage_size);
+						ret = -EFAULT;
+						return ret;
+					}
+					/* first MR page */
+					pginfo->kpage_cnt =
+						(pgaddr &
+						 (pginfo->hwpage_size - 1)) >>
+						PAGE_SHIFT;
+					nr_kpages -= pginfo->kpage_cnt;
+					*kpage = phys_to_abs(
+						pgaddr &
+						~(pginfo->hwpage_size - 1));
+				}
+				ehca_gen_dbg("kpage=%lx chunk_page=%lx "
+					     "value=%016lx", *kpage, pgaddr,
+					     *(u64 *)abs_to_virt(
+						     phys_to_abs(pgaddr)));
+				prev_pgaddr = pgaddr;
+				i++;
+				pginfo->kpage_cnt++;
+				pginfo->u.usr.next_nmap++;
+				nr_kpages--;
+				if (!nr_kpages)
+					goto next_kpage;
+				continue;
+			}
+			if (i + nr_kpages > chunk->nmap) {
+				ret = ehca_check_kpages_per_ate(
+					chunk->page_list, i,
+					chunk->nmap - 1, &prev_pgaddr);
+				if (ret) return ret;
+				pginfo->kpage_cnt += chunk->nmap - i;
+				pginfo->u.usr.next_nmap += chunk->nmap - i;
+				nr_kpages -= chunk->nmap - i;
+				break;
+			}
+
+			ret = ehca_check_kpages_per_ate(chunk->page_list, i,
+							i + nr_kpages - 1,
+							&prev_pgaddr);
+			if (ret) return ret;
+			i += nr_kpages;
+			pginfo->kpage_cnt += nr_kpages;
+			pginfo->u.usr.next_nmap += nr_kpages;
+next_kpage:
+			nr_kpages = kpages_per_hwpage;
+			(pginfo->hwpage_cnt)++;
+			kpage++;
+			j++;
+			if (j >= number) break;
+		}
+		if ((pginfo->u.usr.next_nmap >= chunk->nmap) &&
+		    (j >= number)) {
+			pginfo->u.usr.next_nmap = 0;
+			prev_chunk = chunk;
+			break;
+		} else if (pginfo->u.usr.next_nmap >= chunk->nmap) {
+			pginfo->u.usr.next_nmap = 0;
+			prev_chunk = chunk;
+		} else if (j >= number)
+			break;
+		else
+			prev_chunk = chunk;
+	}
+	pginfo->u.usr.next_chunk =
+		list_prepare_entry(prev_chunk,
+				   (&(pginfo->u.usr.region->chunk_list)),
+				   list);
+	return ret;
+}
+
 int ehca_set_pagebuf_phys(struct ehca_mr_pginfo *pginfo,
 			  u32 number,
 			  u64 *kpage)
@@ -1750,9 +1973,10 @@ int ehca_set_pagebuf_phys(struct ehca_mr_pginfo *pginfo,
 	/* loop over desired phys_buf_array entries */
 	while (i < number) {
 		pbuf   = pginfo->u.phy.phys_buf_array + pginfo->u.phy.next_buf;
-		num_hw  = NUM_CHUNKS((pbuf->addr % EHCA_PAGESIZE) +
-				     pbuf->size, EHCA_PAGESIZE);
-		offs_hw = (pbuf->addr & ~PAGE_MASK) / EHCA_PAGESIZE;
+		num_hw  = NUM_CHUNKS((pbuf->addr % pginfo->hwpage_size) +
+				     pbuf->size, pginfo->hwpage_size);
+		offs_hw = (pbuf->addr & ~(pginfo->hwpage_size - 1)) /
+			pginfo->hwpage_size;
 		while (pginfo->next_hwpage < offs_hw + num_hw) {
 			/* sanity check */
 			if ((pginfo->kpage_cnt >= pginfo->num_kpages) ||
@@ -1768,21 +1992,23 @@ int ehca_set_pagebuf_phys(struct ehca_mr_pginfo *pginfo,
 				return -EFAULT;
 			}
 			*kpage = phys_to_abs(
-				(pbuf->addr & EHCA_PAGEMASK)
-				+ (pginfo->next_hwpage * EHCA_PAGESIZE));
+				(pbuf->addr & ~(pginfo->hwpage_size - 1)) +
+				(pginfo->next_hwpage * pginfo->hwpage_size));
 			if ( !(*kpage) && pbuf->addr ) {
-				ehca_gen_err("pbuf->addr=%lx "
-					     "pbuf->size=%lx "
+				ehca_gen_err("pbuf->addr=%lx pbuf->size=%lx "
 					     "next_hwpage=%lx", pbuf->addr,
-					     pbuf->size,
-					     pginfo->next_hwpage);
+					     pbuf->size, pginfo->next_hwpage);
 				return -EFAULT;
 			}
 			(pginfo->hwpage_cnt)++;
 			(pginfo->next_hwpage)++;
-			if (pginfo->next_hwpage %
-			    (PAGE_SIZE / EHCA_PAGESIZE) == 0)
-				(pginfo->kpage_cnt)++;
+			if (PAGE_SIZE >= pginfo->hwpage_size) {
+				if (pginfo->next_hwpage %
+				    (PAGE_SIZE / pginfo->hwpage_size) == 0)
+					(pginfo->kpage_cnt)++;
+			} else
+				pginfo->kpage_cnt += pginfo->hwpage_size /
+					PAGE_SIZE;
 			kpage++;
 			i++;
 			if (i >= number) break;
@@ -1806,8 +2032,8 @@ int ehca_set_pagebuf_fmr(struct ehca_mr_pginfo *pginfo,
 	/* loop over desired page_list entries */
 	fmrlist = pginfo->u.fmr.page_list + pginfo->u.fmr.next_listelem;
 	for (i = 0; i < number; i++) {
-		*kpage = phys_to_abs((*fmrlist & EHCA_PAGEMASK) +
-				     pginfo->next_hwpage * EHCA_PAGESIZE);
+		*kpage = phys_to_abs((*fmrlist & ~(pginfo->hwpage_size - 1)) +
+				     pginfo->next_hwpage * pginfo->hwpage_size);
 		if ( !(*kpage) ) {
 			ehca_gen_err("*fmrlist=%lx fmrlist=%p "
 				     "next_listelem=%lx next_hwpage=%lx",
@@ -1817,15 +2043,38 @@ int ehca_set_pagebuf_fmr(struct ehca_mr_pginfo *pginfo,
 			return -EFAULT;
 		}
 		(pginfo->hwpage_cnt)++;
-		(pginfo->next_hwpage)++;
-		kpage++;
-		if (pginfo->next_hwpage %
-		    (pginfo->u.fmr.fmr_pgsize / EHCA_PAGESIZE) == 0) {
-			(pginfo->kpage_cnt)++;
-			(pginfo->u.fmr.next_listelem)++;
-			fmrlist++;
-			pginfo->next_hwpage = 0;
+		if (pginfo->u.fmr.fmr_pgsize >= pginfo->hwpage_size) {
+			if (pginfo->next_hwpage %
+			    (pginfo->u.fmr.fmr_pgsize /
+			     pginfo->hwpage_size) == 0) {
+				(pginfo->kpage_cnt)++;
+				(pginfo->u.fmr.next_listelem)++;
+				fmrlist++;
+				pginfo->next_hwpage = 0;
+			} else
+				(pginfo->next_hwpage)++;
+		} else {
+			unsigned int cnt_per_hwpage = pginfo->hwpage_size /
+				pginfo->u.fmr.fmr_pgsize;
+			unsigned int j;
+			u64 prev = *kpage;
+			/* check if adrs are contiguous */
+			for (j = 1; j < cnt_per_hwpage; j++) {
+				u64 p = phys_to_abs(fmrlist[j] &
+						    ~(pginfo->hwpage_size - 1));
+				if (prev + pginfo->u.fmr.fmr_pgsize != p) {
+					ehca_gen_err("uncontiguous fmr pages "
+						     "found prev=%lx p=%lx "
+						     "idx=%x", prev, p, i + j);
+					return -EINVAL;
+				}
+				prev = p;
+			}
+			pginfo->kpage_cnt += cnt_per_hwpage;
+			pginfo->u.fmr.next_listelem += cnt_per_hwpage;
+			fmrlist += cnt_per_hwpage;
 		}
+		kpage++;
 	}
 	return ret;
 }
@@ -1842,7 +2091,9 @@ int ehca_set_pagebuf(struct ehca_mr_pginfo *pginfo,
 		ret = ehca_set_pagebuf_phys(pginfo, number, kpage);
 		break;
 	case EHCA_MR_PGI_USER:
-		ret = ehca_set_pagebuf_user1(pginfo, number, kpage);
+		ret = PAGE_SIZE >= pginfo->hwpage_size ?
+			ehca_set_pagebuf_user1(pginfo, number, kpage) :
+			ehca_set_pagebuf_user2(pginfo, number, kpage);
 		break;
 	case EHCA_MR_PGI_FMR:
 		ret = ehca_set_pagebuf_fmr(pginfo, number, kpage);
@@ -1895,9 +2146,9 @@ void ehca_mrmw_map_acl(int ib_acl,
 /*----------------------------------------------------------------------*/
 
 /* sets page size in hipz access control for MR/MW. */
-void ehca_mrmw_set_pgsize_hipz_acl(u32 *hipz_acl) /*INOUT*/
+void ehca_mrmw_set_pgsize_hipz_acl(u32 pgsize, u32 *hipz_acl) /*INOUT*/
 {
-	return; /* HCA supports only 4k */
+	*hipz_acl |= (ehca_encode_hwpage_size(pgsize) << 24);
 } /* end ehca_mrmw_set_pgsize_hipz_acl() */
 
 /*----------------------------------------------------------------------*/
diff --git a/drivers/infiniband/hw/ehca/ehca_mrmw.h b/drivers/infiniband/hw/ehca/ehca_mrmw.h
index 24f13fe..bc8f4e3 100644
--- a/drivers/infiniband/hw/ehca/ehca_mrmw.h
+++ b/drivers/infiniband/hw/ehca/ehca_mrmw.h
@@ -111,7 +111,7 @@ int ehca_mr_is_maxmr(u64 size,
 void ehca_mrmw_map_acl(int ib_acl,
 		       u32 *hipz_acl);
 
-void ehca_mrmw_set_pgsize_hipz_acl(u32 *hipz_acl);
+void ehca_mrmw_set_pgsize_hipz_acl(u32 pgsize, u32 *hipz_acl);
 
 void ehca_mrmw_reverse_map_acl(const u32 *hipz_acl,
 			       int *ib_acl);
diff --git a/drivers/infiniband/hw/ehca/hcp_if.c b/drivers/infiniband/hw/ehca/hcp_if.c
index 3394e05..358796c 100644
--- a/drivers/infiniband/hw/ehca/hcp_if.c
+++ b/drivers/infiniband/hw/ehca/hcp_if.c
@@ -427,7 +427,8 @@ u64 hipz_h_register_rpage(const struct ipz_adapter_handle adapter_handle,
 {
 	return ehca_plpar_hcall_norets(H_REGISTER_RPAGES,
 				       adapter_handle.handle,      /* r4  */
-				       queue_type | pagesize << 8, /* r5  */
+				       (u64)queue_type | ((u64)pagesize) << 8,
+				       /* r5  */
 				       resource_handle,	           /* r6  */
 				       logical_address_of_page,    /* r7  */
 				       count,	                   /* r8  */
@@ -724,6 +725,9 @@ u64 hipz_h_alloc_resource_mr(const struct ipz_adapter_handle adapter_handle,
 	u64 ret;
 	u64 outs[PLPAR_HCALL9_BUFSIZE];
 
+	ehca_gen_dbg("kernel PAGE_SIZE=%x access_ctrl=%016x "
+		     "vaddr=%lx length=%lx",
+		     (u32)PAGE_SIZE, access_ctrl, vaddr, length);
 	ret = ehca_plpar_hcall9(H_ALLOC_RESOURCE, outs,
 				adapter_handle.handle,            /* r4 */
 				5,                                /* r5 */
@@ -746,8 +750,22 @@ u64 hipz_h_register_rpage_mr(const struct ipz_adapter_handle adapter_handle,
 			     const u64 logical_address_of_page,
 			     const u64 count)
 {
+	extern int ehca_debug_level;
 	u64 ret;
 
+	if (unlikely(ehca_debug_level >= 2)) {
+		if (count > 1) {
+			u64 *kpage;
+			int i;
+			kpage = (u64 *)abs_to_virt(logical_address_of_page);
+			for (i = 0; i < count; i++)
+				ehca_gen_dbg("kpage[%d]=%p",
+					     i, (void *)kpage[i]);
+		} else
+			ehca_gen_dbg("kpage=%p",
+				     (void *)logical_address_of_page);
+	}
+
 	if ((count > 1) && (logical_address_of_page & (EHCA_PAGESIZE-1))) {
 		ehca_gen_err("logical_address_of_page not on a 4k boundary "
 			     "adapter_handle=%lx mr=%p mr_handle=%lx "
-- 
1.5.2




