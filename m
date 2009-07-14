Return-Path: <linux-kernel-owner+w=401wt.eu-S1755277AbZGNQGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277AbZGNQGR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 12:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755220AbZGNQGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 12:06:16 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:42230 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877AbZGNQGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 12:06:15 -0400
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-acpi@vger.kernel.org, rpurdie@rpsys.net, lenb@kernel.org,
       rui.zhang@intel.com, corentincj@iksaif.net,
       Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 1/3] backlight: Allow drivers to update the core, and generate events on changes
Date: Tue, 14 Jul 2009 17:06:02 +0100
Message-Id: <1247587564-27737-1-git-send-email-mjg@redhat.com>
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

Updated to allow drivers to provide a reason for the change

 drivers/video/backlight/backlight.c |   41 +++++++++++++++++++++++++++++++++++
 include/linux/backlight.h           |    7 ++++++
 2 files changed, 48 insertions(+), 0 deletions(-)

diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
index 157057c..01efb2d 100644
--- a/drivers/video/backlight/backlight.c
+++ b/drivers/video/backlight/backlight.c
@@ -73,6 +73,26 @@ static inline void backlight_unregister_fb(struct backlight_device *bd)
 }
 #endif /* CONFIG_FB */
 
+static void backlight_generate_event(struct backlight_device *bd,
+				     enum backlight_update_reason reason)
+{
+	char *envp[2];
+
+	switch (reason) {
+	case BACKLIGHT_UPDATE_SYSFS:
+		envp[0] = "SOURCE=sysfs";
+		break;
+	case BACKLIGHT_UPDATE_HOTKEY:
+		envp[0] = "SOURCE=hotkey";
+		break;
+	default:
+		envp[0] = "SORUCE=unknown";
+		break;
+	}
+	envp[1] = NULL;
+	kobject_uevent_env(&bd->dev.kobj, KOBJ_CHANGE, envp);
+}
+
 static ssize_t backlight_show_power(struct device *dev,
 		struct device_attribute *attr,char *buf)
 {
@@ -142,6 +162,8 @@ static ssize_t backlight_store_brightness(struct device *dev,
 	}
 	mutex_unlock(&bd->ops_lock);
 
+	backlight_generate_event(bd, BACKLIGHT_UPDATE_SYSFS);
+
 	return rc;
 }
 
@@ -214,6 +236,25 @@ static struct device_attribute bl_device_attributes[] = {
 };
 
 /**
+ * backlight_force_update - tell the backlight subsystem that hardware state
+ *   has changed
+ * @bd: the backlight device to update
+ *
+ * Updates the internal state of the backlight in response to a hardware event,
+ * and generate a uevent to notify userspace
+ */
+void backlight_force_update(struct backlight_device *bd,
+			    enum backlight_update_reason reason)
+{
+	mutex_lock(&bd->ops_lock);
+	if (bd->ops && bd->ops->get_brightness)
+		bd->props.brightness = bd->ops->get_brightness(bd);
+	mutex_unlock(&bd->ops_lock);
+	backlight_generate_event(bd, reason);
+}
+EXPORT_SYMBOL(backlight_force_update);
+
+/**
  * backlight_device_register - create and register a new object of
  *   backlight_device class.
  * @name: the name of the new object(must be the same as the name of the
diff --git a/include/linux/backlight.h b/include/linux/backlight.h
index 79ca2da..0f5f578 100644
--- a/include/linux/backlight.h
+++ b/include/linux/backlight.h
@@ -27,6 +27,11 @@
  * Any other use of the locks below is probably wrong.
  */
 
+enum backlight_update_reason {
+	BACKLIGHT_UPDATE_HOTKEY,
+	BACKLIGHT_UPDATE_SYSFS,
+};
+
 struct backlight_device;
 struct fb_info;
 
@@ -100,6 +105,8 @@ static inline void backlight_update_status(struct backlight_device *bd)
 extern struct backlight_device *backlight_device_register(const char *name,
 	struct device *dev, void *devdata, struct backlight_ops *ops);
 extern void backlight_device_unregister(struct backlight_device *bd);
+extern void backlight_force_update(struct backlight_device *bd,
+				   enum backlight_update_reason reason);
 
 #define to_backlight_device(obj) container_of(obj, struct backlight_device, dev)
 
-- 
1.6.2.5

