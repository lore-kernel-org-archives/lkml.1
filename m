Return-Path: <linux-kernel-owner+w=401wt.eu-S1759511AbXGIQ22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759511AbXGIQ22 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 12:28:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757890AbXGIQXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 12:23:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41954 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757799AbXGIQXg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 12:23:36 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com, David Teigland <teigland@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH] [DLM] fix new_lockspace error exit [5/6]
Date: Mon,  9 Jul 2007 17:02:21 +0100
Message-Id: <11839970204036-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11839970182635-git-send-email-swhiteho@redhat.com>
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
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Teigland <teigland@redhat.com>

Fix the error path when exiting new_lockspace().  It was kfree'ing the
lockspace struct at the end, but that's only valid if it exits before
kobject_register occured.  After kobject_register we have to let the
kobject do the freeing.

Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/dlm/lockspace.c b/fs/dlm/lockspace.c
index 339a204..a3a50e6 100644
--- a/fs/dlm/lockspace.c
+++ b/fs/dlm/lockspace.c
@@ -400,6 +400,7 @@ static int new_lockspace(char *name, int namelen, void **lockspace,
 {
 	struct dlm_ls *ls;
 	int i, size, error = -ENOMEM;
+	int do_unreg = 0;
 
 	if (namelen > DLM_LOCKSPACE_LEN)
 		return -EINVAL;
@@ -525,32 +526,34 @@ static int new_lockspace(char *name, int namelen, void **lockspace,
 	error = dlm_recoverd_start(ls);
 	if (error) {
 		log_error(ls, "can't start dlm_recoverd %d", error);
-		goto out_rcomfree;
+		goto out_delist;
 	}
 
-	dlm_create_debug_file(ls);
-
 	error = kobject_setup(ls);
 	if (error)
-		goto out_del;
+		goto out_stop;
 
 	error = kobject_register(&ls->ls_kobj);
 	if (error)
-		goto out_del;
+		goto out_stop;
+
+	/* let kobject handle freeing of ls if there's an error */
+	do_unreg = 1;
 
 	error = do_uevent(ls, 1);
 	if (error)
-		goto out_unreg;
+		goto out_stop;
+
+	dlm_create_debug_file(ls);
+
+	log_debug(ls, "join complete");
 
 	*lockspace = ls;
 	return 0;
 
- out_unreg:
-	kobject_unregister(&ls->ls_kobj);
- out_del:
-	dlm_delete_debug_file(ls);
+ out_stop:
 	dlm_recoverd_stop(ls);
- out_rcomfree:
+ out_delist:
 	spin_lock(&lslist_lock);
 	list_del(&ls->ls_list);
 	spin_unlock(&lslist_lock);
@@ -562,7 +565,10 @@ static int new_lockspace(char *name, int namelen, void **lockspace,
  out_rsbfree:
 	kfree(ls->ls_rsbtbl);
  out_lsfree:
-	kfree(ls);
+	if (do_unreg)
+		kobject_unregister(&ls->ls_kobj);
+	else
+		kfree(ls);
  out:
 	module_put(THIS_MODULE);
 	return error;
@@ -708,7 +714,7 @@ static int release_lockspace(struct dlm_ls *ls, int force)
 	dlm_clear_members_gone(ls);
 	kfree(ls->ls_node_array);
 	kobject_unregister(&ls->ls_kobj);
-        /* The ls structure will be freed when the kobject is done with */
+	/* The ls structure will be freed when the kobject is done with */
 
 	mutex_lock(&ls_lock);
 	ls_count--;
-- 
1.5.1.2

