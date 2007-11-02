Return-Path: <linux-kernel-owner+w=401wt.eu-S932109AbXKCAFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109AbXKCAFv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 20:05:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761923AbXKCABP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 20:01:15 -0400
Received: from ns.suse.de ([195.135.220.2]:41138 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756457AbXKCABO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 20:01:14 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 17/54] kset: convert drivers/base/bus.c kset_create_and_register
Date: Fri,  2 Nov 2007 16:58:55 -0700
Message-Id: <1194047972-9850-17-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <20071102235758.GA9803@kroah.com>
References: <20071102235758.GA9803@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dynamically create the kset instead of declaring it statically.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/bus.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 6309560..8b65694 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -13,6 +13,7 @@
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/string.h>
+#include <linux/err.h>
 #include "base.h"
 #include "power/power.h"
 
@@ -166,7 +167,7 @@ static struct kset_uevent_ops bus_uevent_ops = {
 	.filter = bus_uevent_filter,
 };
 
-static decl_subsys(bus, &bus_uevent_ops);
+static struct kset *bus_kset;
 
 
 #ifdef CONFIG_HOTPLUG
@@ -767,7 +768,7 @@ EXPORT_SYMBOL_GPL(device_reprobe);
 #if 0
 struct bus_type * find_bus(char * name)
 {
-	struct kobject * k = kset_find_obj(&bus_subsys.kset, name);
+	struct kobject * k = kset_find_obj(bus_kset, name);
 	return k ? to_bus(k) : NULL;
 }
 #endif  /*  0  */
@@ -851,7 +852,7 @@ int bus_register(struct bus_type * bus)
 	if (retval)
 		goto out;
 
-	bus->subsys.kobj.kset = &bus_subsys;
+	bus->subsys.kobj.kset = bus_kset;
 	bus->subsys.kobj.ktype = &bus_ktype;
 
 	retval = subsystem_register(&bus->subsys);
@@ -935,7 +936,11 @@ EXPORT_SYMBOL_GPL(bus_unregister_notifier);
 
 int __init buses_init(void)
 {
-	return subsystem_register(&bus_subsys);
+	bus_kset = kset_create_and_register("bus", &bus_uevent_ops,
+					    NULL, NULL);
+	if (IS_ERR(bus_kset))
+		return PTR_ERR(bus_kset);
+	return 0;
 }
 
 
-- 
1.5.3.4

