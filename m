Return-Path: <linux-kernel-owner+w=401wt.eu-S1758721AbYAXRAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758721AbYAXRAA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 12:00:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758272AbYAXQ6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 11:58:38 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49770 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758243AbYAXQ6e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 11:58:34 -0500
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 04/19] dlm: use dlm prefix on alloc and free functions
Date: Thu, 24 Jan 2008 10:50:27 -0600
Message-Id: <1201193442-8260-5-git-send-email-teigland@redhat.com>
X-Mailer: git-send-email 1.5.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dlm functions in memory.c should use the dlm_ prefix.  Also, use
kzalloc/kfree directly for dlm_direntry's, removing the wrapper functions.

Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/dir.c       |   10 +++++-----
 fs/dlm/lock.c      |   26 +++++++++++++-------------
 fs/dlm/lockspace.c |    8 ++++----
 fs/dlm/memory.c    |   32 ++++++++------------------------
 fs/dlm/memory.h    |   16 +++++++---------
 fs/dlm/recover.c   |    4 ++--
 6 files changed, 39 insertions(+), 57 deletions(-)

diff --git a/fs/dlm/dir.c b/fs/dlm/dir.c
index 4675455..600bb1d 100644
--- a/fs/dlm/dir.c
+++ b/fs/dlm/dir.c
@@ -49,7 +49,7 @@ static struct dlm_direntry *get_free_de(struct dlm_ls *ls, int len)
 	spin_unlock(&ls->ls_recover_list_lock);
 
 	if (!found)
-		de = allocate_direntry(ls, len);
+		de = kzalloc(sizeof(struct dlm_direntry) + len, GFP_KERNEL);
 	return de;
 }
 
@@ -62,7 +62,7 @@ void dlm_clear_free_entries(struct dlm_ls *ls)
 		de = list_entry(ls->ls_recover_list.next, struct dlm_direntry,
 				list);
 		list_del(&de->list);
-		free_direntry(de);
+		kfree(de);
 	}
 	spin_unlock(&ls->ls_recover_list_lock);
 }
@@ -171,7 +171,7 @@ void dlm_dir_remove_entry(struct dlm_ls *ls, int nodeid, char *name, int namelen
 	}
 
 	list_del(&de->list);
-	free_direntry(de);
+	kfree(de);
  out:
 	write_unlock(&ls->ls_dirtbl[bucket].lock);
 }
@@ -302,7 +302,7 @@ static int get_entry(struct dlm_ls *ls, int nodeid, char *name,
 
 	write_unlock(&ls->ls_dirtbl[bucket].lock);
 
-	de = allocate_direntry(ls, namelen);
+	de = kzalloc(sizeof(struct dlm_direntry) + namelen, GFP_KERNEL);
 	if (!de)
 		return -ENOMEM;
 
@@ -313,7 +313,7 @@ static int get_entry(struct dlm_ls *ls, int nodeid, char *name,
 	write_lock(&ls->ls_dirtbl[bucket].lock);
 	tmp = search_bucket(ls, name, namelen, bucket);
 	if (tmp) {
-		free_direntry(de);
+		kfree(de);
 		de = tmp;
 	} else {
 		list_add_tail(&de->list, &ls->ls_dirtbl[bucket].list);
diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index 63fe74d..ddb4628 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -334,7 +334,7 @@ static struct dlm_rsb *create_rsb(struct dlm_ls *ls, char *name, int len)
 {
 	struct dlm_rsb *r;
 
-	r = allocate_rsb(ls, len);
+	r = dlm_allocate_rsb(ls, len);
 	if (!r)
 		return NULL;
 
@@ -477,7 +477,7 @@ static int find_rsb(struct dlm_ls *ls, char *name, int namelen,
 	error = _search_rsb(ls, name, namelen, bucket, 0, &tmp);
 	if (!error) {
 		write_unlock(&ls->ls_rsbtbl[bucket].lock);
-		free_rsb(r);
+		dlm_free_rsb(r);
 		r = tmp;
 		goto out;
 	}
@@ -518,7 +518,7 @@ static void toss_rsb(struct kref *kref)
 	list_move(&r->res_hashchain, &ls->ls_rsbtbl[r->res_bucket].toss);
 	r->res_toss_time = jiffies;
 	if (r->res_lvbptr) {
-		free_lvb(r->res_lvbptr);
+		dlm_free_lvb(r->res_lvbptr);
 		r->res_lvbptr = NULL;
 	}
 }
@@ -588,7 +588,7 @@ static int create_lkb(struct dlm_ls *ls, struct dlm_lkb **lkb_ret)
 	uint32_t lkid = 0;
 	uint16_t bucket;
 
-	lkb = allocate_lkb(ls);
+	lkb = dlm_allocate_lkb(ls);
 	if (!lkb)
 		return -ENOMEM;
 
@@ -682,8 +682,8 @@ static int __put_lkb(struct dlm_ls *ls, struct dlm_lkb *lkb)
 
 		/* for local/process lkbs, lvbptr points to caller's lksb */
 		if (lkb->lkb_lvbptr && is_master_copy(lkb))
-			free_lvb(lkb->lkb_lvbptr);
-		free_lkb(lkb);
+			dlm_free_lvb(lkb->lkb_lvbptr);
+		dlm_free_lkb(lkb);
 		return 1;
 	} else {
 		write_unlock(&ls->ls_lkbtbl[bucket].lock);
@@ -987,7 +987,7 @@ static int shrink_bucket(struct dlm_ls *ls, int b)
 
 			if (is_master(r))
 				dir_remove(r);
-			free_rsb(r);
+			dlm_free_rsb(r);
 			count++;
 		} else {
 			write_unlock(&ls->ls_rsbtbl[b].lock);
@@ -1170,7 +1170,7 @@ static void set_lvb_lock(struct dlm_rsb *r, struct dlm_lkb *lkb)
 			return;
 
 		if (!r->res_lvbptr)
-			r->res_lvbptr = allocate_lvb(r->res_ls);
+			r->res_lvbptr = dlm_allocate_lvb(r->res_ls);
 
 		if (!r->res_lvbptr)
 			return;
@@ -1202,7 +1202,7 @@ static void set_lvb_unlock(struct dlm_rsb *r, struct dlm_lkb *lkb)
 		return;
 
 	if (!r->res_lvbptr)
-		r->res_lvbptr = allocate_lvb(r->res_ls);
+		r->res_lvbptr = dlm_allocate_lvb(r->res_ls);
 
 	if (!r->res_lvbptr)
 		return;
@@ -2985,7 +2985,7 @@ static int receive_lvb(struct dlm_ls *ls, struct dlm_lkb *lkb,
 
 	if (lkb->lkb_exflags & DLM_LKF_VALBLK) {
 		if (!lkb->lkb_lvbptr)
-			lkb->lkb_lvbptr = allocate_lvb(ls);
+			lkb->lkb_lvbptr = dlm_allocate_lvb(ls);
 		if (!lkb->lkb_lvbptr)
 			return -ENOMEM;
 		len = receive_extralen(ms);
@@ -3009,7 +3009,7 @@ static int receive_request_args(struct dlm_ls *ls, struct dlm_lkb *lkb,
 
 	if (lkb->lkb_exflags & DLM_LKF_VALBLK) {
 		/* lkb was just created so there won't be an lvb yet */
-		lkb->lkb_lvbptr = allocate_lvb(ls);
+		lkb->lkb_lvbptr = dlm_allocate_lvb(ls);
 		if (!lkb->lkb_lvbptr)
 			return -ENOMEM;
 	}
@@ -4183,7 +4183,7 @@ static int receive_rcom_lock_args(struct dlm_ls *ls, struct dlm_lkb *lkb,
 	lkb->lkb_astaddr = (void *) (long) (rl->rl_asts & AST_COMP);
 
 	if (lkb->lkb_exflags & DLM_LKF_VALBLK) {
-		lkb->lkb_lvbptr = allocate_lvb(ls);
+		lkb->lkb_lvbptr = dlm_allocate_lvb(ls);
 		if (!lkb->lkb_lvbptr)
 			return -ENOMEM;
 		lvblen = rc->rc_header.h_length - sizeof(struct dlm_rcom) -
@@ -4341,7 +4341,7 @@ int dlm_user_request(struct dlm_ls *ls, struct dlm_user_args *ua,
 		}
 	}
 
-	/* After ua is attached to lkb it will be freed by free_lkb().
+	/* After ua is attached to lkb it will be freed by dlm_free_lkb().
 	   When DLM_IFL_USER is set, the dlm knows that this is a userspace
 	   lock and that lkb_astparam is the dlm_user_args structure. */
 
diff --git a/fs/dlm/lockspace.c b/fs/dlm/lockspace.c
index b99485b..4831965 100644
--- a/fs/dlm/lockspace.c
+++ b/fs/dlm/lockspace.c
@@ -698,9 +698,9 @@ static int release_lockspace(struct dlm_ls *ls, int force)
 			dlm_del_ast(lkb);
 
 			if (lkb->lkb_lvbptr && lkb->lkb_flags & DLM_IFL_MSTCPY)
-				free_lvb(lkb->lkb_lvbptr);
+				dlm_free_lvb(lkb->lkb_lvbptr);
 
-			free_lkb(lkb);
+			dlm_free_lkb(lkb);
 		}
 	}
 	dlm_astd_resume();
@@ -718,7 +718,7 @@ static int release_lockspace(struct dlm_ls *ls, int force)
 					 res_hashchain);
 
 			list_del(&rsb->res_hashchain);
-			free_rsb(rsb);
+			dlm_free_rsb(rsb);
 		}
 
 		head = &ls->ls_rsbtbl[i].toss;
@@ -726,7 +726,7 @@ static int release_lockspace(struct dlm_ls *ls, int force)
 			rsb = list_entry(head->next, struct dlm_rsb,
 					 res_hashchain);
 			list_del(&rsb->res_hashchain);
-			free_rsb(rsb);
+			dlm_free_rsb(rsb);
 		}
 	}
 
diff --git a/fs/dlm/memory.c b/fs/dlm/memory.c
index ecf0e5c..f778386 100644
--- a/fs/dlm/memory.c
+++ b/fs/dlm/memory.c
@@ -2,7 +2,7 @@
 *******************************************************************************
 **
 **  Copyright (C) Sistina Software, Inc.  1997-2003  All rights reserved.
-**  Copyright (C) 2004-2005 Red Hat, Inc.  All rights reserved.
+**  Copyright (C) 2004-2007 Red Hat, Inc.  All rights reserved.
 **
 **  This copyrighted material is made available to anyone wishing to use,
 **  modify, copy, or redistribute it subject to the terms and conditions
@@ -35,7 +35,7 @@ void dlm_memory_exit(void)
 		kmem_cache_destroy(lkb_cache);
 }
 
-char *allocate_lvb(struct dlm_ls *ls)
+char *dlm_allocate_lvb(struct dlm_ls *ls)
 {
 	char *p;
 
@@ -43,7 +43,7 @@ char *allocate_lvb(struct dlm_ls *ls)
 	return p;
 }
 
-void free_lvb(char *p)
+void dlm_free_lvb(char *p)
 {
 	kfree(p);
 }
@@ -51,7 +51,7 @@ void free_lvb(char *p)
 /* FIXME: have some minimal space built-in to rsb for the name and
    kmalloc a separate name if needed, like dentries are done */
 
-struct dlm_rsb *allocate_rsb(struct dlm_ls *ls, int namelen)
+struct dlm_rsb *dlm_allocate_rsb(struct dlm_ls *ls, int namelen)
 {
 	struct dlm_rsb *r;
 
@@ -61,14 +61,14 @@ struct dlm_rsb *allocate_rsb(struct dlm_ls *ls, int namelen)
 	return r;
 }
 
-void free_rsb(struct dlm_rsb *r)
+void dlm_free_rsb(struct dlm_rsb *r)
 {
 	if (r->res_lvbptr)
-		free_lvb(r->res_lvbptr);
+		dlm_free_lvb(r->res_lvbptr);
 	kfree(r);
 }
 
-struct dlm_lkb *allocate_lkb(struct dlm_ls *ls)
+struct dlm_lkb *dlm_allocate_lkb(struct dlm_ls *ls)
 {
 	struct dlm_lkb *lkb;
 
@@ -76,7 +76,7 @@ struct dlm_lkb *allocate_lkb(struct dlm_ls *ls)
 	return lkb;
 }
 
-void free_lkb(struct dlm_lkb *lkb)
+void dlm_free_lkb(struct dlm_lkb *lkb)
 {
 	if (lkb->lkb_flags & DLM_IFL_USER) {
 		struct dlm_user_args *ua;
@@ -90,19 +90,3 @@ void free_lkb(struct dlm_lkb *lkb)
 	kmem_cache_free(lkb_cache, lkb);
 }
 
-struct dlm_direntry *allocate_direntry(struct dlm_ls *ls, int namelen)
-{
-	struct dlm_direntry *de;
-
-	DLM_ASSERT(namelen <= DLM_RESNAME_MAXLEN,
-		   printk("namelen = %d\n", namelen););
-
-	de = kzalloc(sizeof(*de) + namelen, GFP_KERNEL);
-	return de;
-}
-
-void free_direntry(struct dlm_direntry *de)
-{
-	kfree(de);
-}
-
diff --git a/fs/dlm/memory.h b/fs/dlm/memory.h
index 6ead158..485fb29 100644
--- a/fs/dlm/memory.h
+++ b/fs/dlm/memory.h
@@ -2,7 +2,7 @@
 *******************************************************************************
 **
 **  Copyright (C) Sistina Software, Inc.  1997-2003  All rights reserved.
-**  Copyright (C) 2004-2005 Red Hat, Inc.  All rights reserved.
+**  Copyright (C) 2004-2007 Red Hat, Inc.  All rights reserved.
 **
 **  This copyrighted material is made available to anyone wishing to use,
 **  modify, copy, or redistribute it subject to the terms and conditions
@@ -16,14 +16,12 @@
 
 int dlm_memory_init(void);
 void dlm_memory_exit(void);
-struct dlm_rsb *allocate_rsb(struct dlm_ls *ls, int namelen);
-void free_rsb(struct dlm_rsb *r);
-struct dlm_lkb *allocate_lkb(struct dlm_ls *ls);
-void free_lkb(struct dlm_lkb *l);
-struct dlm_direntry *allocate_direntry(struct dlm_ls *ls, int namelen);
-void free_direntry(struct dlm_direntry *de);
-char *allocate_lvb(struct dlm_ls *ls);
-void free_lvb(char *l);
+struct dlm_rsb *dlm_allocate_rsb(struct dlm_ls *ls, int namelen);
+void dlm_free_rsb(struct dlm_rsb *r);
+struct dlm_lkb *dlm_allocate_lkb(struct dlm_ls *ls);
+void dlm_free_lkb(struct dlm_lkb *l);
+char *dlm_allocate_lvb(struct dlm_ls *ls);
+void dlm_free_lvb(char *l);
 
 #endif		/* __MEMORY_DOT_H__ */
 
diff --git a/fs/dlm/recover.c b/fs/dlm/recover.c
index c2cc769..2f9d9a3 100644
--- a/fs/dlm/recover.c
+++ b/fs/dlm/recover.c
@@ -629,7 +629,7 @@ static void recover_lvb(struct dlm_rsb *r)
 		goto out;
 
 	if (!r->res_lvbptr) {
-		r->res_lvbptr = allocate_lvb(r->res_ls);
+		r->res_lvbptr = dlm_allocate_lvb(r->res_ls);
 		if (!r->res_lvbptr)
 			goto out;
 	}
@@ -760,7 +760,7 @@ void dlm_clear_toss_list(struct dlm_ls *ls)
 		list_for_each_entry_safe(r, safe, &ls->ls_rsbtbl[i].toss,
 					 res_hashchain) {
 			list_del(&r->res_hashchain);
-			free_rsb(r);
+			dlm_free_rsb(r);
 		}
 		write_unlock(&ls->ls_rsbtbl[i].lock);
 	}
-- 
1.5.3.3

