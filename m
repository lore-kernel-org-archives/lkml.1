Return-Path: <linux-kernel-owner+w=401wt.eu-S1759867AbZA2Qq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759867AbZA2Qq0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 11:46:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759660AbZA2QqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 11:46:00 -0500
Received: from mx2.redhat.com ([66.187.237.31]:55097 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759649AbZA2Qp7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 11:45:59 -0500
Date: Thu, 29 Jan 2009 17:43:05 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, dvlasenk@redhat.com, jmarchan@redhat.com,
       roland@redhat.com
Subject: Re: +
	ptrace-reintroduce-__ptrace_detach-as-a-callee-of-ptrace_exit.patch
	added to -mm tree
Message-ID: <20090129164305.GB21030@redhat.com>
References: <200901290843.n0T8hrJh002987@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901290843.n0T8hrJh002987@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The patch titled
>      ptrace: reintroduce __ptrace_detach() as a callee of ptrace_exit()
> has been added to the -mm tree.  Its filename is
>      ptrace-reintroduce-__ptrace_detach-as-a-callee-of-ptrace_exit.patch

Please find the new version below. Re-diff + update the comments.

----------
[PATCH 3/4] ptrace: reintroduce __ptrace_detach() as a callee of ptrace_exit()

No functional changes, preparation for the next patch.

Move the "should we release this child" logic into the separate handler,
__ptrace_detach().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- 6.29-rc3/kernel/exit.c~3_REINTRODUCE_DETACH	2009-01-29 16:40:38.000000000 +0100
+++ 6.29-rc3/kernel/exit.c	2009-01-29 17:08:27.000000000 +0100
@@ -741,6 +741,38 @@ static int ignoring_children(struct sigh
 	return ret;
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
+	 * reap itself we return true.
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
@@ -752,36 +784,8 @@ static void ptrace_exit(struct task_stru
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
 

