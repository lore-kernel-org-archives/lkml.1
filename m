Return-Path: <linux-kernel-owner+w=401wt.eu-S1763442AbYB0XVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763442AbYB0XVs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 18:21:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760148AbYB0XVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 18:21:16 -0500
Received: from front3.netvisao.pt ([213.228.128.91]:55403 "HELO
	front1.netvisao.pt" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1759751AbYB0XVL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 18:21:11 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Feb 2008 18:21:10 EST
From: Luis Henriques <lhenriques@netvisao.pt>
To: linux-kernel@vger.kernel.org
Cc: Markus.Lidel@shadowconnect.com
Subject: [PATCH] drivers/message/i2o/device.c warnings
Date: Wed, 27 Feb 2008 23:14:25 +0000
Message-ID: <874pbum1pq.fsf@hades.astedixie.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

file drivers/message/i2o/device.c contains the following warnings:

drivers/message/i2o/device.c: In function ‘i2o_device_add’:
drivers/message/i2o/device.c:247: warning: ignoring return value of ‘sysfs_create_link’, declared with attribute warn_unused_result
drivers/message/i2o/device.c:254: warning: ignoring return value of ‘sysfs_create_link’, declared with attribute warn_unused_result
drivers/message/i2o/device.c:260: warning: ignoring return value of ‘sysfs_create_link’, declared with attribute warn_unused_result
drivers/message/i2o/device.c:267: warning: ignoring return value of ‘sysfs_create_link’, declared with attribute warn_unused_result

The following patch is an attempt to remove these warnings.

Signed-off-by: Luis Henriques <lhenriques <at> netvisao.pt>

diff --git a/drivers/message/i2o/device.c b/drivers/message/i2o/device.c
index 489d7c5..73ade62 100644
--- a/drivers/message/i2o/device.c
+++ b/drivers/message/i2o/device.c
@@ -243,29 +243,41 @@ static int i2o_device_add(struct i2o_controller *c, i2o_lct_entry *entry)
 
        /* create user entries for this device */
        tmp = i2o_iop_find_device(i2o_dev->iop, i2o_dev->lct_data.user_tid);
-       if (tmp && (tmp != i2o_dev))
-               sysfs_create_link(&i2o_dev->device.kobj, &tmp->device.kobj,
-                                 "user");
+       if (tmp && (tmp != i2o_dev)) {
+               rc = sysfs_create_link(&i2o_dev->device.kobj, &tmp->device.kobj,
+                                       "user");
+                if (rc)
+                        goto err;
+        }
 
        /* create user entries refering to this device */
        list_for_each_entry(tmp, &c->devices, list)
            if ((tmp->lct_data.user_tid == i2o_dev->lct_data.tid)
-               && (tmp != i2o_dev))
-               sysfs_create_link(&tmp->device.kobj,
-                                 &i2o_dev->device.kobj, "user");
+               && (tmp != i2o_dev)) {
+               rc = sysfs_create_link(&tmp->device.kobj,
+                                       &i2o_dev->device.kobj, "user");
+                if (rc)
+                        goto err;
+        }
 
        /* create parent entries for this device */
        tmp = i2o_iop_find_device(i2o_dev->iop, i2o_dev->lct_data.parent_tid);
-       if (tmp && (tmp != i2o_dev))
-               sysfs_create_link(&i2o_dev->device.kobj, &tmp->device.kobj,
-                                 "parent");
+       if (tmp && (tmp != i2o_dev)) {
+               rc = sysfs_create_link(&i2o_dev->device.kobj, &tmp->device.kobj,
+                                       "parent");
+                if (rc)
+                        goto err;
+        }
 
        /* create parent entries refering to this device */
        list_for_each_entry(tmp, &c->devices, list)
            if ((tmp->lct_data.parent_tid == i2o_dev->lct_data.tid)
-               && (tmp != i2o_dev))
-               sysfs_create_link(&tmp->device.kobj,
-                                 &i2o_dev->device.kobj, "parent");
+               && (tmp != i2o_dev)) {
+               rc = sysfs_create_link(&tmp->device.kobj,
+                                       &i2o_dev->device.kobj, "parent");
+                if (rc)
+                        goto err;
+        }
 
        i2o_driver_notify_device_add_all(i2o_dev);
