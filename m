Return-Path: <linux-kernel-owner+w=401wt.eu-S934830AbXK3OkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934830AbXK3OkV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 09:40:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757772AbXK3OkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 09:40:08 -0500
Received: from ra.tuxdriver.com ([70.61.120.52]:4028 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754383AbXK3OkG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 09:40:06 -0500
Date: Fri, 30 Nov 2007 09:32:53 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Ben Woodard <woodard@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
       Neil Horman <nhorman@redhat.com>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>, hbabu@us.ibm.com,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] kexec: force x86_64 arches to boot kdump kernels on
	boot cpu
Message-ID: <20071130143253.GA29238@hmsreliant.think-freely.org>
References: <20071127194220.GG14887@hmsendeavour.rdu.redhat.com> <20071127200011.GA3703@redhat.com> <20071127222408.GH24223@one.firstfloor.org> <474CA733.9050908@redhat.com> <20071128153649.GC3192@redhat.com> <20071128160206.GA21286@hmsendeavour.rdu.redhat.com> <20071128190525.GD3192@redhat.com> <m1d4tudun5.fsf@ebiederm.dsl.xmission.com> <474F7290.8010504@redhat.com> <m1sl2oa1ev.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1sl2oa1ev.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2007 at 07:54:16PM -0700, Eric W. Biederman wrote:
> Ben Woodard <woodard@redhat.com> writes:
> 
> > Eric W. Biederman wrote:
> >> Vivek Goyal <vgoyal@redhat.com> writes:
> >>
> >>> Ok. Got it. So in this case we route the interrupts directly through LAPIC
> >>> and put LVT0 in ExtInt mode and IOAPIC is bypassed.
> >>>
> >>> I am looking at Intel Multiprocessor specification v1.4 and as per figure
> >>> 3-3 on page 3-9, 8259 is connected to LINTIN0 line, which in turn is
> >>> connected to LINTIN0 pin on all processors. If that is the case, even in
> >>> this mode, all the CPU should see the timer interrupts (which is coming
> >>> from 8259)?
> >>
> >> However things are implemented completely differently now.  I don't think
> >> the coherent hypertransport domain of AMD processors actually routes
> >> ExtINT interrupts to all cpus but instead one (the default route?) is
> >> picked.
> >>
> >> So I think for the kdump case we pretty much need to use an IOAPIC
> >> in virtual wire mode for recent AMD systems.
> >>
> >> For current Intel systems I believe either scenario still works.
> >>
> >>> Can you print the LAPIC registers (print_local_APIC) during normal boot
> >>> and during kdump boot and paste here?
> >>
> >> It's worth a look.
> >>
> >> I still think we need to just use apic mode at kernel startup, and
> >> be done with it.
> >>
> >
> > Neil whipped up a patch to try this and evidently it worked on his test boxes
> > but it didn't work very well on our problem tests box. It hung after the kernel
> > printed "Ready". i.e. on a normal boot I get:
> 
> Interesting can you please try an early_printk console.
> 
> 
> I expect you made it a fair ways and it just didn't show up because you didn't
> get as far as the normal serial port setup.
> 
> You don't have any output from your linux kernel.
> 

I've got a system here that now seems to be behaving in a way that is simmilar
to what Ben describes (although I'm not sure its the same problem).
early_printk shows that we're panic-ing inside check_timer, because we fail to
find any way to route the timer interrupt to the cpu.  Specifically, we're
hitting this panic:

panic("IO-APIC + timer doesn't work! Try using the 'noapic' kernel
parameter\n");

This doesn't make much sense to me, as we clearly have managed to get timer
interrupts at this point (since we made it through calibrate_delay)....

Looking at it, I wonder if this isn't a backporting issue.  Ben and I ran this
test on an older kernel (since thats what the production system under test is
based on).  Currently, check_timer is called directly from within setup_IO_APIC,
but in the 2.6.18 kernel that RHEL5 is based on its part of an initcall thats
run from within init near the call site of the origional io apic init code.  I
wonder if this isn't just an 'old kernel' issue, and that I need to move
check_timer to inside setup_IO_APIC.

Ben, is it possible for you to run an upstream kernel on one of these systems so
we can see if the patch works in that case?  In the interim, I'll update my
patch for 2.6.18 so that check_timer gets moved earlier

Neil


> Eric
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
