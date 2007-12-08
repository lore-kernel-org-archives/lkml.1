Return-Path: <linux-kernel-owner+w=401wt.eu-S1757230AbXLHILS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230AbXLHILS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 03:11:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755467AbXLHIK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 03:10:58 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:3266 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755160AbXLHIK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 03:10:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=I7qMP2uco2rGafvq/ZQfpB8ZFW0sCwwUKfaRYCYUyHQHtreMNwCnnKAtos/cJ/2YVIvzO+Grn2c4AqqoN9t8VBc7OiC7JCjYxxTXPJRS+tgYM0oSVKhuPbwr4sO1SwGeRkEZWzl8AThjBkrsoLMyRWS1F4wIhNZsYNlx2p01Mjc=
Message-ID: <475A5188.6070809@gmail.com>
Date: Sat, 08 Dec 2007 09:10:48 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: broken suspend (sched related) [Was: 2.6.24-rc4-mm1]
References: <20071204211701.994dfce6.akpm@linux-foundation.org> <47595A0A.5000502@gmail.com> <20071207151150.GB24254@elte.hu> <20071207175134.GA18916@elte.hu>
In-Reply-To: <20071207175134.GA18916@elte.hu>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/2007 06:51 PM, Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
>> thanks for tracking it down. Does the patch below help?
> 
> oops, that should be the patch below. Otherwise the watchdog kernel 
> threads will just loop around.
> 
> 	Ingo
> 
> ---
>  kernel/softlockup.c |    9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> Index: linux/kernel/softlockup.c
> ===================================================================
> --- linux.orig/kernel/softlockup.c
> +++ linux/kernel/softlockup.c
> @@ -101,7 +101,11 @@ void softlockup_tick(void)
>  
>  	now = get_timestamp(this_cpu);
>  
> -	/* Warn about unreasonable delays: */
> +	/* Wake up the high-prio watchdog task every second: */
> +	if (now > (touch_timestamp + 1))
> +		wake_up_process(per_cpu(watchdog_task, this_cpu));
> +
> +	/* Warn about unreasonable 10+ seconds delays: */
>  	if (now <= (touch_timestamp + softlockup_thresh))
>  		return;
>  
> @@ -213,8 +217,9 @@ static int watchdog(void *__bind_cpu)
>  	 * debug-printout triggers in softlockup_tick().
>  	 */
>  	while (!kthread_should_stop()) {
> +		set_current_state(TASK_INTERRUPTIBLE);
>  		touch_softlockup_watchdog();
> -		msleep_interruptible(10000);
> +		schedule();
>  
>  		/*
>  		 * Only do the hung-tasks check on one CPU:

Unfortunately no change here.
