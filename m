Return-Path: <linux-kernel-owner+w=401wt.eu-S1755303AbYLCAbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303AbYLCAbv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 19:31:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753438AbYLCAbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 19:31:42 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59036 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754003AbYLCAbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 19:31:42 -0500
Date: Tue, 2 Dec 2008 16:30:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: philb@gnu.org, carsten@sol.wohnheim.uni-ulm.de, renau@acm.org,
       tim@cyberelk.demon.co.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] IEEE1284: Use del_timer_sync in parport_wait_event
Message-Id: <20081202163055.e80e0b81.akpm@linux-foundation.org>
In-Reply-To: <200811302120.49766.mb@bu3sch.de>
References: <200811302120.49766.mb@bu3sch.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Nov 2008 21:20:49 +0100
Michael Buesch <mb@bu3sch.de> wrote:

> Use del_timer_sync() instead of del_timer() to make sure
> the timer won't be running when we return from parport_wait_event(),
> because this would crash due to destruction of timer_list.
> 
> Signed-off-by: Michael Buesch <mb@bu3sch.de>
> 
> ---
> 
> This is completely untested and just based on a code review.
> Just think about the following sequence of events:
> add_timer.
> down_interruptible is interrupted by a signal.
> We enter the timer callback handler on another CPU.
> del_timer, but the timer callback is still running.
> Return from parport_wait_even, which destroys the automatic variable "timer"
> while the callback is running on another CPU.
> 

Yes, I agree.

> ===================================================================
> --- linux-2.6.orig/drivers/parport/ieee1284.c	2008-10-24 21:08:12.000000000 +0200
> +++ linux-2.6/drivers/parport/ieee1284.c	2008-11-30 21:09:25.000000000 +0100
> @@ -84,7 +84,7 @@ int parport_wait_event (struct parport *
>  
>  	add_timer (&timer);
>  	ret = down_interruptible (&port->physport->ieee1284.irq);
> -	if (!del_timer (&timer) && !ret)
> +	if (!del_timer_sync (&timer) && !ret)
>  		/* Timed out. */
>  		ret = 1;

Please fix checkpatch errors when altering code.  This function is
already a mismash of correct and incorrect styles - we might as well
increase the correctness density.

What we really want in this function is down_interruptible_timeout(). 
afaict we have all the infrastructure in place to implement that, but
nobody has typed

static noinline int __sched
__down_interruptible_timeout(struct semaphore *sem, long jiffies)
{
	return __down_common(sem, TASK_INTERRUPTIBLE, jiffies);
}

and then tested it.

Or convert the whole thing to mutexes and write
mutex_lock_interruptible_timeout() :)

