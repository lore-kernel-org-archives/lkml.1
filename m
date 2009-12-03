Return-Path: <linux-kernel-owner+w=401wt.eu-S1756587AbZLCSrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587AbZLCSrn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 13:47:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756119AbZLCSrm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 13:47:42 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49198 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756521AbZLCSrl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 13:47:41 -0500
Date: Thu, 3 Dec 2009 19:47:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>,
       Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL] core/signal for v2.6.33
Message-ID: <20091203184720.GA9244@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-signal-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-signal-for-linus

 Thanks,

	Ingo

------------------>
Naohiro Ooiwa (1):
      signal: Print warning message when dropping signals

Sebastian Andrzej Siewior (1):
      signal: Fix alternate signal stack check


 Documentation/kernel-parameters.txt |   11 +++++++-
 include/linux/sched.h               |   13 +++++++--
 kernel/signal.c                     |   46 +++++++++++++++++++++++++----------
 3 files changed, 52 insertions(+), 18 deletions(-)

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
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 75e6e60..0f67914 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2086,11 +2086,18 @@ static inline int is_si_special(const struct siginfo *info)
 	return info <= SEND_SIG_FORCED;
 }
 
-/* True if we are on the alternate signal stack.  */
-
+/*
+ * True if we are on the alternate signal stack.
+ */
 static inline int on_sig_stack(unsigned long sp)
 {
-	return (sp - current->sas_ss_sp < current->sas_ss_size);
+#ifdef CONFIG_STACK_GROWSUP
+	return sp >= current->sas_ss_sp &&
+		sp - current->sas_ss_sp < current->sas_ss_size;
+#else
+	return sp > current->sas_ss_sp &&
+		sp - current->sas_ss_sp <= current->sas_ss_size;
+#endif
 }
 
 static inline int sas_ss_flags(unsigned long sp)
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
