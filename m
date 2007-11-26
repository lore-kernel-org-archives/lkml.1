Return-Path: <linux-kernel-owner+w=401wt.eu-S1755686AbXKZTSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686AbXKZTSl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 14:18:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752163AbXKZTSe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 14:18:34 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:44639 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518AbXKZTSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 14:18:33 -0500
Message-ID: <474B1BF3.20901@us.ibm.com>
Date: Mon, 26 Nov 2007 13:18:11 -0600
From: Anthony Liguori <aliguori@us.ibm.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Avi Kivity <avi@qumranet.com>
CC: Eric Van Hensbergen <ericvanhensbergen@us.ibm.com>,
       lguest <lguest@ozlabs.org>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org
Subject: Re: [kvm-devel] [PATCH 3/3] virtio PCI device
References: <11944899922822-git-send-email-aliguori@us.ibm.com>	<11944900141678-git-send-email-aliguori@us.ibm.com>	<11944900152750-git-send-email-aliguori@us.ibm.com>	<11944900163817-git-send-email-aliguori@us.ibm.com>	<4742F6B7.20503@qumranet.com>	<474300AD.4060509@us.ibm.com>	<4743076F.8000105@qumranet.com> <47435CCB.1050506@us.ibm.com>	<4743DAA4.70800@qumranet.com> <4747051C.3090903@us.ibm.com> <4747122F.1070905@qumranet.com>
In-Reply-To: <4747122F.1070905@qumranet.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> rx and tx are closely related. You rarely have one without the other.
>
> In fact, a turned implementation should have zero kicks or interrupts 
> for bulk transfers. The rx interrupt on the host will process new tx 
> descriptors and fill the guest's rx queue; the guest's transmit 
> function can also check the receive queue. I don't know if that's 
> achievable for Linuz guests currently, but we should aim to make it 
> possible.

ATM, the net driver does a pretty good job of disabling kicks/interrupts 
unless they are needed.  Checking for rx on tx and vice versa is a good 
idea and could further help there.  I'll give it a try this week.

> Another point is that virtio still has a lot of leading zeros in its 
> mileage counter. We need to keep things flexible and learn from others 
> as much as possible, especially when talking about the ABI.

Yes, after thinking about it over holiday, I agree that we should at 
least introduce a virtio-pci feature bitmask.  I'm not inclined to 
attempt to define a hypercall ABI or anything like that right now but 
having the feature bitmask will at least make it possible to do such a 
thing in the future.

>> I'm wary of introducing the notion of hypercalls to this device 
>> because it makes the device VMM specific.  Maybe we could have the 
>> device provide an option ROM that was treated as the device "BIOS" 
>> that we could use for kicking and interrupt acking?  Any idea of how 
>> that would map to Windows?  Are there real PCI devices that use the 
>> option ROM space to provide what's essentially firmware?  
>> Unfortunately, I don't think an option ROM BIOS would map well to 
>> other architectures.
>>
>>   
>
> The BIOS wouldn't work even on x86 because it isn't mapped to the 
> guest address space (at least not consistently), and doesn't know the 
> guest's programming model (16, 32, or 64-bits? segmented or flat?)
>
> Xen uses a hypercall page to abstract these details out. However, I'm 
> not proposing that. Simply indicate that we support hypercalls, and 
> use some layer below to actually send them. It is the responsibility 
> of this layer to detect if hypercalls are present and how to call them.
>
> Hey, I think the best place for it is in paravirt_ops. We can even 
> patch the hypercall instruction inline, and the driver doesn't need to 
> know about it.

Yes, paravirt_ops is attractive for abstracting the hypercall calling 
mechanism but it's still necessary to figure out how hypercalls would be 
identified.  I think it would be necessary to define a virtio specific 
hypercall space and use the virtio device ID to claim subspaces.

For instance, the hypercall number could be (virtio_devid << 16) | (call 
number).  How that translates into a hypercall would then be part of the 
paravirt_ops abstraction.  In KVM, we may have a single virtio hypercall 
where we pass the virtio hypercall number as one of the arguments or 
something like that.

>>>>> Not much of an argument, I know.
>>>>>
>>>>>
>>>>> wrt. number of queues, 8 queues will consume 32 bytes of pci space 
>>>>> if all you store is the ring pfn.
>>>>>             
>>>> You also at least need a num argument which takes you to 48 or 64 
>>>> depending on whether you care about strange formatting.  8 queues 
>>>> may not be enough either.  Eric and I have discussed whether the 9p 
>>>> virtio device should support multiple mounts per-virtio device and 
>>>> if so, whether each one should have it's own queue.  Any devices 
>>>> that supports this sort of multiplexing will very quickly start 
>>>> using a lot of queues.
>>>>         
>>> Make it appear as a pci function?  (though my feeling is that 
>>> multiple mounts should be different devices; we can then hotplug 
>>> mountpoints).
>>>     
>>
>> We may run out of PCI slots though :-/
>>   
>
> Then we can start selling virtio extension chassis.

:-)  Do you know if there is a hard limit on the number of devices on a 
PCI bus?  My concern was that it was limited by something stupid like an 
8-bit identifier.

Regards,

Anthony Liguori

