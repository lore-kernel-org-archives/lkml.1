Return-Path: <linux-kernel-owner+w=401wt.eu-S1031644AbXEAKJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031644AbXEAKJR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 06:09:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031649AbXEAKJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 06:09:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49199 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031656AbXEAKJP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 06:09:15 -0400
Subject: [GFS2] Speed up lock_dlm's locking (move sprintf) [8/34]
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com
Cc: linux-kernel@vger.kernel.org, David Teigland <teigland@redhat.com>
In-Reply-To: <1178013376.5462.127.camel@quoit.chygwyn.com>
References: <1178013376.5462.127.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Tue, 01 May 2007 11:04:42 +0100
Message-Id: <1178013882.5462.142.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From f35ac346bc48b2086aa94f031baf1f6237a89de6 Mon Sep 17 00:00:00 2001
From: Steven Whitehouse <swhiteho@redhat.com>
Date: Sun, 18 Mar 2007 17:04:15 +0000
Subject: [PATCH] [GFS2] Speed up lock_dlm's locking (move sprintf)

The following patch speeds up lock_dlm's locking by moving the sprintf
out from the lock acquisition path and into the lock creation path. This
reduces the amount of CPU time used in acquiring locks by a fair amount.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Acked-by: David Teigland <teigland@redhat.com>

diff --git a/fs/gfs2/locking/dlm/lock.c b/fs/gfs2/locking/dlm/lock.c
index b167add..f9c8bda 100644
--- a/fs/gfs2/locking/dlm/lock.c
+++ b/fs/gfs2/locking/dlm/lock.c
@@ -151,7 +151,7 @@ static inline unsigned int make_flags(struct gdlm_lock *lp,
 
 /* make_strname - convert GFS lock numbers to a string */
 
-static inline void make_strname(struct lm_lockname *lockname,
+static inline void make_strname(const struct lm_lockname *lockname,
 				struct gdlm_strname *str)
 {
 	sprintf(str->name, "%8x%16llx", lockname->ln_type,
@@ -169,6 +169,7 @@ static int gdlm_create_lp(struct gdlm_ls *ls, struct lm_lockname *name,
 		return -ENOMEM;
 
 	lp->lockname = *name;
+	make_strname(name, &lp->strname);
 	lp->ls = ls;
 	lp->cur = DLM_LOCK_IV;
 	lp->lvb = NULL;
@@ -227,7 +228,6 @@ void gdlm_put_lock(void *lock)
 unsigned int gdlm_do_lock(struct gdlm_lock *lp)
 {
 	struct gdlm_ls *ls = lp->ls;
-	struct gdlm_strname str;
 	int error, bast = 1;
 
 	/*
@@ -249,8 +249,6 @@ unsigned int gdlm_do_lock(struct gdlm_lock *lp)
 	if (test_bit(LFL_NOBAST, &lp->flags))
 		bast = 0;
 
-	make_strname(&lp->lockname, &str);
-
 	set_bit(LFL_ACTIVE, &lp->flags);
 
 	log_debug("lk %x,%llx id %x %d,%d %x", lp->lockname.ln_type,
@@ -258,8 +256,8 @@ unsigned int gdlm_do_lock(struct gdlm_lock *lp)
 		  lp->cur, lp->req, lp->lkf);
 
 	error = dlm_lock(ls->dlm_lockspace, lp->req, &lp->lksb, lp->lkf,
-			 str.name, str.namelen, 0, gdlm_ast, lp,
-			 bast ? gdlm_bast : NULL);
+			 lp->strname.name, lp->strname.namelen, 0, gdlm_ast,
+			 lp, bast ? gdlm_bast : NULL);
 
 	if ((error == -EAGAIN) && (lp->lkf & DLM_LKF_NOQUEUE)) {
 		lp->lksb.sb_status = -EAGAIN;
diff --git a/fs/gfs2/locking/dlm/lock_dlm.h b/fs/gfs2/locking/dlm/lock_dlm.h
index a87c7bf..6888bd4 100644
--- a/fs/gfs2/locking/dlm/lock_dlm.h
+++ b/fs/gfs2/locking/dlm/lock_dlm.h
@@ -106,6 +106,7 @@ enum {
 struct gdlm_lock {
 	struct gdlm_ls		*ls;
 	struct lm_lockname	lockname;
+	struct gdlm_strname	strname;
 	char			*lvb;
 	struct dlm_lksb		lksb;
 
-- 
1.5.1.2



