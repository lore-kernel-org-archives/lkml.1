Return-Path: <linux-kernel-owner+w=401wt.eu-S1754617AbZALLax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617AbZALLax (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 06:30:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752173AbZALLap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 06:30:45 -0500
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:53166 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751425AbZALLao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 06:30:44 -0500
Message-ID: <496B2983.2030601@gentoo.org>
Date: Mon, 12 Jan 2009 11:29:07 +0000
From: Daniel Drake <dsd@gentoo.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090101)
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: linux kernel <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       dliana@frontiernet.net
Subject: can't mmap PCI legacy_mem on Powerbook G4
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Cloudmark-Analysis: v=1.0 c=1 a=OS0xER-0kPsA:10 a=rYRRAtOZ_v4A:10 a=7mOBRU54AAAA:8 a=RatdbZoe5nFEgdrfXAoA:9 a=X38UQwwNcEXMey7HAMMA:7 a=bwFYHg0WWoeC6cfQRZ9h241LvyMA:4 a=50e4U0PicR4A:10 a=kJt0FBZS71X5YZ9Y:21 a=A_KCgd3_-toO3X4V:21
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Dave reports a 2.6.28 regression here:
https://bugs.gentoo.org/show_bug.cgi?id=253149

X (server v1.5.3) no longer starts, it aborts with a mmap() error.


This is because X tries to use sysfs pci legacy_mem to map the VGA frame 
buffer if it is available, and this became available in 2.6.28 for ppc, 
but the mmap() fails with -ENXIO.

(Arguably, xserver should fallback on the old /proc approach when mmap 
fails, we're working on that too)

The memory map for the system is:
Found UniNorth PCI host bridge at 0x00000000f0000000. Firmware bus 
number: 0->0
PCI host bridge /pci@f0000000  ranges:
   MEM 0x00000000f1000000..0x00000000f1ffffff -> 0x00000000f1000000
    IO 0x00000000f0000000..0x00000000f07fffff -> 0x0000000000000000
   MEM 0x0000000090000000..0x00000000afffffff -> 0x0000000090000000
  Found UniNorth PCI host bridge at 0x00000000f2000000. Firmware bus 
number: 0->0
PCI host bridge /pci@f2000000 (primary) ranges:
   MEM 0x00000000f3000000..0x00000000f3ffffff -> 0x00000000f3000000
    IO 0x00000000f2000000..0x00000000f27fffff -> 0x0000000000000000
   MEM 0x0000000080000000..0x000000008fffffff -> 0x0000000080000000
Found UniNorth PCI host bridge at 0x00000000f4000000. Firmware bus 
number: 0->0
PCI host bridge /pci@f4000000  ranges:
   MEM 0x00000000f5000000..0x00000000f5ffffff -> 0x00000000f5000000
    IO 0x00000000f4000000..0x00000000f47fffff -> 0x0000000000000000

Full dmesg here:
https://bugs.gentoo.org/attachment.cgi?id=178141&action=view


strace excerpt from X:
open("/sys/class/pci_bus/0000:00/legacy_mem", O_RDWR) = 9
mmap(NULL, 131072, PROT_READ|PROT_WRITE, MAP_SHARED, 9, 0xa0000) = -1 
ENXIO (No such device or address)


Confirmed with printk debugging, the code that produces the -ENXIO 
condition can be found in arch/powerpc/kernel/pci-common.c 
pci_mmap_legacy_page_range()

		if ((offset + size) > hose->isa_mem_size)
			return -ENXIO;

In this case, hose->isa_mem_size=0 (and offset=655360, size=65536)

As far as I can see, isa_mem_size only ever gets set if a PCI memory 
space is addressed to address 0, which it is not on this system (only IO 
regions get mapped there).

Is this a bug, or is mmap doing the correct thing by failing here?

Given the comment in pci-bridge.h:
	/* Some machines have a special region to forward the ISA
	 * "memory" cycles such as VGA memory regions. Left to 0
	 * if unsupported
	 */

Should this check instead be:
  if (hose->isa_mem_size && ((offset + size) > hose->isa_mem_size))  ?

cheers
Daniel
