Return-Path: <linux-kernel-owner+w=401wt.eu-S1761062AbZLJQiL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761062AbZLJQiL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 11:38:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761033AbZLJQiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 11:38:11 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46134 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760998AbZLJQiK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 11:38:10 -0500
Date: Thu, 10 Dec 2009 17:37:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>,
       linux-kernel@vger.kernel.org, x86team <x86@kernel.org>
Subject: Re: [2.6.32] WARNING: at arch/x86/kernel/apic/apic.c:249
 native_apic_write_dummy+0x30/0x3c()
Message-ID: <20091210163745.GA32563@elte.hu>
References: <20091210154837.GT30903@charite.de>
 <20091210161335.GC5086@lenovo>
 <20091210163055.GD5086@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091210163055.GD5086@lenovo>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Cyrill Gorcunov <gorcunov@openvz.org> wrote:

> On Thu, Dec 10, 2009 at 07:13:35PM +0300, Cyrill Gorcunov wrote:
> > On Thu, Dec 10, 2009 at 04:48:37PM +0100, Ralf Hildebrandt wrote:
> > > Running a vanilla 2.6.32 as Xen DomU, I'm getting:
> > > 
> > > [    0.000999] CPU: Physical Processor ID: 0
> > > [    0.000999] CPU: Processor Core ID: 1
> > > [    0.000999] Performance Events: AMD PMU driver.
> > > [    0.000999] ------------[ cut here ]------------
> > > [    0.000999] WARNING: at arch/x86/kernel/apic/apic.c:249 native_apic_write_dummy+0x30/0x3c()
> > > [    0.000999] Modules linked in:
> ...
> 
> I suppose it should be something like the patch below.
> Please test/review.
> ---
> perf_event: check if we have APIC enabled on AMD cpu
> 
> Ralf Hildebrandt reported:
> 
> |
> | Running a vanilla 2.6.32 as Xen DomU, I'm getting:
> |
> | [    0.000999] CPU: Physical Processor ID: 0
> | [    0.000999] CPU: Processor Core ID: 1
> | [    0.000999] Performance Events: AMD PMU driver.
> | [    0.000999] ------------[ cut here ]------------
> | [    0.000999] WARNING: at arch/x86/kernel/apic/apic.c:249 native_apic_write_dummy+0x30/0x3c()
> | [    0.000999] Modules linked in:
> | [    0.000999] Pid: 0, comm: swapper Not tainted 2.6.32 #3
> | [    0.000999] Call Trace:
> | [    0.000999]  [<ffffffff8102611a>] ? native_apic_write_dummy+0x30/0x3c
> | [    0.000999]  [<ffffffff8104c5a2>] warn_slowpath_common+0x77/0x8f
> | [    0.000999]  [<ffffffff8104c5c9>] warn_slowpath_null+0xf/0x11
> | [    0.000999]  [<ffffffff8102611a>] native_apic_write_dummy+0x30/0x3c
> | [    0.000999]  [<ffffffff8101bf49>] perf_events_lapic_init+0x2e/0x30
> | [    0.000999]  [<ffffffff818cc6fe>] init_hw_perf_events+0x300/0x39d
> | [    0.000999]  [<ffffffff818cc25a>] identify_boot_cpu+0x3c/0x3e
> | [    0.000999]  [<ffffffff818cc3da>] check_bugs+0x9/0x2d
> | [    0.000999]  [<ffffffff818c4cae>] start_kernel+0x37a/0x38f
> | [    0.000999]  [<ffffffff818c42c1>] x86_64_start_reservations+0xac/0xb0
> | [    0.000999]  [<ffffffff818c7b79>] xen_start_kernel+0x530/0x534
> | [    0.000999] ---[ end trace 4eaa2a86a8e2da22 ]---
> |
> 
> So we need to check if APIC has a proper state.
> 
> Reported-by: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> ---
>  arch/x86/kernel/cpu/perf_event.c |   18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)
> 
> Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event.c
> =====================================================================
> --- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event.c
> +++ linux-2.6.git/arch/x86/kernel/cpu/perf_event.c
> @@ -627,6 +627,16 @@ static __initconst u64 amd_hw_cache_even
>   },
>  };
>  
> +static void __init perfmon_check_apic(struct x86_pmu* pmu)
> +{
> +	if (cpu_has_apic)
> +		return;
> +
> +	pmu->apic = 0;
> +	pr_info("no APIC, boot with the \"lapic\" boot parameter to force-enable it.\n");
> +	pr_info("no hardware sampling interrupt available.\n");
> +}
> +
>  /*
>   * AMD Performance Monitor K7 and later.
>   */
> @@ -2062,11 +2072,7 @@ static __init int p6_pmu_init(void)
>  
>  	x86_pmu = p6_pmu;
>  
> -	if (!cpu_has_apic) {
> -		pr_info("no APIC, boot with the \"lapic\" boot parameter to force-enable it.\n");
> -		pr_info("no hardware sampling interrupt available.\n");
> -		x86_pmu.apic = 0;
> -	}
> +	perfmon_check_apic(&x86_pmu);
>  
>  	return 0;
>  }
> @@ -2156,6 +2162,8 @@ static __init int amd_pmu_init(void)
>  	memcpy(hw_cache_event_ids, amd_hw_cache_event_ids,
>  	       sizeof(hw_cache_event_ids));
>  
> +	perfmon_check_apic(&x86_pmu);
> +
>  	return 0;
>  }

Similar check needed in intel_pmu_init() as well? Also, i'd suggest to 
name it pmu_check_apic() or so - and why call it in the middle of of the 
PMU init functions? All PMU drivers are APIC based, so this call can be 
done right after:

        if (err != 0) {
                pr_cont("no PMU driver, software events only.\n");
                return;
        }

	pmu_check_apic();

in a single place. Also, no need to pass in &x86_pmu - we have a single 
PMU driver.

Thanks,

	Ingo
