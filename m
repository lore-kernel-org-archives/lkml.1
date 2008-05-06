Return-Path: <linux-kernel-owner+w=401wt.eu-S933014AbYEFRwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933014AbYEFRwl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 13:52:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764391AbYEFRvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 13:51:54 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:3671 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932822AbYEFRvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 13:51:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=fIsUGSnEYvaFDXwhGKrYyny4RH+qOjN6LQr23DHi6Pj2rJGtMZWboC8bVirB/1dmETyrflWzUohfxmdD5KvO3XjYotjF6lS7QkTQ5SskIQUvVwvwmQo4Hcr0YYPnpYmYIo7G7HBrmS5Kq4L+Pp29+4WqU1tf/Ey6qfRTKY7KRlo=
From: Denis Cheng <crquan@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>, Steven Whitehouse <swhiteho@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] [GFS2] remove the duplicates of just_schedule
Date: Wed,  7 May 2008 01:51:04 +0800
Message-Id: <1210096264-27426-2-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1210096264-27426-1-git-send-email-crquan@gmail.com>
References: <1210096264-27426-1-git-send-email-crquan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Accroding to the former patch, just_schedule is available from fs/inode.c

Signed-off-by: Denis Cheng <crquan@gmail.com>
---
 fs/gfs2/glock.c                |    7 +------
 fs/gfs2/locking/dlm/lock.c     |    9 ++-------
 fs/gfs2/locking/dlm/lock_dlm.h |    1 +
 3 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index d636b3e..b39d827 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -29,6 +29,7 @@
 #include <linux/freezer.h>
 #include <linux/workqueue.h>
 #include <linux/jiffies.h>
+#include <linux/writeback.h>
 
 #include "gfs2.h"
 #include "incore.h"
@@ -454,12 +455,6 @@ static void gfs2_holder_wake(struct gfs2_holder *gh)
 	wake_up_bit(&gh->gh_iflags, HIF_WAIT);
 }
 
-static int just_schedule(void *word)
-{
-        schedule();
-        return 0;
-}
-
 static void wait_on_holder(struct gfs2_holder *gh)
 {
 	might_sleep();
diff --git a/fs/gfs2/locking/dlm/lock.c b/fs/gfs2/locking/dlm/lock.c
index cf7ea8a..2fb91a4 100644
--- a/fs/gfs2/locking/dlm/lock.c
+++ b/fs/gfs2/locking/dlm/lock.c
@@ -399,12 +399,6 @@ static void gdlm_del_lvb(struct gdlm_lock *lp)
 	lp->lksb.sb_lvbptr = NULL;
 }
 
-static int gdlm_ast_wait(void *word)
-{
-	schedule();
-	return 0;
-}
-
 /* This can do a synchronous dlm request (requiring a lock_dlm thread to get
    the completion) because gfs won't call hold_lvb() during a callback (from
    the context of a lock_dlm thread). */
@@ -433,7 +427,8 @@ static int hold_null_lock(struct gdlm_lock *lp)
 	set_bit(LFL_AST_WAIT, &lpn->flags);
 
 	gdlm_do_lock(lpn);
-	wait_on_bit(&lpn->flags, LFL_AST_WAIT, gdlm_ast_wait, TASK_UNINTERRUPTIBLE);
+	wait_on_bit(&lpn->flags, LFL_AST_WAIT, just_schedule,
+			TASK_UNINTERRUPTIBLE);
 	error = lpn->lksb.sb_status;
 	if (error) {
 		printk(KERN_INFO "lock_dlm: hold_null_lock dlm error %d\n",
diff --git a/fs/gfs2/locking/dlm/lock_dlm.h b/fs/gfs2/locking/dlm/lock_dlm.h
index a243cf6..407d00d 100644
--- a/fs/gfs2/locking/dlm/lock_dlm.h
+++ b/fs/gfs2/locking/dlm/lock_dlm.h
@@ -22,6 +22,7 @@
 #include <linux/kobject.h>
 #include <linux/fcntl.h>
 #include <linux/wait.h>
+#include <linux/writeback.h>
 #include <net/sock.h>
 
 #include <linux/dlm.h>
-- 
1.5.5.1

