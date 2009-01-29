Return-Path: <linux-kernel-owner+w=401wt.eu-S1759788AbZA2Eco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759788AbZA2Eco (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 23:32:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759202AbZA2Ebj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 23:31:39 -0500
Received: from mx2.redhat.com ([66.187.237.31]:33322 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758858AbZA2Ebi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 23:31:38 -0500
Date: Thu, 29 Jan 2009 05:29:20 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jerome Marchand <jmarchan@redhat.com>, Roland McGrath <roland@redhat.com>,
       Denys Vlasenko <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] ptrace: reintroduce __ptrace_detach() as a callee of
	ptrace_exit()
Message-ID: <20090129042920.GA5111@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional changes, preparation for the next patch.

Move the "should we release this child" logic into the separate handler,
__ptrace_detach().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- 6.29-rc3/kernel/exit.c~3_REINTRODUCE_DETACH	2009-01-29 02:46:42.000000000 +0100
+++ 6.29-rc3/kernel/exit.c	2009-01-29 04:09:40.000000000 +0100
@@ -737,6 +737,39 @@ static int ignoring_children(struct sigh
 		sigh->action[SIGCHLD-1].sa.sa_flags & SA_NOCLDWAIT;
 }
 
+/* Returns nonzero if the tracee should be released. */
+int __ptrace_detach(struct task_struct *tracer, struct task_struct *p)
+{
+	__ptrace_unlink(p);
+
+	if (p->exit_state != EXIT_ZOMBIE)
+		return 0;
+	/*
+	 * If it's a zombie, our attachedness prevented normal
+	 * parent notification or self-reaping.  Do notification
+	 * now if it would have happened earlier.  If it should
+	 * reap itself, add it to the @dead list.  We can't call
+	 * release_task() here because we already hold tasklist_lock.
+	 *
+	 * If it's our own child, there is no notification to do.
+	 * But if our normal children self-reap, then this child
+	 * was prevented by ptrace and we must reap it now.
+	 */
+	if (!task_detached(p) && thread_group_empty(p)) {
+		if (!same_thread_group(p->real_parent, tracer))
+			do_notify_parent(p, p->exit_signal);
+		else if (ignoring_children(tracer->sighand))
+			p->exit_signal = -1;
+	}
+
+	if (!task_detached(p))
+		return 0;
+
+	/* Mark it as in the process of being reaped. */
+	p->exit_state = EXIT_DEAD;
+	return 1;
+}
+
 /*
  * Detach all tasks we were using ptrace on.
  * Any that need to be release_task'd are put on the @dead list.
@@ -748,36 +781,8 @@ static void ptrace_exit(struct task_stru
 	struct task_struct *p, *n;
 
 	list_for_each_entry_safe(p, n, &parent->ptraced, ptrace_entry) {
-		__ptrace_unlink(p);
-
-		if (p->exit_state != EXIT_ZOMBIE)
-			continue;
-
-		/*
-		 * If it's a zombie, our attachedness prevented normal
-		 * parent notification or self-reaping.  Do notification
-		 * now if it would have happened earlier.  If it should
-		 * reap itself, add it to the @dead list.  We can't call
-		 * release_task() here because we already hold tasklist_lock.
-		 *
-		 * If it's our own child, there is no notification to do.
-		 * But if our normal children self-reap, then this child
-		 * was prevented by ptrace and we must reap it now.
-		 */
-		if (!task_detached(p) && thread_group_empty(p)) {
-			if (!same_thread_group(p->real_parent, parent))
-				do_notify_parent(p, p->exit_signal);
-			else if (ignoring_children(parent->sighand))
-				p->exit_signal = -1;
-		}
-
-		if (task_detached(p)) {
-			/*
-			 * Mark it as in the process of being reaped.
-			 */
-			p->exit_state = EXIT_DEAD;
+		if (__ptrace_detach(parent, p))
 			list_add(&p->ptrace_entry, dead);
-		}
 	}
 }
 

