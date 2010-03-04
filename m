Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541Ab0CDRky (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 12:40:54 -0500
Received: from claw.goop.org ([74.207.240.146]:40445 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752966Ab0CDRkx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 12:40:53 -0500
Message-ID: <4B8FF0A3.9060305@goop.org>
Date: Thu, 04 Mar 2010 09:40:51 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.3
MIME-Version: 1.0
To: Sheng Yang <sheng@linux.intel.com>
CC: Keir Fraser <Keir.Fraser@eu.citrix.com>, Ingo Molnar <mingo@elte.hu>,
       Ian Pratt <Ian.Pratt@eu.citrix.com>,
       Ian Campbell <Ian.Campbell@eu.citrix.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [PATCH 6/7] xen: Enable PV clocksource for HVM
References: <1267695416-14988-1-git-send-email-sheng@linux.intel.com> <1267695416-14988-7-git-send-email-sheng@linux.intel.com>
In-Reply-To: <1267695416-14988-7-git-send-email-sheng@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2010 01:36 AM, Sheng Yang wrote:
> And enable it by default in PV extended HVM guest.
>
> Signed-off-by: Sheng Yang<sheng@linux.intel.com>
> ---
>   arch/x86/xen/hvmpv.c |   20 ++++++++++++++++++++
>   arch/x86/xen/time.c  |    4 +++-
>   2 files changed, 23 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/xen/hvmpv.c b/arch/x86/xen/hvmpv.c
> index 7a741ed..284e021 100644
> --- a/arch/x86/xen/hvmpv.c
> +++ b/arch/x86/xen/hvmpv.c
> @@ -43,6 +43,7 @@ static void __init xen_hvm_pv_banner(void)
>   		pv_info.name);
>   	printk(KERN_INFO "Xen version: %d.%d%s\n",
>   		version>>  16, version&  0xffff, extra.extraversion);
> +	printk(KERN_INFO "PV feature: PV clocksource enabled\n");
>   }
>
>   static int __init xen_para_available(void)
> @@ -117,6 +118,22 @@ static void __init init_shared_info(void)
>   	per_cpu(xen_vcpu, 0) =&HYPERVISOR_shared_info->vcpu_info[0];
>   }
>
> +extern struct clocksource xen_clocksource;
>    

No externs in .c files.  But aside from that, I'd prefer you export a 
function from xen/time.c to do the clocksource registration and call it 
from both places (even if its a one-liner).

> +
> +static void __init init_pv_clocksource(void)
> +{
> +	if (enable_hvm_pv(HVM_PV_CLOCK))
> +		BUG();
>    

BUG is a bit severe.  Will it really never, ever fail?  And if it does, 
the consequence is hardly serious; we just fall back to emulated devices.

> +
> +	pv_time_ops.sched_clock = xen_sched_clock;
> +
> +	x86_platform.calibrate_tsc = xen_tsc_khz;
> +	x86_platform.get_wallclock = xen_get_wallclock;
> +	x86_platform.set_wallclock = xen_set_wallclock;
> +
> +	clocksource_register(&xen_clocksource);
> +}
> +
>   void __init xen_guest_init(void)
>   {
>   	int r;
> @@ -130,4 +147,7 @@ void __init xen_guest_init(void)
>   		return;
>
>   	init_shared_info();
> +
> +	/* PV clocksource would be enabled by default */
> +	init_pv_clocksource();
>   }
> diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
> index 0d3f07c..c80eacb 100644
> --- a/arch/x86/xen/time.c
> +++ b/arch/x86/xen/time.c
> @@ -13,6 +13,7 @@
>   #include<linux/clockchips.h>
>   #include<linux/kernel_stat.h>
>   #include<linux/math64.h>
> +#include<linux/module.h>
>
>   #include<asm/pvclock.h>
>   #include<asm/xen/hypervisor.h>
> @@ -243,7 +244,7 @@ int xen_set_wallclock(unsigned long now)
>   	return -1;
>   }
>
> -static struct clocksource xen_clocksource __read_mostly = {
> +struct clocksource xen_clocksource __read_mostly = {
>   	.name = "xen",
>   	.rating = 400,
>   	.read = xen_clocksource_get_cycles,
> @@ -252,6 +253,7 @@ static struct clocksource xen_clocksource __read_mostly = {
>   	.shift = XEN_SHIFT,
>   	.flags = CLOCK_SOURCE_IS_CONTINUOUS,
>   };
> +EXPORT_SYMBOL_GPL(xen_clocksource);
>
>   /*
>      Xen clockevent implementation
>    

