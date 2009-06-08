Return-Path: <linux-kernel-owner+w=401wt.eu-S1755116AbZFHRVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116AbZFHRVs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 13:21:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753883AbZFHRUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 13:20:15 -0400
Received: from relay1.sgi.com ([192.48.179.29]:57151 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753763AbZFHRUO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 13:20:14 -0400
Message-Id: <20090608172011.901427000@sgi.com>
User-Agent: quilt/0.47-1
Date: Mon, 08 Jun 2009 12:16:56 -0500
From: steiner@sgi.com
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [Patch 08/12] GRU - add user request to specify gru slice
References: <20090608171648.988318000@sgi.com>
Content-Disposition: inline; filename=uv_gru_request_slice
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

Add a user request to specify the gru instruction slice
parameter for user contexts.


Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 drivers/misc/sgi-gru/grufault.c  |    4 ++++
 drivers/misc/sgi-gru/grulib.h    |    2 +-
 drivers/misc/sgi-gru/grumain.c   |    7 +++++++
 drivers/misc/sgi-gru/grutables.h |    1 +
 4 files changed, 13 insertions(+), 1 deletion(-)

Index: linux/drivers/misc/sgi-gru/grufault.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grufault.c	2009-05-12 16:43:36.000000000 -0500
+++ linux/drivers/misc/sgi-gru/grufault.c	2009-05-12 16:48:53.000000000 -0500
@@ -773,6 +773,10 @@ int gru_set_context_option(unsigned long
  		/* Register the current task as the GSEG owner */
 		gts->ts_tgid_owner = current->tgid;
 		break;
+	case sco_cch_req_slice:
+ 		/* Set the CCH slice option */
+		gts->ts_cch_req_slice = req.val1 & 3;
+		break;
 	default:
 		ret = -EINVAL;
 	}
Index: linux/drivers/misc/sgi-gru/grulib.h
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grulib.h	2009-05-12 16:43:36.000000000 -0500
+++ linux/drivers/misc/sgi-gru/grulib.h	2009-05-12 16:48:53.000000000 -0500
@@ -98,7 +98,7 @@ struct gru_unload_context_req {
 /*
  * Structure used to set context options
  */
-enum {sco_gseg_owner};
+enum {sco_gseg_owner, sco_cch_req_slice};
 struct gru_set_context_option_req {
 	unsigned long	gseg;
 	int		op;
Index: linux/drivers/misc/sgi-gru/grumain.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grumain.c	2009-05-12 16:43:19.000000000 -0500
+++ linux/drivers/misc/sgi-gru/grumain.c	2009-05-12 16:48:53.000000000 -0500
@@ -321,6 +321,7 @@ struct gru_thread_state *gru_alloc_gts(s
 	gts->ts_tsid = tsid;
 	gts->ts_ctxnum = NULLCTX;
 	gts->ts_tlb_int_select = -1;
+	gts->ts_cch_req_slice = -1;
 	gts->ts_sizeavail = GRU_SIZEAVAIL(PAGE_SHIFT);
 	if (vma) {
 		gts->ts_mm = current->mm;
@@ -566,6 +567,12 @@ void gru_load_context(struct gru_thread_
 		gts->ts_tlb_int_select = gru_cpu_fault_map_id();
 		cch->tlb_int_select = gts->ts_tlb_int_select;
 	}
+	if (gts->ts_cch_req_slice >= 0) {
+		cch->req_slice_set_enable = 1;
+		cch->req_slice = gts->ts_cch_req_slice;
+	} else {
+		cch->req_slice_set_enable =0;
+	}
 	cch->tfm_done_bit_enable = 0;
 	cch->dsr_allocation_map = gts->ts_dsr_map;
 	cch->cbr_allocation_map = gts->ts_cbr_map;
Index: linux/drivers/misc/sgi-gru/grutables.h
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grutables.h	2009-05-12 16:43:36.000000000 -0500
+++ linux/drivers/misc/sgi-gru/grutables.h	2009-05-12 16:48:53.000000000 -0500
@@ -380,6 +380,7 @@ struct gru_thread_state {
 						   required for contest */
 	unsigned char		ts_cbr_au_count;/* Number of CBR resources
 						   required for contest */
+	char			ts_cch_req_slice;/* CCH packet slice */
 	char			ts_blade;	/* If >= 0, migrate context if
 						   ref from diferent blade */
 	char			ts_force_cch_reload;

