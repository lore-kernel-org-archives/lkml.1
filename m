Return-Path: <linux-kernel-owner+w=401wt.eu-S933392AbZKXPNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933392AbZKXPNR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 10:13:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933162AbZKXPNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 10:13:13 -0500
Received: from relay1.sgi.com ([192.48.179.29]:57690 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933225AbZKXPHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 10:07:45 -0500
Message-Id: <20091124150750.922633000@sgi.com>
User-Agent: quilt/0.47-1
Date: Tue, 24 Nov 2009 09:06:02 -0600
From: steiner@sgi.com
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [Patch 05/29] GRU - allow users to specify gru chiplet 1
References: <20091124150557.082648000@sgi.com>
Content-Disposition: inline; filename=uv_gru_user_blade_chiplet_1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

Add table & user request infrastructure that is needed to
allow users to specify the blade and chiplet for allocation of
GRU contexts. Use of this information is in a subsequent
patch.

Signed-off-by: Jack Steiner <steiner@sgi.com>


---
 drivers/misc/sgi-gru/grufault.c  |   10 ++++++++++
 drivers/misc/sgi-gru/grulib.h    |    5 +++--
 drivers/misc/sgi-gru/grumain.c   |    2 ++
 drivers/misc/sgi-gru/grutables.h |    2 ++
 4 files changed, 17 insertions(+), 2 deletions(-)

Index: linux/drivers/misc/sgi-gru/grufault.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grufault.c	2009-11-20 09:32:27.000000000 -0600
+++ linux/drivers/misc/sgi-gru/grufault.c	2009-11-20 09:32:28.000000000 -0600
@@ -763,6 +763,16 @@ int gru_set_context_option(unsigned long
 		return -EINVAL;
 
 	switch (req.op) {
+	case sco_blade_chiplet:
+		/* Select blade/chiplet for GRU context */
+		if (req.val1 < -1 || req.val1 >= GRU_MAX_BLADES || !gru_base[req.val1] ||
+		    req.val0 < -1 || req.val0 >= GRU_CHIPLETS_PER_HUB) {
+			ret = -EINVAL;
+		} else {
+			gts->ts_user_blade_id = req.val1;
+			gts->ts_user_chiplet_id = req.val0;
+		}
+		break;
 	case sco_gseg_owner:
  		/* Register the current task as the GSEG owner */
 		gts->ts_tgid_owner = current->tgid;
Index: linux/drivers/misc/sgi-gru/grulib.h
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grulib.h	2009-11-20 09:32:15.000000000 -0600
+++ linux/drivers/misc/sgi-gru/grulib.h	2009-11-20 09:32:28.000000000 -0600
@@ -98,11 +98,12 @@ struct gru_unload_context_req {
 /*
  * Structure used to set context options
  */
-enum {sco_gseg_owner, sco_cch_req_slice};
+enum {sco_gseg_owner, sco_cch_req_slice, sco_blade_chiplet};
 struct gru_set_context_option_req {
 	unsigned long	gseg;
 	int		op;
-	unsigned long	val1;
+	int		val0;
+	long		val1;
 };
 
 /*
Index: linux/drivers/misc/sgi-gru/grumain.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grumain.c	2009-11-20 09:32:15.000000000 -0600
+++ linux/drivers/misc/sgi-gru/grumain.c	2009-11-20 09:32:28.000000000 -0600
@@ -328,6 +328,8 @@ struct gru_thread_state *gru_alloc_gts(s
 	gts->ts_cbr_au_count = cbr_au_count;
 	gts->ts_dsr_au_count = dsr_au_count;
 	gts->ts_user_options = options;
+	gts->ts_user_blade_id = -1;
+	gts->ts_user_chiplet_id = -1;
 	gts->ts_tsid = tsid;
 	gts->ts_ctxnum = NULLCTX;
 	gts->ts_tlb_int_select = -1;
Index: linux/drivers/misc/sgi-gru/grutables.h
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grutables.h	2009-11-20 09:32:25.000000000 -0600
+++ linux/drivers/misc/sgi-gru/grutables.h	2009-11-20 09:32:28.000000000 -0600
@@ -369,6 +369,8 @@ struct gru_thread_state {
 	long			ts_user_options;/* misc user option flags */
 	pid_t			ts_tgid_owner;	/* task that is using the
 						   context - for migration */
+	short			ts_user_blade_id;/* user selected blade */
+	char			ts_user_chiplet_id;/* user selected chiplet */
 	unsigned short		ts_sizeavail;	/* Pagesizes in use */
 	int			ts_tsid;	/* thread that owns the
 						   structure */

