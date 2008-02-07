Return-Path: <linux-kernel-owner+w=401wt.eu-S932080AbYBGGTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932080AbYBGGTx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 01:19:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753968AbYBGGSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 01:18:16 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54020 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752695AbYBGGSF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 01:18:05 -0500
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 08/16] dlm: verify that places expecting rcom_lock have packet long enough
Date: Thu,  7 Feb 2008 00:09:11 -0600
Message-Id: <1202364559-9201-9-git-send-email-teigland@redhat.com>
X-Mailer: git-send-email 1.5.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/lock.c |    3 +++
 fs/dlm/rcom.c |   12 +++++++++++-
 2 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index 75176b5..6c605fc 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -4266,6 +4266,7 @@ static struct dlm_lkb *search_remid(struct dlm_rsb *r, int nodeid,
 	return NULL;
 }
 
+/* needs at least dlm_rcom + rcom_lock */
 static int receive_rcom_lock_args(struct dlm_ls *ls, struct dlm_lkb *lkb,
 				  struct dlm_rsb *r, struct dlm_rcom *rc)
 {
@@ -4315,6 +4316,7 @@ static int receive_rcom_lock_args(struct dlm_ls *ls, struct dlm_lkb *lkb,
    the given values and send back our lkid.  We send back our lkid by sending
    back the rcom_lock struct we got but with the remid field filled in. */
 
+/* needs at least dlm_rcom + rcom_lock */
 int dlm_recover_master_copy(struct dlm_ls *ls, struct dlm_rcom *rc)
 {
 	struct rcom_lock *rl = (struct rcom_lock *) rc->rc_buf;
@@ -4370,6 +4372,7 @@ int dlm_recover_master_copy(struct dlm_ls *ls, struct dlm_rcom *rc)
 	return error;
 }
 
+/* needs at least dlm_rcom + rcom_lock */
 int dlm_recover_process_copy(struct dlm_ls *ls, struct dlm_rcom *rc)
 {
 	struct rcom_lock *rl = (struct rcom_lock *) rc->rc_buf;
diff --git a/fs/dlm/rcom.c b/fs/dlm/rcom.c
index a312f1d..ef9d0f9 100644
--- a/fs/dlm/rcom.c
+++ b/fs/dlm/rcom.c
@@ -357,6 +357,7 @@ int dlm_send_rcom_lock(struct dlm_rsb *r, struct dlm_lkb *lkb)
 	return error;
 }
 
+/* needs at least dlm_rcom + rcom_lock */
 static void receive_rcom_lock(struct dlm_ls *ls, struct dlm_rcom *rc_in)
 {
 	struct dlm_rcom *rc;
@@ -448,6 +449,8 @@ static int is_old_reply(struct dlm_ls *ls, struct dlm_rcom *rc)
 
 void dlm_receive_rcom(struct dlm_ls *ls, struct dlm_rcom *rc, int nodeid)
 {
+	int lock_size = sizeof(struct dlm_rcom) + sizeof(struct rcom_lock);
+
 	if (dlm_recovery_stopped(ls) && (rc->rc_type != DLM_RCOM_STATUS)) {
 		log_debug(ls, "ignoring recovery message %x from %d",
 			  rc->rc_type, nodeid);
@@ -471,6 +474,8 @@ void dlm_receive_rcom(struct dlm_ls *ls, struct dlm_rcom *rc, int nodeid)
 		break;
 
 	case DLM_RCOM_LOCK:
+		if (rc->rc_header.h_length < lock_size)
+			goto Eshort;
 		receive_rcom_lock(ls, rc);
 		break;
 
@@ -487,13 +492,18 @@ void dlm_receive_rcom(struct dlm_ls *ls, struct dlm_rcom *rc, int nodeid)
 		break;
 
 	case DLM_RCOM_LOCK_REPLY:
+		if (rc->rc_header.h_length < lock_size)
+			goto Eshort;
 		dlm_recover_process_copy(ls, rc);
 		break;
 
 	default:
 		log_error(ls, "receive_rcom bad type %d", rc->rc_type);
 	}
- out:
+out:
 	return;
+Eshort:
+	log_error(ls, "recovery message %x from %d is too short",
+			  rc->rc_type, nodeid);
 }
 
-- 
1.5.3.3

