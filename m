Return-Path: <linux-kernel-owner+w=401wt.eu-S1756711AbYEKNCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711AbYEKNCw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 09:02:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750913AbYEKNCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 09:02:45 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:56729 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986AbYEKNCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 09:02:44 -0400
Date: Sun, 11 May 2008 07:02:27 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Ingo Molnar <mingo@elte.hu>
Cc: Sven Wegener <sven.wegener@stealer.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] scheduler fixes
Message-ID: <20080511130226.GR19219@parisc-linux.org>
References: <1210219729.3453.97.camel@ymzhang> <alpine.LFD.1.10.0805072115190.3024@woody.linux-foundation.org> <20080508120130.GA2860@elte.hu> <20080508122802.GA4880@elte.hu> <20080508144316.GA9869@elte.hu> <20080508151028.GA12109@elte.hu> <20080511110306.GP19219@parisc-linux.org> <20080511114803.GA8289@parisc-linux.org> <20080511125049.GA22513@elte.hu> <20080511125216.GA25040@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080511125216.GA25040@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 11, 2008 at 02:52:16PM +0200, Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > > So I deem my fix "proven by thought experiment".  I haven't tried 
> > > booting it or anything.
> > 
> > i actually have two fixes, made earlier today. The 'fix3' one has been 
> > confirmed by Sven to fix the regression - but i think we need the 'fix
> > #2' one below as well to make it complete.
> 
> i just combined them into a single fix, see below.

That's mangled ... why did you move __up around?

>  	list_del(&waiter.list);
> +	if (unlikely(!list_empty(&sem->wait_list)) && sem->count)
> +		__up(sem);

That's an unnecessary wakeup compared to my patch.

>  	return ret;
>  }
>  
> @@ -254,9 +264,10 @@ static noinline int __sched __down_timeo
>  	return __down_common(sem, TASK_UNINTERRUPTIBLE, jiffies);
>  }
>  
> -static noinline void __sched __up(struct semaphore *sem)
> -{
> -	struct semaphore_waiter *waiter = list_first_entry(&sem->wait_list,
> -						struct semaphore_waiter, list);
> -	wake_up_process(waiter->task);
> -}
> +
> +	/*
> +	 * Rotate sleepers - to make sure all of them get woken in case
> +	 * of parallel up()s:
> +	 */
> +	list_move_tail(&waiter->list, &sem->wait_list);

Seems like extra cache line dirtying for no real gain over my solution.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
