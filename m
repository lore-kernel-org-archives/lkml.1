Return-Path: <linux-kernel-owner+w=401wt.eu-S1756251AbYIAQPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251AbYIAQPs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 12:15:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752271AbYIAQPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 12:15:38 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:30347 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262AbYIAQPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 12:15:35 -0400
Date: Mon, 1 Sep 2008 10:15:34 -0600
From: Alex Chiang <achiang@hp.com>
To: "Zhao, Yu" <yu.zhao@intel.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>, Greg KH <greg@kroah.com>,
       Grant Grundler <grundler@parisc-linux.org>,
       Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com
Subject: Re: [PATCH 1/4 v2] PCI: introduce new base functions
Message-ID: <20080901161534.GF16796@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	"Zhao, Yu" <yu.zhao@intel.com>,
	Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
	Randy Dunlap <randy.dunlap@oracle.com>, Greg KH <greg@kroah.com>,
	Grant Grundler <grundler@parisc-linux.org>,
	Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
	xen-devel@lists.xensource.com
References: <7A25B56E4BE99C4283EB931CD1A40E110177EB6D@pdsmsx414.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7A25B56E4BE99C4283EB931CD1A40E110177EB6D@pdsmsx414.ccr.corp.intel.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Zhao, Yu <yu.zhao@intel.com>:
> Some basic changes to allocation bus range, MMIO resource for SR-IOV device.

This following comment is a bit confusing:
> And add new sysfs entry to hotplug core to pass parameter to a
> slot, which will be used by SR-IOV code.

I was reading this patch, expecting to see a change to the
hotplug core _API_ taking a param, not just a new sysfs entry.

I would suggest rewording this part of the changelog as:

	Add new sysfs file 'param' to /sys/bus/pci/slots/.../
	which allows the user to pass a parameter to a slot. This
	parameter will be used by the SR-IOV code.

More about this new 'param' file below.

> 
> Signed-off-by: Yu Zhao <yu.zhao@intel.com>
> Signed-off-by: Eddie Dong <eddie.dong@intel.com>
> 
> ---
>  drivers/pci/bus.c                      |   63 +++++++++++++-------------
>  drivers/pci/hotplug/pci_hotplug_core.c |   75 +++++++++++++++++++++++++++++---
>  drivers/pci/pci-sysfs.c                |    4 +-
>  drivers/pci/pci.c                      |   68 +++++++++++++++++++++--------
>  drivers/pci/pci.h                      |    3 +
>  drivers/pci/probe.c                    |   37 ++++++++-------
>  drivers/pci/proc.c                     |    7 ++-
>  drivers/pci/remove.c                   |    3 +-
>  drivers/pci/setup-bus.c                |    9 ++--
>  drivers/pci/setup-res.c                |   29 ++++++------
>  include/linux/pci.h                    |   53 ++++++++++++++++-------
>  include/linux/pci_hotplug.h            |   11 ++++-
>  12 files changed, 246 insertions(+), 116 deletions(-)
> 
> diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
> index 529d9d7..15f64c9 100644
> --- a/drivers/pci/bus.c
> +++ b/drivers/pci/bus.c
> @@ -105,7 +105,7 @@ int pci_bus_add_device(struct pci_dev *dev)
>  void pci_bus_add_devices(struct pci_bus *bus)
>  {
>  	struct pci_dev *dev;
> -	struct pci_bus *child_bus;
> +	struct pci_bus *child;
>  	int retval;
>  
>  	list_for_each_entry(dev, &bus->devices, bus_list) {
> @@ -115,43 +115,42 @@ void pci_bus_add_devices(struct pci_bus *bus)
>  		retval = pci_bus_add_device(dev);
>  		if (retval)
>  			dev_err(&dev->dev, "Error adding device, continuing\n");
> -	}
> -
> -	list_for_each_entry(dev, &bus->devices, bus_list) {
> -		BUG_ON(!dev->is_added);
>  
>  		/*
>  		 * If there is an unattached subordinate bus, attach
>  		 * it and then scan for unattached PCI devices.
>  		 */
> -		if (dev->subordinate) {
> -		       if (list_empty(&dev->subordinate->node)) {
> -			       down_write(&pci_bus_sem);
> -			       list_add_tail(&dev->subordinate->node,
> -					       &dev->bus->children);
> -			       up_write(&pci_bus_sem);
> -			}
> -			pci_bus_add_devices(dev->subordinate);
> -
> -			/* register the bus with sysfs as the parent is now
> -			 * properly registered. */
> -			child_bus = dev->subordinate;
> -			if (child_bus->is_added)
> -				continue;
> -			child_bus->dev.parent = child_bus->bridge;
> -			retval = device_register(&child_bus->dev);
> -			if (retval)
> -				dev_err(&dev->dev, "Error registering pci_bus,"
> -					" continuing...\n");
> -			else {
> -				child_bus->is_added = 1;
> -				retval = device_create_file(&child_bus->dev,
> -							&dev_attr_cpuaffinity);
> -			}
> -			if (retval)
> -				dev_err(&dev->dev, "Error creating cpuaffinity"
> -					" file, continuing...\n");
> +		if (!dev->subordinate)
> +			continue;
> +
> +		if (list_empty(&dev->subordinate->node)) {
> +			down_write(&pci_bus_sem);
> +			list_add_tail(&dev->subordinate->node,
> +				      &dev->bus->children);
> +			up_write(&pci_bus_sem);
>  		}
> +		pci_bus_add_devices(dev->subordinate);
> +	}
> +
> +	list_for_each_entry(child, &bus->children, node) {
> +		/* register the bus with sysfs as the parent is now
> +		 * properly registered. */
> +		if (child->is_added)
> +			continue;
> +		if (child->bridge)
> +			child->dev.parent = child->bridge;
> +		retval = device_register(&child->dev);
> +		if (retval) {
> +			dev_err(&dev->dev, "Error registering pci_bus,"
> +					   " continuing...\n");

Please break the 80-column "rule" and make this all one line, to
help with greppability.

I know the prior version had it broken across two lines too, but
we can improve it now. :)

> +			continue;
> +		}
> +		child->is_added = 1;
> +		retval = device_create_file(&child->dev,
> +					    &dev_attr_cpuaffinity);
> +		if (retval)
> +			dev_err(&dev->dev, "Error creating cpuaffinity"
> +					   " file, continuing...\n");

This one too, please.

>  	}
>  }
>  
> diff --git a/drivers/pci/hotplug/pci_hotplug_core.c b/drivers/pci/hotplug/pci_hotplug_core.c
> index 5f85b1b..96f99c7 100644
> --- a/drivers/pci/hotplug/pci_hotplug_core.c
> +++ b/drivers/pci/hotplug/pci_hotplug_core.c
> @@ -102,13 +102,13 @@ static int get_##name (struct hotplug_slot *slot, type *value)		\
>  {									\
>  	struct hotplug_slot_ops *ops = slot->ops;			\
>  	int retval = 0;							\
> -	if (try_module_get(ops->owner)) {				\
> -		if (ops->get_##name)					\
> -			retval = ops->get_##name(slot, value);		\
> -		else							\
> -			*value = slot->info->name;			\
> -		module_put(ops->owner);					\
> -	}								\
> +	if (!try_module_get(ops->owner))				\
> +		return -ENODEV;						\
> +	if (ops->get_##name)						\
> +		retval = ops->get_##name(slot, value);			\
> +	else								\
> +		*value = slot->info->name;				\
> +	module_put(ops->owner);						\
>  	return retval;							\
>  }
>  
> @@ -118,6 +118,7 @@ GET_STATUS(latch_status, u8)
>  GET_STATUS(adapter_status, u8)
>  GET_STATUS(max_bus_speed, enum pci_bus_speed)
>  GET_STATUS(cur_bus_speed, enum pci_bus_speed)
> +GET_STATUS(param, const char *)

So is this new file only used for SR-IOV? Or do you imagine it to
be general-purpose in the future? If SR-IOV only, then I suggest
a different name other than 'param', since that's a very generic
name for a very specific feature.

If you do imagine 'param' to be generally useful, then ignore
this comment. ;)

>  static ssize_t power_read_file(struct pci_slot *slot, char *buf)
>  {
> @@ -346,6 +347,41 @@ static struct pci_slot_attribute hotplug_slot_attr_test = {
>  	.store = test_write_file
>  };
>  
> +static ssize_t param_read_file(struct pci_slot *slot, char *buf)
> +{
> +	int retval;
> +	const char *param;
> +
> +	retval = get_param(slot->hotplug, &param);
> +	if (retval)
> +		return retval;
> +
> +	return param ? snprintf(buf, PAGE_SIZE, "%s\n", param) : -EPERM;
> +}
> +
> +static ssize_t param_write_file(struct pci_slot *slot, const char *buf,
> +		size_t count)
> +{
> +	int retval = -EPERM;
> +	struct hotplug_slot_ops *ops = slot->hotplug->ops;
> +
> +	if (!try_module_get(ops->owner))
> +		return -ENODEV;
> +
> +	if (ops->set_param)
> +		retval = ops->set_param(slot->hotplug, buf, count);
> +
> +	module_put(ops->owner);
> +
> +	return retval ? retval : count;
> +}
> +
> +static struct pci_slot_attribute hotplug_slot_attr_param = {
> +	.attr = {.name = "param", .mode = S_IFREG | S_IRUGO | S_IWUSR},
> +	.show = param_read_file,
> +	.store = param_write_file
> +};
> +
>  static int has_power_file(struct pci_slot *pci_slot)
>  {
>  	struct hotplug_slot *slot = pci_slot->hotplug;
> @@ -419,6 +455,17 @@ static int has_test_file(struct pci_slot *pci_slot)
>  	return -ENOENT;
>  }
>  
> +static int has_param_file(struct pci_slot *pci_slot)
> +{
> +	struct hotplug_slot *slot = pci_slot->hotplug;
> +	if ((!slot) || (!slot->ops))
> +		return -ENODEV;
> +	if ((slot->ops->set_param) ||
> +	    (slot->ops->get_param))
> +		return 0;

CodingStyle?

	if (slot->ops->set_param || slot->ops->get_param)
		return 0;

Seems slightly more readable to me, but it's just a suggestion;
feel free to ignore.

I guess this comment applies to the above line too; you don't
need all those parens around (!slot), etc.

> +	return -ENOENT;
> +}
> +
>  static int fs_add_slot(struct pci_slot *slot)
>  {
>  	int retval = 0;
> @@ -471,8 +518,19 @@ static int fs_add_slot(struct pci_slot *slot)
>  			goto exit_test;
>  	}
>  
> +	if (has_param_file(slot) == 0) {
> +		retval = sysfs_create_file(&slot->kobj,
> +					   &hotplug_slot_attr_param.attr);
> +		if (retval)
> +			goto exit_param;
> +	}
> +
>  	goto exit;
>  
> +exit_param:
> +	if (has_param_file(slot) == 0)
> +		sysfs_remove_file(&slot->kobj, &hotplug_slot_attr_param.attr);
> +
>  exit_test:
>  	if (has_cur_bus_speed_file(slot) == 0)
>  		sysfs_remove_file(&slot->kobj, &hotplug_slot_attr_cur_bus_speed.attr);
> @@ -523,6 +581,9 @@ static void fs_remove_slot(struct pci_slot *slot)
>  
>  	if (has_test_file(slot) == 0)
>  		sysfs_remove_file(&slot->kobj, &hotplug_slot_attr_test.attr);
> +
> +	if (has_param_file(slot) == 0)
> +		sysfs_remove_file(&slot->kobj, &hotplug_slot_attr_param.attr);
>  }
>  
>  static struct hotplug_slot *get_slot_from_name (const char *name)
> diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
> index 9c71858..f466937 100644
> --- a/drivers/pci/pci-sysfs.c
> +++ b/drivers/pci/pci-sysfs.c
> @@ -100,11 +100,13 @@ resource_show(struct device * dev, struct device_attribute *attr, char * buf)
>  	struct pci_dev * pci_dev = to_pci_dev(dev);
>  	char * str = buf;
>  	int i;
> -	int max = 7;
> +	int max;
>  	resource_size_t start, end;
>  
>  	if (pci_dev->subordinate)
>  		max = DEVICE_COUNT_RESOURCE;
> +	else
> +		max = PCI_BRIDGE_RESOURCES;
>  
>  	for (i = 0; i < max; i++) {
>  		struct resource *res =  &pci_dev->resource[i];
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index c9884bb..c1108ed 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -356,25 +356,10 @@ pci_find_parent_resource(const struct pci_dev *dev, struct resource *res)
>  static void
>  pci_restore_bars(struct pci_dev *dev)
>  {
> -	int i, numres;
> -
> -	switch (dev->hdr_type) {
> -	case PCI_HEADER_TYPE_NORMAL:
> -		numres = 6;
> -		break;
> -	case PCI_HEADER_TYPE_BRIDGE:
> -		numres = 2;
> -		break;
> -	case PCI_HEADER_TYPE_CARDBUS:
> -		numres = 1;
> -		break;
> -	default:
> -		/* Should never get here, but just in case... */
> -		return;
> -	}
> +	int i;
>  
> -	for (i = 0; i < numres; i ++)
> -		pci_update_resource(dev, &dev->resource[i], i);
> +	for (i = 0; i < PCI_BRIDGE_RESOURCES; i++)
> +		pci_update_resource(dev, i);
>  }
>  
>  static struct pci_platform_pm_ops *pci_platform_pm;
> @@ -1864,6 +1849,53 @@ int pci_select_bars(struct pci_dev *dev, unsigned long flags)
>  	return bars;
>  }
>  
> +/**
> + * pci_resource_alignment - get a PCI BAR resource alignment
> + * @dev: the PCI device
> + * @resno: the resource number
> + *
> + * Returns alignment size on success, or 0 on error.
> + */
> +int pci_resource_alignment(struct pci_dev *dev, int resno)
> +{
> +	resource_size_t align;
> +	struct resource *res = dev->resource + resno;
> +
> +	align = resource_alignment(res);
> +	if (align)
> +		return align;
> +
> +	if (resno <= PCI_ROM_RESOURCE)
> +		return resource_size(res);
> +	else if (resno <= PCI_BRIDGE_RES_END)
> +		return res->start;
> +
> +	dev_err(&dev->dev, "alignment: invalid resource #: %d\n", resno);
> +	return 0;
> +}
> +
> +/**
> + * pci_resource_bar - get position of the BAR associated with a resource
> + * @dev: the PCI device
> + * @resno: the resource number
> + * @type: the BAR type to be filled in
> + *
> + * Returns BAR position in config space, or 0 if the BAR is invalid.
> + */
> +int pci_resource_bar(struct pci_dev *dev, int resno, enum pci_bar_type *type)
> +{
> +	if (resno < PCI_ROM_RESOURCE) {
> +		*type = pci_bar_unknown;
> +		return PCI_BASE_ADDRESS_0 + 4 * resno;
> +	} else if (resno == PCI_ROM_RESOURCE) {
> +		*type = pci_bar_rom;
> +		return dev->rom_base_reg;
> +	}
> +
> +	dev_err(&dev->dev, "BAR: invalid resource #: %d\n", resno);
> +	return 0;
> +}
> +
>  static void __devinit pci_no_domains(void)
>  {
>  #ifdef CONFIG_PCI_DOMAINS
> diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
> index d807cd7..5abd69c 100644
> --- a/drivers/pci/pci.h
> +++ b/drivers/pci/pci.h
> @@ -144,3 +144,6 @@ struct pci_slot_attribute {
>  };
>  #define to_pci_slot_attr(s) container_of(s, struct pci_slot_attribute, attr)
>  
> +extern int pci_resource_alignment(struct pci_dev *dev, int resno);
> +extern int pci_resource_bar(struct pci_dev *dev, int resno,
> +			    enum pci_bar_type *type);
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index cce2f4c..3994ea3 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -203,13 +203,6 @@ static u64 pci_size(u64 base, u64 maxbase, u64 mask)
>  	return size;
>  }
>  
> -enum pci_bar_type {
> -	pci_bar_unknown,	/* Standard PCI BAR probe */
> -	pci_bar_io,		/* An io port BAR */
> -	pci_bar_mem32,		/* A 32-bit memory BAR */
> -	pci_bar_mem64,		/* A 64-bit memory BAR */
> -};
> -
>  static inline enum pci_bar_type decode_bar(struct resource *res, u32 bar)
>  {
>  	if ((bar & PCI_BASE_ADDRESS_SPACE) == PCI_BASE_ADDRESS_SPACE_IO) {
> @@ -224,16 +217,21 @@ static inline enum pci_bar_type decode_bar(struct resource *res, u32 bar)
>  	return pci_bar_mem32;
>  }
>  
> -/*
> - * If the type is not unknown, we assume that the lowest bit is 'enable'.
> - * Returns 1 if the BAR was 64-bit and 0 if it was 32-bit.
> +/**
> + * pci_read_base - read a PCI BAR
> + * @dev: the PCI device
> + * @type: type of the BAR
> + * @res: resource buffer to be filled in
> + * @pos: BAR position in the config space
> + *
> + * Returns 1 if the BAR is 64-bit, or 0 if 32-bit.
>   */
> -static int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
> +int pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
>  			struct resource *res, unsigned int pos)
>  {
>  	u32 l, sz, mask;
>  
> -	mask = type ? ~PCI_ROM_ADDRESS_ENABLE : ~0;
> +	mask = (type == pci_bar_rom) ? ~PCI_ROM_ADDRESS_ENABLE : ~0;
>  
>  	res->name = pci_name(dev);
>  
> @@ -258,7 +256,7 @@ static int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
>  	if (l == 0xffffffff)
>  		l = 0;
>  
> -	if (type == pci_bar_unknown) {
> +	if (type != pci_bar_rom) {
>  		type = decode_bar(res, l);
>  		res->flags |= pci_calc_resource_flags(l) | IORESOURCE_SIZEALIGN;
>  		if (type == pci_bar_io) {
> @@ -321,6 +319,7 @@ static int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
>  	res->flags = 0;
>  	goto out;
>  }
> +EXPORT_SYMBOL_GPL(pci_read_base);
>  
>  static void pci_read_bases(struct pci_dev *dev, unsigned int howmany, int rom)
>  {
> @@ -329,7 +328,7 @@ static void pci_read_bases(struct pci_dev *dev, unsigned int howmany, int rom)
>  	for (pos = 0; pos < howmany; pos++) {
>  		struct resource *res = &dev->resource[pos];
>  		reg = PCI_BASE_ADDRESS_0 + (pos << 2);
> -		pos += __pci_read_base(dev, pci_bar_unknown, res, reg);
> +		pos += pci_read_base(dev, pci_bar_unknown, res, reg);
>  	}
>  
>  	if (rom) {
> @@ -338,7 +337,7 @@ static void pci_read_bases(struct pci_dev *dev, unsigned int howmany, int rom)
>  		res->flags = IORESOURCE_MEM | IORESOURCE_PREFETCH |
>  				IORESOURCE_READONLY | IORESOURCE_CACHEABLE |
>  				IORESOURCE_SIZEALIGN;
> -		__pci_read_base(dev, pci_bar_mem32, res, rom);
> +		pci_read_base(dev, pci_bar_rom, res, rom);
>  	}
>  }
>  
> @@ -462,12 +461,10 @@ static struct pci_bus *pci_alloc_child_bus(struct pci_bus *parent,
>  	if (!child)
>  		return NULL;
>  
> -	child->self = bridge;
>  	child->parent = parent;
>  	child->ops = parent->ops;
>  	child->sysdata = parent->sysdata;
>  	child->bus_flags = parent->bus_flags;
> -	child->bridge = get_device(&bridge->dev);
>  
>  	/* initialize some portions of the bus device, but don't register it
>  	 * now as the parent is not properly set up yet.  This device will get
> @@ -484,6 +481,11 @@ static struct pci_bus *pci_alloc_child_bus(struct pci_bus *parent,
>  	child->primary = parent->secondary;
>  	child->subordinate = 0xff;
>  
> +	if (!bridge)
> +		goto done;
> +
> +	child->self = bridge;
> +	child->bridge = get_device(&bridge->dev);
>  	/* Set up default resource pointers and names.. */
>  	for (i = 0; i < 4; i++) {
>  		child->resource[i] = &bridge->resource[PCI_BRIDGE_RESOURCES+i];
> @@ -491,6 +493,7 @@ static struct pci_bus *pci_alloc_child_bus(struct pci_bus *parent,
>  	}
>  	bridge->subordinate = child;
>  
> +done:
>  	return child;
>  }
>  
> diff --git a/drivers/pci/proc.c b/drivers/pci/proc.c
> index e1098c3..f6f2a59 100644
> --- a/drivers/pci/proc.c
> +++ b/drivers/pci/proc.c
> @@ -352,15 +352,16 @@ static int show_device(struct seq_file *m, void *v)
>  			dev->vendor,
>  			dev->device,
>  			dev->irq);
> -	/* Here should be 7 and not PCI_NUM_RESOURCES as we need to preserve compatibility */
> -	for (i=0; i<7; i++) {
> +
> +	/* only print standard and ROM resources to preserve compatibility */
> +	for (i = 0; i <= PCI_ROM_RESOURCE; i++) {

Why not:

	for (i = 0; i < PCI_BRIDGE_RESOURCES; i++) {

Looks like the tradeoff is explicit mention of PCI_ROM_RESOURCE
vs using a non-standard C idiom (personally, I'm not a huge fan
of <= in a for loop, but ymmv).

Again, this is a minor nit, feel free to ignore.

>  		resource_size_t start, end;
>  		pci_resource_to_user(dev, i, &dev->resource[i], &start, &end);
>  		seq_printf(m, "\t%16llx",
>  			(unsigned long long)(start |
>  			(dev->resource[i].flags & PCI_REGION_FLAG_MASK)));
>  	}
> -	for (i=0; i<7; i++) {
> +	for (i = 0; i <= PCI_ROM_RESOURCE; i++) {

Same comment as above.

>  		resource_size_t start, end;
>  		pci_resource_to_user(dev, i, &dev->resource[i], &start, &end);
>  		seq_printf(m, "\t%16llx",
> diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
> index bdc2a44..3501068 100644
> --- a/drivers/pci/remove.c
> +++ b/drivers/pci/remove.c
> @@ -73,7 +73,8 @@ void pci_remove_bus(struct pci_bus *pci_bus)
>  	up_write(&pci_bus_sem);
>  	pci_remove_legacy_files(pci_bus);
>  	device_remove_file(&pci_bus->dev, &dev_attr_cpuaffinity);
> -	device_unregister(&pci_bus->dev);
> +	if (pci_bus->is_added)
> +		device_unregister(&pci_bus->dev);
>  }
>  EXPORT_SYMBOL(pci_remove_bus);
>  
> diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
> index 82634a2..78f2f16 100644
> --- a/drivers/pci/setup-bus.c
> +++ b/drivers/pci/setup-bus.c
> @@ -26,6 +26,8 @@
>  #include <linux/cache.h>
>  #include <linux/slab.h>
>  
> +#include "pci.h"
> +

Stray newline above the #include statement?

>  static void pbus_assign_resources_sorted(struct pci_bus *bus)
>  {
> @@ -299,7 +301,7 @@ static void pbus_size_io(struct pci_bus *bus)
>  
>  			if (r->parent || !(r->flags & IORESOURCE_IO))
>  				continue;
> -			r_size = r->end - r->start + 1;
> +			r_size = resource_size(r);
>  
>  			if (r_size < 0x400)
>  				/* Might be re-aligned for ISA */
> @@ -350,9 +352,8 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask, unsigned long
>  
>  			if (r->parent || (r->flags & mask) != type)
>  				continue;
> -			r_size = r->end - r->start + 1;
> -			/* For bridges size != alignment */
> -			align = (i < PCI_BRIDGE_RESOURCES) ? r_size : r->start;
> +			r_size = resource_size(r);
> +			align = pci_resource_alignment(dev, i);
>  			order = __ffs(align) - 20;
>  			if (order > 11) {
>  				dev_warn(&dev->dev, "BAR %d too large: "
> diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
> index 1a5fc83..b6bb1ad 100644
> --- a/drivers/pci/setup-res.c
> +++ b/drivers/pci/setup-res.c
> @@ -26,11 +26,13 @@
>  #include "pci.h"
>  
>  
> -void pci_update_resource(struct pci_dev *dev, struct resource *res, int resno)
> +void pci_update_resource(struct pci_dev *dev, int resno)
>  {
>  	struct pci_bus_region region;
>  	u32 new, check, mask;
>  	int reg;
> +	enum pci_bar_type type;
> +	struct resource *res = dev->resource + resno;
>  
>  	/*
>  	 * Ignore resources for unimplemented BARs and unused resource slots
> @@ -63,17 +65,13 @@ void pci_update_resource(struct pci_dev *dev, struct resource *res, int resno)
>  	else
>  		mask = (u32)PCI_BASE_ADDRESS_MEM_MASK;
>  
> -	if (resno < 6) {
> -		reg = PCI_BASE_ADDRESS_0 + 4 * resno;
> -	} else if (resno == PCI_ROM_RESOURCE) {
> +	reg = pci_resource_bar(dev, resno, &type);
> +	if (!reg)
> +		return;
> +	if (type == pci_bar_rom) {
>  		if (!(res->flags & IORESOURCE_ROM_ENABLE))
>  			return;
>  		new |= PCI_ROM_ADDRESS_ENABLE;
> -		reg = dev->rom_base_reg;
> -	} else {
> -		/* Hmm, non-standard resource. */
> -	
> -		return;		/* kill uninitialised var warning */
>  	}
>  
>  	pci_write_config_dword(dev, reg, new);
> @@ -133,10 +131,10 @@ int pci_assign_resource(struct pci_dev *dev, int resno)
>  	resource_size_t size, min, align;
>  	int ret;
>  
> -	size = res->end - res->start + 1;
> +	size = resource_size(res);
>  	min = (res->flags & IORESOURCE_IO) ? PCIBIOS_MIN_IO : PCIBIOS_MIN_MEM;
>  
> -	align = resource_alignment(res);
> +	align = pci_resource_alignment(dev, resno);
>  	if (!align) {
>  		dev_err(&dev->dev, "BAR %d: can't allocate resource (bogus "
>  			"alignment) [%#llx-%#llx] flags %#lx\n",
> @@ -170,7 +168,7 @@ int pci_assign_resource(struct pci_dev *dev, int resno)
>  	} else {
>  		res->flags &= ~IORESOURCE_STARTALIGN;
>  		if (resno < PCI_BRIDGE_RESOURCES)
> -			pci_update_resource(dev, res, resno);
> +			pci_update_resource(dev, resno);
>  	}
>  
>  	return ret;
> @@ -208,7 +206,7 @@ int pci_assign_resource_fixed(struct pci_dev *dev, int resno)
>  			(unsigned long long)res->start,
>  			(unsigned long long)res->end);
>  	} else if (resno < PCI_BRIDGE_RESOURCES) {
> -		pci_update_resource(dev, res, resno);
> +		pci_update_resource(dev, resno);
>  	}
>  
>  	return ret;
> @@ -234,7 +232,7 @@ void pdev_sort_resources(struct pci_dev *dev, struct resource_list *head)
>  		if (!(r->flags) || r->parent)
>  			continue;
>  
> -		r_align = resource_alignment(r);
> +		r_align = pci_resource_alignment(dev, i);
>  		if (!r_align) {
>  			dev_warn(&dev->dev, "BAR %d: bogus alignment "
>  				"[%#llx-%#llx] flags %#lx\n",
> @@ -247,7 +245,8 @@ void pdev_sort_resources(struct pci_dev *dev, struct resource_list *head)
>  			struct resource_list *ln = list->next;
>  
>  			if (ln)
> -				align = resource_alignment(ln->res);
> +				align = pci_resource_alignment(ln->dev,
> +						ln->res - ln->dev->resource);
>  
>  			if (r_align > align) {
>  				tmp = kmalloc(sizeof(*tmp), GFP_KERNEL);
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index c0e1400..687be00 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -76,7 +76,29 @@ enum pci_mmap_state {
>  #define PCI_DMA_FROMDEVICE	2
>  #define PCI_DMA_NONE		3
>  
> -#define DEVICE_COUNT_RESOURCE	12
> +/*
> + *  For PCI devices, the region numbers are assigned this way:
> + */
> +enum {
> +	/* 0-5	standard PCI regions */
> +	PCI_STD_RESOURCE,
> +
> +	/* expansion ROM */
> +	PCI_ROM_RESOURCE = 6,
> +
> +	/* address space assigned to buses behind the bridge */
> +#ifndef PCI_BRIDGE_NUM_RES
> +#define PCI_BRIDGE_NUM_RES 4
> +#endif
> +	PCI_BRIDGE_RESOURCES,
> +	PCI_BRIDGE_RES_END = PCI_BRIDGE_RESOURCES + PCI_BRIDGE_NUM_RES - 1,
> +
> +	/* total resources associated with a PCI device */
> +	PCI_NUM_RESOURCES,
> +
> +	/* preserve this for compatibility */
> +	DEVICE_COUNT_RESOURCE
> +};

Ouch, this enum makes my head hurt a little. Care to put in a
comment for PCI_BRIDGE_RES_END, saying that it has a value of 10?

Thanks,

/ac

