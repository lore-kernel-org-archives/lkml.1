Return-Path: <linux-kernel-owner+w=401wt.eu-S2992631AbXCGVPf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992631AbXCGVPf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 16:15:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992629AbXCGVPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 16:15:35 -0500
Received: from www.osadl.org ([213.239.205.134]:41206 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S2992628AbXCGVPe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 16:15:34 -0500
Subject: Re: + stupid-hack-to-make-mainline-build.patch added to -mm tree
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Dan Hecht <dhecht@vmware.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, James Morris <jmorris@namei.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       akpm@linux-foundation.org, john stultz <johnstul@us.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <45EF175D.6030609@vmware.com>
References: <200703060654.l266sVxr014860@shell0.pdx.osdl.net>
	 <45ED16D2.3000202@vmware.com> <20070306084258.GA15745@elte.hu>
	 <20070306084647.GA16280@elte.hu> <45ED2C82.3080008@vmware.com>
	 <1173178774.24738.311.camel@localhost.localdomain>
	 <45EDD82F.90204@vmware.com>
	 <1173225182.24738.507.camel@localhost.localdomain>
	 <45EE0628.1080108@goop.org> <45EE08E8.2020008@vmware.com>
	 <1173228544.24738.514.camel@localhost.localdomain>
	 <45EE0D10.7070807@vmware.com>
	 <1173230305.24738.529.camel@localhost.localdomain>
	 <45EE1EA3.90803@vmware.com>
	 <1173256666.24738.576.camel@localhost.localdomain>
	 <45EEF966.6060902@goop.org>	<Line.LNX.4.64.0703071304080.1851@d.namei>
	 <45EF0CF5.5090305@goop.org>  <45EF175D.6030609@vmware.com>
Content-Type: text/plain
Date: Wed, 07 Mar 2007 22:21:43 +0100
Message-Id: <1173302503.24738.795.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-07 at 11:49 -0800, Dan Hecht wrote:
> Jeremy, I saw you sent out the Xen version earlier, thanks.  Here's ours 
> for reference (please excuse any formating issues); it's also lean. 
> We'll send out a proper patch later after some more testing:

Ah. Bitching loud enough speeds things up. :)

> /** vmi clockevent */
> 
> static struct clock_event_device vmi_global_clockevent;
> 
> static inline u32 vmi_alarm_wiring(struct clock_event_device *evt)
> {
> 	return (evt == &vmi_global_clockevent) ?
> 		VMI_ALARM_WIRED_IRQ0 : VMI_ALARM_WIRED_LVTT;
> }
> 
> static void vmi_timer_set_mode(enum clock_event_mode mode,
> 			       struct clock_event_device *evt)
> {
> 	u32 wiring;
> 	cycle_t now, cycles_per_hz;
> 	BUG_ON(!irqs_disabled());
> 
> 	wiring = vmi_alarm_wiring(evt);
> 	if (wiring == VMI_ALARM_WIRED_LVTT)
> 		/* Route the interrupt to the correct vector */
> 		apic_write_around(APIC_LVTT, LOCAL_TIMER_VECTOR);

Wire that in the hypervisor.

> 	switch (mode) {
> 	case CLOCK_EVT_MODE_ONESHOT:
> 		break;
> 	case CLOCK_EVT_MODE_PERIODIC:
> 		cycles_per_hz = vmi_timer_ops.get_cycle_frequency();
> 		(void)do_div(cycles_per_hz, HZ);
> 		now = vmi_timer_ops.get_cycle_counter(vmi_counter(VMI_PERIODIC));
> 		vmi_timer_ops.set_alarm(wiring | VMI_PERIODIC,
> 					now, cycles_per_hz);

	paravirt_ops->paravirt_clockevent->set_periodic(vcpu, period);

> 		break;
> 	case CLOCK_EVT_MODE_UNUSED:
> 	case CLOCK_EVT_MODE_SHUTDOWN:

	paravirt_ops->paravirt_clockevent->stop_event(vcpu, mode);


> 		switch (evt->mode) {
> 		case CLOCK_EVT_MODE_ONESHOT:
> 			vmi_timer_ops.cancel_alarm(VMI_ONESHOT);
> 			break;
> 		case CLOCK_EVT_MODE_PERIODIC:
> 			vmi_timer_ops.cancel_alarm(VMI_PERIODIC);
> 			break;
> 		default:
> 			break;
> 		}
> 		break;
> 	default:
> 		break;
> 	}
> }

This whole vmi_timer_ops thing is horrible. All hypervisors can share 
paravirt_ops->paravirt_clockevent and retrieve the methods on boot.

> static int vmi_timer_next_event(unsigned long delta,
> 				struct clock_event_device *evt)
> {
> 	/* Unfortunately, set_next_event interface only passes relative
> 	 * expiry, but we want absolute expiry.  It'd be better if were
> 	 * were passed an aboslute expiry, since a bunch of time may
> 	 * have been stolen between the time the delta is computed and
> 	 * when we set the alarm below. */
> 	cycle_t now = vmi_timer_ops.get_cycle_counter(vmi_counter(VMI_ONESHOT));
> 
> 	BUG_ON(evt->mode != CLOCK_EVT_MODE_ONESHOT);
> 	vmi_timer_ops.set_alarm(vmi_alarm_wiring(evt) | VMI_ONESHOT,
> 				now + delta, 0);
> 	return 0;
> }

Great. Now we have:

       s64 event = startup_offset + ktime_to_ns(evt->next_event);

       if (HYPERVISOR_set_timer_op(event) < 0)
                BUG();
and

	vmi_timer_ops.set_alarm(vmi_alarm_wiring(evt) | VMI_ONESHOT,	now + delta, 0);

How will the next implementations look like ?

	lguest_program_timer(delta + lguest_current_time(), LGUEST_TIMER_SHOOT_ONCE);

	virt_nextgen_ops.set_timer_event(delta, NO_WE_NEED_NO_FLAGS);

	.......

This is tinkering of the best. My understanding of the paravirt
discussion at Kernel Summit was, that paravirt ops are exactly there to
prevent the above random hackery in the kernel and to allow _ALL_
hypervisors to interact via a sane interface inside of the kernel.

You are just perverting the whole idea of a standartized
paravirtualization interface.

This things can be done for clocksources, clockevents, interrupts (the
generic irq code allows this) and probaly for a whole bunch of other
stuff.

The current paravirt interface is completely insane and will explode
into an unmaintainable nightmare within no time, if we keep accepting
that crap further.

No thanks.

> #ifdef CONFIG_X86_LOCAL_APIC
> 
> /* Replacement for lapic timer local clock event.
>   * paravirt_ops.setup_boot_clock      = vmi_nop
>   *       (continue using global_clock_event on cpu0)
>   * paravirt_ops.setup_secondary_clock = vmi_timer_setup_local_alarm
>   */
> void __devinit vmi_timer_setup_local_alarm(void)
> {
> 	struct clock_event_device *evt = &__get_cpu_var(local_clock_events);
> 
> 	/* Then, start it back up as a local clockevent device. */
> 	memcpy(evt, &vmi_clockevent, sizeof(*evt));
> 	evt->cpumask = cpumask_of_cpu(smp_processor_id());
> 
> 	printk(KERN_WARNING "vmi: registering clock event %s. mult=%lu 
> shift=%u\n",
> 	       evt->name, evt->mult, evt->shift);
> 	clockevents_register_device(evt);
> }
> 
> #endif

Why the hell do you need an lapic emulator here? This is exactly the
kind of crap, we do not want to have. clockevents do not care which
piece of hardware is calling them and we do not care how a particular
hypervisor is wiring that hardware.

	tglx


