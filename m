Return-Path: <linux-kernel-owner+w=401wt.eu-S1757228AbXFYWDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757228AbXFYWDk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 18:03:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756323AbXFYWDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 18:03:24 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:46061 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756197AbXFYWDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 18:03:23 -0400
Message-ID: <46803B6E.6030804@cosmosbay.com>
Date: Tue, 26 Jun 2007 00:02:22 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       John Stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch, v2.6.22-rc6] sys_time() speedup
References: <20070625200601.GA18980@elte.hu>
In-Reply-To: <20070625200601.GA18980@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Tue, 26 Jun 2007 00:02:28 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar a écrit :
> Subject: [patch] sys_time() speedup
> From: Ingo Molnar <mingo@elte.hu>
> 
> improve performance of sys_time(). sys_time() returns time in seconds, 
> but it does so by calling do_gettimeofday() and then returning the 
> tv_sec portion of the GTOD time. But the data structure "xtime", which 
> is updated by every timer/scheduler tick, already offers HZ granularity 
> time.
> 
> the patch improves the sysbench OLTP macrobenchmark significantly:
> 
> 2.6.22-rc6:
> 
> #threads
>    1:        transactions:                        3733   (373.21 per sec.)
>    2:        transactions:                        6676   (667.46 per sec.)
>    3:        transactions:                        6957   (695.50 per sec.)
>    4:        transactions:                        7055   (705.48 per sec.)
>    5:        transactions:                        6596   (659.33 per sec.)
> 
> 2.6.22-rc6 + sys_time.patch:
> 
>    1:        transactions:                        4005   (400.47 per sec.)
>    2:        transactions:                        7379   (737.77 per sec.)
>    3:        transactions:                        7347   (734.49 per sec.)
>    4:        transactions:                        7468   (746.65 per sec.)
>    5:        transactions:                        7428   (742.47 per sec.)
> 
> mixed API uses of gettimeofday() and time() are guaranteed to be 
> coherent via the use of a at-most-once-per-second slowpath that updates 
> xtime.
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  kernel/time.c |   27 ++++++++++++++++++++++-----
>  1 file changed, 22 insertions(+), 5 deletions(-)
> 
> Index: linux/kernel/time.c
> ===================================================================
> --- linux.orig/kernel/time.c
> +++ linux/kernel/time.c
> @@ -57,14 +57,17 @@ EXPORT_SYMBOL(sys_tz);
>   */
>  asmlinkage long sys_time(time_t __user * tloc)
>  {
> -	time_t i;
> -	struct timeval tv;
> +	/*
> +	 * We read xtime.tv_sec atomically - it's updated
> +	 * atomically by update_wall_time(), so no need to
> +	 * even read-lock the xtime seqlock:
> +	 */
> +	time_t i = xtime.tv_sec;
>  
> -	do_gettimeofday(&tv);
> -	i = tv.tv_sec;
> +	smp_rmb(); /* sys_time() results are coherent */
>  
>  	if (tloc) {
> -		if (put_user(i,tloc))
> +		if (put_user(i, tloc))
>  			i = -EFAULT;
>  	}
>  	return i;
> @@ -373,6 +376,20 @@ void do_gettimeofday (struct timeval *tv
>  
>  	tv->tv_sec = sec;
>  	tv->tv_usec = usec;
> +
> +	/*
> +	 * Make sure xtime.tv_sec [returned by sys_time()] always
> +	 * follows the gettimeofday() result precisely. This
> +	 * condition is extremely unlikely, it can hit at most
> +	 * once per second:
> +	 */

Unfortunatly, some arches (x86_64) can call both sys_time() and vgettimeofday().

And vgettimeofday() cannot update xtime (its mapped readonly in vsyscall 
page), so the coherency wont be guaranted.

Also, I thought glibc time(0) was calling gettimeofday() on x86_64, so I 
wonder on which machine you got your bench results.

Are you still using a 32 bits platform ? :)

