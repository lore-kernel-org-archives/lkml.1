Return-Path: <linux-kernel-owner+w=401wt.eu-S1761313AbZEHIS6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761313AbZEHIS6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 04:18:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754774AbZEHISr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 04:18:47 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51868 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756255AbZEHISp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 04:18:45 -0400
Message-ID: <4A03EA83.6040907@redhat.com>
Date: Fri, 08 May 2009 11:17:07 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: Anthony Liguori <anthony@codemonkey.ws>,
       Chris Wright <chrisw@sous-sol.org>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] generic hypercall support
References: <20090505132005.19891.78436.stgit@dev.haskins.net> <4A0040C0.1080102@redhat.com> <4A0041BA.6060106@novell.com> <4A004676.4050604@redhat.com> <4A0049CD.3080003@gmail.com> <20090505231718.GT3036@sequoia.sous-sol.org> <4A010927.6020207@novell.com> <4A019717.7070806@codemonkey.ws> <4A01B4CF.3080706@novell.com>
In-Reply-To: <4A01B4CF.3080706@novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
> Anthony Liguori wrote:
>   
>> Gregory Haskins wrote:
>>     
>>> Today, there is no equivelent of a platform agnostic "iowrite32()" for
>>> hypercalls so the driver would look like the pseudocode above except
>>> substitute with kvm_hypercall(), lguest_hypercall(), etc.  The proposal
>>> is to allow the hypervisor to assign a dynamic vector to resources in
>>> the backend and convey this vector to the guest (such as in PCI
>>> config-space as mentioned in my example use-case).  The provides the
>>> "address negotiation" function that would normally be done for something
>>> like a pio port-address.   The hypervisor agnostic driver can then use
>>> this globally recognized address-token coupled with other device-private
>>> ABI parameters to communicate with the device.  This can all occur
>>> without the core hypervisor needing to understand the details beyond the
>>> addressing.
>>>   
>>>       
>> PCI already provide a hypervisor agnostic interface (via IO regions). 
>> You have a mechanism for devices to discover which regions they have
>> allocated and to request remappings.  It's supported by Linux and
>> Windows.  It works on the vast majority of architectures out there today.
>>
>> Why reinvent the wheel?
>>     
>
> I suspect the current wheel is square.  And the air is out.  Plus its
> pulling to the left when I accelerate, but to be fair that may be my
> alignment....

No, your wheel is slightly faster on the highway, but doesn't work at 
all off-road.

Consider nested virtualization where the host (H) runs a guest (G1) 
which is itself a hypervisor, running a guest (G2).  The host exposes a 
set of virtio (V1..Vn) devices for guest G1.  Guest G1, rather than 
creating a new virtio devices and bridging it to one of V1..Vn, assigns 
virtio device V1 to guest G2, and prays.

Now guest G2 issues a hypercall.  Host H traps the hypercall, sees it 
originated in G1 while in guest mode, so it injects it into G1.  G1 
examines the parameters but can't make any sense of them, so it returns 
an error to G2.

If this were done using mmio or pio, it would have just worked.  With 
pio, H would have reflected the pio into G1, G1 would have done the 
conversion from G2's port number into G1's port number and reissued the 
pio, finally trapped by H and used to issue the I/O.  With mmio, G1 
would have set up G2's page tables to point directly at the addresses 
set up by H, so we would actually have a direct G2->H path.  Of course 
we'd need an emulated iommu so all the memory references actually 
resolve to G2's context.

So the upshoot is that hypercalls for devices must not be the primary 
method of communications; they're fine as an optimization, but we should 
always be able to fall back on something else.  We also need to figure 
out how G1 can stop V1 from advertising hypercall support.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

