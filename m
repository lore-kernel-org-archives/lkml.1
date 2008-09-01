Return-Path: <linux-kernel-owner+w=401wt.eu-S1758209AbYIAQlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758209AbYIAQlV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 12:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753342AbYIAQlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 12:41:08 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:46104 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825AbYIAQlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 12:41:06 -0400
Date: Mon, 1 Sep 2008 10:41:04 -0600
From: Alex Chiang <achiang@hp.com>
To: "Zhao, Yu" <yu.zhao@intel.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>, Greg KH <greg@kroah.com>,
       Grant Grundler <grundler@parisc-linux.org>,
       Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com
Subject: Re: [PATCH 3/4 v2] PCI: support SR-IOV capability
Message-ID: <20080901164104.GG16796@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	"Zhao, Yu" <yu.zhao@intel.com>,
	Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
	Randy Dunlap <randy.dunlap@oracle.com>, Greg KH <greg@kroah.com>,
	Grant Grundler <grundler@parisc-linux.org>,
	Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
	xen-devel@lists.xensource.com
References: <7A25B56E4BE99C4283EB931CD1A40E110177EB6F@pdsmsx414.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7A25B56E4BE99C4283EB931CD1A40E110177EB6F@pdsmsx414.ccr.corp.intel.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Zhao, Yu <yu.zhao@intel.com>:
> Support SR-IOV capability. By default, this feature is not enabled and the SR-IOV device behaves as traditional PCI device. After it's enabled, each Virtual Function's PCI configuration space can be accessed using its own Bus, Device and Function Number (Routing ID). Each Virtual Function also has PCI Memory Space, which is used to map its own register set.
> 
> Signed-off-by: Yu Zhao <yu.zhao@intel.com>
> Signed-off-by: Eddie Dong <eddie.dong@intel.com>
> 
> ---
>  drivers/pci/Kconfig      |   10 +
>  drivers/pci/Makefile     |    2 +
>  drivers/pci/iov.c        |  555 ++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/pci/pci.c        |   14 +-
>  drivers/pci/pci.h        |   44 ++++
>  drivers/pci/probe.c      |    5 +
>  include/linux/pci.h      |   28 +++
>  include/linux/pci_regs.h |   20 ++
>  8 files changed, 677 insertions(+), 1 deletions(-)
>  create mode 100644 drivers/pci/iov.c
> 
> diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
> index f43cc46..0a1fe01 100644
> --- a/drivers/pci/Kconfig
> +++ b/drivers/pci/Kconfig
> @@ -57,3 +57,13 @@ config PCI_ARI
>  	default n
>  	help
>  	  This enables PCI Alternative Routing-ID Interpretation.
> +
> +config PCI_IOV
> +	bool "PCI SR-IOV support"
> +	depends on PCI && HOTPLUG
> +	select PCI_MSI
> +	select PCI_ARI
> +	select HOTPLUG_PCI
> +	default n
> +	help
> +	  This allows device drivers to enable Single Root I/O Virtualization.
> diff --git a/drivers/pci/Makefile b/drivers/pci/Makefile
> index 96f2767..2dcefce 100644
> --- a/drivers/pci/Makefile
> +++ b/drivers/pci/Makefile
> @@ -55,3 +55,5 @@ EXTRA_CFLAGS += -DDEBUG
>  endif
>  
>  obj-$(CONFIG_PCI_ARI) += ari.o
> +
> +obj-$(CONFIG_PCI_IOV) += iov.o
> diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
> new file mode 100644
> index 0000000..0656655
> --- /dev/null
> +++ b/drivers/pci/iov.c
> @@ -0,0 +1,555 @@
> +/*
> + * drivers/pci/iov.c
> + *
> + * Copyright (C) 2008 Intel Corporation, Yu Zhao <yu.zhao@intel.com>
> + *
> + * PCI Express Single Root I/O Virtualization capability support.
> + */
> +
> +#include <linux/ctype.h>
> +#include <linux/string.h>
> +#include <linux/pci.h>
> +#include <linux/pci_hotplug.h>
> +#include <linux/delay.h>
> +#include <asm/page.h>
> +
> +#include "pci.h"
> +
> +
> +#define PCI_IOV_SLOTNAME_LEN	24
> +
> +#define notify(dev, event, id, param) ({ \
> +	dev->iov->cb ? dev->iov->cb(dev, event, id, param) : 0; \
> +})
> +
> +
> +struct virtfn_slot {
> +	int id;
> +	char name[PCI_IOV_SLOTNAME_LEN];
> +	struct pci_dev *dev;
> +	struct list_head node;
> +	struct hotplug_slot *slot;
> +};
> +
> +static int enable_virtfn(struct hotplug_slot *);
> +static int disable_virtfn(struct hotplug_slot *);
> +static int set_virtfn_param(struct hotplug_slot *, const char *, int);
> +static int get_virtfn_param(struct hotplug_slot *, const char **);
> +
> +static struct hotplug_slot_ops virtfn_slot_ops = {
> +	.owner			= THIS_MODULE,
> +	.enable_slot		= enable_virtfn,
> +	.disable_slot		= disable_virtfn,
> +	.set_param		= set_virtfn_param,
> +	.get_param		= get_virtfn_param
> +};
> +
> +static DEFINE_MUTEX(iov_lock);
> +
> +
> +static inline void get_addr(struct pci_dev *dev, int id, u8 *busnr, u8 *devfn)
> +{
> +	u16 addr;
> +
> +	addr = (dev->bus->number << 8) + dev->devfn +
> +	      dev->iov->offset + dev->iov->stride * id;
> +	*busnr = addr >> 8;
> +	*devfn = addr & 0xff;
> +}
> +
> +static inline struct pci_bus *find_bus(struct pci_dev *dev, int busnr)
> +{
> +	struct pci_bus *bus;
> +
> +	down_read(&pci_bus_sem);
> +	list_for_each_entry(bus, &dev->bus->children, node)
> +		if (bus->number == busnr) {
> +			up_read(&pci_bus_sem);
> +			return bus;
> +		}
> +	up_read(&pci_bus_sem);
> +
> +	return NULL;
> +}
> +
> +static int alloc_virtfn(struct pci_dev *dev, int id)
> +{
> +	int i;
> +	int rc;
> +	u8 busnr, devfn;
> +	unsigned long size;
> +	struct pci_dev *new;
> +	struct pci_bus *bus;
> +	struct resource *res;
> +
> +	get_addr(dev, id, &busnr, &devfn);
> +
> +	new = alloc_pci_dev();
> +	if (!new)
> +		return -ENOMEM;
> +
> +	bus = find_bus(dev, busnr);
> +	BUG_ON(!bus);
> +	new->bus = bus;
> +	new->sysdata = bus->sysdata;
> +	new->dev.parent = dev->dev.parent;
> +	new->dev.bus = dev->dev.bus;
> +	new->devfn = devfn;
> +	new->hdr_type = PCI_HEADER_TYPE_NORMAL;
> +	new->multifunction = 0;
> +	new->vendor = dev->vendor;
> +	pci_read_config_word(dev, dev->iov->cap + PCI_IOV_VF_DID, &new->device);
> +	new->cfg_size = 4096;
> +	new->error_state = pci_channel_io_normal;
> +	new->pcie_type = PCI_EXP_TYPE_ENDPOINT;
> +	new->dma_mask = 0xffffffff;
> +
> +	dev_set_name(&new->dev, "%04x:%02x:%02x.%d", pci_domain_nr(bus),
> +		     busnr, PCI_SLOT(devfn), PCI_FUNC(devfn));
> +
> +	pci_read_config_byte(new, PCI_REVISION_ID, &new->revision);
> +	new->class = dev->class;
> +	new->current_state = PCI_UNKNOWN;
> +	new->irq = 0;
> +
> +	for (i = 0; i < PCI_IOV_NUM_BAR; i++) {
> +		res = dev->resource + PCI_IOV_RESOURCES + i;
> +		if (!res->parent)
> +			continue;
> +		new->resource[i].name = pci_name(new);
> +		new->resource[i].flags = res->flags;
> +		size = resource_size(res) / dev->iov->total;
> +		new->resource[i].start = res->start + size * id;
> +		new->resource[i].end = new->resource[i].start + size - 1;
> +		rc = request_resource(res, &new->resource[i]);
> +		BUG_ON(rc);
> +	}
> +
> +	new->subsystem_vendor = dev->subsystem_vendor;
> +	pci_read_config_word(new, PCI_SUBSYSTEM_ID, &new->subsystem_device);
> +
> +	pci_device_add(new, bus);
> +	return pci_bus_add_device(new);
> +}
> +
> +static int enable_virtfn(struct hotplug_slot *slot)
> +{
> +	int rc;
> +	u8 busnr, devfn;
> +	struct pci_dev *dev;
> +	struct virtfn_slot *vslot = slot->private;
> +
> +	get_addr(vslot->dev, vslot->id, &busnr, &devfn);
> +
> +	mutex_lock(&iov_lock);
> +	dev = pci_get_bus_and_slot(busnr, devfn);
> +	if (dev) {
> +		pci_dev_put(dev);
> +		rc = -EINVAL;
> +		goto out;
> +	}
> +
> +	rc = notify(vslot->dev, PCI_IOV_VF_ENABLE,
> +		     vslot->id, vslot->slot->info->param);
> +	if (rc)
> +		goto out;
> +
> +	rc = alloc_virtfn(vslot->dev, vslot->id);
> +	if (!rc)
> +		slot->info->power_status = 1;
> +out:
> +	mutex_unlock(&iov_lock);
> +
> +	return rc;
> +}
> +
> +static int disable_virtfn(struct hotplug_slot *slot)
> +{
> +	int rc;
> +	u8 busnr, devfn;
> +	struct pci_dev *dev;
> +	struct virtfn_slot *vslot = slot->private;
> +
> +	get_addr(vslot->dev, vslot->id, &busnr, &devfn);
> +
> +	mutex_lock(&iov_lock);
> +	dev = pci_get_bus_and_slot(busnr, devfn);
> +	if (!dev) {
> +		rc = -ENODEV;
> +		goto out;
> +	}
> +
> +	pci_dev_put(dev);
> +	pci_remove_bus_device(dev);
> +	rc = notify(vslot->dev, PCI_IOV_VF_DISABLE, vslot->id, NULL);
> +	slot->info->power_status = 0;
> +out:
> +	mutex_unlock(&iov_lock);
> +
> +	return rc;
> +}
> +
> +static int set_virtfn_param(struct hotplug_slot *slot, const char *buf, int len)
> +{
> +	int rc;
> +	struct virtfn_slot *vslot = slot->private;
> +
> +	if (len > PCI_IOV_PARAM_LEN)
> +		return -E2BIG;
> +
> +	strcpy(slot->info->param, buf);
> +	rc = notify(vslot->dev, PCI_IOV_VF_SETPARAM,
> +		     vslot->id, vslot->slot->info->param);
> +	if (rc)
> +		memset(slot->info->param, 0, PCI_IOV_PARAM_LEN);
> +
> +	return rc;
> +}
> +
> +static int get_virtfn_param(struct hotplug_slot *slot, const char **param)
> +{
> +	int rc;
> +	struct virtfn_slot *vslot = slot->private;
> +
> +	rc = notify(vslot->dev, PCI_IOV_VF_GETPARAM,
> +		     vslot->id, vslot->slot->info->param);
> +	if (!rc)
> +		*param = slot->info->param;
> +
> +	return rc;
> +}
> +
> +static void remove_slot(struct hotplug_slot *slot)
> +{
> +	struct virtfn_slot *vslot = slot->private;
> +
> +	disable_virtfn(slot);
> +	pci_dev_put(vslot->dev);
> +	list_del(&vslot->node);
> +	kfree(slot->info->param);
> +	kfree(slot->info);
> +	kfree(slot);
> +	kfree(vslot);
> +}
> +
> +static int add_slot(struct pci_dev *dev, int id)
> +{
> +	int rc = -ENOMEM;
> +	u8 busnr, devfn;
> +	struct pci_bus *bus;
> +	struct hotplug_slot *slot;
> +	struct virtfn_slot *vslot;
> +
> +	slot = kzalloc(sizeof(*slot), GFP_KERNEL);
> +	if (!slot)
> +		return rc;
> +
> +	slot->info = kzalloc(sizeof(*slot->info), GFP_KERNEL);
> +	if (!slot->info)
> +		goto failed1;
> +
> +	slot->info->param = kzalloc(PCI_IOV_PARAM_LEN, GFP_KERNEL);
> +	if (!slot->info)
> +		goto failed2;
> +
> +	vslot = kzalloc(sizeof(*vslot), GFP_KERNEL);
> +	if (!vslot)
> +		goto failed3;
> +
> +	slot->name = vslot->name;
> +	sprintf(slot->name, "%s-iov-%04x", pci_name(dev), id);
> +	slot->ops = &virtfn_slot_ops;
> +	slot->release = &remove_slot;
> +	slot->private = vslot;
> +	vslot->id = id;
> +	vslot->dev = pci_dev_get(dev);
> +	vslot->slot = slot;
> +
> +	get_addr(dev, id, &busnr, &devfn);
> +	bus = find_bus(dev, busnr);
> +	BUG_ON(!bus);
> +
> +	/* use device and function # as slot # */
> +	rc = pci_hp_register(slot, bus, devfn);
> +	if (rc)
> +		goto failed4;

So, what happens if another hotplug driver is already loaded?

I don't know the SR-IOV spec well enough to know if you are
allowed to have SR-IOV + some other form of hotplug, like ACPI or
native PCIe.

Today, pci_hp_register will return -EBUSY.

If SR-IOV really doesn't have anything to do with hotplug, then
it may be a candidate for directly calling pci_create_slot(). In
that case, 'param' should not be a property of a hotplug slot,
but of a generic PCI slot.

Thanks.

/ac

