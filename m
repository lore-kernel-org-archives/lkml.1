Return-Path: <linux-kernel-owner+w=401wt.eu-S1759962AbZEOQ3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759962AbZEOQ3X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 12:29:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758621AbZEOQ2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 12:28:34 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:35406 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762932AbZEOQ2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 12:28:30 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [KVM PATCH v2 3/4] kvm: add io_bus unregister function
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, avi@redhat.com
Date: Fri, 15 May 2009 12:28:18 -0400
Message-ID: <20090515162818.26209.82481.stgit@dev.haskins.net>
In-Reply-To: <20090515162047.26209.93545.stgit@dev.haskins.net>
References: <20090515162047.26209.93545.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We want to support the notion of dynamic MMIO/PIO registrations and
therefore will need to support both register as well as unregister.

However, the current io_bus code is structured as a linear array and
is not conducive to unregistering, so refactor to allow "holes" in the
array.  We then enhance the API with an unregister function.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 include/linux/kvm_host.h |    4 +++-
 virt/kvm/kvm_main.c      |   48 ++++++++++++++++++++++++++++++++++++++--------
 2 files changed, 43 insertions(+), 9 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 94c1a11..214089f 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -52,7 +52,7 @@ extern struct kmem_cache *kvm_vcpu_cache;
  * in one place.
  */
 struct kvm_io_bus {
-	int                   dev_count;
+	spinlock_t lock;
 #define NR_IOBUS_DEVS 6
 	struct kvm_io_device *devs[NR_IOBUS_DEVS];
 };
@@ -63,6 +63,8 @@ struct kvm_io_device *kvm_io_bus_find_dev(struct kvm_io_bus *bus,
 					  gpa_t addr, int len, int is_write);
 int kvm_io_bus_register_dev(struct kvm_io_bus *bus,
 			    struct kvm_io_device *dev);
+int kvm_io_bus_unregister_dev(struct kvm_io_bus *bus,
+			    struct kvm_io_device *dev);
 
 struct kvm_vcpu {
 	struct kvm *kvm;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 60ba0cf..5f5e443 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2433,16 +2433,18 @@ static struct notifier_block kvm_reboot_notifier = {
 void kvm_io_bus_init(struct kvm_io_bus *bus)
 {
 	memset(bus, 0, sizeof(*bus));
+	spin_lock_init(&bus->lock);
 }
 
 void kvm_io_bus_destroy(struct kvm_io_bus *bus)
 {
 	int i;
 
-	for (i = 0; i < bus->dev_count; i++) {
+	for (i = 0; i < NR_IOBUS_DEVS; i++) {
 		struct kvm_io_device *pos = bus->devs[i];
 
-		kvm_iodevice_destructor(pos);
+		if (pos)
+			kvm_iodevice_destructor(pos);
 	}
 }
 
@@ -2451,10 +2453,10 @@ struct kvm_io_device *kvm_io_bus_find_dev(struct kvm_io_bus *bus,
 {
 	int i;
 
-	for (i = 0; i < bus->dev_count; i++) {
+	for (i = 0; i < NR_IOBUS_DEVS; i++) {
 		struct kvm_io_device *pos = bus->devs[i];
 
-		if (pos->in_range(pos, addr, len, is_write))
+		if (pos && pos->in_range(pos, addr, len, is_write))
 			return pos;
 	}
 
@@ -2463,12 +2465,42 @@ struct kvm_io_device *kvm_io_bus_find_dev(struct kvm_io_bus *bus,
 
 int kvm_io_bus_register_dev(struct kvm_io_bus *bus, struct kvm_io_device *dev)
 {
-	if (bus->dev_count > (NR_IOBUS_DEVS-1))
-		return -ENOSPC;
+	int i;
 
-	bus->devs[bus->dev_count++] = dev;
+	spin_lock(&bus->lock);
 
-	return 0;
+	for (i = 0; i < NR_IOBUS_DEVS; i++) {
+		if (bus->devs[i])
+			continue;
+
+		bus->devs[i] = dev;
+		spin_unlock(&bus->lock);
+		return 0;
+	}
+
+	spin_unlock(&bus->lock);
+
+	return -ENOSPC;
+}
+
+int kvm_io_bus_unregister_dev(struct kvm_io_bus *bus, struct kvm_io_device *dev)
+{
+	int i;
+
+	spin_lock(&bus->lock);
+
+	for (i = 0; i < NR_IOBUS_DEVS; i++) {
+
+		if (bus->devs[i] == dev) {
+			bus->devs[i] = NULL;
+			spin_unlock(&bus->lock);
+			return 0;
+		}
+	}
+
+	spin_unlock(&bus->lock);
+
+	return -ENOENT;
 }
 
 static struct notifier_block kvm_cpu_notifier = {

