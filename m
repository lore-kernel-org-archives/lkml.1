Return-Path: <linux-kernel-owner+w=401wt.eu-S1763321AbYAUKK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763321AbYAUKK7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 05:10:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759790AbYAUKCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 05:02:38 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35788 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759740AbYAUKCe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 05:02:34 -0500
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Fabio Massimo Di Nitto <fabbione@ubuntu.com>,
       "David S. Miller" <davem@davemloft.net>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 25/58] [GFS2] Fix runtime issue with UP kernels
Date: Mon, 21 Jan 2008 09:21:43 +0000
Message-Id: <12009073841692-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12009073823161-git-send-email-swhiteho@redhat.com>
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
Message-Id: <54ef8f1d6dc14b392540209198dce8f21e01dbae.1200905287.git.swhiteho@redhat.com>
In-Reply-To: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
References: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Massimo Di Nitto <fabbione@ubuntu.com>

The issue is indeed UP vs SMP and it is totally random.

spin_is_locked() is a bad assertion because there is no correct answer on UP.
on UP spin_is_locked() has to return either one value or another, always.

This means that in my setup I am lucky enough to trigger the issue and your you
are lucky enough not to.

the patch in attachment removes the bogus calls to BUG_ON and according to David
(in CC and thanks for the long explanation on the problem) we can rely upon
things like lockdep to find problem that might be trying to catch.

Signed-off-by: Fabio M. Di Nitto <fabbione@ubuntu.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index d83df68..a7f3c46 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -217,7 +217,6 @@ int gfs2_glock_put(struct gfs2_glock *gl)
 	if (atomic_dec_and_test(&gl->gl_ref)) {
 		hlist_del(&gl->gl_list);
 		write_unlock(gl_lock_addr(gl->gl_hash));
-		BUG_ON(spin_is_locked(&gl->gl_spin));
 		gfs2_assert(sdp, gl->gl_state == LM_ST_UNLOCKED);
 		gfs2_assert(sdp, list_empty(&gl->gl_reclaim));
 		gfs2_assert(sdp, list_empty(&gl->gl_holders));
@@ -460,7 +459,6 @@ static void wait_on_holder(struct gfs2_holder *gh)
 
 static void gfs2_demote_wake(struct gfs2_glock *gl)
 {
-	BUG_ON(!spin_is_locked(&gl->gl_spin));
 	gl->gl_demote_state = LM_ST_EXCLUSIVE;
         clear_bit(GLF_DEMOTE, &gl->gl_flags);
         smp_mb__after_clear_bit();
@@ -680,7 +678,6 @@ static void gfs2_glmutex_unlock(struct gfs2_glock *gl)
 	gl->gl_owner_pid = 0;
 	gl->gl_ip = 0;
 	run_queue(gl);
-	BUG_ON(!spin_is_locked(&gl->gl_spin));
 	spin_unlock(&gl->gl_spin);
 }
 
diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index 4dcc7a8..96dcf05 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -92,8 +92,6 @@ static void gfs2_ail1_start_one(struct gfs2_sbd *sdp, struct gfs2_ail *ai)
 	struct buffer_head *bh;
 	int retry;
 
-	BUG_ON(!spin_is_locked(&sdp->sd_log_lock));
-
 	do {
 		retry = 0;
 
-- 
1.5.1.2

