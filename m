Return-Path: <linux-kernel-owner+w=401wt.eu-S1757603AbXK0TsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757603AbXK0TsX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 14:48:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752659AbXK0TsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 14:48:15 -0500
Received: from mx1.redhat.com ([66.187.233.31]:47984 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752478AbXK0TsO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 14:48:14 -0500
Date: Tue, 27 Nov 2007 14:42:20 -0500
From: Neil Horman <nhorman@redhat.com>
To: Ben Woodard <woodard@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Andi Kleen <ak@suse.de>,
       Neil Horman <nhorman@redhat.com>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, hbabu@us.ibm.com, vgoyal@in.ibm.com
Subject: Re: [PATCH] kexec: force x86_64 arches to boot kdump kernels on boot cpu
Message-ID: <20071127194220.GG14887@hmsendeavour.rdu.redhat.com>
References: <20071127014740.GA28622@hmsreliant.think-freely.org> <20071127131355.GA14887@hmsendeavour.rdu.redhat.com> <m1y7cjkec2.fsf@ebiederm.dsl.xmission.com> <200711271445.56792.ak@suse.de> <m1lk8jka8j.fsf@ebiederm.dsl.xmission.com> <474C64CB.7080004@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <474C64CB.7080004@redhat.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2007 at 10:41:15AM -0800, Ben Woodard wrote:
> >>But if CPU #0 has interrupts disabled no interrupts get delivered.
> >>
> >>So choices are:
> >>- Move to CPU #0
> >>- Do not use legacy mode during shutdown.
> >    (Do not use legacy mode in the kdump kernel. removing it from shutdown
> >     is just minor optimization)
> >>- Or do not rely on interrupts after enabling legacy mode
> >>- Or do not disable interrupts on the other CPUs when they're
> >>halted.
> >>
> >>First and last option are probably unreliable for the kdump case.
> >>Second or third sound best. 
> >>
> 
> I can agree with the fourth option being a very bad one but I really 
> haven't seen anything in this discussion which supports the assertion 
> that "Move to the CPU that the BIOS originally called CPU#0" is going to 
> be unreliable. Admittedly we haven't tried this on every single x86_64 
> platform that we have but on the handful that we have tried so far, it 
> hasn't been a problem. Why is everybody jumping to the assumption that 
> it will be less reliable?
> 

Ben I tend to agree.  I think re-enabling the APIC early in the boot process
provides a greater degree of reliability in that it more quickly restores the
system to a state where booting on a cpu other than cpu0 will be more likely to
work, but I have to say that overall it seems like booting a secondary kernel on
cpu0, when possible offers the highest degree of reliability.

Perhaps what we need is a 'both solution'.  Re-enabling the apic to full smp
functionality early in the boot process is a good solution for the problems
which we are hypothesizing here, and would be a good thing to do in general, but
it doesn't preclude also attmpting to switch back to cpu0 during a crash.

Perhaps it would be worthwhile to:

1) Investigate the early enablement of the ioapic for x86[_64]
2) implement my prevoiusly proposed patch with the addition of a handshake
element, such that:
	a) when the boot cpu gets the ipi from machine_crash_shutdown it flags
	   the fact that it is going to boot the kexec kernel with a global
	   variable
	b) the crashing cpu loops waiting for either:
		I) a timeout of 1 second
		II) a reduction of the halt count to zero
		III) the setting of the flag mentioned in (a)
	c) the crashing cpu, if it sees that it is not the boot cpu AND
	   that the flag in (III) is set, will halt itself, otherwise it
	   will set the flag and boot the kexec image itself.

With this modification, we can try to relocate to cpu0,  and if we fail, we fall
back to booting on the crashing processor.

I'll work up a patch that implements (2), unless there are strong objections.  I
see no reason why we can't implment this 'both' solution.

Regards
Neil

-- 
/***************************************************
 *Neil Horman
 *Software Engineer
 *Red Hat, Inc.
 *nhorman@redhat.com
 *gpg keyid: 1024D / 0x92A74FA1
 *http://pgp.mit.edu
 ***************************************************/
