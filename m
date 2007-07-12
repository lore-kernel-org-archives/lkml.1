Return-Path: <linux-kernel-owner+w=401wt.eu-S935189AbXGLPx0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935189AbXGLPx0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 11:53:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756938AbXGLPxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 11:53:16 -0400
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:15598 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763202AbXGLPxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 11:53:14 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>
Subject: [PATCH 08/10] IB/ehca: Restructure ehca_set_pagebuf()
User-Agent: KMail/1.8.2
Cc: "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
References: <200707121745.27592.fenkes@de.ibm.com>
In-Reply-To: <200707121745.27592.fenkes@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 25418
Date: Thu, 12 Jul 2007 17:53:11 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200707121753.12404.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hoang-Nam Nguyen <hnguyen@de.ibm.com>

Split ehca_set_pagebuf() into three functions depending on MR type
(phys/user/fast) and remove superfluous ehca_set_pagebuf_1().

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_mrmw.c |  531 ++++++++++++--------------------
 1 files changed, 200 insertions(+), 331 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_mrmw.c b/drivers/infiniband/hw/ehca/ehca_mrmw.c
index 53b334b..93c26cc 100644
--- a/drivers/infiniband/hw/ehca/ehca_mrmw.c
+++ b/drivers/infiniband/hw/ehca/ehca_mrmw.c
@@ -824,6 +824,7 @@ int ehca_map_phys_fmr(struct ib_fmr *fmr,
 	pginfo.u.fmr.page_list = page_list;
 	pginfo.next_hwpage = ((iova & (e_fmr->fmr_page_size-1)) /
 			      EHCA_PAGESIZE);
+	pginfo.u.fmr.fmr_pgsize = e_fmr->fmr_page_size;
 
 	ret = ehca_rereg_mr(shca, e_fmr, (u64*)iova,
 			    list_len * e_fmr->fmr_page_size,
@@ -1044,15 +1045,15 @@ int ehca_reg_mr_rpages(struct ehca_shca *shca,
 		} else
 			rnum = MAX_RPAGES;
 
-		if (rnum > 1) {
-			ret = ehca_set_pagebuf(e_mr, pginfo, rnum, kpage);
-			if (ret) {
-				ehca_err(&shca->ib_device, "ehca_set_pagebuf "
+		ret = ehca_set_pagebuf(pginfo, rnum, kpage);
+		if (ret) {
+			ehca_err(&shca->ib_device, "ehca_set_pagebuf "
 					 "bad rc, ret=%x rnum=%x kpage=%p",
 					 ret, rnum, kpage);
-				ret = -EFAULT;
-				goto ehca_reg_mr_rpages_exit1;
-			}
+			goto ehca_reg_mr_rpages_exit1;
+		}
+
+		if (rnum > 1) {
 			rpage = virt_to_abs(kpage);
 			if (!rpage) {
 				ehca_err(&shca->ib_device, "kpage=%p i=%x",
@@ -1060,15 +1061,8 @@ int ehca_reg_mr_rpages(struct ehca_shca *shca,
 				ret = -EFAULT;
 				goto ehca_reg_mr_rpages_exit1;
 			}
-		} else {  /* rnum==1 */
-			ret = ehca_set_pagebuf_1(e_mr, pginfo, &rpage);
-			if (ret) {
-				ehca_err(&shca->ib_device, "ehca_set_pagebuf_1 "
-					 "bad rc, ret=%x i=%x", ret, i);
-				ret = -EFAULT;
-				goto ehca_reg_mr_rpages_exit1;
-			}
-		}
+		} else
+			rpage = *kpage;
 
 		h_ret = hipz_h_register_rpage_mr(shca->ipz_hca_handle, e_mr,
 						 0, /* pagesize 4k */
@@ -1146,7 +1140,7 @@ inline int ehca_rereg_mr_rereg1(struct ehca_shca *shca,
 	}
 
 	pginfo_save = *pginfo;
-	ret = ehca_set_pagebuf(e_mr, pginfo, pginfo->num_hwpages, kpage);
+	ret = ehca_set_pagebuf(pginfo, pginfo->num_hwpages, kpage);
 	if (ret) {
 		ehca_err(&shca->ib_device, "set pagebuf failed, e_mr=%p "
 			 "pginfo=%p type=%x num_kpages=%lx num_hwpages=%lx "
@@ -1306,98 +1300,86 @@ int ehca_unmap_one_fmr(struct ehca_shca *shca,
 {
 	int ret = 0;
 	u64 h_ret;
-	int rereg_1_hcall = 1; /* 1: use hipz_mr_reregister directly */
-	int rereg_3_hcall = 0; /* 1: use 3 hipz calls for unmapping */
 	struct ehca_pd *e_pd =
 		container_of(e_fmr->ib.ib_fmr.pd, struct ehca_pd, ib_pd);
 	struct ehca_mr save_fmr;
 	u32 tmp_lkey, tmp_rkey;
 	struct ehca_mr_pginfo pginfo;
 	struct ehca_mr_hipzout_parms hipzout = {{0},0,0,0,0,0};
+	struct ehca_mr save_mr;
 
-	/* first check if reregistration hCall can be used for unmap */
-	if (e_fmr->fmr_max_pages > MAX_RPAGES) {
-		rereg_1_hcall = 0;
-		rereg_3_hcall = 1;
-	}
-
-	if (rereg_1_hcall) {
+	if (e_fmr->fmr_max_pages <= MAX_RPAGES) {
 		/*
 		 * note: after using rereg hcall with len=0,
 		 * rereg hcall must be used again for registering pages
 		 */
 		h_ret = hipz_h_reregister_pmr(shca->ipz_hca_handle, e_fmr, 0,
 					      0, 0, e_pd->fw_pd, 0, &hipzout);
-		if (h_ret != H_SUCCESS) {
-			/*
-			 * should not happen, because length checked above,
-			 * FMRs are not shared and no MW bound to FMRs
-			 */
-			ehca_err(&shca->ib_device, "hipz_reregister_pmr failed "
-				 "(Rereg1), h_ret=%lx e_fmr=%p hca_hndl=%lx "
-				 "mr_hndl=%lx lkey=%x lkey_out=%x",
-				 h_ret, e_fmr, shca->ipz_hca_handle.handle,
-				 e_fmr->ipz_mr_handle.handle,
-				 e_fmr->ib.ib_fmr.lkey, hipzout.lkey);
-			rereg_3_hcall = 1;
-		} else {
+		if (h_ret == H_SUCCESS) {
 			/* successful reregistration */
 			e_fmr->start = NULL;
 			e_fmr->size = 0;
 			tmp_lkey = hipzout.lkey;
 			tmp_rkey = hipzout.rkey;
+			return 0;
 		}
+		/*
+		 * should not happen, because length checked above,
+		 * FMRs are not shared and no MW bound to FMRs
+		 */
+		ehca_err(&shca->ib_device, "hipz_reregister_pmr failed "
+			 "(Rereg1), h_ret=%lx e_fmr=%p hca_hndl=%lx "
+			 "mr_hndl=%lx lkey=%x lkey_out=%x",
+			 h_ret, e_fmr, shca->ipz_hca_handle.handle,
+			 e_fmr->ipz_mr_handle.handle,
+			 e_fmr->ib.ib_fmr.lkey, hipzout.lkey);
+		/* try free and rereg */
 	}
 
-	if (rereg_3_hcall) {
-		struct ehca_mr save_mr;
-
-		/* first free old FMR */
-		h_ret = hipz_h_free_resource_mr(shca->ipz_hca_handle, e_fmr);
-		if (h_ret != H_SUCCESS) {
-			ehca_err(&shca->ib_device, "hipz_free_mr failed, "
-				 "h_ret=%lx e_fmr=%p hca_hndl=%lx mr_hndl=%lx "
-				 "lkey=%x",
-				 h_ret, e_fmr, shca->ipz_hca_handle.handle,
-				 e_fmr->ipz_mr_handle.handle,
-				 e_fmr->ib.ib_fmr.lkey);
-			ret = ehca2ib_return_code(h_ret);
-			goto ehca_unmap_one_fmr_exit0;
-		}
-		/* clean ehca_mr_t, without changing lock */
-		save_fmr = *e_fmr;
-		ehca_mr_deletenew(e_fmr);
+	/* first free old FMR */
+	h_ret = hipz_h_free_resource_mr(shca->ipz_hca_handle, e_fmr);
+	if (h_ret != H_SUCCESS) {
+		ehca_err(&shca->ib_device, "hipz_free_mr failed, "
+			 "h_ret=%lx e_fmr=%p hca_hndl=%lx mr_hndl=%lx "
+			 "lkey=%x",
+			 h_ret, e_fmr, shca->ipz_hca_handle.handle,
+			 e_fmr->ipz_mr_handle.handle,
+			 e_fmr->ib.ib_fmr.lkey);
+		ret = ehca2ib_return_code(h_ret);
+		goto ehca_unmap_one_fmr_exit0;
+	}
+	/* clean ehca_mr_t, without changing lock */
+	save_fmr = *e_fmr;
+	ehca_mr_deletenew(e_fmr);
 
-		/* set some MR values */
-		e_fmr->flags = save_fmr.flags;
-		e_fmr->fmr_page_size = save_fmr.fmr_page_size;
-		e_fmr->fmr_max_pages = save_fmr.fmr_max_pages;
-		e_fmr->fmr_max_maps = save_fmr.fmr_max_maps;
-		e_fmr->fmr_map_cnt = save_fmr.fmr_map_cnt;
-		e_fmr->acl = save_fmr.acl;
+	/* set some MR values */
+	e_fmr->flags = save_fmr.flags;
+	e_fmr->fmr_page_size = save_fmr.fmr_page_size;
+	e_fmr->fmr_max_pages = save_fmr.fmr_max_pages;
+	e_fmr->fmr_max_maps = save_fmr.fmr_max_maps;
+	e_fmr->fmr_map_cnt = save_fmr.fmr_map_cnt;
+	e_fmr->acl = save_fmr.acl;
 
-		memset(&pginfo, 0, sizeof(pginfo));
-		pginfo.type = EHCA_MR_PGI_FMR;
-		pginfo.num_kpages = 0;
-		pginfo.num_hwpages = 0;
-		ret = ehca_reg_mr(shca, e_fmr, NULL,
-				  (e_fmr->fmr_max_pages * e_fmr->fmr_page_size),
-				  e_fmr->acl, e_pd, &pginfo, &tmp_lkey,
-				  &tmp_rkey);
-		if (ret) {
-			u32 offset = (u64)(&e_fmr->flags) - (u64)e_fmr;
-			memcpy(&e_fmr->flags, &(save_mr.flags),
-			       sizeof(struct ehca_mr) - offset);
-			goto ehca_unmap_one_fmr_exit0;
-		}
+	memset(&pginfo, 0, sizeof(pginfo));
+	pginfo.type = EHCA_MR_PGI_FMR;
+	pginfo.num_kpages = 0;
+	pginfo.num_hwpages = 0;
+	ret = ehca_reg_mr(shca, e_fmr, NULL,
+			  (e_fmr->fmr_max_pages * e_fmr->fmr_page_size),
+			  e_fmr->acl, e_pd, &pginfo, &tmp_lkey,
+			  &tmp_rkey);
+	if (ret) {
+		u32 offset = (u64)(&e_fmr->flags) - (u64)e_fmr;
+		memcpy(&e_fmr->flags, &(save_mr.flags),
+		       sizeof(struct ehca_mr) - offset);
+		goto ehca_unmap_one_fmr_exit0;
 	}
 
 ehca_unmap_one_fmr_exit0:
 	if (ret)
 		ehca_err(&shca->ib_device, "ret=%x tmp_lkey=%x tmp_rkey=%x "
-			 "fmr_max_pages=%x rereg_1_hcall=%x rereg_3_hcall=%x",
-			 ret, tmp_lkey, tmp_rkey, e_fmr->fmr_max_pages,
-			 rereg_1_hcall, rereg_3_hcall);
+			 "fmr_max_pages=%x",
+			 ret, tmp_lkey, tmp_rkey, e_fmr->fmr_max_pages);
 	return ret;
 } /* end ehca_unmap_one_fmr() */
 
@@ -1690,300 +1672,187 @@ int ehca_fmr_check_page_list(struct ehca_mr *e_fmr,
 
 /*----------------------------------------------------------------------*/
 
-/* setup page buffer from page info */
-int ehca_set_pagebuf(struct ehca_mr *e_mr,
-		     struct ehca_mr_pginfo *pginfo,
-		     u32 number,
-		     u64 *kpage)
+/* PAGE_SIZE >= pginfo->hwpage_size */
+static int ehca_set_pagebuf_user1(struct ehca_mr_pginfo *pginfo,
+				  u32 number,
+				  u64 *kpage)
 {
 	int ret = 0;
 	struct ib_umem_chunk *prev_chunk;
 	struct ib_umem_chunk *chunk;
-	struct ib_phys_buf *pbuf;
-	u64 *fmrlist;
-	u64 num_hw, pgaddr, offs_hw;
+	u64 pgaddr;
 	u32 i = 0;
 	u32 j = 0;
 
-	if (pginfo->type == EHCA_MR_PGI_PHYS) {
-		/* loop over desired phys_buf_array entries */
-		while (i < number) {
-			pbuf   = pginfo->u.phy.phys_buf_array
-				+ pginfo->u.phy.next_buf;
-			num_hw  = NUM_CHUNKS((pbuf->addr % EHCA_PAGESIZE) +
-					     pbuf->size, EHCA_PAGESIZE);
-			offs_hw = (pbuf->addr & ~PAGE_MASK) / EHCA_PAGESIZE;
-			while (pginfo->next_hwpage < offs_hw + num_hw) {
-				/* sanity check */
-				if ((pginfo->kpage_cnt >= pginfo->num_kpages) ||
-				    (pginfo->hwpage_cnt >= pginfo->num_hwpages)) {
-					ehca_gen_err("kpage_cnt >= num_kpages, "
-						     "kpage_cnt=%lx "
-						     "num_kpages=%lx "
-						     "hwpage_cnt=%lx "
-						     "num_hwpages=%lx i=%x",
-						     pginfo->kpage_cnt,
-						     pginfo->num_kpages,
-						     pginfo->hwpage_cnt,
-						     pginfo->num_hwpages, i);
-					ret = -EFAULT;
-					goto ehca_set_pagebuf_exit0;
-				}
-				*kpage = phys_to_abs(
-					(pbuf->addr & EHCA_PAGEMASK)
-					+ (pginfo->next_hwpage * EHCA_PAGESIZE));
-				if ( !(*kpage) && pbuf->addr ) {
-					ehca_gen_err("pbuf->addr=%lx "
-						     "pbuf->size=%lx "
-						     "next_hwpage=%lx", pbuf->addr,
-						     pbuf->size,
-						     pginfo->next_hwpage);
-					ret = -EFAULT;
-					goto ehca_set_pagebuf_exit0;
-				}
-				(pginfo->hwpage_cnt)++;
-				(pginfo->next_hwpage)++;
-				if (pginfo->next_hwpage %
-				    (PAGE_SIZE / EHCA_PAGESIZE) == 0)
-					(pginfo->kpage_cnt)++;
-				kpage++;
-				i++;
-				if (i >= number) break;
-			}
-			if (pginfo->next_hwpage >= offs_hw + num_hw) {
-				(pginfo->u.phy.next_buf)++;
-				pginfo->next_hwpage = 0;
-			}
-		}
-	} else if (pginfo->type == EHCA_MR_PGI_USER) {
-		/* loop over desired chunk entries */
-		chunk      = pginfo->u.usr.next_chunk;
-		prev_chunk = pginfo->u.usr.next_chunk;
-		list_for_each_entry_continue(chunk,
-					     (&(pginfo->u.usr.region->chunk_list)),
-					     list) {
-			for (i = pginfo->u.usr.next_nmap; i < chunk->nmap; ) {
-				pgaddr = ( page_to_pfn(chunk->page_list[i].page)
-					   << PAGE_SHIFT );
-				*kpage = phys_to_abs(pgaddr +
-						     (pginfo->next_hwpage *
-						      EHCA_PAGESIZE));
-				if ( !(*kpage) ) {
-					ehca_gen_err("pgaddr=%lx "
-						     "chunk->page_list[i]=%lx "
-						     "i=%x next_hwpage=%lx mr=%p",
-						     pgaddr,
-						     (u64)sg_dma_address(
-							     &chunk->
-							     page_list[i]),
-						     i, pginfo->next_hwpage, e_mr);
-					ret = -EFAULT;
-					goto ehca_set_pagebuf_exit0;
-				}
-				(pginfo->hwpage_cnt)++;
-				(pginfo->next_hwpage)++;
-				kpage++;
-				if (pginfo->next_hwpage %
-				    (PAGE_SIZE / EHCA_PAGESIZE) == 0) {
-					(pginfo->kpage_cnt)++;
-					(pginfo->u.usr.next_nmap)++;
-					pginfo->next_hwpage = 0;
-					i++;
-				}
-				j++;
-				if (j >= number) break;
-			}
-			if ((pginfo->u.usr.next_nmap >= chunk->nmap) &&
-			    (j >= number)) {
-				pginfo->u.usr.next_nmap = 0;
-				prev_chunk = chunk;
-				break;
-			} else if (pginfo->u.usr.next_nmap >= chunk->nmap) {
-				pginfo->u.usr.next_nmap = 0;
-				prev_chunk = chunk;
-			} else if (j >= number)
-				break;
-			else
-				prev_chunk = chunk;
-		}
-		pginfo->u.usr.next_chunk =
-			list_prepare_entry(prev_chunk,
-					   (&(pginfo->u.usr.region->chunk_list)),
-					   list);
-	} else if (pginfo->type == EHCA_MR_PGI_FMR) {
-		/* loop over desired page_list entries */
-		fmrlist = pginfo->u.fmr.page_list + pginfo->u.fmr.next_listelem;
-		for (i = 0; i < number; i++) {
-			*kpage = phys_to_abs((*fmrlist & EHCA_PAGEMASK) +
-					     pginfo->next_hwpage * EHCA_PAGESIZE);
+	/* loop over desired chunk entries */
+	chunk      = pginfo->u.usr.next_chunk;
+	prev_chunk = pginfo->u.usr.next_chunk;
+	list_for_each_entry_continue(
+		chunk, (&(pginfo->u.usr.region->chunk_list)), list) {
+		for (i = pginfo->u.usr.next_nmap; i < chunk->nmap; ) {
+			pgaddr = page_to_pfn(chunk->page_list[i].page)
+				<< PAGE_SHIFT ;
+			*kpage = phys_to_abs(pgaddr +
+					     (pginfo->next_hwpage *
+					      EHCA_PAGESIZE));
 			if ( !(*kpage) ) {
-				ehca_gen_err("*fmrlist=%lx fmrlist=%p "
-					     "next_listelem=%lx next_hwpage=%lx",
-					     *fmrlist, fmrlist,
-					     pginfo->u.fmr.next_listelem,
-					     pginfo->next_hwpage);
-				ret = -EFAULT;
-				goto ehca_set_pagebuf_exit0;
+				ehca_gen_err("pgaddr=%lx "
+					     "chunk->page_list[i]=%lx "
+					     "i=%x next_hwpage=%lx",
+					     pgaddr, (u64)sg_dma_address(
+						     &chunk->page_list[i]),
+					     i, pginfo->next_hwpage);
+				return -EFAULT;
 			}
 			(pginfo->hwpage_cnt)++;
 			(pginfo->next_hwpage)++;
 			kpage++;
 			if (pginfo->next_hwpage %
-			    (e_mr->fmr_page_size / EHCA_PAGESIZE) == 0) {
+			    (PAGE_SIZE / EHCA_PAGESIZE) == 0) {
 				(pginfo->kpage_cnt)++;
-				(pginfo->u.fmr.next_listelem)++;
-				fmrlist++;
+				(pginfo->u.usr.next_nmap)++;
 				pginfo->next_hwpage = 0;
+				i++;
 			}
+			j++;
+			if (j >= number) break;
 		}
-	} else {
-		ehca_gen_err("bad pginfo->type=%x", pginfo->type);
-		ret = -EFAULT;
-		goto ehca_set_pagebuf_exit0;
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
 	}
-
-ehca_set_pagebuf_exit0:
-	if (ret)
-		ehca_gen_err("ret=%x e_mr=%p pginfo=%p type=%x num_kpages=%lx "
-			     "num_hwpages=%lx next_buf=%lx next_hwpage=%lx number=%x "
-			     "kpage=%p kpage_cnt=%lx hwpage_cnt=%lx i=%x "
-			     "next_listelem=%lx region=%p next_chunk=%p "
-			     "next_nmap=%lx", ret, e_mr, pginfo, pginfo->type,
-			     pginfo->num_kpages, pginfo->num_hwpages,
-			     pginfo->u.phy.next_buf, pginfo->next_hwpage, number, kpage,
-			     pginfo->kpage_cnt, pginfo->hwpage_cnt, i,
-			     pginfo->u.fmr.next_listelem, pginfo->u.usr.region,
-			     pginfo->u.usr.next_chunk, pginfo->u.usr.next_nmap);
+	pginfo->u.usr.next_chunk =
+		list_prepare_entry(prev_chunk,
+				   (&(pginfo->u.usr.region->chunk_list)),
+				   list);
 	return ret;
-} /* end ehca_set_pagebuf() */
-
-/*----------------------------------------------------------------------*/
+}
 
-/* setup 1 page from page info page buffer */
-int ehca_set_pagebuf_1(struct ehca_mr *e_mr,
-		       struct ehca_mr_pginfo *pginfo,
-		       u64 *rpage)
+int ehca_set_pagebuf_phys(struct ehca_mr_pginfo *pginfo,
+			  u32 number,
+			  u64 *kpage)
 {
 	int ret = 0;
-	struct ib_phys_buf *tmp_pbuf;
-	u64 *fmrlist;
-	struct ib_umem_chunk *chunk;
-	struct ib_umem_chunk *prev_chunk;
-	u64 pgaddr, num_hw, offs_hw;
-
-	if (pginfo->type == EHCA_MR_PGI_PHYS) {
-		/* sanity check */
-		if ((pginfo->kpage_cnt >= pginfo->num_kpages) ||
-		    (pginfo->hwpage_cnt >= pginfo->num_hwpages)) {
-			ehca_gen_err("kpage_cnt >= num_hwpages, kpage_cnt=%lx "
-				     "num_hwpages=%lx hwpage_cnt=%lx num_hwpages=%lx",
-				     pginfo->kpage_cnt, pginfo->num_kpages,
-				     pginfo->hwpage_cnt, pginfo->num_hwpages);
-			ret = -EFAULT;
-			goto ehca_set_pagebuf_1_exit0;
-		}
-		tmp_pbuf = pginfo->u.phy.phys_buf_array + pginfo->u.phy.next_buf;
-		num_hw  = NUM_CHUNKS((tmp_pbuf->addr % EHCA_PAGESIZE) +
-				     tmp_pbuf->size, EHCA_PAGESIZE);
-		offs_hw = (tmp_pbuf->addr & ~PAGE_MASK) / EHCA_PAGESIZE;
-		*rpage = phys_to_abs((tmp_pbuf->addr & EHCA_PAGEMASK) +
-				     (pginfo->next_hwpage * EHCA_PAGESIZE));
-		if ( !(*rpage) && tmp_pbuf->addr ) {
-			ehca_gen_err("tmp_pbuf->addr=%lx"
-				     " tmp_pbuf->size=%lx next_hwpage=%lx",
-				     tmp_pbuf->addr, tmp_pbuf->size,
-				     pginfo->next_hwpage);
-			ret = -EFAULT;
-			goto ehca_set_pagebuf_1_exit0;
-		}
-		(pginfo->hwpage_cnt)++;
-		(pginfo->next_hwpage)++;
-		if (pginfo->next_hwpage % (PAGE_SIZE / EHCA_PAGESIZE) == 0)
-			(pginfo->kpage_cnt)++;
-		if (pginfo->next_hwpage >= offs_hw + num_hw) {
-			(pginfo->u.phy.next_buf)++;
-			pginfo->next_hwpage = 0;
-		}
-	} else if (pginfo->type == EHCA_MR_PGI_USER) {
-		chunk = pginfo->u.usr.next_chunk;
-		prev_chunk = pginfo->u.usr.next_chunk;
-		list_for_each_entry_continue(chunk,
-					     (&(pginfo->u.usr.region->chunk_list)),
-					     list) {
-			pgaddr = ( page_to_pfn(chunk->page_list[
-						       pginfo->u.usr.next_nmap].page)
-				   << PAGE_SHIFT);
-			*rpage = phys_to_abs(pgaddr +
-					     (pginfo->next_hwpage * EHCA_PAGESIZE));
-			if ( !(*rpage) ) {
-				ehca_gen_err("pgaddr=%lx chunk->page_list[]=%lx"
-					     " next_nmap=%lx next_hwpage=%lx mr=%p",
-					     pgaddr, (u64)sg_dma_address(
-						     &chunk->page_list[
-							     pginfo->u.usr.
-							     next_nmap]),
-					     pginfo->u.usr.next_nmap, pginfo->next_hwpage,
-					     e_mr);
-				ret = -EFAULT;
-				goto ehca_set_pagebuf_1_exit0;
+	struct ib_phys_buf *pbuf;
+	u64 num_hw, offs_hw;
+	u32 i = 0;
+
+	/* loop over desired phys_buf_array entries */
+	while (i < number) {
+		pbuf   = pginfo->u.phy.phys_buf_array + pginfo->u.phy.next_buf;
+		num_hw  = NUM_CHUNKS((pbuf->addr % EHCA_PAGESIZE) +
+				     pbuf->size, EHCA_PAGESIZE);
+		offs_hw = (pbuf->addr & ~PAGE_MASK) / EHCA_PAGESIZE;
+		while (pginfo->next_hwpage < offs_hw + num_hw) {
+			/* sanity check */
+			if ((pginfo->kpage_cnt >= pginfo->num_kpages) ||
+			    (pginfo->hwpage_cnt >= pginfo->num_hwpages)) {
+				ehca_gen_err("kpage_cnt >= num_kpages, "
+					     "kpage_cnt=%lx num_kpages=%lx "
+					     "hwpage_cnt=%lx "
+					     "num_hwpages=%lx i=%x",
+					     pginfo->kpage_cnt,
+					     pginfo->num_kpages,
+					     pginfo->hwpage_cnt,
+					     pginfo->num_hwpages, i);
+				return -EFAULT;
+			}
+			*kpage = phys_to_abs(
+				(pbuf->addr & EHCA_PAGEMASK)
+				+ (pginfo->next_hwpage * EHCA_PAGESIZE));
+			if ( !(*kpage) && pbuf->addr ) {
+				ehca_gen_err("pbuf->addr=%lx "
+					     "pbuf->size=%lx "
+					     "next_hwpage=%lx", pbuf->addr,
+					     pbuf->size,
+					     pginfo->next_hwpage);
+				return -EFAULT;
 			}
 			(pginfo->hwpage_cnt)++;
 			(pginfo->next_hwpage)++;
 			if (pginfo->next_hwpage %
-			    (PAGE_SIZE / EHCA_PAGESIZE) == 0) {
+			    (PAGE_SIZE / EHCA_PAGESIZE) == 0)
 				(pginfo->kpage_cnt)++;
-				(pginfo->u.usr.next_nmap)++;
-				pginfo->next_hwpage = 0;
-			}
-			if (pginfo->u.usr.next_nmap >= chunk->nmap) {
-				pginfo->u.usr.next_nmap = 0;
-				prev_chunk = chunk;
-			}
-			break;
+			kpage++;
+			i++;
+			if (i >= number) break;
 		}
-		pginfo->u.usr.next_chunk =
-			list_prepare_entry(prev_chunk,
-					   (&(pginfo->u.usr.region->chunk_list)),
-					   list);
-	} else if (pginfo->type == EHCA_MR_PGI_FMR) {
-		fmrlist = pginfo->u.fmr.page_list + pginfo->u.fmr.next_listelem;
-		*rpage = phys_to_abs((*fmrlist & EHCA_PAGEMASK) +
+		if (pginfo->next_hwpage >= offs_hw + num_hw) {
+			(pginfo->u.phy.next_buf)++;
+			pginfo->next_hwpage = 0;
+		}
+	}
+	return ret;
+}
+
+int ehca_set_pagebuf_fmr(struct ehca_mr_pginfo *pginfo,
+			 u32 number,
+			 u64 *kpage)
+{
+	int ret = 0;
+	u64 *fmrlist;
+	u32 i;
+
+	/* loop over desired page_list entries */
+	fmrlist = pginfo->u.fmr.page_list + pginfo->u.fmr.next_listelem;
+	for (i = 0; i < number; i++) {
+		*kpage = phys_to_abs((*fmrlist & EHCA_PAGEMASK) +
 				     pginfo->next_hwpage * EHCA_PAGESIZE);
-		if ( !(*rpage) ) {
+		if ( !(*kpage) ) {
 			ehca_gen_err("*fmrlist=%lx fmrlist=%p "
 				     "next_listelem=%lx next_hwpage=%lx",
-				     *fmrlist, fmrlist, pginfo->u.fmr.next_listelem,
+				     *fmrlist, fmrlist,
+				     pginfo->u.fmr.next_listelem,
 				     pginfo->next_hwpage);
-			ret = -EFAULT;
-			goto ehca_set_pagebuf_1_exit0;
+			return -EFAULT;
 		}
 		(pginfo->hwpage_cnt)++;
 		(pginfo->next_hwpage)++;
+		kpage++;
 		if (pginfo->next_hwpage %
-		    (e_mr->fmr_page_size / EHCA_PAGESIZE) == 0) {
+		    (pginfo->u.fmr.fmr_pgsize / EHCA_PAGESIZE) == 0) {
 			(pginfo->kpage_cnt)++;
 			(pginfo->u.fmr.next_listelem)++;
+			fmrlist++;
 			pginfo->next_hwpage = 0;
 		}
-	} else {
+	}
+	return ret;
+}
+
+/* setup page buffer from page info */
+int ehca_set_pagebuf(struct ehca_mr_pginfo *pginfo,
+		     u32 number,
+		     u64 *kpage)
+{
+	int ret;
+
+	switch (pginfo->type) {
+	case EHCA_MR_PGI_PHYS:
+		ret = ehca_set_pagebuf_phys(pginfo, number, kpage);
+		break;
+	case EHCA_MR_PGI_USER:
+		ret = ehca_set_pagebuf_user1(pginfo, number, kpage);
+		break;
+	case EHCA_MR_PGI_FMR:
+		ret = ehca_set_pagebuf_fmr(pginfo, number, kpage);
+		break;
+	default:
 		ehca_gen_err("bad pginfo->type=%x", pginfo->type);
 		ret = -EFAULT;
-		goto ehca_set_pagebuf_1_exit0;
+		break;
 	}
-
-ehca_set_pagebuf_1_exit0:
-	if (ret)
-		ehca_gen_err("ret=%x e_mr=%p pginfo=%p type=%x num_kpages=%lx "
-			     "num_hwpages=%lx next_buf=%lx next_hwpage=%lx rpage=%p "
-			     "kpage_cnt=%lx hwpage_cnt=%lx next_listelem=%lx "
-			     "region=%p next_chunk=%p next_nmap=%lx", ret, e_mr,
-			     pginfo, pginfo->type, pginfo->num_kpages,
-			     pginfo->num_hwpages, pginfo->u.phy.next_buf, pginfo->next_hwpage,
-			     rpage, pginfo->kpage_cnt, pginfo->hwpage_cnt,
-			     pginfo->u.fmr.next_listelem, pginfo->u.usr.region,
-			     pginfo->u.usr.next_chunk, pginfo->u.usr.next_nmap);
 	return ret;
-} /* end ehca_set_pagebuf_1() */
+} /* end ehca_set_pagebuf() */
 
 /*----------------------------------------------------------------------*/
 
-- 
1.5.2


