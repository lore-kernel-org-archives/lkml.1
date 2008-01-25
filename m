Return-Path: <linux-kernel-owner+w=401wt.eu-S1760497AbYAYIKE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760497AbYAYIKE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:10:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764100AbYAYIAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:00:10 -0500
Received: from mail.suse.de ([195.135.220.2]:59402 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761589AbYAYH7n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:59:43 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Dave Larson <larson1@us.ibm.com>,
       Santiago Leon <santil@us.ibm.com>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 149/196] Driver: add driver_add_kobj for looney iseries_veth driver
Date: Thu, 24 Jan 2008 23:32:58 -0800
Message-Id: <1201246425-5058-70-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The iseries driver wants to hang kobjects off of its driver, so, to
preserve backwards compatibility, we need to add a call to the driver
core to allow future changes to work properly.

Hopefully no one uses this function in the future and the iseries_veth
driver authors come to their senses so I can remove this hack...

Cc: Dave Larson <larson1@us.ibm.com>
Cc: Santiago Leon <santil@us.ibm.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/driver.c      |   24 ++++++++++++++++++++++++
 drivers/net/iseries_veth.c |    2 +-
 include/linux/device.h     |    4 ++++
 3 files changed, 29 insertions(+), 1 deletions(-)

diff --git a/drivers/base/driver.c b/drivers/base/driver.c
index e3b5840..633ae1d 100644
--- a/drivers/base/driver.c
+++ b/drivers/base/driver.c
@@ -124,6 +124,30 @@ void driver_remove_file(struct device_driver * drv, struct driver_attribute * at
 
 
 /**
+ * driver_add_kobj - add a kobject below the specified driver
+ *
+ * You really don't want to do this, this is only here due to one looney
+ * iseries driver, go poke those developers if you are annoyed about
+ * this...
+ */
+int driver_add_kobj(struct device_driver *drv, struct kobject *kobj,
+		    const char *fmt, ...)
+{
+	va_list args;
+	char *name;
+
+	va_start(args, fmt);
+	name = kvasprintf(GFP_KERNEL, fmt, args);
+	va_end(args);
+
+	if (!name)
+		return -ENOMEM;
+
+	return kobject_add_ng(kobj, &drv->kobj, "%s", name);
+}
+EXPORT_SYMBOL_GPL(driver_add_kobj);
+
+/**
  *	get_driver - increment driver reference count.
  *	@drv:	driver.
  */
diff --git a/drivers/net/iseries_veth.c b/drivers/net/iseries_veth.c
index 90ff4ec..1a8299a 100644
--- a/drivers/net/iseries_veth.c
+++ b/drivers/net/iseries_veth.c
@@ -1705,7 +1705,7 @@ static int __init veth_module_init(void)
 
 		kobj = &veth_cnx[i]->kobject;
 		/* If the add failes, complain but otherwise continue */
-		if (0 != kobject_add_ng(kobj, &veth_driver.driver.kobj,
+		if (0 != driver_add_kobj(&veth_driver.driver, kobj,
 					"cnx%.2d", veth_cnx[i]->remote_lp))
 			veth_error("cnx %d: Failed adding to sysfs.\n", i);
 	}
diff --git a/include/linux/device.h b/include/linux/device.h
index d974dda..721ee31 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -156,6 +156,10 @@ extern int __must_check driver_create_file(struct device_driver *,
 					struct driver_attribute *);
 extern void driver_remove_file(struct device_driver *, struct driver_attribute *);
 
+extern int __must_check driver_add_kobj(struct device_driver *drv,
+					struct kobject *kobj,
+					const char *fmt, ...);
+
 extern int __must_check driver_for_each_device(struct device_driver * drv,
 		struct device *start, void *data,
 		int (*fn)(struct device *, void *));
-- 
1.5.3.8

