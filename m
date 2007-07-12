Return-Path: <linux-kernel-owner+w=401wt.eu-S934974AbXGLPul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934974AbXGLPul (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 11:50:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758339AbXGLPu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 11:50:26 -0400
Received: from mtagate1.uk.ibm.com ([195.212.29.134]:45227 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758147AbXGLPuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 11:50:22 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>
Subject: [PATCH 04/10] IB/ehca: use common error code mapping instead of specific ones
User-Agent: KMail/1.8.2
Cc: "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
References: <200707121745.27592.fenkes@de.ibm.com>
In-Reply-To: <200707121745.27592.fenkes@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 25418
Date: Thu, 12 Jul 2007 17:49:02 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200707121749.03556.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hoang-Nam Nguyen <hnguyen@de.ibm.com>

Instead of one error mapping function for each potential error source in
ehca_mrmw.c, use a centralized function that handles all cases, saving a
three-figure line count.

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_mrmw.c  |  195 ++-----------------------------
 drivers/infiniband/hw/ehca/ehca_mrmw.h  |   14 ---
 drivers/infiniband/hw/ehca/ehca_tools.h |    3 +
 3 files changed, 15 insertions(+), 197 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_mrmw.c b/drivers/infiniband/hw/ehca/ehca_mrmw.c
index 98f2531..7c1656a 100644
--- a/drivers/infiniband/hw/ehca/ehca_mrmw.c
+++ b/drivers/infiniband/hw/ehca/ehca_mrmw.c
@@ -537,7 +537,7 @@ int ehca_query_mr(struct ib_mr *mr, struct ib_mr_attr *mr_attr)
 			 "hca_hndl=%lx mr_hndl=%lx lkey=%x",
 			 h_ret, mr, shca->ipz_hca_handle.handle,
 			 e_mr->ipz_mr_handle.handle, mr->lkey);
-		ret = ehca_mrmw_map_hrc_query_mr(h_ret);
+		ret = ehca2ib_return_code(h_ret);
 		goto query_mr_exit1;
 	}
 	mr_attr->pd               = mr->pd;
@@ -597,7 +597,7 @@ int ehca_dereg_mr(struct ib_mr *mr)
 			 "e_mr=%p hca_hndl=%lx mr_hndl=%lx mr->lkey=%x",
 			 h_ret, shca, e_mr, shca->ipz_hca_handle.handle,
 			 e_mr->ipz_mr_handle.handle, mr->lkey);
-		ret = ehca_mrmw_map_hrc_free_mr(h_ret);
+		ret = ehca2ib_return_code(h_ret);
 		goto dereg_mr_exit0;
 	}
 
@@ -637,7 +637,7 @@ struct ib_mw *ehca_alloc_mw(struct ib_pd *pd)
 		ehca_err(pd->device, "hipz_mw_allocate failed, h_ret=%lx "
 			 "shca=%p hca_hndl=%lx mw=%p",
 			 h_ret, shca, shca->ipz_hca_handle.handle, e_mw);
-		ib_mw = ERR_PTR(ehca_mrmw_map_hrc_alloc(h_ret));
+		ib_mw = ERR_PTR(ehca2ib_return_code(h_ret));
 		goto alloc_mw_exit1;
 	}
 	/* successful MW allocation */
@@ -680,7 +680,7 @@ int ehca_dealloc_mw(struct ib_mw *mw)
 			 "mw=%p rkey=%x hca_hndl=%lx mw_hndl=%lx",
 			 h_ret, shca, mw, mw->rkey, shca->ipz_hca_handle.handle,
 			 e_mw->ipz_mw_handle.handle);
-		return ehca_mrmw_map_hrc_free_mw(h_ret);
+		return ehca2ib_return_code(h_ret);
 	}
 	/* successful deallocation */
 	ehca_mw_delete(e_mw);
@@ -923,7 +923,7 @@ int ehca_dealloc_fmr(struct ib_fmr *fmr)
 			 "hca_hndl=%lx fmr_hndl=%lx fmr->lkey=%x",
 			 h_ret, e_fmr, shca->ipz_hca_handle.handle,
 			 e_fmr->ipz_mr_handle.handle, fmr->lkey);
-		ret = ehca_mrmw_map_hrc_free_mr(h_ret);
+		ret = ehca2ib_return_code(h_ret);
 		goto free_fmr_exit0;
 	}
 	/* successful deregistration */
@@ -964,7 +964,7 @@ int ehca_reg_mr(struct ehca_shca *shca,
 	if (h_ret != H_SUCCESS) {
 		ehca_err(&shca->ib_device, "hipz_alloc_mr failed, h_ret=%lx "
 			 "hca_hndl=%lx", h_ret, shca->ipz_hca_handle.handle);
-		ret = ehca_mrmw_map_hrc_alloc(h_ret);
+		ret = ehca2ib_return_code(h_ret);
 		goto ehca_reg_mr_exit0;
 	}
 
@@ -1079,7 +1079,7 @@ int ehca_reg_mr_rpages(struct ehca_shca *shca,
 					 shca->ipz_hca_handle.handle,
 					 e_mr->ipz_mr_handle.handle,
 					 e_mr->ib.ib_mr.lkey);
-				ret = ehca_mrmw_map_hrc_rrpg_last(h_ret);
+				ret = ehca2ib_return_code(h_ret);
 				break;
 			} else
 				ret = 0;
@@ -1090,7 +1090,7 @@ int ehca_reg_mr_rpages(struct ehca_shca *shca,
 				 e_mr->ib.ib_mr.lkey,
 				 shca->ipz_hca_handle.handle,
 				 e_mr->ipz_mr_handle.handle);
-			ret = ehca_mrmw_map_hrc_rrpg_notlast(h_ret);
+			ret = ehca2ib_return_code(h_ret);
 			break;
 		} else
 			ret = 0;
@@ -1254,7 +1254,7 @@ int ehca_rereg_mr(struct ehca_shca *shca,
 				 h_ret, e_mr, shca->ipz_hca_handle.handle,
 				 e_mr->ipz_mr_handle.handle,
 				 e_mr->ib.ib_mr.lkey);
-			ret = ehca_mrmw_map_hrc_free_mr(h_ret);
+			ret = ehca2ib_return_code(h_ret);
 			goto ehca_rereg_mr_exit0;
 		}
 		/* clean ehca_mr_t, without changing struct ib_mr and lock */
@@ -1351,7 +1351,7 @@ int ehca_unmap_one_fmr(struct ehca_shca *shca,
 				 h_ret, e_fmr, shca->ipz_hca_handle.handle,
 				 e_fmr->ipz_mr_handle.handle,
 				 e_fmr->ib.ib_fmr.lkey);
-			ret = ehca_mrmw_map_hrc_free_mr(h_ret);
+			ret = ehca2ib_return_code(h_ret);
 			goto ehca_unmap_one_fmr_exit0;
 		}
 		/* clean ehca_mr_t, without changing lock */
@@ -1420,7 +1420,7 @@ int ehca_reg_smr(struct ehca_shca *shca,
 			 shca->ipz_hca_handle.handle,
 			 e_origmr->ipz_mr_handle.handle,
 			 e_origmr->ib.ib_mr.lkey);
-		ret = ehca_mrmw_map_hrc_reg_smr(h_ret);
+		ret = ehca2ib_return_code(h_ret);
 		goto ehca_reg_smr_exit0;
 	}
 	/* successful registration */
@@ -1539,7 +1539,7 @@ int ehca_reg_maxmr(struct ehca_shca *shca,
 			 h_ret, e_origmr, shca->ipz_hca_handle.handle,
 			 e_origmr->ipz_mr_handle.handle,
 			 e_origmr->ib.ib_mr.lkey);
-		return ehca_mrmw_map_hrc_reg_smr(h_ret);
+		return ehca2ib_return_code(h_ret);
 	}
 	/* successful registration */
 	e_newmr->num_pages     = e_origmr->num_pages;
@@ -2043,177 +2043,6 @@ void ehca_mrmw_reverse_map_acl(const u32 *hipz_acl,
 /*----------------------------------------------------------------------*/
 
 /*
- * map HIPZ rc to IB retcodes for MR/MW allocations
- * Used for hipz_mr_reg_alloc and hipz_mw_alloc.
- */
-int ehca_mrmw_map_hrc_alloc(const u64 hipz_rc)
-{
-	switch (hipz_rc) {
-	case H_SUCCESS:	             /* successful completion */
-		return 0;
-	case H_NOT_ENOUGH_RESOURCES: /* insufficient resources */
-	case H_CONSTRAINED:          /* resource constraint */
-	case H_NO_MEM:
-		return -ENOMEM;
-	case H_BUSY:                 /* long busy */
-		return -EBUSY;
-	default:
-		return -EINVAL;
-	}
-} /* end ehca_mrmw_map_hrc_alloc() */
-
-/*----------------------------------------------------------------------*/
-
-/*
- * map HIPZ rc to IB retcodes for MR register rpage
- * Used for hipz_h_register_rpage_mr at registering last page
- */
-int ehca_mrmw_map_hrc_rrpg_last(const u64 hipz_rc)
-{
-	switch (hipz_rc) {
-	case H_SUCCESS:         /* registration complete */
-		return 0;
-	case H_PAGE_REGISTERED:	/* page registered */
-	case H_ADAPTER_PARM:    /* invalid adapter handle */
-	case H_RH_PARM:         /* invalid resource handle */
-/*	case H_QT_PARM:            invalid queue type */
-	case H_PARAMETER:       /*
-				 * invalid logical address,
-				 * or count zero or greater 512
-				 */
-	case H_TABLE_FULL:      /* page table full */
-	case H_HARDWARE:        /* HCA not operational */
-		return -EINVAL;
-	case H_BUSY:            /* long busy */
-		return -EBUSY;
-	default:
-		return -EINVAL;
-	}
-} /* end ehca_mrmw_map_hrc_rrpg_last() */
-
-/*----------------------------------------------------------------------*/
-
-/*
- * map HIPZ rc to IB retcodes for MR register rpage
- * Used for hipz_h_register_rpage_mr at registering one page, but not last page
- */
-int ehca_mrmw_map_hrc_rrpg_notlast(const u64 hipz_rc)
-{
-	switch (hipz_rc) {
-	case H_PAGE_REGISTERED:	/* page registered */
-		return 0;
-	case H_SUCCESS:         /* registration complete */
-	case H_ADAPTER_PARM:    /* invalid adapter handle */
-	case H_RH_PARM:         /* invalid resource handle */
-/*	case H_QT_PARM:            invalid queue type */
-	case H_PARAMETER:       /*
-				 * invalid logical address,
-				 * or count zero or greater 512
-				 */
-	case H_TABLE_FULL:      /* page table full */
-	case H_HARDWARE:        /* HCA not operational */
-		return -EINVAL;
-	case H_BUSY:            /* long busy */
-		return -EBUSY;
-	default:
-		return -EINVAL;
-	}
-} /* end ehca_mrmw_map_hrc_rrpg_notlast() */
-
-/*----------------------------------------------------------------------*/
-
-/* map HIPZ rc to IB retcodes for MR query. Used for hipz_mr_query. */
-int ehca_mrmw_map_hrc_query_mr(const u64 hipz_rc)
-{
-	switch (hipz_rc) {
-	case H_SUCCESS:	             /* successful completion */
-		return 0;
-	case H_ADAPTER_PARM:         /* invalid adapter handle */
-	case H_RH_PARM:              /* invalid resource handle */
-		return -EINVAL;
-	case H_BUSY:                 /* long busy */
-		return -EBUSY;
-	default:
-		return -EINVAL;
-	}
-} /* end ehca_mrmw_map_hrc_query_mr() */
-
-/*----------------------------------------------------------------------*/
-/*----------------------------------------------------------------------*/
-
-/*
- * map HIPZ rc to IB retcodes for freeing MR resource
- * Used for hipz_h_free_resource_mr
- */
-int ehca_mrmw_map_hrc_free_mr(const u64 hipz_rc)
-{
-	switch (hipz_rc) {
-	case H_SUCCESS:      /* resource freed */
-		return 0;
-	case H_ADAPTER_PARM: /* invalid adapter handle */
-	case H_RH_PARM:      /* invalid resource handle */
-	case H_R_STATE:      /* invalid resource state */
-	case H_HARDWARE:     /* HCA not operational */
-		return -EINVAL;
-	case H_RESOURCE:     /* Resource in use */
-	case H_BUSY:         /* long busy */
-		return -EBUSY;
-	default:
-		return -EINVAL;
-	}
-} /* end ehca_mrmw_map_hrc_free_mr() */
-
-/*----------------------------------------------------------------------*/
-
-/*
- * map HIPZ rc to IB retcodes for freeing MW resource
- * Used for hipz_h_free_resource_mw
- */
-int ehca_mrmw_map_hrc_free_mw(const u64 hipz_rc)
-{
-	switch (hipz_rc) {
-	case H_SUCCESS:	     /* resource freed */
-		return 0;
-	case H_ADAPTER_PARM: /* invalid adapter handle */
-	case H_RH_PARM:      /* invalid resource handle */
-	case H_R_STATE:      /* invalid resource state */
-	case H_HARDWARE:     /* HCA not operational */
-		return -EINVAL;
-	case H_RESOURCE:     /* Resource in use */
-	case H_BUSY:         /* long busy */
-		return -EBUSY;
-	default:
-		return -EINVAL;
-	}
-} /* end ehca_mrmw_map_hrc_free_mw() */
-
-/*----------------------------------------------------------------------*/
-
-/*
- * map HIPZ rc to IB retcodes for SMR registrations
- * Used for hipz_h_register_smr.
- */
-int ehca_mrmw_map_hrc_reg_smr(const u64 hipz_rc)
-{
-	switch (hipz_rc) {
-	case H_SUCCESS:	             /* successful completion */
-		return 0;
-	case H_ADAPTER_PARM:         /* invalid adapter handle */
-	case H_RH_PARM:              /* invalid resource handle */
-	case H_MEM_PARM:             /* invalid MR virtual address */
-	case H_MEM_ACCESS_PARM:      /* invalid access controls */
-	case H_NOT_ENOUGH_RESOURCES: /* insufficient resources */
-		return -EINVAL;
-	case H_BUSY:                 /* long busy */
-		return -EBUSY;
-	default:
-		return -EINVAL;
-	}
-} /* end ehca_mrmw_map_hrc_reg_smr() */
-
-/*----------------------------------------------------------------------*/
-
-/*
  * MR destructor and constructor
  * used in Reregister MR verb, sets all fields in ehca_mr_t to 0,
  * except struct ib_mr and spinlock
diff --git a/drivers/infiniband/hw/ehca/ehca_mrmw.h b/drivers/infiniband/hw/ehca/ehca_mrmw.h
index d936e40..fb69ede 100644
--- a/drivers/infiniband/hw/ehca/ehca_mrmw.h
+++ b/drivers/infiniband/hw/ehca/ehca_mrmw.h
@@ -121,20 +121,6 @@ void ehca_mrmw_set_pgsize_hipz_acl(u32 *hipz_acl);
 void ehca_mrmw_reverse_map_acl(const u32 *hipz_acl,
 			       int *ib_acl);
 
-int ehca_mrmw_map_hrc_alloc(const u64 hipz_rc);
-
-int ehca_mrmw_map_hrc_rrpg_last(const u64 hipz_rc);
-
-int ehca_mrmw_map_hrc_rrpg_notlast(const u64 hipz_rc);
-
-int ehca_mrmw_map_hrc_query_mr(const u64 hipz_rc);
-
-int ehca_mrmw_map_hrc_free_mr(const u64 hipz_rc);
-
-int ehca_mrmw_map_hrc_free_mw(const u64 hipz_rc);
-
-int ehca_mrmw_map_hrc_reg_smr(const u64 hipz_rc);
-
 void ehca_mr_deletenew(struct ehca_mr *mr);
 
 #endif  /*_EHCA_MRMW_H_*/
diff --git a/drivers/infiniband/hw/ehca/ehca_tools.h b/drivers/infiniband/hw/ehca/ehca_tools.h
index 03b185f..fd8238b 100644
--- a/drivers/infiniband/hw/ehca/ehca_tools.h
+++ b/drivers/infiniband/hw/ehca/ehca_tools.h
@@ -161,8 +161,11 @@ static inline int ehca2ib_return_code(u64 ehca_rc)
 	switch (ehca_rc) {
 	case H_SUCCESS:
 		return 0;
+	case H_RESOURCE:             /* Resource in use */
 	case H_BUSY:
 		return -EBUSY;
+	case H_NOT_ENOUGH_RESOURCES: /* insufficient resources */
+	case H_CONSTRAINED:          /* resource constraint */
 	case H_NO_MEM:
 		return -ENOMEM;
 	default:
-- 
1.5.2


