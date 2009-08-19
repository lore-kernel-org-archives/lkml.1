Return-Path: <linux-kernel-owner+w=401wt.eu-S1752676AbZHSPhh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676AbZHSPhh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 11:37:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752532AbZHSPhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 11:37:36 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56490 "EHLO mx2.redhat.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752530AbZHSPhf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 11:37:35 -0400
Message-ID: <4A8C1C22.3010101@redhat.com>
Date: Wed, 19 Aug 2009 18:37:06 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
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
References: <20090818155329.GD31060@ovro.caltech.edu> <4A8ADC09.3030205@redhat.com> <20090818172752.GC17631@ovro.caltech.edu> <4A8AE918.5000109@redhat.com> <20090818182735.GD17631@ovro.caltech.edu> <4A8AF880.6080704@redhat.com> <20090818205919.GA1168@ovro.caltech.edu> <4A8B1C7F.4060008@redhat.com> <20090819003812.GA11168@ovro.caltech.edu> <4A8B9051.3020505@redhat.com> <20090819152811.GA22294@ovro.caltech.edu>
In-Reply-To: <20090819152811.GA22294@ovro.caltech.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/2009 06:28 PM, Ira W. Snyder wrote:
>
>> Well, if you can't do that, you can't use virtio-pci on the host.
>> You'll need another virtio transport (equivalent to "fake pci" you
>> mentioned above).
>>
>>      
> Ok.
>
> Is there something similar that I can study as an example? Should I look
> at virtio-pci?
>
>    

There's virtio-lguest, virtio-s390, and virtio-vbus.

>> I think you tried to take two virtio-nets and make them talk together?
>> That won't work.  You need the code from qemu to talk to virtio-net
>> config space, and vhost-net to pump the rings.
>>
>>      
> It *is* possible to make two unmodified virtio-net's talk together. I've
> done it, and it is exactly what the virtio-over-PCI patch does. Study it
> and you'll see how I connected the rx/tx queues together.
>    

Right, crossing the cables works, but feature negotiation is screwed up, 
and both sides think the data is in their RAM.

vhost-net doesn't do negotiation and doesn't assume the data lives in 
its address space.

>> Please find a name other than virtio-over-PCI since it conflicts with
>> virtio-pci.  You're tunnelling virtio config cycles (which are usually
>> done on pci config cycles) on a new protocol which is itself tunnelled
>> over PCI shared memory.
>>
>>      
> Sorry about that. Do you have suggestions for a better name?
>
>    

virtio-$yourhardware or maybe virtio-dma

> I called it virtio-over-PCI in my previous postings to LKML, so until a
> new patch is written and posted, I'll keep referring to it by the name
> used in the past, so people can search for it.
>
> When I post virtio patches, should I CC another mailing list in addition
> to LKML?
>    

virtualization@lists.linux-foundation.org is virtio's home.

> That said, I'm not sure how qemu-system-ppc running on x86 could
> possibly communicate using virtio-net. This would mean the guest is an
> emulated big-endian PPC, while the host is a little-endian x86. I
> haven't actually tested this situation, so perhaps I am wrong.
>    

I'm confused now.  You don't actually have any guest, do you, so why 
would you run qemu at all?

>> The x86 side only needs to run virtio-net, which is present in RHEL 5.3.
>> You'd only need to run virtio-tunnel or however it's called.  All the
>> eventfd magic takes place on the PCI agents.
>>
>>      
> I can upgrade the kernel to anything I want on both the x86 and ppc's.
> I'd like to avoid changing the x86 (RHEL5) userspace, though. On the
> ppc's, I have full control over the userspace environment.
>    

You don't need any userspace on virtio-net's side.

Your ppc boards emulate a virtio-net device, so all you need is the 
virtio-net module (and virtio bindings).  If you chose to emulate, say, 
an e1000 card all you'd need is the e1000 driver.

-- 
error compiling committee.c: too many arguments to function

