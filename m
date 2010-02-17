Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932463Ab0BQNU2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 08:20:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26017 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757296Ab0BQNU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 08:20:27 -0500
Subject: dlm: Remove/bypass astd
From: Steven Whitehouse <swhiteho@redhat.com>
To: David Teigland <teigland@redhat.com>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Wed, 17 Feb 2010 13:23:39 +0000
Message-ID: <1266413019.2907.27.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


While investigating Red Hat bug #537010 I started looking at the dlm's astd
thread. The way in which the "cast" and "bast" requests are queued looked
as if it might cause reordering since the "bast" requests are always
delivered after any pending "cast" requests which is not always the
correct ordering. This patch doesn't fix that bug, but it will prevent any
races in that bit of code, and the performance benefits are also well
worth having.

I noticed that astd seems to be extraneous to requirements. The notifications
to astd are already running in process context, so they could be delivered
directly. That should improve smp performance since all the notifications
would no longer be funneled through a single thread.

Also, the only other function of astd seemed to be stopping the delivery
of these notifications during recovery. Since, however, the notifications
which are intercepted at recovery time are neither modified, nor filtered
in any way, the only effect is to delay notifications for no obvious reason.

I thought that probably removing the astd thread and delivering the "cast"
and "bast" notifications directly would improve performance due to the
elimination of a scheduling delay. I wrote a small test module which
creates a dlm lock space, and does 100,000 NL -> EX -> NL lock conversions.

Having run this test 10 times each on a 2.6.33-rc8 kernel and then the modified
kernel including this patch, I got the following results:

Original: Avg time 24.62 us per conversion (NL -> EX -> NL)
Modified: Avg time 9.93 us per conversion

Which is a fairly dramatic speed up. Please consider applying this patch.
I've tested it in both clustered and single node GFS2 configurations. The test
figures are from a single node configuration which was a deliberate choice
in order to avoid any effects of network latency.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
---
 fs/dlm/Makefile    |    3 +-
 fs/dlm/ast.c       |  165 ----------------------------------------------------
 fs/dlm/ast.h       |   26 --------
 fs/dlm/lock.c      |   16 ++++-
 fs/dlm/lockspace.c |   17 +-----
 fs/dlm/recover.c   |    1 -
 fs/dlm/recoverd.c  |   11 ----
 7 files changed, 15 insertions(+), 224 deletions(-)
 delete mode 100644 fs/dlm/ast.c
 delete mode 100644 fs/dlm/ast.h

diff --git a/fs/dlm/Makefile b/fs/dlm/Makefile
index ca1c912..8f9f4d2 100644
--- a/fs/dlm/Makefile
+++ b/fs/dlm/Makefile
@@ -1,6 +1,5 @@
 obj-$(CONFIG_DLM) +=		dlm.o
-dlm-y :=			ast.o \
-				config.o \
+dlm-y :=			config.o \
 				dir.o \
 				lock.o \
 				lockspace.o \
diff --git a/fs/dlm/ast.c b/fs/dlm/ast.c
deleted file mode 100644
index dc2ad60..0000000
--- a/fs/dlm/ast.c
+++ /dev/null
@@ -1,165 +0,0 @@
-/******************************************************************************
-*******************************************************************************
-**
-**  Copyright (C) Sistina Software, Inc.  1997-2003  All rights reserved.
-**  Copyright (C) 2004-2008 Red Hat, Inc.  All rights reserved.
-**
-**  This copyrighted material is made available to anyone wishing to use,
-**  modify, copy, or redistribute it subject to the terms and conditions
-**  of the GNU General Public License v.2.
-**
-*******************************************************************************
-******************************************************************************/
-
-#include "dlm_internal.h"
-#include "lock.h"
-#include "user.h"
-#include "ast.h"
-
-#define WAKE_ASTS  0
-
-static struct list_head		ast_queue;
-static spinlock_t		ast_queue_lock;
-static struct task_struct *	astd_task;
-static unsigned long		astd_wakeflags;
-static struct mutex		astd_running;
-
-
-void dlm_del_ast(struct dlm_lkb *lkb)
-{
-	spin_lock(&ast_queue_lock);
-	if (lkb->lkb_ast_type & (AST_COMP | AST_BAST))
-		list_del(&lkb->lkb_astqueue);
-	spin_unlock(&ast_queue_lock);
-}
-
-void dlm_add_ast(struct dlm_lkb *lkb, int type, int bastmode)
-{
-	if (lkb->lkb_flags & DLM_IFL_USER) {
-		dlm_user_add_ast(lkb, type, bastmode);
-		return;
-	}
-
-	spin_lock(&ast_queue_lock);
-	if (!(lkb->lkb_ast_type & (AST_COMP | AST_BAST))) {
-		kref_get(&lkb->lkb_ref);
-		list_add_tail(&lkb->lkb_astqueue, &ast_queue);
-	}
-	lkb->lkb_ast_type |= type;
-	if (bastmode)
-		lkb->lkb_bastmode = bastmode;
-	spin_unlock(&ast_queue_lock);
-
-	set_bit(WAKE_ASTS, &astd_wakeflags);
-	wake_up_process(astd_task);
-}
-
-static void process_asts(void)
-{
-	struct dlm_ls *ls = NULL;
-	struct dlm_rsb *r = NULL;
-	struct dlm_lkb *lkb;
-	void (*cast) (void *astparam);
-	void (*bast) (void *astparam, int mode);
-	int type = 0, bastmode;
-
-repeat:
-	spin_lock(&ast_queue_lock);
-	list_for_each_entry(lkb, &ast_queue, lkb_astqueue) {
-		r = lkb->lkb_resource;
-		ls = r->res_ls;
-
-		if (dlm_locking_stopped(ls))
-			continue;
-
-		list_del(&lkb->lkb_astqueue);
-		type = lkb->lkb_ast_type;
-		lkb->lkb_ast_type = 0;
-		bastmode = lkb->lkb_bastmode;
-
-		spin_unlock(&ast_queue_lock);
-		cast = lkb->lkb_astfn;
-		bast = lkb->lkb_bastfn;
-
-		if ((type & AST_COMP) && cast)
-			cast(lkb->lkb_astparam);
-
-		if ((type & AST_BAST) && bast)
-			bast(lkb->lkb_astparam, bastmode);
-
-		/* this removes the reference added by dlm_add_ast
-		   and may result in the lkb being freed */
-		dlm_put_lkb(lkb);
-
-		cond_resched();
-		goto repeat;
-	}
-	spin_unlock(&ast_queue_lock);
-}
-
-static inline int no_asts(void)
-{
-	int ret;
-
-	spin_lock(&ast_queue_lock);
-	ret = list_empty(&ast_queue);
-	spin_unlock(&ast_queue_lock);
-	return ret;
-}
-
-static int dlm_astd(void *data)
-{
-	while (!kthread_should_stop()) {
-		set_current_state(TASK_INTERRUPTIBLE);
-		if (!test_bit(WAKE_ASTS, &astd_wakeflags))
-			schedule();
-		set_current_state(TASK_RUNNING);
-
-		mutex_lock(&astd_running);
-		if (test_and_clear_bit(WAKE_ASTS, &astd_wakeflags))
-			process_asts();
-		mutex_unlock(&astd_running);
-	}
-	return 0;
-}
-
-void dlm_astd_wake(void)
-{
-	if (!no_asts()) {
-		set_bit(WAKE_ASTS, &astd_wakeflags);
-		wake_up_process(astd_task);
-	}
-}
-
-int dlm_astd_start(void)
-{
-	struct task_struct *p;
-	int error = 0;
-
-	INIT_LIST_HEAD(&ast_queue);
-	spin_lock_init(&ast_queue_lock);
-	mutex_init(&astd_running);
-
-	p = kthread_run(dlm_astd, NULL, "dlm_astd");
-	if (IS_ERR(p))
-		error = PTR_ERR(p);
-	else
-		astd_task = p;
-	return error;
-}
-
-void dlm_astd_stop(void)
-{
-	kthread_stop(astd_task);
-}
-
-void dlm_astd_suspend(void)
-{
-	mutex_lock(&astd_running);
-}
-
-void dlm_astd_resume(void)
-{
-	mutex_unlock(&astd_running);
-}
-
diff --git a/fs/dlm/ast.h b/fs/dlm/ast.h
deleted file mode 100644
index 1b5fc5f..0000000
--- a/fs/dlm/ast.h
+++ /dev/null
@@ -1,26 +0,0 @@
-/******************************************************************************
-*******************************************************************************
-**
-**  Copyright (C) 2005-2008 Red Hat, Inc.  All rights reserved.
-**
-**  This copyrighted material is made available to anyone wishing to use,
-**  modify, copy, or redistribute it subject to the terms and conditions
-**  of the GNU General Public License v.2.
-**
-*******************************************************************************
-******************************************************************************/
-
-#ifndef __ASTD_DOT_H__
-#define __ASTD_DOT_H__
-
-void dlm_add_ast(struct dlm_lkb *lkb, int type, int bastmode);
-void dlm_del_ast(struct dlm_lkb *lkb);
-
-void dlm_astd_wake(void);
-int dlm_astd_start(void);
-void dlm_astd_stop(void);
-void dlm_astd_suspend(void);
-void dlm_astd_resume(void);
-
-#endif
-
diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index 9c0c1db..2c1b04e 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -65,7 +65,6 @@
 #include "dir.h"
 #include "member.h"
 #include "lockspace.h"
-#include "ast.h"
 #include "lock.h"
 #include "rcom.h"
 #include "recover.h"
@@ -283,6 +282,19 @@ static inline int is_overlap(struct dlm_lkb *lkb)
 				  DLM_IFL_OVERLAP_CANCEL));
 }
 
+static void dlm_add_ast(struct dlm_lkb *lkb, int type, int bastmode)
+{
+	if (lkb->lkb_flags & DLM_IFL_USER) {
+		dlm_user_add_ast(lkb, type, bastmode);
+		return;
+	}
+
+	if (type & AST_COMP)
+		lkb->lkb_astfn(lkb->lkb_astparam);
+	else if (type & AST_BAST)
+		lkb->lkb_bastfn(lkb->lkb_astparam, bastmode);
+}
+
 static void queue_cast(struct dlm_rsb *r, struct dlm_lkb *lkb, int rv)
 {
 	if (is_master_copy(lkb))
@@ -3854,8 +3866,6 @@ static void _receive_message(struct dlm_ls *ls, struct dlm_message *ms)
 	default:
 		log_error(ls, "unknown message type %d", ms->m_type);
 	}
-
-	dlm_astd_wake();
 }
 
 /* If the lockspace is in recovery mode (locking stopped), then normal
diff --git a/fs/dlm/lockspace.c b/fs/dlm/lockspace.c
index ce0fdf5..fec8816 100644
--- a/fs/dlm/lockspace.c
+++ b/fs/dlm/lockspace.c
@@ -15,7 +15,6 @@
 #include "lockspace.h"
 #include "member.h"
 #include "recoverd.h"
-#include "ast.h"
 #include "dir.h"
 #include "lowcomms.h"
 #include "config.h"
@@ -356,16 +355,10 @@ static int threads_start(void)
 	int error;
 
 	/* Thread which process lock requests for all lockspace's */
-	error = dlm_astd_start();
-	if (error) {
-		log_print("cannot start dlm_astd thread %d", error);
-		goto fail;
-	}
-
 	error = dlm_scand_start();
 	if (error) {
 		log_print("cannot start dlm_scand thread %d", error);
-		goto astd_fail;
+		goto fail;
 	}
 
 	/* Thread for sending/receiving messages for all lockspace's */
@@ -379,8 +372,6 @@ static int threads_start(void)
 
  scand_fail:
 	dlm_scand_stop();
- astd_fail:
-	dlm_astd_stop();
  fail:
 	return error;
 }
@@ -389,7 +380,6 @@ static void threads_stop(void)
 {
 	dlm_scand_stop();
 	dlm_lowcomms_stop();
-	dlm_astd_stop();
 }
 
 static int new_lockspace(const char *name, int namelen, void **lockspace,
@@ -708,8 +698,6 @@ static int release_lockspace(struct dlm_ls *ls, int force)
 
 	dlm_delete_debug_file(ls);
 
-	dlm_astd_suspend();
-
 	kfree(ls->ls_recover_buf);
 
 	/*
@@ -731,15 +719,12 @@ static int release_lockspace(struct dlm_ls *ls, int force)
 
 			list_del(&lkb->lkb_idtbl_list);
 
-			dlm_del_ast(lkb);
-
 			if (lkb->lkb_lvbptr && lkb->lkb_flags & DLM_IFL_MSTCPY)
 				dlm_free_lvb(lkb->lkb_lvbptr);
 
 			dlm_free_lkb(lkb);
 		}
 	}
-	dlm_astd_resume();
 
 	kfree(ls->ls_lkbtbl);
 
diff --git a/fs/dlm/recover.c b/fs/dlm/recover.c
index eda43f3..88dabb7 100644
--- a/fs/dlm/recover.c
+++ b/fs/dlm/recover.c
@@ -15,7 +15,6 @@
 #include "lockspace.h"
 #include "dir.h"
 #include "config.h"
-#include "ast.h"
 #include "memory.h"
 #include "rcom.h"
 #include "lock.h"
diff --git a/fs/dlm/recoverd.c b/fs/dlm/recoverd.c
index fd677c8..b85ca89 100644
--- a/fs/dlm/recoverd.c
+++ b/fs/dlm/recoverd.c
@@ -15,7 +15,6 @@
 #include "lockspace.h"
 #include "member.h"
 #include "dir.h"
-#include "ast.h"
 #include "recover.h"
 #include "lowcomms.h"
 #include "lock.h"
@@ -59,14 +58,6 @@ static int ls_recover(struct dlm_ls *ls, struct dlm_recover *rv)
 	mutex_lock(&ls->ls_recoverd_active);
 
 	/*
-	 * Suspending and resuming dlm_astd ensures that no lkb's from this ls
-	 * will be processed by dlm_astd during recovery.
-	 */
-
-	dlm_astd_suspend();
-	dlm_astd_resume();
-
-	/*
 	 * Free non-master tossed rsb's.  Master rsb's are kept on toss
 	 * list and put on root list to be included in resdir recovery.
 	 */
@@ -222,8 +213,6 @@ static int ls_recover(struct dlm_ls *ls, struct dlm_recover *rv)
 
 	dlm_grant_after_purge(ls);
 
-	dlm_astd_wake();
-
 	log_debug(ls, "recover %llx done: %u ms",
 		  (unsigned long long)rv->seq,
 		  jiffies_to_msecs(jiffies - start));
-- 
1.6.2.5



