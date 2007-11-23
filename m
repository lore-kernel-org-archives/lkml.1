Return-Path: <linux-kernel-owner+w=401wt.eu-S1757422AbXKWRt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422AbXKWRt1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 12:49:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753777AbXKWRtT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 12:49:19 -0500
Received: from il.qumranet.com ([82.166.9.18]:49951 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753313AbXKWRtS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 12:49:18 -0500
Message-ID: <4747122F.1070905@qumranet.com>
Date: Fri, 23 Nov 2007 19:47:27 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Anthony Liguori <aliguori@us.ibm.com>
CC: Eric Van Hensbergen <ericvanhensbergen@us.ibm.com>,
       lguest <lguest@ozlabs.org>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org
Subject: Re: [kvm-devel] [PATCH 3/3] virtio PCI device
References: <11944899922822-git-send-email-aliguori@us.ibm.com>	<11944900141678-git-send-email-aliguori@us.ibm.com>	<11944900152750-git-send-email-aliguori@us.ibm.com>	<11944900163817-git-send-email-aliguori@us.ibm.com>	<4742F6B7.20503@qumranet.com>	<474300AD.4060509@us.ibm.com>	<4743076F.8000105@qumranet.com> <47435CCB.1050506@us.ibm.com>	<4743DAA4.70800@qumranet.com> <4747051C.3090903@us.ibm.com>
In-Reply-To: <4747051C.3090903@us.ibm.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Anthony Liguori wrote:
> Avi Kivity wrote:
>   
>> Anthony Liguori wrote:
>>     
>>> Well please propose the virtio API first and then I'll adjust the PCI 
>>> ABI.  I don't want to build things into the ABI that we never 
>>> actually end up using in virtio :-)
>>>
>>>   
>>>       
>> Move ->kick() to virtio_driver.
>>     
>
> Then on each kick, all queues have to be checked for processing?  What 
> devices do you expect this would help?
>
>   

Networking.

>> I believe Xen networking uses the same event channel for both rx and 
>> tx, so in effect they're using this model.  Long time since I looked 
>> though,
>>     
>
> I would have to look, but since rx/tx are rather independent actions, 
> I'm not sure that you would really save that much.  You still end up 
> doing the same number of kicks unless I'm missing something.
>
>   

rx and tx are closely related. You rarely have one without the other.

In fact, a turned implementation should have zero kicks or interrupts 
for bulk transfers. The rx interrupt on the host will process new tx 
descriptors and fill the guest's rx queue; the guest's transmit function 
can also check the receive queue. I don't know if that's achievable for 
Linuz guests currently, but we should aim to make it possible.

Another point is that virtio still has a lot of leading zeros in its 
mileage counter. We need to keep things flexible and learn from others 
as much as possible, especially when talking about the ABI.

> I'm wary of introducing the notion of hypercalls to this device because 
> it makes the device VMM specific.  Maybe we could have the device 
> provide an option ROM that was treated as the device "BIOS" that we 
> could use for kicking and interrupt acking?  Any idea of how that would 
> map to Windows?  Are there real PCI devices that use the option ROM 
> space to provide what's essentially firmware?  Unfortunately, I don't 
> think an option ROM BIOS would map well to other architectures.
>
>   

The BIOS wouldn't work even on x86 because it isn't mapped to the guest 
address space (at least not consistently), and doesn't know the guest's 
programming model (16, 32, or 64-bits? segmented or flat?)

Xen uses a hypercall page to abstract these details out. However, I'm 
not proposing that. Simply indicate that we support hypercalls, and use 
some layer below to actually send them. It is the responsibility of this 
layer to detect if hypercalls are present and how to call them.

Hey, I think the best place for it is in paravirt_ops. We can even patch 
the hypercall instruction inline, and the driver doesn't need to know 
about it.

>>> None of the PCI devices currently work like that in QEMU.  It would 
>>> be very hard to make a device that worked this way because since the 
>>> order in which values are written matter a whole lot.  For instance, 
>>> if you wrote the status register before the queue information, the 
>>> driver could get into a funky state.
>>>   
>>>       
>> I assume you're talking about restore?  Isn't that atomic?
>>     
>
> If you're doing restore by passing the PCI config blob to a registered 
> routine, then sure, but that doesn't seem much better to me than just 
> having the device generate that blob in the first place (which is what 
> we have today).  I was assuming that you would want to use the existing 
> PIO/MMIO handlers to do restore by rewriting the config as if the guest was.
>
>   

Sure some complexity is unavoidable. But flat is simpler than indirect.

>>>> Not much of an argument, I know.
>>>>
>>>>
>>>> wrt. number of queues, 8 queues will consume 32 bytes of pci space 
>>>> if all you store is the ring pfn.
>>>>     
>>>>         
>>> You also at least need a num argument which takes you to 48 or 64 
>>> depending on whether you care about strange formatting.  8 queues may 
>>> not be enough either.  Eric and I have discussed whether the 9p 
>>> virtio device should support multiple mounts per-virtio device and if 
>>> so, whether each one should have it's own queue.  Any devices that 
>>> supports this sort of multiplexing will very quickly start using a 
>>> lot of queues.
>>>   
>>>       
>> Make it appear as a pci function?  (though my feeling is that multiple 
>> mounts should be different devices; we can then hotplug mountpoints).
>>     
>
> We may run out of PCI slots though :-/
>   

Then we can start selling virtio extension chassis.

-- 
Any sufficiently difficult bug is indistinguishable from a feature.

