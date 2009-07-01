Return-Path: <linux-kernel-owner+w=401wt.eu-S1754527AbZGAI2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527AbZGAI2p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 04:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754040AbZGAI2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 04:28:30 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57977 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754267AbZGAI21 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 04:28:27 -0400
Message-ID: <4A4B1E95.1030702@redhat.com>
Date: Wed, 01 Jul 2009 11:30:13 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Gleb Natapov <gleb@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Sheng Yang <sheng@linux.intel.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v3] enable x2APIC without interrupt remapping under KVM
References: <20090629132926.GB20289@redhat.com>	<m1ocs6axca.fsf@fess.ebiederm.org> <20090630092623.GI20289@redhat.com>	<m1eit1acxl.fsf@fess.ebiederm.org> <4A4A476C.2070305@redhat.com>	<m1ljn94k16.fsf@fess.ebiederm.org> <4A4A6499.9000406@redhat.com> <m1k52t1plq.fsf@fess.ebiederm.org>
In-Reply-To: <m1k52t1plq.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30/2009 10:36 PM, Eric W. Biederman wrote:
>>> The short version is I don't know what work arounds we will ultimately
>>> decide to deploy to work with real hardware.
>>>
>>> I have been seriously contemplating causing a cpu hot-unplug request
>>> to fail if we are in ioapic mode and we have irqs routed to the cpu
>>> that is being unplugged.
>>>
>>>        
>> Well, obviously we need to disassociate any irqs from such a cpu.  Could be done
>> from the kernel or only enforced by the kernel.
>>      
>
> Using the normal irq migration path we can move irqs off of a cpu reliably
> there just aren't any progress guarantees.
>    

Program the ioapic to the new cpu.  Wait a few milliseconds.  If it 
takes more than that to get an interrupt from the ioapic to the local 
apic, the machine has much bigger problems.

>>> Even with perfectly working hardware it is not possible in the general
>>> case to migrate an ioapic irq from one cpu to another outside of an
>>> interrupt handler without without risking dropping an interrupt.
>>>
>>>        
>> Can't you generate a spurious interrupt immediately after the migration?  An
>> extra interrupt shouldn't hurt.
>>      
>
> Nope.  The ioapics can't be told to send an interrupt.
>    

You can program the local apic ICR to generate an interrupt with the 
same vector.

>>> There is no general way to know you have seen the last interrupt
>>> floating around your system.  PCI ordering rules don't help because
>>> the ioapics can potentially take an out of band channel.
>>>
>>>        
>> Can you describe the problem scenario? an ioapic->lapic message delivered to a
>> dead cpu?
>>      
>
> Dropped irqs..  Driver hangs because it is waiting for an irq.  Hardware
> hangs because it is waiting for the cpu to process the irq.
>
> Potentially we get a level triggered irq that is never acked by
> the cpu that won't arm until the cpu send an ack, and we can't
> send an ack from another cpu.
>
>    

I think a spurious interrupt generated through the local apic solves 
that problem.  For level-triggered interrupts, mask them before 
offlining the cpu.

-- 
error compiling committee.c: too many arguments to function

