Return-Path: <linux-kernel-owner+w=401wt.eu-S1757278AbYEKOKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757278AbYEKOKm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 10:10:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753748AbYEKOKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 10:10:33 -0400
Received: from smtp1.stealer.net ([88.198.224.204]:43142 "EHLO
	smtp1.stealer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267AbYEKOKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 10:10:32 -0400
Date: Sun, 11 May 2008 16:10:13 +0200 (CEST)
From: Sven Wegener <sven.wegener@stealer.net>
To: Matthew Wilcox <matthew@wil.cx>
cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] scheduler fixes
In-Reply-To: <20080511110306.GP19219@parisc-linux.org>
Message-ID: <Pine.LNX.4.64.0805111604210.32758@titan.stealer.net>
References: <alpine.LFD.1.10.0805070728280.32269@woody.linux-foundation.org>
 <alpine.LFD.1.10.0805070817060.3024@woody.linux-foundation.org>
 <1210214696.3453.87.camel@ymzhang> <alpine.LFD.1.10.0805072014330.3024@woody.linux-foundation.org>
 <1210219729.3453.97.camel@ymzhang> <alpine.LFD.1.10.0805072115190.3024@woody.linux-foundation.org>
 <20080508120130.GA2860@elte.hu> <20080508122802.GA4880@elte.hu>
 <20080508144316.GA9869@elte.hu> <20080508151028.GA12109@elte.hu>
 <20080511110306.GP19219@parisc-linux.org>
Organization: STEALER.net
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Spam-Score: -2.5
X-Spam-Bar: --
X-Spam-Report: Scanned by SpamAssassin 3.2.1-gr1 2007-05-02 on smtp1.stealer.net at Sun, 11 May 2008 14:10:26 +0000
	Bayes: 0.0000 Tokens: new, 236; hammy, 8; neutral, 2; spammy, 0.
	AutoLearn: no
	*  0.1 RDNS_NONE Delivered to trusted network by a host with no rDNS
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
X-Spam-Signature: bccf42f8e3b26327703a61cd6e556c9189a96e56
X-DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 May 2008, Matthew Wilcox wrote:

> On Thu, May 08, 2008 at 05:10:28PM +0200, Ingo Molnar wrote:
>> @@ -258,7 +256,5 @@ static noinline void __sched __up(struct semaphore *sem)
>>  {
>>  	struct semaphore_waiter *waiter = list_first_entry(&sem->wait_list,
>>  						struct semaphore_waiter, list);
>> -	list_del(&waiter->list);
>> -	waiter->up = 1;
>>  	wake_up_process(waiter->task);
>>  }
>
> This might be the problem that causes the missing wakeups.  If you have a
> semaphore with n=2, and four processes calling down(), tasks A and B
> acquire the semaphore and tasks C and D go to sleep.  Task A calls up()
> and wakes up C.  Then task B calls up() and doesn't wake up anyone
> because C hasn't run yet.  I think we need another wakeup when task C
> finishes in __down_common, like this (on top of your patch):
>
> diff --git a/kernel/semaphore.c b/kernel/semaphore.c
> index 5e41217..e520ad4 100644
> --- a/kernel/semaphore.c
> +++ b/kernel/semaphore.c
> @@ -229,6 +229,11 @@ static inline int __sched __down_common(struct semaphore *sem, long state,
> 	}
>
> 	list_del(&waiter.list);
> +
> +	/* It's possible we need to wake up the next task on the list too */
> +	if (unlikely(sem->count > 1) && !list_empty(&sem->wait_list))
> +		__up(sem);
> +
> 	return ret;
> }
>
> Sven, can you try this with your workload?  I suspect this might be it
> because XFS does use semaphores with n>1.

This one fixes the regression too, after applying it on top of bf726e.

Sven
