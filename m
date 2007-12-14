Return-Path: <linux-kernel-owner+w=401wt.eu-S932565AbXLNVMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932565AbXLNVMZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 16:12:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753709AbXLNVMS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 16:12:18 -0500
Received: from host.infinivid.com ([64.119.179.76]:32891 "EHLO
	host.infinivid.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043AbXLNVMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 16:12:17 -0500
Subject: Re: PCI resource unavailable on mips
From: Jon Dufresne <jon.dufresne@infinitevideocorporation.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
In-Reply-To: <20071214093945.GA25186@linux-mips.org>
References: <1197557806.3370.7.camel@microwave.infinitevideocorporation.com>
	 <20071214093945.GA25186@linux-mips.org>
Content-Type: text/plain
Date: Fri, 14 Dec 2007 16:12:15 -0500
Message-Id: <1197666735.3800.1.camel@microwave.infinitevideocorporation.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Odd.  I knew the resource allocation stuff has it's issues for some
> non-trivial configuration but that one is a new one.  Which makes me
> wonder if your platform runs the PCI code in probe-only mode where it
> will not actually assign resources but only inherit the whole PCI setup
> except interrupt routing from the firmware.


Hmm, I found more strange behavior with the bars that may or may not be
related. I wrote a function that does another sanity check. It does an
ioremap on one of the working bars, then reads one address for
correctness. This is just to confirm that iomem is working. This is what
the function looks like:

> void dump_mmio(struct pci_dev *dev)
> {
> 	unsigned long phys, size;
> 	struct resource *mem_region;
> 	void __iomem *mmio;
> 	u32 dword;
> 
> 	phys = pci_resource_start(dev, 1);
> 	size = pci_resource_len(dev, 1);
> 
> 	mem_region = request_mem_region(phys, size, MODULENAME);
> 	BUG_ON(!mem_region);
> 	mmio = ioremap_nocache(phys, size);
> 	BUG_ON(!mmio);
> 
> 	printk("******************MMIO*************************************\n");
> 	printk("mmio=0x%p phys=0x%08lx size=0x%08lx\n", mmio, phys, size);
> 	dword = ioread32(mmio + PCI_MMIO_BASE + 0x40);
> 	printk("dword=%x\n", dword);
> 	printk("***********************************************************\n");
> 
> 	iounmap(mmio);
> 	release_mem_region(phys, size);
> }

on x86 this prints out what I would expect with the correct value which
is:

> ******************MMIO*************************************
> mmio=0xf8e80000 phys=0xefa00000 size=0x00200000
> dword=54061131
> ***********************************************************

on mips however this crashes the kernel with a "Data bus error" the
exact output is below:

> ******************MMIO*************************************
> mmio=0xc0300000 phys=0x24000000 size=0x00200000
> Data bus error, epc == c0279a00, ra == c02799f4
> Oops[#1]:
> Cpu 0
> $ 0   : 00000000 10008400 c0340040 802e031c
> $ 4   : 802e031c 802e0000 00000001 8019f924
> $ 8   : 802e0000 0000020b 80320000 80320000
> $12   : 80320000 00000001 83031be6 8031c960
> $16   : 80086994 c0300000 24000000 00200000
> $20   : 802e0000 802e1ae4 c025a000 8008cde4
> $24   : 00000006 00000000                  
> $28   : 83030000 83031d20 c0288aec c02799f4
> Hi    : 00000051
> Lo    : eb851f00
> epc   : c0279a00     Tainted: P     
> ra    : c02799f4 Status: 10008403    KERNEL EXL IE 
> Cause : 1080001c
> PrId  : 00061200
> Modules linked in: tmman1700(P) mousedev usbhid usb_storage phStbFB(P) phStbFBRead(P) phStbVideoRenderer(P) phStbVe
> Process insmod (pid: 785, threadinfo=83030000, task=8109f8e8)
> Stack : c0288b28 c0300000 24000000 00200000 810b9c54 00000003 c0290000 810b9c00
>         c0288b28 c0279ae4 83031d48 00000002 00000000 00000000 810b9c00 c0288510
>         00000000 80373480 80177520 801774e4 810b9d1c c0288544 80177574 829f6066
>         810b9d1c 810b9c48 c0288544 801a3d40 810b9d1c 801a4538 81091c00 8011fc70
>         810b9d1c 810b9c48 c0288544 c0288544 801a475c 801a475c 801a2810 80168e08
>         ...
> Call Trace:[<c0279ae4>][<80177520>][<801774e4>][<80177574>][<801a3d40>][<801a4538>][<8011fc70>][<801a475c>][<801a4]
> 
> Code: 3c020004  34420040  02221021 <8c450000> 3c04c028  0200f809  24845164  3c04c028  0200f809 
> Segmentation fault

The data bus error occurs whenever I do a ioreadX on the ioremapped area. Any idea why this doesn't work on the mips?

Thanks,
Jon

