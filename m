Return-Path: <linux-kernel-owner+w=401wt.eu-S1765362AbYAYITf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765362AbYAYITf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:19:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759546AbYAYIAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:00:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53683 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764086AbYAYH7w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:59:52 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 117/196] Kobject: change drivers/base/sys.c to use kobject_init_and_add
Date: Thu, 24 Jan 2008 23:32:26 -0800
Message-Id: <1201246425-5058-38-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stop using kobject_register, as this way we can control the sending of
the uevent properly, after everything is properly initialized.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/sys.c |   16 ++++++----------
 1 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/base/sys.c b/drivers/base/sys.c
index 29eadc6..47fc6eb 100644
--- a/drivers/base/sys.c
+++ b/drivers/base/sys.c
@@ -224,20 +224,15 @@ int sysdev_register(struct sys_device * sysdev)
 	if (!cls)
 		return -EINVAL;
 
+	pr_debug("Registering sys device '%s'\n", kobject_name(&sysdev->kobj));
+
 	/* Make sure the kset is set */
 	sysdev->kobj.kset = &cls->kset;
 
-	/* But make sure we point to the right type for sysfs translation */
-	sysdev->kobj.ktype = &ktype_sysdev;
-	error = kobject_set_name(&sysdev->kobj, "%s%d",
-			 kobject_name(&cls->kset.kobj), sysdev->id);
-	if (error)
-		return error;
-
-	pr_debug("Registering sys device '%s'\n", kobject_name(&sysdev->kobj));
-
 	/* Register the object */
-	error = kobject_register(&sysdev->kobj);
+	error = kobject_init_and_add(&sysdev->kobj, &ktype_sysdev, NULL,
+				     "%s%d", kobject_name(&cls->kset.kobj),
+				     sysdev->id);
 
 	if (!error) {
 		struct sysdev_driver * drv;
@@ -254,6 +249,7 @@ int sysdev_register(struct sys_device * sysdev)
 		}
 		mutex_unlock(&sysdev_drivers_lock);
 	}
+	kobject_uevent(&sysdev->kobj, KOBJ_ADD);
 	return error;
 }
 
-- 
1.5.3.8

