Return-Path: <linux-kernel-owner+w=401wt.eu-S1755844AbZAVQew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844AbZAVQew (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 11:34:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753380AbZAVQem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 11:34:42 -0500
Received: from mx2.redhat.com ([66.187.237.31]:60533 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753237AbZAVQem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 11:34:42 -0500
From: Jeff Layton <jlayton@redhat.com>
To: smfrench@gmail.com
Cc: linux-cifs-client@lists.samba.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] cifs: wrap cifs_dnotify_thread in CONFIG_BROKEN
Date: Thu, 22 Jan 2009 11:34:38 -0500
Message-Id: <1232642078-9717-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This thread never actually did anything useful, so comment it out by
#ifdef'ing it in CONFIG_BROKEN. My preference would be to remove it
altogether, but it's not my call.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/cifs/cifsfs.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 13ea532..5a9ed5f 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -65,9 +65,8 @@ unsigned int extended_security = CIFSSEC_DEF;
 unsigned int sign_CIFS_PDUs = 1;
 extern struct task_struct *oplockThread; /* remove sparse warning */
 struct task_struct *oplockThread = NULL;
-/* extern struct task_struct * dnotifyThread; remove sparse warning */
-#ifdef CONFIG_CIFS_EXPERIMENTAL
-static struct task_struct *dnotifyThread = NULL;
+#ifdef CONFIG_BROKEN
+static struct task_struct *dnotifyThread;
 #endif
 static const struct super_operations cifs_super_ops;
 unsigned int CIFSMaxBufSize = CIFS_MAX_MSGSIZE;
@@ -1039,7 +1038,7 @@ static int cifs_oplock_thread(void *dummyarg)
 	return 0;
 }
 
-#ifdef CONFIG_CIFS_EXPERIMENTAL
+#ifdef CONFIG_BROKEN
 static int cifs_dnotify_thread(void *dummyarg)
 {
 	struct list_head *tmp;
@@ -1143,7 +1142,7 @@ init_cifs(void)
 		goto out_unregister_dfs_key_type;
 	}
 
-#ifdef CONFIG_CIFS_EXPERIMENTAL
+#ifdef CONFIG_BROKEN
 	dnotifyThread = kthread_run(cifs_dnotify_thread, NULL, "cifsdnotifyd");
 	if (IS_ERR(dnotifyThread)) {
 		rc = PTR_ERR(dnotifyThread);
@@ -1154,7 +1153,7 @@ init_cifs(void)
 
 	return 0;
 
-#ifdef CONFIG_CIFS_EXPERIMENTAL
+#ifdef CONFIG_BROKEN
  out_stop_oplock_thread:
 #endif
 	kthread_stop(oplockThread);
@@ -1195,7 +1194,7 @@ exit_cifs(void)
 	cifs_destroy_inodecache();
 	cifs_destroy_mids();
 	cifs_destroy_request_bufs();
-#ifdef CONFIG_CIFS_EXPERIMENTAL
+#ifdef CONFIG_BROKEN
 	kthread_stop(dnotifyThread);
 #endif
 	kthread_stop(oplockThread);
-- 
1.5.5.6

