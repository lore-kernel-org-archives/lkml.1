Return-Path: <linux-kernel-owner+w=401wt.eu-S1764276AbXKCARF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764276AbXKCARF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 20:17:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762225AbXKCADd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 20:03:33 -0400
Received: from ns.suse.de ([195.135.220.2]:41247 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762223AbXKCADc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 20:03:32 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Matt Domsch <Matt_Domsch@dell.com>
Subject: [PATCH 50/54] kset: convert edd to use kset_create
Date: Fri,  2 Nov 2007 16:59:28 -0700
Message-Id: <1194047972-9850-50-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <20071102235758.GA9803@kroah.com>
References: <20071102235758.GA9803@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dynamically create the kset instead of declaring it statically.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Matt Domsch <Matt_Domsch@dell.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/firmware/edd.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/firmware/edd.c b/drivers/firmware/edd.c
index fc567fa..098132a 100644
--- a/drivers/firmware/edd.c
+++ b/drivers/firmware/edd.c
@@ -631,7 +631,7 @@ static struct kobj_type edd_ktype = {
 	.default_attrs	= def_attrs,
 };
 
-static decl_subsys(edd, NULL);
+static struct kset *edd_kset;
 
 
 /**
@@ -723,7 +723,7 @@ edd_device_register(struct edd_device *edev, int i)
 	edd_dev_set_info(edev, i);
 	kobject_set_name(&edev->kobj, "int13_dev%02x",
 			 0x80 + i);
-	edev->kobj.kset = &edd_subsys;
+	edev->kobj.kset = edd_kset;
 	edev->kobj.ktype = &edd_ktype;
 	error = kobject_register(&edev->kobj);
 	if (!error)
@@ -756,9 +756,9 @@ edd_init(void)
 		return 1;
 	}
 
-	rc = firmware_register(&edd_subsys);
-	if (rc)
-		return rc;
+	edd_kset = kset_create_and_register("edd", NULL, NULL, firmware_kset);
+	if (IS_ERR(edd_kset))
+		return PTR_ERR(edd_kset);
 
 	for (i = 0; i < edd_num_devices() && !rc; i++) {
 		edev = kzalloc(sizeof (*edev), GFP_KERNEL);
@@ -774,7 +774,7 @@ edd_init(void)
 	}
 
 	if (rc)
-		firmware_unregister(&edd_subsys);
+		kset_unregister(edd_kset);
 	return rc;
 }
 
@@ -788,7 +788,7 @@ edd_exit(void)
 		if ((edev = edd_devices[i]))
 			edd_device_unregister(edev);
 	}
-	firmware_unregister(&edd_subsys);
+	kset_unregister(edd_kset);
 }
 
 late_initcall(edd_init);
-- 
1.5.3.4

