Return-Path: <linux-kernel-owner+w=401wt.eu-S1754273AbYLIQnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273AbYLIQnT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 11:43:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753064AbYLIQnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 11:43:07 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43260 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752703AbYLIQnE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 11:43:04 -0500
Subject: Re: [PATCH] virtio: make PCI devices take a virtio_pci module ref
From: Mark McLoughlin <markmc@redhat.com>
Reply-To: Mark McLoughlin <markmc@redhat.com>
To: Anthony Liguori <aliguori@us.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
       Michael Tokarev <mjt@tls.msk.ru>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
In-Reply-To: <493D334D.6050004@us.ibm.com>
References: <1228394671.3732.77.camel@blaa>
	 <200812051043.51417.rusty@rustcorp.com.au> <1228489626.3858.37.camel@blaa>
	 <200812071852.08962.rusty@rustcorp.com.au> <1228741409.3609.32.camel@blaa>
	 <493D334D.6050004@us.ibm.com>
Content-Type: text/plain
Date: Tue, 09 Dec 2008 16:41:30 +0000
Message-Id: <1228840890.26198.25.camel@blaa>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-12-08 at 08:46 -0600, Anthony Liguori wrote:
> Mark McLoughlin wrote:
> > On Sun, 2008-12-07 at 18:52 +1030, Rusty Russell wrote:
> >   
> >> On Saturday 06 December 2008 01:37:06 Mark McLoughlin wrote:
> >>     
> >>> Another example of a lack of an explicit dependency causing problems is
> >>> Fedora's mkinitrd having this hack:
> >>>
> >>>     if echo $PWD | grep -q /virtio-pci/ ; then
> >>>         findmodule virtio_pci
> >>>     fi
> >>>
> >>> which basically says "if this is a virtio device, don't forget to
> >>> include virtio_pci in the initrd too!". Now, mkinitrd is full of hacks,
> >>> but this is a particularly unusual one.
> >>>       
> >> Um, I don't know what this does, sorry.
> >>
> >> I have no idea how Fedora chooses what to put in an initrd; I can't think
> >> of a sensible way of deciding what goes in and what doesn't other than
> >> lists and heuristics.
> >>     
> >
> > Fedora's mkinitrd creates an initrd suitable to boot the machine you run
> > mkinitrd on, rather than creating an initrd suitable to boot any
> > machine.
> >
> > So, it goes "ah, / is mounted from /dev/vda, we need to include
> > virtio_blk and it's dependencies". It does that in a generic way that
> > works well for most setups:
> >
> >   1) Find the device name (e.g. vda) below /sys/block
> >
> >   2) Follow the 'device' link to e.g. /sys/devices/virtio-pci/virtio1
> >
> >   3) Find the module need for this through either 'modalias' or the 
> >      'driver/module' symlink
> >
> >   4) Use modprobe to list any dependencies of that module
> >
> > Clearly, virtio-pci won't be pulled in by any of this so we've added a
> > hack to say "oh, it's a virtio device, let's include virtio_pci just in
> > case".
> >
> > It's not even the case that mkinitrd needs to know how to include the
> > the module for the bus, because in our case that's virtio.ko ... we've
> > pretty effectively hidden the the bus *implementation* from userspace.
> >
> > I don't think this is worth wasting too much time fixing, that's why I'm
> > thinking we should just make virtio_pci built-in by default with
> > CONFIG_KVM_GUEST. 
> >   
> 
> What if we have multiple virtio transports?

I don't think that's so much an an issue (just build in any transport
supported by KVM), but rather that you might build a non-pv_ops kernel
to run on QEMU which would benefit from using virtio drivers ...

>   Is there a way that we can 
> expose the relationship with virtio-blk and virtio-pci in sysfs?  We 
> have a struct device for the PCI device, it's just a matter of making 
> the link visible.

It feels a bit like busy work to generalise this since only virtio_pci
can be built as a module, but here's a patch.

The mkinitrd hack turns into:

        # Handle finding virtio bus implementations
        if [ -L ./virtio_module ] ; then
            findmodule $(basename $(readlink ./virtio_module))
        else if echo $PWD | grep -q /virtio-pci/ ; then
            findmodule virtio_pci
        fi; fi

Cheers,
Mark.

[PATCH] virtio: add a 'virtio_module' sysfs symlink

Add a way for userspace to determine which virtio bus transport a
given device is associated with.

This will be used by Fedora mkinitrd to generically determine e.g.
that virtio_pci is needed to mount a given root filesystem.

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
---
 drivers/virtio/virtio.c       |   21 ++++++++++++++++++++-
 drivers/virtio/virtio_pci.c   |    1 +
 include/linux/virtio_config.h |    2 ++
 3 files changed, 23 insertions(+), 1 deletions(-)

diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
index 018c070..640ede8 100644
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -189,13 +189,32 @@ int register_virtio_device(struct virtio_device *dev)
 	 * matching driver. */
 	err = device_register(&dev->dev);
 	if (err)
-		add_status(dev, VIRTIO_CONFIG_S_FAILED);
+		goto out;
+
+	/* Create a virtio_module symlink */
+	if (dev->config->owner) {
+		struct module_kobject *mk = &dev->config->owner->mkobj;
+
+		err = sysfs_create_link(&dev->dev.kobj, &mk->kobj,
+					"virtio_module");
+		if (err)
+			goto unreg;
+	}
+
+	return 0;
+
+unreg:
+	device_unregister(&dev->dev);
+out:
+	add_status(dev, VIRTIO_CONFIG_S_FAILED);
 	return err;
 }
 EXPORT_SYMBOL_GPL(register_virtio_device);
 
 void unregister_virtio_device(struct virtio_device *dev)
 {
+	if (dev->config->owner)
+		sysfs_remove_link(&dev->dev.kobj, "virtio_module");
 	device_unregister(&dev->dev);
 }
 EXPORT_SYMBOL_GPL(unregister_virtio_device);
diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
index 939e0b4..59e928d 100644
--- a/drivers/virtio/virtio_pci.c
+++ b/drivers/virtio/virtio_pci.c
@@ -328,6 +328,7 @@ static void vp_del_vq(struct virtqueue *vq)
 }
 
 static struct virtio_config_ops virtio_pci_config_ops = {
+	.owner		= THIS_MODULE,
 	.get		= vp_get,
 	.set		= vp_set,
 	.get_status	= vp_get_status,
diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
index bf8ec28..0a01cda 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -33,6 +33,7 @@
 
 /**
  * virtio_config_ops - operations for configuring a virtio device
+ * @owner: the module implementing these ops, usually THIS_MODULE
  * @get: read the value of a configuration field
  *	vdev: the virtio_device
  *	offset: the offset of the configuration field
@@ -68,6 +69,7 @@
  */
 struct virtio_config_ops
 {
+	struct module *owner;
 	void (*get)(struct virtio_device *vdev, unsigned offset,
 		    void *buf, unsigned len);
 	void (*set)(struct virtio_device *vdev, unsigned offset,
-- 
1.6.0.3

