Return-Path: <linux-kernel-owner+w=401wt.eu-S932196AbZJ0I1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932196AbZJ0I1f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 04:27:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932140AbZJ0I1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 04:27:33 -0400
Received: from mailgw.miraclelinux.com ([122.216.84.157]:61918 "EHLO
	mailgw.miraclelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932184AbZJ0I1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 04:27:30 -0400
Message-ID: <4AE6AEEB.3020109@miraclelinux.com>
Date: Tue, 27 Oct 2009 17:27:23 +0900
From: nooiwa <nooiwa@miraclelinux.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
CC: Ingo Molnar <mingo@elte.hu>, roland@redhat.com, akpm@linux-foundation.org,
       oleg@redhat.com, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] show message when exceeded rlimit of pending signals
References: <4AE1804A.2050404@miraclelinux.com> <20091023114600.GG5886@elte.hu> <4AE2A6A1.1070904@miraclelinux.com> <4AE2C151.8070006@miraclelinux.com> <20091024085848.GA23215@elte.hu> <4AE57745.8080701@miraclelinux.com> <20091026113800.GA9503@elte.hu> <4AE5D0B2.2050706@miraclelinux.com> <20091026202808.GA7107@elte.hu> <4AE661D4.5090306@miraclelinux.com> <4AE678C6.2090007@ct.jp.nec.com>
In-Reply-To: <4AE678C6.2090007@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hiroshi

> And nitpicks below.

Thank you so much.
Sorry, I will run scripts/checkpatch.pl in the next time.

> there are white spaces before tabs.

oops...

>> +		printk(KERN_WARNING "%s/%d: reached the limit of pending signals.\n",
current->comm, current->pid);
>
> this line over 80 characters.

I deleted "KERN_WARNING", because there is not it in print_faital_signal().


Thanks you.
Naohiro Ooiwa


Signed-off-by: Naohiro Ooiwa <nooiwa@miraclelinux.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
---
 Documentation/kernel-parameters.txt |   11 +++++++++--
 kernel/signal.c                     |   17 ++++++++++++++---
 2 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/Documentation/kernel-parameters.txt
b/Documentation/kernel-parameters.txt
index 9107b38..6b74dd4 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2032,8 +2032,15 @@ and is between 256 and 4096 characters. It is
defined in the file

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
index 6705320..8588833 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -41,6 +41,8 @@

 static struct kmem_cache *sigqueue_cachep;

+int print_fatal_signals __read_mostly;
+
 static void __user *sig_handler(struct task_struct *t, int sig)
 {
 	return t->sighand->action[sig - 1].sa.sa_handler;
@@ -188,6 +190,13 @@ int next_signal(struct sigpending *pending,
sigset_t *mask)
 	return sig;
 }

+static void show_reach_rlimit_sigpending(void)
+{
+	if (printk_ratelimit())
+		printk("%s/%d: reached the limit of pending signals.\n",
+				current->comm, current->pid);
+}
+
 /*
  * allocate a new signal queue record
  * - this may be called without locks if and only if t == current,
otherwise an
@@ -209,8 +218,12 @@ static struct sigqueue *__sigqueue_alloc(struct
task_struct *t, gfp_t flags,
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
@@ -925,8 +938,6 @@ static int send_signal(int sig, struct siginfo
*info, struct task_struct *t,
 	return __send_signal(sig, info, t, group, from_ancestor_ns);
 }

-int print_fatal_signals;
-
 static void print_fatal_signal(struct pt_regs *regs, int signr)
 {
 	printk("%s/%d: potentially unexpected fatal signal %d.\n",
-- 1.5.4.1




Hiroshi Shimamoto wrote:
> Naohiro Ooiwa wrote:
>> Hi Ingo,
>>
>>> Here's a slightly improved version of the text:
>> Thank you for your review and collect my English.
>>
>>>> +int print_fatal_signals;
>>> i'd suggest __read_mostly.
>>> Plus please move variables to the top of the file. (i know this comes
>>> from the previous code but we can improve it while we are touching it)
>> Of course. You're right, if we found one like it,
>> I want to improve the code little by little too.
>>
>> How is the following patch.
> 
> If you can provide a test case, it's helpful to confirm this improve.
> And nitpicks below.
> 
>> Signed-off-by: Naohiro Ooiwa <nooiwa@miraclelinux.com>
>> Acked-by: Ingo Molnar <mingo@elte.hu>
>> ---
>>  Documentation/kernel-parameters.txt |   13 ++++++++++---
>>  kernel/signal.c                     |   16 +++++++++++++---
>>  2 files changed, 23 insertions(+), 6 deletions(-)
>>
>> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
>> index 9107b38..8492ad3 100644
>> --- a/Documentation/kernel-parameters.txt
>> +++ b/Documentation/kernel-parameters.txt
>> @@ -2032,9 +2032,16 @@ and is between 256 and 4096 characters. It is defined in the file
>>
>>  	print-fatal-signals=
>>  			[KNL] debug: print fatal signals
>> -			print-fatal-signals=1: print segfault info to
>> -			the kernel console.
>> -			default: off.
>> +
>> + 			If enabled, warn about various signal handling
>> + 			related application anomalies: too many signals,
>> + 			too many POSIX.1 timers, fatal signals causing a
>> + 			coredump - etc.
>> +
>> + 			If you hit the warning due to signal overflow,
>> + 			you might want to try "ulimit -i unlimited".
>> +
>> + 			default: off.
> 
> there are white spaces before tabs.
> 
>>  	printk.time=	Show timing data prefixed to each printk message line
>>  			Format: <bool>  (1/Y/y=enable, 0/N/n=disable)
>> diff --git a/kernel/signal.c b/kernel/signal.c
>> index 6705320..c913eb7 100644
>> --- a/kernel/signal.c
>> +++ b/kernel/signal.c
>> @@ -41,6 +41,8 @@
>>
>>  static struct kmem_cache *sigqueue_cachep;
>>
>> +int print_fatal_signals __read_mostly;
>> +
>>  static void __user *sig_handler(struct task_struct *t, int sig)
>>  {
>>  	return t->sighand->action[sig - 1].sa.sa_handler;
>> @@ -188,6 +190,12 @@ int next_signal(struct sigpending *pending, sigset_t *mask)
>>  	return sig;
>>  }
>>
>> +static void show_reach_rlimit_sigpending(void)
>> +{
>> +	if (printk_ratelimit())
>> +		printk(KERN_WARNING "%s/%d: reached the limit of pending signals.\n", current->comm, current->pid);
> 
> this line over 80 characters.
> 
> thanks,
> Hiroshi


