Return-Path: <linux-kernel-owner+w=401wt.eu-S1761952AbYAYHf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761952AbYAYHf6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:35:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759374AbYAYHSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:18:00 -0500
Received: from ns.suse.de ([195.135.220.2]:52823 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759364AbYAYHR7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:17:59 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 061/196] kset: convert drivers/base/class.c to use kset_create
Date: Thu, 24 Jan 2008 23:09:59 -0800
Message-Id: <1201245134-4876-61-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dynamically create the kset instead of declaring it statically.

The class_obj subsystem is not yet converted as it is more complex and
should be going away soon with the removal of class_device from the
kernel tree.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/class.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/base/class.c b/drivers/base/class.c
index 8ad9892..d8a92c6 100644
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -71,7 +71,7 @@ static struct kobj_type class_ktype = {
 };
 
 /* Hotplug events for classes go to the class_obj subsys */
-static decl_subsys(class, NULL);
+static struct kset *class_kset;
 
 
 int class_create_file(struct class * cls, const struct class_attribute * attr)
@@ -149,7 +149,7 @@ int class_register(struct class * cls)
 	if (error)
 		return error;
 
-	cls->subsys.kobj.kset = &class_subsys;
+	cls->subsys.kobj.kset = class_kset;
 	cls->subsys.kobj.ktype = &class_ktype;
 
 	error = subsystem_register(&cls->subsys);
@@ -855,11 +855,9 @@ void class_interface_unregister(struct class_interface *class_intf)
 
 int __init classes_init(void)
 {
-	int retval;
-
-	retval = subsystem_register(&class_subsys);
-	if (retval)
-		return retval;
+	class_kset = kset_create_and_add("class", NULL, NULL);
+	if (!class_kset)
+		return -ENOMEM;
 
 	/* ick, this is ugly, the things we go through to keep from showing up
 	 * in sysfs... */
-- 
1.5.3.8

