Return-Path: <linux-kernel-owner+w=401wt.eu-S1756547AbZCFQKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547AbZCFQKi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 11:10:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754404AbZCFQK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 11:10:26 -0500
Received: from rv-out-0506.google.com ([209.85.198.232]:12534 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754889AbZCFQKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 11:10:24 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [RFC] drivers/base: Add bus_register_notifier_alldev() variant
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Greg Kroah-Hartman <gregkh@suse.de>
Date: Fri, 06 Mar 2009 09:10:19 -0700
Message-ID: <20090306160818.404.92700.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>

bus_register_notifier_alldev() is a variation on bus_register_notifier()
which also triggers the notifier callback for devices already on the bus
and already bound to drivers.

This function is useful for the case where a driver needs to get a
reference to a struct device other than the one it is bound to and
it is not known if the device will be bound before or after this
function is called.  For example, an Ethernet device connected to
a PHY that is probed separately.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
CC: linux-kernel@vger.kernel.org
CC: linuxppc-dev@ozlabs.org
CC: Greg Kroah-Hartman <gregkh@suse.de>
---

I'm using this as part of some changes to phylib to make it easier for
Ethernet drivers to find their PHY device.  Before I'm completely committed
to this approach I'd like some feedback on this change to drivers core.

Thanks,
g.


 drivers/base/bus.c     |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/device.h |    2 ++
 2 files changed, 49 insertions(+), 0 deletions(-)


diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 83f32b8..6edde85 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -962,6 +962,53 @@ int bus_register_notifier(struct bus_type *bus, struct notifier_block *nb)
 }
 EXPORT_SYMBOL_GPL(bus_register_notifier);
 
+/**
+ * bus_register_notifier_alldev_helper - internal support function
+ * Used by bus_register_notifier_alldev() to create ADD and BOUND events
+ * for devices.
+ */
+static int bus_register_notifier_alldev_helper(struct device *dev, void *data)
+{
+	struct notifier_block *nb = data;
+	nb->notifier_call(nb, BUS_NOTIFY_ADD_DEVICE, dev);
+	if (dev->driver)
+		nb->notifier_call(nb, BUS_NOTIFY_BOUND_DRIVER, dev);
+	return 0;
+}
+
+/**
+ * bus_register_notifier_alldev - Register for bus events; include existing devs
+ * @bus: pointer to bus_type
+ * @nb: pointer to notifier block to register with the bus
+ *
+ * Similar to bus_register_notifier() except it also generates events for
+ * devices already on the bus when the notifier is registered.  When this
+ * function is called the notifier is called once for each device with
+ * the BUS_NOTIFY_ADD_DEVICE event, and once for each device registered to
+ * a driver * with the BUS_NOTIFY_BOUND_DRIVER event.
+ *
+ * There is a small chance that the notifier could be called more than once
+ * for a device.  This would happen if a new device was registered on the bus
+ * or bound to a driver between the call to bus_register_notifier() and the
+ * call to bus_for_each_dev().  The only way I can see to protect against
+ * this would be to take the klist_devices spinlock while calling the
+ * notifier; but that would be a Very Bad Thing (tm).  Caller needs to be
+ * aware that a notifier called before this function returns might get
+ * called a second time on the same device.
+ */
+int bus_register_notifier_alldev(struct bus_type *b, struct notifier_block *nb)
+{
+	int ret;
+
+	ret = bus_register_notifier(b, nb);
+	if (ret == 0) {
+		bus_for_each_dev(b, NULL, nb,
+				 bus_register_notifier_alldev_helper);
+	}
+	return ret;
+}
+EXPORT_SYMBOL_GPL(bus_register_notifier_alldev);
+
 int bus_unregister_notifier(struct bus_type *bus, struct notifier_block *nb)
 {
 	return blocking_notifier_chain_unregister(&bus->p->bus_notifier, nb);
diff --git a/include/linux/device.h b/include/linux/device.h
index 45e5b19..05c7d5b 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -103,6 +103,8 @@ struct notifier_block;
 
 extern int bus_register_notifier(struct bus_type *bus,
 				 struct notifier_block *nb);
+extern int bus_register_notifier_alldev(struct bus_type *b,
+					struct notifier_block *nb);
 extern int bus_unregister_notifier(struct bus_type *bus,
 				   struct notifier_block *nb);
 

