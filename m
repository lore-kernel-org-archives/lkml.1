Return-Path: <linux-kernel-owner+w=401wt.eu-S1763272AbZEHRBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763272AbZEHRBs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 13:01:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753775AbZEHRBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 13:01:38 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36296 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486AbZEHRBh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 13:01:37 -0400
Message-ID: <4A046519.30604@redhat.com>
Date: Fri, 08 May 2009 20:00:09 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: Anthony Liguori <anthony@codemonkey.ws>,
       Chris Wright <chrisw@sous-sol.org>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] generic hypercall support
References: <20090505132005.19891.78436.stgit@dev.haskins.net> <4A0040C0.1080102@redhat.com> <4A0041BA.6060106@novell.com> <4A004676.4050604@redhat.com> <4A0049CD.3080003@gmail.com> <20090505231718.GT3036@sequoia.sous-sol.org> <4A010927.6020207@novell.com> <4A019717.7070806@codemonkey.ws> <4A01B4CF.3080706@novell.com> <4A03EA83.6040907@redhat.com> <4A044DB5.7050304@novell.com>
In-Reply-To: <4A044DB5.7050304@novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
>> Consider nested virtualization where the host (H) runs a guest (G1)
>> which is itself a hypervisor, running a guest (G2).  The host exposes
>> a set of virtio (V1..Vn) devices for guest G1.  Guest G1, rather than
>> creating a new virtio devices and bridging it to one of V1..Vn,
>> assigns virtio device V1 to guest G2, and prays.
>>
>> Now guest G2 issues a hypercall.  Host H traps the hypercall, sees it
>> originated in G1 while in guest mode, so it injects it into G1.  G1
>> examines the parameters but can't make any sense of them, so it
>> returns an error to G2.
>>
>> If this were done using mmio or pio, it would have just worked.  With
>> pio, H would have reflected the pio into G1, G1 would have done the
>> conversion from G2's port number into G1's port number and reissued
>> the pio, finally trapped by H and used to issue the I/O. 
>>     
>
> I might be missing something, but I am not seeing the difference here. 
> We have an "address" (in this case the HC-id) and a context (in this
> case G1 running in non-root mode).   Whether the  trap to H is a HC or a
> PIO, the context tells us that it needs to re-inject the same trap to G1
> for proper handling.  So the "address" is re-injected from H to G1 as an
> emulated trap to G1s root-mode, and we continue (just like the PIO).
>   

So far, so good (though in fact mmio can short-circuit G2->H directly).

> And likewise, in both cases, G1 would (should?) know what to do with
> that "address" as it relates to G2, just as it would need to know what
> the PIO address is for.  Typically this would result in some kind of
> translation of that "address", but I suppose even this is completely
> arbitrary and only G1 knows for sure.  E.g. it might translate from
> hypercall vector X to Y similar to your PIO example, it might completely
> change transports, or it might terminate locally (e.g. emulated device
> in G1).   IOW: G2 might be using hypercalls to talk to G1, and G1 might
> be using MMIO to talk to H.  I don't think it matters from a topology
> perspective (though it might from a performance perspective).
>   

How can you translate a hypercall?  G1's and H's hypercall mechanisms 
can be completely different.


>> So the upshoot is that hypercalls for devices must not be the primary
>> method of communications; they're fine as an optimization, but we
>> should always be able to fall back on something else.  We also need to
>> figure out how G1 can stop V1 from advertising hypercall support.
>>     
> I agree it would be desirable to be able to control this exposure. 
> However, I am not currently convinced its strictly necessary because of
> the reason you mentioned above.  And also note that I am not currently
> convinced its even possible to control it.
>
> For instance, what if G1 is an old KVM, or (dare I say) a completely
> different hypervisor?  You could control things like whether G1 can see
> the VMX/SVM option at a coarse level, but once you expose VMX/SVM, who
> is to say what G1 will expose to G2?  G1 may very well advertise a HC
> feature bit to G2 which may allow G2 to try to make a VMCALL.  How do
> you stop that?
>   

I don't see any way.

If, instead of a hypercall we go through the pio hypercall route, then 
it all resolves itself.  G2 issues a pio hypercall, H bounces it to G1, 
G1 either issues a pio or a pio hypercall depending on what the H and G1 
negotiated.  Of course mmio is faster in this case since it traps directly.

btw, what's the hypercall rate you're seeing? at 10K hypercalls/sec, a 
0.4us difference will buy us 0.4% reduction in cpu load, so let's see 
what's the potential gain here.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

