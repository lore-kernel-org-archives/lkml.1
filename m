Return-Path: <linux-kernel-owner+w=401wt.eu-S965583AbXDCMRs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965583AbXDCMRs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 08:17:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753459AbXDCMRs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 08:17:48 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:57218 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206AbXDCMRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 08:17:47 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: Re: A set of "standard" virtual devices?
Date: Tue, 3 Apr 2007 14:15:37 +0200
User-Agent: KMail/1.9.6
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Andi Kleen <ak@suse.de>, Jeff Garzik <jeff@garzik.org>,
       virtualization@lists.linux-foundation.org,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mathiasen@gmail.com
References: <4611652F.700@zytor.com> <200704031141.50045.arnd@arndb.de> <20070403124108.06108665@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070403124108.06108665@gondolin.boeblingen.de.ibm.com>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704031415.38381.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19WgG3kkrP8HMKIwvYWpWNh7+dWiv7sXdhTFHq
 t7fr92fVB4qe592GPxg1D2wjIjv9rjUKmX70si6+AyoZJuBW9e
 RWcBB8QDxUH1EnNc3i7Dg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 April 2007, Cornelia Huck wrote:
> > 
> > I think that's true outside of s390, but a standardized virtual device
> > interface should be able to work there as well. Interestingly, the
> > s390 channel I/O also uses two 16 bit numbers to identify a device
> > (type and model), just like PCI or USB, so in that light, we might
> > be able to use the same number space for something entirely different
> > depending on the virtual bus.
> 
> Even if we used those ids for cu_type and dev_type, it would still be
> ugly IMO. It would be much cleaner to just define a very simple, easy
> to implement virtual bus without dragging implementation details for
> other types of devices around.

Right, but an interesting point is the question what to do when running
another operating system as a guest under Linux, e.g. with kvm.

Ideally, you'd want to use the same interface to announce the presence
of the device, which can be done far more easily with PCI than using
a new bus type that you'd need to implement for every OS, instead of
just implementing the virtual PCI driver.

Using a 16 bit number to identify a specific interface sounds like
a good idea to me, if only for the reason that it is a widely used
approach. The alternative would be to use an ascii string, like we
have for open-firmware devices on powerpc or sparc.

I think in either way, we need to abstract the driver for the virtual
device from the underlying bus infrastructure, which is hypervisor
and/or platform dependent. The abstraction could work roughly like this:


==========
virt_dev.h
==========
struct virt_driver { /* platform independent */
	struct device_driver drv;
	struct pci_device_id *ids; /* not necessarily PCI */
};
struct virt_bus {
	/* platform dependent */
	long (*transfer)(struct virt_dev *dev, void *buffer,
		unsigned long size, int type);
};
struct virt_dev {
	struct device dev;
	struct virt_driver *driver;
	struct virt_bus *bus;
	struct pci_device_id id;
	int irq;
};
==============
virt_example.c
==============
static ssize_t virt_pipe_read(struct file *filp, char __user *buffer,
                         size_t len, loff_t *off)
{
	struct virt_dev *dev = filp->private_data;
	ssize_t ret = dev->bus->transfer(dev, buffer, len, READ);
	*off += ret;
	return ret;
}
static struct file_operations virt_pipe_fops = {
	.open = nonseekable_open,
	.read = virt_pipe_read,
};
static int virt_pipe_probe(struct device *dev)
{
	struct virt_dev *vdev = to_virt_dev(dev);
	struct miscdev *mdev = kmalloc(sizeof(*dev), GFP_KERNEL);
	mdev->name = "virt_pipe";
	mdev->fops = &virt_pipe_fops;
	mdev->parent = dev;
	return register_miscdev(mdev);
}
static struct pci_device_id virt_pipe_id = {
	.vendor = PCI_VENDOR_LINUX, .device = 0x3456,
};
MODULE_DEVICE_TABLE(pci, virt_pipe_id);
static struct virt_driver virt_pipe_driver = {
	.drv = {
		.name = "virt_pipe",
		.probe = virt_pipe_probe,
	},
	.ids = &virt_pipe_id,
}
static int virt_pipe_init(void)
{
	return virt_driver_register(&virt_pipe_driver);
}
module_init(virt_pipe_init);
==============
virt_devtree.c
==============
static long virt_devtree_transfer(struct virt_dev *dev, void *buffer,
		unsigned long size, int type)
{
	long reg;
	switch type {
	case READ:
		ret = hcall(HV_READ, dev->dev.platform_data, buffer, size);
		break;
	case WRITE:
		ret = hcall(HV_WRITE, dev->dev.platform_data, buffer, size);
		break;
	default:
		BUG();
	}
	return ret;
}
static struct virt_bus virt_devtree_bus = {
	.transfer = virt_devtree_transfer,
};
static int virt_devtree_probe(struct of_device *ofdev,
				struct of_device_id *match)
{
	struct virt_dev *vdev = kzalloc(sizeof(*vdev);
	vdev->bus = &virt_devtree_bus;
	vdev->dev.parent = &ofdev->dev;
	vdev.id.vendor = PCI_VENDOR_LINUX;
	vdev.id.device = *of_get_property(ofdev, "virt_dev_id"),
	vdev.irq = of_irq_parse_and_map(ofdev, 0);
	return device_register(&vdev->dev);
}
struct of_device_id virt_devtree_ids = {
	.compatible = "virt-dev",
};
static struct of_platform_driver virt_devtree_driver = {
	.probe = virt_devtree_probe,
	.match_table = &virt_devtree_ids,
};
==============
virt_pci.c
==============
static long virt_pci_transfer(struct virt_dev *dev, void *buffer,
		unsigned long size, int type)
{
	struct virt_pci_regs __iomem *regs = dev->dev.platform_data;
	switch type {
	case READ:
		mmio_insb(regs->read_port, buffer, size);
		break;
	case WRITE:
		mmio_outsb(regs->write_port, buffer, size);
		break;
	default:
		BUG();
	}
	return size;
}
static struct virt_bus virt_pci_bus = {
	.transfer = virt_pci_transfer,
};
static int virt_pci_probe(struct pci_dev *pdev,
				struct pci_device_id *match)
{
	struct virt_dev *vdev = kzalloc(sizeof(*vdev);
	vdev->bus = &virt_pci_bus;
	vdev->dev.parent = &pdev->dev;
	vdev.id = *match;
	vdev.irq = pdev->irq;
	return device_register(&vdev->dev);
}
struct pci_device_id virt_pci_ids = {
	.compatible = "virt-dev",
};
static struct of_platform_driver virt_pci_driver = {
	.probe = virt_pci_probe,
	.match_table = &virt_pci_ids,
};

	Arnd <><
