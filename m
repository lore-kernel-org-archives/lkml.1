Return-Path: <linux-kernel-owner+w=401wt.eu-S1751847AbZLVAMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847AbZLVAMs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 19:12:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751155AbZLVAMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 19:12:48 -0500
Received: from mail-gx0-f211.google.com ([209.85.217.211]:38478 "EHLO
	mail-gx0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbZLVAMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 19:12:47 -0500
Message-ID: <4B300EF8.8010602@codemonkey.ws>
Date: Mon, 21 Dec 2009 18:12:40 -0600
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Gregory Haskins <gregory.haskins@gmail.com>
CC: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       kvm@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org,
       "alacrityvm-devel@lists.sourceforge.net" 
	<alacrityvm-devel@lists.sourceforge.net>
Subject: Re: [GIT PULL] AlacrityVM guest drivers for 2.6.33
References: <4B1D4F29.8020309@gmail.com> <20091218215107.GA14946@elte.hu> <4B2F9582.5000002@gmail.com> <4B2F978D.7010602@redhat.com> <4B2F9C85.7070202@gmail.com> <4B2FA42F.3070408@codemonkey.ws> <4B2FA655.6030205@gmail.com> <4B2FAE7B.9030005@codemonkey.ws> <4B2FB3F1.5080808@gmail.com>
In-Reply-To: <4B2FB3F1.5080808@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2009 11:44 AM, Gregory Haskins wrote:
> Well, surely something like SR-IOV is moving in that direction, no?
>    

Not really, but that's a different discussion.

>> But let's focus on concrete data.  For a given workload,
>> how many exits do you see due to EOI?
>>      
> Its of course highly workload dependent, and I've published these
> details in the past, I believe.  Off the top of my head, I recall that
> virtio-pci tends to throw about 65k exits per second, vs about 32k/s for
> venet on a 10GE box, but I don't recall what ratio of those exits are
> EOI.

Was this userspace virtio-pci or was this vhost-net?  If it was the 
former, then were you using MSI-X?  If you weren't, there would be an 
additional (rather heavy) exit per-interrupt to clear the ISR which 
would certainly account for a large portion of the additional exits.

>    To be perfectly honest, I don't care.  I do not discriminate
> against the exit type...I want to eliminate as many as possible,
> regardless of the type.  That's how you go fast and yet use less CPU.
>    

It's important to understand why one mechanism is better than another.   
All I'm looking for is a set of bullet points that say, vbus does this, 
vhost-net does that, therefore vbus is better.  We would then either 
say, oh, that's a good idea, let's change vhost-net to do that, or we 
would say, hrm, well, we can't change vhost-net to do that because of 
some fundamental flaw, let's drop it and adopt vbus.

It's really that simple :-)


>>   They should be relatively rare
>> because obtaining good receive batching is pretty easy.
>>      
> Batching is poor mans throughput (its easy when you dont care about
> latency), so we generally avoid as much as possible.
>    

Fair enough.

>> Considering
>> these are lightweight exits (on the order of 1-2us),
>>      
> APIC EOIs on x86 are MMIO based, so they are generally much heavier than
> that.  I measure at least 4-5us just for the MMIO exit on my Woodcrest,
> never mind executing the locking/apic-emulation code.
>    

You won't like to hear me say this, but Woodcrests are pretty old and 
clunky as far as VT goes :-)

On a modern Nehalem, I would be surprised if an MMIO exit handled in the 
kernel was muck more than 2us.  The hardware is getting very, very 
fast.  The trends here are very important to consider when we're looking 
at architectures that we potentially are going to support for a long time.

>> you need an awfully
>> large amount of interrupts before you get really significant performance
>> impact.  You would think NAPI would kick in at this point anyway.
>>
>>      
> Whether NAPI can kick in or not is workload dependent, and it also does
> not address coincident events.  But on that topic, you can think of
> AlacrityVM's interrupt controller as "NAPI for interrupts", because it
> operates on the same principle.  For what its worth, it also operates on
> a "NAPI for hypercalls" concept too.
>    

The concept of always batching hypercalls has certainly been explored 
within the context of Xen.  But then when you look at something like 
KVM's hypercall support, it turns out that with sufficient cleverness in 
the host, we don't even bother with the MMU hypercalls anymore.

Doing fancy things in the guest is difficult to support from a long term 
perspective.  It'll more or less never work for Windows and even the lag 
with Linux makes it difficult for users to see the benefit of these 
changes.  You get a lot more flexibility trying to solve things in the 
host even if it's convoluted (like TPR patching).

>> Do you have data demonstrating the advantage of EOI mitigation?
>>      
> I have non-scientifically gathered numbers in my notebook that put it on
> average of about 55%-60% reduction in EOIs for inbound netperf runs, for
> instance.  I don't have time to gather more in the near term, but its
> typically in that range for a chatty enough workload, and it goes up as
> you add devices.  I would certainly formally generate those numbers when
> I make another merge request in the future, but I don't have them now.
>    

I don't think it's possible to make progress with vbus without detailed 
performance data comparing both vbus and virtio (vhost-net).  On the 
virtio/vhost-net side, I think we'd be glad to help gather/analyze that 
data.  We have to understand why one's better than the other and then we 
have to evaluate whether we can bring those benefits into the later.  If 
we can't, we merge vbus.  If we can, we fix virtio.

Regards,

Anthony Liguori

> Kind Regards,
> -Greg
>
>    

