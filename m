Return-Path: <linux-kernel-owner+w=401wt.eu-S932871AbYAYIkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932871AbYAYIkh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:40:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752792AbYAYIBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:01:51 -0500
Received: from mx1.suse.de ([195.135.220.2]:59436 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764070AbYAYH7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:59:48 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Shaohua Li <shaohua.li@intel.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 115/196] Kobject: change drivers/cpuidle/sysfs.c to use kobject_init_and_add
Date: Thu, 24 Jan 2008 23:32:24 -0800
Message-Id: <1201246425-5058-36-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stop using kobject_register, as this way we can control the sending of
the uevent properly, after everything is properly initialized.

Cc: Shaohua Li <shaohua.li@intel.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/cpuidle/sysfs.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/cpuidle/sysfs.c b/drivers/cpuidle/sysfs.c
index 0f3515e..059db9c 100644
--- a/drivers/cpuidle/sysfs.c
+++ b/drivers/cpuidle/sysfs.c
@@ -300,14 +300,13 @@ int cpuidle_add_state_sysfs(struct cpuidle_device *device)
 		kobj->state = &device->states[i];
 		init_completion(&kobj->kobj_unregister);
 
-		kobj->kobj.parent = &device->kobj;
-		kobj->kobj.ktype = &ktype_state_cpuidle;
-		kobject_set_name(&kobj->kobj, "state%d", i);
-		ret = kobject_register(&kobj->kobj);
+		ret = kobject_init_and_add(&kobj->kobj, &ktype_state_cpuidle, &device->kobj,
+					   "state%d", i);
 		if (ret) {
 			kfree(kobj);
 			goto error_state;
 		}
+		kobject_uevent(&kobj->kobj, KOBJ_ADD);
 		device->kobjs[i] = kobj;
 	}
 
@@ -339,12 +338,14 @@ int cpuidle_add_sysfs(struct sys_device *sysdev)
 {
 	int cpu = sysdev->id;
 	struct cpuidle_device *dev;
+	int error;
 
 	dev = per_cpu(cpuidle_devices, cpu);
-	dev->kobj.parent = &sysdev->kobj;
-	dev->kobj.ktype = &ktype_cpuidle;
-	kobject_set_name(&dev->kobj, "%s", "cpuidle");
-	return kobject_register(&dev->kobj);
+	error = kobject_init_and_add(&dev->kobj, &ktype_cpuidle, &sysdev->kobj,
+				     "cpuidle");
+	if (!error)
+		kobject_uevent(&dev->kobj, KOBJ_ADD);
+	return error;
 }
 
 /**
-- 
1.5.3.8

