Return-Path: <linux-kernel-owner+w=401wt.eu-S1760864AbXGJGWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760864AbXGJGWh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 02:22:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751769AbXGJGW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 02:22:28 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:52383 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554AbXGJGW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 02:22:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DFIbjMNGhw6c9PYVJEUwrQbqsyJCTPWoVxssOB+TKfFtqoh3+OxhdJBtyAqcTc+cftxDZsXJxPSMEjPUhKH8hAh4bAZc/aFIPgCmtjVwJ9+JV1yUfzG2IBQmIbW1ieh18h5um3nL7BcbvSRnyhpToaD7V4pSGN90Gvr9m7kvxmE=
Message-ID: <86802c440707092322k6906cdefgae821dbf8e21ef60@mail.gmail.com>
Date: Mon, 9 Jul 2007 23:22:26 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: [PATCH 1/4] try parent numa_node at first before using default
Cc: "Christoph Lameter" <clameter@sgi.com>, akpm@linux-foundation.org,
       ak@suse.de, rientjes@google.com,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070710044911.GB10748@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200707031835.l63IZo9K008197@imap1.linux-foundation.org>
	 <200707031731.02456.yinghai.lu@sun.com>
	 <20070710004416.GA6905@kroah.com>
	 <Pine.LNX.4.64.0707091751410.2269@schroedinger.engr.sgi.com>
	 <20070710044911.GB10748@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/9/07, Greg KH <greg@kroah.com> wrote:
> On Mon, Jul 09, 2007 at 05:52:34PM -0700, Christoph Lameter wrote:
> > It means that the node for the device is the same as the parent device.
> > F.e. if the parent device is a bus that is connected to node 4 then all
> > the devices hooked up to the bus are allocated on that node.
>
> Yes, but is someone setting the parent device node information properly?

> And this really needs some more changelog information please.  Why is
> this needed from how things are done today?

please check if you are happy with the changlog

----------------------------------------------------begin---------------------
For pci_device, pcibios_scan_root and pci_scan_root will call pci_device_add.
pci_device_add will call device_initialize and set_dev_node(&dev->dev,
pcibus_to_node(bus)).
other device such as netdev, and usb_device, set_dev_node is never be
used. So that field numa_node always is -1.

So for netdev, it will need to use dev->parent to get pci_device to
use it's numa_node. esp in netdev_alloc_skb()
not sure how other device such as infiniband do that.

Actually before patch
[PATCH 1/2] x86_64: get mp_bus_to_node as early
there is a bug about squence of bus->sysdata and using pcibus_to_node.
the numa_node of pci_dev->dev is never set correctly...always 0.

So some device have to use pcibus_to_node(to_pci_dev(dev)->bus) directly
such as dma_alloc_pages in arch/x86_64/kernel/pci-dma.c.
or hwif_to_node in include/linux/ide.h

with this patch, we could use device->numa_node direclty for all device.
-------------------------------------------------end-----------



YH
