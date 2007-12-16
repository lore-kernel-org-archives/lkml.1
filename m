Return-Path: <linux-kernel-owner+w=401wt.eu-S1765648AbXLPWtu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765648AbXLPWtu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 17:49:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761394AbXLPWtm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 17:49:42 -0500
Received: from ftp.linux-mips.org ([194.74.144.162]:33153 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758275AbXLPWtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 17:49:41 -0500
Date: Sun, 16 Dec 2007 22:46:17 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Jon Dufresne <jon.dufresne@infinitevideocorporation.com>
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
Subject: Re: PCI resource unavailable on mips
Message-ID: <20071216224617.GA18613@linux-mips.org>
References: <1197557806.3370.7.camel@microwave.infinitevideocorporation.com> <20071214093945.GA25186@linux-mips.org> <1197666735.3800.1.camel@microwave.infinitevideocorporation.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1197666735.3800.1.camel@microwave.infinitevideocorporation.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2007 at 04:12:15PM -0500, Jon Dufresne wrote:

> Hmm, I found more strange behavior with the bars that may or may not be
> related. I wrote a function that does another sanity check. It does an
> ioremap on one of the working bars, then reads one address for
> correctness. This is just to confirm that iomem is working. This is what
> the function looks like:
> 
> > void dump_mmio(struct pci_dev *dev)
> > {
> > 	unsigned long phys, size;
> > 	struct resource *mem_region;
> > 	void __iomem *mmio;
> > 	u32 dword;
> > 
> > 	phys = pci_resource_start(dev, 1);
> > 	size = pci_resource_len(dev, 1);
> > 
> > 	mem_region = request_mem_region(phys, size, MODULENAME);
> > 	BUG_ON(!mem_region);
> > 	mmio = ioremap_nocache(phys, size);
> > 	BUG_ON(!mmio);
> > 
> > 	printk("******************MMIO*************************************\n");
> > 	printk("mmio=0x%p phys=0x%08lx size=0x%08lx\n", mmio, phys, size);
> > 	dword = ioread32(mmio + PCI_MMIO_BASE + 0x40);
> > 	printk("dword=%x\n", dword);
> > 	printk("***********************************************************\n");
> > 
> > 	iounmap(mmio);
> > 	release_mem_region(phys, size);
> > }
> 
> on x86 this prints out what I would expect with the correct value which
> is:
> 
> > ******************MMIO*************************************
> > mmio=0xf8e80000 phys=0xefa00000 size=0x00200000
> > dword=54061131
> > ***********************************************************
> 
> on mips however this crashes the kernel with a "Data bus error" the
> exact output is below:
> 
> > ******************MMIO*************************************
> > mmio=0xc0300000 phys=0x24000000 size=0x00200000

The virtual address 0xc0300000 looks sensible and the physical address
0x24000000 is consistent with what you found in the BAR registers.  So that
all looks reasonable but that only means not obviously wrong.  So next I
wonder what the value of PCI_MMIO_BASE is ...

> > Cpu 0
> > $ 0   : 00000000 10008400 c0340040 802e031c
> > $ 4   : 802e031c 802e0000 00000001 8019f924
> > $ 8   : 802e0000 0000020b 80320000 80320000
> > $12   : 80320000 00000001 83031be6 8031c960
> > $16   : 80086994 c0300000 24000000 00200000
> > $20   : 802e0000 802e1ae4 c025a000 8008cde4
> > $24   : 00000006 00000000                  
> > $28   : 83030000 83031d20 c0288aec c02799f4
> > Hi    : 00000051
> > Lo    : eb851f00
> > epc   : c0279a00     Tainted: P     
> > ra    : c02799f4 Status: 10008403    KERNEL EXL IE 
> > Cause : 1080001c
> > PrId  : 00061200
> > Modules linked in: tmman1700(P) mousedev usbhid usb_storage phStbFB(P) phStbFBRead(P) phStbVideoRenderer(P) phStbVe
> > Process insmod (pid: 785, threadinfo=83030000, task=8109f8e8)
> > Stack : c0288b28 c0300000 24000000 00200000 810b9c54 00000003 c0290000 810b9c00
> >         c0288b28 c0279ae4 83031d48 00000002 00000000 00000000 810b9c00 c0288510
> >         00000000 80373480 80177520 801774e4 810b9d1c c0288544 80177574 829f6066
> >         810b9d1c 810b9c48 c0288544 801a3d40 810b9d1c 801a4538 81091c00 8011fc70
> >         810b9d1c 810b9c48 c0288544 c0288544 801a475c 801a475c 801a2810 80168e08
> >         ...
> > Call Trace:[<c0279ae4>][<80177520>][<801774e4>][<80177574>][<801a3d40>][<801a4538>][<8011fc70>][<801a475c>][<801a4]
> > 
> > Code: 3c020004  34420040  02221021 <8c450000> 3c04c028  0200f809  24845164  3c04c028  0200f809 
> > Segmentation fault
> 
> The data bus error occurs whenever I do a ioreadX on the ioremapped area. Any idea why this doesn't work on the mips?

A bus error is an exception which is signalled by agent external (often
called system controller) to the CPU core to signal a fatal error during a
read or write bus transaction, for example after a bus timeout or if the
address of the read/write isn't assigned to any device.  PCI master abort
also is often mapped to a bus error exception.

  Ralf
