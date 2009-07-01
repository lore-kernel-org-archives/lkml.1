Return-Path: <linux-kernel-owner+w=401wt.eu-S1754698AbZGANbd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698AbZGANbd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 09:31:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751988AbZGANbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 09:31:24 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:55667 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657AbZGANbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 09:31:22 -0400
To: Avi Kivity <avi@redhat.com>
Cc: Gleb Natapov <gleb@redhat.com>,
       "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Sheng Yang <sheng@linux.intel.com>,
       "kvm\@vger.kernel.org" <kvm@vger.kernel.org>
References: <20090629132926.GB20289@redhat.com>
	<m1ocs6axca.fsf@fess.ebiederm.org> <20090630092623.GI20289@redhat.com>
	<m1eit1acxl.fsf@fess.ebiederm.org> <4A4A476C.2070305@redhat.com>
	<m1ljn94k16.fsf@fess.ebiederm.org> <4A4A6499.9000406@redhat.com>
	<m1k52t1plq.fsf@fess.ebiederm.org> <4A4B1E95.1030702@redhat.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 01 Jul 2009 06:31:20 -0700
In-Reply-To: <4A4B1E95.1030702@redhat.com> (Avi Kivity's message of "Wed\, 01 Jul 2009 11\:30\:13 +0300")
Message-ID: <m14otwv8bb.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: avi@redhat.com, kvm@vger.kernel.org, sheng@linux.intel.com, suresh.b.siddha@intel.com, linux-kernel@vger.kernel.org, gleb@redhat.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Avi Kivity <avi@redhat.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0001]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH v3] enable x2APIC without interrupt remapping under KVM
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity <avi@redhat.com> writes:

> On 06/30/2009 10:36 PM, Eric W. Biederman wrote:
>>>> The short version is I don't know what work arounds we will ultimately
>>>> decide to deploy to work with real hardware.
>>>>
>>>> I have been seriously contemplating causing a cpu hot-unplug request
>>>> to fail if we are in ioapic mode and we have irqs routed to the cpu
>>>> that is being unplugged.
>>>>
>>>>        
>>> Well, obviously we need to disassociate any irqs from such a cpu.  Could be done
>>> from the kernel or only enforced by the kernel.
>>>      
>>
>> Using the normal irq migration path we can move irqs off of a cpu reliably
>> there just aren't any progress guarantees.
>>    
>
> Program the ioapic to the new cpu.  Wait a few milliseconds.  If it takes more
> than that to get an interrupt from the ioapic to the local apic, the machine has
> much bigger problems.

In general you can not reprogram an ioapic safely unless the interrupt
is blocked at the source.  Which is why you either need the originating
device disabled or you have to do it in interrupt context.

I forget all of the details.  I just know in real hardware I experimented
with it a lot, and wound up hanging the ioapic state machine of both
intel and amd ioapics.

Migrating ioapic irqs in interrupt context sucks.  It just happens to
be what works reliably.

I do think the wait an eternity in computer time a short while in human
time is a valid technique when you can do nothing better.  If flushing the
interrupt was my only problem that would solve it.

>>>> Even with perfectly working hardware it is not possible in the general
>>>> case to migrate an ioapic irq from one cpu to another outside of an
>>>> interrupt handler without without risking dropping an interrupt.
>>>>
>>>>        
>>> Can't you generate a spurious interrupt immediately after the migration?  An
>>> extra interrupt shouldn't hurt.
>>>      
>>
>> Nope.  The ioapics can't be told to send an interrupt.
>>    
>
> You can program the local apic ICR to generate an interrupt with the same
> vector.

But you can not program the apic ICR to generate a level triggered
interrupt with the same vector.  So you don't get the broadcast
behavior when you ack the apic.

>>>> There is no general way to know you have seen the last interrupt
>>>> floating around your system.  PCI ordering rules don't help because
>>>> the ioapics can potentially take an out of band channel.
>>>>
>>>>        
>>> Can you describe the problem scenario? an ioapic->lapic message delivered to a
>>> dead cpu?
>>>      
>>
>> Dropped irqs..  Driver hangs because it is waiting for an irq.  Hardware
>> hangs because it is waiting for the cpu to process the irq.
>>
>> Potentially we get a level triggered irq that is never acked by
>> the cpu that won't arm until the cpu send an ack, and we can't
>> send an ack from another cpu.
>>
>>    
>
> I think a spurious interrupt generated through the local apic solves that
> problem.  For level-triggered interrupts, mask them before offlining the cpu.

So now we have a masked unacked irq.  It doesn't help in the slightest
that the cpu migration code puts irq migration last and request that we
do it all with interrupts disabled.

You might be right that by application of extreme ingenuity and completely
in spec ioapics there is a path that makes this all work.  Currently I
don't have fully in spec ioapcis, and I don't have anyone interested enough
in cpu hotplug to be willing to rip things apart until interrupt migration
is a reasonable deal on x86.   Instead all I see are patches that mitigate
the worst of the brokenness.

At the same time with the interrupt remapping hardware because it doesn't
need the irq disabled at the source when we reprogram it I can make
everything stable much more easily.

Eric
