Return-Path: <linux-kernel-owner+w=401wt.eu-S1759530AbZHRRq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759530AbZHRRq7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 13:46:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759383AbZHRRq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 13:46:59 -0400
Received: from mx2.redhat.com ([66.187.237.31]:32839 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759332AbZHRRq5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 13:46:57 -0400
Message-ID: <4A8AE918.5000109@redhat.com>
Date: Tue, 18 Aug 2009 20:47:04 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: "Ira W. Snyder" <iws@ovro.caltech.edu>
CC: "Michael S. Tsirkin" <mst@redhat.com>,
       Gregory Haskins <gregory.haskins@gmail.com>, kvm@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       alacrityvm-devel@lists.sourceforge.net,
       Anthony Liguori <anthony@codemonkey.ws>, Ingo Molnar <mingo@elte.hu>,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: [Alacrityvm-devel] [PATCH v3 3/6] vbus: add a "vbus-proxy" bus
 model for vbus_driver objects
References: <20090814154125.26116.70709.stgit@dev.haskins.net> <20090814154308.26116.46980.stgit@dev.haskins.net> <20090815103243.GA26749@elte.hu> <4A870964.9090408@codemonkey.ws> <4A8965E0.8050608@gmail.com> <20090817174142.GA11140@redhat.com> <4A89BAC5.9040400@gmail.com> <20090818084606.GA13878@redhat.com> <20090818155329.GD31060@ovro.caltech.edu> <4A8ADC09.3030205@redhat.com> <20090818172752.GC17631@ovro.caltech.edu>
In-Reply-To: <20090818172752.GC17631@ovro.caltech.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/18/2009 08:27 PM, Ira W. Snyder wrote:
>> In fact, modern x86s do have dma engines these days (google for Intel
>> I/OAT), and one of our plans for vhost-net is to allow their use for
>> packets above a certain size.  So a patch allowing vhost-net to
>> optionally use a dma engine is a good thing.
>>      
> Yes, I'm aware that very modern x86 PCs have general purpose DMA
> engines, even though I don't have any capable hardware. However, I think
> it is better to support using any PC (with or without DMA engine, any
> architecture) as the PCI master, and just handle the DMA all from the
> PCI agent, which is known to have DMA?
>    

Certainly; but if your PCI agent will support the DMA API, then the same 
vhost code will work with both I/OAT and your specialized hardware.

>> Exposing a knob to userspace is not an insurmountable problem; vhost-net
>> already allows changing the memory layout, for example.
>>
>>      
> Let me explain the most obvious problem I ran into: setting the MAC
> addresses used in virtio.
>
> On the host (PCI master), I want eth0 (virtio-net) to get a random MAC
> address.
>
> On the guest (PCI agent), I want eth0 (virtio-net) to get a specific MAC
> address, aa:bb:cc:dd:ee:ff.
>
> The virtio feature negotiation code handles this, by seeing the
> VIRTIO_NET_F_MAC feature in it's configuration space. If BOTH drivers do
> not have VIRTIO_NET_F_MAC set, then NEITHER will use the specified MAC
> address. This is because the feature negotiation code only accepts a
> feature if it is offered by both sides of the connection.
>
> In this case, I must have the guest generate a random MAC address and
> have the host put aa:bb:cc:dd:ee:ff into the guest's configuration
> space. This basically means hardcoding the MAC addresses in the Linux
> drivers, which is a big no-no.
>
> What would I expose to userspace to make this situation manageable?
>
>    

I think in this case you want one side to be virtio-net (I'm guessing 
the x86) and the other side vhost-net (the ppc boards with the dma 
engine).  virtio-net on x86 would communicate with userspace on the ppc 
board to negotiate features and get a mac address, the fast path would 
be between virtio-net and vhost-net (which would use the dma engine to 
push and pull data).

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

