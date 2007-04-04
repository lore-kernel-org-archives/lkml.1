Return-Path: <linux-kernel-owner+w=401wt.eu-S1751536AbXDDVMC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751536AbXDDVMC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 17:12:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751549AbXDDVMB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 17:12:01 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:43074 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751536AbXDDVMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 17:12:00 -0400
Date: Wed, 4 Apr 2007 23:11:59 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Chuck Ebbert <cebbert@redhat.com>, Johannes Bauer <JohannesBauer@gmx.de>,
       linux-kernel@vger.kernel.org, schwab@suse.de,
       Stable Kernel Team <stable@kernel.org>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] hrtimer: prevent overrun DoS in hrtimer_forward()
Message-ID: <20070404211159.GT27660@stusta.de>
References: <45F6F3A6.9060405@gmx.de> <45F7033B.2030204@redhat.com> <1173817985.13341.120.camel@localhost.localdomain> <1173866413.13341.154.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1173866413.13341.154.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2007 at 11:00:12AM +0100, Thomas Gleixner wrote:
> hrtimer_forward() does not check for the possible overflow of
> timer->expires. This can happen on 64 bit machines with large interval
> values and results currently in an endless loop in the softirq because
> the expiry value becomes negative and therefor the timer is expired all
> the time.
> 
> Check for this condition and set the expiry value to the max. expiry
> time in the future.
> 
> The fix should be applied to stable kernel series as well.


Is this relevant for 2.6.16?

I'm asking since KTIME_SEC_MAX is not used in 2.6.16, and therefore the 
check in ktime_set() is also missing.


> Signed-off-by: Thomas Gleixner <tglx@linutronix,de>
> 
> diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
> index ec4cb9f..5e7122d 100644
> --- a/kernel/hrtimer.c
> +++ b/kernel/hrtimer.c
> @@ -644,6 +644,12 @@ hrtimer_forward(struct hrtimer *timer, k
>  		orun++;
>  	}
>  	timer->expires = ktime_add(timer->expires, interval);
> +	/*
> +	 * Make sure, that the result did not wrap with a very large
> +	 * interval.
> +	 */
> +	if (timer->expires.tv64 < 0)
> +		timer->expires = ktime_set(KTIME_SEC_MAX, 0);
>  
>  	return orun;
>  }
> 

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

