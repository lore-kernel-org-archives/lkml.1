Return-Path: <linux-kernel-owner+w=401wt.eu-S1756819AbXHNKLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819AbXHNKLb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 06:11:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755784AbXHNKKt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 06:10:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43271 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755170AbXHNKKi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 06:10:38 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: David Teigland <teigland@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH] [DLM] fix NULL ls usage
Date: Tue, 14 Aug 2007 10:47:06 +0100
Message-Id: <11870848441284-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11870848365-git-send-email-swhiteho@redhat.com>
References: <11870848365-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Teigland <teigland@redhat.com>

Fix regression in recent patch "[DLM] variable allocation" which
attempts to dereference an "ls" struct when it's NULL.

Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/dlm/rcom.c b/fs/dlm/rcom.c
index e3a1527..188b91c 100644
--- a/fs/dlm/rcom.c
+++ b/fs/dlm/rcom.c
@@ -386,8 +386,7 @@ static void receive_rcom_lock_reply(struct dlm_ls *ls, struct dlm_rcom *rc_in)
 	dlm_recover_process_copy(ls, rc_in);
 }
 
-static int send_ls_not_ready(struct dlm_ls *ls, int nodeid,
-			     struct dlm_rcom *rc_in)
+static int send_ls_not_ready(int nodeid, struct dlm_rcom *rc_in)
 {
 	struct dlm_rcom *rc;
 	struct rcom_config *rf;
@@ -395,7 +394,7 @@ static int send_ls_not_ready(struct dlm_ls *ls, int nodeid,
 	char *mb;
 	int mb_len = sizeof(struct dlm_rcom) + sizeof(struct rcom_config);
 
-	mh = dlm_lowcomms_get_buffer(nodeid, mb_len, ls->ls_allocation, &mb);
+	mh = dlm_lowcomms_get_buffer(nodeid, mb_len, GFP_NOFS, &mb);
 	if (!mh)
 		return -ENOBUFS;
 	memset(mb, 0, mb_len);
@@ -465,7 +464,7 @@ void dlm_receive_rcom(struct dlm_header *hd, int nodeid)
 		log_print("lockspace %x from %d type %x not found",
 			  hd->h_lockspace, nodeid, rc->rc_type);
 		if (rc->rc_type == DLM_RCOM_STATUS)
-			send_ls_not_ready(ls, nodeid, rc);
+			send_ls_not_ready(nodeid, rc);
 		return;
 	}
 
-- 
1.5.1.2

