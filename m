Return-Path: <linux-kernel-owner+w=401wt.eu-S1753298AbYJBAml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298AbYJBAml (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 20:42:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751846AbYJBAmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 20:42:32 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:46281 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764AbYJBAmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 20:42:31 -0400
Message-ID: <48E418AE.1090306@codemonkey.ws>
Date: Wed, 01 Oct 2008 19:41:18 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Alok Kataria <akataria@vmware.com>,
       "avi@redhat.com" <avi@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Gerd Hoffmann <kraxel@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Nakajima, Jun" <jun.nakajima@intel.com>,
       Daniel Hecht <dhecht@vmware.com>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [RFC] CPUID usage for interaction between Hypervisors and	Linux.
References: <1222881242.9381.17.camel@alok-dev1> <48E3BBC1.2050607@goop.org>	 <1222894878.9381.63.camel@alok-dev1> <48E3E8DE.1080602@goop.org>	 <48E3ECD1.30809@codemonkey.ws> <1222904824.7330.83.camel@bodhitayantram.eng.vmware.com>
In-Reply-To: <1222904824.7330.83.camel@bodhitayantram.eng.vmware.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> On Wed, 2008-10-01 at 14:34 -0700, Anthony Liguori wrote:
>   
>> Jeremy Fitzhardinge wrote:
>>     
>>> Alok Kataria wrote:
>>>
>>> I guess, but the bulk of the uses of this stuff are going to be
>>> hypervisor-specific.  You're hard-pressed to come up with any other
>>> generic uses beyond tsc.
>>>       
>> And arguably, storing TSC frequency in CPUID is a terrible interface
>> because the TSC frequency can change any time a guest is entered.  It
>> really should be a shared memory area so that a guest doesn't have to
>> vmexit to read it (like it is with the Xen/KVM paravirt clock).
>>     
>
> It's not terrible, it's actually brilliant.

But of course!  Okay, not really :-)

>   TSC is part of the
> processor architecture, the processor should a way to tell us what speed
> it is.
>   

It does.  1 tick == 1 tick.  The processor doesn't have a concept of 
wall clock time so wall clock units don't make much sense.  If it did, 
I'd say, screw the TSC, just give me a ns granular time stamp and let's 
all forget that the TSC even exists.

> And now we're trying to fiddle around with software wizardry what should
> be done in hardware in the first place.  Once again, para-virtualization
> is basically useless.  We can't agree on a solution without
> over-designing some complex system with interface signatures and
> multi-vendor cooperation and nonsense.  Solve the non-virtualized
> problem and the virtualized problem goes away.
>
> Jun, you work at Intel.  Can you ask for a new architecturally defined
> MSR that returns the TSC frequency?  Not a virtualization specific MSR.
> A real MSR that would exist on physical processors.  The TSC started as
> an MSR anyway.  There should be another MSR that tells the frequency.
> If it's hard to do in hardware, it can be a write-once MSR that gets
> initialized by the BIOS.

rdtscp sort of gives you this.  But still, just give me my rdnsc and 
I'll be happy.

> I realize it's the wrong thing for us now, but long term, it's the only
> architecturally 'correct' approach.  You can even extend it to have
> visible TSC frequency changes clocked via performance counter events
> (and then get interrupts on those events if you so wish), solving the
> dynamic problem too.
>   

So a solution is needed that works for now.  Anything that requires a 
vmexit is bad because the TSC frequency can change quite often.  Even if 
you ignore the troubles with frequency scaling on older processors and 
VCPU migration across NUMA nodes, there will be a very visible change in 
TSC frequency after a live migration.

So there are two possible solutions.  Have a shared memory area that the 
guest can consult that has the latest TSC frequency (this is what KVM 
and Xen do) or have some sort of interrupt mechanism that notifies the 
guest when the TSC frequency changes after which, software can do 
something that vmexits to get the TSC frequency.

The proposed solution doesn't include a TSC frequency change 
notification mechanism.

This is part of the problem with this sort of approach to 
standardization.  It's hard to come up with the best interface at 
first.  You have to try a couple ways, and then everyone can eventually 
standardize on the best one if one ever emerges.

Regards,

Anthony Liguori

> Paravirtualization is a symptom of an architectural problem.  We should
> always be trying to fix the architecture first.
>
> Zach
>
>   

