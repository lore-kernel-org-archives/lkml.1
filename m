Return-Path: <linux-kernel-owner+w=401wt.eu-S1756192AbYLEScL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192AbYLEScL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 13:32:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753520AbYLESb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 13:31:56 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59283 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752054AbYLESbz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 13:31:55 -0500
Subject: Re: [PATCH] virtio: make PCI devices take a virtio_pci module ref
From: Mark McLoughlin <markmc@redhat.com>
Reply-To: Mark McLoughlin <markmc@redhat.com>
To: Greg KH <gregkh@suse.de>
Cc: Jiri Slaby <jirislaby@gmail.com>, Michael Tokarev <mjt@tls.msk.ru>,
       Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
       Anthony Liguori <aliguori@us.ibm.com>
In-Reply-To: <20081205152644.GA27847@suse.de>
References: <1228394671.3732.77.camel@blaa> <49385DB7.4060306@gmail.com>
	 <4938EE0B.8020501@msgid.tls.msk.ru> <493929D2.4070900@gmail.com>
	 <1228488921.3858.25.camel@blaa> <493947EB.3050404@gmail.com>
	 <20081205152644.GA27847@suse.de>
Content-Type: text/plain
Date: Fri, 05 Dec 2008 18:30:17 +0000
Message-Id: <1228501817.3858.48.camel@blaa>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-12-05 at 07:26 -0800, Greg KH wrote:
> On Fri, Dec 05, 2008 at 04:25:31PM +0100, Jiri Slaby wrote:
> > Mark McLoughlin wrote:
> > >> Fix the virtio bus instead.
> > > 
> > > Yeah, the patch I posted wasn't meant as a fix for this traceback.
> > 
> > So what's the module_get patch needed for?
> > 
> > > Here's one that does fix it.
> > ...
> > > From: Mark McLoughlin <markmc@redhat.com>
> > > Subject: [PATCH] virtio: add device release() function
> > > 
> > > Add a release() function for virtio_pci devices so as to avoid:
> > > 
> > >   Device 'virtio0' does not have a release() function, it is broken and must be fixed
> 
> Just providing an empty release function to the kernel is the complete
> wrong thing.  Do you not think the kernel is actually trying to tell you
> something here?  If it could test for an empty release function it would
> complain about that as well, providing one is no "fix" at all.
> 
> You need to free your memory in the release function that is owned by
> the device/structure.  Please read the file, Documentation/kobject.txt
> for details as to what you need to do.

Okay, consider me "mocked mercilessly by the kobject maintainer" :-)

Does this version look a bit more reasonable?

(The virtio_pci_root is statically allocated so I don't see how
release() could be non-empty in this case, but let's debate whether we
want to keep this dummy device at all)

Cheers,
Mark.

From: Mark McLoughlin <markmc@redhat.com>
Subject: [PATCH] virtio: add PCI device release() function

Add a release() function for virtio_pci devices so as to avoid:

  Device 'virtio0' does not have a release() function, it is broken and must be fixed

Move the code to free the resources associated with the device
from virtio_pci_remove() into this new function. virtio_pci_remove()
now merely unregisters the device which should cause the final
ref to be dropped and virtio_pci_release_dev() to be called.

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
Reported-by: Michael Tokarev <mjt@tls.msk.ru>
Cc: Anthony Liguori <aliguori@us.ibm.com>
---
 drivers/virtio/virtio_pci.c |   21 +++++++++++++++------
 1 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
index c7dc37c..10d1547 100644
--- a/drivers/virtio/virtio_pci.c
+++ b/drivers/virtio/virtio_pci.c
@@ -305,6 +305,20 @@ static struct virtio_config_ops virtio_pci_config_ops = {
 	.finalize_features = vp_finalize_features,
 };
 
+static void virtio_pci_release_dev(struct device *_d)
+{
+	struct virtio_device *dev = container_of(_d, struct virtio_device, dev);
+	struct virtio_pci_device *vp_dev = to_vp_device(dev);
+	struct pci_dev *pci_dev = vp_dev->pci_dev;
+
+	free_irq(pci_dev->irq, vp_dev);
+	pci_set_drvdata(pci_dev, NULL);
+	pci_iounmap(pci_dev, vp_dev->ioaddr);
+	pci_release_regions(pci_dev);
+	pci_disable_device(pci_dev);
+	kfree(vp_dev);
+}
+
 /* the PCI probing function */
 static int __devinit virtio_pci_probe(struct pci_dev *pci_dev,
 				      const struct pci_device_id *id)
@@ -328,6 +342,7 @@ static int __devinit virtio_pci_probe(struct pci_dev *pci_dev,
 		return -ENOMEM;
 
 	vp_dev->vdev.dev.parent = &virtio_pci_root;
+	vp_dev->vdev.dev.release = virtio_pci_release_dev;
 	vp_dev->vdev.config = &virtio_pci_config_ops;
 	vp_dev->pci_dev = pci_dev;
 	INIT_LIST_HEAD(&vp_dev->virtqueues);
@@ -387,12 +402,6 @@ static void __devexit virtio_pci_remove(struct pci_dev *pci_dev)
 	struct virtio_pci_device *vp_dev = pci_get_drvdata(pci_dev);
 
 	unregister_virtio_device(&vp_dev->vdev);
-	free_irq(pci_dev->irq, vp_dev);
-	pci_set_drvdata(pci_dev, NULL);
-	pci_iounmap(pci_dev, vp_dev->ioaddr);
-	pci_release_regions(pci_dev);
-	pci_disable_device(pci_dev);
-	kfree(vp_dev);
 }
 
 #ifdef CONFIG_PM
-- 
1.6.0.3

