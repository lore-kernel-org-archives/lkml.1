Return-Path: <linux-kernel-owner+w=401wt.eu-S1757164AbZHNVlF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757164AbZHNVlF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 17:41:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756606AbZHNVlD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 17:41:03 -0400
Received: from mga14.intel.com ([143.182.124.37]:25243 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755950AbZHNVlD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 17:41:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,382,1246863600"; 
   d="scan'208";a="175991128"
Subject: Re: [PATCH] disable per-cpu hpet timer if ARAT is supported
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Li, Shaohua" <shaohua.li@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>
In-Reply-To: <20090812031612.GA10062@sli10-desk.sh.intel.com>
References: <20090812031612.GA10062@sli10-desk.sh.intel.com>
Content-Type: text/plain
Date: Fri, 14 Aug 2009 14:41:03 -0700
Message-Id: <1250286063.11545.43904.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>


On Tue, 2009-08-11 at 20:16 -0700, Li, Shaohua wrote:
> If CPU support always running local APIC timer, per-cpu hpet timer could be
> disabled, which is useless and wasteful in such case. Let's leave the timers
> to others.
> Impact: should have no impact except reserving less timers.
> 
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
> index dedc2bd..5969e10 100644
> --- a/arch/x86/kernel/hpet.c
> +++ b/arch/x86/kernel/hpet.c
> @@ -584,6 +584,8 @@ static void hpet_msi_capability_lookup(unsigned int start_timer)
>  	unsigned int num_timers_used = 0;
>  	int i;
>  
> +	if (boot_cpu_has(X86_FEATURE_ARAT))
> +		return;
>  	id = hpet_readl(HPET_ID);
>  
>  	num_timers = ((id & HPET_ID_NUMBER) >> HPET_ID_NUMBER_SHIFT);
> @@ -872,10 +874,8 @@ int __init hpet_enable(void)
>  
>  	if (id & HPET_ID_LEGSUP) {
>  		hpet_legacy_clockevent_register();
> -		hpet_msi_capability_lookup(2);
>  		return 1;
>  	}
> -	hpet_msi_capability_lookup(0);
>  	return 0;
>  
>  out_nohpet:
> @@ -908,9 +908,17 @@ static __init int hpet_late_init(void)
>  	if (!hpet_virt_address)
>  		return -ENODEV;
>  
> +	if (hpet_readl(HPET_ID) & HPET_ID_LEGSUP)
> +		hpet_msi_capability_lookup(2);
> +	else
> +		hpet_msi_capability_lookup(0);
> +
>  	hpet_reserve_platform_timers(hpet_readl(HPET_ID));
>  	hpet_print_config();
>  
> +	if (boot_cpu_has(X86_FEATURE_ARAT))
> +		return 0;
> +
>  	for_each_online_cpu(cpu) {
>  		hpet_cpuhp_notify(NULL, CPU_ONLINE, (void *)(long)cpu);
>  	}

