Return-Path: <linux-kernel-owner+w=401wt.eu-S966177AbXDCNhQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966177AbXDCNhQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 09:37:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966176AbXDCNhQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 09:37:16 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:13090 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965846AbXDCNhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 09:37:13 -0400
Date: Tue, 3 Apr 2007 15:39:21 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Andi Kleen <ak@suse.de>, Jeff Garzik <jeff@garzik.org>,
       virtualization@lists.linux-foundation.org,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mathiasen@gmail.com
Subject: Re: A set of "standard" virtual devices?
Message-ID: <20070403153921.491b1e9f@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <200704031415.38381.arnd@arndb.de>
References: <4611652F.700@zytor.com>
	<200704031141.50045.arnd@arndb.de>
	<20070403124108.06108665@gondolin.boeblingen.de.ibm.com>
	<200704031415.38381.arnd@arndb.de>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.8.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Apr 2007 14:15:37 +0200,
Arnd Bergmann <arnd@arndb.de> wrote:

> Right, but an interesting point is the question what to do when running
> another operating system as a guest under Linux, e.g. with kvm.
> 
> Ideally, you'd want to use the same interface to announce the presence
> of the device, which can be done far more easily with PCI than using
> a new bus type that you'd need to implement for every OS, instead of
> just implementing the virtual PCI driver.

That's OK for a virtualized architecture where the base architecture
already supports PCI. But a traditional s390 OS would be as unhappy
with a PCI device as with a device of a completely new type :)

There are several options for virtualized devices (and I don't know why
they shouldn't coexist):

1. Emulate a well-known device (like a e1000 network card on PCI or a
model 3390 dasd on CCW). Existing operating systems can just use them,
but it's a lot of work in the hypervisor.

2. Create a virtual PCI device (or a virtual CCW device) with a new id.
Operating systems would need to write a new device driver, but they can
use a familiar infrastructure. That seems to be what most people are
talking about here.

3. Create a new bus which uses a new access method. This new method can
be made very simple, but requires support from the guest operating
system. That's what I was talking about :)

[Note: I'm not actually advocating an emulated ccw driver. There be
dragons.]

> Using a 16 bit number to identify a specific interface sounds like
> a good idea to me, if only for the reason that it is a widely used
> approach. The alternative would be to use an ascii string, like we
> have for open-firmware devices on powerpc or sparc.

OK, we could use common identifiers (and reserve it) for case 2 across
several busses. Like

#define PCI_VIRT_ID GENERIC_VIRT_ID
#define CCW_VIRT_DEVTYPE GENERIC_VIRT_ID

> I think in either way, we need to abstract the driver for the virtual
> device from the underlying bus infrastructure, which is hypervisor
> and/or platform dependent.

Yes, that sounds sane for case 3. We should just standardize the
interface.

> The abstraction could work roughly like this:
> 
> 
> ==========
> virt_dev.h
> ==========
> struct virt_driver { /* platform independent */
> 	struct device_driver drv;
> 	struct pci_device_id *ids; /* not necessarily PCI */
> };
> struct virt_bus {
> 	/* platform dependent */
> 	long (*transfer)(struct virt_dev *dev, void *buffer,
> 		unsigned long size, int type);
> };

Should this embed a struct bus_type? Or reference a generic_virt_bus?

> struct virt_dev {
> 	struct device dev;
> 	struct virt_driver *driver;
> 	struct virt_bus *bus;
> 	struct pci_device_id id;
> 	int irq;
> };

And that's where I have problems :) The notion of "irq" is far too
platform specific. I can bend my mind round using PCI-like ids for
non-PCI virtualized devices, but an integer is far too small and to
specific for a way to access the device.
