Return-Path: <linux-kernel-owner+w=401wt.eu-S932692AbXBEODt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932692AbXBEODt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 09:03:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932697AbXBEODt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 09:03:49 -0500
Received: from mx1.redhat.com ([66.187.233.31]:41407 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932695AbXBEODs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 09:03:48 -0500
Subject: [DLM] add version check [4/54]
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Teigland <teigland@redhat.com>, cluster-devel@redhat.com
In-Reply-To: <1170684425.11001.267.camel@quoit.chygwyn.com>
References: <1170684425.11001.267.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd
Date: Mon, 05 Feb 2007 14:11:52 +0000
Message-Id: <1170684712.11001.277.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From c72ebab07b716be7dddfebff05f8a74b94bfebe2 Mon Sep 17 00:00:00 2001
From: David Teigland <teigland@redhat.com>
Date: Wed, 13 Dec 2006 10:37:55 -0600
Subject: [PATCH] [DLM] add version check

Check if we receive a message from another lockspace member running a
version of the dlm with an incompatible inter-node message protocol.

Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/dlm/rcom.c b/fs/dlm/rcom.c
index 521ad9b..54fba9b 100644
--- a/fs/dlm/rcom.c
+++ b/fs/dlm/rcom.c
@@ -82,8 +82,17 @@ static void make_config(struct dlm_ls *ls, struct rcom_config *rf)
 	rf->rf_lsflags = ls->ls_exflags;
 }
 
-static int check_config(struct dlm_ls *ls, struct rcom_config *rf, int nodeid)
+static int check_config(struct dlm_ls *ls, struct dlm_rcom *rc, int nodeid)
 {
+	struct rcom_config *rf = (struct rcom_config *) rc->rc_buf;
+
+	if ((rc->rc_header.h_version & 0xFFFF0000) != DLM_HEADER_MAJOR) {
+		log_error(ls, "version mismatch: %x nodeid %d: %x",
+			  DLM_HEADER_MAJOR | DLM_HEADER_MINOR, nodeid,
+			  rc->rc_header.h_version);
+		return -EINVAL;
+	}
+
 	if (rf->rf_lvblen != ls->ls_lvblen ||
 	    rf->rf_lsflags != ls->ls_exflags) {
 		log_error(ls, "config mismatch: %d,%x nodeid %d: %d,%x",
@@ -145,8 +154,7 @@ int dlm_rcom_status(struct dlm_ls *ls, int nodeid)
 		log_debug(ls, "remote node %d not ready", nodeid);
 		rc->rc_result = 0;
 	} else
-		error = check_config(ls, (struct rcom_config *) rc->rc_buf,
-				     nodeid);
+		error = check_config(ls, rc, nodeid);
 	/* the caller looks at rc_result for the remote recovery status */
  out:
 	return error;
-- 
1.4.4.2



