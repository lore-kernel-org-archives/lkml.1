Return-Path: <linux-kernel-owner+w=401wt.eu-S1755101AbYBANvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101AbYBANvu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 08:51:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750800AbYBANvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 08:51:41 -0500
Received: from www.tglx.de ([62.245.132.106]:53316 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738AbYBANvl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 08:51:41 -0500
Date: Fri, 1 Feb 2008 14:50:28 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Oleg Nesterov <oleg@tv-sign.ru>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@sw.ru>, Ingo Molnar <mingo@elte.hu>,
       Pavel Emelyanov <xemul@sw.ru>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] hrtimer_nanosleep: use -EINTR, not -ERESTARTNOHAND
In-Reply-To: <20080201133755.GA25620@tv-sign.ru>
Message-ID: <alpine.LFD.1.00.0802011438020.9204@apollo.tec.linutronix.de>
References: <20080201133755.GA25620@tv-sign.ru>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Feb 2008, Oleg Nesterov wrote:

> hrtimer_nanosleep:
> 
> 	/* Absolute timers do not update the rmtp value and restart: */
> 	return -ERESTARTNOHAND;
> 
> This is not right, -ERESTARTNOHAND means we will do restart if there is no
> in fact pending signal, and worse, this restart will use the same unchanged
> "__user *rmtp" parameter.

-ERESTARTNOHAND is safe here. We want to restart the timer.

The rmtp problem is separate, but that's addressed by your follow up changes.
 
Thanks,
	tglx

> Use -EINTR instead.
> 
> Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
> 
> --- MM/kernel/hrtimer.c~HRT_RMTP~	2008-01-27 17:07:39.000000000 +0300
> +++ MM/kernel/hrtimer.c~HRT_RMTP	2008-02-01 13:43:52.000000000 +0300
> @@ -1359,7 +1359,7 @@ long hrtimer_nanosleep(struct timespec *
>  
>  	/* Absolute timers do not update the rmtp value and restart: */
>  	if (mode == HRTIMER_MODE_ABS)
> -		return -ERESTARTNOHAND;
> +		return -EINTR;
>  
>  	if (rmtp) {
>  		rem = ktime_sub(t.timer.expires, t.timer.base->get_time());
> 
