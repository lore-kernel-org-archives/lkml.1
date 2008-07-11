Return-Path: <linux-kernel-owner+w=401wt.eu-S1758552AbYGKLEG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758552AbYGKLEG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 07:04:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753554AbYGKLBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 07:01:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40435 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755824AbYGKLBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 07:01:41 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 09/18] [GFS2] Remove obsolete conversion deadlock avoidance code
Date: Fri, 11 Jul 2008 11:11:10 +0100
Message-Id: <12157711023743-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12157711013356-git-send-email-swhiteho@redhat.com>
References: <121577107950-git-send-email-swhiteho@redhat.com>
 <12157710872782-git-send-email-swhiteho@redhat.com>
 <1215771089769-git-send-email-swhiteho@redhat.com>
 <1215771091790-git-send-email-swhiteho@redhat.com>
 <12157710931623-git-send-email-swhiteho@redhat.com>
 <12157710954145-git-send-email-swhiteho@redhat.com>
 <12157710973601-git-send-email-swhiteho@redhat.com>
 <12157710983282-git-send-email-swhiteho@redhat.com>
 <12157711013356-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

This is only used by GFS1 so can be removed.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/locking/dlm/lock.c b/fs/gfs2/locking/dlm/lock.c
index 871ffc9..894df45 100644
--- a/fs/gfs2/locking/dlm/lock.c
+++ b/fs/gfs2/locking/dlm/lock.c
@@ -80,7 +80,6 @@ static void process_complete(struct gdlm_lock *lp)
 {
 	struct gdlm_ls *ls = lp->ls;
 	struct lm_async_cb acb;
-	s16 prev_mode = lp->cur;
 
 	memset(&acb, 0, sizeof(acb));
 
@@ -160,15 +159,7 @@ static void process_complete(struct gdlm_lock *lp)
 			 lp->lksb.sb_status, lp->lockname.ln_type,
 			 (unsigned long long)lp->lockname.ln_number,
 			 lp->flags);
-		if (lp->lksb.sb_status == -EDEADLOCK &&
-		    lp->ls->fsflags & LM_MFLAG_CONV_NODROP) {
-			lp->req = lp->cur;
-			acb.lc_ret |= LM_OUT_CONV_DEADLK;
-			if (lp->cur == DLM_LOCK_IV)
-				lp->lksb.sb_lkid = 0;
-			goto out;
-		} else
-			return;
+		return;
 	}
 
 	/*
@@ -268,10 +259,6 @@ out:
 	acb.lc_name = lp->lockname;
 	acb.lc_ret |= gdlm_make_lmstate(lp->cur);
 
-	if (!test_and_clear_bit(LFL_NOCACHE, &lp->flags) &&
-	    (lp->cur > DLM_LOCK_NL) && (prev_mode > DLM_LOCK_NL))
-		acb.lc_ret |= LM_OUT_CACHEABLE;
-
 	ls->fscb(ls->sdp, LM_CB_ASYNC, &acb);
 }
 
@@ -376,14 +363,6 @@ static inline unsigned int make_flags(struct gdlm_lock *lp,
 
 	if (lp->lksb.sb_lkid != 0) {
 		lkf |= DLM_LKF_CONVERT;
-
-		/* Conversion deadlock avoidance by DLM */
-
-		if (!(lp->ls->fsflags & LM_MFLAG_CONV_NODROP) &&
-		    !test_bit(LFL_FORCE_PROMOTE, &lp->flags) &&
-		    !(lkf & DLM_LKF_NOQUEUE) &&
-		    cur > DLM_LOCK_NL && req > DLM_LOCK_NL && cur != req)
-			lkf |= DLM_LKF_CONVDEADLK;
 	}
 
 	if (lp->lvb)
diff --git a/include/linux/lm_interface.h b/include/linux/lm_interface.h
index d0a7112..2ed8fa1 100644
--- a/include/linux/lm_interface.h
+++ b/include/linux/lm_interface.h
@@ -122,11 +122,9 @@ typedef void (*lm_callback_t) (void *ptr, unsigned int type, void *data);
  */
 
 #define LM_OUT_ST_MASK		0x00000003
-#define LM_OUT_CACHEABLE	0x00000004
 #define LM_OUT_CANCELED		0x00000008
 #define LM_OUT_ASYNC		0x00000080
 #define LM_OUT_ERROR		0x00000100
-#define LM_OUT_CONV_DEADLK	0x00000200
 
 /*
  * lm_callback_t types
-- 
1.5.1.2

