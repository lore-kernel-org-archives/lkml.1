Return-Path: <linux-kernel-owner+w=401wt.eu-S935110AbXGKXeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935110AbXGKXeV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 19:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934934AbXGKXdD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 19:33:03 -0400
Received: from mail.suse.de ([195.135.220.2]:33561 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934908AbXGKXdC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 19:33:02 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 04/61] Driver core: add missing kset uevent
Date: Wed, 11 Jul 2007 16:31:23 -0700
Message-Id: <1184196759393-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <1184196753488-git-send-email-gregkh@suse.de>
References: <20070711233021.GA5253@kroah.com>
 <11841967403365-git-send-email-gregkh@suse.de>
 <11841967493890-git-send-email-gregkh@suse.de>
 <1184196753488-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

We get uevents for a bus/class going away, but not one registering.
Add the missing uevent in kset_register(), which will send an
event for a new bus/class. Suppress all unwanted uevents for bus
subdirectories like /bus/*/devices/, /bus/*/drivers/.

Now we get for module usbcore:
  add      /module/usbcore (module)
  add      /bus/usb (bus)
  add      /class/usb_host (class)
  add      /bus/usb/drivers/hub (drivers)
  add      /bus/usb/drivers/usb (drivers)
  remove   /bus/usb/drivers/usb (drivers)
  remove   /bus/usb/drivers/hub (drivers)
  remove   /class/usb_host (class)
  remove   /bus/usb (bus)
  remove   /module/usbcore (module)

instead of:
  add      /module/usbcore (module)
  add      /bus/usb/drivers/hub (drivers)
  add      /bus/usb/drivers/usb (drivers)
  remove   /bus/usb/drivers/usb (drivers)
  remove   /bus/usb/drivers/hub (drivers)
  remove   /class/usb_host (class)
  remove   /bus/usb/drivers (bus)
  remove   /bus/usb/devices (bus)
  remove   /bus/usb (bus)
  remove   /module/usbcore (module)

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/bus.c |   16 ++++++++++++++--
 lib/kobject.c      |    9 ++++++++-
 2 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index dca7348..7ff5aaf 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -138,12 +138,24 @@ void bus_remove_file(struct bus_type * bus, struct bus_attribute * attr)
 	}
 }
 
-static struct kobj_type ktype_bus = {
+static struct kobj_type bus_ktype = {
 	.sysfs_ops	= &bus_sysfs_ops,
+};
+
+static int bus_uevent_filter(struct kset *kset, struct kobject *kobj)
+{
+	struct kobj_type *ktype = get_ktype(kobj);
+
+	if (ktype == &bus_ktype)
+		return 1;
+	return 0;
+}
 
+static struct kset_uevent_ops bus_uevent_ops = {
+	.filter = bus_uevent_filter,
 };
 
-static decl_subsys(bus, &ktype_bus, NULL);
+static decl_subsys(bus, &bus_ktype, &bus_uevent_ops);
 
 
 #ifdef CONFIG_HOTPLUG
diff --git a/lib/kobject.c b/lib/kobject.c
index ac15206..b4ebd76 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -597,10 +597,17 @@ int kset_add(struct kset * k)
 
 int kset_register(struct kset * k)
 {
+	int err;
+
 	if (!k)
 		return -EINVAL;
+
 	kset_init(k);
-	return kset_add(k);
+	err = kset_add(k);
+	if (err)
+		return err;
+	kobject_uevent(&k->kobj, KOBJ_ADD);
+	return 0;
 }
 
 
-- 
1.5.2.2

