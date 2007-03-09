Return-Path: <linux-kernel-owner+w=401wt.eu-S1767622AbXCIXHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767622AbXCIXHU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 18:07:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767582AbXCIXHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 18:07:20 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:59175 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767622AbXCIXHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 18:07:16 -0500
Message-ID: <45F1E8A3.6000100@vmware.com>
Date: Fri, 09 Mar 2007 15:07:15 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       akpm@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Chris Wright <chrisw@sous-sol.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: ABI coupling to hypervisors via CONFIG_PARAVIRT
References: <20070309180230.GA17988@elte.hu> <Pine.LNX.4.64.0703091022490.10832@woody.linux-foundation.org> <20070309192420.GA27747@elte.hu> <Pine.LNX.4.64.0703091137340.10832@woody.linux-foundation.org> <20070309201257.GA5761@elte.hu> <Pine.LNX.4.64.0703091305090.10832@woody.linux-foundation.org> <20070309213607.GA16796@elte.hu> <Pine.LNX.4.64.0703091423570.10832@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703091423570.10832@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
>> but ... maybe because VMI is so lowlevel and covers /all/ of x86 today, 
>> it will always be able to emulate whatever different concept we can come 
>> up with? Do we really know this absolutely sure?
>>     
>
> "For sure"? Absolutely not. But since any new interfaces we come up with 
> for doing timers etc had better work perfectly fine on an old hardware 
> platform too, we can't exactly require any interfaces that do things that 
> a bog-standard old dual-PPro didn't do 10 years ago, can we?
>
> So assumign that the VMI interface is roughly as powerful (by virtue of 
> basically emulating it) as the old single-ioapic/single-lapic systems we 
> used to use, I don't think it should ever be a real problem. Hmm?
>   

Sorry to keep you in a thread you don't want more to do with Linus, but 
to answer the question completely directly:

There are four design requirement which are inviolate for achieving a 
large measurable performance gain, which is the primary benefit of i386 
paravirt-ops for us.  These changes are required for /ALL/ high 
performance paravirtualized kernels not running in hardware 
virtualization, across a broad spectrum of hypervisors, and have either 
zero negative impact or opportunity for additional gain when hardware 
virtualization is enabled.

1) Ability to run the kernel at non-zero CPL
2) Ability to replace hardware interrupt masking functions with 
virtualizable equivalents
3) Notification when page tables are allocated and released
4) Notification in some form when page table entries are updated (or 
vma's are changed)

Everything after this are incremental gains, some more valuable than 
others, but not as major in significance as the above four (apic_write, 
incidentally, _is_ one of the more substantial gains for us).

These don't seem to be a major burden on the kernel at all.

#1 is already the default case now for even native hardware.
#2 requires a lot of hooks because interrupt masking is a common 
function, and this is where the large numbers of hook points Ingo was 
demonstrating came from, but these icache effects and costs are on 
already expensive instructions.  In fact, it appears on some hardware, 
the nop padding around cli / sti / pushf / popf contributes to a 
mysterious performance gain, perhaps due to some pipelining anomaly.
#3 is not a common enough operation to be of performance concern.  It 
does however, require pagetables, just as native hardware does.  Which 
we can implement perfectly well anyway in our backend, just as the 
native backend would if some reckless madman removed all notions of page 
tables from a paravirt kernel.
#4 involves an extra call in page fault paths and from some points in 
the mm layer.

There are no ABI requirements tied to these, merely the presence of any 
usable API for them in paravirt-ops.

Linus is right - our virtual hardware is an exact replica of real 
hardware.  So no matter how you change paravirtualization in the kernel, 
anything that runs on real hardware will continue to run on VMware.  VMI 
is tied very closely to the hardware, on purpose, and follows the rules 
of native hardware extremely closely.  So you can pretty much twist and 
abuse paravirt-ops in a number of ways, and as long as it continues to 
run on real hardware with the above four requirements, it still runs 
even on VMI.  Violate the above four requirements, and it costs a lot of 
performance, but we still continue to run.

Zach
