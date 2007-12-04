Return-Path: <linux-kernel-owner+w=401wt.eu-S1752557AbXLDTfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557AbXLDTfW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 14:35:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751434AbXLDTfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 14:35:10 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57822 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751331AbXLDTfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 14:35:07 -0500
Date: Tue, 4 Dec 2007 11:33:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-kernel@vger.kernel.org, thomas.mingarelli@hp.com
Subject: Re: [WATCHDOG] HP ProLiant WatchDog driver
Message-Id: <20071204113359.a45151cc.akpm@linux-foundation.org>
In-Reply-To: <20071204184310.GE2668@infomag.infomag.iguana.be>
References: <20071204184310.GE2668@infomag.infomag.iguana.be>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Dec 2007 19:43:10 +0100
Wim Van Sebroeck <wim@iguana.be> wrote:

> Hi Andrew,
> 
> Can you review the below new driver?
> For me it's OK. I agreed with Thomas that we will try to migrate the smbios
> routines into the arch specific part of the kernel in the future.
> 
> Thanks in advance,
> Wim.
> 
> commit b1ad0c9cab52a6437584929cc755898bd85d6045
> Author: Thomas Mingarelli <thomas.mingarelli@hp.com>
> Date:   Tue Dec 4 17:41:54 2007 +0000
> 
>     [WATCHDOG] HP ProLiant WatchDog driver
>     
>     Hp is providing a Hardware WatchDog Timer driver that will only work with the
>     specific HW Timer located in the HP ProLiant iLO 2 ASIC. The iLO 2 HW Timer
>     will generate a Non-maskable Interrupt (NMI) 9 seconds before physically
>     resetting the server, by removing power, so that the event can be logged to
>     the HP Integrated Management Log (IML), a Non-Volatile Random Access Memory
>     (NVRAM). The logging of the event is performed using the HP ProLiant ROM via
>     an Industry Standard access known as a BIOS Service Directory Entry.
>     
>     Signed-off-by: Thomas Mingarelli <thomas.mingarelli@hp.com>
>     Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
> 
> ...
>
> index 0000000..078c954
> --- /dev/null
> +++ b/drivers/watchdog/hpwdt.c
> @@ -0,0 +1,981 @@
> +/*
> + *   HP WatchDog Driver
> + *   based on
> + *
> + *   SoftDog	0.05:	A Software Watchdog Device
> + *
> + *   (c) Copyright 2007 Hewlett-Packard Development Company, L.P.
> + *   Thomas Mingarelli <thomas.mingarelli@hp.com>
> + *
> + *   This program is free software; you can redistribute it and/or
> + *   modify it under the terms of the GNU General Public License
> + *   version 2 as published by the Free Software Foundation
> + *
> + */
> +
> +#include <linux/device.h>
> +#include <linux/fs.h>
> +#include <linux/init.h>
> +#include <linux/interrupt.h>
> +#include <linux/io.h>
> +#include <linux/irq.h>
> +#include <linux/kernel.h>
> +#include <linux/miscdevice.h>
> +#include <linux/mm.h>
> +#include <linux/module.h>
> +#include <linux/moduleparam.h>
> +#include <linux/notifier.h>
> +#include <linux/pci.h>
> +#include <linux/pci_ids.h>
> +#include <linux/reboot.h>
> +#include <linux/sched.h>
> +#include <linux/timer.h>
> +#include <linux/types.h>
> +#include <linux/uaccess.h>
> +#include <linux/watchdog.h>
> +#include <asm/desc.h>
> +#include <asm/kdebug.h>
> +
> +#ifndef CONFIG_X86_64
> +#define HPWDT_ARCH	32
> +#else
> +#define HPWDT_ARCH	64
> +#endif
> +
> +#define PCI_BIOS32_SD_VALUE		0x5F32335F
> +#define CRU_BIOS_SIGNATURE_VALUE	0x55524324
> +#define PCI_BIOS32_PARAGRAPH_LEN	16
> +#define PCI_ROM_BASE1			0x000F0000
> +#define ROM_SIZE			0x0FFFF
> +
> +struct bios32_service_dir {
> +	u32 signature;
> +	u32 entry_point;
> +	u8 revision;
> +	u8 length;
> +	u8 checksum;
> +	u8 reserved[5];
> +};
> +
> +/*
> + * smbios_entry_point     - defines SMBIOS entry point structure
> + *
> + * anchor_string[4]       - anchor string (_SM_)
> + * check_sum              - checksum of the entry point structure
> + * length                 - length of the entry point structure
> + * major_ver              - major version (02h for revision 2.1)
> + * minor_ver              - minor version (01h for revision 2.1)
> + * max_struct_size        - size of the largest SMBIOS structure
> + * revision               - entry point structure revision implemented
> + * reserved[5]            - reserved
> + * intermediate_anchor[5] - intermediate anchor string (_DMI_)
> + * intermediate_check_sum - intermediate checksum
> + * table_length           - structure table length
> + * table_address          - structure table address
> + * number_structs         - number of SMBIOS structures present
> + * bcd_revision           - BCD revision
> + */

We support kerneldoc-style documentation for structs and this comment (and
al similar) should be converted, please.

> +struct smbios_entry_point {
> +	u8 anchor_string[4];
> +	u8 check_sum;
> +	u8 length;
> +	u8 major_ver;
> +	u8 minor_ver;
> +	u16 max_struct_size;
> +	u8 revision;
> +	u8 reserved[5];
> +	u8 intermediate_anchor[5];
> +	u8 intermediate_check_sum;
> +	u16 table_length;
> +	u64 table_address;
> +	u16 number_structs;
> +	u8 bcd_revision;
> +};
> +
> +struct smbios_header {
> +	u8 byte_type;
> +	u8 byte_length;
> +	u16 handle;
> +};
> +
> +/* type 212 */
> +struct smbios_cru64_info {
> +	u8 type;
> +	u8 byte_length;
> +	u16 handle;
> +	u32 signature;
> +	u64 physical_address;
> +	u32 double_length;
> +	u32 double_offset;
> +};
> +#define SMBIOS_CRU64_INFORMATION	212
> +
> +struct cmn_registers {
> +	union {
> +		struct {
> +			u8 ral;
> +			u8 rah;
> +			u16 rea2;
> +		};
> +		u32 reax;
> +	} u1;
> +	union {
> +		struct {
> +			u8 rbl;
> +			u8 rbh;
> +			u8 reb2l;
> +			u8 reb2h;
> +		};
> +		u32 rebx;
> +	} u2;
> +	union {
> +		struct {
> +			u8 rcl;
> +			u8 rch;
> +			u16 rec2;
> +		};
> +		u32 recx;
> +	} u3;
> +	union {
> +		struct {
> +			u8 rdl;
> +			u8 rdh;
> +			u16 red2;
> +		};
> +		u32 redx;
> +	} u4;
> +
> +	u32 resi;
> +	u32 redi;
> +	u16 rds;
> +	u16 res;
> +	u32 reflags;
> +}  __attribute__((packed));

All the above structs are conspicuously uncommented.  A ref to the relevant
manufacturer's doc would suit, I guess.

> +#define DEFAULT_MARGIN	30
> +static unsigned int soft_margin = DEFAULT_MARGIN;	/* in seconds */
> +static int nowayout = WATCHDOG_NOWAYOUT;
> +static unsigned int reload;
> +static char expect_release;
> +static unsigned long hpwdt_is_open;
> +static unsigned long __iomem *hpwdt_timer_reg;
> +static unsigned long __iomem *hpwdt_timer_con;
> +static u16 tbl_len;
> +static u64 tbl_addr;
> +
> +static DEFINE_SPINLOCK(rom_lock);
> +
> +static void *gpVirtRomCRUAddr;
> +static void *gpBios32Map;
> +static unsigned char *gpBios32EntryPoint;

Those identifiers are unlinuxy.

> +static void *p_mem_addr;
> +
> +static struct cmn_registers cmn_regs;
> +
> +static struct pci_device_id hpwdt_devices[] = {
> +	{
> +	 .vendor = PCI_VENDOR_ID_COMPAQ,
> +	 .device = 0xB203,
> +	 .subvendor = PCI_ANY_ID,
> +	 .subdevice = PCI_ANY_ID,
> +	},
> +	{0},			/* terminate list */
> +};
> +MODULE_DEVICE_TABLE(pci, hpwdt_devices);
> +
>
> ...
>
> +
> +/* --32 Bit Bios------------------------------------------------------------ */
> +
> +/*
> + *	cru_detect
> + *
> + *	Routine Description:
> + *    	This function uses the 32-bit BIOS Service Directory record to
> + *    	search for a $CRU record.
> + *
> + *	Return Value:
> + *     	0        :  SUCCESS
> + *     	<0       :  FAILURE
> + */
> +int __devinit cru_detect(void)

I think this can be made static?

> +{
> +	unsigned long cru_physical_address;
> +	unsigned long cru_length;
> +	unsigned long physical_bios_base = 0;
> +	unsigned long physical_bios_offset = 0;
> +	int retval = -ENODEV;
> +
> +	cmn_regs.u1.reax = CRU_BIOS_SIGNATURE_VALUE;
> +
> +	asminline_call(&cmn_regs, (unsigned long *)gpBios32EntryPoint);
> +
> +	if (cmn_regs.u1.ral != 0) {
> +		printk(KERN_WARNING
> +		       "hpwdt: Call succeeded but with an error: 0x%x\n",
> +		       cmn_regs.u1.ral);
> +	} else {
> +		physical_bios_base = cmn_regs.u2.rebx;
> +		physical_bios_offset = cmn_regs.u4.redx;
> +		cru_length = cmn_regs.u3.recx;
> +		cru_physical_address =
> +		    physical_bios_base + physical_bios_offset;
> +
> +		/* If the values look OK, then map it in. */
> +		if ((physical_bios_base + physical_bios_offset)) {
> +			gpVirtRomCRUAddr =
> +			    ioremap(cru_physical_address, cru_length);
> +			if (gpVirtRomCRUAddr)
> +				retval = 0;
> +		}
> +
> +		printk(KERN_DEBUG "hpwdt: CRU Base Address:   0x%lx\n",
> +			physical_bios_base);
> +		printk(KERN_DEBUG "hpwdt: CRU Offset Address: 0x%lx\n",
> +			physical_bios_offset);
> +		printk(KERN_DEBUG "hpwdt: CRU Length:         0x%lx\n",
> +			cru_length);
> +		printk(KERN_DEBUG "hpwdt: CRU Mapped Address: 0x%x\n",
> +			(unsigned int)&gpVirtRomCRUAddr);
> +	}
> +	iounmap(gpBios32Map);
> +	return retval;
> +}
> +
>
> ...
>
> +
> +/*
> + *	check_for_bios32_support
> + *
> + *	Routine Description:
> + *    	This function determine if a pointer is pointing to the
> + *    	32 bit BIOS Directory Services entry in ROM space.
> + *
> + *	Return Value:
> + *	1 - if found the correct signature
> + *	0 - unable to find _32_
> + */
> +static int check_for_bios32_support(struct bios32_service_dir *bios_32_ptr)
> +{
> +	/*
> +	 * Search for signature by checking equal to the swizzled value
> +	 * instead of calling another routine to perform a strcmp.
> +	 */
> +	if (bios_32_ptr->signature == PCI_BIOS32_SD_VALUE) {
> +		if (valid_checksum((void *)bios_32_ptr,

unneeded typecast to void*.

> +			((unsigned char)(bios_32_ptr->length *
> +				PCI_BIOS32_PARAGRAPH_LEN))))
> +		return 1;
> +	}
> +	return 0;
> +}
> +
> +/*
> + *	find_32bit_bios_sd
> + *
> + *	Routine Description:
> + *    	This function find the 32-bit BIOS Service Directory
> + *
> + *	Return Value:
> + *     	0        :  SUCCESS
> + *     	<0       :  FAILURE
> + */
> +int __devinit find_32bit_bios_sd(void)

static?

> +{
> +	struct bios32_service_dir *bios_32_data_ptr;
> +	unsigned long map_entry, map_offset;
> +	void *pRomVirtAddr;
> +	unsigned char *p;
> +	int retval = -ENOMEM;
> +
> +	pRomVirtAddr = ioremap(PCI_ROM_BASE1, ROM_SIZE);
> +	if (!pRomVirtAddr) {
> +		printk(KERN_WARNING "hpwdt: Unable to map in BIOS ROM.\n");
> +		return retval;
> +	}
> +
> +	/*
> +	 * BIOS32 spec indicates that the signature will be
> +	 * paragraph-aligned, so we'll skip by 16 bytes each pass
> +	 * through the loop.
> +	 */
> +	for (p = pRomVirtAddr;
> +	     p < ((unsigned char *)pRomVirtAddr + ROM_SIZE); p += 16) {
> +
> +		if (!check_for_bios32_support((struct bios32_service_dir *) p))
> +			continue;
> +
> +		/* Found a Service Directory. */
> +		bios_32_data_ptr = (struct bios32_service_dir *) p;
> +
> +		/*
> +		 * According to the spec, we're looking for the
> +		 * first 4KB-aligned address below the entrypoint
> +		 * listed in the header. The Service Directory code
> +		 * is guaranteed to occupy no more than 2 4KB pages.
> +		 */
> +		map_entry = bios_32_data_ptr->entry_point & ~(PAGE_SIZE - 1);
> +		map_offset = bios_32_data_ptr->entry_point - map_entry;
> +
> +		gpBios32Map = ioremap(map_entry, (2 * PAGE_SIZE));
> +
> +		if (gpBios32Map) {
> +			/* This will be unmapped in cru_detect. */
> +			gpBios32EntryPoint = gpBios32Map + map_offset;
> +			retval = 0;
> +		}
> +		break;
> +	}
> +	iounmap(pRomVirtAddr);
> +	return retval;
> +}
> +
> +/* --64 Bit Bios------------------------------------------------------------ */

Does the 64-bit code need to be compiled in on i386 kernels?

> +
> +/*
> + *	smbios_get_record
> + *
> + *	Routine Description:
> + *    	This function will get the next record in the SMB Tables
> + *
> + *	Return Value:
> + *     	1        :  SUCCESS - if record found
> + *     	0        :  FAILURE - if record not found
> + */
> +int smbios_get_record(unsigned char **pp_record, void *smbios_table_ptr)

Please check all global symbols in this driver, verify that they indeed
need to be global.

> +{
> +	unsigned char *buffer;
> +	struct smbios_header *header_ptr;
> +
> +	/*
> +	 * if pp_record is NULL, find the first record
> +	 */
> +	if (*pp_record == 0) {
> +		*pp_record = smbios_table_ptr;
> +		buffer = smbios_table_ptr;
> +	} else {
> +		header_ptr = (struct smbios_header *) * pp_record;

Please incorporate scripts/checkpatch.pl into your patch preparation and
merging processes.

> +		buffer = *pp_record;
> +
> +		/*
> +		 * skip over the structure itself
> +		 */
> +		*pp_record += header_ptr->byte_length;
> +
> +		buffer += header_ptr->byte_length;
> +
> +		/*
> +		 * skip over any strings following the structure
> +		 */
> +		while (*buffer || *(buffer + 1))
> +			buffer++;
> +
> +		/*
> +		 * skip over the double NULL characters
> +		 */
> +		buffer += 2;
> +	}
> +	if (buffer >= ((unsigned char *)smbios_table_ptr + tbl_len))
> +		return 0;
> +
> +	*pp_record = buffer;
> +	return 1;
> +}
> +
> +/*
> + *	smbios_get_record_by_type
> + *
> + *	Routine Description:
> + *	This function will get a record in the SMB Table by the type specified
> + *
> + *	Return Value:
> + *     	1        :  SUCCESS - if record found
> + *     	0        :  FAILURE - if record not found
> + */
> +int smbios_get_record_by_type(unsigned char type, unsigned short copy,
> +			      void **pp_record, void *smbios_table_ptr)
> +{
> +	unsigned char *save_state_ptr = NULL;
> +	struct smbios_header *header_ptr;
> +
> +	while (smbios_get_record(&save_state_ptr, smbios_table_ptr)) {
> +		header_ptr = (struct smbios_header *) save_state_ptr;
> +		if (header_ptr->byte_type == type) {
> +			if (copy == 0) {
> +				*pp_record = (void *)save_state_ptr;

Unneeded cast?

> +				return 1;
> +			} else
> +				copy--;
> +		}
> +	}
> +	return 0;
> +}
> +
> +/*
> + *	smbios_get_64bit_cru_info
> + *
> + *	Routine Description:
> + *	This routine will collect the 64bit CRU entry point from SMBIOS
> + *	table.
> + *
> + *	Return Value:
> + *     	0        :  SUCCESS
> + *     	<0       :  FAILURE
> + */
> +int __devinit smbios_get_64bit_cru_info(void)
> +{
> +	unsigned short copy;
> +	unsigned char *record_ptr = NULL;
> +	struct smbios_cru64_info *smbios_cru64_ptr;
> +	unsigned long cru_physical_address;
> +	void *smbios_table_ptr;
> +	int retval = -ENOMEM;
> +
> +	smbios_table_ptr = ioremap((unsigned int)tbl_addr, tbl_len);

ioremap takes an unsigned long.

Why is tbl_addr u64?  Unsigned long would be appropriate for both
archiectures?

> +	if (!smbios_table_ptr)
> +		return retval;
> +
> +	copy = 0;
> +	while (smbios_get_record_by_type
> +	       (SMBIOS_CRU64_INFORMATION, copy, (void *)&record_ptr,
> +	       smbios_table_ptr)) {
> +		/*
> +		 * In the event the ROM has a bug, let's print this
> +		 * out and quit before we get into trouble.
> +		 */
> +		if (!record_ptr) {
> +			printk(KERN_WARNING
> +			       "hpwdt: smbios: Missing SMBIOS_CRU64_INFO!\n");
> +			retval = -ENODEV;
> +			break;
> +		}
> +		smbios_cru64_ptr = (struct smbios_cru64_info *) record_ptr;

Change type of record_ptr to void* and all its typecasts can go away.

> +		if (smbios_cru64_ptr->signature == CRU_BIOS_SIGNATURE_VALUE) {
> +
> +			cru_physical_address =
> +			    smbios_cru64_ptr->physical_address +
> +			    smbios_cru64_ptr->double_offset;
> +			gpVirtRomCRUAddr =
> +			    ioremap((unsigned long)cru_physical_address,
> +				    smbios_cru64_ptr->double_length);
> +			if (gpVirtRomCRUAddr)
> +				retval = 0;
> +			break;
> +		}
> +	}
> +
> +	iounmap(smbios_table_ptr);
> +	return retval;
> +}

If smbios_get_record_by_type() fails, this function will return an
inappropriate -ENOMEM.

> +/*
> + *	smbios_detect
> + *
> + *	Routine Description:
> + *    	This function parses SMBIOS to retrieve the 64 bit CRU Service.
> + *
> + *	Return Value:
> + *     	0        :  SUCCESS
> + *     	<0       :  FAILURE
> + */
> +int smbios_detect(void)

static?

> +{
> +	unsigned char *p_virtual_rom;
> +	unsigned char *p;
> +	struct smbios_entry_point *pEPS;

StudlyCaps.

> +	int retval = -ENOMEM;
> +
> +	/*
> +	 * Search from 0x0f0000 through 0x0fffff, inclusive.
> +	 */
> +	p_virtual_rom = ioremap(PCI_ROM_BASE1, ROM_SIZE);
> +	if (!p_virtual_rom)
> +		return retval;
> +
> +	for (p = p_virtual_rom; p < p_virtual_rom + ROM_SIZE; p += 16) {
> +		pEPS = (struct smbios_entry_point *) p;
> +		if ((strncmp((char *)pEPS->anchor_string, "_SM_",
> +			     sizeof(pEPS->anchor_string))) == 0) {
> +			tbl_addr = pEPS->table_address;
> +			tbl_len = pEPS->table_length;
> +			retval = 0;
> +			break;
> +		}
> +	}
> +	iounmap(p_virtual_rom);
> +	return retval;
> +}
> +
> +/* ------------------------------------------------------------------------- */
> +
> +/*
> + *	NMI Handler
> + */
> +static int hpwdt_pretimeout(struct notifier_block *nb, unsigned long ulReason,
> +			    void *dummy)
> +{
> +	static unsigned long rom_pl;
> +	static int die_nmi_called;
> +
> +	if (ulReason == DIE_NMI || ulReason == DIE_NMI_IPI) {
> +		spin_lock_irqsave(&rom_lock, rom_pl);

spin_lock() in an NMI handler is usually deadlockable.  The only thing
which will save us here is if the hardware somehow prevents another NMI
from being issued when this one is being serviced (which sounds kinda
compulsory).  But if that is true, this lock (which should be static to
this function) is not needed.

> +		if (!die_nmi_called)
> +			asminline_call(&cmn_regs, gpVirtRomCRUAddr);
> +		die_nmi_called = 1;
> +		spin_unlock_irqrestore(&rom_lock, rom_pl);
> +		if (cmn_regs.u1.ral == 0) {
> +			printk(KERN_WARNING "hpwdt: An NMI occurred, "
> +			       "but unable to determine source.\n");
> +		} else {
> +			panic("An NMI occurred, please see the Integrated "
> +				"Management Log for details.\n");
> +		}
> +	}
> +	return NOTIFY_STOP;
> +}
> +
>
> ...
>
> +static int hpwdt_ioctl(struct inode *inode, struct file *file,
> +	unsigned int cmd, unsigned long arg)
> +{
> +	void __user *argp = (void __user *)arg;
> +	int __user *p = argp;
> +	int new_margin;
> +	int ret = -ENOTTY;
> +
> +	switch (cmd) {
> +	case WDIOC_GETSUPPORT:
> +		ret = 0;
> +		if (copy_to_user(argp, &ident, sizeof(ident)))
> +			ret = -EFAULT;
> +		break;
> +
> +	case WDIOC_GETSTATUS:
> +	case WDIOC_GETBOOTSTATUS:
> +		ret = put_user(0, p);
> +		break;
> +
> +	case WDIOC_KEEPALIVE:
> +		hpwdt_ping();
> +		ret = 0;
> +		break;
> +
> +	case WDIOC_SETTIMEOUT:
> +		ret = get_user(new_margin, p);
> +		if (ret)
> +			break;
> +
> +		ret = hpwdt_change_timer(new_margin);
> +		if (ret)
> +			break;
> +
> +		hpwdt_ping();
> +		/* Fall */
> +	case WDIOC_GETTIMEOUT:
> +		ret = put_user(soft_margin, p);
> +		break;
> +	}
> +	return ret;
> +}
> +
> +/*
> + *	Kernel interfaces
> + */
> +static struct file_operations hpwdt_fops = {
> +	.owner = THIS_MODULE,
> +	.llseek = no_llseek,
> +	.write = hpwdt_write,
> +	.ioctl = hpwdt_ioctl,
> +	.open = hpwdt_open,
> +	.release = hpwdt_release,
> +};

Please avoid adding new file_operations.ioctl() instances - we'd like to
remove them all.

Use unlocked_ioctl() instead.  The only substantial difference is that
->unlocked_ioctl() is not called under lock_kernel().

> +static struct miscdevice hpwdt_miscdev = {
> +	.minor = WATCHDOG_MINOR,
> +	.name = "watchdog",
> +	.fops = &hpwdt_fops,
> +};
> +
> +static struct notifier_block die_notifier = {
> +	.notifier_call = hpwdt_pretimeout,
> +	.priority = 0x7FFFFFFF,
> +};
> +
> +/*
> + *	Init & Exit
> + */
> +
> +static int __devinit detect_bios_directory(void)
> +{
> +	if (HPWDT_ARCH == 32) {
> +		return find_32bit_bios_sd();
> +	} else {
> +		return smbios_detect();
> +	}
> +}
> +
> +static int __devinit detect_cru_service(void)
> +{
> +	if (HPWDT_ARCH == 32) {
> +		return cru_detect();
> +	} else {
> +		return smbios_get_64bit_cru_info();
> +	}
> +}

Remove unneeded braces in the above two functions.

> +static int __devinit hpwdt_init_one(struct pci_dev *dev,
> +				    const struct pci_device_id *ent)
> +{
> +	int retval;
> +
> +	/*
> +	 * First let's find out if we are on an iLO2 server. We will
> +	 * not run on a legacy ASM box.
> +	 */
> +	if (dev->subsystem_vendor != PCI_VENDOR_ID_HP) {
> +		dev_warn(&dev->dev,
> +		       "This server does not have an iLO2 ASIC.\n");
> +		return -ENODEV;
> +	}
> +
> +	if (pci_enable_device(dev)) {
> +		dev_warn(&dev->dev,
> +			"Not possible to enable PCI Device: 0x%x:0x%x.\n",
> +			ent->vendor, ent->device);
> +		return -ENODEV;
> +	}
> +
> +	p_mem_addr = ioremap((unsigned long)pci_resource_start(dev, 1), 0x80);
> +	if (!p_mem_addr) {
> +		dev_warn(&dev->dev,
> +			"Unable to detect the iLO2 server memory.\n");
> +		retval = -ENOMEM;
> +		goto error_pci_ioremap;
> +	}
> +	hpwdt_timer_reg = (p_mem_addr + 0x70);
> +	hpwdt_timer_con = (p_mem_addr + 0x72);
> +
> +	/* Make sure that we have a valid soft_margin */
> +	if (hpwdt_change_timer(soft_margin)) {
> +		hpwdt_change_timer(DEFAULT_MARGIN);
> +	}

unneeded braces.

> +	/*
> +	 * We need to map the ROM to get the CRU service.
> +	 * For 32 bit Operating Systems we need to go through the 32 Bit
> +	 * BIOS Service Directory
> +	 * For 64 bit Operating Systems we get that service through SMBIOS.
> +	 */
> +	retval = detect_bios_directory();
> +	if (retval < 0) {
> +		dev_warn(&dev->dev, "No %s found.\n",
> +			(HPWDT_ARCH == 32) ?
> +			"32 Bit BIOS Service Directory" : "64 Bit SMBIOS");
> +		goto error_get_cru;
> +	}
> +
> +	retval = detect_cru_service();
> +	if (retval < 0) {
> +		dev_warn(&dev->dev,
> +		       "Unable to detect the %d Bit CRU Service.\n",
> +			HPWDT_ARCH);
> +		goto error_get_cru;
> +	}
> +
> +	/*
> +	 * We know this is the only CRU call we need to make so lets keep as
> +	 * few instructions as possible once the NMI comes in.
> +	 */
> +	memset(&cmn_regs, 0, sizeof(struct cmn_registers));

This memset is unneeded - the compiler already did it.

> +	cmn_regs.u1.rah = 0x0D;
> +	cmn_regs.u1.ral = 0x02;
> +
> +	retval = register_die_notifier(&die_notifier);
> +	if (retval != 0) {
> +		dev_warn(&dev->dev,
> +		       "Unable to register a die notifier (err=%d).\n",
> +			retval);
> +		goto error_die_notifier;
> +	}
> +
> +	retval = misc_register(&hpwdt_miscdev);
> +	if (retval < 0) {
> +		dev_warn(&dev->dev,
> +			"Unable to register miscdev on minor=%d (err=%d).\n",
> +			WATCHDOG_MINOR, retval);
> +		goto error_misc_register;
> +	}
> +
> +	printk(KERN_INFO
> +		"hp Watchdog Timer Driver: 1.00"
> +		", timer margin: %d seconds( nowayout=%d).\n",
> +		soft_margin, nowayout);
> +
> +	return 0;
> +
> +error_misc_register:
> +	unregister_die_notifier(&die_notifier);
> +error_die_notifier:
> +	if (gpVirtRomCRUAddr)
> +		iounmap(gpVirtRomCRUAddr);
> +error_get_cru:
> +	if (p_mem_addr)
> +		iounmap(p_mem_addr);
> +error_pci_ioremap:
> +	pci_disable_device(dev);
> +	return retval;
> +}
> +
> +static void __devexit hpwdt_exit(struct pci_dev *dev)
> +{
> +	if (!nowayout)
> +		hpwdt_stop();
> +
> +	misc_deregister(&hpwdt_miscdev);
> +
> +	unregister_die_notifier(&die_notifier);
> +
> +	if (gpVirtRomCRUAddr)
> +		iounmap(gpVirtRomCRUAddr);
> +	if (p_mem_addr)
> +		iounmap(p_mem_addr);
> +
> +	pci_disable_device(dev);
> +}
> +
> +static struct pci_driver hpwdt_driver = {
> +	.name = "hpwdt",
> +	.id_table = hpwdt_devices,
> +	.probe = hpwdt_init_one,
> +	.remove = __devexit_p(hpwdt_exit),
> +};
> +
> +static void __exit hpwdt_cleanup(void)
> +{
> +	pci_unregister_driver(&hpwdt_driver);
> +}
> +
> +static int __init hpwdt_init(void)
> +{
> +	return pci_register_driver(&hpwdt_driver);
> +}
> +
> +MODULE_AUTHOR("Tom Mingarelli");
> +MODULE_DESCRIPTION("hp watchdog driver");
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
> +
> +module_param(soft_margin, int, 0);
> +MODULE_PARM_DESC(soft_margin, "Watchdog timeout in seconds");
> +
> +module_param(nowayout, int, 0);
> +MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default="
> +		__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
> +
> +module_init(hpwdt_init);
> +module_exit(hpwdt_cleanup);
