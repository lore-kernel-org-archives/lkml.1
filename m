Return-Path: <linux-kernel-owner+w=401wt.eu-S932921AbXBEOdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932921AbXBEOdZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 09:33:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932926AbXBEOdZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 09:33:25 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52514 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932905AbXBEOdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 09:33:24 -0500
Subject: [DLM] can miss clearing resend flag
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Teigland <teigland@redhat.com>, cluster-devel@redhat.com
In-Reply-To: <1170684425.11001.267.camel@quoit.chygwyn.com>
References: <1170684425.11001.267.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd
Date: Mon, 05 Feb 2007 14:41:24 +0000
Message-Id: <1170686484.11001.355.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 61a6511f5e603c0baadf542f632981248fdc7266 Mon Sep 17 00:00:00 2001
From: David Teigland <teigland@redhat.com>
Date: Wed, 24 Jan 2007 10:21:33 -0600
Subject: [PATCH] [DLM] can miss clearing resend flag

A long, complicated sequence of events, beginning with the RESEND flag not
being cleared on an lkb, can result in an unlock never completing.

- lkb on waiters list for remote lookup
- the remote node is both the dir node and the master node, so
  it optimizes the lookup into a request and sends a request
  reply back
- the request reply is saved on the requestqueue to be processed
  after recovery
- recovery runs dlm_recover_waiters_pre() which sets RESEND flag
  so the lookup will be resent after recovery
- end of recovery: process_requestqueue takes saved request reply
  which removes the lkb off the waitesr list, _without_ clearing
  the RESEND flag
- end of recovery: dlm_recover_waiters_post() doesn't do anything
  with the now completed lookup lkb (would usually clear RESEND)
- later, the node unmounts, unlocks this lkb that still has RESEND
  flag set
- the lkb is on the waiters list again, now for unlock, when recovery
  occurs, dlm_recover_waiters_pre() shows the lkb for unlock with RESEND
  set, doesn't do anything since the master still exists
- end of recovery: dlm_recover_waiters_post() takes this lkb off
  the waiters list because it has the RESEND flag set, then reports
  an error because unlocks are never supposed to be handled in
  recover_waiters_post().
- later, the unlock reply is received, doesn't find the lkb on
  the waiters list because recover_waiters_post() has wrongly
  removed it.
- the unlock operation has been lost, and we're left with a
  stray granted lock
- unmount spins waiting for the unlock to complete

The visible evidence of this problem will be a node where gfs umount is
spinning, the dlm waiters list will be empty, and the dlm locks list will
show a granted lock.

The fix is simply to clear the RESEND flag when taking an lkb off the
waiters list.

Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index 7c7ac2a..c10257f 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -754,6 +754,11 @@ static void add_to_waiters(struct dlm_lkb *lkb, int mstype)
 	mutex_unlock(&ls->ls_waiters_mutex);
 }
 
+/* We clear the RESEND flag because we might be taking an lkb off the waiters
+   list as part of process_requestqueue (e.g. a lookup that has an optimized
+   request reply on the requestqueue) between dlm_recover_waiters_pre() which
+   set RESEND and dlm_recover_waiters_post() */
+
 static int _remove_from_waiters(struct dlm_lkb *lkb)
 {
 	int error = 0;
@@ -764,6 +769,7 @@ static int _remove_from_waiters(struct dlm_lkb *lkb)
 		goto out;
 	}
 	lkb->lkb_wait_type = 0;
+	lkb->lkb_flags &= ~DLM_IFL_RESEND;
 	list_del(&lkb->lkb_wait_reply);
 	unhold_lkb(lkb);
  out:
-- 
1.4.4.2



