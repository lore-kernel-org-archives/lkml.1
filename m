Return-Path: <linux-kernel-owner+w=401wt.eu-S1761455AbXLRSLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761455AbXLRSLv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 13:11:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754005AbXLRSLn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 13:11:43 -0500
Received: from host.infinivid.com ([64.119.179.76]:60224 "EHLO
	host.infinivid.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273AbXLRSLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 13:11:42 -0500
Subject: Re: PCI resource unavailable on mips
From: Jon Dufresne <jon.dufresne@infinitevideocorporation.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org
In-Reply-To: <476699FA.5050606@ru.mvista.com>
References: <1197557806.3370.7.camel@microwave.infinitevideocorporation.com>
	 <20071214093945.GA25186@linux-mips.org>
	 <1197666735.3800.1.camel@microwave.infinitevideocorporation.com>
	 <20071216224617.GA18613@linux-mips.org>
	 <1197904591.3351.5.camel@microwave.infinitevideocorporation.com>
	 <476699FA.5050606@ru.mvista.com>
Content-Type: text/plain
Date: Tue, 18 Dec 2007 13:11:10 -0500
Message-Id: <1198001470.3382.8.camel@microwave.infinitevideocorporation.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>     Your example doesn't make sense to me so far.

Ok, I simplified my driver down to one small C file that does exactly
what I want, and that is it. Below is my driver under "driver.c" and the
user space program I am using to access it under "user-test.c".

When I insmod this driver under mips, it correctly prints out the PCI
config space by accessing it through the chip's mmio (which is provided
by BAR1), using the offset 0x00040000 as described in the technical
manual. This works correctly. This is the block of memory you see
printed out in the dmesg below.

When I run the user space program, however, I try to print out the same
data through the mmap. This causes a Bus Error which I put the output of
below.

I am very confused by this. I can read the memory in kernel space, but
not user space. This driver works as expected under x86, which only
confuses me further.

Any ideas what I am doing wrong?

I've been starring at this for quite some time. Please feel free to give
me any and all critiques on my code, it will only help towards solving
this problem.

Thanks for the help!

------driver.c----------
#include <linux/module.h>
#include <linux/fs.h>
#include <linux/cdev.h>
#include <linux/pci.h>

#define MODULE_NAME "tmexp"
#define PCI_DEVICE_ID_PHILIPS_PNX1700 0x5406

#define MMIO_PCI_BASE 0x00040000


static int pnx1700_mmap(struct file *filp, struct vm_area_struct *vma);

static int pnx1700_probe(struct pci_dev *dev, const struct pci_device_id
*id);
static void pnx1700_remove(struct pci_dev *dev);


struct pnx1700 {
	dev_t devno;
	struct cdev cdev;

	struct pci_dev *pci_dev;

	void __iomem *mmio;
};

struct pnx1700 tmexp;

static struct pci_device_id pnx1700_ids[] = {
	{ PCI_DEVICE(PCI_VENDOR_ID_PHILIPS, PCI_DEVICE_ID_PHILIPS_PNX1700) },
	{ 0, }
};

static struct pci_driver pnx1700_pci_driver = {
	.name = MODULE_NAME,
	.id_table = pnx1700_ids,
	.probe = pnx1700_probe,
	.remove = pnx1700_remove,
};

static struct file_operations pnx1700_fops = {
	.owner = THIS_MODULE,
	.mmap = pnx1700_mmap,
};

static int pnx1700_mmap(struct file *filp, struct vm_area_struct *vma)
{
	unsigned long off = vma->vm_pgoff << PAGE_SHIFT;
	unsigned long physical = pci_resource_start(tmexp.pci_dev, 1) + off;
	unsigned long vsize = vma->vm_end - vma->vm_start;
	unsigned long psize = pci_resource_len(tmexp.pci_dev, 1) - off;

	BUG_ON(vsize > psize);
	return io_remap_pfn_range(vma, vma->vm_start,
			physical >> PAGE_SHIFT,
			vsize, vma->vm_page_prot);
}

static void dump_pci_mmio(void __iomem *mmio)
{
	int i;
	u8 mem[16];
	for(i = 0; i < 0x100; i += 0x10) {
		memcpy_fromio(mem, mmio + MMIO_PCI_BASE + 0x40 + i, 16);
		printk("%02x: %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %
02x %02x %02x %02x %02x\n",
			i, mem[0], mem[1], mem[2], mem[3], mem[4], mem[5], mem[6], mem[7],
mem[8], mem[9], mem[10], mem[11], mem[12], mem[13], mem[14], mem[15]);
	}
}

static int pnx1700_probe(struct pci_dev *dev, const struct pci_device_id
*id)
{
	int err;
	struct resource *resource;
	unsigned long start = pci_resource_start(dev, 1);
	unsigned long len = pci_resource_len(dev, 1);

	tmexp.pci_dev = dev;

	err = pci_enable_device(dev);
	BUG_ON(err);
	err = pci_enable_device_bars(dev, 0x7);
	BUG_ON(err);

	resource = request_mem_region(start, len, MODULE_NAME);
	BUG_ON(!resource);
	tmexp.mmio = ioremap(start, len);
	BUG_ON(!tmexp.mmio);
	dump_pci_mmio(tmexp.mmio);

	return 0;
}

static void pnx1700_remove(struct pci_dev *dev)
{
	unsigned long start = pci_resource_start(dev, 1);
	unsigned long len = pci_resource_len(dev, 1);

	iounmap(tmexp.mmio);
	release_mem_region(start, len);
}

static int __init tmexp_init(void)
{
	int err;

	memset(&tmexp, 0, sizeof(struct pnx1700));

	err = pci_register_driver(&pnx1700_pci_driver);
	BUG_ON(err);

	alloc_chrdev_region(&tmexp.devno, 0, 1, MODULE_NAME);
	cdev_init(&tmexp.cdev, &pnx1700_fops);
	tmexp.cdev.owner = THIS_MODULE;
	err = cdev_add(&tmexp.cdev, tmexp.devno, 1);
	BUG_ON(err);
	return 0;
}

static void __exit tmexp_exit(void)
{
	cdev_del(&tmexp.cdev);
	unregister_chrdev_region(tmexp.devno, 1);
	pci_unregister_driver(&pnx1700_pci_driver);
}

module_init(tmexp_init);
module_exit(tmexp_exit);
----------------


-------user-test.c----------
#include <fcntl.h>
#include <sys/mman.h>
#include <unistd.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>

#define PCI_MMIO_BASE            (0x00040000)

static void dump_mem(void const *src, int offset, int size);
static void sanity_check(void const *mmio);

int main(int argc, char *argv[])
{
	int fd;
	void *mmio;


	fd = open("/dev/pnx1700", O_RDWR);
	mmio = mmap(0, 0x00200000, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);

	printf("stuff mapped ready to test\n");
	sanity_check(mmio);
	dump_mem(mmio, PCI_MMIO_BASE + 0x40, 0x100);

	munmap(mmio, 0x00200000);
	close(fd);
	return 0;
}

static void dump_mem(void const *src, int offset, int size)
{
	int i;
	unsigned char mem[16];

	for(i = 0; i < size; i += 0x10) {
		memcpy(mem, src + offset + i, 16);
		printf("%02x: %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %
02x %02x %02x %02x %02x\n",
			i, mem[0], mem[1], mem[2], mem[3], mem[4], mem[5], mem[6], mem[7],
mem[8], mem[9], mem[10], mem[11], mem[12], mem[13], mem[14], mem[15]);
	}
}

static void sanity_check(void const *mmio)
{
	uint32_t dword;

	dword = *((uint32_t *)(mmio + PCI_MMIO_BASE + 0x40));
	printf("dword=0x%x\n", dword);
}
-------------


-----output-----
 # ./load_driver 
PCI: Enabling device 0000:00:0c.0 (0000 -> 0002)
00: 31 11 06 54 02 00 90 82 00 00 80 04 00 00 00 00
10: 08 00 00 20 00 00 00 24 00 00 00 1c 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 36 11 17 00
30: 00 00 00 00 40 00 00 00 00 00 00 00 00 01 09 18
40: 01 00 02 00 00 00 00 00 00 00 00 00 03 02 07 00
50: 06 18 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
10.41.1.162 # ./user-test 
stuff mapped reaData bus error, epc == 00400a24, ra == 004007f4
dy to test
Bus error
10.41.1.162 # dmesg
<4>PCI: Enabling device 0000:00:0c.0 (0000 -> 0002)
<4>00: 31 11 06 54 02 00 90 82 00 00 80 04 00 00 00 00
<4>10: 08 00 00 20 00 00 00 24 00 00 00 1c 00 00 00 00
<4>20: 00 00 00 00 00 00 00 00 00 00 00 00 36 11 17 00
<4>30: 00 00 00 00 40 00 00 00 00 00 00 00 00 01 09 18
<4>40: 01 00 02 00 00 00 00 00 00 00 00 00 03 02 07 00
<4>50: 06 18 00 00 00 00 00 00 00 00 00 00 00 00 00 00
<4>60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
<4>70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
<4>80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
<4>90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
<4>a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
<4>b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
<4>c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
<4>d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
<4>e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
<4>f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
<1>Data bus error, epc == 00400a24, ra == 004007f4
-----------

