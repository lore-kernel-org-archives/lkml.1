Return-Path: <linux-kernel-owner+w=401wt.eu-S1756237AbXKWQwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237AbXKWQwU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 11:52:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752414AbXKWQwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 11:52:12 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:35413 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752318AbXKWQwL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 11:52:11 -0500
Message-ID: <4747051C.3090903@us.ibm.com>
Date: Fri, 23 Nov 2007 10:51:40 -0600
From: Anthony Liguori <aliguori@us.ibm.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Avi Kivity <avi@qumranet.com>
CC: kvm-devel@lists.sourceforge.net, virtualization@lists.osdl.org,
       linux-kernel@vger.kernel.org,
       Eric Van Hensbergen <ericvanhensbergen@us.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>, lguest <lguest@ozlabs.org>
Subject: Re: [kvm-devel] [PATCH 3/3] virtio PCI device
References: <11944899922822-git-send-email-aliguori@us.ibm.com>	<11944900141678-git-send-email-aliguori@us.ibm.com>	<11944900152750-git-send-email-aliguori@us.ibm.com>	<11944900163817-git-send-email-aliguori@us.ibm.com>	<4742F6B7.20503@qumranet.com>	<474300AD.4060509@us.ibm.com> <4743076F.8000105@qumranet.com> <47435CCB.1050506@us.ibm.com> <4743DAA4.70800@qumranet.com>
In-Reply-To: <4743DAA4.70800@qumranet.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> Anthony Liguori wrote:
>> Well please propose the virtio API first and then I'll adjust the PCI 
>> ABI.  I don't want to build things into the ABI that we never 
>> actually end up using in virtio :-)
>>
>>   
>
> Move ->kick() to virtio_driver.

Then on each kick, all queues have to be checked for processing?  What 
devices do you expect this would help?

> I believe Xen networking uses the same event channel for both rx and 
> tx, so in effect they're using this model.  Long time since I looked 
> though,

I would have to look, but since rx/tx are rather independent actions, 
I'm not sure that you would really save that much.  You still end up 
doing the same number of kicks unless I'm missing something.

>> I was thinking more along the lines that a hypercall-based device 
>> would certainly be implemented in-kernel whereas the current device 
>> is naturally implemented in userspace.  We can simply use a different 
>> device for in-kernel drivers than for userspace drivers.  
>
> Where the device is implemented is an implementation detail that 
> should be hidden from the guest, isn't that one of the strengths of 
> virtualization?  Two examples: a file-based block device implemented 
> in qemu gives you fancy file formats with encryption and compression, 
> while the same device implemented in the kernel gives you a 
> low-overhead path directly to a zillion-disk SAN volume.  Or a 
> user-level network device capable of running with the slirp stack and 
> no permissions vs. the kernel device running copyless most of the time 
> and using a dma engine for the rest but requiring you to be good 
> friends with the admin.
>
> The user should expect zero reconfigurations moving a VM from one 
> model to the other.

I'm wary of introducing the notion of hypercalls to this device because 
it makes the device VMM specific.  Maybe we could have the device 
provide an option ROM that was treated as the device "BIOS" that we 
could use for kicking and interrupt acking?  Any idea of how that would 
map to Windows?  Are there real PCI devices that use the option ROM 
space to provide what's essentially firmware?  Unfortunately, I don't 
think an option ROM BIOS would map well to other architectures.

>> None of the PCI devices currently work like that in QEMU.  It would 
>> be very hard to make a device that worked this way because since the 
>> order in which values are written matter a whole lot.  For instance, 
>> if you wrote the status register before the queue information, the 
>> driver could get into a funky state.
>>   
>
> I assume you're talking about restore?  Isn't that atomic?

If you're doing restore by passing the PCI config blob to a registered 
routine, then sure, but that doesn't seem much better to me than just 
having the device generate that blob in the first place (which is what 
we have today).  I was assuming that you would want to use the existing 
PIO/MMIO handlers to do restore by rewriting the config as if the guest was.

>>> Not much of an argument, I know.
>>>
>>>
>>> wrt. number of queues, 8 queues will consume 32 bytes of pci space 
>>> if all you store is the ring pfn.
>>>     
>>
>> You also at least need a num argument which takes you to 48 or 64 
>> depending on whether you care about strange formatting.  8 queues may 
>> not be enough either.  Eric and I have discussed whether the 9p 
>> virtio device should support multiple mounts per-virtio device and if 
>> so, whether each one should have it's own queue.  Any devices that 
>> supports this sort of multiplexing will very quickly start using a 
>> lot of queues.
>>   
>
> Make it appear as a pci function?  (though my feeling is that multiple 
> mounts should be different devices; we can then hotplug mountpoints).

We may run out of PCI slots though :-/

>> I think most types of hardware have some notion of a selector or 
>> mode.  Take a look at the LSI adapter or even VGA.
>>
>>   
>
> True.  They aren't fun to use, though.

I don't think they're really any worse :-)

Regards,

Anthony Liguori

