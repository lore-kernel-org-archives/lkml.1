Return-Path: <linux-kernel-owner+w=401wt.eu-S1764195AbYETQj5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764195AbYETQj5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 12:39:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755622AbYETQjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 12:39:42 -0400
Received: from gv-out-0910.google.com ([216.239.58.190]:34514 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755278AbYETQjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 12:39:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=rfQgC5dBGKJEUQsZfHZqGpRZ6miZDeHOYBXSAImZx759K1y32R5cd28J5bUJ8IIixpPv3rdZYZ6DkR7UZCo2tTT7K30PI9StBOfkrLjqC/XR3J/QMaG0AEQ8IG3ylPmXtN2wxDtn83dfp8wip9ySCXN4sy6hjrRhyTVr8quTcsI=
Date: Tue, 20 May 2008 20:39:28 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Michael A. Halcrow" <mhalcrow@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] eCryptFS: mutex lock-unlock ordering fix
Message-ID: <20080520163928.GA6926@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should lock/unlock mutexes by a proper way which means
there should not be chains like ABAB but ABBA otherwise the
race window is opened.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Michael A. Halcrow <mhalcrow@us.ibm.com>
---

Michael, could you test it please? To be honest I see that
my patch makes source looks ugly unfirtunelly... thoughts?
Any comments are welcome. Maybe I missed something - but I think
the chain LOCK: hash_mux -> mux, UNLOCK: hash_mux -> mux is a bit
weird ;) so please check if I'm wrong.

Index: linux-2.6.git/fs/ecryptfs/miscdev.c
===================================================================
--- linux-2.6.git.orig/fs/ecryptfs/miscdev.c	2008-05-18 18:53:56.000000000 +0400
+++ linux-2.6.git/fs/ecryptfs/miscdev.c	2008-05-20 20:27:33.000000000 +0400
@@ -50,7 +50,6 @@ ecryptfs_miscdev_poll(struct file *file,
 					  current->nsproxy->user_ns);
 	BUG_ON(rc || !daemon);
 	mutex_lock(&daemon->mux);
-	mutex_unlock(&ecryptfs_daemon_hash_mux);
 	if (daemon->flags & ECRYPTFS_DAEMON_ZOMBIE) {
 		printk(KERN_WARNING "%s: Attempt to poll on zombified "
 		       "daemon\n", __func__);
@@ -62,6 +61,7 @@ ecryptfs_miscdev_poll(struct file *file,
 		goto out_unlock_daemon;
 	daemon->flags |= ECRYPTFS_DAEMON_IN_POLL;
 	mutex_unlock(&daemon->mux);
+	mutex_unlock(&ecryptfs_daemon_hash_mux);
 	poll_wait(file, &daemon->wait, pt);
 	mutex_lock(&daemon->mux);
 	if (!list_empty(&daemon->msg_ctx_out_queue))
@@ -69,6 +69,8 @@ ecryptfs_miscdev_poll(struct file *file,
 out_unlock_daemon:
 	daemon->flags &= ~ECRYPTFS_DAEMON_IN_POLL;
 	mutex_unlock(&daemon->mux);
+	if (mutex_is_locked(&ecryptfs_daemon_hash_mux))
+		mutex_unlock(&ecryptfs_daemon_hash_mux);
 	return mask;
 }
 
@@ -257,24 +259,23 @@ ecryptfs_miscdev_read(struct file *file,
 	mutex_lock(&daemon->mux);
 	if (daemon->flags & ECRYPTFS_DAEMON_ZOMBIE) {
 		rc = 0;
-		mutex_unlock(&ecryptfs_daemon_hash_mux);
 		printk(KERN_WARNING "%s: Attempt to read from zombified "
 		       "daemon\n", __func__);
 		goto out_unlock_daemon;
 	}
 	if (daemon->flags & ECRYPTFS_DAEMON_IN_READ) {
 		rc = 0;
-		mutex_unlock(&ecryptfs_daemon_hash_mux);
 		goto out_unlock_daemon;
 	}
 	/* This daemon will not go away so long as this flag is set */
 	daemon->flags |= ECRYPTFS_DAEMON_IN_READ;
-	mutex_unlock(&ecryptfs_daemon_hash_mux);
 check_list:
 	if (list_empty(&daemon->msg_ctx_out_queue)) {
+		if (mutex_is_locked(&ecryptfs_daemon_hash_mux))
+			mutex_unlock(&ecryptfs_daemon_hash_mux);
 		mutex_unlock(&daemon->mux);
-		rc = wait_event_interruptible(
-			daemon->wait, !list_empty(&daemon->msg_ctx_out_queue));
+		rc = wait_event_interruptible(daemon->wait,
+			!list_empty(&daemon->msg_ctx_out_queue));
 		mutex_lock(&daemon->mux);
 		if (rc < 0) {
 			rc = 0;
@@ -357,6 +358,8 @@ out_unlock_msg_ctx:
 out_unlock_daemon:
 	daemon->flags &= ~ECRYPTFS_DAEMON_IN_READ;
 	mutex_unlock(&daemon->mux);
+	if (mutex_is_locked(&ecryptfs_daemon_hash_mux))
+		mutex_unlock(&ecryptfs_daemon_hash_mux);
 	return rc;
 }
 
