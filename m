Return-Path: <linux-kernel-owner+w=401wt.eu-S1757260AbXK0JAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757260AbXK0JAj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 04:00:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751559AbXK0JAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 04:00:31 -0500
Received: from il.qumranet.com ([82.166.9.18]:57841 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751048AbXK0JAb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 04:00:31 -0500
Message-ID: <474BDD28.7050801@qumranet.com>
Date: Tue, 27 Nov 2007 11:02:32 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Anthony Liguori <aliguori@us.ibm.com>
CC: Eric Van Hensbergen <ericvanhensbergen@us.ibm.com>,
       lguest <lguest@ozlabs.org>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org
Subject: Re: [kvm-devel] [PATCH 3/3] virtio PCI device
References: <11944899922822-git-send-email-aliguori@us.ibm.com>	<11944900141678-git-send-email-aliguori@us.ibm.com>	<11944900152750-git-send-email-aliguori@us.ibm.com>	<11944900163817-git-send-email-aliguori@us.ibm.com>	<4742F6B7.20503@qumranet.com>	<474300AD.4060509@us.ibm.com>	<4743076F.8000105@qumranet.com> <47435CCB.1050506@us.ibm.com>	<4743DAA4.70800@qumranet.com> <4747051C.3090903@us.ibm.com> <4747122F.1070905@qumranet.com> <474B1BF3.20901@us.ibm.com>
In-Reply-To: <474B1BF3.20901@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Anthony Liguori wrote:
>> Another point is that virtio still has a lot of leading zeros in its 
>> mileage counter. We need to keep things flexible and learn from 
>> others as much as possible, especially when talking about the ABI.
>
> Yes, after thinking about it over holiday, I agree that we should at 
> least introduce a virtio-pci feature bitmask.  I'm not inclined to 
> attempt to define a hypercall ABI or anything like that right now but 
> having the feature bitmask will at least make it possible to do such a 
> thing in the future.

No, definitely not define a hypercall ABI.  The feature bit should say 
"this device understands a hypervisor-specific way of kicking.  consult 
your hypervisor manual and cpuid bits for further details.  should you 
not be satisfied with this method, port io is still available".

>
>>> I'm wary of introducing the notion of hypercalls to this device 
>>> because it makes the device VMM specific.  Maybe we could have the 
>>> device provide an option ROM that was treated as the device "BIOS" 
>>> that we could use for kicking and interrupt acking?  Any idea of how 
>>> that would map to Windows?  Are there real PCI devices that use the 
>>> option ROM space to provide what's essentially firmware?  
>>> Unfortunately, I don't think an option ROM BIOS would map well to 
>>> other architectures.
>>>
>>>   
>>
>> The BIOS wouldn't work even on x86 because it isn't mapped to the 
>> guest address space (at least not consistently), and doesn't know the 
>> guest's programming model (16, 32, or 64-bits? segmented or flat?)
>>
>> Xen uses a hypercall page to abstract these details out. However, I'm 
>> not proposing that. Simply indicate that we support hypercalls, and 
>> use some layer below to actually send them. It is the responsibility 
>> of this layer to detect if hypercalls are present and how to call them.
>>
>> Hey, I think the best place for it is in paravirt_ops. We can even 
>> patch the hypercall instruction inline, and the driver doesn't need 
>> to know about it.
>
> Yes, paravirt_ops is attractive for abstracting the hypercall calling 
> mechanism but it's still necessary to figure out how hypercalls would 
> be identified.  I think it would be necessary to define a virtio 
> specific hypercall space and use the virtio device ID to claim subspaces.
>
> For instance, the hypercall number could be (virtio_devid << 16) | 
> (call number).  How that translates into a hypercall would then be 
> part of the paravirt_ops abstraction.  In KVM, we may have a single 
> virtio hypercall where we pass the virtio hypercall number as one of 
> the arguments or something like that.

If we don't call it a hypercall, but a virtio kick operation, we don't 
need to worry about the hypercall number or ABI.  It's just a function 
that takes an argument that's implemented differently by every 
hypervisor.  The default implementation can be a pio operation.

>>>> Make it appear as a pci function?  (though my feeling is that 
>>>> multiple mounts should be different devices; we can then hotplug 
>>>> mountpoints).
>>>>     
>>>
>>> We may run out of PCI slots though :-/
>>>   
>>
>> Then we can start selling virtio extension chassis.
>
> :-)  Do you know if there is a hard limit on the number of devices on 
> a PCI bus?  My concern was that it was limited by something stupid 
> like an 8-bit identifier.

IIRC pci slots are 8-bit, but you can have multiple buses, so 
effectively 16 bits of device address space (discounting functions which 
are likely not hot-pluggable).


-- 
error compiling committee.c: too many arguments to function

