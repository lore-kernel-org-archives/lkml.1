Return-Path: <linux-kernel-owner+w=401wt.eu-S1754314AbZJaH6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314AbZJaH6s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Oct 2009 03:58:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753396AbZJaH6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Oct 2009 03:58:47 -0400
Received: from mailgw.miraclelinux.com ([122.216.84.157]:30391 "EHLO
	mailgw.miraclelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576AbZJaH6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Oct 2009 03:58:47 -0400
Message-ID: <4AEBEE38.50108@miraclelinux.com>
Date: Sat, 31 Oct 2009 16:58:48 +0900
From: Naohiro Ooiwa <nooiwa@miraclelinux.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
       roland@redhat.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, oleg@redhat.com
Subject: Re: [PATCH] show message when exceeded rlimit of pending signals
References: <4AEACFBF.4060108@miraclelinux.com> <20091030143333.414ea29c.akpm@linux-foundation.org>
In-Reply-To: <20091030143333.414ea29c.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 30 Oct 2009 20:36:31 +0900
> Naohiro Ooiwa <nooiwa@miraclelinux.com> wrote:
> 
>> Hi Ingo,
>>
>> I wrote proper changelog entry.
>> And I resent the patch. I added KERN_INFO to printk.
>>
>>
>>
>> When the system has too many timers or too many aggregate
>> queued signals, the EAGAIN error is returned to application
>> from kernel, including timer_create().
>> It means that exceeded limit of pending signals at all.
>> But we can't imagine it.
>>
>> This patch show the message when reached limit of pending signals.
>> If you see this message and your system behaved unexpectedly,
>> you can run following command.
>>    # ulimit -i unlimited
>>
>> With help from Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>.
>>
>>
>> ...
>>
>> diff --git a/kernel/signal.c b/kernel/signal.c
>> index 6705320..50e10dc 100644
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
>> @@ -188,6 +190,14 @@ int next_signal(struct sigpending *pending, sigset_t *mask)
>>  	return sig;
>>  }
>>
>> +static void show_reach_rlimit_sigpending(void)
>> +{
>> +	if (!printk_ratelimit())
>> +		return;
> 
> printk_ratelimit() is a bad thing and we should be working toward
> removing it altogether, not adding new callers.
> 
> Because it uses global state.  So if subsystem A is trying to generate
> lots of printk's, subsystem B's important message might get
> accidentally suppressed.
> 
> It's better to use DEFINE_RATELIMIT_STATE() and __ratelimit() directly.


Thank you for your advices.
And I was glad to talk to you in Japan Linux Symposium.

I got it, now that you mention it.
I will fix my patch.

> 
>> +	printk(KERN_INFO "%s/%d: reached the limit of pending signals.\n",
>> +				current->comm, current->pid);
> 
> I suggest that this be
> 
> 	"reached RLIMIT_SIGPENDING"
> 
> because RLIMIT_SIGPENDING is a well-understood term and concept.
> 

OK, I see.

>>  static void print_fatal_signal(struct pt_regs *regs, int signr)
>>  {
>> -	printk("%s/%d: potentially unexpected fatal signal %d.\n",
>> +	printk(KERN_INFO "%s/%d: potentially unexpected fatal signal %d.\n",
>>  		current->comm, task_pid_nr(current), signr);
>>
> 
> This is an unchangelogged, unrelated, non-backward-compatible
> user-visible change.  For some people, their machine which used to
> print this warning will mysteriously stop doing so when they upgrade
> their kernels.
> 
> That doesn't mean that we shouldn't make the change.  But we should
> have a think about it and we shouldn't hide changes of this nature
> inside some other patch like this.
> 

You are right.
I'm sorry, I shouldn't habe done it.


Thanks you.
Naohiro Ooiwa
