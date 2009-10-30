Return-Path: <linux-kernel-owner+w=401wt.eu-S1757181AbZJ3Lg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757181AbZJ3Lg2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 07:36:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756534AbZJ3Lg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 07:36:28 -0400
Received: from mailgw.miraclelinux.com ([122.216.84.157]:10853 "EHLO
	mailgw.miraclelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755806AbZJ3Lg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 07:36:27 -0400
Message-ID: <4AEACFBF.4060108@miraclelinux.com>
Date: Fri, 30 Oct 2009 20:36:31 +0900
From: Naohiro Ooiwa <nooiwa@miraclelinux.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>, roland@redhat.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, oleg@redhat.com,
       akpm@linux-foundation.org
Subject: [PATCH] show message when exceeded rlimit of pending signals
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

I wrote proper changelog entry.
And I resent the patch. I added KERN_INFO to printk.



When the system has too many timers or too many aggregate
queued signals, the EAGAIN error is returned to application
from kernel, including timer_create().
It means that exceeded limit of pending signals at all.
But we can't imagine it.

This patch show the message when reached limit of pending signals.
If you see this message and your system behaved unexpectedly,
you can run following command.
   # ulimit -i unlimited

With help from Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>.

Signed-off-by: Naohiro Ooiwa <nooiwa@miraclelinux.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
---
 Documentation/kernel-parameters.txt |   11 +++++++++--
 kernel/signal.c                     |   20 ++++++++++++++++----
 2 files changed, 25 insertions(+), 6 deletions(-)

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
index 6705320..50e10dc 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -41,6 +41,8 @@

 static struct kmem_cache *sigqueue_cachep;

+int print_fatal_signals __read_mostly;
+
 static void __user *sig_handler(struct task_struct *t, int sig)
 {
 	return t->sighand->action[sig - 1].sa.sa_handler;
@@ -188,6 +190,14 @@ int next_signal(struct sigpending *pending, sigset_t *mask)
 	return sig;
 }

+static void show_reach_rlimit_sigpending(void)
+{
+	if (!printk_ratelimit())
+		return;
+	printk(KERN_INFO "%s/%d: reached the limit of pending signals.\n",
+				current->comm, current->pid);
+}
+
 /*
  * allocate a new signal queue record
  * - this may be called without locks if and only if t == current, otherwise an
@@ -209,8 +219,12 @@ static struct sigqueue *__sigqueue_alloc(struct task_struct *t, gfp_t flags,
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
@@ -925,11 +939,9 @@ static int send_signal(int sig, struct siginfo *info, struct task_struct *t,
 	return __send_signal(sig, info, t, group, from_ancestor_ns);
 }

-int print_fatal_signals;
-
 static void print_fatal_signal(struct pt_regs *regs, int signr)
 {
-	printk("%s/%d: potentially unexpected fatal signal %d.\n",
+	printk(KERN_INFO "%s/%d: potentially unexpected fatal signal %d.\n",
 		current->comm, task_pid_nr(current), signr);

 #if defined(__i386__) && !defined(__arch_um__)
