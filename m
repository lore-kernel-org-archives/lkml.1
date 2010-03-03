Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854Ab0CCPs0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 10:48:26 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:13647 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653Ab0CCPsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 10:48:21 -0500
X-IronPort-AV: E=Sophos;i="4.49,574,1262563200"; 
   d="scan'208";a="9764365"
Date: Wed, 3 Mar 2010 15:52:07 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Bastian Blank <waldi@debian.org>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 4 of 4] Linux pvops: xen pci platform device
 driver
In-Reply-To: <20100303121726.GA26656@wavehammer.waldi.eu.org>
Message-ID: <alpine.DEB.2.00.1003031520320.4648@kaball-desktop>
References: <alpine.DEB.2.00.1003021748250.22259@kaball-desktop> <20100303121726.GA26656@wavehammer.waldi.eu.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Mar 2010, Bastian Blank wrote:
> 
> Why is version 1 grant table the default on HVM?
> 

Because version 2 is known not to work on HVM, fixing this is on my TODO
list.


> > +/* NB. [aux-]ide-disks options do not unplug IDE CD-ROM drives. */
> > +/* NB. aux-ide-disks is equiv to ide-disks except ignores primary master. */
> > +static char *dev_unplug;
> > +module_param(dev_unplug, charp, 0644);
> > +MODULE_PARM_DESC(dev_unplug, "Emulated devices to unplug: "
> > +		 "[all,][ide-disks,][aux-ide-disks,][nics]\n");
> 
> What is this parameter about?

During the initialization of the xen pci device driver, we write to a
magic ioport that causes qemu to unplug some emulated devices, disc and
network in particular.
This parameter is meant to present the user a choice about what emulated
devices to unplug.


> > +#define XEN_IOPORT_BASE 0x10
> 
> Why are this constants defined in the driver themself? They only make
> sense if there are two components making use of them.

Yep, the other one is qemu.


> > +	if (request_mem_region(mmio_addr, mmio_len, DRV_NAME) == NULL) {
> > +		printk(KERN_ERR ":MEM I/O resource 0x%lx @ 0x%lx busy\n",
> > +		       mmio_addr, mmio_len);
> > +		return -EBUSY;
> 
> Why is this a sign of busy?

I think we were just trying to follow the behaviour of the other drivers
of real pci devices.
I am not sure how this condition could happen on Xen.


> > +	if ((ret = gnttab_init()))
> > +		goto out;
> > +
> > +	if ((ret = xenbus_probe_init()))
> > +		goto out;
> > +
> > + out:
> > +	if (ret) {
> > +		release_mem_region(mmio_addr, mmio_len);
> > +		release_region(ioaddr, iolen);
> 
> If xenbus inits, this does not undo the gnttab init?
> 

Do you mean "if xenbus DOESN'T init, this does not undo the gnttab
init?"
Strictly speaking the grant table can work without xenbus even if no Xen
pv driver is able to use it without xenstore support at the moment.


All the other comments indicate issues that need to be solved,
I'll address them in the next version of the series.
Most issues derive from the the fact that I did a straight port of the
platform-pci driver we have in xen-unstable/unmodified_drivers.

Thank you very much for the detailed review.

Cheers,

Stefano
