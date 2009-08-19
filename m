Return-Path: <linux-kernel-owner+w=401wt.eu-S1751603AbZHSAor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751603AbZHSAor (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 20:44:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751140AbZHSAoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 20:44:46 -0400
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:58938 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847AbZHSAop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 20:44:45 -0400
Date: Tue, 18 Aug 2009 17:44:45 -0700
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
Message-ID: <20090819004445.GB11168@ovro.caltech.edu>
References: <20090818084606.GA13878@redhat.com> <20090818155329.GD31060@ovro.caltech.edu> <4A8ADC09.3030205@redhat.com> <20090818172752.GC17631@ovro.caltech.edu> <4A8AE918.5000109@redhat.com> <20090818182735.GD17631@ovro.caltech.edu> <4A8AF880.6080704@redhat.com> <20090818205919.GA1168@ovro.caltech.edu> <4A8B1C7F.4060008@redhat.com> <4A8B25F5.7050806@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A8B25F5.7050806@redhat.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (ovro.ovro.caltech.edu); Tue, 18 Aug 2009 17:44:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 19, 2009 at 01:06:45AM +0300, Avi Kivity wrote:
> On 08/19/2009 12:26 AM, Avi Kivity wrote:
>>>
>>> Off the top of my head, I would think that transporting userspace
>>> addresses in the ring (for copy_(to|from)_user()) vs. physical addresses
>>> (for DMAEngine) might be a problem. Pinning userspace pages into memory
>>> for DMA is a bit of a pain, though it is possible.
>>
>>
>> Oh, the ring doesn't transport userspace addresses.  It transports  
>> guest addresses, and it's up to vhost to do something with them.
>>
>> Currently vhost supports two translation modes:
>>
>> 1. virtio address == host virtual address (using copy_to_user)
>> 2. virtio address == offsetted host virtual address (using copy_to_user)
>>
>> The latter mode is used for kvm guests (with multiple offsets,  
>> skipping some details).
>>
>> I think you need to add a third mode, virtio address == host physical  
>> address (using dma engine).  Once you do that, and wire up the  
>> signalling, things should work.
>
>
> You don't need in fact a third mode.  You can mmap the x86 address space  
> into your ppc userspace and use the second mode.  All you need then is  
> the dma engine glue and byte swapping.
>

Hmm, I'll have to think about that.

The ppc is a 32-bit processor, so it has 4GB of address space for
everything, including PCI, SDRAM, flash memory, and all other
peripherals.

This is exactly like 32bit x86, where you cannot have a PCI card that
exposes a 4GB PCI BAR. The system would have no address space left for
its own SDRAM.

On my x86 computers, I only have 1GB of physical RAM, and so the ppc's
have plenty of room in their address spaces to map the entire x86 RAM
into their own address space. That is exactly what I do now. Accesses to
ppc physical address 0x80000000 "magically" hit x86 physical address
0x0.

Ira
