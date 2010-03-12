Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932556Ab0CLUiA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 15:38:00 -0500
Received: from claw.goop.org ([74.207.240.146]:42371 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753168Ab0CLUh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 15:37:58 -0500
Message-ID: <4B9AA623.6050601@goop.org>
Date: Fri, 12 Mar 2010 12:37:55 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.3
MIME-Version: 1.0
To: Sheng Yang <sheng@linux.intel.com>
CC: xen-devel <xen-devel@lists.xensource.com>,
       Ian Campbell <Ian.Campbell@citrix.com>, linux-kernel@vger.kernel.org,
       Ian Pratt <Ian.Pratt@eu.citrix.com>,
       Keir Fraser <keir.fraser@eu.citrix.com>
Subject: Re: [Xen-devel] [PATCH][v9 6/6] xen: Enable PV clocksource for HVM
References: <1268362647-5317-1-git-send-email-sheng@linux.intel.com> <1268362647-5317-7-git-send-email-sheng@linux.intel.com>
In-Reply-To: <1268362647-5317-7-git-send-email-sheng@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2010 06:57 PM, Sheng Yang wrote:
> PV clocksource can provide a reliable clocksource for HVM running on Xen.
>
> To enable it, put following line to the HVM configure file:
>
> cpuid = [ '0x40000002:edx=0x3' ]
>
> It would set bit 0 and bit 1 in 0x40000002:edx, which enable PV extension
> framework and PV clocksource.
>    

I guess my previous comment would be better made here.  I don't see any 
reason to make the Xen pv clocksource conditional at runtime.  If the 
user wants to disable/override it, then they can either boot with a 
clocksource= parameter on the kernel command line, or change it on the 
fly via /sys.

     J

> Signed-off-by: Sheng Yang<sheng@linux.intel.com>
> ---
>   arch/x86/xen/hvmpv.c   |   24 ++++++++++++++++++++++++
>   arch/x86/xen/time.c    |   12 +++++++++++-
>   arch/x86/xen/xen-ops.h |    1 +
>   3 files changed, 36 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/xen/hvmpv.c b/arch/x86/xen/hvmpv.c
> index a24a1e9..1961cf0 100644
> --- a/arch/x86/xen/hvmpv.c
> +++ b/arch/x86/xen/hvmpv.c
> @@ -42,6 +42,8 @@ static void __init xen_hvm_pv_banner(void)
>   		pv_info.name);
>   	printk(KERN_INFO "Xen version: %d.%d%s\n",
>   		version>>  16, version&  0xffff, extra.extraversion);
> +	if (xen_hvm_pv_clock_enabled())
> +		printk(KERN_INFO "PV feature: PV clocksource enabled\n");
>   }
>
>   static int __init xen_para_available(void)
> @@ -80,6 +82,9 @@ static int __init init_hvm_pv_info(void)
>   	if (!(edx&  XEN_CPUID_FEAT2_HVM_PV))
>   		return -ENODEV;
>
> +	if (edx&  XEN_CPUID_FEAT2_HVM_PV_CLOCK)
> +		xen_hvm_pv_features |= XEN_HVM_PV_CLOCK_ENABLED;
> +
>   	if (pages<  1)
>   		return -ENODEV;
>
> @@ -110,6 +115,23 @@ static int __init init_shared_info(void)
>   	return 0;
>   }
>
> +static void __init init_pv_clocksource(void)
> +{
> +	if (!xen_hvm_pv_clock_enabled())
> +		return;
> +
> +	if (enable_hvm_pv(HVM_PV_CLOCK))
> +		BUG();
> +
> +	pv_time_ops.sched_clock = xen_sched_clock;
> +
> +	x86_platform.calibrate_tsc = xen_tsc_khz;
> +	x86_platform.get_wallclock = xen_get_wallclock;
> +	x86_platform.set_wallclock = xen_set_wallclock;
> +
> +	xen_register_clocksource();
> +}
> +
>   void __init xen_guest_init(void)
>   {
>   	int r;
> @@ -132,4 +154,6 @@ void __init xen_guest_init(void)
>   	pv_info = xen_hvm_pv_info;
>
>   	xen_domain_type = XEN_HVM_DOMAIN;
> +
> +	init_pv_clocksource();
>   }
> diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
> index 0a5aa44..d1c1c50 100644
> --- a/arch/x86/xen/time.c
> +++ b/arch/x86/xen/time.c
> @@ -474,11 +474,21 @@ void xen_timer_resume(void)
>   	}
>   }
>
> +static bool xen_clocksource_enabled;
> +
> +void xen_register_clocksource(void)
> +{
> +	if (!xen_clocksource_enabled) {
> +		clocksource_register(&xen_clocksource);
> +		xen_clocksource_enabled = 1;
> +	}
> +}
> +
>   __init void xen_time_init(void)
>   {
>   	int cpu = smp_processor_id();
>
> -	clocksource_register(&xen_clocksource);
> +	xen_register_clocksource();
>
>   	if (HYPERVISOR_vcpu_op(VCPUOP_stop_periodic_timer, cpu, NULL) == 0) {
>   		/* Successfully turned off 100Hz tick, so we have the
> diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
> index 355fa6b..2aeaf51 100644
> --- a/arch/x86/xen/xen-ops.h
> +++ b/arch/x86/xen/xen-ops.h
> @@ -46,6 +46,7 @@ cycle_t xen_clocksource_read(void);
>   void xen_setup_cpu_clockevents(void);
>   unsigned long xen_tsc_khz(void);
>   void __init xen_time_init(void);
> +void xen_register_clocksource(void);
>   unsigned long xen_get_wallclock(void);
>   int xen_set_wallclock(unsigned long time);
>   unsigned long long xen_sched_clock(void);
>    

