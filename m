Return-Path: <linux-kernel-owner+w=401wt.eu-S1759477AbYBGGVB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759477AbYBGGVB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 01:21:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754464AbYBGGSU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 01:18:20 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54022 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752743AbYBGGSF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 01:18:05 -0500
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 05/16] dlm: use proper type for ->ls_recover_buf
Date: Thu,  7 Feb 2008 00:09:08 -0600
Message-Id: <1202364559-9201-6-git-send-email-teigland@redhat.com>
X-Mailer: git-send-email 1.5.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/dir.c          |    2 +-
 fs/dlm/dlm_internal.h |    2 +-
 fs/dlm/rcom.c         |   11 ++++++-----
 fs/dlm/recover.c      |    4 ++--
 4 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/fs/dlm/dir.c b/fs/dlm/dir.c
index ff97ba9..ce30136 100644
--- a/fs/dlm/dir.c
+++ b/fs/dlm/dir.c
@@ -235,7 +235,7 @@ int dlm_recover_directory(struct dlm_ls *ls)
 			 * pick namelen/name pairs out of received buffer
 			 */
 
-			b = ls->ls_recover_buf + sizeof(struct dlm_rcom);
+			b = ls->ls_recover_buf->rc_buf;
 
 			for (;;) {
 				memcpy(&namelen, b, sizeof(uint16_t));
diff --git a/fs/dlm/dlm_internal.h b/fs/dlm/dlm_internal.h
index 187a5b5..f7fbaec 100644
--- a/fs/dlm/dlm_internal.h
+++ b/fs/dlm/dlm_internal.h
@@ -500,7 +500,7 @@ struct dlm_ls {
 	struct rw_semaphore	ls_recv_active;	/* block dlm_recv */
 	struct list_head	ls_requestqueue;/* queue remote requests */
 	struct mutex		ls_requestqueue_mutex;
-	char			*ls_recover_buf;
+	struct dlm_rcom		*ls_recover_buf;
 	int			ls_recover_nodeid; /* for debugging */
 	uint64_t		ls_rcom_seq;
 	spinlock_t		ls_rcom_spin;
diff --git a/fs/dlm/rcom.c b/fs/dlm/rcom.c
index fb07762..3f9b96f 100644
--- a/fs/dlm/rcom.c
+++ b/fs/dlm/rcom.c
@@ -129,7 +129,7 @@ int dlm_rcom_status(struct dlm_ls *ls, int nodeid)
 	ls->ls_recover_nodeid = nodeid;
 
 	if (nodeid == dlm_our_nodeid()) {
-		rc = (struct dlm_rcom *) ls->ls_recover_buf;
+		rc = ls->ls_recover_buf;
 		rc->rc_result = dlm_recover_status(ls);
 		goto out;
 	}
@@ -148,7 +148,7 @@ int dlm_rcom_status(struct dlm_ls *ls, int nodeid)
 	if (error)
 		goto out;
 
-	rc = (struct dlm_rcom *) ls->ls_recover_buf;
+	rc = ls->ls_recover_buf;
 
 	if (rc->rc_result == -ESRCH) {
 		/* we pretend the remote lockspace exists with 0 status */
@@ -202,14 +202,15 @@ int dlm_rcom_names(struct dlm_ls *ls, int nodeid, char *last_name, int last_len)
 {
 	struct dlm_rcom *rc;
 	struct dlm_mhandle *mh;
-	int error = 0, len = sizeof(struct dlm_rcom);
+	int error = 0;
+	int max_size = dlm_config.ci_buffer_size - sizeof(struct dlm_rcom);
 
 	ls->ls_recover_nodeid = nodeid;
 
 	if (nodeid == dlm_our_nodeid()) {
 		dlm_copy_master_names(ls, last_name, last_len,
-		                      ls->ls_recover_buf + len,
-		                      dlm_config.ci_buffer_size - len, nodeid);
+		                      ls->ls_recover_buf->rc_buf,
+		                      max_size, nodeid);
 		goto out;
 	}
 
diff --git a/fs/dlm/recover.c b/fs/dlm/recover.c
index df075dc..80aba5b 100644
--- a/fs/dlm/recover.c
+++ b/fs/dlm/recover.c
@@ -94,7 +94,7 @@ void dlm_set_recover_status(struct dlm_ls *ls, uint32_t status)
 
 static int wait_status_all(struct dlm_ls *ls, uint32_t wait_status)
 {
-	struct dlm_rcom *rc = (struct dlm_rcom *) ls->ls_recover_buf;
+	struct dlm_rcom *rc = ls->ls_recover_buf;
 	struct dlm_member *memb;
 	int error = 0, delay;
 
@@ -123,7 +123,7 @@ static int wait_status_all(struct dlm_ls *ls, uint32_t wait_status)
 
 static int wait_status_low(struct dlm_ls *ls, uint32_t wait_status)
 {
-	struct dlm_rcom *rc = (struct dlm_rcom *) ls->ls_recover_buf;
+	struct dlm_rcom *rc = ls->ls_recover_buf;
 	int error = 0, delay = 0, nodeid = ls->ls_low_nodeid;
 
 	for (;;) {
-- 
1.5.3.3

