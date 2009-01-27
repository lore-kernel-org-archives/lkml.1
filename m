Return-Path: <linux-kernel-owner+w=401wt.eu-S1755291AbZA0MyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291AbZA0MyR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 07:54:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753200AbZA0MyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 07:54:04 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39670 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753068AbZA0MyC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 07:54:02 -0500
Date: Tue, 27 Jan 2009 13:53:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [PATCH 1/3] fix debug message of CPU clock speed
Message-ID: <20090127125349.GB23121@elte.hu>
References: <497EC23A.7050408@jp.fujitsu.com> <497EC3F8.6020100@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <497EC3F8.6020100@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com> wrote:

> LOCAL APIC is corrected by PM-Timer, when SMI occurred while LOCAL APIC 
> is calibrated. In this case, LOCAL APIC debug message(Boot with 
> apic=debug) is displayed correctly, however, CPU clock speed debug 
> message is displayed wrongly .

your fix looks good, but there are a few minor style details that need to 
be addressed:

> When SMI occured on my machine, which has 1.6GHz CPU, CPU clock speed is 
> displayed 3622.0205 MHz as follow.
> 
> 	CPU0: Intel(R) Xeon(R) CPU            5110  @ 1.60GHz stepping 06
> 	Using local APIC timer interrupts.
> 	calibrating APIC timer ...
> 	... lapic delta = 3773130
> 	... PM timer delta = 812434
> 	APIC calibration not consistent with PM Timer: 226ms instead of 100ms
> 	APIC delta adjusted to PM-Timer: 1662420 (3773130)
> 	..... delta 1662420
> 	..... mult: 71411249
> 	..... calibration result: 265987
> 	..... CPU clock speed is 3622.0205 MHz.  =====>  here
> 	..... host bus clock speed is 265.0987 MHz.
> 
> This patch fixes to displaying CPU clock speed correctly as follow.
> 
> 	CPU0: Intel(R) Xeon(R) CPU            5110  @ 1.60GHz stepping 06
> 	Using local APIC timer interrupts.
> 	calibrating APIC timer ...
> 	... lapic delta = 3773131
> 	... PM timer delta = 812434
> 	APIC calibration not consistent with PM Timer: 226ms instead of 100ms
> 	APIC delta adjusted to PM-Timer: 1662420 (3773131)
> 	TSC delta adjusted to PM-Timer: 159592409 (362220564)
> 	..... delta 1662420
> 	..... mult: 71411249
> 	..... calibration result: 265987
> 	..... CPU clock speed is 1595.0924 MHz.
> 	..... host bus clock speed is 265.0987 MHz.
> 
> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> 
> ---
>  arch/x86/kernel/apic.c |   23 +++++++++++++++++------
>  1 file changed, 17 insertions(+), 6 deletions(-)
> 
> Index: linux-2.6.29-rc2/arch/x86/kernel/apic.c
> ===================================================================
> --- linux-2.6.29-rc2.orig/arch/x86/kernel/apic.c	2009-01-27 11:04:40.000000000 +0900
> +++ linux-2.6.29-rc2/arch/x86/kernel/apic.c	2009-01-27 12:29:03.000000000 +0900
> @@ -535,7 +535,8 @@ static void __init lapic_cal_handler(str
>  	}
>  }
> 
> -static int __init calibrate_by_pmtimer(long deltapm, long *delta)
> +static int __init calibrate_by_pmtimer(long deltapm, long *delta,
> +						long *deltatsc)

The cleaner prototype line-width break is:

  + static int __init
  + calibrate_by_pmtimer(long deltapm, long *delta, long *deltatsc)


this function:

> @@ -569,6 +570,15 @@ static int __init calibrate_by_pmtimer(l
>  		pr_info("APIC delta adjusted to PM-Timer: "
>  			"%lu (%ld)\n", (unsigned long)res, *delta);
>  		*delta = (long)res;
> +
> +		if (cpu_has_tsc) {
> +			res = (((u64)(*deltatsc)) * pm_100ms);
> +			do_div(res, deltapm);
> +			apic_printk(APIC_VERBOSE, "TSC delta adjusted to "
> +					"PM-Timer: %lu (%ld)\n",
> +					(unsigned long)res, *deltatsc);
> +			*deltatsc = (long)res;
> +		}

has too deep nesting in the form of:

	if (A) {
		...
	} else {
		...
		if (B) {
			...
		}
	}

	return 0;


Could you please restructure it to a cleaner control flow, in the form of:

	if (A) {
		...
		return 0;
	}
	...
	if (B) {
		...
  	}

	return 0;

?

Thanks,

	Ingo
