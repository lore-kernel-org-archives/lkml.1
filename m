Return-Path: <linux-kernel-owner+w=401wt.eu-S1751697AbXBVQsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751697AbXBVQsu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 11:48:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751704AbXBVQst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 11:48:49 -0500
Received: from smtp4-g19.free.fr ([212.27.42.30]:57424 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751697AbXBVQst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 11:48:49 -0500
Message-ID: <45DDC97F.7000602@free.fr>
Date: Thu, 22 Feb 2007 17:49:03 +0100
From: John <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: tglx@linutronix.de
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       john stultz <johnstul@us.ibm.com>, Roman Zippel <zippel@linux-m68k.org>,
       Mike Galbraith <efault@gmx.de>, Ken Chen <kenneth.w.chen@intel.com>,
       balducci@units.it, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, linux.kernel@free.fr
Subject: Re: [PATCH] Fix posix-cpu-timer breakage caused by stale p->last_ran
 value
References: <fa.5d4W3Gwb5Gw7ztDfk2utJt1zgjc@ifi.uio.no> <fa.cIP2OCge0gIF8cSETEmZ9D2dxpE@ifi.uio.no>
In-Reply-To: <fa.cIP2OCge0gIF8cSETEmZ9D2dxpE@ifi.uio.no>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:

> Problem description at:
> http://bugzilla.kernel.org/show_bug.cgi?id=8048
> 
> Commit b18ec80396834497933d77b81ec0918519f4e2a7 
>     [PATCH] sched: improve migration accuracy
> optimized the scheduler time calculations, but broke posix-cpu-timers.
> 
> The problem is that the p->last_ran value is not updated after a context
> switch. So a subsequent call to current_sched_time() calculates with a
> stale p->last_ran value, i.e. accounts the full time, which the task was
> scheduled away.

Could you expand on the impact of this bug for non-kernel hackers? :-)

I'm currently testing 2.6.20-rt5. My app runs in SCHED_RR and just 
blocks waiting for several signals. Since my app is the only SCHED_RR 
process running on the system, I get the impression that I'm not 
affected by this bug. Is that correct?

> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> 
> Index: linux-2.6/kernel/sched.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched.c
> +++ linux-2.6/kernel/sched.c
> @@ -3566,7 +3566,7 @@ switch_tasks:
>  
>  	sched_info_switch(prev, next);
>  	if (likely(prev != next)) {
> -		next->timestamp = now;
> +		next->timestamp = next->last_ran = now;
>  		rq->nr_switches++;
>  		rq->curr = next;
>  		++*switch_count;

Regards,

John
