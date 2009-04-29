Return-Path: <linux-kernel-owner+w=401wt.eu-S1759938AbZD2LOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759938AbZD2LOg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 07:14:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752469AbZD2LO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 07:14:27 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54511 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750965AbZD2LO0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 07:14:26 -0400
Date: Wed, 29 Apr 2009 13:14:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 26/29] x86/perfcounters: introduce max_period variable
Message-ID: <20090429111420.GL2373@elte.hu>
References: <1241002046-8832-1-git-send-email-robert.richter@amd.com> <1241002046-8832-27-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241002046-8832-27-git-send-email-robert.richter@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Robert Richter <robert.richter@amd.com> wrote:

> In x86 pmus the allowed counter period to programm differs. This
> introduces a max_period value and allows the generic implementation
> for all models to check the max period.
> 
> Signed-off-by: Robert Richter <robert.richter@amd.com>
> ---
>  arch/x86/kernel/cpu/perf_counter.c |   20 ++++++++++++--------
>  1 files changed, 12 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
> index a8a53ab..4b8715b 100644
> --- a/arch/x86/kernel/cpu/perf_counter.c
> +++ b/arch/x86/kernel/cpu/perf_counter.c
> @@ -54,6 +54,7 @@ struct x86_pmu {
>  	int		num_counters_fixed;
>  	int		counter_bits;
>  	u64		counter_mask;
> +	u64		max_period;
>  };
>  
>  static struct x86_pmu x86_pmu __read_mostly;
> @@ -279,14 +280,8 @@ static int __hw_perf_counter_init(struct perf_counter *counter)
>  		hwc->nmi = 1;
>  
>  	hwc->irq_period		= hw_event->irq_period;
> -	/*
> -	 * Intel PMCs cannot be accessed sanely above 32 bit width,
> -	 * so we install an artificial 1<<31 period regardless of
> -	 * the generic counter period:
> -	 */
> -	if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL)
> -		if ((s64)hwc->irq_period <= 0 || hwc->irq_period > 0x7FFFFFFF)
> -			hwc->irq_period = 0x7FFFFFFF;
> +	if ((s64)hwc->irq_period <= 0 || hwc->irq_period > x86_pmu.max_period)
> +		hwc->irq_period = x86_pmu.max_period;

btw., should hwc->irq_period perhaps have an s64 type?

	Ingo
