Return-Path: <linux-kernel-owner+w=401wt.eu-S1030401AbXEAKQG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030401AbXEAKQG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 06:16:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030367AbXEAKQB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 06:16:01 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50744 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161674AbXEAKP5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 06:15:57 -0400
Subject: [DLM] split create_message function [16/34]
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com
Cc: linux-kernel@vger.kernel.org, David Teigland <teigland@redhat.com>
In-Reply-To: <1178013376.5462.127.camel@quoit.chygwyn.com>
References: <1178013376.5462.127.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Tue, 01 May 2007 11:11:23 +0100
Message-Id: <1178014283.5462.159.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 7e4dac33594468153c38b5c94d8ebcafb0e0a68d Mon Sep 17 00:00:00 2001
From: David Teigland <teigland@redhat.com>
Date: Mon, 2 Apr 2007 09:06:41 -0500
Subject: [PATCH] [DLM] split create_message function

This splits the current create_message() function into two parts so that
later patches can call the new lower-level _create_message() function when
they don't have an rsb struct.  No functional change in this patch.

Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index b865a46..7807958 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -2301,31 +2301,14 @@ int dlm_unlock(dlm_lockspace_t *lockspace,
  * receive_lookup_reply		send_lookup_reply
  */
 
-static int create_message(struct dlm_rsb *r, struct dlm_lkb *lkb,
-			  int to_nodeid, int mstype,
-			  struct dlm_message **ms_ret,
-			  struct dlm_mhandle **mh_ret)
+static int _create_message(struct dlm_ls *ls, int mb_len,
+			   int to_nodeid, int mstype,
+			   struct dlm_message **ms_ret,
+			   struct dlm_mhandle **mh_ret)
 {
 	struct dlm_message *ms;
 	struct dlm_mhandle *mh;
 	char *mb;
-	int mb_len = sizeof(struct dlm_message);
-
-	switch (mstype) {
-	case DLM_MSG_REQUEST:
-	case DLM_MSG_LOOKUP:
-	case DLM_MSG_REMOVE:
-		mb_len += r->res_length;
-		break;
-	case DLM_MSG_CONVERT:
-	case DLM_MSG_UNLOCK:
-	case DLM_MSG_REQUEST_REPLY:
-	case DLM_MSG_CONVERT_REPLY:
-	case DLM_MSG_GRANT:
-		if (lkb && lkb->lkb_lvbptr)
-			mb_len += r->res_ls->ls_lvblen;
-		break;
-	}
 
 	/* get_buffer gives us a message handle (mh) that we need to
 	   pass into lowcomms_commit and a message buffer (mb) that we
@@ -2340,7 +2323,7 @@ static int create_message(struct dlm_rsb *r, struct dlm_lkb *lkb,
 	ms = (struct dlm_message *) mb;
 
 	ms->m_header.h_version = (DLM_HEADER_MAJOR | DLM_HEADER_MINOR);
-	ms->m_header.h_lockspace = r->res_ls->ls_global_id;
+	ms->m_header.h_lockspace = ls->ls_global_id;
 	ms->m_header.h_nodeid = dlm_our_nodeid();
 	ms->m_header.h_length = mb_len;
 	ms->m_header.h_cmd = DLM_MSG;
@@ -2352,6 +2335,33 @@ static int create_message(struct dlm_rsb *r, struct dlm_lkb *lkb,
 	return 0;
 }
 
+static int create_message(struct dlm_rsb *r, struct dlm_lkb *lkb,
+			  int to_nodeid, int mstype,
+			  struct dlm_message **ms_ret,
+			  struct dlm_mhandle **mh_ret)
+{
+	int mb_len = sizeof(struct dlm_message);
+
+	switch (mstype) {
+	case DLM_MSG_REQUEST:
+	case DLM_MSG_LOOKUP:
+	case DLM_MSG_REMOVE:
+		mb_len += r->res_length;
+		break;
+	case DLM_MSG_CONVERT:
+	case DLM_MSG_UNLOCK:
+	case DLM_MSG_REQUEST_REPLY:
+	case DLM_MSG_CONVERT_REPLY:
+	case DLM_MSG_GRANT:
+		if (lkb && lkb->lkb_lvbptr)
+			mb_len += r->res_ls->ls_lvblen;
+		break;
+	}
+
+	return _create_message(r->res_ls, mb_len, to_nodeid, mstype,
+			       ms_ret, mh_ret);
+}
+
 /* further lowcomms enhancements or alternate implementations may make
    the return value from this function useful at some point */
 
-- 
1.5.1.2



