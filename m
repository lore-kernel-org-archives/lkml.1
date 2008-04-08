Return-Path: <linux-kernel-owner+w=401wt.eu-S1754642AbYDHLU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642AbYDHLU3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 07:20:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752546AbYDHLTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 07:19:22 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:38338 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752257AbYDHLTT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 07:19:19 -0400
From: "Denis V. Lunev" <den@openvz.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, "Denis V. Lunev" <den@openvz.org>
Subject: [PATCH 23/29] acpi: use non-racy method for proc entries creation
Date: Tue,  8 Apr 2008 15:19:30 +0400
Message-Id: <1207653576-12640-23-git-send-email-den@openvz.org>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1207653508.7171.18.camel@iris.sw.ru>
References: <1207653508.7171.18.camel@iris.sw.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use proc_create()/proc_create_data() to make sure that ->proc_fops and
->data be setup before gluing PDE to main tree.

Add correct ->owner to proc_fops to fix reading/module unloading race.

Signed-off-by: Denis V. Lunev <den@openvz.org>
CC: linux-acpi@vger.kernel.org
---
 drivers/acpi/ac.c                   |   12 +---
 drivers/acpi/battery.c              |   12 ++--
 drivers/acpi/button.c               |   24 +++----
 drivers/acpi/ec.c                   |   11 +---
 drivers/acpi/event.c                |    8 +-
 drivers/acpi/fan.c                  |   14 ++---
 drivers/acpi/power.c                |   11 +--
 drivers/acpi/processor_core.c       |   39 +++++--------
 drivers/acpi/processor_idle.c       |   13 ++---
 drivers/acpi/processor_perflib.c    |   13 +---
 drivers/acpi/processor_thermal.c    |    1 +
 drivers/acpi/processor_throttling.c |    1 +
 drivers/acpi/sbs.c                  |   35 +++--------
 drivers/acpi/sleep/proc.c           |   26 +++-----
 drivers/acpi/system.c               |   27 ++++-----
 drivers/acpi/thermal.c              |   67 +++++++++------------
 drivers/acpi/video.c                |  112 ++++++++++++++---------------------
 17 files changed, 162 insertions(+), 264 deletions(-)

diff --git a/drivers/acpi/ac.c b/drivers/acpi/ac.c
index 76b9bea..ab6b7ac 100644
--- a/drivers/acpi/ac.c
+++ b/drivers/acpi/ac.c
@@ -92,6 +92,7 @@ struct acpi_ac {
 
 #ifdef CONFIG_ACPI_PROCFS_POWER
 static const struct file_operations acpi_ac_fops = {
+	.owner = THIS_MODULE,
 	.open = acpi_ac_open_fs,
 	.read = seq_read,
 	.llseek = seq_lseek,
@@ -195,16 +196,11 @@ static int acpi_ac_add_fs(struct acpi_device *device)
 	}
 
 	/* 'state' [R] */
-	entry = create_proc_entry(ACPI_AC_FILE_STATE,
-				  S_IRUGO, acpi_device_dir(device));
+	entry = proc_create_data(ACPI_AC_FILE_STATE,
+				 S_IRUGO, acpi_device_dir(device),
+				 &acpi_ac_fops, acpi_driver_data(device));
 	if (!entry)
 		return -ENODEV;
-	else {
-		entry->proc_fops = &acpi_ac_fops;
-		entry->data = acpi_driver_data(device);
-		entry->owner = THIS_MODULE;
-	}
-
 	return 0;
 }
 
diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index d5729d5..b1c723f 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -741,15 +741,13 @@ static int acpi_battery_add_fs(struct acpi_device *device)
 	}
 
 	for (i = 0; i < ACPI_BATTERY_NUMFILES; ++i) {
-		entry = create_proc_entry(acpi_battery_file[i].name,
-				  acpi_battery_file[i].mode, acpi_device_dir(device));
+		entry = proc_create_data(acpi_battery_file[i].name,
+					 acpi_battery_file[i].mode,
+					 acpi_device_dir(device),
+					 &acpi_battery_file[i].ops,
+					 acpi_driver_data(device));
 		if (!entry)
 			return -ENODEV;
-		else {
-			entry->proc_fops = &acpi_battery_file[i].ops;
-			entry->data = acpi_driver_data(device);
-			entry->owner = THIS_MODULE;
-		}
 	}
 	return 0;
 }
diff --git a/drivers/acpi/button.c b/drivers/acpi/button.c
index 6c5da83..1dfec41 100644
--- a/drivers/acpi/button.c
+++ b/drivers/acpi/button.c
@@ -102,6 +102,7 @@ struct acpi_button {
 };
 
 static const struct file_operations acpi_button_info_fops = {
+	.owner = THIS_MODULE,
 	.open = acpi_button_info_open_fs,
 	.read = seq_read,
 	.llseek = seq_lseek,
@@ -109,6 +110,7 @@ static const struct file_operations acpi_button_info_fops = {
 };
 
 static const struct file_operations acpi_button_state_fops = {
+	.owner = THIS_MODULE,
 	.open = acpi_button_state_open_fs,
 	.read = seq_read,
 	.llseek = seq_lseek,
@@ -207,27 +209,21 @@ static int acpi_button_add_fs(struct acpi_device *device)
 	acpi_device_dir(device)->owner = THIS_MODULE;
 
 	/* 'info' [R] */
-	entry = create_proc_entry(ACPI_BUTTON_FILE_INFO,
-				  S_IRUGO, acpi_device_dir(device));
+	entry = proc_create_data(ACPI_BUTTON_FILE_INFO,
+				 S_IRUGO, acpi_device_dir(device),
+				 &acpi_button_info_fops,
+				 acpi_driver_data(device));
 	if (!entry)
 		return -ENODEV;
-	else {
-		entry->proc_fops = &acpi_button_info_fops;
-		entry->data = acpi_driver_data(device);
-		entry->owner = THIS_MODULE;
-	}
 
 	/* show lid state [R] */
 	if (button->type == ACPI_BUTTON_TYPE_LID) {
-		entry = create_proc_entry(ACPI_BUTTON_FILE_STATE,
-					  S_IRUGO, acpi_device_dir(device));
+		entry = proc_create_data(ACPI_BUTTON_FILE_STATE,
+					 S_IRUGO, acpi_device_dir(device),
+					 &acpi_button_state_fops,
+					 acpi_driver_data(device));
 		if (!entry)
 			return -ENODEV;
-		else {
-			entry->proc_fops = &acpi_button_state_fops;
-			entry->data = acpi_driver_data(device);
-			entry->owner = THIS_MODULE;
-		}
 	}
 
 	return 0;
diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 3d93621..0924992 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -634,16 +634,11 @@ static int acpi_ec_add_fs(struct acpi_device *device)
 			return -ENODEV;
 	}
 
-	entry = create_proc_entry(ACPI_EC_FILE_INFO, S_IRUGO,
-				  acpi_device_dir(device));
+	entry = proc_create_data(ACPI_EC_FILE_INFO, S_IRUGO,
+				 acpi_device_dir(device),
+				 &acpi_ec_info_ops, acpi_driver_data(device));
 	if (!entry)
 		return -ENODEV;
-	else {
-		entry->proc_fops = &acpi_ec_info_ops;
-		entry->data = acpi_driver_data(device);
-		entry->owner = THIS_MODULE;
-	}
-
 	return 0;
 }
 
diff --git a/drivers/acpi/event.c b/drivers/acpi/event.c
index abec1ca..0c24bd4 100644
--- a/drivers/acpi/event.c
+++ b/drivers/acpi/event.c
@@ -102,6 +102,7 @@ static unsigned int acpi_system_poll_event(struct file *file, poll_table * wait)
 }
 
 static const struct file_operations acpi_system_event_ops = {
+	.owner = THIS_MODULE,
 	.open = acpi_system_open_event,
 	.read = acpi_system_read_event,
 	.release = acpi_system_close_event,
@@ -294,10 +295,9 @@ static int __init acpi_event_init(void)
 
 #ifdef CONFIG_ACPI_PROC_EVENT
 	/* 'event' [R] */
-	entry = create_proc_entry("event", S_IRUSR, acpi_root_dir);
-	if (entry)
-		entry->proc_fops = &acpi_system_event_ops;
-	else
+	entry = proc_create("event", S_IRUSR, acpi_root_dir,
+			    &acpi_system_event_ops);
+	if (!entry)
 		return -ENODEV;
 #endif
 
diff --git a/drivers/acpi/fan.c b/drivers/acpi/fan.c
index c8e3cba..194077a 100644
--- a/drivers/acpi/fan.c
+++ b/drivers/acpi/fan.c
@@ -192,17 +192,13 @@ static int acpi_fan_add_fs(struct acpi_device *device)
 	}
 
 	/* 'status' [R/W] */
-	entry = create_proc_entry(ACPI_FAN_FILE_STATE,
-				  S_IFREG | S_IRUGO | S_IWUSR,
-				  acpi_device_dir(device));
+	entry = proc_create_data(ACPI_FAN_FILE_STATE,
+				 S_IFREG | S_IRUGO | S_IWUSR,
+				 acpi_device_dir(device),
+				 &acpi_fan_state_ops,
+				 device);
 	if (!entry)
 		return -ENODEV;
-	else {
-		entry->proc_fops = &acpi_fan_state_ops;
-		entry->data = device;
-		entry->owner = THIS_MODULE;
-	}
-
 	return 0;
 }
 
diff --git a/drivers/acpi/power.c b/drivers/acpi/power.c
index 76bf6d9..21fc8bf 100644
--- a/drivers/acpi/power.c
+++ b/drivers/acpi/power.c
@@ -93,6 +93,7 @@ struct acpi_power_resource {
 static struct list_head acpi_power_resource_list;
 
 static const struct file_operations acpi_power_fops = {
+	.owner = THIS_MODULE,
 	.open = acpi_power_open_fs,
 	.read = seq_read,
 	.llseek = seq_lseek,
@@ -543,15 +544,11 @@ static int acpi_power_add_fs(struct acpi_device *device)
 	}
 
 	/* 'status' [R] */
-	entry = create_proc_entry(ACPI_POWER_FILE_STATUS,
-				  S_IRUGO, acpi_device_dir(device));
+	entry = proc_create_data(ACPI_POWER_FILE_STATUS,
+				 S_IRUGO, acpi_device_dir(device),
+				 &acpi_power_fops, acpi_driver_data(device));
 	if (!entry)
 		return -EIO;
-	else {
-		entry->proc_fops = &acpi_power_fops;
-		entry->data = acpi_driver_data(device);
-	}
-
 	return 0;
 }
 
diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
index 3015330..6e68e3f 100644
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -112,6 +112,7 @@ static struct acpi_driver acpi_processor_driver = {
 #define UNINSTALL_NOTIFY_HANDLER	2
 
 static const struct file_operations acpi_processor_info_fops = {
+	.owner = THIS_MODULE,
 	.open = acpi_processor_info_open_fs,
 	.read = seq_read,
 	.llseek = seq_lseek,
@@ -326,40 +327,30 @@ static int acpi_processor_add_fs(struct acpi_device *device)
 	acpi_device_dir(device)->owner = THIS_MODULE;
 
 	/* 'info' [R] */
-	entry = create_proc_entry(ACPI_PROCESSOR_FILE_INFO,
-				  S_IRUGO, acpi_device_dir(device));
+	entry = proc_create_data(ACPI_PROCESSOR_FILE_INFO,
+				 S_IRUGO, acpi_device_dir(device),
+				 &acpi_processor_info_fops,
+				 acpi_driver_data(device));
 	if (!entry)
 		return -EIO;
-	else {
-		entry->proc_fops = &acpi_processor_info_fops;
-		entry->data = acpi_driver_data(device);
-		entry->owner = THIS_MODULE;
-	}
 
 	/* 'throttling' [R/W] */
-	entry = create_proc_entry(ACPI_PROCESSOR_FILE_THROTTLING,
-				  S_IFREG | S_IRUGO | S_IWUSR,
-				  acpi_device_dir(device));
+	entry = proc_create_data(ACPI_PROCESSOR_FILE_THROTTLING,
+				 S_IFREG | S_IRUGO | S_IWUSR,
+				 acpi_device_dir(device),
+				 &acpi_processor_throttling_fops,
+				 acpi_driver_data(device));
 	if (!entry)
 		return -EIO;
-	else {
-		entry->proc_fops = &acpi_processor_throttling_fops;
-		entry->data = acpi_driver_data(device);
-		entry->owner = THIS_MODULE;
-	}
 
 	/* 'limit' [R/W] */
-	entry = create_proc_entry(ACPI_PROCESSOR_FILE_LIMIT,
-				  S_IFREG | S_IRUGO | S_IWUSR,
-				  acpi_device_dir(device));
+	entry = proc_create_data(ACPI_PROCESSOR_FILE_LIMIT,
+				 S_IFREG | S_IRUGO | S_IWUSR,
+				 acpi_device_dir(device),
+				 &acpi_processor_limit_fops,
+				 acpi_driver_data(device));
 	if (!entry)
 		return -EIO;
-	else {
-		entry->proc_fops = &acpi_processor_limit_fops;
-		entry->data = acpi_driver_data(device);
-		entry->owner = THIS_MODULE;
-	}
-
 	return 0;
 }
 
diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 5f91ad3..b0c8584 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -1302,6 +1302,7 @@ static int acpi_processor_power_open_fs(struct inode *inode, struct file *file)
 }
 
 static const struct file_operations acpi_processor_power_fops = {
+	.owner = THIS_MODULE,
 	.open = acpi_processor_power_open_fs,
 	.read = seq_read,
 	.llseek = seq_lseek,
@@ -1842,16 +1843,12 @@ int __cpuinit acpi_processor_power_init(struct acpi_processor *pr,
 	}
 
 	/* 'power' [R] */
-	entry = create_proc_entry(ACPI_PROCESSOR_FILE_POWER,
-				  S_IRUGO, acpi_device_dir(device));
+	entry = proc_create_data(ACPI_PROCESSOR_FILE_POWER,
+				 S_IRUGO, acpi_device_dir(device),
+				 &acpi_processor_power_fops,
+				 acpi_driver_data(device));
 	if (!entry)
 		return -EIO;
-	else {
-		entry->proc_fops = &acpi_processor_power_fops;
-		entry->data = acpi_driver_data(device);
-		entry->owner = THIS_MODULE;
-	}
-
 	return 0;
 }
 
diff --git a/drivers/acpi/processor_perflib.c b/drivers/acpi/processor_perflib.c
index 3f3ab11..b474996 100644
--- a/drivers/acpi/processor_perflib.c
+++ b/drivers/acpi/processor_perflib.c
@@ -411,6 +411,7 @@ EXPORT_SYMBOL(acpi_processor_notify_smm);
 
 static int acpi_processor_perf_open_fs(struct inode *inode, struct file *file);
 static struct file_operations acpi_processor_perf_fops = {
+	.owner = THIS_MODULE,
 	.open = acpi_processor_perf_open_fs,
 	.read = seq_read,
 	.llseek = seq_lseek,
@@ -456,7 +457,6 @@ static int acpi_processor_perf_open_fs(struct inode *inode, struct file *file)
 
 static void acpi_cpufreq_add_file(struct acpi_processor *pr)
 {
-	struct proc_dir_entry *entry = NULL;
 	struct acpi_device *device = NULL;
 
 
@@ -464,14 +464,9 @@ static void acpi_cpufreq_add_file(struct acpi_processor *pr)
 		return;
 
 	/* add file 'performance' [R/W] */
-	entry = create_proc_entry(ACPI_PROCESSOR_FILE_PERFORMANCE,
-				  S_IFREG | S_IRUGO,
-				  acpi_device_dir(device));
-	if (entry){
-		entry->proc_fops = &acpi_processor_perf_fops;
-		entry->data = acpi_driver_data(device);
-		entry->owner = THIS_MODULE;
-	}
+	proc_create_data(ACPI_PROCESSOR_FILE_PERFORMANCE, S_IFREG | S_IRUGO,
+			 acpi_device_dir(device),
+			 &acpi_processor_perf_fops, acpi_driver_data(device));
 	return;
 }
 
diff --git a/drivers/acpi/processor_thermal.c b/drivers/acpi/processor_thermal.c
index 649ae99..ef34b18 100644
--- a/drivers/acpi/processor_thermal.c
+++ b/drivers/acpi/processor_thermal.c
@@ -509,6 +509,7 @@ static ssize_t acpi_processor_write_limit(struct file * file,
 }
 
 struct file_operations acpi_processor_limit_fops = {
+	.owner = THIS_MODULE,
 	.open = acpi_processor_limit_open_fs,
 	.read = seq_read,
 	.write = acpi_processor_write_limit,
diff --git a/drivers/acpi/processor_throttling.c b/drivers/acpi/processor_throttling.c
index 117cda6..b4cd47c 100644
--- a/drivers/acpi/processor_throttling.c
+++ b/drivers/acpi/processor_throttling.c
@@ -1252,6 +1252,7 @@ static ssize_t acpi_processor_write_throttling(struct file *file,
 }
 
 struct file_operations acpi_processor_throttling_fops = {
+	.owner = THIS_MODULE,
 	.open = acpi_processor_throttling_open_fs,
 	.read = seq_read,
 	.write = acpi_processor_write_throttling,
diff --git a/drivers/acpi/sbs.c b/drivers/acpi/sbs.c
index 585ae3c..10a3651 100644
--- a/drivers/acpi/sbs.c
+++ b/drivers/acpi/sbs.c
@@ -483,8 +483,6 @@ acpi_sbs_add_fs(struct proc_dir_entry **dir,
 		struct file_operations *state_fops,
 		struct file_operations *alarm_fops, void *data)
 {
-	struct proc_dir_entry *entry = NULL;
-
 	if (!*dir) {
 		*dir = proc_mkdir(dir_name, parent_dir);
 		if (!*dir) {
@@ -494,34 +492,19 @@ acpi_sbs_add_fs(struct proc_dir_entry **dir,
 	}
 
 	/* 'info' [R] */
-	if (info_fops) {
-		entry = create_proc_entry(ACPI_SBS_FILE_INFO, S_IRUGO, *dir);
-		if (entry) {
-			entry->proc_fops = info_fops;
-			entry->data = data;
-			entry->owner = THIS_MODULE;
-		}
-	}
+	if (info_fops)
+		proc_create_data(ACPI_SBS_FILE_INFO, S_IRUGO, *dir,
+				 info_fops, data);
 
 	/* 'state' [R] */
-	if (state_fops) {
-		entry = create_proc_entry(ACPI_SBS_FILE_STATE, S_IRUGO, *dir);
-		if (entry) {
-			entry->proc_fops = state_fops;
-			entry->data = data;
-			entry->owner = THIS_MODULE;
-		}
-	}
+	if (state_fops)
+		proc_create_data(ACPI_SBS_FILE_STATE, S_IRUGO, *dir,
+				 state_fops, data);
 
 	/* 'alarm' [R/W] */
-	if (alarm_fops) {
-		entry = create_proc_entry(ACPI_SBS_FILE_ALARM, S_IRUGO, *dir);
-		if (entry) {
-			entry->proc_fops = alarm_fops;
-			entry->data = data;
-			entry->owner = THIS_MODULE;
-		}
-	}
+	if (alarm_fops)
+		proc_create_data(ACPI_SBS_FILE_ALARM, S_IRUGO, *dir,
+				 alarm_fops, data);
 	return 0;
 }
 
diff --git a/drivers/acpi/sleep/proc.c b/drivers/acpi/sleep/proc.c
index f8df521..8a5fe87 100644
--- a/drivers/acpi/sleep/proc.c
+++ b/drivers/acpi/sleep/proc.c
@@ -440,6 +440,7 @@ acpi_system_wakeup_device_open_fs(struct inode *inode, struct file *file)
 }
 
 static const struct file_operations acpi_system_wakeup_device_fops = {
+	.owner = THIS_MODULE,
 	.open = acpi_system_wakeup_device_open_fs,
 	.read = seq_read,
 	.write = acpi_system_write_wakeup_device,
@@ -449,6 +450,7 @@ static const struct file_operations acpi_system_wakeup_device_fops = {
 
 #ifdef	CONFIG_ACPI_PROCFS
 static const struct file_operations acpi_system_sleep_fops = {
+	.owner = THIS_MODULE,
 	.open = acpi_system_sleep_open_fs,
 	.read = seq_read,
 	.write = acpi_system_write_sleep,
@@ -459,6 +461,7 @@ static const struct file_operations acpi_system_sleep_fops = {
 
 #ifdef	HAVE_ACPI_LEGACY_ALARM
 static const struct file_operations acpi_system_alarm_fops = {
+	.owner = THIS_MODULE,
 	.open = acpi_system_alarm_open_fs,
 	.read = seq_read,
 	.write = acpi_system_write_alarm,
@@ -477,37 +480,26 @@ static u32 rtc_handler(void *context)
 
 static int __init acpi_sleep_proc_init(void)
 {
-	struct proc_dir_entry *entry = NULL;
-
 	if (acpi_disabled)
 		return 0;
 
 #ifdef	CONFIG_ACPI_PROCFS
 	/* 'sleep' [R/W] */
-	entry =
-	    create_proc_entry("sleep", S_IFREG | S_IRUGO | S_IWUSR,
-			      acpi_root_dir);
-	if (entry)
-		entry->proc_fops = &acpi_system_sleep_fops;
+	proc_create("sleep", S_IFREG | S_IRUGO | S_IWUSR,
+		    acpi_root_dir, &acpi_system_sleep_fops);
 #endif				/* CONFIG_ACPI_PROCFS */
 
 #ifdef	HAVE_ACPI_LEGACY_ALARM
 	/* 'alarm' [R/W] */
-	entry =
-	    create_proc_entry("alarm", S_IFREG | S_IRUGO | S_IWUSR,
-			      acpi_root_dir);
-	if (entry)
-		entry->proc_fops = &acpi_system_alarm_fops;
+	proc_create("alarm", S_IFREG | S_IRUGO | S_IWUSR,
+		    acpi_root_dir, &acpi_system_alarm_fops);
 
 	acpi_install_fixed_event_handler(ACPI_EVENT_RTC, rtc_handler, NULL);
 #endif				/* HAVE_ACPI_LEGACY_ALARM */
 
 	/* 'wakeup device' [R/W] */
-	entry =
-	    create_proc_entry("wakeup", S_IFREG | S_IRUGO | S_IWUSR,
-			      acpi_root_dir);
-	if (entry)
-		entry->proc_fops = &acpi_system_wakeup_device_fops;
+	proc_create("wakeup", S_IFREG | S_IRUGO | S_IWUSR,
+		    acpi_root_dir, &acpi_system_wakeup_device_fops);
 
 	return 0;
 }
diff --git a/drivers/acpi/system.c b/drivers/acpi/system.c
index 4749f37..769f248 100644
--- a/drivers/acpi/system.c
+++ b/drivers/acpi/system.c
@@ -396,6 +396,7 @@ static int acpi_system_info_open_fs(struct inode *inode, struct file *file)
 }
 
 static const struct file_operations acpi_system_info_ops = {
+	.owner = THIS_MODULE,
 	.open = acpi_system_info_open_fs,
 	.read = seq_read,
 	.llseek = seq_lseek,
@@ -406,6 +407,7 @@ static ssize_t acpi_system_read_dsdt(struct file *, char __user *, size_t,
 				     loff_t *);
 
 static const struct file_operations acpi_system_dsdt_ops = {
+	.owner = THIS_MODULE,
 	.read = acpi_system_read_dsdt,
 };
 
@@ -430,6 +432,7 @@ static ssize_t acpi_system_read_fadt(struct file *, char __user *, size_t,
 				     loff_t *);
 
 static const struct file_operations acpi_system_fadt_ops = {
+	.owner = THIS_MODULE,
 	.read = acpi_system_read_fadt,
 };
 
@@ -454,31 +457,23 @@ static int acpi_system_procfs_init(void)
 {
 	struct proc_dir_entry *entry;
 	int error = 0;
-	char *name;
 
 	/* 'info' [R] */
-	name = ACPI_SYSTEM_FILE_INFO;
-	entry = create_proc_entry(name, S_IRUGO, acpi_root_dir);
+	entry = proc_create(ACPI_SYSTEM_FILE_INFO, S_IRUGO, acpi_root_dir,
+			    &acpi_system_info_ops);
 	if (!entry)
 		goto Error;
-	else {
-		entry->proc_fops = &acpi_system_info_ops;
-	}
 
 	/* 'dsdt' [R] */
-	name = ACPI_SYSTEM_FILE_DSDT;
-	entry = create_proc_entry(name, S_IRUSR, acpi_root_dir);
-	if (entry)
-		entry->proc_fops = &acpi_system_dsdt_ops;
-	else
+	entry = proc_create(ACPI_SYSTEM_FILE_DSDT, S_IRUSR, acpi_root_dir,
+			    &acpi_system_dsdt_ops);
+	if (!entry)
 		goto Error;
 
 	/* 'fadt' [R] */
-	name = ACPI_SYSTEM_FILE_FADT;
-	entry = create_proc_entry(name, S_IRUSR, acpi_root_dir);
-	if (entry)
-		entry->proc_fops = &acpi_system_fadt_ops;
-	else
+	entry = proc_create(ACPI_SYSTEM_FILE_FADT, S_IRUSR, acpi_root_dir,
+			    &acpi_system_fadt_ops);
+	if (!entry)
 		goto Error;
 
       Done:
diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
index 921d0f7..d18c4dd 100644
--- a/drivers/acpi/thermal.c
+++ b/drivers/acpi/thermal.c
@@ -198,6 +198,7 @@ struct acpi_thermal {
 };
 
 static const struct file_operations acpi_thermal_state_fops = {
+	.owner = THIS_MODULE,
 	.open = acpi_thermal_state_open_fs,
 	.read = seq_read,
 	.llseek = seq_lseek,
@@ -205,6 +206,7 @@ static const struct file_operations acpi_thermal_state_fops = {
 };
 
 static const struct file_operations acpi_thermal_temp_fops = {
+	.owner = THIS_MODULE,
 	.open = acpi_thermal_temp_open_fs,
 	.read = seq_read,
 	.llseek = seq_lseek,
@@ -212,6 +214,7 @@ static const struct file_operations acpi_thermal_temp_fops = {
 };
 
 static const struct file_operations acpi_thermal_trip_fops = {
+	.owner = THIS_MODULE,
 	.open = acpi_thermal_trip_open_fs,
 	.read = seq_read,
 	.llseek = seq_lseek,
@@ -219,6 +222,7 @@ static const struct file_operations acpi_thermal_trip_fops = {
 };
 
 static const struct file_operations acpi_thermal_cooling_fops = {
+	.owner = THIS_MODULE,
 	.open = acpi_thermal_cooling_open_fs,
 	.read = seq_read,
 	.write = acpi_thermal_write_cooling_mode,
@@ -227,6 +231,7 @@ static const struct file_operations acpi_thermal_cooling_fops = {
 };
 
 static const struct file_operations acpi_thermal_polling_fops = {
+	.owner = THIS_MODULE,
 	.open = acpi_thermal_polling_open_fs,
 	.read = seq_read,
 	.write = acpi_thermal_write_polling,
@@ -1419,63 +1424,47 @@ static int acpi_thermal_add_fs(struct acpi_device *device)
 	}
 
 	/* 'state' [R] */
-	entry = create_proc_entry(ACPI_THERMAL_FILE_STATE,
-				  S_IRUGO, acpi_device_dir(device));
+	entry = proc_create_data(ACPI_THERMAL_FILE_STATE,
+				 S_IRUGO, acpi_device_dir(device),
+				 &acpi_thermal_state_fops,
+				 acpi_driver_data(device));
 	if (!entry)
 		return -ENODEV;
-	else {
-		entry->proc_fops = &acpi_thermal_state_fops;
-		entry->data = acpi_driver_data(device);
-		entry->owner = THIS_MODULE;
-	}
 
 	/* 'temperature' [R] */
-	entry = create_proc_entry(ACPI_THERMAL_FILE_TEMPERATURE,
-				  S_IRUGO, acpi_device_dir(device));
+	entry = proc_create_data(ACPI_THERMAL_FILE_TEMPERATURE,
+				 S_IRUGO, acpi_device_dir(device),
+				 &acpi_thermal_temp_fops,
+				 acpi_driver_data(device));
 	if (!entry)
 		return -ENODEV;
-	else {
-		entry->proc_fops = &acpi_thermal_temp_fops;
-		entry->data = acpi_driver_data(device);
-		entry->owner = THIS_MODULE;
-	}
 
 	/* 'trip_points' [R] */
-	entry = create_proc_entry(ACPI_THERMAL_FILE_TRIP_POINTS,
-				  S_IRUGO,
-				  acpi_device_dir(device));
+	entry = proc_create_data(ACPI_THERMAL_FILE_TRIP_POINTS,
+				 S_IRUGO,
+				 acpi_device_dir(device),
+				 &acpi_thermal_trip_fops,
+				 acpi_driver_data(device));
 	if (!entry)
 		return -ENODEV;
-	else {
-		entry->proc_fops = &acpi_thermal_trip_fops;
-		entry->data = acpi_driver_data(device);
-		entry->owner = THIS_MODULE;
-	}
 
 	/* 'cooling_mode' [R/W] */
-	entry = create_proc_entry(ACPI_THERMAL_FILE_COOLING_MODE,
-				  S_IFREG | S_IRUGO | S_IWUSR,
-				  acpi_device_dir(device));
+	entry = proc_create_data(ACPI_THERMAL_FILE_COOLING_MODE,
+				 S_IFREG | S_IRUGO | S_IWUSR,
+				 acpi_device_dir(device),
+				 &acpi_thermal_cooling_fops,
+				 acpi_driver_data(device));
 	if (!entry)
 		return -ENODEV;
-	else {
-		entry->proc_fops = &acpi_thermal_cooling_fops;
-		entry->data = acpi_driver_data(device);
-		entry->owner = THIS_MODULE;
-	}
 
 	/* 'polling_frequency' [R/W] */
-	entry = create_proc_entry(ACPI_THERMAL_FILE_POLLING_FREQ,
-				  S_IFREG | S_IRUGO | S_IWUSR,
-				  acpi_device_dir(device));
+	entry = proc_create_data(ACPI_THERMAL_FILE_POLLING_FREQ,
+				 S_IFREG | S_IRUGO | S_IWUSR,
+				 acpi_device_dir(device),
+				 &acpi_thermal_polling_fops,
+				 acpi_driver_data(device));
 	if (!entry)
 		return -ENODEV;
-	else {
-		entry->proc_fops = &acpi_thermal_polling_fops;
-		entry->data = acpi_driver_data(device);
-		entry->owner = THIS_MODULE;
-	}
-
 	return 0;
 }
 
diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index 12fb44f..0fc952d 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -192,6 +192,7 @@ struct acpi_video_device {
 /* bus */
 static int acpi_video_bus_info_open_fs(struct inode *inode, struct file *file);
 static struct file_operations acpi_video_bus_info_fops = {
+	.owner = THIS_MODULE,
 	.open = acpi_video_bus_info_open_fs,
 	.read = seq_read,
 	.llseek = seq_lseek,
@@ -200,6 +201,7 @@ static struct file_operations acpi_video_bus_info_fops = {
 
 static int acpi_video_bus_ROM_open_fs(struct inode *inode, struct file *file);
 static struct file_operations acpi_video_bus_ROM_fops = {
+	.owner = THIS_MODULE,
 	.open = acpi_video_bus_ROM_open_fs,
 	.read = seq_read,
 	.llseek = seq_lseek,
@@ -209,6 +211,7 @@ static struct file_operations acpi_video_bus_ROM_fops = {
 static int acpi_video_bus_POST_info_open_fs(struct inode *inode,
 					    struct file *file);
 static struct file_operations acpi_video_bus_POST_info_fops = {
+	.owner = THIS_MODULE,
 	.open = acpi_video_bus_POST_info_open_fs,
 	.read = seq_read,
 	.llseek = seq_lseek,
@@ -217,6 +220,7 @@ static struct file_operations acpi_video_bus_POST_info_fops = {
 
 static int acpi_video_bus_POST_open_fs(struct inode *inode, struct file *file);
 static struct file_operations acpi_video_bus_POST_fops = {
+	.owner = THIS_MODULE,
 	.open = acpi_video_bus_POST_open_fs,
 	.read = seq_read,
 	.llseek = seq_lseek,
@@ -225,6 +229,7 @@ static struct file_operations acpi_video_bus_POST_fops = {
 
 static int acpi_video_bus_DOS_open_fs(struct inode *inode, struct file *file);
 static struct file_operations acpi_video_bus_DOS_fops = {
+	.owner = THIS_MODULE,
 	.open = acpi_video_bus_DOS_open_fs,
 	.read = seq_read,
 	.llseek = seq_lseek,
@@ -235,6 +240,7 @@ static struct file_operations acpi_video_bus_DOS_fops = {
 static int acpi_video_device_info_open_fs(struct inode *inode,
 					  struct file *file);
 static struct file_operations acpi_video_device_info_fops = {
+	.owner = THIS_MODULE,
 	.open = acpi_video_device_info_open_fs,
 	.read = seq_read,
 	.llseek = seq_lseek,
@@ -244,6 +250,7 @@ static struct file_operations acpi_video_device_info_fops = {
 static int acpi_video_device_state_open_fs(struct inode *inode,
 					   struct file *file);
 static struct file_operations acpi_video_device_state_fops = {
+	.owner = THIS_MODULE,
 	.open = acpi_video_device_state_open_fs,
 	.read = seq_read,
 	.llseek = seq_lseek,
@@ -253,6 +260,7 @@ static struct file_operations acpi_video_device_state_fops = {
 static int acpi_video_device_brightness_open_fs(struct inode *inode,
 						struct file *file);
 static struct file_operations acpi_video_device_brightness_fops = {
+	.owner = THIS_MODULE,
 	.open = acpi_video_device_brightness_open_fs,
 	.read = seq_read,
 	.llseek = seq_lseek,
@@ -262,6 +270,7 @@ static struct file_operations acpi_video_device_brightness_fops = {
 static int acpi_video_device_EDID_open_fs(struct inode *inode,
 					  struct file *file);
 static struct file_operations acpi_video_device_EDID_fops = {
+	.owner = THIS_MODULE,
 	.open = acpi_video_device_EDID_open_fs,
 	.read = seq_read,
 	.llseek = seq_lseek,
@@ -1070,51 +1079,36 @@ static int acpi_video_device_add_fs(struct acpi_device *device)
 	}
 
 	/* 'info' [R] */
-	entry = create_proc_entry("info", S_IRUGO, acpi_device_dir(device));
+	entry = proc_create_data("info", S_IRUGO, acpi_device_dir(device),
+			&acpi_video_device_info_fops, acpi_driver_data(device));
 	if (!entry)
 		return -ENODEV;
-	else {
-		entry->proc_fops = &acpi_video_device_info_fops;
-		entry->data = acpi_driver_data(device);
-		entry->owner = THIS_MODULE;
-	}
 
 	/* 'state' [R/W] */
-	entry =
-	    create_proc_entry("state", S_IFREG | S_IRUGO | S_IWUSR,
-			      acpi_device_dir(device));
+	acpi_video_device_state_fops.write = acpi_video_device_write_state;
+	entry = proc_create_data("state", S_IFREG | S_IRUGO | S_IWUSR,
+				 acpi_device_dir(device),
+				 &acpi_video_device_state_fops,
+				 acpi_driver_data(device));
 	if (!entry)
 		return -ENODEV;
-	else {
-		acpi_video_device_state_fops.write = acpi_video_device_write_state;
-		entry->proc_fops = &acpi_video_device_state_fops;
-		entry->data = acpi_driver_data(device);
-		entry->owner = THIS_MODULE;
-	}
 
 	/* 'brightness' [R/W] */
-	entry =
-	    create_proc_entry("brightness", S_IFREG | S_IRUGO | S_IWUSR,
-			      acpi_device_dir(device));
+	acpi_video_device_brightness_fops.write =
+		acpi_video_device_write_brightness;
+	entry = proc_create_data("brightness", S_IFREG | S_IRUGO | S_IWUSR,
+				 acpi_device_dir(device),
+				 &acpi_video_device_brightness_fops,
+				 acpi_driver_data(device));
 	if (!entry)
 		return -ENODEV;
-	else {
-		acpi_video_device_brightness_fops.write = acpi_video_device_write_brightness;
-		entry->proc_fops = &acpi_video_device_brightness_fops;
-		entry->data = acpi_driver_data(device);
-		entry->owner = THIS_MODULE;
-	}
 
 	/* 'EDID' [R] */
-	entry = create_proc_entry("EDID", S_IRUGO, acpi_device_dir(device));
+	entry = proc_create_data("EDID", S_IRUGO, acpi_device_dir(device),
+				 &acpi_video_device_EDID_fops,
+				 acpi_driver_data(device));
 	if (!entry)
 		return -ENODEV;
-	else {
-		entry->proc_fops = &acpi_video_device_EDID_fops;
-		entry->data = acpi_driver_data(device);
-		entry->owner = THIS_MODULE;
-	}
-
 	return 0;
 }
 
@@ -1353,61 +1347,43 @@ static int acpi_video_bus_add_fs(struct acpi_device *device)
 	}
 
 	/* 'info' [R] */
-	entry = create_proc_entry("info", S_IRUGO, acpi_device_dir(device));
+	entry = proc_create_data("info", S_IRUGO, acpi_device_dir(device),
+				 &acpi_video_bus_info_fops,
+				 acpi_driver_data(device));
 	if (!entry)
 		return -ENODEV;
-	else {
-		entry->proc_fops = &acpi_video_bus_info_fops;
-		entry->data = acpi_driver_data(device);
-		entry->owner = THIS_MODULE;
-	}
 
 	/* 'ROM' [R] */
-	entry = create_proc_entry("ROM", S_IRUGO, acpi_device_dir(device));
+	entry = proc_create_data("ROM", S_IRUGO, acpi_device_dir(device),
+				 &acpi_video_bus_ROM_fops,
+				 acpi_driver_data(device));
 	if (!entry)
 		return -ENODEV;
-	else {
-		entry->proc_fops = &acpi_video_bus_ROM_fops;
-		entry->data = acpi_driver_data(device);
-		entry->owner = THIS_MODULE;
-	}
 
 	/* 'POST_info' [R] */
-	entry =
-	    create_proc_entry("POST_info", S_IRUGO, acpi_device_dir(device));
+	entry = proc_create_data("POST_info", S_IRUGO, acpi_device_dir(device),
+				 &acpi_video_bus_POST_info_fops,
+				 acpi_driver_data(device));
 	if (!entry)
 		return -ENODEV;
-	else {
-		entry->proc_fops = &acpi_video_bus_POST_info_fops;
-		entry->data = acpi_driver_data(device);
-		entry->owner = THIS_MODULE;
-	}
 
 	/* 'POST' [R/W] */
-	entry =
-	    create_proc_entry("POST", S_IFREG | S_IRUGO | S_IRUSR,
-			      acpi_device_dir(device));
+	acpi_video_bus_POST_fops.write = acpi_video_bus_write_POST;
+	entry = proc_create_data("POST", S_IFREG | S_IRUGO | S_IRUSR,
+				 acpi_device_dir(device),
+				 &acpi_video_bus_POST_fops,
+				 acpi_driver_data(device));
 	if (!entry)
 		return -ENODEV;
-	else {
-		acpi_video_bus_POST_fops.write = acpi_video_bus_write_POST;
-		entry->proc_fops = &acpi_video_bus_POST_fops;
-		entry->data = acpi_driver_data(device);
-		entry->owner = THIS_MODULE;
-	}
 
 	/* 'DOS' [R/W] */
-	entry =
-	    create_proc_entry("DOS", S_IFREG | S_IRUGO | S_IRUSR,
-			      acpi_device_dir(device));
+	acpi_video_bus_DOS_fops.write = acpi_video_bus_write_DOS;
+	entry = proc_create_data("DOS", S_IFREG | S_IRUGO | S_IRUSR,
+				 acpi_device_dir(device),
+				 &acpi_video_bus_DOS_fops,
+				 acpi_driver_data(device));
 	if (!entry)
 		return -ENODEV;
-	else {
-		acpi_video_bus_DOS_fops.write = acpi_video_bus_write_DOS;
-		entry->proc_fops = &acpi_video_bus_DOS_fops;
-		entry->data = acpi_driver_data(device);
-		entry->owner = THIS_MODULE;
-	}
 
 	return 0;
 }
-- 
1.5.3.rc5

