Return-Path: <linux-kernel-owner+w=401wt.eu-S1753313AbXK0WnN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313AbXK0WnN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 17:43:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759905AbXK0Wm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 17:42:57 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:36947 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759766AbXK0Wm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 17:42:56 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Neil Horman <nhorman@redhat.com>
Cc: Ben Woodard <woodard@redhat.com>, Neil Horman <nhorman@tuxdriver.com>,
       kexec@lists.infradead.org, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, hbabu@us.ibm.com, vgoyal@in.ibm.com
Subject: Re: [PATCH] kexec: force x86_64 arches to boot kdump kernels on boot cpu
References: <20071127014740.GA28622@hmsreliant.think-freely.org>
	<200711271445.56792.ak@suse.de>
	<20071127142826.GB31376@hmsreliant.think-freely.org>
	<200711271543.11809.ak@suse.de>
	<20071127144856.GC31376@hmsreliant.think-freely.org>
	<m14pf7k8ns.fsf@ebiederm.dsl.xmission.com>
	<474C832C.1060903@redhat.com>
	<20071127210558.GI14887@hmsendeavour.rdu.redhat.com>
Date: Tue, 27 Nov 2007 15:38:52 -0700
In-Reply-To: <20071127210558.GI14887@hmsendeavour.rdu.redhat.com> (Neil
	Horman's message of "Tue, 27 Nov 2007 16:05:58 -0500")
Message-ID: <m1r6ibia9v.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Horman <nhorman@redhat.com> writes:

>> 
>> ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1

Ben, what chipset is this?

>
> Ok, I think from what I understand of what we're reading here, the apic2 = -1
> and pin2 = -1 indicate that the 8259 has no direct connection to any cpu, which
> means that on shutdown disable_IO_APIC should take us into virtual wire mode.
> As such enabling the APIC early in boot should fix us, but more consisely,
> rewriting the entry in the IOAPIC to deliver int0 to the only running cpu should
> accomplish the same goal for this problem.  Does that sound reasonable (at least
> as a test to ensure we understand the problem) to everyone?

Close.  There are two options with virtual wire mode.  
- Either the local apic is in virtual wire mode, and somehow the
  legacy interrupts make it to the local cpu.
- Or an ioapic is in virtual wire mode and the legacy interrupt
  controller is connected to it.

So I guess fundamentally for any SMP system that only supports the
cpu being in local apic mode and only routes interrupts to the boot
strap processor we could be in trouble.  That is what our current
information about your system suggests.

However most systems actually connect the i8254 PIC interrupt
controller to the ioapic in virtual wire mode.  As I recall the
standard mapping is to ioapic 0, pin 0.  With ioapic 0, pin 2 being
the timer interrupt (Possibly it is the other way around).

So as a test we could feed those values into ioapic_8259 and see
if the kdump case works.  I believe we prefer putting the ioapic
into virtual wire mode over putting the cpu into virtual wire
mode.  We can only control which cpu receives the legacy interrupts if
we are putting the ioapic in virtual wire mode.

It may also be an interesting test to just enable the timer for the
ioapic in early boot, as you have suggested.  I don't have a clue what
that will do.

Eric
