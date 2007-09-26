Return-Path: <linux-kernel-owner+w=401wt.eu-S1762818AbXIZVbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762818AbXIZVbu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 17:31:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750863AbXIZVbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 17:31:41 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:35557 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760777AbXIZVbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 17:31:39 -0400
Date: Wed, 26 Sep 2007 14:29:50 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Konrad Rzeszutek <konrad@darnok.org>
Cc: linux-kernel@vger.kernel.org, pjones@redhat.com, konradr@redhat.com,
       konradr@linux.vnet.ibm.com
Subject: Re: [PATCH] Add iSCSI iBFT support.
Message-Id: <20070926142950.46bbfcd2.randy.dunlap@oracle.com>
In-Reply-To: <20070926184652.GA16369@andromeda.dapyr.net>
References: <20070926184652.GA16369@andromeda.dapyr.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Sep 2007 14:46:52 -0400 Konrad Rzeszutek wrote:

> This patch adds a /sysfs/firmware/ibft/table binary blob which exports
> the iSCSI Boot Firmware Table (iBFT) structure. 
> 
> What is iSCSI Boot Firmware Table? It is a mechanism for the iSCSI
> tools to extract from the machine NICs the iSCSI connection information
> so that they can automagically mount the iSCSI share/target. Currently
> the iSCSI information is hard-coded in the initrd.
> 
> The full details of the structure are located at:
> ftp://ftp.software.ibm.com/systems/support/system_x_pdf/ibm_iscsi_boot_firmware_table_v1.02.pdf
> 
> Signed-off-by: Konrad Rzeszutek <konradr@linux.vnet.ibm.com>
> Signed-off-by: Peter Jones <pjones@redhat.com>

> diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
> index 05f02a3..2d9f01a 100644
> --- a/drivers/firmware/Kconfig
> +++ b/drivers/firmware/Kconfig
> @@ -93,4 +93,14 @@ config DMIID
>  	  information from userspace through /sys/class/dmi/id/ or if you want
>  	  DMI-based module auto-loading.
>  
> +config ISCSI_IBFT
> +	tristate "iSCSI Boot Firmware Table Attributes"
> +	depends on X86

why only on X86?

> +	default	n
> +	help
> +	  This option enables support for detection of an iSCSI
> +	  Boot Firmware Table (iBFT).  If you wish to detect iSCSI boot
> +	  parameters dynamically during system boot, say Y.
> +	  Otherwise, say N.
> +
>  endmenu
> diff --git a/drivers/firmware/iscsi_ibft.c b/drivers/firmware/iscsi_ibft.c
> new file mode 100644
> index 0000000..b3767fe
> --- /dev/null
> +++ b/drivers/firmware/iscsi_ibft.c
> @@ -0,0 +1,201 @@
> +/*
> + * drivers/firmware/iscsi_ibft.c

Don't repeat the file name.

> + *  Copyright 2007 Red Hat, Inc.
> + *  by Peter Jones <pjones@redhat.com>
> + *  Copyright 2007 IBM
> + *  by Konrad Rzeszutek <konradr@us.ibm.com>
> + *
> + * This code exposes the the iSCSI Boot Format Table to userland via sysfs.
                ~~~~~~~
yes.

> + */
> +
> +#include <linux/module.h>
> +#include <linux/string.h>
> +#include <linux/types.h>
> +#include <linux/init.h>
> +#include <linux/stat.h>
> +#include <linux/err.h>
> +#include <linux/ctype.h>
> +#include <linux/slab.h>
> +#include <linux/limits.h>
> +#include <linux/device.h>
> +#include <linux/pci.h>
> +#include <linux/blkdev.h>
> +

no blank line here.

> +#include <linux/iscsi_ibft.h>
> +
> +#define ISCSI_IBFT_VERSION  "0.2"
> +#define ISCSI_IBFT_DATE	 "2007-Aug-29"
> +
> +MODULE_AUTHOR
> +("Peter Jones <pjones@redhat.com> and Konrad Rzeszutek <konradr@us.ibm.com>");
> +MODULE_DESCRIPTION("sysfs interface to BIOS iBFT information");
> +MODULE_LICENSE("GPL");
> +MODULE_VERSION(ISCSI_IBFT_VERSION);
> +
> +
> +static ssize_t
> +ibft_read_binary(struct kobject *kobj, struct bin_attribute *attr, char *buf,
> +		 loff_t off, size_t count)

Put 'static ssize_t' on same line as function name, then put parameters
on following lines as needed.


> +{
> +
> +	struct ibft_device *ibft = container_of(kobj, struct ibft_device, kobj);
> +	ssize_t len = ibft->hdr->length;
> +
> +	if (off > len)
> +		return 0;
> +
> +	if (off + count > len)
> +		count = len - off;
> +
> +	memcpy(buf, ibft->hdr + off, count);
> +
> +	return count;
> +}
> +static int
> +ibft_mmap_binary(struct kobject *kobj, struct bin_attribute *attr,
> +		 struct vm_area_struct *vma)

ditto.

> +{
...
> +}
> +static struct bin_attribute ibft_attribute_binary = {
> +	.attr = {
> +		 .name = "binary",
> +		 .mode = S_IRUSR,
> +		 .owner = THIS_MODULE,
> +		 },
> +	.read = ibft_read_binary,
> +	.write = NULL,
> +	.mmap = ibft_mmap_binary
> +};
> +static struct kobj_type ktype_ibft = {
> +	.release = ibft_release,
> +};
> +
> +static decl_subsys(ibft, &ktype_ibft, NULL);
> +
> +static int ibft_device_register(struct ibft_device *idev)
> +{
> +	int error = 0;
> +	int len = 0;
> +	struct ibft_header *hdr;
> +
> +	if (!idev)
> +		return 1;
> +
> +	/* Copy over the data */
> +	hdr = (struct ibft_header *)phys_to_virt((unsigned long)ibft_phys);
> +	len = hdr->length;
> +
> +	/* Need PAGE_ALING for mmap functionality. */

                PAGE_ALIGN

> +	idev->hdr = kzalloc(PAGE_ALIGN(len), GFP_KERNEL);
> +	if (!idev->hdr)
> +		return -ENOMEM;
> +
> +	memcpy(idev->hdr, hdr, len);
> +
> +	/* This is firmware/ibft */
> +	kobject_set_name(&idev->kobj, "table");
> +	kobj_set_kset_s(idev, ibft_subsys);
> +	error = kobject_register(&idev->kobj);
> +
> +	if (!error) {
> +		ibft_attribute_binary.size = idev->hdr->length;
> +		error =
> +		    sysfs_create_bin_file(&idev->kobj, &ibft_attribute_binary);
> +	}
> +
> +	/* The de-allocation part is done by module_exit() */
> +	return error;
> +}
> +
> +static struct ibft_device *ibft_idev;
...
> +static void __exit ibft_exit(void)
> +{
> +	if (ibft_idev)
> +		kobject_unregister(&ibft_idev->kobj);
> +
> +	firmware_unregister(&ibft_subsys);
> +	printk(KERN_INFO "BIOS iBFT unloaded.\n");

Drop the unload message.  ibft_init() is also quite noisy.


> +}
> +
> +module_init(ibft_init);
> +module_exit(ibft_exit);
> diff --git a/include/linux/iscsi_ibft.h b/include/linux/iscsi_ibft.h
> new file mode 100644
> index 0000000..5e7b267
> --- /dev/null
> +++ b/include/linux/iscsi_ibft.h
> @@ -0,0 +1,58 @@
> +#ifndef ISCSI_IBFT_H
> +#define ISCSI_IBFT_H
> +
> +extern void *ibft_phys;
> +
> +struct ibft_header {
> +	char signature[4];
> +	u32 length;
> +	u8 revision;
> +	u8 checksum;
> +	char oem_id[6];
> +	char oem_table_id[8];
> +	char reserved[24];
> +};
> +
> +struct ibft_device {
> +	struct ibft_header *hdr;
> +	struct kobject kobj;
> +};
> +
> +#if defined(CONFIG_ISCSI_IBFT) || defined(CONFIG_ISCSI_IBFT_MODULES)
> +
> +#define IBFT_SIGN "iBFT"
> +#define IBFT_SIGN_LEN 4
> +#define IBFT_START 0x80000 /* 512kB */
> +#define IBFT_END 0x100000 /* 1MB */
> +#define VGA_MEM 0xA0000 /* VGA buffer */
> +#define VGA_SIZE 0x20000 /* 132kB */

Need blank line here... except why is this function in the header
file?  and why is it inline?


> +static inline ssize_t find_ibft(void)
> +{
> +	unsigned long pos;

add blank line here between data / code.

> +	for (pos = IBFT_START; pos < IBFT_END; pos += 16) {
> +		void *virt;
> +		/* The table can't be inside the VGA BIOS reserved space,
> +		 * so skip that area */
> +		if (pos == VGA_MEM-PAGE_SIZE)
> +			pos += VGA_SIZE+PAGE_SIZE;
> +		virt = phys_to_virt(pos);
> +		if (memcmp(virt, IBFT_SIGN, IBFT_SIGN_LEN) == 0) {
> +			unsigned long *addr =
> +			    (unsigned long *)phys_to_virt(pos + 4);
> +			unsigned int len = *addr;
> +			/* if the length of the table extends past 1M,
> +			 * the table cannot be valid. */
> +			if (pos + len <= (IBFT_END-1)) {
> +				ibft_phys = (void *)pos;
> +				return len;
> +			}
> +		}
> +	}
> +	return 0;
> +}
> +
> +#else
> +
> +static inline ssize_t find_ibft(void) { return 0; };
> +#endif
> +#endif /* ISCSI_IBFT_H */
> -

---
~Randy
Phaedrus says that Quality is about caring.
