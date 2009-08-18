Return-Path: <linux-kernel-owner+w=401wt.eu-S1751441AbZHRS1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751441AbZHRS1g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 14:27:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750942AbZHRS1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 14:27:36 -0400
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:51202 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbZHRS1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 14:27:35 -0400
Date: Tue, 18 Aug 2009 11:27:35 -0700
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: Avi Kivity <avi@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
       Gregory Haskins <gregory.haskins@gmail.com>, kvm@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       alacrityvm-devel@lists.sourceforge.net,
       Anthony Liguori <anthony@codemonkey.ws>, Ingo Molnar <mingo@elte.hu>,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: [Alacrityvm-devel] [PATCH v3 3/6] vbus: add a "vbus-proxy" bus
	model for vbus_driver objects
Message-ID: <20090818182735.GD17631@ovro.caltech.edu>
References: <20090815103243.GA26749@elte.hu> <4A870964.9090408@codemonkey.ws> <4A8965E0.8050608@gmail.com> <20090817174142.GA11140@redhat.com> <4A89BAC5.9040400@gmail.com> <20090818084606.GA13878@redhat.com> <20090818155329.GD31060@ovro.caltech.edu> <4A8ADC09.3030205@redhat.com> <20090818172752.GC17631@ovro.caltech.edu> <4A8AE918.5000109@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A8AE918.5000109@redhat.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (ovro.ovro.caltech.edu); Tue, 18 Aug 2009 11:27:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 18, 2009 at 08:47:04PM +0300, Avi Kivity wrote:
> On 08/18/2009 08:27 PM, Ira W. Snyder wrote:
>>> In fact, modern x86s do have dma engines these days (google for Intel
>>> I/OAT), and one of our plans for vhost-net is to allow their use for
>>> packets above a certain size.  So a patch allowing vhost-net to
>>> optionally use a dma engine is a good thing.
>>>      
>> Yes, I'm aware that very modern x86 PCs have general purpose DMA
>> engines, even though I don't have any capable hardware. However, I think
>> it is better to support using any PC (with or without DMA engine, any
>> architecture) as the PCI master, and just handle the DMA all from the
>> PCI agent, which is known to have DMA?
>>    
>
> Certainly; but if your PCI agent will support the DMA API, then the same  
> vhost code will work with both I/OAT and your specialized hardware.
>

Yes, that's true. My ppc is a Freescale MPC8349EMDS. It has a Linux
DMAEngine driver in mainline, which I've used. That's excellent.

>>> Exposing a knob to userspace is not an insurmountable problem; vhost-net
>>> already allows changing the memory layout, for example.
>>>
>>>      
>> Let me explain the most obvious problem I ran into: setting the MAC
>> addresses used in virtio.
>>
>> On the host (PCI master), I want eth0 (virtio-net) to get a random MAC
>> address.
>>
>> On the guest (PCI agent), I want eth0 (virtio-net) to get a specific MAC
>> address, aa:bb:cc:dd:ee:ff.
>>
>> The virtio feature negotiation code handles this, by seeing the
>> VIRTIO_NET_F_MAC feature in it's configuration space. If BOTH drivers do
>> not have VIRTIO_NET_F_MAC set, then NEITHER will use the specified MAC
>> address. This is because the feature negotiation code only accepts a
>> feature if it is offered by both sides of the connection.
>>
>> In this case, I must have the guest generate a random MAC address and
>> have the host put aa:bb:cc:dd:ee:ff into the guest's configuration
>> space. This basically means hardcoding the MAC addresses in the Linux
>> drivers, which is a big no-no.
>>
>> What would I expose to userspace to make this situation manageable?
>>
>>    
>
> I think in this case you want one side to be virtio-net (I'm guessing  
> the x86) and the other side vhost-net (the ppc boards with the dma  
> engine).  virtio-net on x86 would communicate with userspace on the ppc  
> board to negotiate features and get a mac address, the fast path would  
> be between virtio-net and vhost-net (which would use the dma engine to  
> push and pull data).
>

Ah, that seems backwards, but it should work after vhost-net learns how
to use the DMAEngine API.

I haven't studied vhost-net very carefully yet. As soon as I saw the
copy_(to|from)_user() I stopped reading, because it seemed useless for
my case. I'll look again and try to find where vhost-net supports
setting MAC addresses and other features.

Also, in my case I'd like to boot Linux with my rootfs over NFS. Is
vhost-net capable of this?

I've had Arnd, BenH, and Grant Likely (and others, privately) contact me
about devices they are working with that would benefit from something
like virtio-over-PCI. I'd like to see vhost-net be merged with the
capability to support my use case. There are plenty of others that would
benefit, not just myself.

I'm not sure vhost-net is being written with this kind of future use in
mind. I'd hate to see it get merged, and then have to change the ABI to
support physical-device-to-device usage. It would be better to keep
future use in mind now, rather than try and hack it in later.

Thanks for the comments.
Ira
