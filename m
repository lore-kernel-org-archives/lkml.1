Return-Path: <linux-kernel-owner+w=401wt.eu-S1760260AbXK0Xme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760260AbXK0Xme (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 18:42:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758749AbXK0XmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 18:42:25 -0500
Received: from mx1.redhat.com ([66.187.233.31]:55781 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752648AbXK0XmY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 18:42:24 -0500
Date: Tue, 27 Nov 2007 18:40:37 -0500
From: Neil Horman <nhorman@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Neil Horman <nhorman@redhat.com>, Ben Woodard <woodard@redhat.com>,
       Neil Horman <nhorman@tuxdriver.com>, kexec@lists.infradead.org,
       Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org, hbabu@us.ibm.com,
       vgoyal@in.ibm.com
Subject: Re: [PATCH] kexec: force x86_64 arches to boot kdump kernels on boot cpu
Message-ID: <20071127234037.GA16756@hmsendeavour.rdu.redhat.com>
References: <20071127014740.GA28622@hmsreliant.think-freely.org> <200711271445.56792.ak@suse.de> <20071127142826.GB31376@hmsreliant.think-freely.org> <200711271543.11809.ak@suse.de> <20071127144856.GC31376@hmsreliant.think-freely.org> <m14pf7k8ns.fsf@ebiederm.dsl.xmission.com> <474C832C.1060903@redhat.com> <20071127210558.GI14887@hmsendeavour.rdu.redhat.com> <m1r6ibia9v.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1r6ibia9v.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2007 at 03:38:52PM -0700, Eric W. Biederman wrote:
> Neil Horman <nhorman@redhat.com> writes:
> 
> >> 
> >> ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
> 
> Ben, what chipset is this?
> 
> >
> > Ok, I think from what I understand of what we're reading here, the apic2 = -1
> > and pin2 = -1 indicate that the 8259 has no direct connection to any cpu, which
> > means that on shutdown disable_IO_APIC should take us into virtual wire mode.
> > As such enabling the APIC early in boot should fix us, but more consisely,
> > rewriting the entry in the IOAPIC to deliver int0 to the only running cpu should
> > accomplish the same goal for this problem.  Does that sound reasonable (at least
> > as a test to ensure we understand the problem) to everyone?
> 
> Close.  There are two options with virtual wire mode.  
> - Either the local apic is in virtual wire mode, and somehow the
>   legacy interrupts make it to the local cpu.
I assume this is the case if the ioapic is also in virtual wire mode and the
destination field for the appropriate interrupt(s) (the timer interrupt in this
case) is set to either physical mode with a destination id of the lapic for the
running cpu, or if it is set to logical mode and the destination id has the
corresponding bit for the running cpu set.  Is that right?

> - Or an ioapic is in virtual wire mode and the legacy interrupt
>   controller is connected to it.
> 
I thought we only had one ioapic in this system (Ben correct me if I'm wrong on
that please).  I thought the above printk told us that, because apic2 and pin2
are both -1, that means that the 8259 isn't physically connected to any cpu, and
instead is routed through apic 0, and asserts on pin 2 of that ioapic. 

> So I guess fundamentally for any SMP system that only supports the
> cpu being in local apic mode and only routes interrupts to the boot
> strap processor we could be in trouble.  That is what our current
> information about your system suggests.
> 
If that were the case, then we would need to support moving kexec boot to cpu0,
at least in some limited cases.  I've got a patch together that enables the
handshaking I was brainstorming earlier, which should allow an attempted jump to
cpu0 on a crash, with a fallback to booting on the crashing processor.  If we
wind up confirming the above case, then I'll post it.

> However most systems actually connect the i8254 PIC interrupt
Sorry, to split hairs here, but you mean the 8259 right?  Just want to be sure
I'm clear on whats going on.  I thought the 8254 was the external timer.

> controller to the ioapic in virtual wire mode.  As I recall the
> standard mapping is to ioapic 0, pin 0.  With ioapic 0, pin 2 being
> the timer interrupt (Possibly it is the other way around).
> 
> So as a test we could feed those values into ioapic_8259 and see
> if the kdump case works.  I believe we prefer putting the ioapic
> into virtual wire mode over putting the cpu into virtual wire
> mode.  We can only control which cpu receives the legacy interrupts if
> we are putting the ioapic in virtual wire mode.
> 
I'm sorry, I can't find ioapic_8259 defined anywhere.  Where is that supposed to
be?  Show me where its defined and I'll happily write the patch.


> It may also be an interesting test to just enable the timer for the
> ioapic in early boot, as you have suggested.  I don't have a clue what
> that will do.
> 
Unfortunately nothing.  We've tried using the local apic timer in a previous
test, and it resulted in no change, as did transitioning the cpu to the apic
timer via a call to switch_ipi_to_APIC_timer.  Its possible I did something
wrong however.

Currently I'm writing a patch that calls setup_ioapic_dest after we call
disable_IO_APIC.  Looking at the implementation, it appears that calling this
function should rewrite the irq routing table in the ioapic to deliver
interrupts to the set of online cpus, as defined by the TARGET_CPUS macro.  I
asusme that if the ioapic is in virtual wire mode from the call to
disablie_IO_APIC, then calling setup_ioapic_dest will force interrupts to be
delivered to the crashing cpu, as it should be the only bit set in the online
cpu mask.  Please feel free to poke holes in this idea.


Thanks & Regards
Neil

> Eric

-- 
/***************************************************
 *Neil Horman
 *Software Engineer
 *Red Hat, Inc.
 *nhorman@redhat.com
 *gpg keyid: 1024D / 0x92A74FA1
 *http://pgp.mit.edu
 ***************************************************/
