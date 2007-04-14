Return-Path: <linux-kernel-owner+w=401wt.eu-S1753735AbXDNDTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735AbXDNDTS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 23:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753748AbXDNDTS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 23:19:18 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:37298 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753678AbXDNDTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 23:19:17 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Davide Libenzi <davidel@xmailserver.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Roland McGrath <roland@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       <linux-arch@vger.kernel.org>
Subject: [PATCH] kthread: Simplify kthread_create.
References: <20070413130236.GA173@tv-sign.ru>
	<m1zm5bmywm.fsf@ebiederm.dsl.xmission.com>
Date: Fri, 13 Apr 2007 21:17:39 -0600
In-Reply-To: <m1zm5bmywm.fsf@ebiederm.dsl.xmission.com> (Eric W. Biederman's
	message of "Fri, 13 Apr 2007 21:13:13 -0600")
Message-ID: <m1vefzmyp8.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This removes an unneeded completion from kthread_create and moves
wake_up_process out of the kthread_create_lock making it clear that
wake_up_process doesn't need the protection of the
kthread_create_lock.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 kernel/kthread.c |   16 ++++++----------
 1 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/kernel/kthread.c b/kernel/kthread.c
index 06c7e51..cd89b49 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -24,7 +24,6 @@ struct kthread_create_info
 	/* Information passed to kthread() from kthreadd. */
 	int (*threadfn)(void *data);
 	void *data;
-	struct completion started;
 
 	/* Result passed back to kthread_create() from kthreadd. */
 	struct task_struct *result;
@@ -41,6 +40,9 @@ static int kthread(void *_create)
 	void *data;
 	int ret = -EINTR;
 
+	/* Report which task_struct I am */
+	create->result = current;
+
 	/* Setup a completion on this thread's stack */
 	init_completion(&done);
 	current->vfork_done = &done;
@@ -51,7 +53,7 @@ static int kthread(void *_create)
 
 	/* OK, tell user we're spawned, wait for stop or wakeup */
 	__set_current_state(TASK_INTERRUPTIBLE);
-	complete(&create->started);
+	complete(&create->done);
 	schedule();
 
 	if (!kthread_should_stop())
@@ -68,13 +70,8 @@ static void create_kthread(struct kthread_create_info *create)
 	pid = kernel_thread(kthread, create, CLONE_FS | CLONE_FILES | SIGCHLD);
 	if (pid < 0) {
 		create->result = ERR_PTR(pid);
-	} else {
-		wait_for_completion(&create->started);
-		read_lock(&tasklist_lock);
-		create->result = find_task_by_pid(pid);
-		read_unlock(&tasklist_lock);
+		complete(&create->done);
 	}
-	complete(&create->done);
 }
 
 /**
@@ -105,14 +102,13 @@ struct task_struct *kthread_create(int (*threadfn)(void *data),
 
 	create.threadfn = threadfn;
 	create.data = data;
-	init_completion(&create.started);
 	init_completion(&create.done);
 
 	spin_lock(&kthread_create_lock);
 	list_add_tail(&create.list, &kthread_create_list);
-	wake_up_process(kthreadd_task);
 	spin_unlock(&kthread_create_lock);
 
+	wake_up_process(kthreadd_task);
 	wait_for_completion(&create.done);
 
 	if (!IS_ERR(create.result)) {
-- 
1.5.0.g53756

