Return-Path: <linux-kernel-owner+w=401wt.eu-S1758068AbXFZQXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758068AbXFZQXy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 12:23:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753348AbXFZQXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 12:23:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33406 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752356AbXFZQXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 12:23:46 -0400
Message-ID: <46813D1C.9080107@redhat.com>
Date: Tue, 26 Jun 2007 12:21:48 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@tv-sign.ru>
CC: Ingo Molnar <mingo@elte.hu>, John Stultz <johnstul@us.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Roman Zippel <zippel@linux-m68k.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sys_time-speedup-small-cleanup
References: <20070626123424.GA259@tv-sign.ru>
In-Reply-To: <20070626123424.GA259@tv-sign.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> on top of sys_time-speedup.patch
> 
> Ingo Molnar wrote:
>>  asmlinkage long sys_time(time_t __user * tloc)
>>  {
>> -	time_t i;
>> -	struct timeval tv;
>> +	/*
>> +	 * We read xtime.tv_sec atomically - it's updated
>> +	 * atomically by update_wall_time(), so no need to
>> +	 * even read-lock the xtime seqlock:
>> +	 */
>> +	time_t i = xtime.tv_sec;
>>  
>> -	do_gettimeofday(&tv);
>> -	i = tv.tv_sec;
>> +	smp_rmb(); /* sys_time() results are coherent */
> 
> Why do we need this barrier? My guess it is needed to prevent
> the reading of xtime.tv_sec twice, yes? In that case a simple
> barrier() should be enough.

Without the smp_rmb, you can potentially have a situation where one CPU is still 
reading an old value from cache while another has the new value.  It's generally 
a rather small race window on most architectures, but very bad things can happen 
if time ever goes backwards, so it's worth the overhead of maintaining coherence 
on smp.

	-- Chris

> Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
> 
> --- t/kernel/time.c~	2007-06-26 16:28:59.000000000 +0400
> +++ t/kernel/time.c	2007-06-26 16:32:09.000000000 +0400
> @@ -64,7 +64,7 @@ asmlinkage long sys_time(time_t __user *
>  	 */
>  	time_t i = xtime.tv_sec;
>  
> -	smp_rmb(); /* sys_time() results are coherent */
> +	barrier(); /* sys_time() results are coherent */
>  
>  	if (tloc) {
>  		if (put_user(i, tloc))
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

