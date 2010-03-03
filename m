Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531Ab0CCSbr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 13:31:47 -0500
Received: from claw.goop.org ([74.207.240.146]:41228 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754490Ab0CCSbp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 13:31:45 -0500
Message-ID: <4B8EAB0F.3000104@goop.org>
Date: Wed, 03 Mar 2010 10:31:43 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Sheng Yang <sheng@linux.intel.com>
CC: Keir Fraser <keir.fraser@eu.citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Ian Pratt <Ian.Pratt@eu.citrix.com>, linux-kernel@vger.kernel.org,
       xen-devel <xen-devel@lists.xensource.com>,
       Ian Campbell <Ian.Campbell@citrix.com>,
       Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [Xen-devel] [PATCH 5/7] xen: Make event channel work with PV
 extension of HVM
References: <1267436315-24486-1-git-send-email-sheng@linux.intel.com> <1267436315-24486-6-git-send-email-sheng@linux.intel.com> <4B8C6C0D.3070005@goop.org> <201003021348.06360.sheng@linux.intel.com>
In-Reply-To: <201003021348.06360.sheng@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2010 09:48 PM, Sheng Yang wrote:
>> Presumably even if we don't have PV_EVTCHN available/enabled, the Xen
>> clocksource would be available for getting time?
>>      
> I think currently Xen pv clocksource and clockevent are binding... Not sure if
> a single line "clocksource_register(&xen_clocksource)" can work. I would give
> it a try, maybe add a new PV feature.
>    

There should be no strong binding between them, but there may be some 
sloppy assumptions in xen/time.c which should be fixed.  Linux itself 
treats clocksources and eventsources as completely distinct entities, 
and doesn't assume they're running on the same timebase (for example).

Having a PV clocksource even if the timer interrupts are emulated would 
make sense and be useful.

>>>    	xen_setup_vcpu_info_placement();
>>>    }
>>> @@ -480,3 +487,138 @@ void __init xen_smp_init(void)
>>>    	xen_fill_possible_map();
>>>    	xen_init_spinlocks();
>>>    }
>>> +
>>> +static __cpuinit void xen_hvm_pv_start_secondary(void)
>>> +{
>>> +	int cpu = smp_processor_id();
>>> +
>>> +	cpu_init();
>>> +	touch_nmi_watchdog();
>>> +	preempt_disable();
>>> +
>>> +	/* otherwise gcc will move up smp_processor_id before the cpu_init */
>>> +	barrier();
>>> +	/*
>>> +	 * Check TSC synchronization with the BSP:
>>> +	 */
>>> +	check_tsc_sync_target();
>>> +
>>> +	/* Done in smp_callin(), move it here */
>>> +	set_mtrr_aps_delayed_init();
>>> +	smp_store_cpu_info(cpu);
>>> +
>>> +	/* This must be done before setting cpu_online_mask */
>>> +	set_cpu_sibling_map(cpu);
>>> +	wmb();
>>> +
>>> +	set_cpu_online(smp_processor_id(), true);
>>> +	per_cpu(cpu_state, smp_processor_id()) = CPU_ONLINE;
>>> +
>>> +	/* enable local interrupts */
>>> +	local_irq_enable();
>>> +
>>> +	xen_setup_cpu_clockevents();
>>>        
>> How much of this is necessary?  At this point, isn't CPU bringup the
>> same as PV?
>>      
> Xen_enable_sysenter/syscall is not needed for this. And we have a TSC sync
> here - but it seems unnecessary for PV. But set_mtrr_aps_delayed_init() is
> needed. Reuse the cpu_bring_up() is fine?
>    

Doesn't Xen arrange for the tscs to be synced anyway?

>> Is the MMUEXT_TLB_FLUSH/INVLPG_MULTI hypercall not currently available
>> to HVM?
>>      
> I think they are different. These hypercalls flushed native's TLB, but HVM
> want to flush guest one, especially when using shadow, HVM need do something
> for it.
>    

I see.

     J
