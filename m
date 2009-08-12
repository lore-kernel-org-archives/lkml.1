Return-Path: <linux-kernel-owner+w=401wt.eu-S1754149AbZHLQL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149AbZHLQL2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 12:11:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752735AbZHLQL1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 12:11:27 -0400
Received: from relay.medianet-world.de ([213.157.0.172]:57123 "HELO
	relay.medianet-world.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752664AbZHLQL0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 12:11:26 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Aug 2009 12:11:25 EDT
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4325
Importance: normal
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
Subject: automagic udev device node creation?
Date: Wed, 12 Aug 2009 18:04:46 +0200
Message-ID: <35C3744979512D47ABD7DBA7920B2DBB091F50@HBMNTX3.hbm.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: automagic udev device node creation?
Thread-Index: AcobZpxULdQRlBsjQA6Nam75jVV/pA==
From: "Sander, Tim" <Tim.Sander@hbm.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 12 Aug 2009 16:04:46.0114 (UTC) FILETIME=[9C958820:01CA1B66]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I have written a simple mmap test driver which seems to work so far.=20
The only problem i have, is that no udev device node is automatically =
created?=20
So i really would like to know what part is missing to make udev =
automatically create
the device node?

Everything works alright if i just create the device node by hand.

I suspect that these should be created out of the sysfs information =
created by the module.

I am not on the list, so please cc.

Thanks
Tim

Start of file:
/*
 * Memory Map Test Kernel Part
 *
 * 2009 (C) Tim Sander <tim.sander@hbm.com>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License Version
 * 2 as published by the Free Software Foundation.
 *
 */

#include <mach/hardware.h>
#include <linux/init.h>
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/fs.h>
#include <linux/cdev.h>
#include <asm/uaccess.h>
#include <asm/io.h>
#include <linux/interrupt.h>
#include <linux/sched.h>
#include <linux/mm.h>
#include <linux/platform_device.h>

/* generic values of CSCRXU (Chip Select Control Register X Upper) */
/* (bit_mask & value) << position */
#define CSCRXU_SP(val)   ( 0x1 & val) << 31
#define CSCRXU_WP(val)   ( 0x1 & val) << 30
#define CSCRXU_BCD(val)  ( 0x3 & val) << 28
#define CSCRXU_BCS(val)  ( 0xf & val) << 24
#define CSCRXU_PSZ(val)  ( 0x3 & val) << 22
#define CSCRXU_PME(val)  ( 0x1 & val) << 21
#define CSCRXU_SYNC(val) ( 0x1 & val) << 20
#define CSCRXU_DOL(val)  ( 0xf & val) << 16
#define CSCRXU_CNC(val)  ( 0x3 & val) << 14
#define CSCRXU_WSC(val)  (0x3f & val) <<  8
#define CSCRXU_EW(val)   ( 0x1 & val) <<  7
#define CSCRXU_WWS(val)  ( 0x7 & val) <<  4
#define CSCRXU_EDC(val)  ( 0xf & val) <<  0

/* generic values of CSCRXL (Chip Select Control Register X Lower) */
#define CSCRXL_OEA(val)  ( 0xf & val) << 28
#define CSCRXL_OEN(val)  ( 0xf & val) << 24
#define CSCRXL_EBWA(val) ( 0xf & val) << 20
#define CSCRXL_EBWN(val) ( 0xf & val) << 16
#define CSCRXL_CSA(val)  ( 0xf & val) << 12
#define CSCRXL_EBC(val)  ( 0x1 & val) << 11
#define CSCRXL_DSZ(val)  ( 0x7 & val) <<  8
#define CSCRXL_CSN(val)  ( 0xf & val) <<  4
#define CSCRXL_PSR(val)  ( 0x1 & val) <<  3
#define CSCRXL_CRE(val)  ( 0x1 & val) <<  2
#define CSCRXL_WRAP(val) ( 0x1 & val) <<  1
#define CSCRXL_CSEN(val) ( 0x1 & val) <<  0

/* generic values of CSCRXA (Chip Select Control Register X Additional) */
#define CSCRXA_EBRA(val) ( 0xf & val) << 28
#define CSCRXA_EBRN(val) ( 0xf & val) << 24
#define CSCRXA_RWA(val)  ( 0xf & val) << 20
#define CSCRXA_RWN(val)  ( 0xf & val) << 16
#define CSCRXA_MUM(val)  ( 0x1 & val) << 15
#define CSCRXA_LAH(val)  ( 0x3 & val) << 13
#define CSCRXA_LBN(val)  ( 0x7 & val) << 10
#define CSCRXA_LBA(val)  ( 0x3 & val) <<  8
#define CSCRXA_DWW(val)  ( 0x3 & val) <<  6
#define CSCRXA_DCT(val)  ( 0x3 & val) <<  4
#define CSCRXA_WWU(val)  ( 0x1 & val) <<  3
#define CSCRXA_AGE(val)  ( 0x3 & val) <<  2
#define CSCRXA_CNC2(val) ( 0x1 & val) <<  1
#define CSCRXA_FCE(val)  ( 0x1 & val) <<  0

/* Chip Select 5: CSCR5U value */
#define CSCR5U_VAL  0 \
    | CSCRXU_SP(0)  \
    | CSCRXU_WP(0)  \
    | CSCRXU_BCD(0) \
    | CSCRXU_BCS(0) \
    | CSCRXU_PSZ(3) \
    | CSCRXU_PME(0) \
    | CSCRXU_SYNC(0)\
    | CSCRXU_DOL(2) \
    | CSCRXU_CNC(3) \
    | CSCRXU_WSC(8) \
    | CSCRXU_EW(0)  \
    | CSCRXU_WWS(0) \
    | CSCRXU_EDC(0)

/* Chip Select 5: CSCR5L value */
#define CSCR5L_VAL  0 \
    | CSCRXL_OEA(0) \
    | CSCRXL_OEN(2) \
    | CSCRXL_EBWA(0)\
    | CSCRXL_EBWN(0)\
    | CSCRXL_CSA(0) \
    | CSCRXL_EBC(0) \
    | CSCRXL_DSZ(5) \
    | CSCRXL_CSN(0) \
    | CSCRXL_PSR(0) \
    | CSCRXL_CRE(0) \
    | CSCRXL_WRAP(0)\
    | CSCRXL_CSEN(1)

/* Chip Select 5: CSCR5A value */
#define CSCR5A_VAL  0 \
    | CSCRXA_EBRA(1)\
    | CSCRXA_EBRN(0)\
    | CSCRXA_RWA(0) \
    | CSCRXA_RWN(0) \
    | CSCRXA_MUM(0) \
    | CSCRXA_LAH(0) \
    | CSCRXA_LBN(2) \
    | CSCRXA_LBA(0) \
    | CSCRXA_DWW(0) \
    | CSCRXA_DCT(0) \
    | CSCRXA_WWU(0) \
    | CSCRXA_AGE(0) \
    | CSCRXA_CNC2(0)\
    | CSCRXA_FCE(1)

/* permanent Burst Clock Mode enable */
#define BCM_VAL 0

#define MMAP_MEMSIZE	128*1024

#define WCR	IO_ADDRESS(0xB8002060)

#define CSCR0U	IO_ADDRESS(0xB8002000)
#define CSCR1U	IO_ADDRESS(0xB8002010)
#define CSCR2U	IO_ADDRESS(0xB8002020)
#define CSCR3U	IO_ADDRESS(0xB8002030)
#define CSCR4U	IO_ADDRESS(0xB8002040)
#define CSCR5U	IO_ADDRESS(0xB8002050)

#define CSCR0L	IO_ADDRESS(0xB8002004)
#define CSCR1L	IO_ADDRESS(0xB8002014)
#define CSCR2L	IO_ADDRESS(0xB8002024)
#define CSCR3L	IO_ADDRESS(0xB8002034)
#define CSCR4L	IO_ADDRESS(0xB8002044)
#define CSCR5L	IO_ADDRESS(0xB8002054)

#define CSCR0A	IO_ADDRESS(0xB8002008)
#define CSCR1A	IO_ADDRESS(0xB8002018)
#define CSCR2A	IO_ADDRESS(0xB8002028)
#define CSCR3A	IO_ADDRESS(0xB8002038)
#define CSCR4A	IO_ADDRESS(0xB8002048)
#define CSCR5A	IO_ADDRESS(0xB8002058)

/*
0xA0000000 â€¦ 0xA7FF_FFFF CS0 memory region R/W = 128MB
0xA8000000 â€¦ 0xAFFF_FFFF CS1 memory region R/W = 128MB
0xB0000000 â€¦ 0xB1FF_FFFF CS2 memory region R/W =  32MB
0xB2000000 â€¦ 0xB3FF_FFFF CS3 memory region R/W =  32MB
0xB4000000 â€¦ 0xB5FF_FFFF CS4 memory region R/W =  32MB
0xB6000000 â€¦ 0xB7FF_FFFF CS5 memory region R/W =  32MB
*/

#define PHYS_MEM_POS	0xB6000000

static int hbm_mmap_count=1;
static dev_t hbm_mmap_dev;
static struct cdev hbm_mmap_cdev;
static struct platform_device *platform_device;

static struct attribute *hbm_attributes[] = {
	NULL
};

static struct attribute_group hbm_attribute_group = {
	.attrs = hbm_attributes
};

static ssize_t hbm_mmap_read(struct file *file, char __user *buf, size_t count, loff_t * ppos);
static ssize_t hbm_mmap_write(struct file *file, const char __user *buf, size_t count, loff_t * ppos);
static int hbm_mmap_mmap(struct file *file, struct vm_area_struct *vma);
static struct file_operations hbm_mmap_fops =
{
	.owner = THIS_MODULE,
	.read = hbm_mmap_read,
	.write = hbm_mmap_write,
	.mmap = hbm_mmap_mmap,
};

static struct platform_driver hbm_mmap_driver=
{	
	.driver	= {
		.name = "hbm",
		.owner = THIS_MODULE,
	}
};

static int hbm_mmap_mmap(struct file *file, struct vm_area_struct *vma) {
	int size=vma->vm_end-vma->vm_start;
	if(size>MMAP_MEMSIZE) {
		return -EINVAL;
	}

	vma->vm_flags |= VM_IO |VM_RESERVED;
	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
	if(remap_pfn_range(vma, vma->vm_start, __pa(PHYS_MEM_POS)>>PAGE_SHIFT, size, vma->vm_page_prot)) {
	//if(remap_pfn_range(vma, vma->vm_start, IO_ADDRESS(PHYS_MEM_POS), size, vma->vm_page_prot)) {
		return -EAGAIN;
	};
	return 0;
}

static ssize_t hbm_mmap_read(struct file *file, char __user *buf, size_t count, loff_t * ppos) {
	return -EINVAL;
}

static ssize_t hbm_mmap_write(struct file *file, const char __user *buf, size_t count, loff_t * ppos) {
	/* no writes on device for the time beeing */
	return -EROFS; //RO FS	
}

static int __init hbm_mmap_init(void) {
	int err;
	if(alloc_chrdev_region(&hbm_mmap_dev, 0, hbm_mmap_count, "hbm%d")) {
		err=-ENODEV;
		goto err_exit;
	}
	cdev_init(&hbm_mmap_cdev, &hbm_mmap_fops);
	if(cdev_add(&hbm_mmap_cdev, hbm_mmap_dev,hbm_mmap_count)) {
		err=-ENODEV;
		goto err_dev_unregister;
	}
	if(platform_driver_register(&hbm_mmap_driver)!=0) {
		err=-ENODEV;
		goto err_cdev_unregister;
	}
	platform_device=platform_device_alloc("hbm%d",-1);
	if (!platform_device) {
                err = -ENOMEM;
                goto err_platform_device_alloc;
        }
	if(platform_device_add(platform_device)) {
		goto err_platform_device_add;
	}
	if(sysfs_create_group(&platform_device->dev.kobj, &hbm_attribute_group)) {
		err= -ENODEV;
		goto err_create_group;
	}
	printk(KERN_INFO "hbm mmap loaded successfully\n");
	/* 
		__raw_writel fÃ¼r 32 bit
		__raw_writew fÃ¼r 16 bit
		__raw_writeb fÃ¼r 8  bit zugriffe 
		read equivalent
	 */

	/* Hier werden die Register fÃ¼r CS5 gesetzt */
	/*
	reg=__raw_readl(WCR);
	reg|=(BCM_VAL<<2);
	__raw_writel(reg,WCR); */ /* BCLK enable ist bÃ¶se aka unstabil*/
	
	__raw_writel(CSCR5U_VAL,CSCR5U); /* CS 5 setup */
	__raw_writel(CSCR5L_VAL,CSCR5L);
	__raw_writel(CSCR5A_VAL,CSCR5A);
	
   printk(KERN_INFO "WEIM registers set up:\n");
   printk(KERN_INFO "CSCR5U_VAL = 0x%x\n", CSCR5U_VAL);
   printk(KERN_INFO "CSCR5L_VAL = 0x%x\n", CSCR5L_VAL);
   printk(KERN_INFO "CSCR5A_VAL = 0x%x\n", CSCR5A_VAL);
   printk(KERN_INFO "BCM_VAL = %x\n", BCM_VAL);
	return 0;
	err_create_group:
		platform_device_unregister(platform_device);
	err_platform_device_add:
		platform_device_put(platform_device);
	err_platform_device_alloc:
		platform_driver_unregister(&hbm_mmap_driver);
	err_cdev_unregister:
		cdev_del(&hbm_mmap_cdev);
	err_dev_unregister:
		unregister_chrdev_region(hbm_mmap_dev, hbm_mmap_count);
	err_exit:
		return err;
}

static void __exit hbm_mmap_exit(void) {
	unsigned int reg;
	sysfs_remove_group(&platform_device->dev.kobj, &hbm_attribute_group);
	platform_device_unregister(platform_device);
	platform_driver_unregister(&hbm_mmap_driver);
	cdev_del(&hbm_mmap_cdev);
	unregister_chrdev_region(hbm_mmap_dev, hbm_mmap_count);
	reg=__raw_readl(WCR);
	reg&=~(BCM_VAL<<2);
	__raw_writel(reg,WCR); //BCLK enable
	printk(KERN_ALERT "hbm mmap unloaded\n");
}

module_init(hbm_mmap_init);
module_exit(hbm_mmap_exit);
MODULE_LICENSE("GPL");
MODULE_DESCRIPTION("hbm memory map test");
MODULE_AUTHOR("Tim Sander");
MODULE_ALIAS("platform:hbm");

EOF

Hottinger Baldwin Messtechnik GmbH, Im Tiefen See 45, 64293 Darmstadt, Germany | www.hbm.com 

Registered as GmbH (German limited liability corporation) in the commercial register at the local court of Darmstadt, HRB 1147  
Company domiciled in Darmstadt | CEO: Andreas Huellhorst | Chairman of the board: James Charles Webster

Als Gesellschaft mit beschraenkter Haftung eingetragen im Handelsregister des Amtsgerichts Darmstadt unter HRB 1147 
Sitz der Gesellschaft: Darmstadt | Geschaeftsfuehrung: Andreas Huellhorst | Aufsichtsratsvorsitzender: James Charles Webster

The information in this email is confidential. It is intended solely for the addressee. If you are not the intended recipient, please let me know and delete this email.

Die in dieser E-Mail enthaltene Information ist vertraulich und lediglich für den Empfaenger bestimmt. Sollten Sie nicht der eigentliche Empfaenger sein, informieren Sie mich bitte kurz und loeschen diese E-Mail.

