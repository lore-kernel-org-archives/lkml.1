Return-Path: <linux-kernel-owner+w=401wt.eu-S1761629AbYAYHfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761629AbYAYHfg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:35:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756847AbYAYHR4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:17:56 -0500
Received: from mx2.suse.de ([195.135.220.15]:47651 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759351AbYAYHRz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:17:55 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 060/196] kset: convert drivers/base/bus.c to use kset_create
Date: Thu, 24 Jan 2008 23:09:58 -0800
Message-Id: <1201245134-4876-60-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dynamically create the kset instead of declaring it statically.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/bus.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 6309560..e3b1010 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -166,7 +166,7 @@ static struct kset_uevent_ops bus_uevent_ops = {
 	.filter = bus_uevent_filter,
 };
 
-static decl_subsys(bus, &bus_uevent_ops);
+static struct kset *bus_kset;
 
 
 #ifdef CONFIG_HOTPLUG
@@ -767,7 +767,7 @@ EXPORT_SYMBOL_GPL(device_reprobe);
 #if 0
 struct bus_type * find_bus(char * name)
 {
-	struct kobject * k = kset_find_obj(&bus_subsys.kset, name);
+	struct kobject * k = kset_find_obj(bus_kset, name);
 	return k ? to_bus(k) : NULL;
 }
 #endif  /*  0  */
@@ -851,7 +851,7 @@ int bus_register(struct bus_type * bus)
 	if (retval)
 		goto out;
 
-	bus->subsys.kobj.kset = &bus_subsys;
+	bus->subsys.kobj.kset = bus_kset;
 	bus->subsys.kobj.ktype = &bus_ktype;
 
 	retval = subsystem_register(&bus->subsys);
@@ -935,7 +935,10 @@ EXPORT_SYMBOL_GPL(bus_unregister_notifier);
 
 int __init buses_init(void)
 {
-	return subsystem_register(&bus_subsys);
+	bus_kset = kset_create_and_add("bus", &bus_uevent_ops, NULL);
+	if (!bus_kset)
+		return -ENOMEM;
+	return 0;
 }
 
 
-- 
1.5.3.8

