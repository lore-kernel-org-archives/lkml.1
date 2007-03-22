Return-Path: <linux-kernel-owner+w=401wt.eu-S933115AbXCVPJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933115AbXCVPJ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 11:09:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933152AbXCVPJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 11:09:27 -0400
Received: from www.osadl.org ([213.239.205.134]:55272 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933143AbXCVPJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 11:09:25 -0400
Subject: Re: 2.6.21-rc[123] regression with NOAPIC
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Adrian Bunk <bunk@stusta.de>
Cc: Ray Lee <ray-lk@madrabbit.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, john stultz <johnstul@us.ibm.com>,
       Len Brown <len.brown@intel.com>, Andi Kleen <ak@suse.de>,
       linux-acpi@vger.kernel.org
In-Reply-To: <20070322141630.GA752@stusta.de>
References: <4601573A.8070602@madrabbit.org>
	 <20070322134238.GY752@stusta.de>
	 <1174572603.10840.162.camel@localhost.localdomain>
	 <20070322141630.GA752@stusta.de>
Content-Type: text/plain
Date: Thu, 22 Mar 2007 16:16:41 +0100
Message-Id: <1174576601.10840.189.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-22 at 15:16 +0100, Adrian Bunk wrote:
> > > Does it work if you do _not_ revert the commits, and instead replace in
> > > drivers/acpi/processor_idle.c the
> > >   #ifdef ARCH_APICTIMER_STOPS_ON_C3
> > > with an
> > >   #if 0
> > > ?
> > 
> > Then NOAPIC probably works again, but booting w/o NOAPIC fails.
> 
> But we'll know that it's this code that has a problen with noapic
> in the CONFIG_GENERIC_CLOCKEVENTS=n case.

Nope. This code does not have a problem. It causes a problem elsewhere:

It calls switch_ipi_to_APIC_timer() or switch_APIC_timer_to_ipi(), which
sets/clears a bit in the broadcast mask and enables / disables the local
APIC timer.

I don't see right now, why this causes the box to lock up hard, but
maybe the debug printk's below give us some hint.

	tglx

diff --git a/arch/x86_64/kernel/apic.c b/arch/x86_64/kernel/apic.c
index 723417d..29376e2 100644
--- a/arch/x86_64/kernel/apic.c
+++ b/arch/x86_64/kernel/apic.c
@@ -886,6 +886,8 @@ void disable_APIC_timer(void)
 	if (using_apic_timer) {
 		unsigned long v;
 
+		printk("Disabling local APIC timer %d\n", apic_runs_main_timer);
+
 		v = apic_read(APIC_LVTT);
 		/*
 		 * When an illegal vector value (0-15) is written to an LVT
@@ -910,6 +912,7 @@ void enable_APIC_timer(void)
 	    !cpu_isset(cpu, timer_interrupt_broadcast_ipi_mask)) {
 		unsigned long v;
 
+		printk("Enabling local APIC timer: %d\n", apic_runs_main_timer);
 		v = apic_read(APIC_LVTT);
 		apic_write(APIC_LVTT, v & ~APIC_LVT_MASKED);
 	}
@@ -934,6 +937,7 @@ void smp_send_timer_broadcast_ipi(void)
 
 	cpus_and(mask, cpu_online_map, timer_interrupt_broadcast_ipi_mask);
 	if (!cpus_empty(mask)) {
+		printk("Send IPI\n");
 		send_IPI_mask(mask, LOCAL_TIMER_VECTOR);
 	}
 }


