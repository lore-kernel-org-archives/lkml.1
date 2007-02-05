Return-Path: <linux-kernel-owner+w=401wt.eu-S932612AbXBEOYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932612AbXBEOYt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 09:24:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932831AbXBEOYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 09:24:48 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49492 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932846AbXBEOYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 09:24:47 -0500
Subject: [GFS2] Shrink gfs2_inode memory by half [29/54]
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com
In-Reply-To: <1170684425.11001.267.camel@quoit.chygwyn.com>
References: <1170684425.11001.267.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd
Date: Mon, 05 Feb 2007 14:32:51 +0000
Message-Id: <1170685971.11001.329.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 6be1a543bdaf360ab499e401ca5a0105a9923d75 Mon Sep 17 00:00:00 2001
From: Steven Whitehouse <swhiteho@redhat.com>
Date: Wed, 17 Jan 2007 15:33:23 +0000
Subject: [PATCH] [GFS2] Shrink gfs2_inode memory by half

Here is something I spotted (while looking for something entirely
different) the other day.

Rather than using a completion in each and every struct gfs2_holder,
this removes it in favour of hashed wait queues, thus saving a
considerable amount of memory both on the stack (where a number of
gfs2_holder structures are allocated) and in particular in the
gfs2_inode which has 8 gfs2_holder structures embedded within it.

As a result on x86_64 the gfs2_inode shrinks from 2488 bytes to
1912 bytes, a saving of 576 bytes per inode (no thats not a typo!).
In actual practice we get a much better result than that since
now that a gfs2_inode is under the 2048 byte barrier, we get two
per 4k slab page effectively halving the amount of memory required
to store gfs2_inodes.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index fb1960b..5341e03 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -19,6 +19,7 @@
 #include <linux/gfs2_ondisk.h>
 #include <linux/list.h>
 #include <linux/lm_interface.h>
+#include <linux/wait.h>
 #include <asm/uaccess.h>
 
 #include "gfs2.h"
@@ -395,7 +396,6 @@ void gfs2_holder_init(struct gfs2_glock *gl, unsigned int state, unsigned flags,
 	gh->gh_flags = flags;
 	gh->gh_error = 0;
 	gh->gh_iflags = 0;
-	init_completion(&gh->gh_wait);
 
 	if (gh->gh_state == LM_ST_EXCLUSIVE)
 		gh->gh_flags |= GL_LOCAL_EXCL;
@@ -479,6 +479,29 @@ static void gfs2_holder_put(struct gfs2_holder *gh)
 	kfree(gh);
 }
 
+static void gfs2_holder_dispose_or_wake(struct gfs2_holder *gh)
+{
+	if (test_bit(HIF_DEALLOC, &gh->gh_iflags)) {
+		gfs2_holder_put(gh);
+		return;
+	}
+	clear_bit(HIF_WAIT, &gh->gh_iflags);
+	smp_mb();
+	wake_up_bit(&gh->gh_iflags, HIF_WAIT);
+}
+
+static int holder_wait(void *word)
+{
+        schedule();
+        return 0;
+}
+
+static void wait_on_holder(struct gfs2_holder *gh)
+{
+	might_sleep();
+	wait_on_bit(&gh->gh_iflags, HIF_WAIT, holder_wait, TASK_UNINTERRUPTIBLE);
+}
+
 /**
  * rq_mutex - process a mutex request in the queue
  * @gh: the glock holder
@@ -493,7 +516,9 @@ static int rq_mutex(struct gfs2_holder *gh)
 	list_del_init(&gh->gh_list);
 	/*  gh->gh_error never examined.  */
 	set_bit(GLF_LOCK, &gl->gl_flags);
-	complete(&gh->gh_wait);
+	clear_bit(HIF_WAIT, &gh->gh_flags);
+	smp_mb();
+	wake_up_bit(&gh->gh_iflags, HIF_WAIT);
 
 	return 1;
 }
@@ -549,7 +574,7 @@ static int rq_promote(struct gfs2_holder *gh)
 	gh->gh_error = 0;
 	set_bit(HIF_HOLDER, &gh->gh_iflags);
 
-	complete(&gh->gh_wait);
+	gfs2_holder_dispose_or_wake(gh);
 
 	return 0;
 }
@@ -573,10 +598,7 @@ static int rq_demote(struct gfs2_holder *gh)
 		list_del_init(&gh->gh_list);
 		gh->gh_error = 0;
 		spin_unlock(&gl->gl_spin);
-		if (test_bit(HIF_DEALLOC, &gh->gh_iflags))
-			gfs2_holder_put(gh);
-		else
-			complete(&gh->gh_wait);
+		gfs2_holder_dispose_or_wake(gh);
 		spin_lock(&gl->gl_spin);
 	} else {
 		gl->gl_req_gh = gh;
@@ -684,6 +706,8 @@ static void gfs2_glmutex_lock(struct gfs2_glock *gl)
 
 	gfs2_holder_init(gl, 0, 0, &gh);
 	set_bit(HIF_MUTEX, &gh.gh_iflags);
+	if (test_and_set_bit(HIF_WAIT, &gh.gh_iflags))
+		BUG();
 
 	spin_lock(&gl->gl_spin);
 	if (test_and_set_bit(GLF_LOCK, &gl->gl_flags)) {
@@ -691,11 +715,13 @@ static void gfs2_glmutex_lock(struct gfs2_glock *gl)
 	} else {
 		gl->gl_owner = current;
 		gl->gl_ip = (unsigned long)__builtin_return_address(0);
-		complete(&gh.gh_wait);
+		clear_bit(HIF_WAIT, &gh.gh_iflags);
+		smp_mb();
+		wake_up_bit(&gh.gh_iflags, HIF_WAIT);
 	}
 	spin_unlock(&gl->gl_spin);
 
-	wait_for_completion(&gh.gh_wait);
+	wait_on_holder(&gh);
 	gfs2_holder_uninit(&gh);
 }
 
@@ -774,6 +800,7 @@ restart:
 			return;
 		set_bit(HIF_DEMOTE, &new_gh->gh_iflags);
 		set_bit(HIF_DEALLOC, &new_gh->gh_iflags);
+		set_bit(HIF_WAIT, &new_gh->gh_iflags);
 
 		goto restart;
 	}
@@ -908,12 +935,8 @@ static void xmote_bh(struct gfs2_glock *gl, unsigned int ret)
 
 	gfs2_glock_put(gl);
 
-	if (gh) {
-		if (test_bit(HIF_DEALLOC, &gh->gh_iflags))
-			gfs2_holder_put(gh);
-		else
-			complete(&gh->gh_wait);
-	}
+	if (gh)
+		gfs2_holder_dispose_or_wake(gh);
 }
 
 /**
@@ -999,12 +1022,8 @@ static void drop_bh(struct gfs2_glock *gl, unsigned int ret)
 
 	gfs2_glock_put(gl);
 
-	if (gh) {
-		if (test_bit(HIF_DEALLOC, &gh->gh_iflags))
-			gfs2_holder_put(gh);
-		else
-			complete(&gh->gh_wait);
-	}
+	if (gh)
+		gfs2_holder_dispose_or_wake(gh);
 }
 
 /**
@@ -1105,8 +1124,7 @@ static int glock_wait_internal(struct gfs2_holder *gh)
 	if (gh->gh_flags & LM_FLAG_PRIORITY)
 		do_cancels(gh);
 
-	wait_for_completion(&gh->gh_wait);
-
+	wait_on_holder(gh);
 	if (gh->gh_error)
 		return gh->gh_error;
 
@@ -1162,6 +1180,8 @@ static void add_to_queue(struct gfs2_holder *gh)
 	struct gfs2_holder *existing;
 
 	BUG_ON(!gh->gh_owner);
+	if (test_and_set_bit(HIF_WAIT, &gh->gh_iflags))
+		BUG();
 
 	existing = find_holder_by_owner(&gl->gl_holders, gh->gh_owner);
 	if (existing) {
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 9114851..a24c4af 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -128,6 +128,7 @@ enum {
 	HIF_HOLDER		= 6,
 	HIF_FIRST		= 7,
 	HIF_ABORTED		= 9,
+	HIF_WAIT		= 10,
 };
 
 struct gfs2_holder {
@@ -140,7 +141,6 @@ struct gfs2_holder {
 
 	int gh_error;
 	unsigned long gh_iflags;
-	struct completion gh_wait;
 	unsigned long gh_ip;
 };
 
-- 
1.4.4.2



