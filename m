Return-Path: <linux-kernel-owner+w=401wt.eu-S1757715AbYAXRDI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757715AbYAXRDI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 12:03:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757239AbYAXQ6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 11:58:47 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49785 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758270AbYAXQ6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 11:58:40 -0500
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 16/19] dlm: fix possible use-after-free
Date: Thu, 24 Jan 2008 10:50:39 -0600
Message-Id: <1201193442-8260-17-git-send-email-teigland@redhat.com>
X-Mailer: git-send-email 1.5.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dlm_put_lkb() can free the lkb and its associated ua structure,
so we can't depend on using the ua struct after the put.

Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/user.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/dlm/user.c b/fs/dlm/user.c
index 4f74154..eb61648 100644
--- a/fs/dlm/user.c
+++ b/fs/dlm/user.c
@@ -236,12 +236,12 @@ void dlm_user_add_ast(struct dlm_lkb *lkb, int type)
 	spin_unlock(&proc->asts_spin);
 
 	if (eol) {
-		spin_lock(&ua->proc->locks_spin);
+		spin_lock(&proc->locks_spin);
 		if (!list_empty(&lkb->lkb_ownqueue)) {
 			list_del_init(&lkb->lkb_ownqueue);
 			dlm_put_lkb(lkb);
 		}
-		spin_unlock(&ua->proc->locks_spin);
+		spin_unlock(&proc->locks_spin);
 	}
  out:
 	mutex_unlock(&ls->ls_clear_proc_locks);
-- 
1.5.3.3

