Return-Path: <linux-kernel-owner+w=401wt.eu-S1762829AbXGSDAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762829AbXGSDAd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 23:00:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758048AbXGSDAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 23:00:25 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37966 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757767AbXGSDAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 23:00:24 -0400
Date: Wed, 18 Jul 2007 19:59:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Stable Team <stable@kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] X86_64: hpet tsc calibration fix broken smi detection
 logic
Message-Id: <20070718195932.ea72e6f0.akpm@linux-foundation.org>
In-Reply-To: <1184402499.12353.340.camel@chaos>
References: <1184402499.12353.340.camel@chaos>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Jul 2007 10:41:39 +0200 Thomas Gleixner <tglx@linutronix.de> wrote:

> The current SMI detection logic in read_hpet_tsc() makes sure,
> that when a SMI happens between the read of the HPET counter and
> the read of the TSC, this wrong value is used for TSC calibration.
> 
> This is not the intention of the function. The comparison must ensure,
> that we do _NOT_ use such a value.
> 
> Fix the check to use calibration values where delta of the two TSC reads
> is smaller than a reasonable threshold.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> 
> --- a/arch/x86_64/kernel/hpet.c
> +++ b/arch/x86_64/kernel/hpet.c
> @@ -190,7 +190,7 @@ int hpet_reenable(void)
>   */
>  
>  #define TICK_COUNT 100000000
> -#define TICK_MIN   5000
> +#define SMI_THRESHOLD 50000
>  #define MAX_TRIES  5
>  
>  /*
> @@ -205,7 +205,7 @@ static void __init read_hpet_tsc(int *hpet, int *tsc)
>  		tsc1 = get_cycles_sync();
>  		hpet1 = hpet_readl(HPET_COUNTER);
>  		tsc2 = get_cycles_sync();
> -		if (tsc2 - tsc1 > TICK_MIN)
> +		if ((tsc2 - tsc1) < SMI_TRESHOLD)
>  			break;
>  	}
>  	*hpet = hpet1;
> 

So I queued this, and then another patch to revert it so that the
x86_64-clockevents conversion would apply.  But I was unable to locate the
corresponding bug in the post-x86_64-clockevents tree.  Did it get fixed by
other means in there?

