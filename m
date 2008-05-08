Return-Path: <linux-kernel-owner+w=401wt.eu-S1759554AbYEHHQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759554AbYEHHQX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 03:16:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754272AbYEHHQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 03:16:07 -0400
Received: from mga05.intel.com ([192.55.52.89]:55601 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753111AbYEHHP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 03:15:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,453,1204531200"; 
   d="scan'208";a="562142802"
Subject: Re: AIM7 40% regression with 2.6.26-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080508064340.GA27452@elte.hu>
References: <1210052904.3453.30.camel@ymzhang>
	 <20080506114449.GC32591@elte.hu> <1210126286.3453.37.camel@ymzhang>
	 <1210131712.3453.43.camel@ymzhang> <87lk2mbcqp.fsf@basil.nowhere.org>
	 <20080507114643.GR19219@parisc-linux.org>
	 <87hcdab8zp.fsf@basil.nowhere.org>
	 <alpine.LFD.1.10.0805070728280.32269@woody.linux-foundation.org>
	 <alpine.LFD.1.10.0805070817060.3024@woody.linux-foundation.org>
	 <1210214696.3453.87.camel@ymzhang>  <20080508064340.GA27452@elte.hu>
Content-Type: text/plain
Date: Thu, 08 May 2008 15:14:43 +0800
Message-Id: <1210230883.3453.127.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 (2.21.5-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-05-08 at 08:43 +0200, Ingo Molnar wrote:
> * Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:
> 
> > > Here's a trial balloon patch to do that.
> > > 
> > > Yanmin - this is not well tested, but the code is fairly obvious, 
> > > and it would be interesting to hear if this fixes the performance 
> > > regression. Because if it doesn't, then it's not the BKL, or 
> > > something totally different is going on.
> >
> > Congratulations! The patch really fixes the regression completely! 
> > vmstat showed cpu idle is 0%, just like 2.6.25's.
> 
> great! Yanmin, could you please also check the other patch i sent (also 
> attached below), does it solve the regression similarly?
With your patch, aim7 regression becomes less than 2%. I ran the testing twice.

Linus' patch could recover it completely. As aim7 result is quite stable(usually
fluctuating less than 1%), 1.5%~2% is a little big.

> 
> 	Ingo
> 
> ---
>  lib/kernel_lock.c |    9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> Index: linux/lib/kernel_lock.c
> ===================================================================
> --- linux.orig/lib/kernel_lock.c
> +++ linux/lib/kernel_lock.c
> @@ -46,7 +46,8 @@ int __lockfunc __reacquire_kernel_lock(v
>  	task->lock_depth = -1;
>  	preempt_enable_no_resched();
>  
> -	down(&kernel_sem);
> +	while (down_trylock(&kernel_sem))
> +		cpu_relax();
>  
>  	preempt_disable();
>  	task->lock_depth = saved_lock_depth;
> @@ -67,11 +68,13 @@ void __lockfunc lock_kernel(void)
>  	struct task_struct *task = current;
>  	int depth = task->lock_depth + 1;
>  
> -	if (likely(!depth))
> +	if (likely(!depth)) {
>  		/*
>  		 * No recursion worries - we set up lock_depth _after_
>  		 */
> -		down(&kernel_sem);
> +		while (down_trylock(&kernel_sem))
> +			cpu_relax();
> +	}
>  
>  	task->lock_depth = depth;
>  }

