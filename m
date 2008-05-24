Return-Path: <linux-kernel-owner+w=401wt.eu-S1759637AbYEXCP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759637AbYEXCP2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 22:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755587AbYEXCPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 22:15:17 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:56143 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755471AbYEXCPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 22:15:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=qsPGwzeIVihWc/aJlQ5dG3uclH6WzhvV1uSuxa+9psFe/qoacrLMaY1lsdRXXYl0jx0Q+eLD+XQBDUg0PDJLhOdQh8VoKdTldELxvpbY89A5VTxqiKbAGWLx7Cy4H/MFWjleHj3hGCgpf4GdhHayA1e9QXN7jg7st10DX0f1Z+4=
Date: Sat, 24 May 2008 11:03:23 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Matt Domsch <Matt_Domsch@Dell.com>
Subject: [PATCH] edd: fix error paths in module_init
Message-ID: <20080524020321.GA3470@APFDCB5C>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes error handlings when kzalloc() or edd_device_register()
failed in module_init. It needs to clean registered edd_devices before
return error.

Also this patch fixes return value of module_init. module_init should not
return positive value.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Matt Domsch <Matt_Domsch@Dell.com>
---
 drivers/firmware/edd.c |   30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

Index: 2.6-git/drivers/firmware/edd.c
===================================================================
--- 2.6-git.orig/drivers/firmware/edd.c
+++ 2.6-git/drivers/firmware/edd.c
@@ -718,8 +718,7 @@ edd_device_register(struct edd_device *e
 {
 	int error;
 
-	if (!edev)
-		return 1;
+	BUG_ON(!edev);
 	edd_dev_set_info(edev, i);
 	edev->kobj.kset = edd_kset;
 	error = kobject_init_and_add(&edev->kobj, &edd_ktype, NULL,
@@ -744,8 +743,8 @@ static inline int edd_num_devices(void)
 static int __init
 edd_init(void)
 {
-	unsigned int i;
-	int rc=0;
+	int i;
+	int rc;
 	struct edd_device *edev;
 
 	printk(KERN_INFO "BIOS EDD facility v%s %s, %d devices found\n",
@@ -753,29 +752,36 @@ edd_init(void)
 
 	if (!edd_num_devices()) {
 		printk(KERN_INFO "EDD information not available.\n");
-		return 1;
+		return -ENODEV;
 	}
 
 	edd_kset = kset_create_and_add("edd", NULL, firmware_kobj);
 	if (!edd_kset)
 		return -ENOMEM;
 
-	for (i = 0; i < edd_num_devices() && !rc; i++) {
+	for (i = 0; i < edd_num_devices(); i++) {
 		edev = kzalloc(sizeof (*edev), GFP_KERNEL);
-		if (!edev)
-			return -ENOMEM;
+		if (!edev) {
+			rc = -ENOMEM;
+			goto out;
+		}
 
 		rc = edd_device_register(edev, i);
 		if (rc) {
 			kfree(edev);
-			break;
+			goto out;
 		}
 		edd_devices[i] = edev;
 	}
 
-	if (rc)
-		kset_unregister(edd_kset);
-	return rc;
+	return 0;
+out:
+	while (--i >= 0)
+		edd_device_unregister(edd_devices[i]);
+
+	kset_unregister(edd_kset);
+
+  	return rc;
 }
 
 static void __exit
