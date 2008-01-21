Return-Path: <linux-kernel-owner+w=401wt.eu-S1764692AbYAUKQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764692AbYAUKQf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 05:16:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760051AbYAUKC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 05:02:59 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35808 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760017AbYAUKC4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 05:02:56 -0500
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 39/58] [GFS2] Reorganize function gfs2_glmutex_lock
Date: Mon, 21 Jan 2008 09:21:57 +0000
Message-Id: <12009074082286-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12009074074196-git-send-email-swhiteho@redhat.com>
References: <1200907336293-git-send-email-swhiteho@redhat.com>
 <12009073443813-git-send-email-swhiteho@redhat.com>
 <12009073453549-git-send-email-swhiteho@redhat.com>
 <1200907348435-git-send-email-swhiteho@redhat.com>
 <12009073492811-git-send-email-swhiteho@redhat.com>
 <12009073512300-git-send-email-swhiteho@redhat.com>
 <12009073531216-git-send-email-swhiteho@redhat.com>
 <12009073542596-git-send-email-swhiteho@redhat.com>
 <1200907356883-git-send-email-swhiteho@redhat.com>
 <12009073571991-git-send-email-swhiteho@redhat.com>
 <12009073591688-git-send-email-swhiteho@redhat.com>
 <12009073611695-git-send-email-swhiteho@redhat.com>
 <1200907362266-git-send-email-swhiteho@redhat.com>
 <12009073642512-git-send-email-swhiteho@redhat.com>
 <12009073662309-git-send-email-swhiteho@redhat.com>
 <12009073671755-git-send-email-swhiteho@redhat.com>
 <12009073698-git-send-email-swhiteho@redhat.com>
 <12009073701982-git-send-email-swhiteho@redhat.com>
 <12009073722253-git-send-email-swhiteho@redhat.com>
 <1200907374616-git-send-email-swhiteho@redhat.com>
 <12009073753723-git-send-email-swhiteho@redhat.com>
 <12009073771883-git-send-email-swhiteho@redhat.com>
 <1200907378664-git-send-email-swhiteho@redhat.com>
 <12009073803732-git-send-email-swhiteho@redhat.com>
 <12009073823161-git-send-email-swhiteho@redhat.com>
 <12009073841692-git-send-email-swhiteho@redhat.com>
 <12009073862261-git-send-email-swhiteho@redhat.com>
 <12009073883125-git-send-email-swhiteho@redhat.com>
 <12009073891848-git-send-email-swhiteho@redhat.com>
 <12009073913676-git-send-email-swhiteho@redhat.com>
 <12009073933630-git-send-email-swhiteho@redhat.com>
 <12009073953412-git-send-email-swhiteho@redhat.com>
 <1200907397123-git-send-email-swhiteho@redhat.com>
 <12009073981159-git-send-email-swhiteho@redhat.com>
 <12009074002775-git-send-email-swhiteho@redhat.com>
 <12009074021586-git-send-email-swhiteho@redhat.com>
 <12009074032614-git-send-email-swhiteho@redhat.com>
 <1200907405414-git-send-email-swhiteho@redhat.com>
 <12009074074196-git-send-email-swhiteho@redhat.com>
Message-Id: <beb922fe3a443dba9e6c23f30689d5f2f0adeca1.1200905287.git.swhiteho@redhat.com>
In-Reply-To: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
References: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch optimizes the function gfs2_glmutex_lock.
The basic theory is: Why bother initializing a holder, setting up
wait bits and then waiting on them, if you know the glock can be
yours.  So the holder stuff is placed inside the if checking if the
glock is locked.  This one needs careful scrutiny because changing
anything to do with locking should strike terror into one's heart.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index a7f3c46..80e09c5 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) Sistina Software, Inc.  1997-2003 All rights reserved.
- * Copyright (C) 2004-2006 Red Hat, Inc.  All rights reserved.
+ * Copyright (C) 2004-2007 Red Hat, Inc.  All rights reserved.
  *
  * This copyrighted material is made available to anyone wishing to use,
  * modify, copy, or redistribute it subject to the terms and conditions
@@ -620,26 +620,21 @@ static void run_queue(struct gfs2_glock *gl)
 
 static void gfs2_glmutex_lock(struct gfs2_glock *gl)
 {
-	struct gfs2_holder gh;
-
-	gfs2_holder_init(gl, 0, 0, &gh);
-	if (test_and_set_bit(HIF_WAIT, &gh.gh_iflags))
-		BUG();
-
 	spin_lock(&gl->gl_spin);
 	if (test_and_set_bit(GLF_LOCK, &gl->gl_flags)) {
+		struct gfs2_holder gh;
+
+		gfs2_holder_init(gl, 0, 0, &gh);
+		set_bit(HIF_WAIT, &gh.gh_iflags);
 		list_add_tail(&gh.gh_list, &gl->gl_waiters1);
+		spin_unlock(&gl->gl_spin);
+		wait_on_holder(&gh);
+		gfs2_holder_uninit(&gh);
 	} else {
 		gl->gl_owner_pid = current->pid;
 		gl->gl_ip = (unsigned long)__builtin_return_address(0);
-		clear_bit(HIF_WAIT, &gh.gh_iflags);
-		smp_mb();
-		wake_up_bit(&gh.gh_iflags, HIF_WAIT);
+		spin_unlock(&gl->gl_spin);
 	}
-	spin_unlock(&gl->gl_spin);
-
-	wait_on_holder(&gh);
-	gfs2_holder_uninit(&gh);
 }
 
 /**
-- 
1.5.1.2

