Return-Path: <linux-kernel-owner+w=401wt.eu-S1753153AbXCZVAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153AbXCZVAa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 17:00:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753164AbXCZVAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 17:00:30 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51824 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753153AbXCZVA2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 17:00:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [3/5] 2.6.21-rc4: known regressions (v2)
Date: Mon, 26 Mar 2007 23:03:26 +0200
User-Agent: KMail/1.9.5
Cc: Thomas Meyer <thomas@m3y3r.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pci@atrey.karlin.mff.cuni.cz, Greg Kroah-Hartman <gregkh@suse.de>,
       Tony Luck <tony.luck@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <200703252114.16436.rjw@sisk.pl> <m1ps6x2h5z.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1ps6x2h5z.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703262303.27342.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 25 March 2007 22:37, Eric W. Biederman wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
> > On Sunday, 25 March 2007 14:56, Eric W. Biederman wrote:
> >> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> >> 
> >> > Yes, in kernel/power/disk.c:power_down() .
> >> >
> >> > Please comment out the disable_nonboot_cpus() in there and retest (but
> > please
> >> > test the latest Linus' tree).
> >> 
> >> <rant>
> >> 
> >> Why do we even need a disable_nonboot_cpus in that path?  machine_shutdown
> >> on i386 and x86_64 should take care of that.  Further the code that computes
> >> the boot cpu is bogus (not all architectures require cpu == 0 to be
> >> the boot cpu), and disabling non boot cpus appears to be a strong
> >> x86ism, in the first place.
> >
> > Yes.
> >  
> >> If the only reason for disable_nonboot_cpus there is to avoid the
> >> WARN_ON in init_low_mappings() we should seriously consider killing
> >> it.
> >
> > We have considered it, but no one was sure that it was a good idea.
> 
> The problem with the current init_low_mappings is that it hacks the
> current page table.  If we can instead use a different page table
> the code becomes SMP safe.

What exactly is the danger here?

> I have extracted the patch that addresses this from the relocatable
> patchset and appended it for sparking ideas.  It goes a little
> farther than we need to solve this issue but the basics are there.
> 
> >> If we can wait for 2.6.22 the relocatable x86_64 patchset that 
> >> Andi has queued, has changes that kill the init_low_mapping() hack.
> >
> > I think we should kill the WARN_ON() right now, perhaps replacing it with
> > a FIXME comment.
> 
> Reasonable.
> 
> >> I'm not very comfortable with calling cpu_down in a common code path
> >> right now either.  I'm fairly certain we still don't have that
> >> correct.  So if we confine the mess that is cpu_down to #if
> >> defined(CPU_HOTPLUG) && defined(CONFIG_EXPERIMENTAL) I don't care.
> >> If we start using it everywhere I'm very nervous.
> >> migration when bringing a cpu down is strongly racy, and I don't think
> >> we actually put cpus to sleep properly either.
> >
> > I'm interested in all of the details, please.  I seriously consider dropping
> > cpu_up()/cpu_down() from the suspend code paths.
> 
> So I'm not certain if in a multiple cpu context we can avoid all of the
> issues with cpu hotplug but there is a reasonable chance so I will
> explain as best I can.
> 
> Yanking the appropriate code out of linuxbios the way a processor should stop
> itself is to send an INIT IPI to itself.  This puts a cpu into an optimized
> wait for startup IPI state where it is otherwise disabled.  This is the state
> any sane BIOS will put the cpus into before control is handed off to the kernel.
> 
> > static inline void stop_this_cpu(void)
> > {
> >         unsigned apicid;
> >         apicid = lapicid();
> > 
> >         /* Send an APIC INIT to myself */
> >         lapic_write(LAPIC_ICR2, SET_LAPIC_DEST_FIELD(apicid));
> >         lapic_write(LAPIC_ICR, LAPIC_INT_LEVELTRIG | LAPIC_INT_ASSERT | LAPIC_DM_INIT);
> >         /* Wait for the ipi send to finish */
> >         lapic_wait_icr_idle();
> > 
> >         /* Deassert the APIC INIT */
> >         lapic_write(LAPIC_ICR2, SET_LAPIC_DEST_FIELD(apicid));
> >         lapic_write(LAPIC_ICR,  LAPIC_INT_LEVELTRIG | LAPIC_DM_INIT);
> >         /* Wait for the ipi send to finish */
> >         lapic_wait_icr_idle();
> > 
> >         /* If I haven't halted spin forever */
> >         for(;;) {
> >                 hlt();
> >         }
> > }
> 
> I'm not certain what to do with the interrupt races.  But I will see
> if I can explain what I know.
> 
> <braindump>
> 
> - Most ioapics are buggy.
> - Most ioapics do not follow pci-ordering rules with respect to
>   interrupt message deliver so ensuring all in-flight irqs have
>   arrived somewhere is very hard.
> - To avoid bugs we always limit ourselves to reprogramming the ioapics
>   in the interrupt handler, and not considering an interrupt
>   successfully reprogrammed until we have received an irq in the new
>   location.
> - On x86 we have two basic interrupt handling modes.
>   o logical addressing with lowest priority delivery.
>   o physical addressing with delivery to a single cpu.
> - With logical addressing as long as the cpu is not available for
>   having an interrupt delivered to it the interrupt will be
>   never be delivered to a particular cpu.  Ideally we also update
>   the mask in the ioapic to not target that cpu.
> - With physical addressing targeting a single cpu we need to reprogram
>   the ioapics not to target that specific cpu.  This needs to happen
>   in the interrupt handler and we need to wait for the next interrupt
>   before we tear down our data structures for handling the interrupt.
> 
>   The current cpu hotplug code attempts to reprogram the ioapics from
>   process context which is just wrong.

I wasn't aware of that.

> Now as part of suspend/resume I think we should be programming the
> hardware not to generate interrupts in the first place at the actual
> hardware devices so we can likely avoid all of the code that
> reprograms interrupts while they are active.

The devices are expected (and in fact required) not to generate interrupts
and not to do any DMA transfers after they have been frozen.

> If we can use things like pci ordering rules to ensure the device will
> never fire the interrupt until resumed we should be able to disable interrupts
> synchronously.  Something that we can not safely do in the current
> cpu hotplug scenario.  Which should make the problem of doing the
> work race free much easier.

I think this is doable.

> I don't know if other architectures need to disable cpus or not before
> doing a suspend to ram or a suspend to disk.

In the suspend to disk context we must ensure that the other CPUs won't
modify memory in any way while the image is being created, so I think we
should at least make them loop in a safe place and refuse to take any
interrupts.

> I also don't know if we have any code that brings up the other cpus
> after we have been suspended.  In either the cpu hotplug paths or the
> architecture specific paths.

I'm not sure what you mean.

Anyway, currently cpu_up() is used to enable the other CPUs when we have
finished with the image (as well as during the resume).
 
> The bottom line is after the partial review of the irq handling during
> cpu shutdown a little while ago that I consider the current cpu
> hotplug code to be something that works when you are lucky.  There are
> to many hardware bugs to support the general case it tries to
> implement.

Well, we've been using it for suspending SMP boxes for quite some time now
and there haven't been any major low-level problems.  The current problems are
related to the fact that the CPU hotplug calls lots of notifiers that need not
run during the suspend or resume (or in power_down() for that matter).

> I have not reviewed the entire cpu hotplug path nor have I even tried
> suspend/resume.  But I have been all and down the boot and shutdown
> code paths so I understand the general problem.
> 
> The other part I know is that cpu numbers are assigned at the
> architectures discretion.  So unless the architecture code or the
> early boot code sets a variable remembering which was the boot cpu
> there is no reason to believe we can deduce it.

I'm not sure if we have to.  On x86_* we cannot turn the 1st CPU off anyway.

> In addition I don't know if any other architectures have anything resembling
> the x86 requirement to disable non-boot cpus.  I do know machine_shutdown
> on i386 and x86_64 performs that action (if not perfectly) so at
> least currently we should be able to do this in architecture
> specific code.
> 
> </braindump>

Thanks a lot for the info.

The patch looks a bit too complicated for a quick fix.  I think we'll need to
remove that WARN_ON() in 2.6.21 after all.

Greetings,
Rafael
