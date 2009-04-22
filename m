Return-Path: <linux-kernel-owner+w=401wt.eu-S1756075AbZDVPhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075AbZDVPhm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 11:37:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753376AbZDVPhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 11:37:32 -0400
Received: from relay2.sgi.com ([192.48.179.30]:58866 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755498AbZDVPhb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 11:37:31 -0400
Date: Wed, 22 Apr 2009 10:37:30 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: Coly Li <coly.li@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] uv_time: add parameter to uv_read_rtc()
Message-ID: <20090422153730.GA8490@sgi.com>
References: <49EF3614.1050806@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49EF3614.1050806@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks like this interface has just been changed, by commit 8e19608e8b5c001e4a66ce482edc474f05fb7355.

This looks OK to me.

On Wed, Apr 22, 2009 at 11:21:56PM +0800, Coly Li wrote:
> uv_read_rtc() is referenced by read member of struct clocksource clocksource_uv.
> In include/linux/clocksource.h, read of struct clocksource is declared as:
> cycle_t (*read)(struct clocksource *cs)
> 
> This patch adds a dummy parameter (struct clocksource type) to uv_read_rtc() to
> fix the incompatible reference in clocksource_uv, and add a NULL parameter in
> all places where uv_read_rtc() gets called.
> 
> Signed-off-by: Coly Li <coly.li@suse.de>
> Cc: Dimitri Sivanich <sivanich@sgi.com>
> ---
>  arch/x86/kernel/uv_time.c |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kernel/uv_time.c b/arch/x86/kernel/uv_time.c
> index 2ffb6c5..583f11d 100644
> --- a/arch/x86/kernel/uv_time.c
> +++ b/arch/x86/kernel/uv_time.c
> @@ -29,7 +29,7 @@
> 
>  #define RTC_NAME		"sgi_rtc"
> 
> -static cycle_t uv_read_rtc(void);
> +static cycle_t uv_read_rtc(struct clocksource *cs);
>  static int uv_rtc_next_event(unsigned long, struct clock_event_device *);
>  static void uv_rtc_timer_setup(enum clock_event_mode,
>  				struct clock_event_device *);
> @@ -123,7 +123,7 @@ static int uv_setup_intr(int cpu, u64 expires)
>  	/* Initialize comparator value */
>  	uv_write_global_mmr64(pnode, UVH_INT_CMPB, expires);
> 
> -	return (expires < uv_read_rtc() && !uv_intr_pending(pnode));
> +	return (expires < uv_read_rtc(NULL) && !uv_intr_pending(pnode));
>  }
> 
>  /*
> @@ -256,7 +256,7 @@ static int uv_rtc_unset_timer(int cpu)
> 
>  	spin_lock_irqsave(&head->lock, flags);
> 
> -	if (head->next_cpu == bcpu && uv_read_rtc() >= *t)
> +	if (head->next_cpu == bcpu && uv_read_rtc(NULL) >= *t)
>  		rc = 1;
> 
>  	*t = ULLONG_MAX;
> @@ -278,7 +278,7 @@ static int uv_rtc_unset_timer(int cpu)
>  /*
>   * Read the RTC.
>   */
> -static cycle_t uv_read_rtc(void)
> +static cycle_t uv_read_rtc(struct clocksource *cs)
>  {
>  	return (cycle_t)uv_read_local_mmr(UVH_RTC);
>  }
> @@ -291,7 +291,7 @@ static int uv_rtc_next_event(unsigned long delta,
>  {
>  	int ced_cpu = cpumask_first(ced->cpumask);
> 
> -	return uv_rtc_set_timer(ced_cpu, delta + uv_read_rtc());
> +	return uv_rtc_set_timer(ced_cpu, delta + uv_read_rtc(NULL));
>  }
> 
>  /*
> 
> -- 
> Coly Li
> SuSE Labs
