Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758113Ab0BXUjn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 15:39:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40935 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758056Ab0BXUjb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 15:39:31 -0500
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] dlm: send reply before bast
Date: Wed, 24 Feb 2010 14:39:17 -0600
Message-Id: <1267043958-31082-3-git-send-email-teigland@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the lock master processes a successful convert or request,
it will process the effects of that change before sending the
reply for the convert/request.  The effects are:

- blocking callbacks (basts) for the newly granted locks
- waiting or converting locks that can now be granted

The cast is queued on the local node when the reply from the lock
master is received.  This means that a lock holder can receive a
bast for a lock mode that is doesn't yet know has been granted.

Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/lock.c |   69 +++++++++++++++++++++++++++++++++++++++++++--------------
 1 files changed, 52 insertions(+), 17 deletions(-)

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index e08ea93..4f99a4e 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -2280,20 +2280,30 @@ static int do_request(struct dlm_rsb *r, struct dlm_lkb *lkb)
 	if (can_be_queued(lkb)) {
 		error = -EINPROGRESS;
 		add_lkb(r, lkb, DLM_LKSTS_WAITING);
-		send_blocking_asts(r, lkb);
 		add_timeout(lkb);
 		goto out;
 	}
 
 	error = -EAGAIN;
-	if (force_blocking_asts(lkb))
-		send_blocking_asts_all(r, lkb);
 	queue_cast(r, lkb, -EAGAIN);
-
  out:
 	return error;
 }
 
+static void do_request_effects(struct dlm_rsb *r, struct dlm_lkb *lkb,
+			       int error)
+{
+	switch (error) {
+	case -EAGAIN:
+		if (force_blocking_asts(lkb))
+			send_blocking_asts_all(r, lkb);
+		break;
+	case -EINPROGRESS:
+		send_blocking_asts(r, lkb);
+		break;
+	}
+}
+
 static int do_convert(struct dlm_rsb *r, struct dlm_lkb *lkb)
 {
 	int error = 0;
@@ -2304,7 +2314,6 @@ static int do_convert(struct dlm_rsb *r, struct dlm_lkb *lkb)
 	if (can_be_granted(r, lkb, 1, &deadlk)) {
 		grant_lock(r, lkb);
 		queue_cast(r, lkb, 0);
-		grant_pending_locks(r);
 		goto out;
 	}
 
@@ -2334,7 +2343,6 @@ static int do_convert(struct dlm_rsb *r, struct dlm_lkb *lkb)
 		if (_can_be_granted(r, lkb, 1)) {
 			grant_lock(r, lkb);
 			queue_cast(r, lkb, 0);
-			grant_pending_locks(r);
 			goto out;
 		}
 		/* else fall through and move to convert queue */
@@ -2344,20 +2352,34 @@ static int do_convert(struct dlm_rsb *r, struct dlm_lkb *lkb)
 		error = -EINPROGRESS;
 		del_lkb(r, lkb);
 		add_lkb(r, lkb, DLM_LKSTS_CONVERT);
-		send_blocking_asts(r, lkb);
 		add_timeout(lkb);
 		goto out;
 	}
 
 	error = -EAGAIN;
-	if (force_blocking_asts(lkb))
-		send_blocking_asts_all(r, lkb);
 	queue_cast(r, lkb, -EAGAIN);
-
  out:
 	return error;
 }
 
+static void do_convert_effects(struct dlm_rsb *r, struct dlm_lkb *lkb,
+			       int error)
+{
+	switch (error) {
+	case 0:
+		grant_pending_locks(r);
+		/* grant_pending_locks also sends basts */
+		break;
+	case -EAGAIN:
+		if (force_blocking_asts(lkb))
+			send_blocking_asts_all(r, lkb);
+		break;
+	case -EINPROGRESS:
+		send_blocking_asts(r, lkb);
+		break;
+	}
+}
+
 static int do_unlock(struct dlm_rsb *r, struct dlm_lkb *lkb)
 {
 	remove_lock(r, lkb);
@@ -2402,11 +2424,15 @@ static int _request_lock(struct dlm_rsb *r, struct dlm_lkb *lkb)
 		goto out;
 	}
 
-	if (is_remote(r))
+	if (is_remote(r)) {
 		/* receive_request() calls do_request() on remote node */
 		error = send_request(r, lkb);
-	else
+	} else {
 		error = do_request(r, lkb);
+		/* for remote locks the request_reply is sent
+		   between do_request and do_request_effects */
+		do_request_effects(r, lkb, error);
+	}
  out:
 	return error;
 }
@@ -2417,11 +2443,15 @@ static int _convert_lock(struct dlm_rsb *r, struct dlm_lkb *lkb)
 {
 	int error;
 
-	if (is_remote(r))
+	if (is_remote(r)) {
 		/* receive_convert() calls do_convert() on remote node */
 		error = send_convert(r, lkb);
-	else
+	} else {
 		error = do_convert(r, lkb);
+		/* for remote locks the convert_reply is sent
+		   between do_convert and do_convert_effects */
+		do_convert_effects(r, lkb, error);
+	}
 
 	return error;
 }
@@ -3191,6 +3221,7 @@ static void receive_request(struct dlm_ls *ls, struct dlm_message *ms)
 	attach_lkb(r, lkb);
 	error = do_request(r, lkb);
 	send_request_reply(r, lkb, error);
+	do_request_effects(r, lkb, error);
 
 	unlock_rsb(r);
 	put_rsb(r);
@@ -3226,15 +3257,19 @@ static void receive_convert(struct dlm_ls *ls, struct dlm_message *ms)
 		goto out;
 
 	receive_flags(lkb, ms);
+
 	error = receive_convert_args(ls, lkb, ms);
-	if (error)
-		goto out_reply;
+	if (error) {
+		send_convert_reply(r, lkb, error);
+		goto out;
+	}
+
 	reply = !down_conversion(lkb);
 
 	error = do_convert(r, lkb);
- out_reply:
 	if (reply)
 		send_convert_reply(r, lkb, error);
+	do_convert_effects(r, lkb, error);
  out:
 	unlock_rsb(r);
 	put_rsb(r);
-- 
1.6.6

