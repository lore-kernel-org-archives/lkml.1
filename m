Return-Path: <linux-kernel-owner+w=401wt.eu-S932247AbXBWKw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932247AbXBWKw3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 05:52:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932249AbXBWKw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 05:52:29 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:37713 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932247AbXBWKw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 05:52:28 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: linux-kernel@vger.kernel.org
Cc: Zwane Mwaikambo <zwane@infradead.org>, Ashok Raj <ashok.raj@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@osdl.org>,
       "Lu, Yinghai" <yinghai.lu@amd.com>,
       Natalie Protasevich <protasnb@gmail.com>, Andi Kleen <ak@suse.de>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Conclusions from my investigation about ioapic programming
References: <200701221116.13154.luigi.genoni@pirelli.com>
	<200702021848.55921.luigi.genoni@pirelli.com>
	<m1ejp85tgm.fsf@ebiederm.dsl.xmission.com>
	<200702021905.39922.luigi.genoni@pirelli.com>
	<m1zm7w3wvr.fsf_-_@ebiederm.dsl.xmission.com>
	<m1veik3woc.fsf_-_@ebiederm.dsl.xmission.com>
	<20070206073616.GA15016@elte.hu>
	<m1odo7q6cq.fsf@ebiederm.dsl.xmission.com>
	<20070206222523.GA11602@elte.hu>
	<m1irecamzh.fsf@ebiederm.dsl.xmission.com>
	<m1wt2s8ksa.fsf@ebiederm.dsl.xmission.com>
	<m1veib6dgi.fsf@ebiederm.dsl.xmission.com>
	<m1hctt1sfp.fsf_-_@ebiederm.dsl.xmission.com>
	<Pine.LNX.4.64.0702102146380.8245@montezuma.fsmlabs.com>
	<m13b5d0zdp.fsf@ebiederm.dsl.xmission.com>
	<Pine.LNX.4.64.0702110753390.8245@montezuma.fsmlabs.com>
	<m17iuoz74f.fsf@ebiederm.dsl.xmission.com>
	<Pine.LNX.4.64.0702111416220.24829@montezuma.fsmlabs.com>
	<m1r6swx9l2.fsf@ebiederm.dsl.xmission.com>
Date: Fri, 23 Feb 2007 03:51:04 -0700
In-Reply-To: <m1r6swx9l2.fsf@ebiederm.dsl.xmission.com> (Eric W. Biederman's
	message of "Sun, 11 Feb 2007 21:51:05 -0700")
Message-ID: <m1irdtw3jb.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Ok. This is just an email to summarize my findings after investigating
the ioapic programming.

The ioapics on the E75xx chipset do have issues if you attempt to
reprogramming them outside of the irq handler.  I have on several
instances caused the state machine to get stuck such that an
individual ioapic entry was no longer capable of delivering
interrupts.  I suspect the remote IRR bit was set stuck on such that
switch the irq to edge triggered and back to level triggered would not
clear it but I did not confirm this.  I just know that I was switching
the irq to between level and edge triggered with the irq masked
and the irq did not fire.


The ioapics on the AMD 8xxx chipset do have issues if you attempt
to reprogram them outside of the irq handler.  I would up with 
remote IRR set and never clearing.  But by temporarily switching
the irq to edge triggered while it was masked I could clear
this condition.

I could not hit verifiable bugs in the ioapics on the Nforce4
chipset.  It's amazing one part of that chipset that I can't find
issues with.



I did find an algorithm that will work successfully for migrating
IRQs in process context if you have an ioapic that will follow pci
ordering rules.  In particulars the properties that the algorithm
depend on are reads guaranteeing that outstanding writes are flushed,
and in this context irqs in flight are considered writes.  I have
assumed that to devices outside of the cpu asic the cpu and the local
apic appear as the same device.

The algorithm was:
- Be running with interrupts enabled in process context.
- Mask the ioapic.
- Read the ioapic to flush outstanding reads to the local apic.
- Read the local apic to flush outstanding irqs to be send the cpu.

- Now that all of the irqs have been delivered and the irq is masked
  that irq is finally quiescent.

- With the irq quiescent it is safe to reprogram interrupt controller
  and the irq reception data structures.

There were a lot more details but that was the essence.

What I discovered was that except on the nforce chipset masking the
ioapic and then issue a read did not behave as if the interrupts were
flushed to the local apic. 

I did not look close enough to tell if local apics suffered from this
issue.  With local apics at least a read was necessary before you
could guarantee the local apic would deliver pending irqs.  A work
around on the local apics is to simply issue a low priority interrupt
as an IPI and wait for it to be processed.  This guarantees that all
higher priority interrupts have been flushed from the apic, and that
the local apic has processed interrupts.

For ioapics because they cannot be stimulated to send any irq by
stimulation from the cpu side not similar work around was possible.



** Conclusions.

*IRQs must be reprogramed in interrupt context.

The result of this is investigation is that I am convinced we need
to perform the irq migration activities in interrupt context although
I am not convinced it is completely safe.  I suspect multiple irqs
firing closely enough to each other may hit the same issues as
migrating irqs from process context.  However the odds are on our
side, when we are in irq context.

The reasoning for this is simply that.
- Before we reprogram a level triggered irq it's remote irr bit
  must be cleared by the irq being acknowledged before the can be
  safely reprogrammed.

- There is no generally effective way short of receiving an additional
  irq to ensure that the irq handler has run.  Polling the ioapics
  remote irr bit does not work.


* The CPU hotplug is currently very buggy.

Irq migration in the cpu hotplug case is a serious problem.  If we can
only safely migrate irqs from interrupt context and we cannot control
when those interrupts fire, then we cannot bound the amount of time it
will take to migrate the irqs away from a cpu.   The current cpu
hotplug code currently calls chip->set_affinity directly which is
wrong, as it does not take the necessary locks, and it does not
attempt to delay execution until we are in process context.

* Only an additional irq can signal the completion of an irq movement.

The attempt to rebuild the irq migration code from first principles
did bear some fruit.  I asked the question: "When is it safe to tear
down the data structures for irq movement?".  The only answer I have
is when I have received an irq provably from after the irq was
reprogrammed.  This is because the only way I can reliably synchronize
with irq delivery from an apic is to receive an additional irq.

Currently this is a problem both for cpu hotplug on x86_64 and i386
and for general irq migration on x86_64.

Patches to follow shortly.

Eric
