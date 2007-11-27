Return-Path: <linux-kernel-owner+w=401wt.eu-S1758092AbXK0UBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758092AbXK0UBb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 15:01:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754376AbXK0UBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 15:01:23 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35854 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754301AbXK0UBX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 15:01:23 -0500
Date: Tue, 27 Nov 2007 15:00:11 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Neil Horman <nhorman@redhat.com>
Cc: Ben Woodard <woodard@redhat.com>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>, hbabu@us.ibm.com,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] kexec: force x86_64 arches to boot kdump kernels on
	boot cpu
Message-ID: <20071127200011.GA3703@redhat.com>
References: <20071127014740.GA28622@hmsreliant.think-freely.org> <20071127131355.GA14887@hmsendeavour.rdu.redhat.com> <m1y7cjkec2.fsf@ebiederm.dsl.xmission.com> <200711271445.56792.ak@suse.de> <m1lk8jka8j.fsf@ebiederm.dsl.xmission.com> <474C64CB.7080004@redhat.com> <20071127194220.GG14887@hmsendeavour.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071127194220.GG14887@hmsendeavour.rdu.redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2007 at 02:42:20PM -0500, Neil Horman wrote:

[..]
> 
> Ben I tend to agree.  I think re-enabling the APIC early in the boot process
> provides a greater degree of reliability in that it more quickly restores the
> system to a state where booting on a cpu other than cpu0 will be more likely to
> work, but I have to say that overall it seems like booting a secondary kernel on
> cpu0, when possible offers the highest degree of reliability.
> 
> Perhaps what we need is a 'both solution'.  Re-enabling the apic to full smp
> functionality early in the boot process is a good solution for the problems
> which we are hypothesizing here, and would be a good thing to do in general, but
> it doesn't preclude also attmpting to switch back to cpu0 during a crash.
> 
> Perhaps it would be worthwhile to:
> 
> 1) Investigate the early enablement of the ioapic for x86[_64]
> 2) implement my prevoiusly proposed patch with the addition of a handshake
> element, such that:
> 	a) when the boot cpu gets the ipi from machine_crash_shutdown it flags
> 	   the fact that it is going to boot the kexec kernel with a global
> 	   variable
> 	b) the crashing cpu loops waiting for either:
> 		I) a timeout of 1 second
> 		II) a reduction of the halt count to zero
> 		III) the setting of the flag mentioned in (a)
> 	c) the crashing cpu, if it sees that it is not the boot cpu AND
> 	   that the flag in (III) is set, will halt itself, otherwise it
> 	   will set the flag and boot the kexec image itself.
> 
> With this modification, we can try to relocate to cpu0,  and if we fail, we fall
> back to booting on the crashing processor.
> 
> I'll work up a patch that implements (2), unless there are strong objections.  I
> see no reason why we can't implment this 'both' solution.
> 

Hi Neil,

If we implement first solution, we don't have to implement second. Problem
will automatically be solved.

In general adding more code in crash shutdown path is not good. We are
trying to make that code path as small as possible.

OTOH, I think we have not root caused this problem yet. We don't know yet
why interrupts are not coming to non-boot cpu. I think we can go little
deeper to compare the system state in normal boot and kdump boot and see
what has changed. System state would include, LAPIC and IOAPIC entries
etc.

Are we putting the system back in PIC mode or virtual wire mode? I have
not seen systems which support PIC mode. All latest systems seems
to be having virtual wire mode. I think in case of PIC mode, interrupts
can be delivered to cpu0 only. In virt wire mode, one can program IOAPIC
to deliver interrupt to any of the cpus and that's what we have been
relying on  until and unless there is something board specific.

Thanks
Vivek
