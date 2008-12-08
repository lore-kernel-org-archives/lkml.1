Return-Path: <linux-kernel-owner+w=401wt.eu-S1754207AbYLHOrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207AbYLHOrT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 09:47:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751809AbYLHOrD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 09:47:03 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:52318 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbYLHOrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 09:47:00 -0500
Message-ID: <493D334D.6050004@us.ibm.com>
Date: Mon, 08 Dec 2008 08:46:37 -0600
From: Anthony Liguori <aliguori@us.ibm.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Mark McLoughlin <markmc@redhat.com>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
       Michael Tokarev <mjt@tls.msk.ru>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] virtio: make PCI devices take a virtio_pci module ref
References: <1228394671.3732.77.camel@blaa> <200812051043.51417.rusty@rustcorp.com.au> <1228489626.3858.37.camel@blaa> <200812071852.08962.rusty@rustcorp.com.au> <1228741409.3609.32.camel@blaa>
In-Reply-To: <1228741409.3609.32.camel@blaa>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark McLoughlin wrote:
> On Sun, 2008-12-07 at 18:52 +1030, Rusty Russell wrote:
>   
>> On Saturday 06 December 2008 01:37:06 Mark McLoughlin wrote:
>>     
>>> Another example of a lack of an explicit dependency causing problems is
>>> Fedora's mkinitrd having this hack:
>>>
>>>     if echo $PWD | grep -q /virtio-pci/ ; then
>>>         findmodule virtio_pci
>>>     fi
>>>
>>> which basically says "if this is a virtio device, don't forget to
>>> include virtio_pci in the initrd too!". Now, mkinitrd is full of hacks,
>>> but this is a particularly unusual one.
>>>       
>> Um, I don't know what this does, sorry.
>>
>> I have no idea how Fedora chooses what to put in an initrd; I can't think
>> of a sensible way of deciding what goes in and what doesn't other than
>> lists and heuristics.
>>     
>
> Fedora's mkinitrd creates an initrd suitable to boot the machine you run
> mkinitrd on, rather than creating an initrd suitable to boot any
> machine.
>
> So, it goes "ah, / is mounted from /dev/vda, we need to include
> virtio_blk and it's dependencies". It does that in a generic way that
> works well for most setups:
>
>   1) Find the device name (e.g. vda) below /sys/block
>
>   2) Follow the 'device' link to e.g. /sys/devices/virtio-pci/virtio1
>
>   3) Find the module need for this through either 'modalias' or the 
>      'driver/module' symlink
>
>   4) Use modprobe to list any dependencies of that module
>
> Clearly, virtio-pci won't be pulled in by any of this so we've added a
> hack to say "oh, it's a virtio device, let's include virtio_pci just in
> case".
>
> It's not even the case that mkinitrd needs to know how to include the
> the module for the bus, because in our case that's virtio.ko ... we've
> pretty effectively hidden the the bus *implementation* from userspace.
>
> I don't think this is worth wasting too much time fixing, that's why I'm
> thinking we should just make virtio_pci built-in by default with
> CONFIG_KVM_GUEST. 
>   

What if we have multiple virtio transports?  Is there a way that we can 
expose the relationship with virtio-blk and virtio-pci in sysfs?  We 
have a struct device for the PCI device, it's just a matter of making 
the link visible.

Regards,

Anthony Liguori

Regards,

Anthony Liguori

>> But there really is no explicit dependency between virtio modules and
>> virtio_pci.  There just is for kvm/x86 at the moment, since that is how
>> they use virtio.  Running over another bus is certainly possible,
>> though may never happen for x86 (happens today for s390).
>>     
>
> Right, and in the case of both kvm/s390 and lguest the bus
> implementation is built-in, not a module.
>
> Cheers,
> Mark.
>
>   

