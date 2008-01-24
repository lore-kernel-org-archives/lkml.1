Return-Path: <linux-kernel-owner+w=401wt.eu-S1759052AbYAXRBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759052AbYAXRBc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 12:01:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758298AbYAXQ6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 11:58:42 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49778 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758276AbYAXQ6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 11:58:38 -0500
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: "Fabio M. Di Nitto" <fabbione@ubuntu.com>
Subject: [PATCH 07/19] dlm: swap bytes for rcom lock reply
Date: Thu, 24 Jan 2008 10:50:30 -0600
Message-Id: <1201193442-8260-8-git-send-email-teigland@redhat.com>
X-Mailer: git-send-email 1.5.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio M. Di Nitto <fabbione@ubuntu.com>

DLM_RCOM_LOCK_REPLY messages need byte swapping.

Signed-off-by: Fabio M. Di Nitto <fabbione@ubuntu.com>
Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/util.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/dlm/util.c b/fs/dlm/util.c
index 963889c..38dcfeb 100644
--- a/fs/dlm/util.c
+++ b/fs/dlm/util.c
@@ -137,7 +137,7 @@ void dlm_rcom_out(struct dlm_rcom *rc)
 	rc->rc_seq		= cpu_to_le64(rc->rc_seq);
 	rc->rc_seq_reply	= cpu_to_le64(rc->rc_seq_reply);
 
-	if (type == DLM_RCOM_LOCK)
+	if ((type == DLM_RCOM_LOCK) || (type == DLM_RCOM_LOCK_REPLY))
 		rcom_lock_out((struct rcom_lock *) rc->rc_buf);
 
 	else if (type == DLM_RCOM_STATUS_REPLY)
@@ -147,6 +147,7 @@ void dlm_rcom_out(struct dlm_rcom *rc)
 void dlm_rcom_in(struct dlm_rcom *rc)
 {
 	struct dlm_header *hd = (struct dlm_header *) rc;
+	int type;
 
 	header_in(hd);
 
@@ -156,10 +157,12 @@ void dlm_rcom_in(struct dlm_rcom *rc)
 	rc->rc_seq		= le64_to_cpu(rc->rc_seq);
 	rc->rc_seq_reply	= le64_to_cpu(rc->rc_seq_reply);
 
-	if (rc->rc_type == DLM_RCOM_LOCK)
+	type = rc->rc_type;
+
+	if ((type == DLM_RCOM_LOCK) || (type == DLM_RCOM_LOCK_REPLY))
 		rcom_lock_in((struct rcom_lock *) rc->rc_buf);
 
-	else if (rc->rc_type == DLM_RCOM_STATUS_REPLY)
+	else if (type == DLM_RCOM_STATUS_REPLY)
 		rcom_config_in((struct rcom_config *) rc->rc_buf);
 }
 
-- 
1.5.3.3

