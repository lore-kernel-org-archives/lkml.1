Return-Path: <linux-kernel-owner+w=401wt.eu-S1753258AbXDJR0K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258AbXDJR0K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 13:26:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753922AbXDJR0K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 13:26:10 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:49882 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753920AbXDJR0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 13:26:08 -0400
Date: Tue, 10 Apr 2007 10:24:29 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Zachary Amsden <zach@vmware.com>
Cc: Chris Wright <chrisw@sous-sol.org>, Andrew Morton <akpm@osdl.org>,
       Andi Kleen <ak@muc.de>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dan Hecht <dhecht@vmware.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 9/10] Vmi timer update.patch
Message-ID: <20070410172429.GN10574@sequoia.sous-sol.org>
References: <200704100006.l3A06RUR020644@zach-dev.vmware.com> <20070410023702.GJ10574@sequoia.sous-sol.org> <461BC373.10306@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <461BC373.10306@vmware.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Zachary Amsden (zach@vmware.com) wrote:
> >>+void __init vmi_time_init(void)
> >>+{
> >>+	/* Disable PIT: BIOSes start PIT CH0 with 18.2hz peridic. */
> >>+	outb_p(0x3a, PIT_MODE); /* binary, mode 5, LSB/MSB, ch 0 */
> >
> >That shouldn't be necessary using clockevents.
> 
> Actually, I'm not so sure.  If clockevents simply masks the PIT when 
> disabling it, we still have overhead of keeping the latch in sync, which 
> requires a timer at the PIT frequency.  I can instrument to see how 
> exactly the PIT gets disabled.

It should switch from pit to vmi-timer, and the switch should do the state
transistions on pit to go to unused mode.

> >>+	vmi_time_init_clockevent();
> >>+	setup_irq(0, &vmi_clock_action);
> >>+}
> >>+
> >>+#ifdef CONFIG_X86_LOCAL_APIC
> >>+void __devinit vmi_time_bsp_init(void)
> >>+{
> >>+	/*
> >>+	 * On APIC systems, we want local timers to fire on each cpu.  We do
> >>+	 * this by programming LVTT to deliver timer events to the IRQ 
> >>handler
> >>+	 * for IRQ-0, since we can't re-use the APIC local timer handler
> >>+	 * without interfering with that code.
> >>+	 */
> >>+	clockevents_notify(CLOCK_EVT_NOTIFY_SUSPEND, NULL);
> >
> >Why do you do this suspend...
> 
> We need to cancel all pending PIT timer events and restart then local 
> timer, which requires atomically taking over IRQ-0.  We use the IDT gate 
> for IRQ-0 because it is already an exclusive interrupt, but we can't 
> re-use the LVTT IDT gate for local timer since that requires a custom 
> custom SMP interrupt in entry.S.  So we must be absolutely sure when we 
> get an interrupt on IRQ-0 that it came from the VMI local (rather than 
> PIT) delivery path.

OK, this is why it seems odd.  Clockevents should put pit timer into
unused state.

> >>+	local_irq_disable();
> >>+#ifdef CONFIG_X86_SMP
> >>+	/*
> >>+	 * XXX handle_percpu_irq only defined for SMP; we need to switch over
> >>+	 * to using it, since this is a local interrupt, which each CPU must
> >>+	 * handle individually without locking out or dropping simultaneous
> >>+	 * local timers on other CPUs.  We also don't want to trigger the
> >>+	 * quirk workaround code for interrupts which gets invoked from
> >>+	 * handle_percpu_irq via eoi, so we use our own IRQ chip.
> >>+	 */
> >>+	set_irq_chip_and_handler_name(0, &vmi_chip, handle_percpu_irq, 
> >>"lvtt");
> >>+#else
> >>+	set_irq_chip_and_handler_name(0, &vmi_chip, handle_edge_irq, "lvtt");
> >>+#endif
> >>+	vmi_wiring = VMI_ALARM_WIRED_LVTT;
> >>+	apic_write(APIC_LVTT, vmi_get_timer_vector());
> >>    
> >
> >isn't this just your ->startup?
> 
> Which structure has a ->startup function we can use?  Sorry if this 
> seems ignorant, I'm not quite sure what you mean.

The irq_chip.  IOW, it looks like a liberal sprinkling of LVTT vector
initialization.

> >>+	local_irq_enable();
> >>+	clockevents_notify(CLOCK_EVT_NOTIFY_RESUME, NULL);
> >...and resume?  Instead of letting clockevents core handle all of that,
> >and just registering right here?
> 
> It wasn't clear that clockevents would issue a resume notify for us; if 
> so we could handle this setup in the callback, but it has to be done on 
> the correct CPU.  I can try it and see if that works.

I would've expected to simply register the clockevents device right here,
and that should do the proper state transitions on the old device, as well
as the new device.  Why do you need resume notify?

thanks,
-chris
