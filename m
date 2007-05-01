Return-Path: <linux-kernel-owner+w=401wt.eu-S1423462AbXEAKZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423462AbXEAKZ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 06:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423552AbXEAKZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 06:25:29 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52837 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423462AbXEAKZW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 06:25:22 -0400
Subject: [DLM] fix mode munging [27/34]
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com
Cc: linux-kernel@vger.kernel.org, David Teigland <teigland@redhat.com>
In-Reply-To: <1178013376.5462.127.camel@quoit.chygwyn.com>
References: <1178013376.5462.127.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Tue, 01 May 2007 11:20:48 +0100
Message-Id: <1178014848.5462.184.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 7d3c1feb80913ba4253c3517d48b9b3741c44fc9 Mon Sep 17 00:00:00 2001
From: David Teigland <teigland@redhat.com>
Date: Thu, 19 Apr 2007 10:30:41 -0500
Subject: [PATCH] [DLM] fix mode munging

There are flags to enable two specialized features in the dlm:
1. CONVDEADLK causes the dlm to resolve conversion deadlocks internally by
   changing the granted mode of locks to NL.
2. ALTPR/ALTCW cause the dlm to change the requested mode of locks to PR
   or CW to grant them if the normal requested mode can't be granted.

GFS direct i/o exercises both of these features, especially when mixed
with buffered i/o.  The dlm has problems with them.

The first problem is on the master node. If it demotes a lock as a part of
converting it, the actual step of converting the lock isn't being done
after the demotion, the lock is just left sitting on the granted queue
with a granted mode of NL.  I think the mistaken assumption was that the
call to grant_pending_locks() would grant it, but that function naturally
doesn't look at locks on the granted queue.

The second problem is on the process node.  If the master either demotes
or gives an altmode, the munging of the gr/rq modes is never done in the
process copy of the lock, leaving the master/process copies out of sync.

Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index eac54d2..d8d6e72 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -224,6 +224,16 @@ static inline int is_demoted(struct dlm_lkb *lkb)
 	return (lkb->lkb_sbflags & DLM_SBF_DEMOTED);
 }
 
+static inline int is_altmode(struct dlm_lkb *lkb)
+{
+	return (lkb->lkb_sbflags & DLM_SBF_ALTMODE);
+}
+
+static inline int is_granted(struct dlm_lkb *lkb)
+{
+	return (lkb->lkb_status == DLM_LKSTS_GRANTED);
+}
+
 static inline int is_remote(struct dlm_rsb *r)
 {
 	DLM_ASSERT(r->res_nodeid >= 0, dlm_print_rsb(r););
@@ -1191,6 +1201,50 @@ static void grant_lock_pending(struct dlm_rsb *r, struct dlm_lkb *lkb)
 		queue_cast(r, lkb, 0);
 }
 
+/* The special CONVDEADLK, ALTPR and ALTCW flags allow the master to
+   change the granted/requested modes.  We're munging things accordingly in
+   the process copy.
+   CONVDEADLK: our grmode may have been forced down to NL to resolve a
+   conversion deadlock
+   ALTPR/ALTCW: our rqmode may have been changed to PR or CW to become
+   compatible with other granted locks */
+
+static void munge_demoted(struct dlm_lkb *lkb, struct dlm_message *ms)
+{
+	if (ms->m_type != DLM_MSG_CONVERT_REPLY) {
+		log_print("munge_demoted %x invalid reply type %d",
+			  lkb->lkb_id, ms->m_type);
+		return;
+	}
+
+	if (lkb->lkb_rqmode == DLM_LOCK_IV || lkb->lkb_grmode == DLM_LOCK_IV) {
+		log_print("munge_demoted %x invalid modes gr %d rq %d",
+			  lkb->lkb_id, lkb->lkb_grmode, lkb->lkb_rqmode);
+		return;
+	}
+
+	lkb->lkb_grmode = DLM_LOCK_NL;
+}
+
+static void munge_altmode(struct dlm_lkb *lkb, struct dlm_message *ms)
+{
+	if (ms->m_type != DLM_MSG_REQUEST_REPLY &&
+	    ms->m_type != DLM_MSG_GRANT) {
+		log_print("munge_altmode %x invalid reply type %d",
+			  lkb->lkb_id, ms->m_type);
+		return;
+	}
+
+	if (lkb->lkb_exflags & DLM_LKF_ALTPR)
+		lkb->lkb_rqmode = DLM_LOCK_PR;
+	else if (lkb->lkb_exflags & DLM_LKF_ALTCW)
+		lkb->lkb_rqmode = DLM_LOCK_CW;
+	else {
+		log_print("munge_altmode invalid exflags %x", lkb->lkb_exflags);
+		dlm_print_lkb(lkb);
+	}
+}
+
 static inline int first_in_list(struct dlm_lkb *lkb, struct list_head *head)
 {
 	struct dlm_lkb *first = list_entry(head->next, struct dlm_lkb,
@@ -1965,9 +2019,24 @@ static int do_convert(struct dlm_rsb *r, struct dlm_lkb *lkb)
 		goto out;
 	}
 
-	if (can_be_queued(lkb)) {
-		if (is_demoted(lkb))
+	/* is_demoted() means the can_be_granted() above set the grmode
+	   to NL, and left us on the granted queue.  This auto-demotion
+	   (due to CONVDEADLK) might mean other locks, and/or this lock, are
+	   now grantable.  We have to try to grant other converting locks
+	   before we try again to grant this one. */
+
+	if (is_demoted(lkb)) {
+		grant_pending_convert(r, DLM_LOCK_IV);
+		if (_can_be_granted(r, lkb, 1)) {
+			grant_lock(r, lkb);
+			queue_cast(r, lkb, 0);
 			grant_pending_locks(r);
+			goto out;
+		}
+		/* else fall through and move to convert queue */
+	}
+
+	if (can_be_queued(lkb)) {
 		error = -EINPROGRESS;
 		del_lkb(r, lkb);
 		add_lkb(r, lkb, DLM_LKSTS_CONVERT);
@@ -2908,6 +2977,8 @@ static void receive_grant(struct dlm_ls *ls, struct dlm_message *ms)
 	lock_rsb(r);
 
 	receive_flags_reply(lkb, ms);
+	if (is_altmode(lkb))
+		munge_altmode(lkb, ms);
 	grant_lock_pc(r, lkb, ms);
 	queue_cast(r, lkb, 0);
 
@@ -3038,6 +3109,8 @@ static void receive_request_reply(struct dlm_ls *ls, struct dlm_message *ms)
 		/* request was queued or granted on remote master */
 		receive_flags_reply(lkb, ms);
 		lkb->lkb_remid = ms->m_lkid;
+		if (is_altmode(lkb))
+			munge_altmode(lkb, ms);
 		if (result)
 			add_lkb(r, lkb, DLM_LKSTS_WAITING);
 		else {
@@ -3101,6 +3174,9 @@ static void __receive_convert_reply(struct dlm_rsb *r, struct dlm_lkb *lkb,
 
 	case -EINPROGRESS:
 		/* convert was queued on remote master */
+		receive_flags_reply(lkb, ms);
+		if (is_demoted(lkb))
+			munge_demoted(lkb, ms);
 		del_lkb(r, lkb);
 		add_lkb(r, lkb, DLM_LKSTS_CONVERT);
 		break;
@@ -3108,6 +3184,8 @@ static void __receive_convert_reply(struct dlm_rsb *r, struct dlm_lkb *lkb,
 	case 0:
 		/* convert was granted on remote master */
 		receive_flags_reply(lkb, ms);
+		if (is_demoted(lkb))
+			munge_demoted(lkb, ms);
 		grant_lock_pc(r, lkb, ms);
 		queue_cast(r, lkb, 0);
 		break;
-- 
1.5.1.2



