Return-Path: <linux-kernel-owner+w=401wt.eu-S1753903AbZJaIuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903AbZJaIuW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Oct 2009 04:50:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752594AbZJaIuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Oct 2009 04:50:21 -0400
Received: from mailgw.miraclelinux.com ([122.216.84.157]:11952 "EHLO
	mailgw.miraclelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbZJaIuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Oct 2009 04:50:20 -0400
Message-ID: <4AEBFA46.8070709@miraclelinux.com>
Date: Sat, 31 Oct 2009 17:50:14 +0900
From: Naohiro Ooiwa <nooiwa@miraclelinux.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
       roland@redhat.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, oleg@redhat.com
Subject: Re: [PATCH] show message when exceeded rlimit of pending signals
References: <4AEACFBF.4060108@miraclelinux.com> <20091030143333.414ea29c.akpm@linux-foundation.org> <4AEBEE38.50108@miraclelinux.com>
In-Reply-To: <4AEBEE38.50108@miraclelinux.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Naohiro Ooiwa wrote:
> Andrew Morton wrote:
>> On Fri, 30 Oct 2009 20:36:31 +0900
>> Naohiro Ooiwa <nooiwa@miraclelinux.com> wrote:
>>>
>>> +static void show_reach_rlimit_sigpending(void)
>>> +{
>>> +	if (!printk_ratelimit())
>>> +		return;
>> printk_ratelimit() is a bad thing and we should be working toward
>> removing it altogether, not adding new callers.
>>
>> Because it uses global state.  So if subsystem A is trying to generate
>> lots of printk's, subsystem B's important message might get
>> accidentally suppressed.
>>
>> It's better to use DEFINE_RATELIMIT_STATE() and __ratelimit() directly.
> 
> 
> Thank you for your advices.
> And I was glad to talk to you in Japan Linux Symposium.
> 
> I got it, now that you mention it.
> I will fix my patch.
> 
>>> +	printk(KERN_INFO "%s/%d: reached the limit of pending signals.\n",
>>> +				current->comm, current->pid);
>> I suggest that this be
>>
>> 	"reached RLIMIT_SIGPENDING"
>>
>> because RLIMIT_SIGPENDING is a well-understood term and concept.
>>
> 
> OK, I see.

I fixed my patch.
Could you please check it.

Thanks you.
Naohiro Ooiwa


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
index 6705320..624a626 100644
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
+	DEFINE_RATELIMIT_STATE(printk_rl_state, 5 * HZ, 10);
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

