Return-Path: <linux-kernel-owner+w=401wt.eu-S1756654AbYJHVr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654AbYJHVr4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 17:47:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754406AbYJHVrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 17:47:48 -0400
Received: from xenotime.net ([66.160.160.81]:47092 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754107AbYJHVrr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 17:47:47 -0400
Date: Wed, 8 Oct 2008 14:47:37 -0700 (PDT)
From: "Randy.Dunlap" <rdunlap@xenotime.net>
X-X-Sender: rddunlap@shark.he.net
To: Jeff Hansen <x@jeffhansen.com>
cc: Chris Snook <csnook@redhat.com>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH] Re: x86_32 tsc/pit and hrtimers
In-Reply-To: <Pine.LNX.4.64.0810081542300.14815@ren>
Message-ID: <Pine.LNX.4.64.0810081446340.19120@shark.he.net>
References: <Pine.LNX.4.64.0810071640110.25661@ren> <48ECFEDC.90305@redhat.com>
 <Pine.LNX.4.64.0810081342570.11108@ren> <48ED1728.5060708@redhat.com>
 <Pine.LNX.4.64.0810081542300.14815@ren>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Oct 2008, Jeff Hansen wrote:

> [HRTIMER]: Add highres=noverify option to bypass clocksource verification
> 
> This disregards the CLOCK_SOURCE_MUST_VERIFY flag on all clocksources.
> This is particularly useful on legacy x86_32 systems that have no ACPI,
> LAPIC, or HPET timers, where only TSC and PIT are available.
> 
> Thanks to Chris Snook for suggesting this.
> ---
>  include/linux/clocksource.h |    2 ++
>  kernel/hrtimer.c            |    2 ++
>  kernel/time/clocksource.c   |    3 ++-
>  3 files changed, 6 insertions(+), 1 deletions(-)

Oops, missing update to Documentation/kernel-parameters.txt.
Please see Documentation/SubmitChecklist :)
Thanks.

> diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
> index 55e434f..90ae835 100644
> --- a/include/linux/clocksource.h
> +++ b/include/linux/clocksource.h
> @@ -104,6 +104,8 @@ extern struct clocksource *clock;	/* current clocksource
> */
>  #define CLOCK_SOURCE_WATCHDOG			0x10
>  #define CLOCK_SOURCE_VALID_FOR_HRES		0x20
> 
> +extern int clocksource_noverify;
> +
>  /* simplify initialization of mask field */
>  #define CLOCKSOURCE_MASK(bits) (cycle_t)((bits) < 64 ? ((1ULL<<(bits))-1) :
> -1)
> 
> diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
> index ab80515..2fdf59f 100644
> --- a/kernel/hrtimer.c
> +++ b/kernel/hrtimer.c
> @@ -476,6 +476,8 @@ static int __init setup_hrtimer_hres(char *str)
>  		hrtimer_hres_enabled = 0;
>  	else if (!strcmp(str, "on"))
>  		hrtimer_hres_enabled = 1;
> +	else if (!strcmp(str, "noverify"))
> +		clocksource_noverify = 1;
>  	else
>  		return 0;
>  	return 1;
> diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
> index dadde53..d3c14c1 100644
> --- a/kernel/time/clocksource.c
> +++ b/kernel/time/clocksource.c
> @@ -54,6 +54,7 @@ static LIST_HEAD(clocksource_list);
>  static DEFINE_SPINLOCK(clocksource_lock);
>  static char override_name[32];
>  static int finished_booting;
> +int clocksource_noverify;
> 
>  /* clocksource_done_booting - Called near the end of core bootup
>   *
> @@ -165,7 +166,7 @@ static void clocksource_check_watchdog(struct clocksource
> *cs)
>  	unsigned long flags;
> 
>  	spin_lock_irqsave(&watchdog_lock, flags);
> -	if (cs->flags & CLOCK_SOURCE_MUST_VERIFY) {
> +	if (!clocksource_noverify && cs->flags & CLOCK_SOURCE_MUST_VERIFY) {
>  		int started = !list_empty(&watchdog_list);
> 
>  		list_add(&cs->wd_list, &watchdog_list);
> 

-- 
~Randy
