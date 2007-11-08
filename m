Return-Path: <linux-kernel-owner+w=401wt.eu-S1761970AbXKHWc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761970AbXKHWc4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 17:32:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761222AbXKHWcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 17:32:47 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:13117 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758366AbXKHWcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 17:32:46 -0500
Message-ID: <47338EA0.6050100@codemonkey.ws>
Date: Thu, 08 Nov 2007 16:33:04 -0600
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Anthony Liguori <aliguori@us.ibm.com>, lguest <lguest@ozlabs.org>,
       linux-kernel@vger.kernel.org, Dor Laor <dor.laor@qumranet.com>,
       virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] virtio config_ops refactoring
References: <4730A8F3.6020008@us.ibm.com> <200711081320.35844.rusty__6233.15023626692$1194488552$gmane$org@rustcorp.com.au> <4732774C.6020903@codemonkey.ws> <200711090924.28659.rusty@rustcorp.com.au>
In-Reply-To: <200711090924.28659.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Thursday 08 November 2007 13:41:16 Anthony Liguori wrote:
>   
>> Rusty Russell wrote:
>>     
>>> On Thursday 08 November 2007 04:30:50 Anthony Liguori wrote:
>>>       
>>>> I would prefer that the virtio API not expose a little endian standard.
>>>> I'm currently converting config->get() ops to ioreadXX depending on the
>>>> size which already does the endianness conversion for me so this just
>>>> messes things up.  I think it's better to let the backend deal with
>>>> endianness since it's trivial to handle for both the PCI backend and the
>>>> lguest backend (lguest doesn't need to do any endianness conversion).
>>>>         
>>> -ETOOMUCHMAGIC.  We should either expose all the XX interfaces (but this
>>> isn't a high-speed interface, so let's not) or not "sometimes" convert
>>> endianness. Getting surprises because a field happens to be packed into 4
>>> bytes is counter-intuitive.
>>>       
>> Then I think it's necessary to expose the XX interfaces.  Otherwise, the
>> backend has to deal with doing all register operations at a per-byte
>> granularity which adds a whole lot of complexity on a per-device basis
>> (as opposed to a little complexity once in the transport layer).
>>     
>
> Huh?  Take a look at the drivers, this simply isn't true.  Do you have 
> evidence that it will be true later?
>   

I'm a bit confused.  So right now, the higher level virtio functions do 
endianness conversion.  I really want to make sure that if a guest tries 
to read a 4-byte PCI config field, that it does so using an "outl" 
instruction so that in my QEMU backend, I don't have to deal with a 
guest reading/writing a single byte within a 4-byte configuration 
field.  It's the difference between having in the PIO handler:

switch (addr) {
case VIRTIO_BLK_CONFIG_MAX_SEG:
    return vdev->max_seg;
case VIRTIO_BLK_CONFIG_MAX_SIZE:
    return vdev->max_size;
....
}

and:

switch (addr) {
case VIRTIO_BLK_CONFIG_MAX_SEG:
   return vdev->max_seg & 0xFF;
case VIRTIO_BLK_CONFIG_MAX_SEG + 1:
   return (vdev->max_seg >> 8) & 0xFF;
case VIRTIO_BLK_CONFIG_MAX_SEG + 2:
   return (vdev->max_seg >> 16) & 0xFF;
case VIRTIO_BLK_CONFIG_MAX_SEG + 3:
   return (vdev->max_seg >> 24) & 0xFF;
case VIRTIO_BLK_CONFIG_MAX_SIZE:
   return vdev->max_size & 0xFF;
case VIRTIO_BLK_CONFIG_MAX_SIZE + 1:
   return (vdev->max_size >> 8) & 0xFF;
case VIRTIO_BLK_CONFIG_MAX_SIZE + 2:
   return (vdev->max_size >> 16) & 0xFF;
case VIRTIO_BLK_CONFIG_MAX_SIZE + 3:
   return (vdev->max_size >> 24) & 0xFF;
...
}


It's the host-side code I'm concerned about, not the guest-side code.  
I'm happy to just ignore the whole endianness conversion thing and 
always pass values through in the CPU bitness but it's very important to 
me that the PCI config registers are accessed with their natural sized 
instructions (just as they would with a real PCI device).

Regards,

Anthony Liguori

> Plus your code will be smaller doing a single writeb/readb loop than trying to 
> do a switch statement.
>
>   
>> You really want to be able to rely on multi-byte atomic operations too
>> when setting values.  Otherwise, you need another register to just to
>> signal when it's okay for the device to examine any given register.
>>     
>
> You already do; the status register fills this role.  For example, you can't 
> tell what features a guest understands until it updates the status register.
>
> Hope that clarifies,
> Rusty.
>
>   

