Return-Path: <linux-kernel-owner+w=401wt.eu-S1757114AbZGMUlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757114AbZGMUlh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 16:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756865AbZGMUlg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 16:41:36 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:58752 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755600AbZGMUlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 16:41:35 -0400
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-acpi@vger.kernel.org, rpurdie@rpsys.net, lenb@kernel.org,
       rui.zhang@intel.com, corentincj@iksaif.net,
       Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 1/3] backlight: Allow drivers to update the core, and generate events on changes
Date: Mon, 13 Jul 2009 21:41:23 +0100
Message-Id: <1247517685-7719-1-git-send-email-mjg@redhat.com>
X-Mailer: git-send-email 1.6.2.5
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 78.86.230.144
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Certain hardware will send us events when the backlight brightness
changes. Add a function to update the value in the core, and
additionally send a uevent so that userspace can pop up appropriate
UI. The uevents are flagged depending on whether the update originated
in the kernel or from userspace, making it easier to only display UI
at the appropriate time.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/video/backlight/backlight.c |   23 +++++++++++++++++++++++
 include/linux/backlight.h           |    1 +
 2 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
index 157057c..98ab76c 100644
--- a/drivers/video/backlight/backlight.c
+++ b/drivers/video/backlight/backlight.c
@@ -120,6 +120,7 @@ static ssize_t backlight_store_brightness(struct device *dev,
 {
 	int rc;
 	struct backlight_device *bd = to_backlight_device(dev);
+	char *envp[] = { "SOURCE=userspace", NULL };
 	unsigned long brightness;
 
 	rc = strict_strtoul(buf, 0, &brightness);
@@ -142,6 +143,8 @@ static ssize_t backlight_store_brightness(struct device *dev,
 	}
 	mutex_unlock(&bd->ops_lock);
 
+	kobject_uevent_env(&bd->dev.kobj, KOBJ_CHANGE, envp);
+
 	return rc;
 }
 
@@ -214,6 +217,26 @@ static struct device_attribute bl_device_attributes[] = {
 };
 
 /**
+ * backlight_force_update - tell the backlight subsystem that hardware state
+ *   has changed
+ * @bd: the backlight device to update
+ *
+ * Updates the internal state of the backlight in response to a hardware event,
+ * and generate a uevent to notify userspace
+ */
+void backlight_force_update(struct backlight_device *bd)
+{
+	char *envp[] = { "SOURCE=kernel", NULL };
+
+	mutex_lock(&bd->ops_lock);
+	if (bd->ops && bd->ops->get_brightness)
+		bd->props.brightness = bd->ops->get_brightness(bd);
+	mutex_unlock(&bd->ops_lock);
+	kobject_uevent_env(&bd->dev.kobj, KOBJ_CHANGE, envp);
+}
+EXPORT_SYMBOL(backlight_force_update);
+
+/**
  * backlight_device_register - create and register a new object of
  *   backlight_device class.
  * @name: the name of the new object(must be the same as the name of the
diff --git a/include/linux/backlight.h b/include/linux/backlight.h
index 79ca2da..8298c43 100644
--- a/include/linux/backlight.h
+++ b/include/linux/backlight.h
@@ -100,6 +100,7 @@ static inline void backlight_update_status(struct backlight_device *bd)
 extern struct backlight_device *backlight_device_register(const char *name,
 	struct device *dev, void *devdata, struct backlight_ops *ops);
 extern void backlight_device_unregister(struct backlight_device *bd);
+extern void backlight_force_update(struct backlight_device *bd);
 
 #define to_backlight_device(obj) container_of(obj, struct backlight_device, dev)
 
-- 
1.6.2.5

