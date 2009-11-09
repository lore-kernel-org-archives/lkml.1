Return-Path: <linux-kernel-owner+w=401wt.eu-S1754898AbZKIJ3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898AbZKIJ3v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 04:29:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751452AbZKIJ3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 04:29:50 -0500
Received: from hera.kernel.org ([140.211.167.34]:46939 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985AbZKIJ3t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 04:29:49 -0500
Date: Mon, 9 Nov 2009 09:28:17 GMT
From: tip-bot for Naohiro Ooiwa <nooiwa@miraclelinux.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, h-shimamoto@ct.jp.nec.com, roland@redhat.com,
       nooiwa@miraclelinux.com, akpm@linux-foundation.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, h-shimamoto@ct.jp.nec.com, roland@redhat.com,
       nooiwa@miraclelinux.com, akpm@linux-foundation.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <4AF6E7E2.9080406@miraclelinux.com>
References: <4AF6E7E2.9080406@miraclelinux.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/signal] signal: Print warning message when dropping signals
Message-ID: <tip-f84d49b218b7d4c6cba2e0b41f24bd4045403962@git.kernel.org>
Git-Commit-ID: f84d49b218b7d4c6cba2e0b41f24bd4045403962
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f84d49b218b7d4c6cba2e0b41f24bd4045403962
Gitweb:     http://git.kernel.org/tip/f84d49b218b7d4c6cba2e0b41f24bd4045403962
Author:     Naohiro Ooiwa <nooiwa@miraclelinux.com>
AuthorDate: Mon, 9 Nov 2009 00:46:42 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 9 Nov 2009 09:44:26 +0100

signal: Print warning message when dropping signals

When the system has too many timers or too many aggregate
queued signals, the EAGAIN error is returned to application
from kernel, including timer_create() [POSIX.1b].

It means that the app exceeded the limit of pending signals,
but in general application writers do not expect this
outcome and the current silent failure can cause rare app
failures under very high load.

This patch adds a new message when we reach the limit
and if print_fatal_signals is enabled:

    task/1234: reached RLIMIT_SIGPENDING, dropping signal

If you see this message and your system behaved unexpectedly,
you can run following command to lift the limit:

   # ulimit -i unlimited

With help from Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>.

Signed-off-by: Naohiro Ooiwa <nooiwa@miraclelinux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: oleg@redhat.com
LKML-Reference: <4AF6E7E2.9080406@miraclelinux.com>
[ Modified a few small details, gave surrounding code some love. ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 Documentation/kernel-parameters.txt |   11 +++++++-
 kernel/signal.c                     |   46 +++++++++++++++++++++++++----------
 2 files changed, 42 insertions(+), 15 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 9107b38..3bbd92f 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2032,8 +2032,15 @@ and is between 256 and 4096 characters. It is defined in the file
 
 	print-fatal-signals=
 			[KNL] debug: print fatal signals
-			print-fatal-signals=1: print segfault info to
-			the kernel console.
+
+			If enabled, warn about various signal handling
+			related application anomalies: too many signals,
+			too many POSIX.1 timers, fatal signals causing a
+			coredump - etc.
+
+			If you hit the warning due to signal overflow,
+			you might want to try "ulimit -i unlimited".
+
 			default: off.
 
 	printk.time=	Show timing data prefixed to each printk message line
diff --git a/kernel/signal.c b/kernel/signal.c
index 6705320..fe08008 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -22,6 +22,7 @@
 #include <linux/ptrace.h>
 #include <linux/signal.h>
 #include <linux/signalfd.h>
+#include <linux/ratelimit.h>
 #include <linux/tracehook.h>
 #include <linux/capability.h>
 #include <linux/freezer.h>
@@ -41,6 +42,8 @@
 
 static struct kmem_cache *sigqueue_cachep;
 
+int print_fatal_signals __read_mostly;
+
 static void __user *sig_handler(struct task_struct *t, int sig)
 {
 	return t->sighand->action[sig - 1].sa.sa_handler;
@@ -159,7 +162,7 @@ int next_signal(struct sigpending *pending, sigset_t *mask)
 {
 	unsigned long i, *s, *m, x;
 	int sig = 0;
-	
+
 	s = pending->signal.sig;
 	m = mask->sig;
 	switch (_NSIG_WORDS) {
@@ -184,17 +187,31 @@ int next_signal(struct sigpending *pending, sigset_t *mask)
 			sig = ffz(~x) + 1;
 		break;
 	}
-	
+
 	return sig;
 }
 
+static inline void print_dropped_signal(int sig)
+{
+	static DEFINE_RATELIMIT_STATE(ratelimit_state, 5 * HZ, 10);
+
+	if (!print_fatal_signals)
+		return;
+
+	if (!__ratelimit(&ratelimit_state))
+		return;
+
+	printk(KERN_INFO "%s/%d: reached RLIMIT_SIGPENDING, dropped signal %d\n",
+				current->comm, current->pid, sig);
+}
+
 /*
  * allocate a new signal queue record
  * - this may be called without locks if and only if t == current, otherwise an
  *   appopriate lock must be held to stop the target task from exiting
  */
-static struct sigqueue *__sigqueue_alloc(struct task_struct *t, gfp_t flags,
-					 int override_rlimit)
+static struct sigqueue *
+__sigqueue_alloc(int sig, struct task_struct *t, gfp_t flags, int override_rlimit)
 {
 	struct sigqueue *q = NULL;
 	struct user_struct *user;
@@ -207,10 +224,15 @@ static struct sigqueue *__sigqueue_alloc(struct task_struct *t, gfp_t flags,
 	 */
 	user = get_uid(__task_cred(t)->user);
 	atomic_inc(&user->sigpending);
+
 	if (override_rlimit ||
 	    atomic_read(&user->sigpending) <=
-			t->signal->rlim[RLIMIT_SIGPENDING].rlim_cur)
+			t->signal->rlim[RLIMIT_SIGPENDING].rlim_cur) {
 		q = kmem_cache_alloc(sigqueue_cachep, flags);
+	} else {
+		print_dropped_signal(sig);
+	}
+
 	if (unlikely(q == NULL)) {
 		atomic_dec(&user->sigpending);
 		free_uid(user);
@@ -869,7 +891,7 @@ static int __send_signal(int sig, struct siginfo *info, struct task_struct *t,
 	else
 		override_rlimit = 0;
 
-	q = __sigqueue_alloc(t, GFP_ATOMIC | __GFP_NOTRACK_FALSE_POSITIVE,
+	q = __sigqueue_alloc(sig, t, GFP_ATOMIC | __GFP_NOTRACK_FALSE_POSITIVE,
 		override_rlimit);
 	if (q) {
 		list_add_tail(&q->list, &pending->list);
@@ -925,8 +947,6 @@ static int send_signal(int sig, struct siginfo *info, struct task_struct *t,
 	return __send_signal(sig, info, t, group, from_ancestor_ns);
 }
 
-int print_fatal_signals;
-
 static void print_fatal_signal(struct pt_regs *regs, int signr)
 {
 	printk("%s/%d: potentially unexpected fatal signal %d.\n",
@@ -1293,19 +1313,19 @@ EXPORT_SYMBOL(kill_pid);
  * These functions support sending signals using preallocated sigqueue
  * structures.  This is needed "because realtime applications cannot
  * afford to lose notifications of asynchronous events, like timer
- * expirations or I/O completions".  In the case of Posix Timers 
+ * expirations or I/O completions".  In the case of Posix Timers
  * we allocate the sigqueue structure from the timer_create.  If this
  * allocation fails we are able to report the failure to the application
  * with an EAGAIN error.
  */
- 
 struct sigqueue *sigqueue_alloc(void)
 {
-	struct sigqueue *q;
+	struct sigqueue *q = __sigqueue_alloc(-1, current, GFP_KERNEL, 0);
 
-	if ((q = __sigqueue_alloc(current, GFP_KERNEL, 0)))
+	if (q)
 		q->flags |= SIGQUEUE_PREALLOC;
-	return(q);
+
+	return q;
 }
 
 void sigqueue_free(struct sigqueue *q)
