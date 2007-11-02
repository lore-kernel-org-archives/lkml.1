Return-Path: <linux-kernel-owner+w=401wt.eu-S1762566AbXKCAGO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762566AbXKCAGO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 20:06:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761932AbXKCABT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 20:01:19 -0400
Received: from ns2.suse.de ([195.135.220.15]:34833 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761697AbXKCABR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 20:01:17 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 18/54] kset: convert drivers/base/class.c kset_create_and_register
Date: Fri,  2 Nov 2007 16:58:56 -0700
Message-Id: <1194047972-9850-18-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <20071102235758.GA9803@kroah.com>
References: <20071102235758.GA9803@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
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
index 8ad9892..27256b3 100644
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
+	class_kset = kset_create_and_register("class", NULL, NULL, NULL);
+	if (IS_ERR(class_kset))
+		return PTR_ERR(class_kset);
 
 	/* ick, this is ugly, the things we go through to keep from showing up
 	 * in sysfs... */
-- 
1.5.3.4

