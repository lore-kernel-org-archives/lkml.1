Return-Path: <linux-kernel-owner+w=401wt.eu-S1762944AbXLQPQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762944AbXLQPQm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 10:16:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754087AbXLQPQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 10:16:35 -0500
Received: from host.infinivid.com ([64.119.179.76]:38895 "EHLO
	host.infinivid.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753652AbXLQPQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 10:16:34 -0500
Subject: Re: PCI resource unavailable on mips
From: Jon Dufresne <jon.dufresne@infinitevideocorporation.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
In-Reply-To: <20071216224617.GA18613@linux-mips.org>
References: <1197557806.3370.7.camel@microwave.infinitevideocorporation.com>
	 <20071214093945.GA25186@linux-mips.org>
	 <1197666735.3800.1.camel@microwave.infinitevideocorporation.com>
	 <20071216224617.GA18613@linux-mips.org>
Content-Type: text/plain
Date: Mon, 17 Dec 2007 10:16:31 -0500
Message-Id: <1197904591.3351.5.camel@microwave.infinitevideocorporation.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I did a bit more work and investigation on this and it turns out I could
not read the mmio in kernel space because I had not done a
pci_enable_device_bars() on the device. I had never done this on x86 so
I didn't realize it was necessary.

> The virtual address 0xc0300000 looks sensible and the physical address
> 0x24000000 is consistent with what you found in the BAR registers.  So that
> all looks reasonable but that only means not obviously wrong.  So next I
> wonder what the value of PCI_MMIO_BASE is ...

The PCI_MMIO_BASE is a defined as:


> #define PCI_MMIO_BASE            (0x00040000)

This is define in the technical documentation as the offset to access
pci config space from the mmio. I am using this because I know what the
values should be so it provides a nice sanity check.


> A bus error is an exception which is signalled by agent external (often
> called system controller) to the CPU core to signal a fatal error during a
> read or write bus transaction, for example after a bus timeout or if the
> address of the read/write isn't assigned to any device.  PCI master abort
> also is often mapped to a bus error exception.

So after doing pci_enable_bars() I can now access this mmio region in
kernel space. However, if I try to mmap this into user space I still
receive the bus error. I am mapping this into user space using the
example for LDD which says to use the remap_pfn_range() function. I've
tested this on the x86 and it works as expected, however every time I
access the mmio from user space using the mips, I continue to get the
bus error I previously received in kernel space.

Any idea what I might be doing wrong? How can I access this from user
space?

Thanks,
Jon

