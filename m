Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166Ab0CCMRg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 07:17:36 -0500
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:57571 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531Ab0CCMRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 07:17:30 -0500
Date: Wed, 3 Mar 2010 13:17:26 +0100
From: Bastian Blank <waldi@debian.org>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH 4 of 4] Linux pvops: xen pci platform
	device driver
Message-ID: <20100303121726.GA26656@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <waldi@debian.org>,
	xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
References: <alpine.DEB.2.00.1003021748250.22259@kaball-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1003021748250.22259@kaball-desktop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 02, 2010 at 06:31:10PM +0000, Stefano Stabellini wrote:
> +config XEN_PLATFORM_PCI
> +	bool "xen platform pci device driver"

Case? Why does this need to be built-in?

> +	depends on XEN
> +	select XEN_XENBUS_FRONTEND
> +	help
> +	  Necessary to run Xen PV drivers in Xen HVM domains.

A little bit short.

> -	gsv.version = 2;
> +	if (xen_hvm_domain())
> +		gsv.version = 1;
> +	else
> +		gsv.version = 2;
>  	rc = HYPERVISOR_grant_table_op(GNTTABOP_set_version, &gsv, 1);
>  	if (rc == 0)
> -		grant_table_version = 2;
> +		grant_table_version = xen_hvm_domain() ? 1 : 2;

Why is version 1 grant table the default on HVM?

> -		grant_table_version = 1;
> +		grant_table_version = xen_hvm_domain() ? 2 : 1;

But then, this makes no sense for me.

> -static int __devinit gnttab_init(void)
> +int gnttab_init(void)

I miss an export for this function.

> -core_initcall(gnttab_init);
> +static int __devinit __gnttab_init(void)
> +{
> +	if (!xen_domain())
> +		return -ENODEV;

Shouldn't this read xen_pv_domain?

> +/* NB. [aux-]ide-disks options do not unplug IDE CD-ROM drives. */
> +/* NB. aux-ide-disks is equiv to ide-disks except ignores primary master. */
> +static char *dev_unplug;
> +module_param(dev_unplug, charp, 0644);
> +MODULE_PARM_DESC(dev_unplug, "Emulated devices to unplug: "
> +		 "[all,][ide-disks,][aux-ide-disks,][nics]\n");

What is this parameter about?

> +#define XEN_IOPORT_BASE 0x10

Why are this constants defined in the driver themself? They only make
sense if there are two components making use of them.

> +#define XEN_IOPORT_PLATFLAGS	(XEN_IOPORT_BASE + 0) /* 1 byte access (R/W) */
> +#define XEN_IOPORT_MAGIC	(XEN_IOPORT_BASE + 0) /* 2 byte access (R) */
> +#define XEN_IOPORT_UNPLUG	(XEN_IOPORT_BASE + 0) /* 2 byte access (W) */
> +#define XEN_IOPORT_DRVVER	(XEN_IOPORT_BASE + 0) /* 4 byte access (W) */
> +
> +#define XEN_IOPORT_SYSLOG	(XEN_IOPORT_BASE + 2) /* 1 byte access (W) */
> +#define XEN_IOPORT_PROTOVER	(XEN_IOPORT_BASE + 2) /* 1 byte access (R) */
> +#define XEN_IOPORT_PRODNUM	(XEN_IOPORT_BASE + 2) /* 2 byte access (W) */
> +
> +#define XEN_IOPORT_MAGIC_VAL 0x49d2
> +#define XEN_IOPORT_LINUX_PRODNUM 0xffff /* NB: register a proper one */

What does this "register a proper one" mean?

> +#define XEN_IOPORT_LINUX_DRVVER  ((LINUX_VERSION_CODE << 8) + 0x0)
> +
> +#define UNPLUG_ALL_IDE_DISKS 1
> +#define UNPLUG_ALL_NICS 2
> +#define UNPLUG_AUX_IDE_DISKS 4
> +#define UNPLUG_ALL 7
> +
> +static int check_platform_magic(struct device *dev, long ioaddr, long iolen)
> +{
> +	short magic, unplug = 0;
> +	char protocol, *p, *q, *err;
> +
> +	for (p = dev_unplug; p; p = q) {
> +		q = strchr(dev_unplug, ',');
> +		if (q)
> +			*q++ = '\0';
> +		if (!strcmp(p, "all"))
> +			unplug |= UNPLUG_ALL;
> +		else if (!strcmp(p, "ide-disks"))
> +			unplug |= UNPLUG_ALL_IDE_DISKS;
> +		else if (!strcmp(p, "aux-ide-disks"))
> +			unplug |= UNPLUG_AUX_IDE_DISKS;
> +		else if (!strcmp(p, "nics"))
> +			unplug |= UNPLUG_ALL_NICS;
> +		else
> +			dev_warn(dev, "unrecognised option '%s' "
> +				 "in module parameter 'dev_unplug'\n", p);
> +	}

Usually this is done during the parameter setup.

> +	if (request_mem_region(mmio_addr, mmio_len, DRV_NAME) == NULL) {
> +		printk(KERN_ERR ":MEM I/O resource 0x%lx @ 0x%lx busy\n",
> +		       mmio_addr, mmio_len);
> +		return -EBUSY;

Why is this a sign of busy?

> +	if ((ret = gnttab_init()))
> +		goto out;
> +
> +	if ((ret = xenbus_probe_init()))
> +		goto out;
> +
> + out:
> +	if (ret) {
> +		release_mem_region(mmio_addr, mmio_len);
> +		release_region(ioaddr, iolen);

If xenbus inits, this does not undo the gnttab init?

> +#define XEN_PLATFORM_VENDOR_ID 0x5853
> +#define XEN_PLATFORM_DEVICE_ID 0x0001
> +static struct pci_device_id platform_pci_tbl[] __devinitdata = {
> +	{XEN_PLATFORM_VENDOR_ID, XEN_PLATFORM_DEVICE_ID,
> +	 PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
> +	/* Continue to recognise the old ID for now */
> +	{0xfffd, 0x0101, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},

What is the reasoning for this?

> +static int pci_device_registered;

What is this for?

Bastian
