Return-Path: <linux-kernel-owner+w=401wt.eu-S1754137AbZJ0EiK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137AbZJ0EiK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 00:38:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752166AbZJ0EiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 00:38:09 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:60312 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbZJ0EiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 00:38:09 -0400
Message-ID: <4AE678C6.2090007@ct.jp.nec.com>
Date: Tue, 27 Oct 2009 13:36:22 +0900
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Naohiro Ooiwa <nooiwa@miraclelinux.com>
CC: Ingo Molnar <mingo@elte.hu>, roland@redhat.com, akpm@linux-foundation.org,
       oleg@redhat.com, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] show message when exceeded rlimit of pending signals
References: <4AE1804A.2050404@miraclelinux.com> <20091023114600.GG5886@elte.hu> <4AE2A6A1.1070904@miraclelinux.com> <4AE2C151.8070006@miraclelinux.com> <20091024085848.GA23215@elte.hu> <4AE57745.8080701@miraclelinux.com> <20091026113800.GA9503@elte.hu> <4AE5D0B2.2050706@miraclelinux.com> <20091026202808.GA7107@elte.hu> <4AE661D4.5090306@miraclelinux.com>
In-Reply-To: <4AE661D4.5090306@miraclelinux.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Naohiro Ooiwa wrote:
> Hi Ingo,
> 
>> Here's a slightly improved version of the text:
> 
> Thank you for your review and collect my English.
> 
>>> +int print_fatal_signals;
>> i'd suggest __read_mostly.
> 
>> Plus please move variables to the top of the file. (i know this comes
>> from the previous code but we can improve it while we are touching it)
> 
> Of course. You're right, if we found one like it,
> I want to improve the code little by little too.
> 
> How is the following patch.

If you can provide a test case, it's helpful to confirm this improve.
And nitpicks below.

> 
> Signed-off-by: Naohiro Ooiwa <nooiwa@miraclelinux.com>
> Acked-by: Ingo Molnar <mingo@elte.hu>
> ---
>  Documentation/kernel-parameters.txt |   13 ++++++++++---
>  kernel/signal.c                     |   16 +++++++++++++---
>  2 files changed, 23 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 9107b38..8492ad3 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -2032,9 +2032,16 @@ and is between 256 and 4096 characters. It is defined in the file
> 
>  	print-fatal-signals=
>  			[KNL] debug: print fatal signals
> -			print-fatal-signals=1: print segfault info to
> -			the kernel console.
> -			default: off.
> +
> + 			If enabled, warn about various signal handling
> + 			related application anomalies: too many signals,
> + 			too many POSIX.1 timers, fatal signals causing a
> + 			coredump - etc.
> +
> + 			If you hit the warning due to signal overflow,
> + 			you might want to try "ulimit -i unlimited".
> +
> + 			default: off.

there are white spaces before tabs.

> 
>  	printk.time=	Show timing data prefixed to each printk message line
>  			Format: <bool>  (1/Y/y=enable, 0/N/n=disable)
> diff --git a/kernel/signal.c b/kernel/signal.c
> index 6705320..c913eb7 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -41,6 +41,8 @@
> 
>  static struct kmem_cache *sigqueue_cachep;
> 
> +int print_fatal_signals __read_mostly;
> +
>  static void __user *sig_handler(struct task_struct *t, int sig)
>  {
>  	return t->sighand->action[sig - 1].sa.sa_handler;
> @@ -188,6 +190,12 @@ int next_signal(struct sigpending *pending, sigset_t *mask)
>  	return sig;
>  }
> 
> +static void show_reach_rlimit_sigpending(void)
> +{
> +	if (printk_ratelimit())
> +		printk(KERN_WARNING "%s/%d: reached the limit of pending signals.\n", current->comm, current->pid);

this line over 80 characters.

thanks,
Hiroshi
