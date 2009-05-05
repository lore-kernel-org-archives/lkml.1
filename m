Return-Path: <linux-kernel-owner+w=401wt.eu-S1754803AbZEEGtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803AbZEEGtX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 02:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753832AbZEEGtO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 02:49:14 -0400
Received: from www.tglx.de ([62.245.132.106]:50809 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714AbZEEGtN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 02:49:13 -0400
Date: Tue, 5 May 2009 08:48:28 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: john stultz <johnstul@us.ibm.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Sanity check sysfs clocksource changes
In-Reply-To: <1241493035.7444.115.camel@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0905050839560.3375@localhost.localdomain>
References: <1239759163.6064.25.camel@localhost>  <1239759251.6064.27.camel@localhost> <1239759393.6064.30.camel@localhost>  <20090501131006.fa631417.akpm@linux-foundation.org> <1241493035.7444.115.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 May 2009, john stultz wrote:

> On Fri, 2009-05-01 at 13:10 -0700, Andrew Morton wrote:
> > What's the status of
> > clocksource-sanity-check-sysfs-clocksource-changes.patch, btw?  I have
> > it marked as "still an RFC", but it's been sitting here since January?
> 
> Thanks for reminding me! I lost track of that one. Still waiting on
> feedback from Thomas.
> 
> Thomas? What do you think? Original patch below, applies with fuzz and
> builds.
> 
> -john
> 
> 
> Hey all,
> 	Thomas, Andrew and Ingo pointed out that we don't have any safety
> checks in the clocksource sysfs entries to make sure sysadmins don't try
> to change the clocksource to a non high-res timer capable clocksource
> (such as jiffies) when high-res timers (HRT) is enabled. Doing so will
> likely hang a system.
> 
> This patch tries to correct this by filtering non HRT clocksources from
> available_clocksources and not accepting non HRT clocksources with HRT
> is is enabled.
> 
> This has been lightly tested, and seems to work, but there may be some
> drawbacks.
> 
> One issue I realized was that when TSCs disqualified, they are marked as
> not CLOCK_SOURCE_VALID_FOR_HRES. This means on boxes with unsycned TSCs,
> the only available clocksource may be the slower acpi_pm and the user
> will not be able to override it with the TSC as is currently possible.
> (even if that seems ill-advised).
> 
> So Thomas, what do you think? Should we just use
> CLOCK_SOURCE_IS_CONTINUOUS flag or is CLOCK_SOURCE_VALID_FOR_HRES really
> what we want?

Hmm. If we switched to highres and discarded TSC already then we
should not go back to it. 
 
> Signed-off-by: John Stultz <johnstul@us.ibm.com>
> 
> 
> diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
> index bd37078..05f67f0 100644
> --- a/include/linux/hrtimer.h
> +++ b/include/linux/hrtimer.h
> @@ -305,7 +305,7 @@ static inline int hrtimer_is_hres_active(struct hrtimer *timer)
>  
>  extern ktime_t ktime_get(void);
>  extern ktime_t ktime_get_real(void);
> -
> +extern int hrtimer_hres_active(void);
>  
>  DECLARE_PER_CPU(struct tick_device, tick_cpu_device);
>  
> diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
> index 2dc30c5..fa4abdc 100644
> --- a/kernel/hrtimer.c
> +++ b/kernel/hrtimer.c
> @@ -476,7 +476,7 @@ static inline int hrtimer_is_hres_enabled(void)
>  /*
>   * Is the high resolution mode active ?
>   */
> -static inline int hrtimer_hres_active(void)
> +int hrtimer_hres_active(void)
>  {
>  	return __get_cpu_var(hrtimer_bases).hres_active;
>  }
> @@ -689,7 +689,7 @@ static int hrtimer_switch_to_hres(void)
>  
>  #else
>  
> -static inline int hrtimer_hres_active(void) { return 0; }
> +int hrtimer_hres_active(void) { return 0; }

We want to keep that static inline and move it to hrtimer.h to allow
gcc to optimize stuff out.

Thanks,

	tglx




