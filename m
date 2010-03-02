Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab0CBX3t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:29:49 -0500
Received: from kroah.org ([198.145.64.141]:38697 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752314Ab0CBX3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:29:47 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 52/62] driver core: Use sysfs_rename_link in device_rename
Date: Tue,  2 Mar 2010 15:28:51 -0800
Message-Id: <1267572541-410-52-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100302230933.GA32287@kroah.com>
References: <20100302230933.GA32287@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Don't open code the renaming of symlinks in sysfs
instead use the new helper function sysfs_rename_link

Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/core.c |   18 ++++++------------
 1 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index bbfcea0..77acb8a 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1569,22 +1569,16 @@ int device_rename(struct device *dev, char *new_name)
 	if (old_class_name) {
 		new_class_name = make_class_name(dev->class->name, &dev->kobj);
 		if (new_class_name) {
-			error = sysfs_create_link_nowarn(&dev->parent->kobj,
-							 &dev->kobj,
-							 new_class_name);
-			if (error)
-				goto out;
-			sysfs_remove_link(&dev->parent->kobj, old_class_name);
+			error = sysfs_rename_link(&dev->parent->kobj,
+						  &dev->kobj,
+						  old_class_name,
+						  new_class_name);
 		}
 	}
 #else
 	if (dev->class) {
-		error = sysfs_create_link_nowarn(&dev->class->p->class_subsys.kobj,
-						 &dev->kobj, dev_name(dev));
-		if (error)
-			goto out;
-		sysfs_remove_link(&dev->class->p->class_subsys.kobj,
-				  old_device_name);
+		error = sysfs_rename_link(&dev->class->p->class_subsys.kobj,
+					  &dev->kobj, old_device_name, new_name);
 	}
 #endif
 
-- 
1.7.0.1

