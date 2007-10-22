Return-Path: <linux-kernel-owner+w=401wt.eu-S1753905AbXJVIvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905AbXJVIvj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 04:51:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751984AbXJVIvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 04:51:32 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35750 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751464AbXJVIva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 04:51:30 -0400
Date: Mon, 22 Oct 2007 01:51:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: thomas.mingarelli@hp.com
Cc: linux-kernel@vger.kernel.org, Wim Van Sebroeck <wim@iguana.be>
Subject: Re: [HP ProLiant WatchDog driver] hpwdt HP WatchDog Patch
Message-Id: <20071022015116.8e70fd19.akpm@linux-foundation.org>
In-Reply-To: <20071015130312.13901.89895.sendpatchset@tmingo.cca.cpqcorp.net>
References: <20071015130312.13901.89895.sendpatchset@tmingo.cca.cpqcorp.net>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Oct 2007 14:05:50 -0400 (EDT) thomas.mingarelli@hp.com wrote:

> Hp is providing a Hardware WatchDog Timer driver that will only work with the
> specific HW Timer located in the HP ProLiant iLO 2 ASIC. The iLO 2 HW Timer
> will generate a Non-maskable Interrupt (NMI) 9 seconds before physically
> resetting the server, by removing power, so that the event can be logged to
> the HP Integrated Management Log (IML), a Non-Volatile Random Access Memory
> (NVRAM). The logging of the event is performed using the HP ProLiant ROM via
> an Industry Standard access known as a BIOS Service Directory Entry.

Please include a signed-off-by: for contributions, as per
Documentation/SubmittingPatches.

Please cc the watchdog maintainer (cc'ed here) on watchdog patches.

I'm inclined to agree with Arjan - a lot of this code is not specific to
this driver and to this device.  It is not desirable that such code be
hidden inside a particular device driver.

Please respond to Andrey Panin's (good) question?

Please pass the patch through scripts/checkpatch.pl.  It does catch a few
little things.

> --- linux-2.6.23.1/drivers/char/watchdog/Makefile.orig	2007-10-12 11:43:44.000000000 -0500
> +++ linux-2.6.23.1/drivers/char/watchdog/Makefile	2007-10-15 07:56:31.000000000 -0500

Please don't raise patches against the stable kernel: it is not a
development kernel.  Generally it's best to work against the latest Linus
tree, available from git or from
ftp://ftp.kernel.org/pub/linux/kernel/v2.6/snapshots/

For a submission like this we'll be OK with a diff against 2.6.23 because
it doesn't modify any existing code.  But it is risky to assume this in
general.   I mean, Linus's tree right now is 99% of the way to 2.6.24...

> +#include <linux/fs.h>
> +#include <linux/init.h>
> +#include <linux/interrupt.h>
> +#include <linux/kdebug.h>
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
> +#include <linux/watchdog.h>
> +#include <asm/desc.h>
> +#include <asm/io.h>
> +#include <asm/irq.h>
> +#include <asm/uaccess.h>

Are all those inclusions needed?

> +#define PCI_BIOS32_SD_VALUE		0x5F32335F
> +#define CRU_BIOS_SIGNATURE_VALUE	0x55524324
> +#define PCI_BIOS32_PARAGRAPH_LEN	16
> +#define PCI_ROM_BASE1			0x000F0000
> +#define ROM_SIZE			0x0FFFF
> +
> +typedef struct _BIOS32_SERVICE_DIRECTORY {
> +	u32 signature;
> +	u32 entry_point;
> +	u8 revision;
> +	u8 length;
> +	u8 checksum;
> +	u8 reserved[5];
> +} BIOS32_SERVICE_DIRECTORY, *PBIOS32_SERVICE_DIRECTORY;

Please avoid adding typedefs.  `struct bios32_service_directory' would work
fine here.  The PBIOS32_SERVICE_DIRECTORY typedef is simply unneeded - just
open-code 'struct bios32_service_directory *' where needed.

Please avoid ALL CAPS.

> +
> +/*
> + * SMBIOSEntryPoint       - defines SMBIOS entry point structure
> + *
> + * anchor_string[4]       - anchor string (_SM_)
> + * check_sum              - checksum of the entry point structure
> + * length                 - length of the entry point structure
> + * major_ver              - major version (02h for revision 2.1)
> + * minor_ver              - minor version (01h for revision 2.1)
> + * max_struct_size        - size of the largest SMBIOS structure
> + * revision               - entry point structure revision implemented
> + * reserved[5]            - reserved
> + * intermediate_anchor[5] - intermediate anchor string (_DM_)
> + * intermediate_check_sum - intermediate checksum
> + * table_length           - structure table length
> + * table_address          - structure table address
> + * number_structs         - number of structures present
> + * bcd_revision           - BCD revision
> + */

The patch has (good) commenting like this in many places but there is no
reason why it has to be in this unconventional format.  Please consider
converting them to standard kernel-doc style.

> +typedef struct _SMBIOSEntryPoint {
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
> +}SMBIOSEntryPoint;

`struct SMBIOS_entry_point' would be more typical.

Please put a space after the '}' here.  (checkpatch misses this)

> +#pragma pack(1)

A handful of not-very-modern-or-well-maintained drivers in the kernel do
use pragma-pack, but __attribute__((packed)) is much more typical.

> +typedef struct _CMN_REGISTERS {
> +	union {
> +		struct {
> +			u8 ral;
> +			u8 rah;
> +			u16 rea2;
> +		} s1;
> +		u32 reax;
> +	} u1;
> +	union {
> +		struct {
> +			u8 rbl;
> +			u8 rbh;
> +			u8 reb2l;
> +			u8 reb2h;
> +		} s1;
> +		u32 rebx;
> +	} u2;
> +	union {
> +		struct {
> +			u8 rcl;
> +			u8 rch;
> +			u16 rec2;
> +		} s1;
> +		u32 recx;
> +	} u3;
> +	union {
> +		struct {
> +			u8 rdl;
> +			u8 rdh;
> +			u16 red2;
> +		} s1;
> +		u32 redx;
> +	} u4;
> +
> +	u32 resi;
> +	u32 redi;
> +	u16 rds;
> +	u16 res;
> +	u32 reflags;
> +} CMN_REGISTERS, *PCMN_REGISTERS;

Actually all the s1's here could be just removed: can use anonymous structs.

> +#pragma pack()
> +
> +#define CQSMBIOS_CRU64_INFORMATION              212
> +
> +static unsigned int soft_margin = 2;	/* in minutes */
> +static unsigned long *hpwdt_timer_reg;
> +static unsigned long *hpwdt_timer_con;

The above two need __iomem notation, methinks.  The `sparse' tool can then
check this code more effectively.

> +static unsigned int reload;
> +static unsigned int new_margin;
> +static u16 tbl_len;
> +static u64 tbl_addr;
> +static int die_reg;
> +static int pci_enable;
> +
> +static DEFINE_SPINLOCK(rom_lock);
> +
> +static void *gpVirtRomCRUAddr;
> +static void *gpBios32Map;
> +static unsigned char *gpBios32EntryPoint;
> +static void *p_mem_addr;
> +
> +static int hpwdt_pretimeout(struct notifier_block *, unsigned long, void *);

This decalration is unneeded.

> +static CMN_REGISTERS cmn_regs;
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
> +
> +MODULE_DEVICE_TABLE(pci, hpwdt_devices);
> +
>
> ...
>
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
> +int smbios_get_record(unsigned char **ppRecord, void *smbios_table_ptr)

The driver has a large number of global symbols which can (and I suspect
should) be made static.  Unless you have plans to use these in other code
or something?

> +{
> +	unsigned char *buffer;
> +	PSMBIOS_HEADER header_ptr;
> +
> +	/*
> +	 * if ppRecord is NULL, find the first record

Kernel avoids this sort of variable naming.  Please prefer pp_record.

> +	 */
> +	if (*ppRecord == 0) {
> +		*ppRecord = smbios_table_ptr;
> +		buffer = smbios_table_ptr;
> +	} else {
> +		header_ptr = (PSMBIOS_HEADER) * ppRecord;
> +		buffer = *ppRecord;
> +
> +		/*
> +		 * skip over the structure itself
> +		 */
> +		*ppRecord += header_ptr->byte_length;
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
> +	*ppRecord = buffer;
> +	return 1;
> +}
> +
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
> +{
> +	unsigned long cru_physical_address;
> +	unsigned long cru_length;
> +	unsigned long physical_bios_base = 0;
> +	unsigned long physical_bios_offset = 0;
> +	int retval = -ENODEV;
> +
> +	memset(&cmn_regs, 0, sizeof(CMN_REGISTERS));

The compiler already did that for ue?

> +	cmn_regs.u1.reax = CRU_BIOS_SIGNATURE_VALUE;
> +
> +	asminline_call(&cmn_regs, (unsigned long *)gpBios32EntryPoint);
> +
> +	if (cmn_regs.u1.s1.ral != 0) {
> +		printk(KERN_WARNING
> +		       "hpwdt: Call succeeded but with an error: 0x%x\n",
> +		       cmn_regs.u1.s1.ral);
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
>
> ...
>
> +static int check_for_bios32_support(PBIOS32_SERVICE_DIRECTORY bios_32_ptr)
> +{
> +	/*
> +	 * Search for signature by checking equal to the swizzled value
> +	 * instead of calling another routine to perform a strcmp.
> +	 */
> +	if (bios_32_ptr->signature == PCI_BIOS32_SD_VALUE) {
> +		if (valid_checksum((void *)bios_32_ptr,
> +			((unsigned char)(bios_32_ptr->length *
> +				PCI_BIOS32_PARAGRAPH_LEN))))
> +		return 1;

Missed a tabstop there.

> +	}
> +	return 0;
> +}

Kernel functions conventionally return 0 on success and often a -ve errno
on failure.

> +static struct watchdog_info ident = {
> +	.options = WDIOF_SETTIMEOUT,
> +	.identity = "hp Watchdog",

Is that a sufficiently specific description?  The only watchdog HP will
ever make?

> +};
> +
> +static long
> +hpwdt_ioctl(struct file *file, unsigned int cmd,
> +	    unsigned long arg)
> +{
> +	int ret = -ENOIOCTLCMD;
> +
> +	switch (cmd) {
> +	case WDIOC_GETSUPPORT:
> +		ret = 0;
> +		if (copy_to_user((void *)arg, &ident, sizeof(ident)))
> +			ret = -EFAULT;
> +		break;
> +
> +	case WDIOC_GETSTATUS:
> +		ret = 0;
> +		break;
> +
> +	case WDIOC_GETBOOTSTATUS:
> +		ret = put_user(0, (int *)arg);
> +		break;
> +
> +	case WDIOC_KEEPALIVE:
> +		hpwdt_ping();
> +		ret = 0;
> +		break;
> +
> +	case WDIOC_SETTIMEOUT:
> +		ret = get_user(new_margin, (int *)arg);
> +		if (ret)
> +			break;
> +
> +		/* Arbitrary, can't find the card's limits */
> +		if (new_margin < 2 || new_margin > 30) {
> +			ret = -EINVAL;
> +			break;
> +		}
> +
> +		soft_margin = new_margin;
> +		printk(KERN_DEBUG
> +			"hpwdt: New timer passed in is %d minutes.\n",
> +			new_margin);
> +		reload = ((soft_margin * 60) * 1000) / 128;
> +		hpwdt_ping();
> +		/* Fall */
> +	case WDIOC_GETTIMEOUT:
> +		ret = put_user(new_margin, (int *)arg);
> +		break;
> +	}
> +	return ret;
> +}
> +
> +static struct file_operations hpwdt_fops = {
> +	.owner = THIS_MODULE,
> +	.llseek = no_llseek,
> +	.write = hpwdt_write,
> +	.unlocked_ioctl = hpwdt_ioctl,
> +	.open = hpwdt_open,
> +	.release = hpwdt_release,
> +};
> +
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

hm.  People rarely bother with notifier priorities.  Is this here for some
reason?

> +static int __devinit hpwdt_init_one(struct pci_dev *dev,
> +				    const struct pci_device_id *ent)
> +{
> +	int retval;
> +
> +	if (pci_enable_device(dev)) {
> +		printk(KERN_WARNING
> +		       "hpwdt: Not possible to enable PCI Device\n");
> +		return -ENODEV;
> +	}
> +	pci_enable = 1;
> +
> +	/*
> +	 * First let's find out if we are on an iLO2 server. We will
> +	 * not run on a legacy ASM box.
> +	 */
> +	if (dev->subsystem_vendor != PCI_VENDOR_ID_HP) {
> +		printk(KERN_WARNING
> +		       "hpwdt: This server does not have an iLO2 ASIC.\n");

How do we know that the code is running on a server?  My laptop would find
that message quite complimentary ;)

> +		return -ENODEV;

Missed a pci_disable_device()?

> +	}
> +
> +	retval = misc_register(&hpwdt_miscdev);
> +	if (retval < 0)
> +		return retval;

Missed a pci_disable_device()?

> +	p_mem_addr = ioremap((unsigned long)pci_resource_start(dev, 1), 0x80);
> +	if (!p_mem_addr) {
> +		retval = -ENOMEM;
> +		goto error_out;
> +	}
> +	hpwdt_timer_reg = (p_mem_addr + 0x70);
> +	hpwdt_timer_con = (p_mem_addr + 0x72);
> +
> +#ifndef CONFIG_X86_64
> +	/*
> +	 * Let's try to map in the ROM for 32 bit Operating Systems because
> +	 * we need get the CRU Service through the 32 Bit BIOS SD.
> +	 * This is not the case for 64 bit Operating Systems where we get
> +	 * that service through SMBIOS.
> +	 */
> +	retval = find_32bit_bios_sd();
> +	if (retval < 0) {
> +		printk(KERN_WARNING
> +		       "hpwdt: No 32 Bit BIOS Service Directory found.\n");
> +		goto error_out;
> +	}
> +
> +	retval = cru_detect();
> +	if (retval < 0) {
> +		printk(KERN_WARNING
> +		       "hpwdt: Unable to detect 32 Bit CRU Service.\n");
> +		goto error_out;
> +	}
> +#else
> +	retval = smbios_detect();
> +	if (retval < 0) {
> +		printk(KERN_WARNING "hpwdt: No 64 Bit SMBIOS found.\n");
> +		goto error_out;
> +	}
> +
> +	retval = smbios_get_64bit_cru_info();
> +	if (retval < 0) {
> +		printk(KERN_WARNING
> +		       "hpwdt: Unable to detect the 64 Bit CRU Service.\n");
> +		goto error_out;
> +	}
> +#endif
> +	/*
> +	 * We know this is the only CRU call we need to make so lets keep as
> +	 * few instructions as possible once the NMI comes in.
> +	 */
> +	memset(&cmn_regs, 0, sizeof(CMN_REGISTERS));

That's the third time we cleared this?

> +	cmn_regs.u1.s1.rah = 0x0D;
> +	cmn_regs.u1.s1.ral = 0x02;
> +
> +	retval = register_die_notifier(&die_notifier);
> +	if (retval != 0) {
> +		printk(KERN_WARNING
> +		       "hpwdt: Unable to register a die notifier.\n");
> +		goto error_out;
> +	}
> +	die_reg = 1;
> +
> +	new_margin = soft_margin;
> +	printk("hp Watchdog Timer Driver: 1.00, timer margin: %d minutes\n",
> +		new_margin);
> +
> +	return 0;
> +error_out:
> +	printk(KERN_WARNING "hpwdt: NMI support is not possible.\n");
> +	misc_deregister(&hpwdt_miscdev);
> +	if (pci_enable)
> +		pci_disable_device(dev);
> +	if (p_mem_addr)
> +		iounmap(p_mem_addr);
> +	if (gpVirtRomCRUAddr)
> +		iounmap(gpVirtRomCRUAddr);
> +	return retval;
> +}
> +
> +static void __devexit hpwdt_exit(struct pci_dev *dev)
> +{
> +	if (die_reg)
> +		unregister_die_notifier(&die_notifier);
> +
> +	misc_deregister(&hpwdt_miscdev);
> +	if (p_mem_addr)
> +		iounmap(p_mem_addr);
> +	if (gpVirtRomCRUAddr)
> +		iounmap(gpVirtRomCRUAddr);
> +}

Did that clean everything up?  It seems to be missing a
pci_disable_device() (at least).

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
> +MODULE_PARM_DESC(soft_margin, "Watchdog timeout in minutes");
> +
> +module_init(hpwdt_init);
> +module_exit(hpwdt_cleanup);

