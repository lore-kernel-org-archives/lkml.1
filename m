Return-Path: <linux-kernel-owner+w=401wt.eu-S1761296AbYAUKIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761296AbYAUKIm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 05:08:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759609AbYAUKC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 05:02:27 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35768 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759394AbYAUKCT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 05:02:19 -0500
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: David Teigland <teigland@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 18/58] [GFS2] check kthread_should_stop when waiting
Date: Mon, 21 Jan 2008 09:21:36 +0000
Message-Id: <12009073722253-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12009073701982-git-send-email-swhiteho@redhat.com>
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
Message-Id: <efa04e414fd6216d16e067a3bced8163c6197376.1200905287.git.swhiteho@redhat.com>
In-Reply-To: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
References: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Teigland <teigland@redhat.com>

Use wait_event_interruptible() in the lock_dlm thread instead
of an open coded equivalent, and include a kthread_should_stop()
check in the wait test so we don't miss a kthread_stop().

Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/locking/dlm/thread.c b/fs/gfs2/locking/dlm/thread.c
index bd938f0..521694f 100644
--- a/fs/gfs2/locking/dlm/thread.c
+++ b/fs/gfs2/locking/dlm/thread.c
@@ -273,18 +273,13 @@ static int gdlm_thread(void *data, int blist)
 	struct gdlm_ls *ls = (struct gdlm_ls *) data;
 	struct gdlm_lock *lp = NULL;
 	uint8_t complete, blocking, submit, drop;
-	DECLARE_WAITQUEUE(wait, current);
 
 	/* Only thread1 is allowed to do blocking callbacks since gfs
 	   may wait for a completion callback within a blocking cb. */
 
 	while (!kthread_should_stop()) {
-		set_current_state(TASK_INTERRUPTIBLE);
-		add_wait_queue(&ls->thread_wait, &wait);
-		if (no_work(ls, blist))
-			schedule();
-		remove_wait_queue(&ls->thread_wait, &wait);
-		set_current_state(TASK_RUNNING);
+		wait_event_interruptible(ls->thread_wait,
+				!no_work(ls, blist) || kthread_should_stop());
 
 		complete = blocking = submit = drop = 0;
 
-- 
1.5.1.2

