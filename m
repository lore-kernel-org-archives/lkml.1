Return-Path: <linux-kernel-owner+w=401wt.eu-S1753967AbZKHPqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967AbZKHPqa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 10:46:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752831AbZKHPqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 10:46:30 -0500
Received: from mailgw.miraclelinux.com ([122.216.84.157]:35667 "EHLO
	mailgw.miraclelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715AbZKHPq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 10:46:29 -0500
Message-ID: <4AF6E7E2.9080406@miraclelinux.com>
Date: Mon, 09 Nov 2009 00:46:42 +0900
From: Naohiro Ooiwa <nooiwa@miraclelinux.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
       Roland McGrath <roland@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, oleg@redhat.com
Subject: [PATCH] extend print_fatal_signals for reached RLIMIT_SIGPENDING
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the system has too many timers or too many aggregate
queued signals, the EAGAIN error is returned to application
from kernel, including timer_create().
It means that exceeded limit of pending signals at all.
But we can't imagine it.

This patch show the message when reached limit of pending signals
and enabled print_fatal_signals.
If you see this message and your system behaved unexpectedly,
you can run following command.
   # ulimit -i unlimited

With help from Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>.


Signed-off-by: Naohiro Ooiwa <nooiwa@miraclelinux.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
---
 Documentation/kernel-parameters.txt |   11 +++++++++--
 kernel/signal.c                     |   21 ++++++++++++++++++---
 2 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/Documentation/kernel-parameters.txt
b/Documentation/kernel-parameters.txt
index 9107b38..3bbd92f 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2032,8 +2032,15 @@ and is between 256 and 4096 characters. It is defined in
the file

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
index 6705320..56e9c00 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -41,6 +41,8 @@

 static struct kmem_cache *sigqueue_cachep;

+int print_fatal_signals __read_mostly;
+
 static void __user *sig_handler(struct task_struct *t, int sig)
 {
 	return t->sighand->action[sig - 1].sa.sa_handler;
@@ -188,6 +190,17 @@ int next_signal(struct sigpending *pending, sigset_t *mask)
 	return sig;
 }

+static void show_reach_rlimit_sigpending(void)
+{
+	static DEFINE_RATELIMIT_STATE(printk_rl_state, 5 * HZ, 10);
+
+	if (!__ratelimit(&printk_rl_state))
+		return;
+
+	printk(KERN_INFO "%s/%d: reached RLIMIT_SIGPENDING.\n",
+				current->comm, current->pid);
+}
+
 /*
  * allocate a new signal queue record
  * - this may be called without locks if and only if t == current, otherwise an
@@ -209,8 +222,12 @@ static struct sigqueue *__sigqueue_alloc(struct task_struct
*t, gfp_t flags,
 	atomic_inc(&user->sigpending);
 	if (override_rlimit ||
 	    atomic_read(&user->sigpending) <=
-			t->signal->rlim[RLIMIT_SIGPENDING].rlim_cur)
+			t->signal->rlim[RLIMIT_SIGPENDING].rlim_cur) {
 		q = kmem_cache_alloc(sigqueue_cachep, flags);
+	} else {
+		if (print_fatal_signals)
+			show_reach_rlimit_sigpending();
+	}
 	if (unlikely(q == NULL)) {
 		atomic_dec(&user->sigpending);
 		free_uid(user);
@@ -925,8 +942,6 @@ static int send_signal(int sig, struct siginfo *info, struct
task_struct *t,
 	return __send_signal(sig, info, t, group, from_ancestor_ns);
 }

-int print_fatal_signals;
-
 static void print_fatal_signal(struct pt_regs *regs, int signr)
 {
 	printk("%s/%d: potentially unexpected fatal signal %d.\n",
-- 1.5.4.1
