Return-Path: <linux-kernel-owner+w=401wt.eu-S1761481AbZCXOSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761481AbZCXOSl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 10:18:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759953AbZCXOLt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 10:11:49 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37595 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760842AbZCXOLq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 10:11:46 -0400
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 1/7] dlm: Change rwlock which is only used in write mode to a spinlock
Date: Tue, 24 Mar 2009 09:07:46 -0500
Message-Id: <1237903672-18913-2-git-send-email-teigland@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

The ls_dirtbl[].lock was an rwlock, but since it was only used in write
mode a spinlock will suffice.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/dir.c          |   18 +++++++++---------
 fs/dlm/dlm_internal.h |    2 +-
 fs/dlm/lockspace.c    |    2 +-
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/fs/dlm/dir.c b/fs/dlm/dir.c
index 92969f8..858fba1 100644
--- a/fs/dlm/dir.c
+++ b/fs/dlm/dir.c
@@ -156,7 +156,7 @@ void dlm_dir_remove_entry(struct dlm_ls *ls, int nodeid, char *name, int namelen
 
 	bucket = dir_hash(ls, name, namelen);
 
-	write_lock(&ls->ls_dirtbl[bucket].lock);
+	spin_lock(&ls->ls_dirtbl[bucket].lock);
 
 	de = search_bucket(ls, name, namelen, bucket);
 
@@ -173,7 +173,7 @@ void dlm_dir_remove_entry(struct dlm_ls *ls, int nodeid, char *name, int namelen
 	list_del(&de->list);
 	kfree(de);
  out:
-	write_unlock(&ls->ls_dirtbl[bucket].lock);
+	spin_unlock(&ls->ls_dirtbl[bucket].lock);
 }
 
 void dlm_dir_clear(struct dlm_ls *ls)
@@ -185,14 +185,14 @@ void dlm_dir_clear(struct dlm_ls *ls)
 	DLM_ASSERT(list_empty(&ls->ls_recover_list), );
 
 	for (i = 0; i < ls->ls_dirtbl_size; i++) {
-		write_lock(&ls->ls_dirtbl[i].lock);
+		spin_lock(&ls->ls_dirtbl[i].lock);
 		head = &ls->ls_dirtbl[i].list;
 		while (!list_empty(head)) {
 			de = list_entry(head->next, struct dlm_direntry, list);
 			list_del(&de->list);
 			put_free_de(ls, de);
 		}
-		write_unlock(&ls->ls_dirtbl[i].lock);
+		spin_unlock(&ls->ls_dirtbl[i].lock);
 	}
 }
 
@@ -307,17 +307,17 @@ static int get_entry(struct dlm_ls *ls, int nodeid, char *name,
 
 	bucket = dir_hash(ls, name, namelen);
 
-	write_lock(&ls->ls_dirtbl[bucket].lock);
+	spin_lock(&ls->ls_dirtbl[bucket].lock);
 	de = search_bucket(ls, name, namelen, bucket);
 	if (de) {
 		*r_nodeid = de->master_nodeid;
-		write_unlock(&ls->ls_dirtbl[bucket].lock);
+		spin_unlock(&ls->ls_dirtbl[bucket].lock);
 		if (*r_nodeid == nodeid)
 			return -EEXIST;
 		return 0;
 	}
 
-	write_unlock(&ls->ls_dirtbl[bucket].lock);
+	spin_unlock(&ls->ls_dirtbl[bucket].lock);
 
 	if (namelen > DLM_RESNAME_MAXLEN)
 		return -EINVAL;
@@ -330,7 +330,7 @@ static int get_entry(struct dlm_ls *ls, int nodeid, char *name,
 	de->length = namelen;
 	memcpy(de->name, name, namelen);
 
-	write_lock(&ls->ls_dirtbl[bucket].lock);
+	spin_lock(&ls->ls_dirtbl[bucket].lock);
 	tmp = search_bucket(ls, name, namelen, bucket);
 	if (tmp) {
 		kfree(de);
@@ -339,7 +339,7 @@ static int get_entry(struct dlm_ls *ls, int nodeid, char *name,
 		list_add_tail(&de->list, &ls->ls_dirtbl[bucket].list);
 	}
 	*r_nodeid = de->master_nodeid;
-	write_unlock(&ls->ls_dirtbl[bucket].lock);
+	spin_unlock(&ls->ls_dirtbl[bucket].lock);
 	return 0;
 }
 
diff --git a/fs/dlm/dlm_internal.h b/fs/dlm/dlm_internal.h
index 076e86f..d01ca0a 100644
--- a/fs/dlm/dlm_internal.h
+++ b/fs/dlm/dlm_internal.h
@@ -99,7 +99,7 @@ struct dlm_direntry {
 
 struct dlm_dirtable {
 	struct list_head	list;
-	rwlock_t		lock;
+	spinlock_t		lock;
 };
 
 struct dlm_rsbtable {
diff --git a/fs/dlm/lockspace.c b/fs/dlm/lockspace.c
index aa32e5f..cd8e2df 100644
--- a/fs/dlm/lockspace.c
+++ b/fs/dlm/lockspace.c
@@ -487,7 +487,7 @@ static int new_lockspace(char *name, int namelen, void **lockspace,
 		goto out_lkbfree;
 	for (i = 0; i < size; i++) {
 		INIT_LIST_HEAD(&ls->ls_dirtbl[i].list);
-		rwlock_init(&ls->ls_dirtbl[i].lock);
+		spin_lock_init(&ls->ls_dirtbl[i].lock);
 	}
 
 	INIT_LIST_HEAD(&ls->ls_waiters);
-- 
1.5.5.6

