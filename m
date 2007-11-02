Return-Path: <linux-kernel-owner+w=401wt.eu-S1763354AbXKCAKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763354AbXKCAKj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 20:10:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761991AbXKCACK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 20:02:10 -0400
Received: from mx1.suse.de ([195.135.220.2]:41173 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761596AbXKCACJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 20:02:09 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 31/54] driver core: add way to get to bus kset
Date: Fri,  2 Nov 2007 16:59:09 -0700
Message-Id: <1194047972-9850-31-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <20071102235758.GA9803@kroah.com>
References: <20071102235758.GA9803@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This allows an easier way to get to the kset associated with a struct
bus_type (you have three to choose from...)  This will make it easier to
move these fields to be dynamic in a future patch.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/bus.c                     |    6 ++++++
 drivers/pci/hotplug/pci_hotplug_core.c |    2 +-
 include/linux/device.h                 |    2 ++
 3 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 5ddc2e8..3cd991f 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -936,6 +936,12 @@ int bus_unregister_notifier(struct bus_type *bus, struct notifier_block *nb)
 }
 EXPORT_SYMBOL_GPL(bus_unregister_notifier);
 
+struct kset *bus_get_kset(struct bus_type *bus)
+{
+	return &bus->subsys;
+}
+EXPORT_SYMBOL_GPL(bus_get_kset);
+
 int __init buses_init(void)
 {
 	bus_kset = kset_create_and_register("bus", &bus_uevent_ops,
diff --git a/drivers/pci/hotplug/pci_hotplug_core.c b/drivers/pci/hotplug/pci_hotplug_core.c
index 6130397..cf69024 100644
--- a/drivers/pci/hotplug/pci_hotplug_core.c
+++ b/drivers/pci/hotplug/pci_hotplug_core.c
@@ -701,7 +701,7 @@ static int __init pci_hotplug_init (void)
 	int result;
 
 	pci_hotplug_slots_kset = kset_create_and_register("slots", NULL, NULL,
-							  &pci_bus_type.subsys);
+						bus_get_kset(&pci_bus_type));
 	if (IS_ERR(pci_hotplug_slots_kset)) {
 		result = PTR_ERR(pci_hotplug_slots_kset);
 		err("Register subsys with error %d\n", result);
diff --git a/include/linux/device.h b/include/linux/device.h
index a8ffb3a..86eff9d 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -117,6 +117,8 @@ extern int bus_unregister_notifier(struct bus_type *bus,
 #define BUS_NOTIFY_UNBIND_DRIVER	0x00000004 /* driver about to be
 						      unbound */
 
+extern struct kset *bus_get_kset(struct bus_type *bus);
+
 struct device_driver {
 	const char		* name;
 	struct bus_type		* bus;
-- 
1.5.3.4

