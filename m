Return-Path: <linux-kernel-owner+w=401wt.eu-S932221AbYAYIYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932221AbYAYIYm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:24:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764119AbYAYIBD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:01:03 -0500
Received: from mx1.suse.de ([195.135.220.2]:59454 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764077AbYAYH7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:59:51 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 138/196] driver core: add way to get to bus kset
Date: Thu, 24 Jan 2008 23:32:47 -0800
Message-Id: <1201246425-5058-59-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows an easier way to get to the kset associated with a struct
bus_type (you have three to choose from...)  This will make it easier to
move these fields to be dynamic in a future patch.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/bus.c                     |    6 ++++++
 drivers/pci/hotplug/pci_hotplug_core.c |    5 ++++-
 include/linux/device.h                 |    2 ++
 3 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 871607b..8335a10 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -935,6 +935,12 @@ int bus_unregister_notifier(struct bus_type *bus, struct notifier_block *nb)
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
 	bus_kset = kset_create_and_add("bus", &bus_uevent_ops, NULL);
diff --git a/drivers/pci/hotplug/pci_hotplug_core.c b/drivers/pci/hotplug/pci_hotplug_core.c
index 0f05e6a..3606d5b 100644
--- a/drivers/pci/hotplug/pci_hotplug_core.c
+++ b/drivers/pci/hotplug/pci_hotplug_core.c
@@ -699,9 +699,12 @@ int __must_check pci_hp_change_slot_info(struct hotplug_slot *slot,
 static int __init pci_hotplug_init (void)
 {
 	int result;
+	struct kset *pci_bus_kset;
+
+	pci_bus_kset = bus_get_kset(&pci_bus_type);
 
 	pci_hotplug_slots_kset = kset_create_and_add("slots", NULL,
-						     &pci_bus_type.subsys.kobj);
+						     &pci_bus_kset->kobj);
 	if (!pci_hotplug_slots_kset) {
 		result = -ENOMEM;
 		err("Register subsys error\n");
diff --git a/include/linux/device.h b/include/linux/device.h
index 313e0b3..3cc13c3 100644
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
1.5.3.8

