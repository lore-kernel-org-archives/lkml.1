Return-Path: <linux-kernel-owner+w=401wt.eu-S1756369AbYAXRAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756369AbYAXRAq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 12:00:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757325AbYAXQ6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 11:58:40 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49773 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758263AbYAXQ6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 11:58:37 -0500
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 09/19] dlm: clear ast_type when removing from astqueue
Date: Thu, 24 Jan 2008 10:50:32 -0600
Message-Id: <1201193442-8260-10-git-send-email-teigland@redhat.com>
X-Mailer: git-send-email 1.5.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The lkb_ast_type field indicates whether the lkb is on the astqueue list.
When clearing locks for a process, lkb's were being removed from the astqueue
list without clearing the field.  If release_lockspace then happened
immediately afterward, it could try to remove the lkb from the list a second
time.

Appears when process calls libdlm dlm_release_lockspace() which first
closes the ls dev triggering clear_proc_locks, and then removes the ls
(a write to control dev) causing release_lockspace().

Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/lock.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index ddb4628..43ca2a3 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -4678,6 +4678,7 @@ void dlm_clear_proc_locks(struct dlm_ls *ls, struct dlm_user_proc *proc)
 	}
 
 	list_for_each_entry_safe(lkb, safe, &proc->asts, lkb_astqueue) {
+		lkb->lkb_ast_type = 0;
 		list_del(&lkb->lkb_astqueue);
 		dlm_put_lkb(lkb);
 	}
-- 
1.5.3.3

