Return-Path: <linux-kernel-owner+w=401wt.eu-S1759699AbYAXRDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759699AbYAXRDv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 12:03:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758346AbYAXQ6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 11:58:49 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49793 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758292AbYAXQ6l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 11:58:41 -0500
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 18/19] dlm: keep cached master rsbs during recovery
Date: Thu, 24 Jan 2008 10:50:41 -0600
Message-Id: <1201193442-8260-19-git-send-email-teigland@redhat.com>
X-Mailer: git-send-email 1.5.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To prevent the master of an rsb from changing rapidly, an unused rsb is kept
on the "toss list" for a period of time to be reused.  The toss list was
being cleared completely for each recovery, which is unnecessary.  Much of
the benefit of the toss list can be maintained if nodes keep rsb's in their
toss list that they are the master of.  These rsb's need to be included
when the resource directory is rebuilt during recovery.

Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/dir.c      |   66 +++++++++++++++++++++++++---------------------------
 fs/dlm/lock.c     |    6 -----
 fs/dlm/lock.h     |    2 -
 fs/dlm/recover.c  |   25 ++++++++++++++++++-
 fs/dlm/recoverd.c |   11 +++++----
 5 files changed, 61 insertions(+), 49 deletions(-)

diff --git a/fs/dlm/dir.c b/fs/dlm/dir.c
index 600bb1d..ff97ba9 100644
--- a/fs/dlm/dir.c
+++ b/fs/dlm/dir.c
@@ -329,49 +329,47 @@ int dlm_dir_lookup(struct dlm_ls *ls, int nodeid, char *name, int namelen,
 	return get_entry(ls, nodeid, name, namelen, r_nodeid);
 }
 
-/* Copy the names of master rsb's into the buffer provided.
-   Only select names whose dir node is the given nodeid. */
+static struct dlm_rsb *find_rsb_root(struct dlm_ls *ls, char *name, int len)
+{
+	struct dlm_rsb *r;
+
+	down_read(&ls->ls_root_sem);
+	list_for_each_entry(r, &ls->ls_root_list, res_root_list) {
+		if (len == r->res_length && !memcmp(name, r->res_name, len)) {
+			up_read(&ls->ls_root_sem);
+			return r;
+		}
+	}
+	up_read(&ls->ls_root_sem);
+	return NULL;
+}
+
+/* Find the rsb where we left off (or start again), then send rsb names
+   for rsb's we're master of and whose directory node matches the requesting
+   node.  inbuf is the rsb name last sent, inlen is the name's length */
 
 void dlm_copy_master_names(struct dlm_ls *ls, char *inbuf, int inlen,
  			   char *outbuf, int outlen, int nodeid)
 {
 	struct list_head *list;
-	struct dlm_rsb *start_r = NULL, *r = NULL;
-	int offset = 0, start_namelen, error, dir_nodeid;
-	char *start_name;
+	struct dlm_rsb *r;
+	int offset = 0, dir_nodeid;
 	uint16_t be_namelen;
 
-	/*
-	 * Find the rsb where we left off (or start again)
-	 */
-
-	start_namelen = inlen;
-	start_name = inbuf;
-
-	if (start_namelen > 1) {
-		/*
-		 * We could also use a find_rsb_root() function here that
-		 * searched the ls_root_list.
-		 */
-		error = dlm_find_rsb(ls, start_name, start_namelen, R_MASTER,
-				     &start_r);
-		DLM_ASSERT(!error && start_r,
-			   printk("error %d\n", error););
-		DLM_ASSERT(!list_empty(&start_r->res_root_list),
-			   dlm_print_rsb(start_r););
-		dlm_put_rsb(start_r);
-	}
-
-	/*
-	 * Send rsb names for rsb's we're master of and whose directory node
-	 * matches the requesting node.
-	 */
-
 	down_read(&ls->ls_root_sem);
-	if (start_r)
-		list = start_r->res_root_list.next;
-	else
+
+	if (inlen > 1) {
+		r = find_rsb_root(ls, inbuf, inlen);
+		if (!r) {
+			inbuf[inlen - 1] = '\0';
+			log_error(ls, "copy_master_names from %d start %d %s",
+				  nodeid, inlen, inbuf);
+			goto out;
+		}
+		list = r->res_root_list.next;
+	} else {
 		list = ls->ls_root_list.next;
+	}
 
 	for (offset = 0; list != &ls->ls_root_list; list = list->next) {
 		r = list_entry(list, struct dlm_rsb, res_root_list);
diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index 7ee7c7c..ff4a198 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -489,12 +489,6 @@ static int find_rsb(struct dlm_ls *ls, char *name, int namelen,
 	return error;
 }
 
-int dlm_find_rsb(struct dlm_ls *ls, char *name, int namelen,
-		 unsigned int flags, struct dlm_rsb **r_ret)
-{
-	return find_rsb(ls, name, namelen, flags, r_ret);
-}
-
 /* This is only called to add a reference when the code already holds
    a valid reference to the rsb, so there's no need for locking. */
 
diff --git a/fs/dlm/lock.h b/fs/dlm/lock.h
index ada0468..27b6ed3 100644
--- a/fs/dlm/lock.h
+++ b/fs/dlm/lock.h
@@ -19,8 +19,6 @@ void dlm_print_lkb(struct dlm_lkb *lkb);
 void dlm_receive_message_saved(struct dlm_ls *ls, struct dlm_message *ms);
 void dlm_receive_buffer(struct dlm_header *hd, int nodeid);
 int dlm_modes_compat(int mode1, int mode2);
-int dlm_find_rsb(struct dlm_ls *ls, char *name, int namelen,
-	unsigned int flags, struct dlm_rsb **r_ret);
 void dlm_put_rsb(struct dlm_rsb *r);
 void dlm_hold_rsb(struct dlm_rsb *r);
 int dlm_put_lkb(struct dlm_lkb *lkb);
diff --git a/fs/dlm/recover.c b/fs/dlm/recover.c
index 2f9d9a3..df075dc 100644
--- a/fs/dlm/recover.c
+++ b/fs/dlm/recover.c
@@ -731,6 +731,20 @@ int dlm_create_root_list(struct dlm_ls *ls)
 			list_add(&r->res_root_list, &ls->ls_root_list);
 			dlm_hold_rsb(r);
 		}
+
+		/* If we're using a directory, add tossed rsbs to the root
+		   list; they'll have entries created in the new directory,
+		   but no other recovery steps should do anything with them. */
+
+		if (dlm_no_directory(ls)) {
+			read_unlock(&ls->ls_rsbtbl[i].lock);
+			continue;
+		}
+
+		list_for_each_entry(r, &ls->ls_rsbtbl[i].toss, res_hashchain) {
+			list_add(&r->res_root_list, &ls->ls_root_list);
+			dlm_hold_rsb(r);
+		}
 		read_unlock(&ls->ls_rsbtbl[i].lock);
 	}
  out:
@@ -750,6 +764,11 @@ void dlm_release_root_list(struct dlm_ls *ls)
 	up_write(&ls->ls_root_sem);
 }
 
+/* If not using a directory, clear the entire toss list, there's no benefit to
+   caching the master value since it's fixed.  If we are using a dir, keep the
+   rsb's we're the master of.  Recovery will add them to the root list and from
+   there they'll be entered in the rebuilt directory. */
+
 void dlm_clear_toss_list(struct dlm_ls *ls)
 {
 	struct dlm_rsb *r, *safe;
@@ -759,8 +778,10 @@ void dlm_clear_toss_list(struct dlm_ls *ls)
 		write_lock(&ls->ls_rsbtbl[i].lock);
 		list_for_each_entry_safe(r, safe, &ls->ls_rsbtbl[i].toss,
 					 res_hashchain) {
-			list_del(&r->res_hashchain);
-			dlm_free_rsb(r);
+			if (dlm_no_directory(ls) || !is_master(r)) {
+				list_del(&r->res_hashchain);
+				dlm_free_rsb(r);
+			}
 		}
 		write_unlock(&ls->ls_rsbtbl[i].lock);
 	}
diff --git a/fs/dlm/recoverd.c b/fs/dlm/recoverd.c
index 4b89e20..997f953 100644
--- a/fs/dlm/recoverd.c
+++ b/fs/dlm/recoverd.c
@@ -67,17 +67,18 @@ static int ls_recover(struct dlm_ls *ls, struct dlm_recover *rv)
 	dlm_astd_resume();
 
 	/*
-	 * This list of root rsb's will be the basis of most of the recovery
-	 * routines.
+	 * Free non-master tossed rsb's.  Master rsb's are kept on toss
+	 * list and put on root list to be included in resdir recovery.
 	 */
 
-	dlm_create_root_list(ls);
+	dlm_clear_toss_list(ls);
 
 	/*
-	 * Free all the tossed rsb's so we don't have to recover them.
+	 * This list of root rsb's will be the basis of most of the recovery
+	 * routines.
 	 */
 
-	dlm_clear_toss_list(ls);
+	dlm_create_root_list(ls);
 
 	/*
 	 * Add or remove nodes from the lockspace's ls_nodes list.
-- 
1.5.3.3

