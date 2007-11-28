Return-Path: <linux-kernel-owner+w=401wt.eu-S1755520AbXK1SUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520AbXK1SUa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 13:20:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751381AbXK1SUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 13:20:20 -0500
Received: from mx1.redhat.com ([66.187.233.31]:58652 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750850AbXK1SUS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 13:20:18 -0500
Date: Wed, 28 Nov 2007 13:16:53 -0500
From: Neil Horman <nhorman@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Neil Horman <nhorman@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
       Ben Woodard <woodard@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>, hbabu@us.ibm.com
Subject: Re: [PATCH] kexec: force x86_64 arches to boot kdump kernels on boot cpu
Message-ID: <20071128181653.GB21286@hmsendeavour.rdu.redhat.com>
References: <200711271445.56792.ak@suse.de> <m1lk8jka8j.fsf@ebiederm.dsl.xmission.com> <474C64CB.7080004@redhat.com> <20071127194220.GG14887@hmsendeavour.rdu.redhat.com> <20071127200011.GA3703@redhat.com> <20071127222408.GH24223@one.firstfloor.org> <474CA733.9050908@redhat.com> <20071128153649.GC3192@redhat.com> <20071128160206.GA21286@hmsendeavour.rdu.redhat.com> <m1ir3me0hf.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1ir3me0hf.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2007 at 10:36:12AM -0700, Eric W. Biederman wrote:
> Neil Horman <nhorman@redhat.com> writes:
> 
> > On Wed, Nov 28, 2007 at 10:36:49AM -0500, Vivek Goyal wrote:
> >> On Tue, Nov 27, 2007 at 03:24:35PM -0800, Ben Woodard wrote:
> >> > Andi Kleen wrote:
> >> >>> Are we putting the system back in PIC mode or virtual wire mode? I have
> >> >>> not seen systems which support PIC mode. All latest systems seems
> >> >>> to be having virtual wire mode. I think in case of PIC mode, interrupts
> >> >>
> >> >> Yes it's probably virtual wire. For real PIC mode we would need really
> >> >> old systems without APIC.
> >> >>
> >> >>> can be delivered to cpu0 only. In virt wire mode, one can program IOAPIC
> >> >>> to deliver interrupt to any of the cpus and that's what we have been
> >> >>
> >> >> The code doesn't try to program anything specific, it just restores the
> > state
> >> >> that was left over originally by the BIOS.
> >> >>
> >> >
> >> > So if the BIOS originally left the IOAPIC in a state where the timer 
> >> > interrupts were only going to CPU0 then by restoring that state we could be
> >> > bringing this problem upon ourselves when we restore that state.
> >> >
> >> 
> >> Hi Ben,
> >> 
> >> Apart from restoring the original state (Bring APICS back to virtual wire
> >> mode), we also reprogram IOAPIC so that timer interrupt can go to crashing
> >> cpu (and not necessarily cpu0). Look at following code in disable_IO_APIC.
> >> 
> >>                 entry.dest.physical.physical_dest =
> >>                                         GET_APIC_ID(apic_read(APIC_ID));
> >> 
> >> Here we read the apic id of crashing cpu and program IOAPIC accordingly.
> >> This will make sure that even in virtual wire mode, timer interrupts
> >> will be delivered to crashing cpu APIC.
> >> 
> > Yes, but according to Bens last debug effort, the APIC printout regarding the
> > timer setup, indicates that ioapic_i8259.pin == -1, meaning that the 8259 is not
> > routed through the ioapic.  In those cases, disable_IO_APIC does not take us
> > through the path you reference above, and does not revert to virtual wire mode.
> > Instead, it simply disables legacy vector 0, which if I understand this
> > correctly, simply tells the ioapic to not handle timer interrupts, trusting that
> > the 8259 in the system will deliver that interrupt where it needs to be.  If the
> > 8259 is wired to deliver timer interrupts to cpu0 only, then you get the problem
> > that we have, do you?
> 
> Exactly.
> 
> It is still interesting to test to see what happens if you plugin the
> normal values into ioapic_i8259 for .pin and .apic (.pin is 0 or 2 and .apic is 0)
> and see what happens.
> 
> Having a command line parameter that could do that would be a cheap temporary
> solution.
> 
> But this is the most likely reason why the timer interrupt is not working.
> 

Ok, thank you for the explination, this all makes a good deal more sense to me
now.  Ben is near the machine, so hopefully we'll hear from him soon with the
results of this test.

Given that, do you think the cpu-switch test that I proposed would be a good
solution now (with the fallback mechanism I described), or would a command line
8259 solution be better?  I tend to think the former would be better since it
would be transparent to the user, but I'd like to have that debate.

Regards
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
