Return-Path: <linux-kernel-owner+w=401wt.eu-S1757524AbZEaKJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757524AbZEaKJR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 06:09:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754357AbZEaKJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 06:09:05 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56442 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182AbZEaKJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 06:09:01 -0400
Date: Sun, 31 May 2009 11:08:43 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Janboe Ye <yuan-bo.ye@motorola.com>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       jwboyer@linux.vnet.ibm.com, grant.likely@secretlab.ca, paulus@samba.org
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
Message-ID: <20090531100843.GB18650@n2100.arm.linux.org.uk>
References: <1243408083.13460.14.camel@debian-nb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243408083.13460.14.camel@debian-nb>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For what its worth, here's a review of this patch.

On Wed, May 27, 2009 at 03:08:03PM +0800, Janboe Ye wrote:
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index f430e15..b0ee851 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -158,6 +158,17 @@ config ARCH_MTD_XIP
>  config GENERIC_HARDIRQS_NO__DO_IRQ
>  	def_bool y
>  
> +config OF
> +        def_bool y

We really don't want OF enabled for all ARM platforms, the vast majority
don't use it.  It would be far better to only enable it for those classes
of machines which (eventually) support it, otherwise it's just needless
bloat.

> +
> +config PROC_DEVICETREE
> +        bool "Support for device tree in /proc"
> +        depends on PROC_FS
> +        help
> +          This option adds a device-tree directory under /proc which contains
> +          an image of the device tree that the kernel copies from Open
> +          Firmware or other boot firmware. If unsure, say Y here.
> +
>  if OPROFILE
>  
>  config OPROFILE_ARMV6
> @@ -1231,6 +1242,8 @@ menu "Device Drivers"
>  
>  source "drivers/base/Kconfig"
>  
> +source "drivers/of/Kconfig"
> +
>  source "drivers/connector/Kconfig"
>  
>  if ALIGNMENT_TRAP || !CPU_CP15_MMU
> diff --git a/arch/arm/include/asm/of_device.h b/arch/arm/include/asm/of_device.h
> new file mode 100644
> index 0000000..6317713
> --- /dev/null
> +++ b/arch/arm/include/asm/of_device.h
> @@ -0,0 +1,32 @@
> +#ifndef _ASM_POWERPC_OF_DEVICE_H
> +#define _ASM_POWERPC_OF_DEVICE_H

This isn't PowerPC.

> +#ifdef __KERNEL__
> +
> +#include <linux/device.h>
> +#include <linux/of.h>
> +
> +/*
> + * The of_device is a kind of "base class" that is a superset of
> + * struct device for use by devices attached to an OF node and
> + * probed using OF properties.
> + */
> +struct of_device {
> +	struct device_node	*node;		/* to be obsoleted */
> +	u64			dma_mask;	/* DMA mask */
> +	struct device		dev;		/* Generic device interface */
> +};
> +
> +extern struct of_device *of_device_alloc(struct device_node *np,
> +					 const char *bus_id,
> +					 struct device *parent);
> +
> +extern int of_device_uevent(struct device *dev,
> +			    struct kobj_uevent_env *env);

Both of these don't appear to be defined or used in this patch, are
these prototypes necessary?

> +
> +static inline int of_node_to_nid(struct device_node *device)
> +{
> +	return 0;
> +}
> +
> +#endif /* __KERNEL__ */
> +#endif /* _ASM_POWERPC_OF_DEVICE_H */
> diff --git a/arch/arm/include/asm/of_platform.h b/arch/arm/include/asm/of_platform.h
> new file mode 100644
> index 0000000..53b4650
> --- /dev/null
> +++ b/arch/arm/include/asm/of_platform.h
> @@ -0,0 +1,39 @@
> +#ifndef _ASM_POWERPC_OF_PLATFORM_H
> +#define _ASM_POWERPC_OF_PLATFORM_H

Also not PowerPC.

> +/*
> + *    Copyright (C) 2006 Benjamin Herrenschmidt, IBM Corp.
> + *			 <benh@kernel.crashing.org>
> + *
> + *  This program is free software; you can redistribute it and/or
> + *  modify it under the terms of the GNU General Public License
> + *  as published by the Free Software Foundation; either version
> + *  2 of the License, or (at your option) any later version.
> + *
> + */
> +
> +/* Platform drivers register/unregister */
> +static inline int of_register_platform_driver(struct of_platform_driver *drv)
> +{
> +	return of_register_driver(drv, &of_platform_bus_type);
> +}
> +static inline void of_unregister_platform_driver(struct of_platform_driver *drv)
> +{
> +	of_unregister_driver(drv);
> +}

Not sure why this isn't generic code.

> +
> +/* Platform devices and busses creation */
> +extern struct of_device *of_platform_device_create(struct device_node *np,
> +						   const char *bus_id,
> +						   struct device *parent);

Doesn't appear to be defined or used in this patch, is this prototype
necessary?

> +/* pseudo "matches" value to not do deep probe */
> +#define OF_NO_DEEP_PROBE ((struct of_device_id *)-1)
> +
> +extern int of_platform_bus_probe(struct device_node *root,
> +				 const struct of_device_id *matches,
> +				 struct device *parent);
> +
> +extern struct of_device *of_find_device_by_phandle(phandle ph);
> +
> +extern void of_instantiate_rtc(void);

These three don't appear to be defined or used in this patch, are
they necessary?

> +
> +#endif	/* _ASM_POWERPC_OF_PLATFORM_H */
> diff --git a/arch/arm/include/asm/prom.h b/arch/arm/include/asm/prom.h
> new file mode 100644
> index 0000000..8105074
> --- /dev/null
> +++ b/arch/arm/include/asm/prom.h
> @@ -0,0 +1,367 @@
> +#ifndef _POWERPC_PROM_H
> +#define _POWERPC_PROM_H

ARM, not PowerPC.

> +#ifdef __KERNEL__
> +
> +/*
> + * Definitions for talking to the Open Firmware PROM on
> + * Power Macintosh computers.

As far as I know, we don't have an OF PROM to talk to in any ARM machine.
Is this file relevent for ARM?  Maybe it's misnamed?

> + *
> + * Copyright (C) 1996-2005 Paul Mackerras.
> + *
> + * Updates for PPC64 by Peter Bergner & David Engebretsen, IBM Corp.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version
> + * 2 of the License, or (at your option) any later version.
> + */
> +#include <linux/types.h>
> +#include <linux/proc_fs.h>
> +#include <linux/platform_device.h>
> +#include <asm/irq.h>
> +#include <asm/atomic.h>

I don't see anything using atomic stuff in here, but I do see bitops,
which seems to be missing from the include list above.

> +
> +#define OF_ROOT_NODE_ADDR_CELLS_DEFAULT	1
> +#define OF_ROOT_NODE_SIZE_CELLS_DEFAULT	1
> +
> +#define of_compat_cmp(s1, s2, l)	strcasecmp((s1), (s2))
> +#define of_prop_cmp(s1, s2)		strcmp((s1), (s2))
> +#define of_node_cmp(s1, s2)		strcasecmp((s1), (s2))
> +
> +/* Definitions used by the flattened device tree */
> +#define OF_DT_HEADER		0xd00dfeed	/* marker */
> +#define OF_DT_BEGIN_NODE	0x1		/* Start of node, full name */
> +#define OF_DT_END_NODE		0x2		/* End node */
> +#define OF_DT_PROP		0x3		/* Property: name off, size,
> +						 * content */
> +#define OF_DT_NOP		0x4		/* nop */
> +#define OF_DT_END		0x9
> +
> +#define OF_DT_VERSION		0x10
> +
> +/*
> + * This is what gets passed to the kernel by prom_init or kexec
> + *
> + * The dt struct contains the device tree structure, full pathes and
> + * property contents. The dt strings contain a separate block with just
> + * the strings for the property names, and is fully page aligned and
> + * self contained in a page, so that it can be kept around by the kernel,
> + * each property name appears only once in this page (cheap compression)
> + *
> + * the mem_rsvmap contains a map of reserved ranges of physical memory,
> + * passing it here instead of in the device-tree itself greatly simplifies
> + * the job of everybody. It's just a list of u64 pairs (base/size) that
> + * ends when size is 0
> + */
> +struct boot_param_header {
> +	u32	magic;			/* magic word OF_DT_HEADER */
> +	u32	totalsize;		/* total size of DT block */
> +	u32	off_dt_struct;		/* offset to structure */
> +	u32	off_dt_strings;		/* offset to strings */
> +	u32	off_mem_rsvmap;		/* offset to memory reserve map */
> +	u32	version;		/* format version */
> +	u32	last_comp_version;	/* last compatible version */
> +	/* version 2 fields below */
> +	u32	boot_cpuid_phys;	/* Physical CPU id we're booting on */
> +	/* version 3 fields below */
> +	u32	dt_strings_size;	/* size of the DT strings block */
> +	/* version 17 fields below */
> +	u32	dt_struct_size;		/* size of the DT structure block */
> +};
> +
> +
> +
> +typedef u32 phandle;
> +typedef u32 ihandle;
> +
> +struct property {
> +	char	*name;
> +	int	length;
> +	void	*value;
> +	struct property *next;
> +};
> +
> +struct device_node {
> +	const char *name;
> +	const char *type;
> +	phandle	node;
> +	phandle linux_phandle;
> +	char	*full_name;
> +
> +	struct	property *properties;
> +	struct  property *deadprops; /* removed properties */
> +	struct	device_node *parent;
> +	struct	device_node *child;
> +	struct	device_node *sibling;
> +	struct	device_node *next;	/* next device of same type */
> +	struct	device_node *allnext;	/* next in list of all nodes */
> +	struct  proc_dir_entry *pde;	/* this node's proc directory */
> +	struct  kref kref;
> +	unsigned long _flags;
> +	void	*data;
> +};
> +
> +extern struct device_node *of_chosen;
> +
> +static inline int of_node_check_flag(struct device_node *n, unsigned long flag)
> +{
> +	return test_bit(flag, &n->_flags);
> +}
> +
> +static inline void of_node_set_flag(struct device_node *n, unsigned long flag)
> +{
> +	set_bit(flag, &n->_flags);
> +}
> +
> +
> +#define HAVE_ARCH_DEVTREE_FIXUPS
> +
> +static inline void set_node_proc_entry(struct device_node *dn,
> +					struct proc_dir_entry *de)
> +{
> +	dn->pde = de;
> +}
> +
> +
> +extern struct device_node *of_find_all_nodes(struct device_node *prev);

Doesn't appear to be defined or used in this patch, is this prototype
necessary?

> +extern struct device_node *of_node_get(struct device_node *node);
> +extern void of_node_put(struct device_node *node);

These two are, great.

> +
> +/* For scanning the flat device-tree at boot time */
> +extern int __init of_scan_flat_dt(int (*it)(unsigned long node,
> +					    const char *uname, int depth,
> +					    void *data),
> +				  void *data);
> +extern void * __init of_get_flat_dt_prop(unsigned long node, const char *name,
> +					unsigned long *size);
> +extern int __init of_flat_dt_is_compatible(unsigned long node,
> +					const char *name);
> +extern unsigned long __init of_get_flat_dt_root(void);
> +
> +/* For updating the device tree at runtime */
> +extern void of_attach_node(struct device_node *);
> +extern void of_detach_node(struct device_node *);
> +
> +/* Other Prototypes */
> +extern void finish_device_tree(void);

These seven again don't appear to be defined...

> +extern void unflatten_device_tree(void);

This one is, yay!

> +extern void early_init_devtree(void *);
> +extern int machine_is_compatible(const char *compat);
> +extern void print_properties(struct device_node *node);
> +extern int prom_n_intr_cells(struct device_node *np);
> +extern void prom_get_irq_senses(unsigned char *senses, int off, int max);
> +extern int prom_add_property(struct device_node *np, struct property *prop);
> +extern int prom_remove_property(struct device_node *np, struct property *prop);
> +extern int prom_update_property(struct device_node *np,
> +				struct property *newprop,
> +				struct property *oldprop);

These eight don't appear to be defined...

> +
> +#ifdef CONFIG_PPC32

This define will never be set, so the definitions within this conditional
should not be here.

> +/*
> + * PCI <-> OF matching functions
> + * (XXX should these be here?)
> + */
> +struct pci_bus;
> +struct pci_dev;
> +extern int pci_device_from_OF_node(struct device_node *node,
> +				   u8 *bus, u8 *devfn);
> +extern struct device_node *pci_busdev_to_OF_node(struct pci_bus *, int);
> +extern struct device_node *pci_device_to_OF_node(struct pci_dev *);
> +extern void pci_create_OF_bus_map(void);
> +#endif
> +
> +extern struct resource *request_OF_resource(struct device_node* node,
> +				int index, const char *name_postfix);
> +extern int release_OF_resource(struct device_node *node, int index);

These two don't appear to be defined.

> +
> +
> +/*
> + * OF address retreival & translation
> + */
> +
> +
> +/* Helper to read a big number; size is in cells (not bytes) */
> +static inline u64 of_read_number(const u32 *cell, int size)
> +{
> +	u64 r = 0;
> +	while (size--)
> +		r = (r << 32) | *(cell++);
> +	return r;
> +}
> +
> +/* Like of_read_number, but we want an unsigned long result */
> +#ifdef CONFIG_PPC32

Ditto.

> +static inline unsigned long of_read_ulong(const u32 *cell, int size)
> +{
> +	return cell[size-1];
> +}
> +#else
> +#define of_read_ulong(cell, size)	of_read_number(cell, size)
> +#endif
> +
> +/* Translate an OF address block into a CPU physical address
> + */
> +extern u64 of_translate_address(struct device_node *np, const u32 *addr);
> +
> +/* Translate a DMA address from device space to CPU space */
> +extern u64 of_translate_dma_address(struct device_node *dev,
> +				    const u32 *in_addr);
> +
> +/* Extract an address from a device, returns the region size and
> + * the address space flags too. The PCI version uses a BAR number
> + * instead of an absolute index
> + */
> +extern const u32 *of_get_address(struct device_node *dev, int index,
> +			   u64 *size, unsigned int *flags);
> +#ifdef CONFIG_PCI
> +extern const u32 *of_get_pci_address(struct device_node *dev, int bar_no,
> +			       u64 *size, unsigned int *flags);
> +#else
> +static inline const u32 *of_get_pci_address(struct device_node *dev,
> +		int bar_no, u64 *size, unsigned int *flags)
> +{
> +	return NULL;
> +}
> +#endif /* CONFIG_PCI */

These address translation macros aren't defined, should they be?

> +
> +/* Get an address as a resource. Note that if your address is
> + * a PIO address, the conversion will fail if the physical address
> + * can't be internally converted to an IO token with
> + * pci_address_to_pio(), that is because it's either called to early
> + * or it can't be matched to any host bridge IO space
> + */
> +extern int of_address_to_resource(struct device_node *dev, int index,
> +				  struct resource *r);

Not defined.  I've stopped checking here, so prototypes below will need
removing if they're not required.

> +#ifdef CONFIG_PCI
> +extern int of_pci_address_to_resource(struct device_node *dev, int bar,
> +				      struct resource *r);
> +#else
> +static inline int of_pci_address_to_resource(struct device_node *dev, int bar,
> +		struct resource *r)
> +{
> +	return -ENOSYS;
> +}
> +#endif /* CONFIG_PCI */
> +
> +/* Parse the ibm,dma-window property of an OF node into the busno, phys and
> + * size parameters.
> + */
> +void of_parse_dma_window(struct device_node *dn, const void *dma_window_prop,
> +		unsigned long *busno, unsigned long *phys, unsigned long *size);
> +
> +extern void kdump_move_device_tree(void);
> +
> +/* CPU OF node matching */
> +struct device_node *of_get_cpu_node(int cpu, unsigned int *thread);
> +
> +/* cache lookup */
> +struct device_node *of_find_next_cache_node(struct device_node *np);
> +
> +/* Get the MAC address */
> +extern const void *of_get_mac_address(struct device_node *np);
> +
> +/*
> + * OF interrupt mapping
> + */
> +
> +/* This structure is returned when an interrupt is mapped. The controller
> + * field needs to be put() after use
> + */
> +
> +#define OF_MAX_IRQ_SPEC		 4 /* We handle specifiers of at most 4 cells */
> +
> +struct of_irq {
> +	struct device_node *controller;	/* Interrupt controller node */
> +	u32 size;			/* Specifier size */
> +	u32 specifier[OF_MAX_IRQ_SPEC];	/* Specifier copy */
> +};
> +
> +/**
> + * of_irq_map_init - Initialize the irq remapper
> + * @flags:	flags defining workarounds to enable
> + *
> + * Some machines have bugs in the device-tree which require certain workarounds
> + * to be applied. Call this before any interrupt mapping attempts to enable
> + * those workarounds.
> + */
> +#define OF_IMAP_OLDWORLD_MAC	0x00000001
> +#define OF_IMAP_NO_PHANDLE	0x00000002
> +
> +extern void of_irq_map_init(unsigned int flags);
> +
> +/**
> + * of_irq_map_raw - Low level interrupt tree parsing
> + * @parent:	the device interrupt parent
> + * @intspec:	interrupt specifier ("interrupts" property of the device)
> + * @ointsize:   size of the passed in interrupt specifier
> + * @addr:	address specifier (start of "reg" property of the device)
> + * @out_irq:	structure of_irq filled by this function
> + *
> + * Returns 0 on success and a negative number on error
> + *
> + * This function is a low-level interrupt tree walking function. It
> + * can be used to do a partial walk with synthetized reg and interrupts
> + * properties, for example when resolving PCI interrupts when no device
> + * node exist for the parent.
> + *
> + */
> +
> +extern int of_irq_map_raw(struct device_node *parent, const u32 *intspec,
> +			  u32 ointsize, const u32 *addr,
> +			  struct of_irq *out_irq);
> +
> +
> +/**
> + * of_irq_map_one - Resolve an interrupt for a device
> + * @device:	the device whose interrupt is to be resolved
> + * @index:     	index of the interrupt to resolve
> + * @out_irq:	structure of_irq filled by this function
> + *
> + * This function resolves an interrupt, walking the tree, for a given
> + * device-tree node. It's the high level pendant to of_irq_map_raw().
> + * It also implements the workarounds for OldWolrd Macs.
> + */
> +extern int of_irq_map_one(struct device_node *device, int index,
> +			  struct of_irq *out_irq);
> +
> +/**
> + * of_irq_map_pci - Resolve the interrupt for a PCI device
> + * @pdev:	the device whose interrupt is to be resolved
> + * @out_irq:	structure of_irq filled by this function
> + *
> + * This function resolves the PCI interrupt for a given PCI device. If a
> + * device-node exists for a given pci_dev, it will use normal OF tree
> + * walking. If not, it will implement standard swizzling and walk up the
> + * PCI tree until an device-node is found, at which point it will finish
> + * resolving using the OF tree walking.
> + */
> +struct pci_dev;
> +extern int of_irq_map_pci(struct pci_dev *pdev, struct of_irq *out_irq);
> +
> +extern int of_irq_to_resource(struct device_node *dev, int index,
> +			struct resource *r);
> +
> +/**
> + * of_iomap - Maps the memory mapped IO for a given device_node
> + * @device:	the device whose io range will be mapped
> + * @index:	index of the io range
> + *
> + * Returns a pointer to the mapped memory
> + */
> +extern void __iomem *of_iomap(struct device_node *device, int index);
> +extern int have_of;
> +/*
> + * NB:  This is here while we transition from using asm/prom.h
> + * to linux/of.h
> + */
> +#include <linux/of.h>

Hmm, if asm/prom.h is a transitionary thing, should new implementations be
providing it?

> +
> +/* align addr on a size boundary - adjust address up/down if needed */
> +#define _ALIGN_UP(addr, size)	(((addr) + ((size) - 1)) & (~((size) - 1)))
> +#define _ALIGN_DOWN(addr, size)	((addr) & (~((size) - 1)))
> +
> +/* align addr on a size boundary - adjust address up if needed */
> +#define _ALIGN(addr, size)     _ALIGN_UP(addr, size)
> +
> +#endif /* __KERNEL__ */
> +#endif /* _POWERPC_PROM_H */
> diff --git a/arch/arm/include/asm/setup.h b/arch/arm/include/asm/setup.h
> index 7ffbb29..2fbf11a 100644
> --- a/arch/arm/include/asm/setup.h
> +++ b/arch/arm/include/asm/setup.h
> @@ -150,6 +150,13 @@ struct tag_memclk {
>  	__u32 fmemclk;
>  };
>  
> +/* Flat dev tree address */
> +#define ATAG_FLAT_DEV_TREE_ADDRESS 0xf100040A

I'd prefer this to be 0x544100xx where 'xx' is the next available number
(which looks like being '0A').  The 0x544n00nn numbers are used for non-
platform specific tags.

> +struct tag_flat_dev_tree_address {

Hmm, the name of this structure doesn't really reflect it's purpose.  It
isn't an address, it's an address and size.  'tag_flat_dev_tree' would
be sufficient.

> +	u32 flat_dev_tree_address;
> +	u32 flat_dev_tree_size;

and just calling these 'address' and 'size' would also be sufficient.

> +};
> +
>  struct tag {
>  	struct tag_header hdr;
>  	union {
> @@ -177,6 +184,7 @@ struct tag {
>  		 * DC21285 specific
>  		 */
>  		struct tag_memclk	memclk;
> +		struct tag_flat_dev_tree_address flat_dev_tree_address;

'flat_dev_tree' will do fine here as well.

>  	} u;
>  };
>  
> diff --git a/arch/arm/kernel/Makefile b/arch/arm/kernel/Makefile
> index 4305345..adbdd3b 100644
> --- a/arch/arm/kernel/Makefile
> +++ b/arch/arm/kernel/Makefile
> @@ -29,6 +29,7 @@ obj-$(CONFIG_ATAGS_PROC)	+= atags.o
>  obj-$(CONFIG_OABI_COMPAT)	+= sys_oabi-compat.o
>  obj-$(CONFIG_ARM_THUMBEE)	+= thumbee.o
>  obj-$(CONFIG_KGDB)		+= kgdb.o
> +obj-$(CONFIG_OF)		+= prom.o
>  
>  obj-$(CONFIG_CRUNCH)		+= crunch.o crunch-bits.o
>  AFLAGS_crunch-bits.o		:= -Wa,-mcpu=ep9312
> diff --git a/arch/arm/kernel/prom.c b/arch/arm/kernel/prom.c
> new file mode 100644
> index 0000000..9d1c835
> --- /dev/null
> +++ b/arch/arm/kernel/prom.c
> @@ -0,0 +1,414 @@
> +/*
> + * Procedures for creating, accessing and interpreting the device tree.

Again, we don't have a PROM, but maybe this file is just misnamed.  Is
there a better name for it?

> + *
> + * Paul Mackerras       August 1996.
> + * Copyright (C) 1996-2005 Paul Mackerras.
> + *
> + *  Adapted for 64bit PowerPC by Dave Engebretsen and Peter Bergner.
> + *    {engebret|bergner}@us.ibm.com
> + *
> + *  Adapted for ARM by Motorola Inc.
> + *
> + *      This program is free software; you can redistribute it and/or
> + *      modify it under the terms of the GNU General Public License
> + *      as published by the Free Software Foundation; either version
> + *      2 of the License, or (at your option) any later version.
> + */
> +
> +#include <stdarg.h>
> +#include <linux/kernel.h>
> +#include <linux/string.h>
> +#include <linux/init.h>
> +#include <linux/threads.h>
> +#include <linux/spinlock.h>
> +#include <linux/types.h>
> +#include <linux/pci.h>
> +#include <linux/stringify.h>
> +#include <linux/delay.h>
> +#include <linux/initrd.h>
> +#include <linux/bitops.h>
> +#include <linux/module.h>
> +#include <linux/bootmem.h>
> +#include <linux/kexec.h>
> +#include <linux/debugfs.h>
> +#include <linux/irq.h>
> +#include <asm/prom.h>
> +#include <asm/setup.h>
> +#include <asm/memory.h>
> +#ifdef DEBUG
> +#define DBG(fmt...) printk(KERN_ERR fmt)
> +#else
> +#define DBG(fmt...)
> +#endif
> +
> +struct boot_param_header *initial_boot_params;

Should this be static?

> +
> +extern struct device_node *allnodes;	/* temporary while merging */
> +
> +extern rwlock_t devtree_lock;	/* temporary while merging */
> +
> +/* export that to outside world */
> +struct device_node *of_chosen;
> +
> +static inline char *find_flat_dt_string(u32 offset)
> +{
> +	return ((char *)initial_boot_params) +
> +		initial_boot_params->off_dt_strings + offset;
> +}
> +
> +static void *__init unflatten_dt_alloc(unsigned long *mem, unsigned long size,
> +				       unsigned long align)
> +{
> +	void *res;
> +
> +	*mem = _ALIGN(*mem, align);
> +	res = (void *)*mem;
> +	*mem += size;
> +
> +	return res;
> +}
> +
> +static unsigned long __init unflatten_dt_node(unsigned long mem,
> +					      unsigned long *p,
> +					      struct device_node *dad,
> +					      struct device_node ***allnextpp,
> +					      unsigned long fpsize)
> +{
> +	struct device_node *np;
> +	struct property *pp, **prev_pp = NULL;
> +	char *pathp;
> +	u32 tag;
> +	unsigned int l, allocl;
> +	int has_name = 0;
> +	int new_format = 0;
> +
> +	tag = *((u32 *)(*p));

There's lots of this casting going on - maybe an accessor function or macro
to read a u32 quantity from the stream (and increment the pointer) would be
better?

> +	if (tag != OF_DT_BEGIN_NODE) {
> +		printk("Weird tag at start of node: %x\n", tag);
> +		return mem;
> +	}
> +	*p += 4;
> +	pathp = (char *)*p;
> +	l = allocl = strlen(pathp) + 1;
> +	*p = _ALIGN(*p + l, 4);
> +
> +	/* version 0x10 has a more compact unit name here instead of the full
> +	 * path. we accumulate the full path size using "fpsize", we'll rebuild
> +	 * it later. We detect this because the first character of the name is
> +	 * not '/'.
> +	 */
> +	if ((*pathp) != '/') {
> +		new_format = 1;
> +		if (fpsize == 0) {
> +			/* root node: special case. fpsize accounts for path
> +			 * plus terminating zero. root node only has '/', so
> +			 * fpsize should be 2, but we want to avoid the first
> +			 * level nodes to have two '/' so we use fpsize 1 here
> +			 */
> +			fpsize = 1;
> +			allocl = 2;
> +		} else {
> +			/* account for '/' and path size minus terminal 0
> +			 * already in 'l'
> +			 */
> +			fpsize += l;
> +			allocl = fpsize;
> +		}
> +	}
> +
> +
> +	np = unflatten_dt_alloc(&mem, sizeof(struct device_node) + allocl,
> +				__alignof__(struct device_node));
> +	if (allnextpp) {
> +		memset(np, 0, sizeof(*np));
> +		np->full_name = ((char *)np) + sizeof(struct device_node);

This is just a more complex way of saying:

		np->full_name = (char *)(np + 1);

> +		if (new_format) {
> +			char *p = np->full_name;
> +			/* rebuild full path for new format */
> +			if (dad && dad->parent) {
> +				strcpy(p, dad->full_name);
> +#ifdef DEBUG
> +				if ((strlen(p) + l + 1) != allocl) {
> +					DBG("%s: p: %d, l: %d, a: %d\n",
> +					    pathp, (int)strlen(p), l, allocl);
> +				}
> +#endif
> +				p += strlen(p);
> +			}
> +			*(p++) = '/';
> +			memcpy(p, pathp, l);

Hmm.  Wouldn't:

			int n = scnprintf(np->full_name, allocl, "%s/%s",
				dad && dad->parent ? dad->full_name : "",
				pathp);
#ifdef DEBUG
			if (n != allocl) {
				DBG("%s: p: %d, l: %d, a: %d\n",
				    pathp, (int)strlen(p), l, allocl);
			}
#endif

be simpler and more readable?

> +		} else
> +			memcpy(np->full_name, pathp, l);

Interestingly, you check above that the new format string fits exactly in
the buffer, but no check here.  Maybe the check above can be eliminated
with the simplified version.

> +		prev_pp = &np->properties;
> +		**allnextpp = np;
> +		*allnextpp = &np->allnext;
> +		if (dad != NULL) {
> +			np->parent = dad;
> +			/* we temporarily use the next field as `last_child'*/
> +			if (dad->next == 0)
> +				dad->child = np;
> +			else
> +				dad->next->sibling = np;
> +			dad->next = np;
> +		}
> +		kref_init(&np->kref);
> +	}
> +	while (1) {
> +		u32 sz, noff;
> +		char *pname;
> +
> +		tag = *((u32 *)(*p));
> +		if (tag == OF_DT_NOP) {
> +			*p += 4;
> +			continue;
> +		}
> +		if (tag != OF_DT_PROP)
> +			break;
> +		*p += 4;
> +		sz = *((u32 *)(*p));
> +		noff = *((u32 *)((*p) + 4));
> +		*p += 8;
> +		if (initial_boot_params->version < 0x10)
> +			*p = _ALIGN(*p, sz >= 8 ? 8 : 4);
> +
> +		pname = find_flat_dt_string(noff);
> +		if (pname == NULL) {
> +			printk(KERN_INFO "Can't find property name in list!\n");
> +			break;
> +		}
> +		if (strcmp(pname, "name") == 0)
> +			has_name = 1;
> +		l = strlen(pname) + 1;
> +		pp = unflatten_dt_alloc(&mem, sizeof(struct property),
> +					__alignof__(struct property));
> +		if (allnextpp) {
> +			if (strcmp(pname, "linux,phandle") == 0) {
> +				np->node = *((u32 *)*p);
> +				if (np->linux_phandle == 0)
> +					np->linux_phandle = np->node;
> +			}
> +			if (strcmp(pname, "ibm,phandle") == 0)
> +				np->linux_phandle = *((u32 *)*p);
> +			pp->name = pname;
> +			pp->length = sz;
> +			pp->value = (void *)*p;
> +			*prev_pp = pp;
> +			prev_pp = &pp->next;
> +		}
> +		*p = _ALIGN((*p) + sz, 4);
> +	}
> +	/* with version 0x10 we may not have the name property, recreate
> +	 * it here from the unit name if absent
> +	 */
> +	if (!has_name) {
> +		char *p = pathp, *ps = pathp, *pa = NULL;
> +		int sz;
> +
> +		while (*p) {
> +			if ((*p) == '@')
> +				pa = p;
> +			if ((*p) == '/')
> +				ps = p + 1;
> +			p++;
> +		}
> +		if (pa < ps)
> +			pa = p;
> +		sz = (pa - ps) + 1;
> +		pp = unflatten_dt_alloc(&mem, sizeof(struct property) + sz,
> +					__alignof__(struct property));
> +		if (allnextpp) {
> +			pp->name = "name";
> +			pp->length = sz;
> +			pp->value = pp + 1;
> +			*prev_pp = pp;
> +			prev_pp = &pp->next;
> +			memcpy(pp->value, ps, sz - 1);
> +			((char *)pp->value)[sz - 1] = 0;

strlcpy?

> +			DBG("fixed up name for %s -> %s\n", pathp,
> +				(char *)pp->value);
> +		}
> +	}
> +	if (allnextpp) {
> +		*prev_pp = NULL;
> +		np->name = of_get_property(np, "name", NULL);
> +		np->type = of_get_property(np, "device_type", NULL);
> +
> +		if (!np->name)
> +			np->name = "<NULL>";
> +		if (!np->type)
> +			np->type = "<NULL>";
> +	}
> +	while (tag == OF_DT_BEGIN_NODE) {
> +		mem = unflatten_dt_node(mem, p, np, allnextpp, fpsize);
> +		tag = *((u32 *)(*p));
> +	}
> +	if (tag != OF_DT_END_NODE) {
> +		printk(KERN_INFO "Weird tag at end of node: %x\n", tag);
> +		return mem;
> +	}
> +	*p += 4;
> +	return mem;
> +}
> +
> +/**
> + * unflattens the device-tree passed by the firmware, creating the
> + * tree of struct device_node. It also fills the "name" and "type"
> + * pointers of the nodes so the normal device-tree walking functions
> + * can be used (this used to be done by finish_device_tree)
> + */
> +void __init unflatten_device_tree(void)
> +{
> +	unsigned long start, mem, size;
> +	struct device_node **allnextp = &allnodes;
> +
> +	DBG(" -> unflatten_device_tree()\n");
> +	if (!initial_boot_params)
> +		return;
> +	/* First pass, scan for size */
> +	start = ((unsigned long)initial_boot_params) +
> +		initial_boot_params->off_dt_struct;
> +	size = unflatten_dt_node(0, &start, NULL, NULL, 0);
> +	size = (size | 3) + 1;

This might be worth doing proper alignment on - as it is, if 'size' was
already aligned, this will still align it to the _next_ word boundary.

	size = (size + 3) & ~3;

Even better would be:

	size = ALIGN(size, __alignof__(u32));

or whatever type you're requiring it to be aligned to.

> +
> +	DBG("  size is %lx, allocating...\n", size);
> +
> +	/* Allocate memory for the expanded device tree */
> +	mem = (unsigned long) __alloc_bootmem(size + 4,

sizeof(u32) ?

> +			__alignof__(struct device_node), 0);
> +
> +	((u32 *)mem)[size / 4] = 0xdeadbeef;

sizeof(u32) ?  As I side-note, I really hate these casts - it's screaming
that the type of 'mem' is wrong.  Making it a void pointer might be an
improvement (though it does require casts in unflatten_dt_alloc instead.)

	void *mem;
	u32 *mem_endmarker;

	mem = __alloc_bootmem(size + sizeof(u32),
			__alignof__(struct device_node), 0);

	mem_endmarker = mem + size;
	*mem_endmarker = 0xdeadbeef;

	...

	if (*mem_endmarker != 0xdeadbeef)
		printk(...);

looks much nicer and again easier to read, no?

> +
> +	DBG("  unflattening %lx...\n", mem);
> +
> +	/* Second pass, do actual unflattening */
> +	start = ((unsigned long)initial_boot_params) +
> +		initial_boot_params->off_dt_struct;
> +	unflatten_dt_node(mem, &start, NULL, &allnextp, 0);
> +	if (*((u32 *)start) != OF_DT_END)
> +		printk(KERN_WARNING "Weird tag at end of tree: %08x\n",
> +			*((u32 *)start));
> +	if (((u32 *)mem)[size / 4] != 0xdeadbeef)
> +		printk(KERN_WARNING "End of tree marker overwritten: %08x\n",
> +		       ((u32 *)mem)[size / 4]);
> +	*allnextp = NULL;
> +
> +	/* Get pointer to OF "/chosen" node for use everywhere */
> +	of_chosen = of_find_node_by_path("/chosen");
> +	if (of_chosen == NULL)
> +		of_chosen = of_find_node_by_path("/chosen@0");
> +
> +	DBG(" <- unflatten_device_tree()\n");
> +}
> +
> +/**
> + *	of_find_node_by_phandle - Find a node given a phandle
> + *	@handle:	phandle of the node to find
> + *
> + *	Returns a node pointer with refcount incremented, use
> + *	of_node_put() on it when done.
> + */
> +struct device_node *of_find_node_by_phandle(phandle handle)
> +{
> +	struct device_node *np;
> +
> +	read_lock(&devtree_lock);
> +	for (np = allnodes; np != 0; np = np->allnext)
> +		if (np->linux_phandle == handle)
> +			break;
> +	of_node_get(np);
> +	read_unlock(&devtree_lock);
> +	return np;
> +}
> +EXPORT_SYMBOL(of_find_node_by_phandle);
> +
> +struct device_node *of_node_get(struct device_node *node)
> +{
> +	if (node)
> +		kref_get(&node->kref);
> +	return node;
> +}
> +EXPORT_SYMBOL(of_node_get);

Blank line here would be nice.

> +static inline struct device_node *kref_to_device_node(struct kref *kref)
> +{
> +	return container_of(kref, struct device_node, kref);
> +}
> +
> +/**
> + *	of_node_release - release a dynamically allocated node
> + *	@kref:  kref element of the node to be released
> + *
> + *	In of_node_put() this function is passed to kref_put()
> + *	as the destructor.
> + */
> +static void of_node_release(struct kref *kref)
> +{
> +	struct device_node *node = kref_to_device_node(kref);
> +	struct property *prop = node->properties;
> +
> +	/* We should never be releasing nodes that haven't been detached. */
> +	if (!of_node_check_flag(node, OF_DETACHED)) {
> +		printk(KERN_WARNING "WARNING: Bad of_node_put() on %s\n",
> +			node->full_name);
> +		dump_stack();
> +		kref_init(&node->kref);
> +		return;
> +	}
> +
> +	if (!of_node_check_flag(node, OF_DYNAMIC))
> +		return;
> +
> +	while (prop) {
> +		struct property *next = prop->next;
> +		kfree(prop->name);
> +		kfree(prop->value);
> +		kfree(prop);
> +		prop = next;
> +
> +		if (!prop) {
> +			prop = node->deadprops;
> +			node->deadprops = NULL;
> +		}
> +	}
> +	kfree(node->full_name);
> +	kfree(node->data);
> +	kfree(node);
> +}
> +
> +/**
> + *	of_node_put - Decrement refcount of a node
> + *	@node:	Node to dec refcount, NULL is supported to
> + *		simplify writing of callers
> + *
> + */
> +void of_node_put(struct device_node *node)
> +{
> +	if (node)
> +		kref_put(&node->kref, of_node_release);
> +}
> +EXPORT_SYMBOL(of_node_put);
> +
> +int have_of;
> +u32 phys_flat_dev_tree_address __initdata;
> +u32 phys_flat_dev_tree_size __initdata;
> +
> +/* process flat device tree for hardware configuration */
> +static int __init parse_tag_flat_dev_tree_address(const struct tag *tag)
> +{
> +    phys_flat_dev_tree_address =
> +			tag->u.flat_dev_tree_address.flat_dev_tree_address;
> +    phys_flat_dev_tree_size = tag->u.flat_dev_tree_address.flat_dev_tree_size;
> +
> +    have_of = 1;
> +    if (phys_flat_dev_tree_size)
> +	initial_boot_params = phys_to_virt(phys_flat_dev_tree_address);

With shorter names, and elimination of unnecessary variables, this can become:

	if (tag->u.flat_dev_tree.size)
		initial_boot_params = phys_to_virt(tag->u.flat_dev_tree.address);
	have_of = 1;

which is immensely more readable than the above.

> +
> +    printk(KERN_INFO
> +	"%s: flat_dev_tree_address=0x%08x, flat_dev_tree_size == 0x%08X\n",
> +	__func__,
> +	phys_flat_dev_tree_address,
> +	phys_flat_dev_tree_size);

I really hate normal printk's which include things like source file name,
function name, line numbers, etc.  That may be useful for debug messages,
but for normal output it's virtually irrelevent.  It's certainly
irrelevent here - are users or developers going to care that the message
has come from a function called 'parse_tag_flat_dev_tree_address' ?

Of course, the two variable names need to become the versions in the
tag itself.

> +
> +    return 0;
> +}
> +
> +__tagtable(ATAG_FLAT_DEV_TREE_ADDRESS, parse_tag_flat_dev_tree_address);
> diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
> index 68d6494..8b219ec 100644
> --- a/arch/arm/kernel/setup.c
> +++ b/arch/arm/kernel/setup.c
> @@ -35,6 +35,7 @@
>  #include <asm/cacheflush.h>
>  #include <asm/cachetype.h>
>  #include <asm/tlbflush.h>
> +#include <asm/prom.h>
>  
>  #include <asm/mach/arch.h>
>  #include <asm/mach/irq.h>
> @@ -726,6 +727,7 @@ void __init setup_arch(char **cmdline_p)
>  	parse_cmdline(cmdline_p, from);
>  	paging_init(mdesc);
>  	request_standard_resources(&meminfo, mdesc);
> +	unflatten_device_tree();

Might this want to come immediately after 'paging_init' but before
'request_standard_resources' ?  If we want resources to be controlled
by device tree stuff then it would have to be.

The other point which occurs to me is that on ARM, platforms do some
kind of platform specific setup in paging_init() - that may be an
issue which will need to be revisited.

>  
>  #ifdef CONFIG_SMP
>  	smp_init_cpus();
> diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
> index f821dbc..c23a6ea 100644
> --- a/drivers/of/Kconfig
> +++ b/drivers/of/Kconfig
> @@ -1,6 +1,6 @@
>  config OF_DEVICE
>  	def_bool y
> -	depends on OF && (SPARC || PPC_OF)
> +	depends on OF && (SPARC || PPC_OF || ARM)
>  
>  config OF_GPIO
>  	def_bool y
> 
> 
> -------------------------------------------------------------------
> List admin: http://lists.arm.linux.org.uk/mailman/listinfo/linux-arm-kernel
> FAQ:        http://www.arm.linux.org.uk/mailinglists/faq.php
> Etiquette:  http://www.arm.linux.org.uk/mailinglists/etiquette.php
