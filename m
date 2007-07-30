Return-Path: <linux-kernel-owner+w=401wt.eu-S1753308AbXG3J60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308AbXG3J60 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 05:58:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751108AbXG3J6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 05:58:18 -0400
Received: from serv1.oss.ntt.co.jp ([222.151.198.98]:55635 "EHLO
	serv1.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbXG3J6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 05:58:17 -0400
Subject: Re: [PATCH 2/2] Debug handling of early spurious interrupts
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070720144302.2785e961.akpm@linux-foundation.org>
References: <1184666997.5271.5.camel@sebastian.kern.oss.ntt.co.jp>
	 <20070718154659.c8b5ffea.akpm@linux-foundation.org>
	 <1184896459.27369.36.camel@sebastian.kern.oss.ntt.co.jp>
	 <1184896944.27369.50.camel@sebastian.kern.oss.ntt.co.jp>
	 <1184898043.28418.3.camel@sebastian.kern.oss.ntt.co.jp>
	 <20070720144302.2785e961.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: NTT Open Source Software Center
Date: Mon, 30 Jul 2007 18:58:14 +0900
Message-Id: <1185789494.9831.107.camel@sebastian.kern.oss.ntt.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-20 at 14:43 -0700, Andrew Morton wrote: 
> On Fri, 20 Jul 2007 11:20:43 +0900
> Fernando Luis V__zquez Cao <fernando@oss.ntt.co.jp> wrote:
> 
> > With the advent of kdump it is possible that device drivers receive
> > interrupts generated in the context of a previous kernel. Ideally
> > quiescing the underlying devices should suffice but not all drivers do
> > this, either because it is not possible or because they did not
> > contemplate this case. Thus drivers ought to be able to handle
> > interrupts coming in as soon as the interrupt handler is registered.
> > 
> > Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
> > ---
> > 
> > diff -urNp linux-2.6.22-orig/kernel/irq/manage.c linux-2.6.22-pendirq/kernel/irq/manage.c
> > --- linux-2.6.22-orig/kernel/irq/manage.c	2007-07-19 18:18:53.000000000 +0900
> > +++ linux-2.6.22-pendirq/kernel/irq/manage.c	2007-07-19 19:43:41.000000000 +0900
> > @@ -533,21 +533,32 @@ int request_irq(unsigned int irq, irq_ha
> >  
> >  	select_smp_affinity(irq);
> >  
> > -	if (irqflags & IRQF_SHARED) {
> > -		/*
> > -		 * It's a shared IRQ -- the driver ought to be prepared for it
> > -		 * to happen immediately, so let's make sure....
> > -		 * We do this before actually registering it, to make sure that
> > -		 * a 'real' IRQ doesn't run in parallel with our fake
> > -		 */
> > -		if (irqflags & IRQF_DISABLED) {
> > -			unsigned long flags;
> > +	/*
> > +	 * With the advent of kdump it possible that device drivers receive
> > +	 * interrupts generated in the context of a previous kernel. Ideally
> > +	 * quiescing the underlying devices should suffice but not all drivers
> > +	 * do this, either because it is not possible or because they did not
> > +	 * contemplate this case. Thus drivers ought to be able to handle
> > +	 * interrupts coming in as soon as the interrupt handler is registered.
> > +	 *
> > +	 * Besides, if it is a shared IRQ the driver ought to be prepared for
> > +	 * it to happen immediately too.
> > +	 *
> > +	 * We do this before actually registering it, to make sure that
> > +	 * a 'real' IRQ doesn't run in parallel with our fake.
> > +	 */
> > +	if (irqflags & IRQF_DISABLED) {
> > +		unsigned long flags;
> >  
> > -			local_irq_save(flags);
> > -			handler(irq, dev_id);
> > -			local_irq_restore(flags);
> > -		} else
> > -			handler(irq, dev_id);
> > +		local_irq_save(flags);
> > +		retval = handler(irq, dev_id);
> > +		local_irq_restore(flags);
> > +	} else
> > +		retval = handler(irq, dev_id);
> > +	if (retval == IRQ_HANDLED) {
> > +		printk(KERN_WARNING
> > +		       "%s (IRQ %d) handled a spurious interrupt\n",
> > +		       devname, irq);
> >  	}
> >  
> 
> This change means that we'll run the irq handler at request_irq()-time even
> for non-shared interrupts.
> 
> This is a bit of a worry.  See, shared-interrupt handlers are required to
> be able to cope with being called when their device isn't interrupting. 
> But nobody ever said that non-shared interrupt handlers need to be able to
> cope with that.
> 
> Hence these non-shared handlers are within their rights to emit warning
> printks, go BUG or accuse the operator of having busted hardware.
> 
> So bad things might happen because of this change.  And if they do, they
> will take a loooong time to be discovered, because non-shared interrupt
> handlers tend to dwell in crufty old drivers which not many people use.
> 
> So I'm wondering if it would be more prudent to only do all this for shared
> handlers?

I have been testing this patches on all my machines, which spans three
different architectures: i386, x86_64 (EM64T and Opteron), and ia64.

The good news is that nothing catastrophic happened and, in the process,
I managed to find some somewhat buggy interrupt handlers.

I will present a brief summary of my findings here. That said, I have to
admit that these are still preliminary results and have not had time to
dig deep into all the issues. I would like hear from you first.

- Test environment

-- x86_64 [EM64T]
   CPU: Intel(R) Xeon(TM) CPU 3.20GHz (2 cpus)
   SCSI: Adaptec AIC-7902B U320
   IDE: Intel Corporation 82801EB/ER (ICH5/ICH5R) IDE Controller

-- x86_64 [Opteron]
   CPU: AMD Opteron(tm) Processor 240 (2 cpus)
   IDE: Advanced Micro Devices [AMD] AMD-8111 IDE (rev 03)

-- ia64
   CPU: Itanium 2 Madison (2 cpus)
   SCSI: LSI Logic / Symbios Logic 53c1030 PCI-X Fusion-MPT Dual
Ultra320 SCSI
   IDE: Intel Corporation 82801DB (ICH4) IDE Controller

-- i386
   CPU: Intel(R) Xeon(TM) CPU 2.40GHz (2 cpus)
   IDE: Intel Corporation 82801EB/ER (ICH5/ICH5R) IDE Controller (rev
02)

- Test results for i386

--i8042 (IRQ 12) handled a spurious interrupt -> i8042
The culprit here was the i8042_aux_test_irq interrupt handler
unconditionally returning IRQ_HANDLED despite being marked as
IRQF_SHARED. I submitted a fix and it is currently sitting in the
'for-linus' branch of Dmitry Torokhov's input tree (Dmitry, Alan,
Vojtech, thank you for reviewing the patch!).

-- eth0 (IRQ 16) handled a spurious interrupt -> e1000
The problem here is that the network card is active before it has been
assigned an interrupt line. This means that if the card detects an event
such as a link status change it will update the status register (ICR) by
setting the corresponding flag, even if request_irq has not been invoked
yet. In such a case, once the interrupt handler is set if a spurious
interrupt comes in it will be handled. The reason is that the handler
checks ICR to determine whether the underlying the device has generated
an interrupt or not, and the flag that indicates a link status change
will happen to be set.

I have sent a patch that clears the ICR before requesting an IRQ, but
according to Auke Kok there is a small window during which the device
could generate another link status change interrupt. I am looking for a
way to prevent the device from reacting to such events before an IRQ has
been allocated, but still do not know if it is possible.

-- rtc (IRQ 8) handled a spurious interrupt
-- parport0 (IRQ 7) handled a spurious interrupt
-- MPU401 UART (IRQ 10) handled a spurious interrupt
I have not looked into these three yet but it seems that in some cases
it is not possible to determine whether an interrupt has actually
occurred.

- Test results for x86_64 [EM64T]

-- i8042 (IRQ 12) handled a spurious interrupt -> i8042
Ditto.
-- eth0 (IRQ 54) handled a spurious interrupt -> e1000
Ditto.
-- rtc (IRQ 8) handled a spurious interrupt
Ditto.

- Test results for x86_64 [Opteron]
-- i8042 (IRQ 12) handled a spurious interrupt -> i8042
Ditto.
-- rtc (IRQ 8) handled a spurious interrupt
Ditto.
-- parport0 (IRQ 7) handled a spurious interrupt
Ditto.

- Test results for ia64
-- eth0 (IRQ 48) handled a spurious interrupt -> e1000
Ditto.

Besides these patches have exposed bugs in other people's machines too.
Valdis Kletnieks discovered a problem in his tpm driver and it seems
that the TPM guys are already looking into it.

- Conclusion

These patches can affect device drivers in several ways and, so far, I
have identified 5 possible scenarios:

  1. Shared handlers that behave as expected and ignore spurious
interrupts.
  2. Shared handlers that unconditionally handle any incoming interrupt.
  3. Shared handlers that cannot distinguish between interrupts that it
needs to handle and interrupts generated by other devices in certain
situations.
  4. Non-shared handlers that behave as expected and ignore spurious
interrupts.
  5. Drivers for legacy devices in which it is not possible to determine
whether a given interrupt has actually come from the underlying device.

Obviously, 1) and 4) are the ideal cases and (probably) the majority of
the drivers fall into this group.

2) means that the driver cannot cohabit harmoniously with other drivers
and it would end up handling any interrupt coming in from that interrupt
line regardless of its origin. i8042 used to be belong to this group,
but the aforementioned patch should have solved it.

Most devices have a interrupt pending bit in some port or an interrupt
cause register (ICR) that can be checked by the driver to determine what
interrupts it needs to handle. The problem is that some devices are
operational before request_irq has been called and react to external
events by updating the interrupt pending bit or the ICR. This means that
after actually registering the interrupt handler, any interrupt coming
in would be handled. 3) refers to such cases. By the way, the e1000
driver seems to be suffering this issue which causes the error message
above.

When it comes to 5) there is not much we can do. Sometimes you simply
cannot tell.

The bottom line is that we have to decide how two tackle 2), 3) and 5).
My gut feeling is that in most cases 2) and 3) constitute a bug, because
if the driver is not fixable then IRQF_SHARED should not have been set
in the first place. Regarding 5), there is no choice, so it seems we
would need to mark such drivers somehow (another possible solution would
be calling the interrupt handler from request_irq only when IRQF_SHARED
is set, because shared handlers should not be affected by this problem).

If we find drivers that are not fixable we should probably consider this
new behaviour on a per-driver basis, as Andrew suggested. This would
probably require passing a new flag into request_irq. Besides, when such
a driver is detected we should emit a warning that it may not work
properly in a kdump kernel.

I would appreciate your comments on this.

- Fernando

