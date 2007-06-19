Return-Path: <linux-kernel-owner+w=401wt.eu-S1756342AbXFSI0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756342AbXFSI0R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 04:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754476AbXFSI0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 04:26:07 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:9729 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183AbXFSI0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 04:26:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:reply-to:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=dg2FlDUkfw0aCytagxaumwmBK9sCbqsELb3jYp2pk3mT8pKeP0jl3Sw5nmLlmioHTSAIyZZrqueIs1b2R9sh9bnOv0lpwgEySo1Spe+pz2ZPSWKRvmeD6qGrTKkDSzfbh+mvNqzikiKM7EKkKGPXbcgyicCdIDCLHoq3/78mIa4=
Message-ID: <46779353.7010709@innova-card.com>
Date: Tue, 19 Jun 2007 10:26:59 +0200
Reply-To: Franck <vagabon.xyz@gmail.com>
User-Agent: Thunderbird 1.5.0.4 (X11/20060614)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       Chris Wright <chrisw@sous-sol.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       john stultz <johnstul@us.ibm.com>, David Miller <davem@davemloft.net>
Subject: Re: [patch-mm 14/25] NTP: Move the cmos update code into ntp.c
References: <20070616101126.296384219@inhelltoy.tec.linutronix.de> <20070616101637.068394614@inhelltoy.tec.linutronix.de>
In-Reply-To: <20070616101637.068394614@inhelltoy.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Franck Bui-Huu <vagabon.xyz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

Thomas Gleixner wrote:
> i386 and sparc64 have the identical code to update the cmos clock.
> Move it into kernel/time/ntp.c as there are other architectures
> coming along with the same requirements.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Chris Wright <chrisw@sous-sol.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: john stultz <johnstul@us.ibm.com>
> Cc: David Miller <davem@davemloft.net>
> 
> ---
>  arch/i386/Kconfig          |    4 +++
>  arch/i386/kernel/time.c    |   50 +-------------------------------------
>  arch/sparc64/Kconfig       |    4 +++
>  arch/sparc64/kernel/time.c |   53 +---------------------------------------
>  include/asm-i386/timer.h   |    1 
>  include/linux/time.h       |    2 +
>  kernel/time/ntp.c          |   59 ++++++++++++++++++++++++++++++++++++++++++---
>  7 files changed, 70 insertions(+), 103 deletions(-)
> 

[snip]

>  /* Kick start a stopped clock (procedure from the Sun NVRAM/hostid FAQ). */
> Index: linux-2.6.22-rc4-mm/include/linux/time.h
> ===================================================================
> --- linux-2.6.22-rc4-mm.orig/include/linux/time.h	2007-06-16 12:10:21.000000000 +0200
> +++ linux-2.6.22-rc4-mm/include/linux/time.h	2007-06-16 12:10:24.000000000 +0200
> @@ -93,6 +93,8 @@ extern struct timespec wall_to_monotonic
>  extern seqlock_t xtime_lock __attribute__((weak));
>  
>  extern unsigned long read_persistent_clock(void);
> +extern int update_persistent_clock(struct timespec now);

I'm wondering if update_persistent_clock shouldn't be part of
"drivers/rtc/*" framework. Do you have any idea on how this
is going to be implemented on platforms that use this framework ?

> +extern int no_sync_cmos_clock __read_mostly;
>  void timekeeping_init(void);
>  
>  static inline unsigned long get_seconds(void)
> Index: linux-2.6.22-rc4-mm/kernel/time/ntp.c
> ===================================================================
> --- linux-2.6.22-rc4-mm.orig/kernel/time/ntp.c	2007-06-16 12:10:21.000000000 +0200
> +++ linux-2.6.22-rc4-mm/kernel/time/ntp.c	2007-06-16 12:10:24.000000000 +0200
> @@ -10,6 +10,7 @@
>  
>  #include <linux/mm.h>
>  #include <linux/time.h>
> +#include <linux/timer.h>
>  #include <linux/timex.h>
>  #include <linux/jiffies.h>
>  #include <linux/hrtimer.h>
> @@ -187,12 +188,64 @@ u64 current_tick_length(void)
>  	return tick_length;
>  }
>  
> +#ifdef CONFIG_GENERIC_CMOS_UPDATE
>  
> -void __attribute__ ((weak)) notify_arch_cmos_timer(void)
> +/* Disable the cmos update - used by virtualization and embedded */
> +int no_sync_cmos_clock  __read_mostly;
> +

[snip]

>  
> +static void notify_cmos_timer(void)
> +{
> +	if (no_sync_cmos_clock)
> +		mod_timer(&sync_cmos_timer, jiffies + 1);
> +}

Isn't the test condition wrong ? Shouldn't it be:

	if (!no_sync_cmos_clock)
		mod_timer(&sync_cmos_timer, jiffies + 1);

Thanks,

		Franck
