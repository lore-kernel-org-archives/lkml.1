Return-Path: <linux-kernel-owner+w=401wt.eu-S1756597AbYBGGUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597AbYBGGUV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 01:20:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754033AbYBGGSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 01:18:17 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54019 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752654AbYBGGSF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 01:18:05 -0500
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 06/16] dlm: missing length check in check_config()
Date: Thu,  7 Feb 2008 00:09:09 -0600
Message-Id: <1202364559-9201-7-git-send-email-teigland@redhat.com>
X-Mailer: git-send-email 1.5.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/rcom.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/dlm/rcom.c b/fs/dlm/rcom.c
index 3f9b96f..a312f1d 100644
--- a/fs/dlm/rcom.c
+++ b/fs/dlm/rcom.c
@@ -85,6 +85,7 @@ static void make_config(struct dlm_ls *ls, struct rcom_config *rf)
 static int check_config(struct dlm_ls *ls, struct dlm_rcom *rc, int nodeid)
 {
 	struct rcom_config *rf = (struct rcom_config *) rc->rc_buf;
+	size_t conf_size = sizeof(struct dlm_rcom) + sizeof(struct rcom_config);
 
 	if ((rc->rc_header.h_version & 0xFFFF0000) != DLM_HEADER_MAJOR) {
 		log_error(ls, "version mismatch: %x nodeid %d: %x",
@@ -93,6 +94,12 @@ static int check_config(struct dlm_ls *ls, struct dlm_rcom *rc, int nodeid)
 		return -EPROTO;
 	}
 
+	if (rc->rc_header.h_length < conf_size) {
+		log_error(ls, "config too short: %d nodeid %d",
+			  rc->rc_header.h_length, nodeid);
+		return -EPROTO;
+	}
+
 	if (le32_to_cpu(rf->rf_lvblen) != ls->ls_lvblen ||
 	    le32_to_cpu(rf->rf_lsflags) != ls->ls_exflags) {
 		log_error(ls, "config mismatch: %d,%x nodeid %d: %d,%x",
-- 
1.5.3.3

