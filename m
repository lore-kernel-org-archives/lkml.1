Return-Path: <linux-kernel-owner+w=401wt.eu-S1759975AbXGIQaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759975AbXGIQaA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 12:30:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758095AbXGIQXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 12:23:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42022 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758044AbXGIQXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 12:23:47 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com, David Teigland <teigland@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH] [DLM] timeout fixes
Date: Mon,  9 Jul 2007 17:02:26 +0100
Message-Id: <11839970302426-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11839970282009-git-send-email-swhiteho@redhat.com>
References: <11839969822277-git-send-email-swhiteho@redhat.com>
 <1183996989263-git-send-email-swhiteho@redhat.com>
 <11839969911617-git-send-email-swhiteho@redhat.com>
 <1183996996300-git-send-email-swhiteho@redhat.com>
 <11839969982134-git-send-email-swhiteho@redhat.com>
 <11839970003764-git-send-email-swhiteho@redhat.com>
 <11839970032102-git-send-email-swhiteho@redhat.com>
 <11839970052865-git-send-email-swhiteho@redhat.com>
 <11839970061096-git-send-email-swhiteho@redhat.com>
 <1183997008395-git-send-email-swhiteho@redhat.com>
 <11839970101065-git-send-email-swhiteho@redhat.com>
 <11839970122624-git-send-email-swhiteho@redhat.com>
 <11839970143164-git-send-email-swhiteho@redhat.com>
 <11839970162125-git-send-email-swhiteho@redhat.com>
 <11839970182635-git-send-email-swhiteho@redhat.com>
 <11839970204036-git-send-email-swhiteho@redhat.com>
 <11839970222606-git-send-email-swhiteho@redhat.com>
 <11839970241526-git-send-email-swhiteho@redhat.com>
 <1183997026104-git-send-email-swhiteho@redhat.com>
 <11839970282009-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Teigland <teigland@redhat.com>

Various fixes related to the new timeout feature:
- add_timeout() missed setting TIMEWARN flag on lkb's when the
  TIMEOUT flag was already set
- clear_proc_locks should remove a dead process's locks from the
  timeout list
- the end-of-life calculation for user locks needs to consider that
  ETIMEDOUT is equivalent to -DLM_ECANCEL
- make initial default timewarn_cs config value visible in configfs
- change bit position of TIMEOUT_CANCEL flag so it's not copied to
  a remote master node
- set timestamp on remote lkb's so a lock dump will display the time
  they've been waiting

Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/dlm/config.c b/fs/dlm/config.c
index 2909abf..1b59fa5 100644
--- a/fs/dlm/config.c
+++ b/fs/dlm/config.c
@@ -433,6 +433,7 @@ static struct config_group *make_cluster(struct config_group *g,
 	cl->cl_toss_secs = dlm_config.ci_toss_secs;
 	cl->cl_scan_secs = dlm_config.ci_scan_secs;
 	cl->cl_log_debug = dlm_config.ci_log_debug;
+	cl->cl_timewarn_cs = dlm_config.ci_timewarn_cs;
 
 	space_list = &sps->ss_group;
 	comm_list = &cms->cs_group;
diff --git a/fs/dlm/dlm_internal.h b/fs/dlm/dlm_internal.h
index 03ba6c4..a7435a8 100644
--- a/fs/dlm/dlm_internal.h
+++ b/fs/dlm/dlm_internal.h
@@ -215,9 +215,9 @@ struct dlm_args {
 #define DLM_IFL_OVERLAP_CANCEL  0x00100000
 #define DLM_IFL_ENDOFLIFE	0x00200000
 #define DLM_IFL_WATCH_TIMEWARN	0x00400000
+#define DLM_IFL_TIMEOUT_CANCEL	0x00800000
 #define DLM_IFL_USER		0x00000001
 #define DLM_IFL_ORPHAN		0x00000002
-#define DLM_IFL_TIMEOUT_CANCEL	0x00000004
 
 struct dlm_lkb {
 	struct dlm_rsb		*lkb_resource;	/* the rsb */
diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index 2f8a5a7..df91578 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -1010,17 +1010,18 @@ static void add_timeout(struct dlm_lkb *lkb)
 {
 	struct dlm_ls *ls = lkb->lkb_resource->res_ls;
 
-	if (is_master_copy(lkb))
+	if (is_master_copy(lkb)) {
+		lkb->lkb_timestamp = jiffies;
 		return;
-
-	if (lkb->lkb_exflags & DLM_LKF_TIMEOUT)
-		goto add_it;
+	}
 
 	if (test_bit(LSFL_TIMEWARN, &ls->ls_flags) &&
 	    !(lkb->lkb_exflags & DLM_LKF_NODLCKWT)) {
 		lkb->lkb_flags |= DLM_IFL_WATCH_TIMEWARN;
 		goto add_it;
 	}
+	if (lkb->lkb_exflags & DLM_LKF_TIMEOUT)
+		goto add_it;
 	return;
 
  add_it:
@@ -3510,8 +3511,7 @@ static void _receive_cancel_reply(struct dlm_lkb *lkb, struct dlm_message *ms)
 	case -DLM_ECANCEL:
 		receive_flags_reply(lkb, ms);
 		revert_lock_pc(r, lkb);
-		if (ms->m_result)
-			queue_cast(r, lkb, -DLM_ECANCEL);
+		queue_cast(r, lkb, -DLM_ECANCEL);
 		break;
 	case 0:
 		break;
@@ -4534,6 +4534,7 @@ void dlm_clear_proc_locks(struct dlm_ls *ls, struct dlm_user_proc *proc)
 		lkb = del_proc_lock(ls, proc);
 		if (!lkb)
 			break;
+		del_timeout(lkb);
 		if (lkb->lkb_exflags & DLM_LKF_PERSISTENT)
 			orphan_proc_lock(ls, lkb);
 		else
diff --git a/fs/dlm/netlink.c b/fs/dlm/netlink.c
index 804b32c..863b87d 100644
--- a/fs/dlm/netlink.c
+++ b/fs/dlm/netlink.c
@@ -133,8 +133,6 @@ void dlm_timeout_warn(struct dlm_lkb *lkb)
 	size_t size;
 	int rv;
 
-	log_debug(lkb->lkb_resource->res_ls, "timeout_warn %x", lkb->lkb_id);
-
 	size = nla_total_size(sizeof(struct dlm_lock_data)) +
 	       nla_total_size(0); /* why this? */
 
diff --git a/fs/dlm/user.c b/fs/dlm/user.c
index 37aad3f..329da1b 100644
--- a/fs/dlm/user.c
+++ b/fs/dlm/user.c
@@ -138,6 +138,35 @@ static void compat_output(struct dlm_lock_result *res,
 }
 #endif
 
+/* Figure out if this lock is at the end of its life and no longer
+   available for the application to use.  The lkb still exists until
+   the final ast is read.  A lock becomes EOL in three situations:
+     1. a noqueue request fails with EAGAIN
+     2. an unlock completes with EUNLOCK
+     3. a cancel of a waiting request completes with ECANCEL/EDEADLK
+   An EOL lock needs to be removed from the process's list of locks.
+   And we can't allow any new operation on an EOL lock.  This is
+   not related to the lifetime of the lkb struct which is managed
+   entirely by refcount. */
+
+static int lkb_is_endoflife(struct dlm_lkb *lkb, int sb_status, int type)
+{
+	switch (sb_status) {
+	case -DLM_EUNLOCK:
+		return 1;
+	case -DLM_ECANCEL:
+	case -ETIMEDOUT:
+		if (lkb->lkb_grmode == DLM_LOCK_IV)
+			return 1;
+		break;
+	case -EAGAIN:
+		if (type == AST_COMP && lkb->lkb_grmode == DLM_LOCK_IV)
+			return 1;
+		break;
+	}
+	return 0;
+}
+
 /* we could possibly check if the cancel of an orphan has resulted in the lkb
    being removed and then remove that lkb from the orphans list and free it */
 
@@ -184,25 +213,7 @@ void dlm_user_add_ast(struct dlm_lkb *lkb, int type)
 		log_debug(ls, "ast overlap %x status %x %x",
 			  lkb->lkb_id, ua->lksb.sb_status, lkb->lkb_flags);
 
-	/* Figure out if this lock is at the end of its life and no longer
-	   available for the application to use.  The lkb still exists until
-	   the final ast is read.  A lock becomes EOL in three situations:
-	     1. a noqueue request fails with EAGAIN
-	     2. an unlock completes with EUNLOCK
-	     3. a cancel of a waiting request completes with ECANCEL
-	   An EOL lock needs to be removed from the process's list of locks.
-	   And we can't allow any new operation on an EOL lock.  This is
-	   not related to the lifetime of the lkb struct which is managed
-	   entirely by refcount. */
-
-	if (type == AST_COMP &&
-	    lkb->lkb_grmode == DLM_LOCK_IV &&
-	    ua->lksb.sb_status == -EAGAIN)
-		eol = 1;
-	else if (ua->lksb.sb_status == -DLM_EUNLOCK ||
-	    (ua->lksb.sb_status == -DLM_ECANCEL &&
-	     lkb->lkb_grmode == DLM_LOCK_IV))
-		eol = 1;
+	eol = lkb_is_endoflife(lkb, ua->lksb.sb_status, type);
 	if (eol) {
 		lkb->lkb_ast_type &= ~AST_BAST;
 		lkb->lkb_flags |= DLM_IFL_ENDOFLIFE;
-- 
1.5.1.2

