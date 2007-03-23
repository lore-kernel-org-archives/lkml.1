Return-Path: <linux-kernel-owner+w=401wt.eu-S1752264AbXCWFf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264AbXCWFf2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 01:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751647AbXCWFf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 01:35:28 -0400
Received: from tapsys.com ([72.36.178.242]:37453 "EHLO tapsys.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751326AbXCWFf0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 01:35:26 -0400
Message-ID: <46036718.7060502@madrabbit.org>
Date: Thu, 22 Mar 2007 22:35:20 -0700
From: Ray Lee <ray-lk@madrabbit.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: tglx@linutronix.de
Cc: Adrian Bunk <bunk@stusta.de>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, john stultz <johnstul@us.ibm.com>,
       Len Brown <len.brown@intel.com>, Andi Kleen <ak@suse.de>,
       linux-acpi@vger.kernel.org
Subject: Re: 2.6.21-rc[123] regression with NOAPIC
References: <4601573A.8070602@madrabbit.org>	 <20070322134238.GY752@stusta.de>	 <1174572603.10840.162.camel@localhost.localdomain>	 <20070322141630.GA752@stusta.de> <1174576601.10840.189.camel@localhost.localdomain>
In-Reply-To: <1174576601.10840.189.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Thu, 2007-03-22 at 15:16 +0100, Adrian Bunk wrote:
>>>> Does it work if you do _not_ revert the commits, and instead replace in
>>>> drivers/acpi/processor_idle.c the
>>>>   #ifdef ARCH_APICTIMER_STOPS_ON_C3
>>>> with an
>>>>   #if 0
>>>> ?
>>> Then NOAPIC probably works again, but booting w/o NOAPIC fails.
>> But we'll know that it's this code that has a problen with noapic
>> in the CONFIG_GENERIC_CLOCKEVENTS=n case.
> 
> Nope. This code does not have a problem. It causes a problem elsewhere:

I can still try the above if it ends up being a useful data point.

> 
> It calls switch_ipi_to_APIC_timer() or switch_APIC_timer_to_ipi(), which
> sets/clears a bit in the broadcast mask and enables / disables the local
> APIC timer.
> 
> I don't see right now, why this causes the box to lock up hard, but
> maybe the debug printk's below give us some hint.
> 
> 	tglx
> 
> diff --git a/arch/x86_64/kernel/apic.c b/arch/x86_64/kernel/apic.c
> index 723417d..29376e2 100644
> --- a/arch/x86_64/kernel/apic.c
> +++ b/arch/x86_64/kernel/apic.c
> @@ -886,6 +886,8 @@ void disable_APIC_timer(void)
>  	if (using_apic_timer) {
>  		unsigned long v;
>  
> +		printk("Disabling local APIC timer %d\n", apic_runs_main_timer);
> +
>  		v = apic_read(APIC_LVTT);
>  		/*
>  		 * When an illegal vector value (0-15) is written to an LVT
> @@ -910,6 +912,7 @@ void enable_APIC_timer(void)
>  	    !cpu_isset(cpu, timer_interrupt_broadcast_ipi_mask)) {
>  		unsigned long v;
>  
> +		printk("Enabling local APIC timer: %d\n", apic_runs_main_timer);
>  		v = apic_read(APIC_LVTT);
>  		apic_write(APIC_LVTT, v & ~APIC_LVT_MASKED);
>  	}
> @@ -934,6 +937,7 @@ void smp_send_timer_broadcast_ipi(void)
>  
>  	cpus_and(mask, cpu_online_map, timer_interrupt_broadcast_ipi_mask);
>  	if (!cpus_empty(mask)) {
> +		printk("Send IPI\n");
>  		send_IPI_mask(mask, LOCAL_TIMER_VECTOR);
>  	}
>  }
> 
> 

I didn't see the first two print, but I'm having to watch the bad
bootups (with NOAPIC) by eyesight alone, as I don't have a second system
to run netconsole on at the moment.

However, on the NOAPIC, locking boot, the last thing that prints out is
the final printk, Send IPI.

On the boots without NOAPIC, at the same spot roughly a thousand
(estimated) "Send IPI" messages hit the screen before transitioning to
the initramfs and continuing normally.

In the morning, I can rework the patch to set a global in the first two
cases (Disabling/Enabling local APIC timer), and print the result of
those in the last case, as we know the system will hang there. (I would
have done this before sending the message, but given our timezone
difference, figured this was a good start.)

Ray
