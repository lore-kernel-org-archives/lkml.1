Return-Path: <linux-kernel-owner+w=401wt.eu-S933609AbXJLWcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933609AbXJLWcy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 18:32:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932394AbXJLWTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 18:19:39 -0400
Received: from mx2.suse.de ([195.135.220.15]:49708 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760051AbXJLWTh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 18:19:37 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Jean Delvare <khali@linux-fr.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 26/75] dmi-id: Use dynamic sysfs attributes
Date: Fri, 12 Oct 2007 15:16:30 -0700
Message-Id: <119222756066-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <11922275552558-git-send-email-gregkh@suse.de>
References: \<20071012221251.GB4559@kroah.com\>
 <11922274393667-git-send-email-gregkh@suse.de>
 <11922274441634-git-send-email-gregkh@suse.de>
 <11922274503271-git-send-email-gregkh@suse.de>
 <11922274543490-git-send-email-gregkh@suse.de>
 <11922274643370-git-send-email-gregkh@suse.de>
 <11922274682487-git-send-email-gregkh@suse.de>
 <11922274732211-git-send-email-gregkh@suse.de>
 <11922274772578-git-send-email-gregkh@suse.de>
 <1192227481691-git-send-email-gregkh@suse.de>
 <11922274853108-git-send-email-gregkh@suse.de>
 <11922274901810-git-send-email-gregkh@suse.de>
 <11922274941588-git-send-email-gregkh@suse.de>
 <11922274993462-git-send-email-gregkh@suse.de>
 <11922275031518-git-send-email-gregkh@suse.de>
 <11922275074080-git-send-email-gregkh@suse.de>
 <11922275121763-git-send-email-gregkh@suse.de>
 <11922275181138-git-send-email-gregkh@suse.de>
 <11922275221643-git-send-email-gregkh@suse.de>
 <1192227527856-git-send-email-gregkh@suse.de>
 <11922275312531-git-send-email-gregkh@suse.de>
 <11922275371856-git-send-email-gregkh@suse.de>
 <11922275413548-git-send-email-gregkh@suse.de>
 <11922275462233-git-send-email-gregkh@suse.de>
 <1192227551156-git-send-email-gregkh@suse.de>
 <11922275552558-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean Delvare <khali@linux-fr.org>

We can use sysfs attributes with an extra parameter for dmi id
attributes. This makes it possible to use the same callback function
for all attributes, reducing the binary size significantly (-18% on
x86_64.)

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Acked-by: Lennart Poettering <mzxreary@0pointer.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/firmware/dmi-id.c |   38 ++++++++++++++++++++++++++------------
 1 files changed, 26 insertions(+), 12 deletions(-)

diff --git a/drivers/firmware/dmi-id.c b/drivers/firmware/dmi-id.c
index 2678098..a7bd87d 100644
--- a/drivers/firmware/dmi-id.c
+++ b/drivers/firmware/dmi-id.c
@@ -13,21 +13,35 @@
 #include <linux/device.h>
 #include <linux/autoconf.h>
 
+struct dmi_device_attribute{
+	struct device_attribute dev_attr;
+	int field;
+};
+#define to_dmi_dev_attr(_dev_attr) \
+	container_of(_dev_attr, struct dmi_device_attribute, dev_attr)
+
 #define DEFINE_DMI_ATTR(_name, _mode, _show)		\
 static struct device_attribute sys_dmi_##_name##_attr =	\
 	__ATTR(_name, _mode, _show, NULL);
 
-#define DEFINE_DMI_ATTR_WITH_SHOW(_name, _mode, _field)			\
-static ssize_t sys_dmi_##_name##_show(struct device *dev,		\
-				      struct device_attribute *attr,	\
-				      char *page)			\
-{									\
-	ssize_t len;							\
-	len = scnprintf(page, PAGE_SIZE, "%s\n", dmi_get_system_info(_field)); \
-	page[len-1] = '\n';						\
-	return len;							\
-}									\
-DEFINE_DMI_ATTR(_name, _mode, sys_dmi_##_name##_show);
+static ssize_t sys_dmi_field_show(struct device *dev,
+				  struct device_attribute *attr,
+				  char *page)
+{
+	int field = to_dmi_dev_attr(attr)->field;
+	ssize_t len;
+	len = scnprintf(page, PAGE_SIZE, "%s\n", dmi_get_system_info(field));
+	page[len-1] = '\n';
+	return len;
+}
+
+#define DMI_ATTR(_name, _mode, _show, _field)			\
+	{ .dev_attr = __ATTR(_name, _mode, _show, NULL),	\
+	  .field = _field }
+
+#define DEFINE_DMI_ATTR_WITH_SHOW(_name, _mode, _field)		\
+static struct dmi_device_attribute sys_dmi_##_name##_attr =	\
+	DMI_ATTR(_name, _mode, sys_dmi_field_show, _field);
 
 DEFINE_DMI_ATTR_WITH_SHOW(bios_vendor,		0444, DMI_BIOS_VENDOR);
 DEFINE_DMI_ATTR_WITH_SHOW(bios_version,		0444, DMI_BIOS_VERSION);
@@ -160,7 +174,7 @@ static struct device *dmi_dev;
 
 #define ADD_DMI_ATTR(_name, _field) \
 	if (dmi_get_system_info(_field)) \
-		sys_dmi_attributes[i++] = & sys_dmi_##_name##_attr.attr;
+		sys_dmi_attributes[i++] = &sys_dmi_##_name##_attr.dev_attr.attr;
 
 extern int dmi_available;
 
-- 
1.5.3.4

