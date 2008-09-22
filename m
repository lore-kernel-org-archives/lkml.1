Return-Path: <linux-kernel-owner+w=401wt.eu-S1754836AbYIVSl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836AbYIVSl7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 14:41:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753856AbYIVSkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 14:40:45 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54653 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752970AbYIVSkm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 14:40:42 -0400
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] dlm: remove bkl
Date: Mon, 22 Sep 2008 13:28:38 -0500
Message-Id: <1222108119-24928-6-git-send-email-teigland@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BLK from recent pushdown is not needed.

Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/user.c |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/fs/dlm/user.c b/fs/dlm/user.c
index 81627b5..b3832c6 100644
--- a/fs/dlm/user.c
+++ b/fs/dlm/user.c
@@ -15,7 +15,6 @@
 #include <linux/poll.h>
 #include <linux/signal.h>
 #include <linux/spinlock.h>
-#include <linux/smp_lock.h>
 #include <linux/dlm.h>
 #include <linux/dlm_device.h>
 
@@ -637,17 +636,13 @@ static int device_open(struct inode *inode, struct file *file)
 	struct dlm_user_proc *proc;
 	struct dlm_ls *ls;
 
-	lock_kernel();
 	ls = dlm_find_lockspace_device(iminor(inode));
-	if (!ls) {
-		unlock_kernel();
+	if (!ls)
 		return -ENOENT;
-	}
 
 	proc = kzalloc(sizeof(struct dlm_user_proc), GFP_KERNEL);
 	if (!proc) {
 		dlm_put_lockspace(ls);
-		unlock_kernel();
 		return -ENOMEM;
 	}
 
@@ -659,7 +654,6 @@ static int device_open(struct inode *inode, struct file *file)
 	spin_lock_init(&proc->locks_spin);
 	init_waitqueue_head(&proc->wait);
 	file->private_data = proc;
-	unlock_kernel();
 
 	return 0;
 }
@@ -914,7 +908,6 @@ int dlm_user_daemon_available(void)
 
 static int ctl_device_open(struct inode *inode, struct file *file)
 {
-	cycle_kernel_lock();
 	file->private_data = NULL;
 	return 0;
 }
-- 
1.5.5.1

