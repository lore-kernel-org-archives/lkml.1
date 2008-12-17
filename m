Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1760470AbYLQFPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760470AbYLQFPr (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 00:15:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752560AbYLQFNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 00:13:12 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:37073 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759745AbYLQFNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 00:13:11 -0500
To: linux-audit@redhat.com
Subject: [PATCH 13/15] make sure that filterkey of task,always rules is reported
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1LCoic-0000Fo-UH@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 17 Dec 2008 05:13:10 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 kernel/auditsc.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 296d329..549443e 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -618,7 +618,7 @@ static int audit_filter_rules(struct task_struct *tsk,
  * completely disabled for this task.  Since we only have the task
  * structure at this point, we can only check uid and gid.
  */
-static enum audit_state audit_filter_task(struct task_struct *tsk)
+static enum audit_state audit_filter_task(struct task_struct *tsk, char **key)
 {
 	struct audit_entry *e;
 	enum audit_state   state;
@@ -626,6 +626,8 @@ static enum audit_state audit_filter_task(struct task_struct *tsk)
 	rcu_read_lock();
 	list_for_each_entry_rcu(e, &audit_filter_list[AUDIT_FILTER_TASK], list) {
 		if (audit_filter_rules(tsk, &e->rule, NULL, NULL, &state)) {
+			if (state == AUDIT_RECORD_CONTEXT)
+				*key = kstrdup(e->rule.filterkey, GFP_ATOMIC);
 			rcu_read_unlock();
 			return state;
 		}
@@ -832,18 +834,21 @@ int audit_alloc(struct task_struct *tsk)
 {
 	struct audit_context *context;
 	enum audit_state     state;
+	char *key = NULL;
 
 	if (likely(!audit_ever_enabled))
 		return 0; /* Return if not auditing. */
 
-	state = audit_filter_task(tsk);
+	state = audit_filter_task(tsk, &key);
 	if (likely(state == AUDIT_DISABLED))
 		return 0;
 
 	if (!(context = audit_alloc_context(state))) {
+		kfree(key);
 		audit_log_lost("out of memory in audit_alloc");
 		return -ENOMEM;
 	}
+	context->filterkey = key;
 
 	tsk->audit_context  = context;
 	set_tsk_thread_flag(tsk, TIF_SYSCALL_AUDIT);
@@ -1616,8 +1621,10 @@ void audit_syscall_exit(int valid, long return_code)
 		context->sockaddr_len = 0;
 		context->type = 0;
 		context->fds[0] = -1;
-		kfree(context->filterkey);
-		context->filterkey = NULL;
+		if (context->state != AUDIT_RECORD_CONTEXT) {
+			kfree(context->filterkey);
+			context->filterkey = NULL;
+		}
 		tsk->audit_context = context;
 	}
 }
-- 
1.5.6.5


