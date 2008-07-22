Return-Path: <linux-kernel-owner+w=401wt.eu-S932123AbYGVFma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932123AbYGVFma (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:42:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757540AbYGVFZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:25:52 -0400
Received: from mail.suse.de ([195.135.220.2]:54084 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757535AbYGVFZu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:25:50 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Ben Dooks <ben-linux@fluff.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 62/79] sysdev: fix debugging statements in registration code.
Date: Mon, 21 Jul 2008 22:19:26 -0700
Message-Id: <1216703983-21448-62-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <20080722051805.GA17373@suse.de>
References: <20080722051805.GA17373@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Dooks <ben-linux@fluff.org>

The systdev_class_register() and sysdev_register() functions have
pr_debug() statements which are enabled when the user selects the
driver core debug. Both of these routines do not produce the
correct output, as they make assumptions about data which has not
been initialised.

In sysdev_class_register() the code uses the kobject_name(&cls->kset.kobj)
at the start of the function, but this is not setup until later in the
same call. Change this to use cls->name which is passed in from the caller.

The sysdev_register() function tries to get the name of the sysdev by
kobject_name(&sysdev->kobj), but that isn't setup until later in the same
function so change this message to use the name of the sysdev's class and
add another message once the name is initialised.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/sys.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/base/sys.c b/drivers/base/sys.c
index 358bb0b..50690d9 100644
--- a/drivers/base/sys.c
+++ b/drivers/base/sys.c
@@ -130,8 +130,8 @@ static struct kset *system_kset;
 
 int sysdev_class_register(struct sysdev_class * cls)
 {
-	pr_debug("Registering sysdev class '%s'\n",
-		 kobject_name(&cls->kset.kobj));
+	pr_debug("Registering sysdev class '%s'\n", cls->name);
+
 	INIT_LIST_HEAD(&cls->drivers);
 	memset(&cls->kset.kobj, 0x00, sizeof(struct kobject));
 	cls->kset.kobj.parent = &system_kset->kobj;
@@ -241,7 +241,8 @@ int sysdev_register(struct sys_device * sysdev)
 	if (!cls)
 		return -EINVAL;
 
-	pr_debug("Registering sys device '%s'\n", kobject_name(&sysdev->kobj));
+	pr_debug("Registering sys device of class '%s'\n",
+		 kobject_name(&cls->kset.kobj));
 
 	/* initialize the kobject to 0, in case it had previously been used */
 	memset(&sysdev->kobj, 0x00, sizeof(struct kobject));
@@ -257,6 +258,9 @@ int sysdev_register(struct sys_device * sysdev)
 	if (!error) {
 		struct sysdev_driver * drv;
 
+		pr_debug("Registering sys device '%s'\n",
+			 kobject_name(&sysdev->kobj));
+
 		mutex_lock(&sysdev_drivers_lock);
 		/* Generic notification is implicit, because it's that
 		 * code that should have called us.
@@ -269,6 +273,7 @@ int sysdev_register(struct sys_device * sysdev)
 		}
 		mutex_unlock(&sysdev_drivers_lock);
 	}
+
 	kobject_uevent(&sysdev->kobj, KOBJ_ADD);
 	return error;
 }
-- 
1.5.6.3

