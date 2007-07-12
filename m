Return-Path: <linux-kernel-owner+w=401wt.eu-S935017AbXGLPws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935017AbXGLPws (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 11:52:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758147AbXGLPwh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 11:52:37 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:39571 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755933AbXGLPwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 11:52:35 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>
Subject: [PATCH 07/10] IB/ehca: MR/MW structure refactoring
User-Agent: KMail/1.8.2
Cc: "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
References: <200707121745.27592.fenkes@de.ibm.com>
In-Reply-To: <200707121745.27592.fenkes@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 25418
Date: Thu, 12 Jul 2007 17:52:29 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200707121752.30129.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hoang-Nam Nguyen <hnguyen@de.ibm.com>

- Rename struct ehca_mr fields to clearly distinguish between kernel and HW
  page size
- Sort struct ehca_mr_pginfo into a common part and a union containing
  specific fields for physical, user and fast MR

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_classes.h |   50 ++--
 drivers/infiniband/hw/ehca/ehca_mrmw.c    |  511 +++++++++++++++--------------
 2 files changed, 284 insertions(+), 277 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_classes.h b/drivers/infiniband/hw/ehca/ehca_classes.h
index b2d614a..92103df 100644
--- a/drivers/infiniband/hw/ehca/ehca_classes.h
+++ b/drivers/infiniband/hw/ehca/ehca_classes.h
@@ -211,8 +211,8 @@ struct ehca_mr {
 	spinlock_t mrlock;
 
 	enum ehca_mr_flag flags;
-	u32 num_pages;		/* number of MR pages */
-	u32 num_4k;		/* number of 4k "page" portions to form MR */
+	u32 num_kpages;		/* number of kernel pages */
+	u32 num_hwpages;	/* number of hw pages to form MR */
 	int acl;		/* ACL (stored here for usage in reregister) */
 	u64 *start;		/* virtual start address (stored here for */
 	                        /* usage in reregister) */
@@ -224,9 +224,6 @@ struct ehca_mr {
 	/* fw specific data */
 	struct ipz_mrmw_handle ipz_mr_handle;	/* MR handle for h-calls */
 	struct h_galpas galpas;
-	/* data for userspace bridge */
-	u32 nr_of_pages;
-	void *pagearray;
 };
 
 struct ehca_mw {
@@ -248,26 +245,29 @@ enum ehca_mr_pgi_type {
 
 struct ehca_mr_pginfo {
 	enum ehca_mr_pgi_type type;
-	u64 num_pages;
-	u64 page_cnt;
-	u64 num_4k;       /* number of 4k "page" portions */
-	u64 page_4k_cnt;  /* counter for 4k "page" portions */
-	u64 next_4k;      /* next 4k "page" portion in buffer/chunk/listelem */
-
-	/* type EHCA_MR_PGI_PHYS section */
-	int num_phys_buf;
-	struct ib_phys_buf *phys_buf_array;
-	u64 next_buf;
-
-	/* type EHCA_MR_PGI_USER section */
-	struct ib_umem *region;
-	struct ib_umem_chunk *next_chunk;
-	u64 next_nmap;
-
-	/* type EHCA_MR_PGI_FMR section */
-	u64 *page_list;
-	u64 next_listelem;
-	/* next_4k also used within EHCA_MR_PGI_FMR */
+	u64 num_kpages;
+	u64 kpage_cnt;
+	u64 num_hwpages;     /* number of hw pages */
+	u64 hwpage_cnt;      /* counter for hw pages */
+	u64 next_hwpage;     /* next hw page in buffer/chunk/listelem */
+
+	union {
+		struct { /* type EHCA_MR_PGI_PHYS section */
+			int num_phys_buf;
+			struct ib_phys_buf *phys_buf_array;
+			u64 next_buf;
+		} phy;
+		struct { /* type EHCA_MR_PGI_USER section */
+			struct ib_umem *region;
+			struct ib_umem_chunk *next_chunk;
+			u64 next_nmap;
+		} usr;
+		struct { /* type EHCA_MR_PGI_FMR section */
+			u64 fmr_pgsize;
+			u64 *page_list;
+			u64 next_listelem;
+		} fmr;
+	} u;
 };
 
 /* output parameters for MR/FMR hipz calls */
diff --git a/drivers/infiniband/hw/ehca/ehca_mrmw.c b/drivers/infiniband/hw/ehca/ehca_mrmw.c
index 58e8b33..53b334b 100644
--- a/drivers/infiniband/hw/ehca/ehca_mrmw.c
+++ b/drivers/infiniband/hw/ehca/ehca_mrmw.c
@@ -150,9 +150,6 @@ struct ib_mr *ehca_reg_phys_mr(struct ib_pd *pd,
 	struct ehca_pd *e_pd = container_of(pd, struct ehca_pd, ib_pd);
 
 	u64 size;
-	struct ehca_mr_pginfo pginfo={0,0,0,0,0,0,0,NULL,0,NULL,NULL,0,NULL,0};
-	u32 num_pages_mr;
-	u32 num_pages_4k; /* 4k portion "pages" */
 
 	if ((num_phys_buf <= 0) || !phys_buf_array) {
 		ehca_err(pd->device, "bad input values: num_phys_buf=%x "
@@ -196,12 +193,6 @@ struct ib_mr *ehca_reg_phys_mr(struct ib_pd *pd,
 		goto reg_phys_mr_exit0;
 	}
 
-	/* determine number of MR pages */
-	num_pages_mr = NUM_CHUNKS(((u64)iova_start % PAGE_SIZE) + size,
-				  PAGE_SIZE);
-	num_pages_4k = NUM_CHUNKS(((u64)iova_start % EHCA_PAGESIZE) + size,
-				  EHCA_PAGESIZE);
-
 	/* register MR on HCA */
 	if (ehca_mr_is_maxmr(size, iova_start)) {
 		e_mr->flags |= EHCA_MR_FLAG_MAXMR;
@@ -213,13 +204,22 @@ struct ib_mr *ehca_reg_phys_mr(struct ib_pd *pd,
 			goto reg_phys_mr_exit1;
 		}
 	} else {
-		pginfo.type           = EHCA_MR_PGI_PHYS;
-		pginfo.num_pages      = num_pages_mr;
-		pginfo.num_4k         = num_pages_4k;
-		pginfo.num_phys_buf   = num_phys_buf;
-		pginfo.phys_buf_array = phys_buf_array;
-		pginfo.next_4k        = (((u64)iova_start & ~PAGE_MASK) /
-					 EHCA_PAGESIZE);
+		struct ehca_mr_pginfo pginfo;
+		u32 num_kpages;
+		u32 num_hwpages;
+
+		num_kpages = NUM_CHUNKS(((u64)iova_start % PAGE_SIZE) + size,
+					PAGE_SIZE);
+		num_hwpages = NUM_CHUNKS(((u64)iova_start % EHCA_PAGESIZE) +
+					 size, EHCA_PAGESIZE);
+		memset(&pginfo, 0, sizeof(pginfo));
+		pginfo.type = EHCA_MR_PGI_PHYS;
+		pginfo.num_kpages = num_kpages;
+		pginfo.num_hwpages = num_hwpages;
+		pginfo.u.phy.num_phys_buf = num_phys_buf;
+		pginfo.u.phy.phys_buf_array = phys_buf_array;
+		pginfo.next_hwpage = (((u64)iova_start & ~PAGE_MASK) /
+				      EHCA_PAGESIZE);
 
 		ret = ehca_reg_mr(shca, e_mr, iova_start, size, mr_access_flags,
 				  e_pd, &pginfo, &e_mr->ib.ib_mr.lkey,
@@ -254,10 +254,10 @@ struct ib_mr *ehca_reg_user_mr(struct ib_pd *pd, u64 start, u64 length, u64 virt
 	struct ehca_shca *shca =
 		container_of(pd->device, struct ehca_shca, ib_device);
 	struct ehca_pd *e_pd = container_of(pd, struct ehca_pd, ib_pd);
-	struct ehca_mr_pginfo pginfo={0,0,0,0,0,0,0,NULL,0,NULL,NULL,0,NULL,0};
+	struct ehca_mr_pginfo pginfo;
 	int ret;
-	u32 num_pages_mr;
-	u32 num_pages_4k; /* 4k portion "pages" */
+	u32 num_kpages;
+	u32 num_hwpages;
 
 	if (!pd) {
 		ehca_gen_err("bad pd=%p", pd);
@@ -307,19 +307,20 @@ struct ib_mr *ehca_reg_user_mr(struct ib_pd *pd, u64 start, u64 length, u64 virt
 	}
 
 	/* determine number of MR pages */
-	num_pages_mr = NUM_CHUNKS((virt % PAGE_SIZE) + length, PAGE_SIZE);
-	num_pages_4k = NUM_CHUNKS((virt % EHCA_PAGESIZE) + length,
-				  EHCA_PAGESIZE);
+	num_kpages = NUM_CHUNKS((virt % PAGE_SIZE) + length, PAGE_SIZE);
+	num_hwpages = NUM_CHUNKS((virt % EHCA_PAGESIZE) + length,
+				 EHCA_PAGESIZE);
 
 	/* register MR on HCA */
-	pginfo.type       = EHCA_MR_PGI_USER;
-	pginfo.num_pages  = num_pages_mr;
-	pginfo.num_4k     = num_pages_4k;
-	pginfo.region     = e_mr->umem;
-	pginfo.next_4k	  = e_mr->umem->offset / EHCA_PAGESIZE;
-	pginfo.next_chunk = list_prepare_entry(pginfo.next_chunk,
-					       (&e_mr->umem->chunk_list),
-					       list);
+	memset(&pginfo, 0, sizeof(pginfo));
+	pginfo.type = EHCA_MR_PGI_USER;
+	pginfo.num_kpages = num_kpages;
+	pginfo.num_hwpages = num_hwpages;
+	pginfo.u.usr.region = e_mr->umem;
+	pginfo.next_hwpage = e_mr->umem->offset / EHCA_PAGESIZE;
+	pginfo.u.usr.next_chunk = list_prepare_entry(pginfo.u.usr.next_chunk,
+						     (&e_mr->umem->chunk_list),
+						     list);
 
 	ret = ehca_reg_mr(shca, e_mr, (u64*) virt, length, mr_access_flags, e_pd,
 			  &pginfo, &e_mr->ib.ib_mr.lkey, &e_mr->ib.ib_mr.rkey);
@@ -365,9 +366,9 @@ int ehca_rereg_phys_mr(struct ib_mr *mr,
 	struct ehca_pd *new_pd;
 	u32 tmp_lkey, tmp_rkey;
 	unsigned long sl_flags;
-	u32 num_pages_mr = 0;
-	u32 num_pages_4k = 0; /* 4k portion "pages" */
-	struct ehca_mr_pginfo pginfo={0,0,0,0,0,0,0,NULL,0,NULL,NULL,0,NULL,0};
+	u32 num_kpages = 0;
+	u32 num_hwpages = 0;
+	struct ehca_mr_pginfo pginfo;
 	u32 cur_pid = current->tgid;
 
 	if (my_pd->ib_pd.uobject && my_pd->ib_pd.uobject->context &&
@@ -463,17 +464,18 @@ int ehca_rereg_phys_mr(struct ib_mr *mr,
 			ret = -EINVAL;
 			goto rereg_phys_mr_exit1;
 		}
-		num_pages_mr = NUM_CHUNKS(((u64)new_start % PAGE_SIZE) +
-					  new_size, PAGE_SIZE);
-		num_pages_4k = NUM_CHUNKS(((u64)new_start % EHCA_PAGESIZE) +
-					  new_size, EHCA_PAGESIZE);
-		pginfo.type           = EHCA_MR_PGI_PHYS;
-		pginfo.num_pages      = num_pages_mr;
-		pginfo.num_4k         = num_pages_4k;
-		pginfo.num_phys_buf   = num_phys_buf;
-		pginfo.phys_buf_array = phys_buf_array;
-		pginfo.next_4k        = (((u64)iova_start & ~PAGE_MASK) /
-					 EHCA_PAGESIZE);
+		num_kpages = NUM_CHUNKS(((u64)new_start % PAGE_SIZE) +
+					new_size, PAGE_SIZE);
+		num_hwpages = NUM_CHUNKS(((u64)new_start % EHCA_PAGESIZE) +
+					 new_size, EHCA_PAGESIZE);
+		memset(&pginfo, 0, sizeof(pginfo));
+		pginfo.type = EHCA_MR_PGI_PHYS;
+		pginfo.num_kpages = num_kpages;
+		pginfo.num_hwpages = num_hwpages;
+		pginfo.u.phy.num_phys_buf = num_phys_buf;
+		pginfo.u.phy.phys_buf_array = phys_buf_array;
+		pginfo.next_hwpage = (((u64)iova_start & ~PAGE_MASK) /
+				      EHCA_PAGESIZE);
 	}
 	if (mr_rereg_mask & IB_MR_REREG_ACCESS)
 		new_acl = mr_access_flags;
@@ -544,11 +546,11 @@ int ehca_query_mr(struct ib_mr *mr, struct ib_mr_attr *mr_attr)
 		ret = ehca2ib_return_code(h_ret);
 		goto query_mr_exit1;
 	}
-	mr_attr->pd               = mr->pd;
+	mr_attr->pd = mr->pd;
 	mr_attr->device_virt_addr = hipzout.vaddr;
-	mr_attr->size             = hipzout.len;
-	mr_attr->lkey             = hipzout.lkey;
-	mr_attr->rkey             = hipzout.rkey;
+	mr_attr->size = hipzout.len;
+	mr_attr->lkey = hipzout.lkey;
+	mr_attr->rkey = hipzout.rkey;
 	ehca_mrmw_reverse_map_acl(&hipzout.acl, &mr_attr->mr_access_flags);
 
 query_mr_exit1:
@@ -704,7 +706,7 @@ struct ib_fmr *ehca_alloc_fmr(struct ib_pd *pd,
 	struct ehca_mr *e_fmr;
 	int ret;
 	u32 tmp_lkey, tmp_rkey;
-	struct ehca_mr_pginfo pginfo={0,0,0,0,0,0,0,NULL,0,NULL,NULL,0,NULL,0};
+	struct ehca_mr_pginfo pginfo;
 
 	/* check other parameters */
 	if (((mr_access_flags & IB_ACCESS_REMOTE_WRITE) &&
@@ -750,6 +752,7 @@ struct ib_fmr *ehca_alloc_fmr(struct ib_pd *pd,
 	e_fmr->flags |= EHCA_MR_FLAG_FMR;
 
 	/* register MR on HCA */
+	memset(&pginfo, 0, sizeof(pginfo));
 	ret = ehca_reg_mr(shca, e_fmr, NULL,
 			  fmr_attr->max_pages * (1 << fmr_attr->page_shift),
 			  mr_access_flags, e_pd, &pginfo,
@@ -788,7 +791,7 @@ int ehca_map_phys_fmr(struct ib_fmr *fmr,
 		container_of(fmr->device, struct ehca_shca, ib_device);
 	struct ehca_mr *e_fmr = container_of(fmr, struct ehca_mr, ib.ib_fmr);
 	struct ehca_pd *e_pd = container_of(fmr->pd, struct ehca_pd, ib_pd);
-	struct ehca_mr_pginfo pginfo={0,0,0,0,0,0,0,NULL,0,NULL,NULL,0,NULL,0};
+	struct ehca_mr_pginfo pginfo;
 	u32 tmp_lkey, tmp_rkey;
 
 	if (!(e_fmr->flags & EHCA_MR_FLAG_FMR)) {
@@ -814,12 +817,13 @@ int ehca_map_phys_fmr(struct ib_fmr *fmr,
 			  fmr, e_fmr->fmr_map_cnt, e_fmr->fmr_max_maps);
 	}
 
-	pginfo.type      = EHCA_MR_PGI_FMR;
-	pginfo.num_pages = list_len;
-	pginfo.num_4k    = list_len * (e_fmr->fmr_page_size / EHCA_PAGESIZE);
-	pginfo.page_list = page_list;
-	pginfo.next_4k   = ((iova & (e_fmr->fmr_page_size-1)) /
-			    EHCA_PAGESIZE);
+	memset(&pginfo, 0, sizeof(pginfo));
+	pginfo.type = EHCA_MR_PGI_FMR;
+	pginfo.num_kpages = list_len;
+	pginfo.num_hwpages = list_len * (e_fmr->fmr_page_size / EHCA_PAGESIZE);
+	pginfo.u.fmr.page_list = page_list;
+	pginfo.next_hwpage = ((iova & (e_fmr->fmr_page_size-1)) /
+			      EHCA_PAGESIZE);
 
 	ret = ehca_rereg_mr(shca, e_fmr, (u64*)iova,
 			    list_len * e_fmr->fmr_page_size,
@@ -979,11 +983,11 @@ int ehca_reg_mr(struct ehca_shca *shca,
 		goto ehca_reg_mr_exit1;
 
 	/* successful registration */
-	e_mr->num_pages = pginfo->num_pages;
-	e_mr->num_4k    = pginfo->num_4k;
-	e_mr->start     = iova_start;
-	e_mr->size      = size;
-	e_mr->acl       = acl;
+	e_mr->num_kpages = pginfo->num_kpages;
+	e_mr->num_hwpages = pginfo->num_hwpages;
+	e_mr->start = iova_start;
+	e_mr->size = size;
+	e_mr->acl = acl;
 	*lkey = hipzout.lkey;
 	*rkey = hipzout.rkey;
 	return 0;
@@ -993,10 +997,10 @@ ehca_reg_mr_exit1:
 	if (h_ret != H_SUCCESS) {
 		ehca_err(&shca->ib_device, "h_ret=%lx shca=%p e_mr=%p "
 			 "iova_start=%p size=%lx acl=%x e_pd=%p lkey=%x "
-			 "pginfo=%p num_pages=%lx num_4k=%lx ret=%x",
+			 "pginfo=%p num_kpages=%lx num_hwpages=%lx ret=%x",
 			 h_ret, shca, e_mr, iova_start, size, acl, e_pd,
-			 hipzout.lkey, pginfo, pginfo->num_pages,
-			 pginfo->num_4k, ret);
+			 hipzout.lkey, pginfo, pginfo->num_kpages,
+			 pginfo->num_hwpages, ret);
 		ehca_err(&shca->ib_device, "internal error in ehca_reg_mr, "
 			 "not recoverable");
 	}
@@ -1004,9 +1008,9 @@ ehca_reg_mr_exit0:
 	if (ret)
 		ehca_err(&shca->ib_device, "ret=%x shca=%p e_mr=%p "
 			 "iova_start=%p size=%lx acl=%x e_pd=%p pginfo=%p "
-			 "num_pages=%lx num_4k=%lx",
+			 "num_kpages=%lx num_hwpages=%lx",
 			 ret, shca, e_mr, iova_start, size, acl, e_pd, pginfo,
-			 pginfo->num_pages, pginfo->num_4k);
+			 pginfo->num_kpages, pginfo->num_hwpages);
 	return ret;
 } /* end ehca_reg_mr() */
 
@@ -1031,10 +1035,10 @@ int ehca_reg_mr_rpages(struct ehca_shca *shca,
 	}
 
 	/* max 512 pages per shot */
-	for (i = 0; i < NUM_CHUNKS(pginfo->num_4k, MAX_RPAGES); i++) {
+	for (i = 0; i < NUM_CHUNKS(pginfo->num_hwpages, MAX_RPAGES); i++) {
 
-		if (i == NUM_CHUNKS(pginfo->num_4k, MAX_RPAGES) - 1) {
-			rnum = pginfo->num_4k % MAX_RPAGES; /* last shot */
+		if (i == NUM_CHUNKS(pginfo->num_hwpages, MAX_RPAGES) - 1) {
+			rnum = pginfo->num_hwpages % MAX_RPAGES; /* last shot */
 			if (rnum == 0)
 				rnum = MAX_RPAGES;      /* last shot is full */
 		} else
@@ -1070,7 +1074,7 @@ int ehca_reg_mr_rpages(struct ehca_shca *shca,
 						 0, /* pagesize 4k */
 						 0, rpage, rnum);
 
-		if (i == NUM_CHUNKS(pginfo->num_4k, MAX_RPAGES) - 1) {
+		if (i == NUM_CHUNKS(pginfo->num_hwpages, MAX_RPAGES) - 1) {
 			/*
 			 * check for 'registration complete'==H_SUCCESS
 			 * and for 'page registered'==H_PAGE_REGISTERED
@@ -1106,8 +1110,8 @@ ehca_reg_mr_rpages_exit1:
 ehca_reg_mr_rpages_exit0:
 	if (ret)
 		ehca_err(&shca->ib_device, "ret=%x shca=%p e_mr=%p pginfo=%p "
-			 "num_pages=%lx num_4k=%lx", ret, shca, e_mr, pginfo,
-			 pginfo->num_pages, pginfo->num_4k);
+			 "num_kpages=%lx num_hwpages=%lx", ret, shca, e_mr,
+			 pginfo, pginfo->num_kpages, pginfo->num_hwpages);
 	return ret;
 } /* end ehca_reg_mr_rpages() */
 
@@ -1142,12 +1146,12 @@ inline int ehca_rereg_mr_rereg1(struct ehca_shca *shca,
 	}
 
 	pginfo_save = *pginfo;
-	ret = ehca_set_pagebuf(e_mr, pginfo, pginfo->num_4k, kpage);
+	ret = ehca_set_pagebuf(e_mr, pginfo, pginfo->num_hwpages, kpage);
 	if (ret) {
 		ehca_err(&shca->ib_device, "set pagebuf failed, e_mr=%p "
-			 "pginfo=%p type=%x num_pages=%lx num_4k=%lx kpage=%p",
-			 e_mr, pginfo, pginfo->type, pginfo->num_pages,
-			 pginfo->num_4k,kpage);
+			 "pginfo=%p type=%x num_kpages=%lx num_hwpages=%lx "
+			 "kpage=%p", e_mr, pginfo, pginfo->type,
+			 pginfo->num_kpages, pginfo->num_hwpages, kpage);
 		goto ehca_rereg_mr_rereg1_exit1;
 	}
 	rpage = virt_to_abs(kpage);
@@ -1181,11 +1185,11 @@ inline int ehca_rereg_mr_rereg1(struct ehca_shca *shca,
 		 * successful reregistration
 		 * note: start and start_out are identical for eServer HCAs
 		 */
-		e_mr->num_pages = pginfo->num_pages;
-		e_mr->num_4k    = pginfo->num_4k;
-		e_mr->start     = iova_start;
-		e_mr->size      = size;
-		e_mr->acl       = acl;
+		e_mr->num_kpages = pginfo->num_kpages;
+		e_mr->num_hwpages = pginfo->num_hwpages;
+		e_mr->start = iova_start;
+		e_mr->size = size;
+		e_mr->acl = acl;
 		*lkey = hipzout.lkey;
 		*rkey = hipzout.rkey;
 	}
@@ -1195,9 +1199,9 @@ ehca_rereg_mr_rereg1_exit1:
 ehca_rereg_mr_rereg1_exit0:
 	if ( ret && (ret != -EAGAIN) )
 		ehca_err(&shca->ib_device, "ret=%x lkey=%x rkey=%x "
-			 "pginfo=%p num_pages=%lx num_4k=%lx",
-			 ret, *lkey, *rkey, pginfo, pginfo->num_pages,
-			 pginfo->num_4k);
+			 "pginfo=%p num_kpages=%lx num_hwpages=%lx",
+			 ret, *lkey, *rkey, pginfo, pginfo->num_kpages,
+			 pginfo->num_hwpages);
 	return ret;
 } /* end ehca_rereg_mr_rereg1() */
 
@@ -1219,10 +1223,12 @@ int ehca_rereg_mr(struct ehca_shca *shca,
 	int rereg_3_hcall = 0; /* 1: use 3 hipz calls for reregistration */
 
 	/* first determine reregistration hCall(s) */
-	if ((pginfo->num_4k > MAX_RPAGES) || (e_mr->num_4k > MAX_RPAGES) ||
-	    (pginfo->num_4k > e_mr->num_4k)) {
-		ehca_dbg(&shca->ib_device, "Rereg3 case, pginfo->num_4k=%lx "
-			 "e_mr->num_4k=%x", pginfo->num_4k, e_mr->num_4k);
+	if ((pginfo->num_hwpages > MAX_RPAGES) ||
+	    (e_mr->num_hwpages > MAX_RPAGES) ||
+	    (pginfo->num_hwpages > e_mr->num_hwpages)) {
+		ehca_dbg(&shca->ib_device, "Rereg3 case, "
+			 "pginfo->num_hwpages=%lx e_mr->num_hwpages=%x",
+			 pginfo->num_hwpages, e_mr->num_hwpages);
 		rereg_1_hcall = 0;
 		rereg_3_hcall = 1;
 	}
@@ -1286,9 +1292,9 @@ ehca_rereg_mr_exit0:
 	if (ret)
 		ehca_err(&shca->ib_device, "ret=%x shca=%p e_mr=%p "
 			 "iova_start=%p size=%lx acl=%x e_pd=%p pginfo=%p "
-			 "num_pages=%lx lkey=%x rkey=%x rereg_1_hcall=%x "
+			 "num_kpages=%lx lkey=%x rkey=%x rereg_1_hcall=%x "
 			 "rereg_3_hcall=%x", ret, shca, e_mr, iova_start, size,
-			 acl, e_pd, pginfo, pginfo->num_pages, *lkey, *rkey,
+			 acl, e_pd, pginfo, pginfo->num_kpages, *lkey, *rkey,
 			 rereg_1_hcall, rereg_3_hcall);
 	return ret;
 } /* end ehca_rereg_mr() */
@@ -1306,7 +1312,7 @@ int ehca_unmap_one_fmr(struct ehca_shca *shca,
 		container_of(e_fmr->ib.ib_fmr.pd, struct ehca_pd, ib_pd);
 	struct ehca_mr save_fmr;
 	u32 tmp_lkey, tmp_rkey;
-	struct ehca_mr_pginfo pginfo={0,0,0,0,0,0,0,NULL,0,NULL,NULL,0,NULL,0};
+	struct ehca_mr_pginfo pginfo;
 	struct ehca_mr_hipzout_parms hipzout = {{0},0,0,0,0,0};
 
 	/* first check if reregistration hCall can be used for unmap */
@@ -1370,9 +1376,10 @@ int ehca_unmap_one_fmr(struct ehca_shca *shca,
 		e_fmr->fmr_map_cnt = save_fmr.fmr_map_cnt;
 		e_fmr->acl = save_fmr.acl;
 
-		pginfo.type      = EHCA_MR_PGI_FMR;
-		pginfo.num_pages = 0;
-		pginfo.num_4k    = 0;
+		memset(&pginfo, 0, sizeof(pginfo));
+		pginfo.type = EHCA_MR_PGI_FMR;
+		pginfo.num_kpages = 0;
+		pginfo.num_hwpages = 0;
 		ret = ehca_reg_mr(shca, e_fmr, NULL,
 				  (e_fmr->fmr_max_pages * e_fmr->fmr_page_size),
 				  e_fmr->acl, e_pd, &pginfo, &tmp_lkey,
@@ -1428,11 +1435,11 @@ int ehca_reg_smr(struct ehca_shca *shca,
 		goto ehca_reg_smr_exit0;
 	}
 	/* successful registration */
-	e_newmr->num_pages     = e_origmr->num_pages;
-	e_newmr->num_4k        = e_origmr->num_4k;
-	e_newmr->start         = iova_start;
-	e_newmr->size          = e_origmr->size;
-	e_newmr->acl           = acl;
+	e_newmr->num_kpages = e_origmr->num_kpages;
+	e_newmr->num_hwpages = e_origmr->num_hwpages;
+	e_newmr->start = iova_start;
+	e_newmr->size = e_origmr->size;
+	e_newmr->acl = acl;
 	e_newmr->ipz_mr_handle = hipzout.handle;
 	*lkey = hipzout.lkey;
 	*rkey = hipzout.rkey;
@@ -1458,10 +1465,10 @@ int ehca_reg_internal_maxmr(
 	struct ehca_mr *e_mr;
 	u64 *iova_start;
 	u64 size_maxmr;
-	struct ehca_mr_pginfo pginfo={0,0,0,0,0,0,0,NULL,0,NULL,NULL,0,NULL,0};
+	struct ehca_mr_pginfo pginfo;
 	struct ib_phys_buf ib_pbuf;
-	u32 num_pages_mr;
-	u32 num_pages_4k; /* 4k portion "pages" */
+	u32 num_kpages;
+	u32 num_hwpages;
 
 	e_mr = ehca_mr_new();
 	if (!e_mr) {
@@ -1476,25 +1483,26 @@ int ehca_reg_internal_maxmr(
 	iova_start = (u64*)KERNELBASE;
 	ib_pbuf.addr = 0;
 	ib_pbuf.size = size_maxmr;
-	num_pages_mr = NUM_CHUNKS(((u64)iova_start % PAGE_SIZE) + size_maxmr,
-				  PAGE_SIZE);
-	num_pages_4k = NUM_CHUNKS(((u64)iova_start % EHCA_PAGESIZE)
-				  + size_maxmr, EHCA_PAGESIZE);
-
-	pginfo.type           = EHCA_MR_PGI_PHYS;
-	pginfo.num_pages      = num_pages_mr;
-	pginfo.num_4k         = num_pages_4k;
-	pginfo.num_phys_buf   = 1;
-	pginfo.phys_buf_array = &ib_pbuf;
+	num_kpages = NUM_CHUNKS(((u64)iova_start % PAGE_SIZE) + size_maxmr,
+				PAGE_SIZE);
+	num_hwpages = NUM_CHUNKS(((u64)iova_start % EHCA_PAGESIZE) + size_maxmr,
+				 EHCA_PAGESIZE);
+
+	memset(&pginfo, 0, sizeof(pginfo));
+	pginfo.type = EHCA_MR_PGI_PHYS;
+	pginfo.num_kpages = num_kpages;
+	pginfo.num_hwpages = num_hwpages;
+	pginfo.u.phy.num_phys_buf = 1;
+	pginfo.u.phy.phys_buf_array = &ib_pbuf;
 
 	ret = ehca_reg_mr(shca, e_mr, iova_start, size_maxmr, 0, e_pd,
 			  &pginfo, &e_mr->ib.ib_mr.lkey,
 			  &e_mr->ib.ib_mr.rkey);
 	if (ret) {
 		ehca_err(&shca->ib_device, "reg of internal max MR failed, "
-			 "e_mr=%p iova_start=%p size_maxmr=%lx num_pages_mr=%x "
-			 "num_pages_4k=%x", e_mr, iova_start, size_maxmr,
-			 num_pages_mr, num_pages_4k);
+			 "e_mr=%p iova_start=%p size_maxmr=%lx num_kpages=%x "
+			 "num_hwpages=%x", e_mr, iova_start, size_maxmr,
+			 num_kpages, num_hwpages);
 		goto ehca_reg_internal_maxmr_exit1;
 	}
 
@@ -1546,11 +1554,11 @@ int ehca_reg_maxmr(struct ehca_shca *shca,
 		return ehca2ib_return_code(h_ret);
 	}
 	/* successful registration */
-	e_newmr->num_pages     = e_origmr->num_pages;
-	e_newmr->num_4k        = e_origmr->num_4k;
-	e_newmr->start         = iova_start;
-	e_newmr->size          = e_origmr->size;
-	e_newmr->acl           = acl;
+	e_newmr->num_kpages = e_origmr->num_kpages;
+	e_newmr->num_hwpages = e_origmr->num_hwpages;
+	e_newmr->start = iova_start;
+	e_newmr->size = e_origmr->size;
+	e_newmr->acl = acl;
 	e_newmr->ipz_mr_handle = hipzout.handle;
 	*lkey = hipzout.lkey;
 	*rkey = hipzout.rkey;
@@ -1693,138 +1701,139 @@ int ehca_set_pagebuf(struct ehca_mr *e_mr,
 	struct ib_umem_chunk *chunk;
 	struct ib_phys_buf *pbuf;
 	u64 *fmrlist;
-	u64 num4k, pgaddr, offs4k;
+	u64 num_hw, pgaddr, offs_hw;
 	u32 i = 0;
 	u32 j = 0;
 
 	if (pginfo->type == EHCA_MR_PGI_PHYS) {
 		/* loop over desired phys_buf_array entries */
 		while (i < number) {
-			pbuf   = pginfo->phys_buf_array + pginfo->next_buf;
-			num4k  = NUM_CHUNKS((pbuf->addr % EHCA_PAGESIZE)
-					    + pbuf->size, EHCA_PAGESIZE);
-			offs4k = (pbuf->addr & ~PAGE_MASK) / EHCA_PAGESIZE;
-			while (pginfo->next_4k < offs4k + num4k) {
+			pbuf   = pginfo->u.phy.phys_buf_array
+				+ pginfo->u.phy.next_buf;
+			num_hw  = NUM_CHUNKS((pbuf->addr % EHCA_PAGESIZE) +
+					     pbuf->size, EHCA_PAGESIZE);
+			offs_hw = (pbuf->addr & ~PAGE_MASK) / EHCA_PAGESIZE;
+			while (pginfo->next_hwpage < offs_hw + num_hw) {
 				/* sanity check */
-				if ((pginfo->page_cnt >= pginfo->num_pages) ||
-				    (pginfo->page_4k_cnt >= pginfo->num_4k)) {
-					ehca_gen_err("page_cnt >= num_pages, "
-						     "page_cnt=%lx "
-						     "num_pages=%lx "
-						     "page_4k_cnt=%lx "
-						     "num_4k=%lx i=%x",
-						     pginfo->page_cnt,
-						     pginfo->num_pages,
-						     pginfo->page_4k_cnt,
-						     pginfo->num_4k, i);
+				if ((pginfo->kpage_cnt >= pginfo->num_kpages) ||
+				    (pginfo->hwpage_cnt >= pginfo->num_hwpages)) {
+					ehca_gen_err("kpage_cnt >= num_kpages, "
+						     "kpage_cnt=%lx "
+						     "num_kpages=%lx "
+						     "hwpage_cnt=%lx "
+						     "num_hwpages=%lx i=%x",
+						     pginfo->kpage_cnt,
+						     pginfo->num_kpages,
+						     pginfo->hwpage_cnt,
+						     pginfo->num_hwpages, i);
 					ret = -EFAULT;
 					goto ehca_set_pagebuf_exit0;
 				}
 				*kpage = phys_to_abs(
 					(pbuf->addr & EHCA_PAGEMASK)
-					+ (pginfo->next_4k * EHCA_PAGESIZE));
+					+ (pginfo->next_hwpage * EHCA_PAGESIZE));
 				if ( !(*kpage) && pbuf->addr ) {
 					ehca_gen_err("pbuf->addr=%lx "
 						     "pbuf->size=%lx "
-						     "next_4k=%lx", pbuf->addr,
+						     "next_hwpage=%lx", pbuf->addr,
 						     pbuf->size,
-						     pginfo->next_4k);
+						     pginfo->next_hwpage);
 					ret = -EFAULT;
 					goto ehca_set_pagebuf_exit0;
 				}
-				(pginfo->page_4k_cnt)++;
-				(pginfo->next_4k)++;
-				if (pginfo->next_4k %
+				(pginfo->hwpage_cnt)++;
+				(pginfo->next_hwpage)++;
+				if (pginfo->next_hwpage %
 				    (PAGE_SIZE / EHCA_PAGESIZE) == 0)
-					(pginfo->page_cnt)++;
+					(pginfo->kpage_cnt)++;
 				kpage++;
 				i++;
 				if (i >= number) break;
 			}
-			if (pginfo->next_4k >= offs4k + num4k) {
-				(pginfo->next_buf)++;
-				pginfo->next_4k = 0;
+			if (pginfo->next_hwpage >= offs_hw + num_hw) {
+				(pginfo->u.phy.next_buf)++;
+				pginfo->next_hwpage = 0;
 			}
 		}
 	} else if (pginfo->type == EHCA_MR_PGI_USER) {
 		/* loop over desired chunk entries */
-		chunk      = pginfo->next_chunk;
-		prev_chunk = pginfo->next_chunk;
+		chunk      = pginfo->u.usr.next_chunk;
+		prev_chunk = pginfo->u.usr.next_chunk;
 		list_for_each_entry_continue(chunk,
-					     (&(pginfo->region->chunk_list)),
+					     (&(pginfo->u.usr.region->chunk_list)),
 					     list) {
-			for (i = pginfo->next_nmap; i < chunk->nmap; ) {
+			for (i = pginfo->u.usr.next_nmap; i < chunk->nmap; ) {
 				pgaddr = ( page_to_pfn(chunk->page_list[i].page)
 					   << PAGE_SHIFT );
 				*kpage = phys_to_abs(pgaddr +
-						     (pginfo->next_4k *
+						     (pginfo->next_hwpage *
 						      EHCA_PAGESIZE));
 				if ( !(*kpage) ) {
 					ehca_gen_err("pgaddr=%lx "
 						     "chunk->page_list[i]=%lx "
-						     "i=%x next_4k=%lx mr=%p",
+						     "i=%x next_hwpage=%lx mr=%p",
 						     pgaddr,
 						     (u64)sg_dma_address(
 							     &chunk->
 							     page_list[i]),
-						     i, pginfo->next_4k, e_mr);
+						     i, pginfo->next_hwpage, e_mr);
 					ret = -EFAULT;
 					goto ehca_set_pagebuf_exit0;
 				}
-				(pginfo->page_4k_cnt)++;
-				(pginfo->next_4k)++;
+				(pginfo->hwpage_cnt)++;
+				(pginfo->next_hwpage)++;
 				kpage++;
-				if (pginfo->next_4k %
+				if (pginfo->next_hwpage %
 				    (PAGE_SIZE / EHCA_PAGESIZE) == 0) {
-					(pginfo->page_cnt)++;
-					(pginfo->next_nmap)++;
-					pginfo->next_4k = 0;
+					(pginfo->kpage_cnt)++;
+					(pginfo->u.usr.next_nmap)++;
+					pginfo->next_hwpage = 0;
 					i++;
 				}
 				j++;
 				if (j >= number) break;
 			}
-			if ((pginfo->next_nmap >= chunk->nmap) &&
+			if ((pginfo->u.usr.next_nmap >= chunk->nmap) &&
 			    (j >= number)) {
-				pginfo->next_nmap = 0;
+				pginfo->u.usr.next_nmap = 0;
 				prev_chunk = chunk;
 				break;
-			} else if (pginfo->next_nmap >= chunk->nmap) {
-				pginfo->next_nmap = 0;
+			} else if (pginfo->u.usr.next_nmap >= chunk->nmap) {
+				pginfo->u.usr.next_nmap = 0;
 				prev_chunk = chunk;
 			} else if (j >= number)
 				break;
 			else
 				prev_chunk = chunk;
 		}
-		pginfo->next_chunk =
+		pginfo->u.usr.next_chunk =
 			list_prepare_entry(prev_chunk,
-					   (&(pginfo->region->chunk_list)),
+					   (&(pginfo->u.usr.region->chunk_list)),
 					   list);
 	} else if (pginfo->type == EHCA_MR_PGI_FMR) {
 		/* loop over desired page_list entries */
-		fmrlist = pginfo->page_list + pginfo->next_listelem;
+		fmrlist = pginfo->u.fmr.page_list + pginfo->u.fmr.next_listelem;
 		for (i = 0; i < number; i++) {
 			*kpage = phys_to_abs((*fmrlist & EHCA_PAGEMASK) +
-					     pginfo->next_4k * EHCA_PAGESIZE);
+					     pginfo->next_hwpage * EHCA_PAGESIZE);
 			if ( !(*kpage) ) {
 				ehca_gen_err("*fmrlist=%lx fmrlist=%p "
-					     "next_listelem=%lx next_4k=%lx",
+					     "next_listelem=%lx next_hwpage=%lx",
 					     *fmrlist, fmrlist,
-					     pginfo->next_listelem,
-					     pginfo->next_4k);
+					     pginfo->u.fmr.next_listelem,
+					     pginfo->next_hwpage);
 				ret = -EFAULT;
 				goto ehca_set_pagebuf_exit0;
 			}
-			(pginfo->page_4k_cnt)++;
-			(pginfo->next_4k)++;
+			(pginfo->hwpage_cnt)++;
+			(pginfo->next_hwpage)++;
 			kpage++;
-			if (pginfo->next_4k %
+			if (pginfo->next_hwpage %
 			    (e_mr->fmr_page_size / EHCA_PAGESIZE) == 0) {
-				(pginfo->page_cnt)++;
-				(pginfo->next_listelem)++;
+				(pginfo->kpage_cnt)++;
+				(pginfo->u.fmr.next_listelem)++;
 				fmrlist++;
-				pginfo->next_4k = 0;
+				pginfo->next_hwpage = 0;
 			}
 		}
 	} else {
@@ -1835,16 +1844,16 @@ int ehca_set_pagebuf(struct ehca_mr *e_mr,
 
 ehca_set_pagebuf_exit0:
 	if (ret)
-		ehca_gen_err("ret=%x e_mr=%p pginfo=%p type=%x num_pages=%lx "
-			     "num_4k=%lx next_buf=%lx next_4k=%lx number=%x "
-			     "kpage=%p page_cnt=%lx page_4k_cnt=%lx i=%x "
+		ehca_gen_err("ret=%x e_mr=%p pginfo=%p type=%x num_kpages=%lx "
+			     "num_hwpages=%lx next_buf=%lx next_hwpage=%lx number=%x "
+			     "kpage=%p kpage_cnt=%lx hwpage_cnt=%lx i=%x "
 			     "next_listelem=%lx region=%p next_chunk=%p "
 			     "next_nmap=%lx", ret, e_mr, pginfo, pginfo->type,
-			     pginfo->num_pages, pginfo->num_4k,
-			     pginfo->next_buf, pginfo->next_4k, number, kpage,
-			     pginfo->page_cnt, pginfo->page_4k_cnt, i,
-			     pginfo->next_listelem, pginfo->region,
-			     pginfo->next_chunk, pginfo->next_nmap);
+			     pginfo->num_kpages, pginfo->num_hwpages,
+			     pginfo->u.phy.next_buf, pginfo->next_hwpage, number, kpage,
+			     pginfo->kpage_cnt, pginfo->hwpage_cnt, i,
+			     pginfo->u.fmr.next_listelem, pginfo->u.usr.region,
+			     pginfo->u.usr.next_chunk, pginfo->u.usr.next_nmap);
 	return ret;
 } /* end ehca_set_pagebuf() */
 
@@ -1860,101 +1869,101 @@ int ehca_set_pagebuf_1(struct ehca_mr *e_mr,
 	u64 *fmrlist;
 	struct ib_umem_chunk *chunk;
 	struct ib_umem_chunk *prev_chunk;
-	u64 pgaddr, num4k, offs4k;
+	u64 pgaddr, num_hw, offs_hw;
 
 	if (pginfo->type == EHCA_MR_PGI_PHYS) {
 		/* sanity check */
-		if ((pginfo->page_cnt >= pginfo->num_pages) ||
-		    (pginfo->page_4k_cnt >= pginfo->num_4k)) {
-			ehca_gen_err("page_cnt >= num_pages, page_cnt=%lx "
-				     "num_pages=%lx page_4k_cnt=%lx num_4k=%lx",
-				     pginfo->page_cnt, pginfo->num_pages,
-				     pginfo->page_4k_cnt, pginfo->num_4k);
+		if ((pginfo->kpage_cnt >= pginfo->num_kpages) ||
+		    (pginfo->hwpage_cnt >= pginfo->num_hwpages)) {
+			ehca_gen_err("kpage_cnt >= num_hwpages, kpage_cnt=%lx "
+				     "num_hwpages=%lx hwpage_cnt=%lx num_hwpages=%lx",
+				     pginfo->kpage_cnt, pginfo->num_kpages,
+				     pginfo->hwpage_cnt, pginfo->num_hwpages);
 			ret = -EFAULT;
 			goto ehca_set_pagebuf_1_exit0;
 		}
-		tmp_pbuf = pginfo->phys_buf_array + pginfo->next_buf;
-		num4k  = NUM_CHUNKS((tmp_pbuf->addr % EHCA_PAGESIZE) +
-				    tmp_pbuf->size, EHCA_PAGESIZE);
-		offs4k = (tmp_pbuf->addr & ~PAGE_MASK) / EHCA_PAGESIZE;
+		tmp_pbuf = pginfo->u.phy.phys_buf_array + pginfo->u.phy.next_buf;
+		num_hw  = NUM_CHUNKS((tmp_pbuf->addr % EHCA_PAGESIZE) +
+				     tmp_pbuf->size, EHCA_PAGESIZE);
+		offs_hw = (tmp_pbuf->addr & ~PAGE_MASK) / EHCA_PAGESIZE;
 		*rpage = phys_to_abs((tmp_pbuf->addr & EHCA_PAGEMASK) +
-				     (pginfo->next_4k * EHCA_PAGESIZE));
+				     (pginfo->next_hwpage * EHCA_PAGESIZE));
 		if ( !(*rpage) && tmp_pbuf->addr ) {
 			ehca_gen_err("tmp_pbuf->addr=%lx"
-				     " tmp_pbuf->size=%lx next_4k=%lx",
+				     " tmp_pbuf->size=%lx next_hwpage=%lx",
 				     tmp_pbuf->addr, tmp_pbuf->size,
-				     pginfo->next_4k);
+				     pginfo->next_hwpage);
 			ret = -EFAULT;
 			goto ehca_set_pagebuf_1_exit0;
 		}
-		(pginfo->page_4k_cnt)++;
-		(pginfo->next_4k)++;
-		if (pginfo->next_4k % (PAGE_SIZE / EHCA_PAGESIZE) == 0)
-			(pginfo->page_cnt)++;
-		if (pginfo->next_4k >= offs4k + num4k) {
-			(pginfo->next_buf)++;
-			pginfo->next_4k = 0;
+		(pginfo->hwpage_cnt)++;
+		(pginfo->next_hwpage)++;
+		if (pginfo->next_hwpage % (PAGE_SIZE / EHCA_PAGESIZE) == 0)
+			(pginfo->kpage_cnt)++;
+		if (pginfo->next_hwpage >= offs_hw + num_hw) {
+			(pginfo->u.phy.next_buf)++;
+			pginfo->next_hwpage = 0;
 		}
 	} else if (pginfo->type == EHCA_MR_PGI_USER) {
-		chunk      = pginfo->next_chunk;
-		prev_chunk = pginfo->next_chunk;
+		chunk = pginfo->u.usr.next_chunk;
+		prev_chunk = pginfo->u.usr.next_chunk;
 		list_for_each_entry_continue(chunk,
-					     (&(pginfo->region->chunk_list)),
+					     (&(pginfo->u.usr.region->chunk_list)),
 					     list) {
 			pgaddr = ( page_to_pfn(chunk->page_list[
-						       pginfo->next_nmap].page)
+						       pginfo->u.usr.next_nmap].page)
 				   << PAGE_SHIFT);
 			*rpage = phys_to_abs(pgaddr +
-					     (pginfo->next_4k * EHCA_PAGESIZE));
+					     (pginfo->next_hwpage * EHCA_PAGESIZE));
 			if ( !(*rpage) ) {
 				ehca_gen_err("pgaddr=%lx chunk->page_list[]=%lx"
-					     " next_nmap=%lx next_4k=%lx mr=%p",
+					     " next_nmap=%lx next_hwpage=%lx mr=%p",
 					     pgaddr, (u64)sg_dma_address(
 						     &chunk->page_list[
-							     pginfo->
+							     pginfo->u.usr.
 							     next_nmap]),
-					     pginfo->next_nmap, pginfo->next_4k,
+					     pginfo->u.usr.next_nmap, pginfo->next_hwpage,
 					     e_mr);
 				ret = -EFAULT;
 				goto ehca_set_pagebuf_1_exit0;
 			}
-			(pginfo->page_4k_cnt)++;
-			(pginfo->next_4k)++;
-			if (pginfo->next_4k %
+			(pginfo->hwpage_cnt)++;
+			(pginfo->next_hwpage)++;
+			if (pginfo->next_hwpage %
 			    (PAGE_SIZE / EHCA_PAGESIZE) == 0) {
-				(pginfo->page_cnt)++;
-				(pginfo->next_nmap)++;
-				pginfo->next_4k = 0;
+				(pginfo->kpage_cnt)++;
+				(pginfo->u.usr.next_nmap)++;
+				pginfo->next_hwpage = 0;
 			}
-			if (pginfo->next_nmap >= chunk->nmap) {
-				pginfo->next_nmap = 0;
+			if (pginfo->u.usr.next_nmap >= chunk->nmap) {
+				pginfo->u.usr.next_nmap = 0;
 				prev_chunk = chunk;
 			}
 			break;
 		}
-		pginfo->next_chunk =
+		pginfo->u.usr.next_chunk =
 			list_prepare_entry(prev_chunk,
-					   (&(pginfo->region->chunk_list)),
+					   (&(pginfo->u.usr.region->chunk_list)),
 					   list);
 	} else if (pginfo->type == EHCA_MR_PGI_FMR) {
-		fmrlist = pginfo->page_list + pginfo->next_listelem;
+		fmrlist = pginfo->u.fmr.page_list + pginfo->u.fmr.next_listelem;
 		*rpage = phys_to_abs((*fmrlist & EHCA_PAGEMASK) +
-				     pginfo->next_4k * EHCA_PAGESIZE);
+				     pginfo->next_hwpage * EHCA_PAGESIZE);
 		if ( !(*rpage) ) {
 			ehca_gen_err("*fmrlist=%lx fmrlist=%p "
-				     "next_listelem=%lx next_4k=%lx",
-				     *fmrlist, fmrlist, pginfo->next_listelem,
-				     pginfo->next_4k);
+				     "next_listelem=%lx next_hwpage=%lx",
+				     *fmrlist, fmrlist, pginfo->u.fmr.next_listelem,
+				     pginfo->next_hwpage);
 			ret = -EFAULT;
 			goto ehca_set_pagebuf_1_exit0;
 		}
-		(pginfo->page_4k_cnt)++;
-		(pginfo->next_4k)++;
-		if (pginfo->next_4k %
+		(pginfo->hwpage_cnt)++;
+		(pginfo->next_hwpage)++;
+		if (pginfo->next_hwpage %
 		    (e_mr->fmr_page_size / EHCA_PAGESIZE) == 0) {
-			(pginfo->page_cnt)++;
-			(pginfo->next_listelem)++;
-			pginfo->next_4k = 0;
+			(pginfo->kpage_cnt)++;
+			(pginfo->u.fmr.next_listelem)++;
+			pginfo->next_hwpage = 0;
 		}
 	} else {
 		ehca_gen_err("bad pginfo->type=%x", pginfo->type);
@@ -1964,15 +1973,15 @@ int ehca_set_pagebuf_1(struct ehca_mr *e_mr,
 
 ehca_set_pagebuf_1_exit0:
 	if (ret)
-		ehca_gen_err("ret=%x e_mr=%p pginfo=%p type=%x num_pages=%lx "
-			     "num_4k=%lx next_buf=%lx next_4k=%lx rpage=%p "
-			     "page_cnt=%lx page_4k_cnt=%lx next_listelem=%lx "
+		ehca_gen_err("ret=%x e_mr=%p pginfo=%p type=%x num_kpages=%lx "
+			     "num_hwpages=%lx next_buf=%lx next_hwpage=%lx rpage=%p "
+			     "kpage_cnt=%lx hwpage_cnt=%lx next_listelem=%lx "
 			     "region=%p next_chunk=%p next_nmap=%lx", ret, e_mr,
-			     pginfo, pginfo->type, pginfo->num_pages,
-			     pginfo->num_4k, pginfo->next_buf, pginfo->next_4k,
-			     rpage, pginfo->page_cnt, pginfo->page_4k_cnt,
-			     pginfo->next_listelem, pginfo->region,
-			     pginfo->next_chunk, pginfo->next_nmap);
+			     pginfo, pginfo->type, pginfo->num_kpages,
+			     pginfo->num_hwpages, pginfo->u.phy.next_buf, pginfo->next_hwpage,
+			     rpage, pginfo->kpage_cnt, pginfo->hwpage_cnt,
+			     pginfo->u.fmr.next_listelem, pginfo->u.usr.region,
+			     pginfo->u.usr.next_chunk, pginfo->u.usr.next_nmap);
 	return ret;
 } /* end ehca_set_pagebuf_1() */
 
@@ -2053,19 +2062,17 @@ void ehca_mrmw_reverse_map_acl(const u32 *hipz_acl,
  */
 void ehca_mr_deletenew(struct ehca_mr *mr)
 {
-	mr->flags         = 0;
-	mr->num_pages     = 0;
-	mr->num_4k        = 0;
-	mr->acl           = 0;
-	mr->start         = NULL;
+	mr->flags = 0;
+	mr->num_kpages = 0;
+	mr->num_hwpages = 0;
+	mr->acl = 0;
+	mr->start = NULL;
 	mr->fmr_page_size = 0;
 	mr->fmr_max_pages = 0;
-	mr->fmr_max_maps  = 0;
-	mr->fmr_map_cnt   = 0;
+	mr->fmr_max_maps = 0;
+	mr->fmr_map_cnt = 0;
 	memset(&mr->ipz_mr_handle, 0, sizeof(mr->ipz_mr_handle));
 	memset(&mr->galpas, 0, sizeof(mr->galpas));
-	mr->nr_of_pages   = 0;
-	mr->pagearray     = NULL;
 } /* end ehca_mr_deletenew() */
 
 int ehca_init_mrmw_cache(void)
-- 
1.5.2


