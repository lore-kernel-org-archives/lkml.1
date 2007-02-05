Return-Path: <linux-kernel-owner+w=401wt.eu-S932695AbXBEOEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932695AbXBEOEq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 09:04:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932734AbXBEOEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 09:04:46 -0500
Received: from mx1.redhat.com ([66.187.233.31]:41722 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932695AbXBEOEo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 09:04:44 -0500
Subject: [DLM] fix send_args() lvb copying [5/54]
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Teigland <teigland@redhat.com>, cluster-devel@redhat.com
In-Reply-To: <1170684425.11001.267.camel@quoit.chygwyn.com>
References: <1170684425.11001.267.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd
Date: Mon, 05 Feb 2007 14:12:47 +0000
Message-Id: <1170684767.11001.279.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From f9066217183174c56cf9992b8e2819702031aa85 Mon Sep 17 00:00:00 2001
From: David Teigland <teigland@redhat.com>
Date: Wed, 13 Dec 2006 10:38:45 -0600
Subject: [PATCH] [DLM] fix send_args() lvb copying

The send_args() function is used to copy parameters into a message for a
number different message types.  Only some of those types are set up
beforehand (in create_message) to include space for sending lvb data.
send_args was wrongly copying the lvb for all message types as long as the
lock had an lvb.  This means that the lvb data was being written past the
end of the message into unknown space.

Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index 69ada58..cdf2cb9 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -2144,12 +2144,24 @@ static void send_args(struct dlm_rsb *r, struct dlm_lkb *lkb,
 	if (lkb->lkb_astaddr)
 		ms->m_asts |= AST_COMP;
 
-	if (ms->m_type == DLM_MSG_REQUEST || ms->m_type == DLM_MSG_LOOKUP)
-		memcpy(ms->m_extra, r->res_name, r->res_length);
+	/* compare with switch in create_message; send_remove() doesn't
+	   use send_args() */
 
-	else if (lkb->lkb_lvbptr)
+	switch (ms->m_type) {
+	case DLM_MSG_REQUEST:
+	case DLM_MSG_LOOKUP:
+		memcpy(ms->m_extra, r->res_name, r->res_length);
+		break;
+	case DLM_MSG_CONVERT:
+	case DLM_MSG_UNLOCK:
+	case DLM_MSG_REQUEST_REPLY:
+	case DLM_MSG_CONVERT_REPLY:
+	case DLM_MSG_GRANT:
+		if (!lkb->lkb_lvbptr)
+			break;
 		memcpy(ms->m_extra, lkb->lkb_lvbptr, r->res_ls->ls_lvblen);
-
+		break;
+	}
 }
 
 static int send_common(struct dlm_rsb *r, struct dlm_lkb *lkb, int mstype)
-- 
1.4.4.2



