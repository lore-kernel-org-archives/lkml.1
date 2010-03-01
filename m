Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751119Ab0CAR6F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 12:58:05 -0500
Received: from mga01.intel.com ([192.55.52.88]:35456 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750748Ab0CAR6B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 12:58:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,561,1262592000"; 
   d="scan'208";a="776929682"
Subject: Re: [PATCH v2] x86: Fix sched_clock_cpu for systems with
 unsynchronized TSC
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20100301174815.GC8224@sgi.com>
References: <20100301174815.GC8224@sgi.com>
Content-Type: text/plain
Date: Mon, 01 Mar 2010 09:58:00 -0800
Message-Id: <1267466280.16916.927.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Acked-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

On Mon, 2010-03-01 at 09:48 -0800, Dimitri Sivanich wrote:
> On UV systems, the TSC is not synchronized across blades.  The
> sched_clock_cpu() function is returning values that can go backwards 
> (I've seen as much as 8 seconds) when switching between cpus.
> 
> As each cpu comes up, early_init_intel() will currently set the
> sched_clock_stable flag true.  When mark_tsc_unstable() runs, it clears
> the flag, but this only occurs once (the first time a cpu comes up whose
> TSC is not synchronized with cpu 0).  After this, early_init_intel() will
> set the flag again as the next cpu comes up.
> 
> Only set sched_clock_stable if tsc has not been marked unstable.
> 
> Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
> 
> ---
> 
> Only affects x86 arch.
> 
>  arch/x86/kernel/cpu/intel.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> Index: linux/arch/x86/kernel/cpu/intel.c
> ===================================================================
> --- linux.orig/arch/x86/kernel/cpu/intel.c
> +++ linux/arch/x86/kernel/cpu/intel.c
> @@ -70,7 +70,8 @@ static void __cpuinit early_init_intel(s
>  	if (c->x86_power & (1 << 8)) {
>  		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
>  		set_cpu_cap(c, X86_FEATURE_NONSTOP_TSC);
> -		sched_clock_stable = 1;
> +		if (!check_tsc_unstable())
> +			sched_clock_stable = 1;
>  	}
>  
>  	/*


