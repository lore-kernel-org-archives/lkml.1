Return-Path: <linux-kernel-owner+w=401wt.eu-S1755523AbZJZKRj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523AbZJZKRj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 06:17:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755510AbZJZKRi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 06:17:38 -0400
Received: from mailgw.miraclelinux.com ([122.216.84.157]:18504 "EHLO
	mailgw.miraclelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755501AbZJZKRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 06:17:37 -0400
Message-ID: <4AE57745.8080701@miraclelinux.com>
Date: Mon, 26 Oct 2009 19:17:41 +0900
From: nooiwa <nooiwa@miraclelinux.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: roland@redhat.com, akpm@linux-foundation.org, oleg@redhat.com,
       LKML <linux-kernel@vger.kernel.org>, h-shimamoto@ct.jp.nec.com,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] show message when exceeded rlimit of pending signals
References: <4AE1804A.2050404@miraclelinux.com> <20091023114600.GG5886@elte.hu> <4AE2A6A1.1070904@miraclelinux.com> <4AE2C151.8070006@miraclelinux.com> <20091024085848.GA23215@elte.hu>
In-Reply-To: <20091024085848.GA23215@elte.hu>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo

I remade a patch.

I already tested it. The result was good for me.
Could you please check it.

Thanks you.
Naohiro Ooiwa


Signed-off-by: Naohiro Ooiwa <nooiwa@miraclelinux.com>
---
 Documentation/kernel-parameters.txt |   14 ++++++++++++++
 kernel/signal.c                     |   24 +++++++++++++++++++++++-
 kernel/sysctl.c                     |    9 +++++++++
 3 files changed, 46 insertions(+), 1 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 9107b38..37104b1 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2036,6 +2036,20 @@ and is between 256 and 4096 characters. It is defined in the file
 			the kernel console.
 			default: off.

+	print-reach-rlimit-sigpending=
+			[KNL] debug: print caution that reached the limit of
+			pending signals.
+			If your working system may have too many POSIX.1 timers
+			or during the system test, you may as well to enable
+			this parameter.
+			print-reach-rlimit-sigpending=0: disable this print
+			print-reach-rlimit-sigpending=1: print message that
+			reached	the limit of pending signals to the kernel
+			console.
+			When this message is printed, maybe you should try to
+			"ulimit -i unlimited".
+			default: off.
+
 	printk.time=	Show timing data prefixed to each printk message line
 			Format: <bool>  (1/Y/y=enable, 0/N/n=disable)

diff --git a/kernel/signal.c b/kernel/signal.c
index 6705320..9943e71 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -188,6 +188,24 @@ int next_signal(struct sigpending *pending, sigset_t *mask)
 	return sig;
 }

+int print_reach_rlimit_sigpending;
+
+static void show_reach_rlimit_sigpending(void)
+{
+	if (printk_ratelimit())
+		printk(KERN_WARNING "%s/%d: reached the limit of
+			pending signals.\n", current->comm, current->pid);
+}
+
+static int __init setup_print_reach_rlimit_sigpending(char *str)
+{
+	get_option(&str, &print_reach_rlimit_sigpending);
+
+	return 1;
+}
+
+__setup("print-reach-rlimit-sigpending=", setup_print_reach_rlimit_sigpending);
+
 /*
  * allocate a new signal queue record
  * - this may be called without locks if and only if t == current, otherwise an
@@ -209,8 +227,12 @@ static struct sigqueue *__sigqueue_alloc(struct task_struct *t, gfp_t flags,
 	atomic_inc(&user->sigpending);
 	if (override_rlimit ||
 	    atomic_read(&user->sigpending) <=
-			t->signal->rlim[RLIMIT_SIGPENDING].rlim_cur)
+			t->signal->rlim[RLIMIT_SIGPENDING].rlim_cur) {
 		q = kmem_cache_alloc(sigqueue_cachep, flags);
+	} else {
+		if (print_reach_rlimit_sigpending)
+			show_reach_rlimit_sigpending();
+	}
 	if (unlikely(q == NULL)) {
 		atomic_dec(&user->sigpending);
 		free_uid(user);
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 0d949c5..93b2760 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -67,6 +67,7 @@ static int deprecated_sysctl_warning(struct __sysctl_args *args);
 /* External variables not in a header file. */
 extern int C_A_D;
 extern int print_fatal_signals;
+extern int print_reach_rlimit_sigpending;
 extern int sysctl_overcommit_memory;
 extern int sysctl_overcommit_ratio;
 extern int sysctl_panic_on_oom;
@@ -467,6 +468,14 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec,
 	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "print-reach-rlimit-sigpending",
+		.data		= &print_reach_rlimit_sigpending,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
 #ifdef CONFIG_SPARC
 	{
 		.ctl_name	= KERN_SPARC_REBOOT,
-- 1.5.4.1

Ingo Molnar wrote:
> * Naohiro Ooiwa <nooiwa@miraclelinux.com> wrote:
> 
>> Hi Ingo, Roland,
>>
>> Now, I received a nice comment from OGAWA-san.
>> How is this impriment like a print_faital_signal().
>>
>> I think it's very nice.
> 
> Agreed - i just wanted to suggest that too. print_fatal_signals is 
> already a switch that turns on warnings about 'weird looking signal 
> behavior'. print-on-overflow seems like a good match.
> 
> 	Ingo



