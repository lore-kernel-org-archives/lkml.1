Return-Path: <linux-kernel-owner+w=401wt.eu-S1761679AbYBGGVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761679AbYBGGVt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 01:21:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754674AbYBGGSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 01:18:22 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54024 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752805AbYBGGSF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 01:18:05 -0500
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 09/16] dlm: receive_rcom_lock_args() overflow check
Date: Thu,  7 Feb 2008 00:09:12 -0600
Message-Id: <1202364559-9201-10-git-send-email-teigland@redhat.com>
X-Mailer: git-send-email 1.5.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/lock.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index 6c605fc..0593dd8 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -4271,7 +4271,6 @@ static int receive_rcom_lock_args(struct dlm_ls *ls, struct dlm_lkb *lkb,
 				  struct dlm_rsb *r, struct dlm_rcom *rc)
 {
 	struct rcom_lock *rl = (struct rcom_lock *) rc->rc_buf;
-	int lvblen;
 
 	lkb->lkb_nodeid = rc->rc_header.h_nodeid;
 	lkb->lkb_ownpid = le32_to_cpu(rl->rl_ownpid);
@@ -4288,11 +4287,13 @@ static int receive_rcom_lock_args(struct dlm_ls *ls, struct dlm_lkb *lkb,
 	lkb->lkb_astaddr = (void *) (long) (rl->rl_asts & AST_COMP);
 
 	if (lkb->lkb_exflags & DLM_LKF_VALBLK) {
+		int lvblen = rc->rc_header.h_length - sizeof(struct dlm_rcom) -
+			 sizeof(struct rcom_lock);
+		if (lvblen > ls->ls_lvblen)
+			return -EINVAL;
 		lkb->lkb_lvbptr = dlm_allocate_lvb(ls);
 		if (!lkb->lkb_lvbptr)
 			return -ENOMEM;
-		lvblen = rc->rc_header.h_length - sizeof(struct dlm_rcom) -
-			 sizeof(struct rcom_lock);
 		memcpy(lkb->lkb_lvbptr, rl->rl_lvb, lvblen);
 	}
 
-- 
1.5.3.3

