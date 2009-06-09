Return-Path: <linux-kernel-owner+w=401wt.eu-S1762368AbZFIKc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762368AbZFIKc4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 06:32:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760823AbZFIKVP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 06:21:15 -0400
Received: from kroah.org ([198.145.64.141]:55341 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760332AbZFIKVO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 06:21:14 -0400
X-Mailbox-Line: From greg@blue.kroah.org Tue Jun  9 02:41:07 2009
Message-Id: <20090609094107.328131075@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 09 Jun 2009 02:39:53 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Oleg Nesterov <oleg@redhat.com>,
       Jerome Marchand <jmarchan@redhat.com>,
       Roland McGrath <roland@redhat.com>,
       Denys Vlasenko <dvlasenk@redhat.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 65/87] ptrace: reintroduce __ptrace_detach() as a callee of ptrace_exit()
References: <20090609093848.204935043@blue.kroah.org>
Content-Disposition: inline; filename=ptrace-reintroduce-__ptrace_detach-as-a-callee-of-ptrace_exit.patch
In-Reply-To: <20090609094451.GA26439@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit b1b4c6799fb59e710454bfe0ab477cb8523a8667 upstream.

No functional changes, preparation for the next patch.

Move the "should we release this child" logic into the separate handler,
__ptrace_detach().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/exit.c |   62 ++++++++++++++++++++++++++++++----------------------------
 1 file changed, 33 insertions(+), 29 deletions(-)

--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -715,6 +715,38 @@ static int ignoring_children(struct sigh
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
@@ -726,36 +758,8 @@ static void ptrace_exit(struct task_stru
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
 


