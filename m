Return-Path: <linux-kernel-owner+w=401wt.eu-S1764302AbYEFAf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764302AbYEFAf1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 20:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764135AbYEFAel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 20:34:41 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39937 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763230AbYEFAej (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 20:34:39 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH 4/4] fix dangling zombie when new parent ignores children
In-Reply-To: Roland McGrath's message of  Monday, 5 May 2008 17:32:39 -0700 <20080506003239.43FF026FA20@magilla.localdomain>
References: <20080506003239.43FF026FA20@magilla.localdomain>
Emacs: or perhaps you'd prefer Russian Roulette, after all?
Message-Id: <20080506003435.1301B26FA20@magilla.localdomain>
Date: Mon,  5 May 2008 17:34:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes an arcane bug that we think was a regression introduced
by commit b2b2cbc4b2a2f389442549399a993a8306420baf.  When a parent
ignores SIGCHLD (or uses SA_NOCLDWAIT), its children would self-reap
but they don't if it's using ptrace on them.  When the parent thread
later exits and ceases to ptrace a child but leaves other live
threads in the parent's thread group, any zombie children are left
dangling.  The fix makes them self-reap then, as they would have
done earlier if ptrace had not been in use.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 kernel/exit.c |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 42980e2..afed083 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -697,6 +697,22 @@ static void exit_mm(struct task_struct * tsk)
 }
 
 /*
+ * Return nonzero if @parent's children should reap themselves.
+ *
+ * Called with write_lock_irq(&tasklist_lock) held.
+ */
+static int ignoring_children(struct task_struct *parent)
+{
+	int ret;
+	struct sighand_struct *psig = parent->sighand;
+	spin_lock(&psig->siglock);
+	ret = (psig->action[SIGCHLD-1].sa.sa_handler == SIG_IGN ||
+	       (psig->action[SIGCHLD-1].sa.sa_flags & SA_NOCLDWAIT));
+	spin_unlock(&psig->siglock);
+	return ret;
+}
+
+/*
  * Detach all tasks we were using ptrace on.
  * Any that need to be release_task'd are put on the @dead list.
  *
@@ -705,6 +721,7 @@ static void exit_mm(struct task_struct * tsk)
 static void ptrace_exit(struct task_struct *parent, struct list_head *dead)
 {
 	struct task_struct *p, *n;
+	int ign = -1;
 
 	list_for_each_entry_safe(p, n, &parent->ptraced, ptrace_entry) {
 		__ptrace_unlink(p);
@@ -720,10 +737,18 @@ static void ptrace_exit(struct task_struct *parent, struct list_head *dead)
 		 * release_task() here because we already hold tasklist_lock.
 		 *
 		 * If it's our own child, there is no notification to do.
+		 * But if our normal children self-reap, then this child
+		 * was prevented by ptrace and we must reap it now.
 		 */
 		if (!task_detached(p) && thread_group_empty(p)) {
 			if (!same_thread_group(p->real_parent, parent))
 				do_notify_parent(p, p->exit_signal);
+			else {
+				if (ign < 0)
+					ign = ignoring_children(parent);
+				if (ign)
+					p->exit_signal = -1;
+			}
 		}
 
 		if (task_detached(p)) {
