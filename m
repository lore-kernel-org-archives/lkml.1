Return-Path: <linux-kernel-owner+w=401wt.eu-S1757616AbYA0GDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757616AbYA0GDy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 01:03:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756422AbYA0GDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 01:03:15 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46134 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755265AbYA0GDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 01:03:13 -0500
Date: Sat, 26 Jan 2008 22:01:23 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Konrad Rzeszutek <konrad@darnok.org>
Cc: linux-kernel@vger.kernel.org, greg@kroah.com, dwm@enoyolf.org,
       darnok@68k.org, pjones@redhat.com, konradr@redhat.com,
       konradr@linux.vnet.ibm.com, randy.dunlap@oracle.com, hpa@zytor.com,
       lenb@kernel.org, mike.anderson@us.ibm.com, dwm@austin.ibm.com,
       arjan@infradead.org, michaelc@cs.wisc.edu,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: [PATCH] Add iSCSI iBFT support (v0.4.5)
Message-Id: <20080126220123.d20dd393.akpm@linux-foundation.org>
In-Reply-To: <20080125220629.GA25325@andromeda.dapyr.net>
References: <20080125220629.GA25325@andromeda.dapyr.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 25 Jan 2008 18:06:29 -0400 Konrad Rzeszutek <konrad@darnok.org> wrote:
> Hey Andrew,
> 
> Please add this patch along with Greg KH's kobject fixes.

erm, OK.  But I don't think I'm the appropriate conduit for iscsi paches.

By what path _does_ iscsi ode get into the tree, anyway?  Mike is listed as
maintainer...

Oh well, at least I get to read some code.

> This module
> is dependent on the fixes that Greg KH has in his patches git tree.
> 
> This patch (v0.4.5) adds /sysfs/firmware/ibft/[initiator|targetX|ethernetX]
> directories along with text properties which export the the iSCSI
> Boot Firmware Table (iBFT) structure.
> 
> What is iSCSI Boot Firmware Table? It is a mechanism for the iSCSI
> tools to extract from the machine NICs the iSCSI connection information
> so that they can automagically mount the iSCSI share/target. Currently
> the iSCSI information is hard-coded in the initrd.
> 
> For full details of the IBFT structure please take a look at:
> ftp://ftp.software.ibm.com/systems/support/system_x_pdf/ibm_iscsi_boot_firmware_table_v1.02.pdf

When adding new sysfs things (especially things as complex as this) please
fully describe the user-visible interface in the changelog so that we can
review your interface design.

Does this code follow the one-value-per-sysfs-file convention?

> +#if defined(CONFIG_ISCSI_IBFT_FIND)
> +static void __init reserve_ibft_region(void)
> +{
> +	unsigned int ibft_len;
> +
> +	ibft_len = find_ibft();
> +	if (ibft_len)
> +		reserve_bootmem((unsigned int)ibft_phys,
> +				PAGE_ALIGN(ibft_len));
> +}
> +#else
> +static void __init reserve_ibft_region(void) { }
> +#endif

Usually we'd make the CONFIG_ISCSI_IBFT_FIND=n version of this function
static inline in a header.  As it stands this code will add a pointless
empty function to the vmlinux image.

>  int __initdata user_defined_memmap = 0;

checkpatch should have told you that this "= 0" shouldn't be there.  But it
doesn't.

> +	struct kobject *kobj;
> +	int type; /* The enum of the type. This can be any value off:
> +		ibft_eth_properties_enum, ibft_tgt_properties_enum,
> +		or ibft_initiator_properties_enum. */
> +	struct list_head node;
> +};
> +
> +static LIST_HEAD(ibft_attr_list);
> +static LIST_HEAD(ibft_kobject_list);

A brief search for the locking which protects these lists was unsuccessful.
What's up?

> +/*
> + * Helper functions to parse data properly.
> + */
> +static ssize_t sprintf_ipaddr(char *buf, u8 *ip)
> +{
> +	if (ip[0] == 0 && ip[1] == 0 && ip[2] == 0 && ip[3] == 0 &&
> +	    ip[4] == 0 && ip[5] == 0 && ip[6] == 0 && ip[7] == 0 &&
> +	    ip[8] == 0 && ip[9] == 0 && ip[10] == 0xff && ip[11] == 0xff) {
> +		/*
> +		 * IPV4
> +		 */
> +		return sprintf(buf, "%d.%d.%d.%d\n", ip[12],
> +			       ip[13], ip[14], ip[15]);
> +	} else
> +		return 0;
> +}

I'm seeing an awful lot of sprintf()s in here which look like they should
be snprintf().  By what means is this code bulletproof against overflows?

> +static ssize_t sprintf_string(char *str, int len, char *buf)
> +{
> +	return sprintf(str, "%.*s\n", len, buf);
> +}
> +
> +/*
> + * Helper function to verify the IBFT header.
> + */
> +static int ibft_verify_hdr(char *t, struct ibft_hdr *hdr, int id, int length)
> +{
> +#define IBFT_VERIFY_HDR_FIELD(val, name) \
> +	if (hdr->val != val) { \
> +		printk(KERN_ERR \
> +		       "iBFT error: In structure %s field %s expected %d but" \
> +		       " found %d!\n", \
> +		       t, name, val, hdr->val); \
> +		return -ENODEV; \
> +	}
> +	IBFT_VERIFY_HDR_FIELD(id, "id");
> +	IBFT_VERIFY_HDR_FIELD(length, "length");
> +	return 0;
> +}

I'm not sure that two usages really justifies IBFT_VERIFY_HDR_FIELD's
existence.  If you're really attched to it then I'd suggest that it be
undefed immediately after having been read, for readability reasons.

> +static void ibft_release(struct kobject *kobj)
> +{
> +	struct ibft_kobject *ibft =
> +		container_of(kobj, struct ibft_kobject, kobj);
> +	kfree(ibft);
> +}
>
> ...
>
> +	for (pos = (u8 *)hdr; pos < (u8 *)hdr + len; pos ++)
>

checkpatch should have caught the " ++" but didn't.  I think it used to. 
It seems to be going backwards?

> +		csum += *pos;
> +
> +	if (csum) {
> +		printk(KERN_ERR "iBFT has incorrect checksum (0x%x)!\n", csum);
> +		return 1;
> +	}
> +
> +	ibft_device = kmalloc(len, GFP_KERNEL);
> +	if (!ibft_device)
> +		return -ENOMEM;
> +
> +	memcpy(ibft_device, hdr, len);
> +
> +	return 0;
> +}
> +
>
> ...
>
> +
> +	/* kobject fief. We will let the reference counter do the job
> +	 of deleting its name if we fail here. */

what's a fief?

> +/*
> + * Physical location of iSCSI Boot Format Table.
> + */
> +void *ibft_phys;
> +EXPORT_SYMBOL(ibft_phys);
> +
> +#define IBFT_SIGN "iBFT"
> +#define IBFT_SIGN_LEN 4
> +#define IBFT_START 0x80000 /* 512kB */
> +#define IBFT_END 0x100000 /* 1MB */
> +#define VGA_MEM 0xA0000 /* VGA buffer */
> +#define VGA_SIZE 0x20000 /* 128kB */
> +
> +
> +/*
> + * Routine used to find the iSCSI Boot Format Table. the physical
> + * location is set in the ibft_phys variable. The return value is
> + * the size of IBFT.
> + */
> +ssize_t find_ibft(void)
> +{
> +	unsigned long pos;
> +
> +	for (pos = IBFT_START; pos < IBFT_END; pos += 16) {
> +		void *virt;
> +		/* The table can't be inside the VGA BIOS reserved space,
> +		 * so skip that area */
> +		if (pos == VGA_MEM)
> +			pos += VGA_SIZE;
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
> +EXPORT_SYMBOL(find_ibft);

Is this x86-specific?  Are suitable Kconfig dependencies in place?

> + *  Copyright 2007 Red Hat, Inc.
> + *  by Peter Jones <pjones@redhat.com>
> + *  Copyright 2007 IBM, Inc.
> + *  by Konrad Rzeszutek <konradr@linux.vnet.ibm.com>
> + *
> + * This code exposes the iSCSI Boot Format Table to userland via sysfs.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License v2.0 as published by
> + * the Free Software Foundation
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#ifndef ISCSI_IBFT_H
> +#define ISCSI_IBFT_H
> +
> +#if defined(CONFIG_ISCSI_IBFT_FIND)

We'd more usually use #ifdef here.  Whatever.

> +/*
> + * Physical location of iSCSI Boot Format Table.
> + */
> +extern void *ibft_phys;
> +
> +/*
> + * Routine used to find the iSCSI Boot Format Table. The physical
> + * location is set in the ibft_phys variable. The return value is the
> + * size of IBFT.
> + */
> +extern ssize_t find_ibft(void);
> +
> +#endif

Often we don't bother putting declarations like this inside the ifdef. 
Upside: cleaner code.  Downside: error-detection happens at link-time
rather tha compile-time.

