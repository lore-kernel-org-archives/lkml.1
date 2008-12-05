Return-Path: <linux-kernel-owner+w=401wt.eu-S1755504AbYLEO5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504AbYLEO5T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 09:57:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752523AbYLEO5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 09:57:05 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53698 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751919AbYLEO5D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 09:57:03 -0500
Subject: Re: [PATCH] virtio: make PCI devices take a virtio_pci module ref
From: Mark McLoughlin <markmc@redhat.com>
Reply-To: Mark McLoughlin <markmc@redhat.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Michael Tokarev <mjt@tls.msk.ru>, Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
       Anthony Liguori <aliguori@us.ibm.com>
In-Reply-To: <493929D2.4070900@gmail.com>
References: <1228394671.3732.77.camel@blaa> <49385DB7.4060306@gmail.com>
	 <4938EE0B.8020501@msgid.tls.msk.ru>  <493929D2.4070900@gmail.com>
Content-Type: text/plain
Date: Fri, 05 Dec 2008 14:55:21 +0000
Message-Id: <1228488921.3858.25.camel@blaa>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-12-05 at 14:17 +0100, Jiri Slaby wrote:
> Michael Tokarev napsal(a):
> > Jiri Slaby wrote:
> >> On 12/04/2008 01:44 PM, Mark McLoughlin wrote:
> >>> Nothing takes a ref on virtio_pci, so even if you have
> >>> devices in use, rmmod will attempt to unload the module.
> >> It unbinds the device properly as any other driver. So what's the problem here?
> > 
> > Here's what we get when rmmod'ing (a zero-refcounted but
> > in use) virtio_pci (I did it by a chance, cut-n-pasted
> > the wrong line):
> > 
> > WARNING: at drivers/base/core.c:122 device_release+0x5f/0x70()
> > Device 'virtio1' does not have a release() function, it is broken and must be fixed.
> > Modules linked in: ext3 jbd mbcache acpiphp dock pci_hotplug virtio_net virtio_blk virtio_pci(-) virtio_ring virtio
> > 
> > Pid: 361, comm: rmmod Tainted: G S        2.6.27-i686smp #2.6.27.7
> >  [<c012b81f>] warn_slowpath+0x6f/0xa0
> >  [<c0110030>] prepare_set+0x30/0x80
> >  [<c012067e>] __wake_up+0x3e/0x60
> >  [<c01d1d25>] release_sysfs_dirent+0x45/0xb0
> >  ...
> 
> So why don't you fix the root cause and add such a crap into the probe
> function (not even counting probe can fail later)?
> 
> Fix the virtio bus instead.

Yeah, the patch I posted wasn't meant as a fix for this traceback.
Here's one that does fix it.

Cheers,
Mark.

From: Mark McLoughlin <markmc@redhat.com>
Subject: [PATCH] virtio: add device release() function

Add a release() function for virtio_pci devices so as to avoid:

  Device 'virtio0' does not have a release() function, it is broken and must be fixed

The struct device is embedded in the struct virtio_pci_device which
is freed by virtio_pci_remove(), so virtio_pci_release_dev() need
not actually do anything.

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
---
 drivers/virtio/virtio_pci.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
index c7dc37c..7d4899c 100644
--- a/drivers/virtio/virtio_pci.c
+++ b/drivers/virtio/virtio_pci.c
@@ -70,12 +70,17 @@ static struct pci_device_id virtio_pci_id_table[] = {
 
 MODULE_DEVICE_TABLE(pci, virtio_pci_id_table);
 
+static void virtio_pci_release_dev(struct device *dev)
+{
+}
+
 /* A PCI device has it's own struct device and so does a virtio device so
  * we create a place for the virtio devices to show up in sysfs.  I think it
  * would make more sense for virtio to not insist on having it's own device. */
 static struct device virtio_pci_root = {
 	.parent		= NULL,
 	.bus_id		= "virtio-pci",
+	.release	= virtio_pci_release_dev,
 };
 
 /* Convert a generic virtio device to our structure */
@@ -328,6 +333,7 @@ static int __devinit virtio_pci_probe(struct pci_dev *pci_dev,
 		return -ENOMEM;
 
 	vp_dev->vdev.dev.parent = &virtio_pci_root;
+	vp_dev->vdev.dev.release = virtio_pci_release_dev;
 	vp_dev->vdev.config = &virtio_pci_config_ops;
 	vp_dev->pci_dev = pci_dev;
 	INIT_LIST_HEAD(&vp_dev->virtqueues);
-- 
1.6.0.3

