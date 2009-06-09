Return-Path: <linux-kernel-owner+w=401wt.eu-S1762267AbZFIKco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762267AbZFIKco (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 06:32:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759916AbZFIKVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 06:21:11 -0400
Received: from kroah.org ([198.145.64.141]:55324 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932127AbZFIKVK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 06:21:10 -0400
X-Mailbox-Line: From greg@blue.kroah.org Tue Jun  9 02:41:07 2009
Message-Id: <20090609094107.093854872@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 09 Jun 2009 02:39:52 -0700
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
Subject: [patch 64/87] ptrace: simplify ptrace_exit()->ignoring_children() path
References: <20090609093848.204935043@blue.kroah.org>
Content-Disposition: inline; filename=ptrace-simplify-ptrace_exit-ignoring_children-path.patch
In-Reply-To: <20090609094451.GA26439@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit 6d69cb87f05eef3b02370b2f7bae608ad2301a00 upstream.

ignoring_children() takes parent->sighand->siglock and checks
k_sigaction[SIGCHLD] atomically.  But this buys nothing, we can't get the
"really" wrong result even if we race with sigaction(SIGCHLD).  If we read
the "stale" sa_handler/sa_flags we can pretend it was changed right after
the check.

Remove spin_lock(->siglock), and kill "int ign" which caches the result of
ignoring_children() which becomes rather trivial.

Perhaps it makes sense to export this helper, do_notify_parent() can use
it too.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/exit.c |   25 ++++++++-----------------
 1 file changed, 8 insertions(+), 17 deletions(-)

--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -703,19 +703,15 @@ static void exit_mm(struct task_struct *
 }
 
 /*
- * Return nonzero if @parent's children should reap themselves.
- *
- * Called with write_lock_irq(&tasklist_lock) held.
+ * Called with irqs disabled, returns true if childs should reap themselves.
  */
-static int ignoring_children(struct task_struct *parent)
+static int ignoring_children(struct sighand_struct *sigh)
 {
 	int ret;
-	struct sighand_struct *psig = parent->sighand;
-	unsigned long flags;
-	spin_lock_irqsave(&psig->siglock, flags);
-	ret = (psig->action[SIGCHLD-1].sa.sa_handler == SIG_IGN ||
-	       (psig->action[SIGCHLD-1].sa.sa_flags & SA_NOCLDWAIT));
-	spin_unlock_irqrestore(&psig->siglock, flags);
+	spin_lock(&sigh->siglock);
+	ret = (sigh->action[SIGCHLD-1].sa.sa_handler == SIG_IGN) ||
+	      (sigh->action[SIGCHLD-1].sa.sa_flags & SA_NOCLDWAIT);
+	spin_unlock(&sigh->siglock);
 	return ret;
 }
 
@@ -728,7 +724,6 @@ static int ignoring_children(struct task
 static void ptrace_exit(struct task_struct *parent, struct list_head *dead)
 {
 	struct task_struct *p, *n;
-	int ign = -1;
 
 	list_for_each_entry_safe(p, n, &parent->ptraced, ptrace_entry) {
 		__ptrace_unlink(p);
@@ -750,12 +745,8 @@ static void ptrace_exit(struct task_stru
 		if (!task_detached(p) && thread_group_empty(p)) {
 			if (!same_thread_group(p->real_parent, parent))
 				do_notify_parent(p, p->exit_signal);
-			else {
-				if (ign < 0)
-					ign = ignoring_children(parent);
-				if (ign)
-					p->exit_signal = -1;
-			}
+			else if (ignoring_children(parent->sighand))
+				p->exit_signal = -1;
 		}
 
 		if (task_detached(p)) {


