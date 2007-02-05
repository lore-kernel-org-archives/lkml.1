Return-Path: <linux-kernel-owner+w=401wt.eu-S932608AbXBEOCH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932608AbXBEOCH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 09:02:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932659AbXBEOCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 09:02:06 -0500
Received: from mx1.redhat.com ([66.187.233.31]:40634 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932608AbXBEOB7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 09:01:59 -0500
Subject: [DLM] fix resend rcom lock [2/54]
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Teigland <teigland@redhat.com>, cluster-devel@redhat.com
In-Reply-To: <1170684425.11001.267.camel@quoit.chygwyn.com>
References: <1170684425.11001.267.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd
Date: Mon, 05 Feb 2007 14:09:59 +0000
Message-Id: <1170684599.11001.273.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 3f75e071fc3e5479800614656492230a1ce50182 Mon Sep 17 00:00:00 2001
From: David Teigland <teigland@redhat.com>
Date: Wed, 13 Dec 2006 10:36:37 -0600
Subject: [PATCH] [DLM] fix resend rcom lock

There's a chance the new master of resource hasn't learned it's the new
master before another node sends it a lock during recovery.  The node
sending the lock needs to resend if this happens.

- A sends a master lookup for resource R to C
- B sends a master lookup for resource R to C
- C receives A's lookup, assigns A to be master of R and
  sends a reply back to A
- C receives B's lookup and sends a reply back to B saying
  that A is the master
- B receives lookup reply from C and sends its lock for R to A
- A receives lock from B, doesn't think it's the master of R
  and sends an error back to B
- A receives lookup reply from C and becomes master of R
- B gets error back from A and resends its lock back to A
  (this resending is what this patch does)
- A receives lock from B, it now sees it's the master of R
  and takes the lock

Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index 30878de..69ada58 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -3571,6 +3571,14 @@ int dlm_recover_process_copy(struct dlm_ls *ls, struct dlm_rcom *rc)
 	lock_rsb(r);
 
 	switch (error) {
+	case -EBADR:
+		/* There's a chance the new master received our lock before
+		   dlm_recover_master_reply(), this wouldn't happen if we did
+		   a barrier between recover_masters and recover_locks. */
+		log_debug(ls, "master copy not ready %x r %lx %s", lkb->lkb_id,
+			  (unsigned long)r, r->res_name);
+		dlm_send_rcom_lock(r, lkb);
+		goto out;
 	case -EEXIST:
 		log_debug(ls, "master copy exists %x", lkb->lkb_id);
 		/* fall through */
@@ -3585,7 +3593,7 @@ int dlm_recover_process_copy(struct dlm_ls *ls, struct dlm_rcom *rc)
 	/* an ack for dlm_recover_locks() which waits for replies from
 	   all the locks it sends to new masters */
 	dlm_recovered_lock(r);
-
+ out:
 	unlock_rsb(r);
 	put_rsb(r);
 	dlm_put_lkb(lkb);
-- 
1.4.4.2



