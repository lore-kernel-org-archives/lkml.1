Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965857Ab0BZTRv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 14:17:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36259 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965829Ab0BZTRr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 14:17:47 -0500
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] dlm: fix ordering of bast and cast
Date: Fri, 26 Feb 2010 13:17:41 -0600
Message-Id: <1267211864-5474-2-git-send-email-teigland@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When both blocking and completion callbacks are queued for lock,
the dlm would always deliver the completion callback (cast) first.
In some cases the blocking callback (bast) is queued before the
cast, though, and should be delivered first.  This patch keeps
track of the order in which they were queued and delivers them
in that order.

This patch also keeps track of the granted mode in the last cast
and eliminates the following bast if the bast mode is compatible
with the preceding cast mode.  This happens when a remotely mastered
lock is demoted, e.g. EX->NL, in which case the local node queues
a cast immediately after sending the demote message.  In this way
a cast can be queued for a mode, e.g. NL, that makes an in-transit
bast extraneous.

Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/ast.c          |   74 ++++++++++++++++++++++++++++++++++++++----------
 fs/dlm/ast.h          |    4 +-
 fs/dlm/dlm_internal.h |   10 +++++-
 fs/dlm/lock.c         |    4 +-
 fs/dlm/user.c         |   10 ++++--
 fs/dlm/user.h         |    4 +-
 6 files changed, 78 insertions(+), 28 deletions(-)

diff --git a/fs/dlm/ast.c b/fs/dlm/ast.c
index dc2ad60..4314f0d 100644
--- a/fs/dlm/ast.c
+++ b/fs/dlm/ast.c
@@ -2,7 +2,7 @@
 *******************************************************************************
 **
 **  Copyright (C) Sistina Software, Inc.  1997-2003  All rights reserved.
-**  Copyright (C) 2004-2008 Red Hat, Inc.  All rights reserved.
+**  Copyright (C) 2004-2010 Red Hat, Inc.  All rights reserved.
 **
 **  This copyrighted material is made available to anyone wishing to use,
 **  modify, copy, or redistribute it subject to the terms and conditions
@@ -33,10 +33,10 @@ void dlm_del_ast(struct dlm_lkb *lkb)
 	spin_unlock(&ast_queue_lock);
 }
 
-void dlm_add_ast(struct dlm_lkb *lkb, int type, int bastmode)
+void dlm_add_ast(struct dlm_lkb *lkb, int type, int mode)
 {
 	if (lkb->lkb_flags & DLM_IFL_USER) {
-		dlm_user_add_ast(lkb, type, bastmode);
+		dlm_user_add_ast(lkb, type, mode);
 		return;
 	}
 
@@ -44,10 +44,21 @@ void dlm_add_ast(struct dlm_lkb *lkb, int type, int bastmode)
 	if (!(lkb->lkb_ast_type & (AST_COMP | AST_BAST))) {
 		kref_get(&lkb->lkb_ref);
 		list_add_tail(&lkb->lkb_astqueue, &ast_queue);
+		lkb->lkb_ast_first = type;
 	}
+
+	/* sanity check, this should not happen */
+
+	if ((type == AST_COMP) && (lkb->lkb_ast_type & AST_COMP))
+		log_print("repeat cast %d castmode %d lock %x %s",
+			  mode, lkb->lkb_castmode,
+			  lkb->lkb_id, lkb->lkb_resource->res_name);
+
 	lkb->lkb_ast_type |= type;
-	if (bastmode)
-		lkb->lkb_bastmode = bastmode;
+	if (type == AST_BAST)
+		lkb->lkb_bastmode = mode;
+	else
+		lkb->lkb_castmode = mode;
 	spin_unlock(&ast_queue_lock);
 
 	set_bit(WAKE_ASTS, &astd_wakeflags);
@@ -59,9 +70,9 @@ static void process_asts(void)
 	struct dlm_ls *ls = NULL;
 	struct dlm_rsb *r = NULL;
 	struct dlm_lkb *lkb;
-	void (*cast) (void *astparam);
-	void (*bast) (void *astparam, int mode);
-	int type = 0, bastmode;
+	void (*castfn) (void *astparam);
+	void (*bastfn) (void *astparam, int mode);
+	int type, first, bastmode, castmode, do_bast, do_cast, last_castmode;
 
 repeat:
 	spin_lock(&ast_queue_lock);
@@ -75,17 +86,48 @@ repeat:
 		list_del(&lkb->lkb_astqueue);
 		type = lkb->lkb_ast_type;
 		lkb->lkb_ast_type = 0;
+		first = lkb->lkb_ast_first;
+		lkb->lkb_ast_first = 0;
 		bastmode = lkb->lkb_bastmode;
-
+		castmode = lkb->lkb_castmode;
+		castfn = lkb->lkb_astfn;
+		bastfn = lkb->lkb_bastfn;
 		spin_unlock(&ast_queue_lock);
-		cast = lkb->lkb_astfn;
-		bast = lkb->lkb_bastfn;
-
-		if ((type & AST_COMP) && cast)
-			cast(lkb->lkb_astparam);
 
-		if ((type & AST_BAST) && bast)
-			bast(lkb->lkb_astparam, bastmode);
+		do_cast = (type & AST_COMP) && castfn;
+		do_bast = (type & AST_BAST) && bastfn;
+
+		/* Skip a bast if its blocking mode is compatible with the
+		   granted mode of the preceding cast. */
+
+		if (do_bast) {
+			if (first == AST_COMP)
+				last_castmode = castmode;
+			else
+				last_castmode = lkb->lkb_castmode_done;
+			if (dlm_modes_compat(bastmode, last_castmode))
+				do_bast = 0;
+		}
+
+		if (first == AST_COMP) {
+			if (do_cast)
+				castfn(lkb->lkb_astparam);
+			if (do_bast)
+				bastfn(lkb->lkb_astparam, bastmode);
+		} else if (first == AST_BAST) {
+			if (do_bast)
+				bastfn(lkb->lkb_astparam, bastmode);
+			if (do_cast)
+				castfn(lkb->lkb_astparam);
+		} else {
+			log_error(ls, "bad ast_first %d ast_type %d",
+				  first, type);
+		}
+
+		if (do_cast)
+			lkb->lkb_castmode_done = castmode;
+		if (do_bast)
+			lkb->lkb_bastmode_done = bastmode;
 
 		/* this removes the reference added by dlm_add_ast
 		   and may result in the lkb being freed */
diff --git a/fs/dlm/ast.h b/fs/dlm/ast.h
index 1b5fc5f..bcb1aab 100644
--- a/fs/dlm/ast.h
+++ b/fs/dlm/ast.h
@@ -1,7 +1,7 @@
 /******************************************************************************
 *******************************************************************************
 **
-**  Copyright (C) 2005-2008 Red Hat, Inc.  All rights reserved.
+**  Copyright (C) 2005-2010 Red Hat, Inc.  All rights reserved.
 **
 **  This copyrighted material is made available to anyone wishing to use,
 **  modify, copy, or redistribute it subject to the terms and conditions
@@ -13,7 +13,7 @@
 #ifndef __ASTD_DOT_H__
 #define __ASTD_DOT_H__
 
-void dlm_add_ast(struct dlm_lkb *lkb, int type, int bastmode);
+void dlm_add_ast(struct dlm_lkb *lkb, int type, int mode);
 void dlm_del_ast(struct dlm_lkb *lkb);
 
 void dlm_astd_wake(void);
diff --git a/fs/dlm/dlm_internal.h b/fs/dlm/dlm_internal.h
index 826d3dc..f632b58 100644
--- a/fs/dlm/dlm_internal.h
+++ b/fs/dlm/dlm_internal.h
@@ -2,7 +2,7 @@
 *******************************************************************************
 **
 **  Copyright (C) Sistina Software, Inc.  1997-2003  All rights reserved.
-**  Copyright (C) 2004-2008 Red Hat, Inc.  All rights reserved.
+**  Copyright (C) 2004-2010 Red Hat, Inc.  All rights reserved.
 **
 **  This copyrighted material is made available to anyone wishing to use,
 **  modify, copy, or redistribute it subject to the terms and conditions
@@ -232,11 +232,17 @@ struct dlm_lkb {
 	int8_t			lkb_status;     /* granted, waiting, convert */
 	int8_t			lkb_rqmode;	/* requested lock mode */
 	int8_t			lkb_grmode;	/* granted lock mode */
-	int8_t			lkb_bastmode;	/* requested mode */
 	int8_t			lkb_highbast;	/* highest mode bast sent for */
+
 	int8_t			lkb_wait_type;	/* type of reply waiting for */
 	int8_t			lkb_wait_count;
 	int8_t			lkb_ast_type;	/* type of ast queued for */
+	int8_t			lkb_ast_first;	/* type of first ast queued */
+
+	int8_t			lkb_bastmode;	/* req mode of queued bast */
+	int8_t			lkb_castmode;	/* gr mode of queued cast */
+	int8_t			lkb_bastmode_done; /* last delivered bastmode */
+	int8_t			lkb_castmode_done; /* last delivered castmode */
 
 	struct list_head	lkb_idtbl_list;	/* lockspace lkbtbl */
 	struct list_head	lkb_statequeue;	/* rsb g/c/w list */
diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index 9c0c1db..e08ea93 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -1,7 +1,7 @@
 /******************************************************************************
 *******************************************************************************
 **
-**  Copyright (C) 2005-2008 Red Hat, Inc.  All rights reserved.
+**  Copyright (C) 2005-2010 Red Hat, Inc.  All rights reserved.
 **
 **  This copyrighted material is made available to anyone wishing to use,
 **  modify, copy, or redistribute it subject to the terms and conditions
@@ -307,7 +307,7 @@ static void queue_cast(struct dlm_rsb *r, struct dlm_lkb *lkb, int rv)
 	lkb->lkb_lksb->sb_status = rv;
 	lkb->lkb_lksb->sb_flags = lkb->lkb_sbflags;
 
-	dlm_add_ast(lkb, AST_COMP, 0);
+	dlm_add_ast(lkb, AST_COMP, lkb->lkb_grmode);
 }
 
 static inline void queue_cast_overlap(struct dlm_rsb *r, struct dlm_lkb *lkb)
diff --git a/fs/dlm/user.c b/fs/dlm/user.c
index e73a4bb..a4bfd31 100644
--- a/fs/dlm/user.c
+++ b/fs/dlm/user.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2006-2009 Red Hat, Inc.  All rights reserved.
+ * Copyright (C) 2006-2010 Red Hat, Inc.  All rights reserved.
  *
  * This copyrighted material is made available to anyone wishing to use,
  * modify, copy, or redistribute it subject to the terms and conditions
@@ -173,7 +173,7 @@ static int lkb_is_endoflife(struct dlm_lkb *lkb, int sb_status, int type)
 /* we could possibly check if the cancel of an orphan has resulted in the lkb
    being removed and then remove that lkb from the orphans list and free it */
 
-void dlm_user_add_ast(struct dlm_lkb *lkb, int type, int bastmode)
+void dlm_user_add_ast(struct dlm_lkb *lkb, int type, int mode)
 {
 	struct dlm_ls *ls;
 	struct dlm_user_args *ua;
@@ -206,8 +206,10 @@ void dlm_user_add_ast(struct dlm_lkb *lkb, int type, int bastmode)
 
 	ast_type = lkb->lkb_ast_type;
 	lkb->lkb_ast_type |= type;
-	if (bastmode)
-		lkb->lkb_bastmode = bastmode;
+	if (type == AST_BAST)
+		lkb->lkb_bastmode = mode;
+	else
+		lkb->lkb_castmode = mode;
 
 	if (!ast_type) {
 		kref_get(&lkb->lkb_ref);
diff --git a/fs/dlm/user.h b/fs/dlm/user.h
index 1c96864..f196091 100644
--- a/fs/dlm/user.h
+++ b/fs/dlm/user.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2006-2008 Red Hat, Inc.  All rights reserved.
+ * Copyright (C) 2006-2010 Red Hat, Inc.  All rights reserved.
  *
  * This copyrighted material is made available to anyone wishing to use,
  * modify, copy, or redistribute it subject to the terms and conditions
@@ -9,7 +9,7 @@
 #ifndef __USER_DOT_H__
 #define __USER_DOT_H__
 
-void dlm_user_add_ast(struct dlm_lkb *lkb, int type, int bastmode);
+void dlm_user_add_ast(struct dlm_lkb *lkb, int type, int mode);
 int dlm_user_init(void);
 void dlm_user_exit(void);
 int dlm_device_deregister(struct dlm_ls *ls);
-- 
1.6.6

