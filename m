Return-Path: <linux-kernel-owner+w=401wt.eu-S932434AbZJPNlD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932434AbZJPNlD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 09:41:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757583AbZJPNlD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 09:41:03 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:42969 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755724AbZJPNlB (ORCPT
	<rfc822;groupwise-GHaskins@novell.com;0:0>);
	Fri, 16 Oct 2009 09:41:01 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH] vbus: fix kmalloc() from interrupt context to use GFP_ATOMIC
To: linux-kernel@vger.kernel.org
Cc: alacrityvm-devel@lists.sourceforge.net
Date: Fri, 16 Oct 2009 09:40:07 -0400
Message-ID: <20091016133809.13571.6991.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applies to the linux-next branch for AlacrityVM:

git://git.kernel.org/pub/scm/linux/kernel/git/ghaskins/alacrityvm/linux-2.6.git


----------------------------
From: Gregory Haskins <ghaskins@novell.com>
vbus: fix kmalloc() from interrupt context to use GFP_ATOMIC

DEVADD events currently perform a GFP_KERNEL allocation for the device
object in interrupt context.  This is technically illegal, although we
have gotten away with it to date by sheer luck that the allocation
never tried to swap or otherwise sleep.  This problem was highlighted
with the lockdep facility.

Lets fix this properly by making sure that we only allocated the space
for the device object using GFP_KERNEL from process-context.  We achieve
this by generating a temporary GFP_ATOMIC relay for the event and
deferring the actual device allocation/registration to process context.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 drivers/vbus/pci-bridge.c |   54 +++++++++++++++++++++++++++++++--------------
 1 files changed, 37 insertions(+), 17 deletions(-)

diff --git a/drivers/vbus/pci-bridge.c b/drivers/vbus/pci-bridge.c
index fcde495..c1af37c 100644
--- a/drivers/vbus/pci-bridge.c
+++ b/drivers/vbus/pci-bridge.c
@@ -63,7 +63,6 @@ struct vbus_pci_device {
 	u64                      handle;
 	struct list_head         shms;
 	struct vbus_device_proxy vdev;
-	struct work_struct       add;
 	struct work_struct       drop;
 };
 
@@ -442,18 +441,45 @@ struct vbus_device_proxy_ops vbus_pci_device_ops = {
  * -------------------
  */
 
+struct deferred_devadd_event {
+	struct work_struct        work;
+	struct vbus_pci_add_event event;
+};
+
+static void deferred_devdrop(struct work_struct *work);
+
 static void
 deferred_devadd(struct work_struct *work)
 {
+	struct deferred_devadd_event *_event;
 	struct vbus_pci_device *new;
 	int ret;
 
-	new = container_of(work, struct vbus_pci_device, add);
+	_event = container_of(work, struct deferred_devadd_event, work);
+
+	new = kzalloc(sizeof(*new), GFP_KERNEL);
+	if (!new) {
+		printk(KERN_ERR "VBUS_PCI: Out of memory on add_event\n");
+		return;
+	}
+
+	INIT_LIST_HEAD(&new->shms);
+
+	memcpy(new->type, _event->event.type, VBUS_MAX_DEVTYPE_LEN);
+	new->vdev.type        = new->type;
+	new->vdev.id          = _event->event.id;
+	new->vdev.ops         = &vbus_pci_device_ops;
+
+	dev_set_name(&new->vdev.dev, "%lld", _event->event.id);
+
+	INIT_WORK(&new->drop, deferred_devdrop);
 
 	ret = vbus_device_proxy_register(&new->vdev);
 	if (ret < 0)
 		panic("failed to register device %lld(%s): %d\n",
 		      new->vdev.id, new->type, ret);
+
+	kfree(_event);
 }
 
 static void
@@ -468,25 +494,19 @@ deferred_devdrop(struct work_struct *work)
 static void
 event_devadd(struct vbus_pci_add_event *event)
 {
-	struct vbus_pci_device *new = kzalloc(sizeof(*new), GFP_KERNEL);
-	if (!new) {
-		printk(KERN_ERR "VBUS_PCI: Out of memory on add_event\n");
+	struct deferred_devadd_event *_event;
+
+	_event = kzalloc(sizeof(*_event), GFP_ATOMIC);
+	if (!_event) {
+		printk(KERN_ERR \
+		       "VBUS_PCI: Out of ATOMIC memory on add_event\n");
 		return;
 	}
 
-	INIT_LIST_HEAD(&new->shms);
-
-	memcpy(new->type, event->type, VBUS_MAX_DEVTYPE_LEN);
-	new->vdev.type        = new->type;
-	new->vdev.id          = event->id;
-	new->vdev.ops         = &vbus_pci_device_ops;
-
-	dev_set_name(&new->vdev.dev, "%lld", event->id);
-
-	INIT_WORK(&new->add, deferred_devadd);
-	INIT_WORK(&new->drop, deferred_devdrop);
+	INIT_WORK(&_event->work, deferred_devadd);
+	memcpy(&_event->event, event, sizeof(*event));
 
-	schedule_work(&new->add);
+	schedule_work(&_event->work);
 }
 
 static void

