Return-Path: <linux-kernel-owner+w=401wt.eu-S1759320AbXGLI6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759320AbXGLI6S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 04:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751569AbXGLI6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 04:58:06 -0400
Received: from server78.greatnet.de ([83.133.96.102]:40324 "EHLO
	server78.greatnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbXGLI6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 04:58:04 -0400
Message-ID: <4695ED3F.7020303@nachtwindheim.de>
Date: Thu, 12 Jul 2007 10:58:39 +0200
From: Henne <henne@nachtwindheim.de>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: len.brown@intel.com
CC: linux-acpi@vger.kernel.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH][ACPI][BUTTON] remove procfs-interface
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Removes the proc_fs interface from the ACPI button driver.
Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>

---

 Documentation/feature-removal-schedule.txt |    8 -
 drivers/acpi/button.c                      |  195 -----------------------------
 2 files changed, 2 insertions(+), 201 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 3a159da..a33354b 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -240,14 +240,6 @@ Who:	Zhang Rui <rui.zhang@intel.com>
 
 ---------------------------
 
-What:	/proc/acpi/button
-When:	August 2007
-Why:	/proc/acpi/button has been replaced by events to the input layer
-	since 2.6.20.
-Who:	Len Brown <len.brown@intel.com>
-
----------------------------
-
 What:	Compaq touchscreen device emulation
 When:	Oct 2007
 Files:	drivers/input/tsdev.c
diff --git a/drivers/acpi/button.c b/drivers/acpi/button.c
index cb4110b..574041b 100644
--- a/drivers/acpi/button.c
+++ b/drivers/acpi/button.c
@@ -27,17 +27,11 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/types.h>
-#include <linux/proc_fs.h>
-#include <linux/seq_file.h>
 #include <linux/input.h>
 #include <acpi/acpi_bus.h>
 #include <acpi/acpi_drivers.h>
 
-#define ACPI_BUTTON_COMPONENT		0x00080000
 #define ACPI_BUTTON_CLASS		"button"
-#define ACPI_BUTTON_FILE_INFO		"info"
-#define ACPI_BUTTON_FILE_STATE		"state"
-#define ACPI_BUTTON_TYPE_UNKNOWN	0x00
 #define ACPI_BUTTON_NOTIFY_STATUS	0x80
 
 #define ACPI_BUTTON_SUBCLASS_POWER	"power"
@@ -59,7 +53,6 @@
 #define ACPI_BUTTON_DEVICE_NAME_LID	"Lid Switch"
 #define ACPI_BUTTON_TYPE_LID		0x05
 
-#define _COMPONENT		ACPI_BUTTON_COMPONENT
 ACPI_MODULE_NAME("button");
 
 MODULE_AUTHOR("Paul Diefenbaugh");
@@ -68,8 +61,6 @@ MODULE_LICENSE("GPL");
 
 static int acpi_button_add(struct acpi_device *device);
 static int acpi_button_remove(struct acpi_device *device, int type);
-static int acpi_button_info_open_fs(struct inode *inode, struct file *file);
-static int acpi_button_state_open_fs(struct inode *inode, struct file *file);
 
 static struct acpi_driver acpi_button_driver = {
 	.name = "button",
@@ -89,161 +80,6 @@ struct acpi_button {
 	unsigned long pushed;
 };
 
-static const struct file_operations acpi_button_info_fops = {
-	.open = acpi_button_info_open_fs,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
-};
-
-static const struct file_operations acpi_button_state_fops = {
-	.open = acpi_button_state_open_fs,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
-};
-
-/* --------------------------------------------------------------------------
-                              FS Interface (/proc)
-   -------------------------------------------------------------------------- */
-
-static struct proc_dir_entry *acpi_button_dir;
-
-static int acpi_button_info_seq_show(struct seq_file *seq, void *offset)
-{
-	struct acpi_button *button = seq->private;
-
-	if (!button || !button->device)
-		return 0;
-
-	seq_printf(seq, "type:                    %s\n",
-		   acpi_device_name(button->device));
-
-	return 0;
-}
-
-static int acpi_button_info_open_fs(struct inode *inode, struct file *file)
-{
-	return single_open(file, acpi_button_info_seq_show, PDE(inode)->data);
-}
-
-static int acpi_button_state_seq_show(struct seq_file *seq, void *offset)
-{
-	struct acpi_button *button = seq->private;
-	acpi_status status;
-	unsigned long state;
-
-	if (!button || !button->device)
-		return 0;
-
-	status = acpi_evaluate_integer(button->device->handle, "_LID", NULL, &state);
-	seq_printf(seq, "state:      %s\n",
-		   ACPI_FAILURE(status) ? "unsupported" :
-			(state ? "open" : "closed"));
-	return 0;
-}
-
-static int acpi_button_state_open_fs(struct inode *inode, struct file *file)
-{
-	return single_open(file, acpi_button_state_seq_show, PDE(inode)->data);
-}
-
-static struct proc_dir_entry *acpi_power_dir;
-static struct proc_dir_entry *acpi_sleep_dir;
-static struct proc_dir_entry *acpi_lid_dir;
-
-static int acpi_button_add_fs(struct acpi_device *device)
-{
-	struct proc_dir_entry *entry = NULL;
-	struct acpi_button *button;
-
-	if (!device || !acpi_driver_data(device))
-		return -EINVAL;
-
-	button = acpi_driver_data(device);
-
-	switch (button->type) {
-	case ACPI_BUTTON_TYPE_POWER:
-	case ACPI_BUTTON_TYPE_POWERF:
-		if (!acpi_power_dir)
-			acpi_power_dir = proc_mkdir(ACPI_BUTTON_SUBCLASS_POWER,
-						    acpi_button_dir);
-		entry = acpi_power_dir;
-		break;
-	case ACPI_BUTTON_TYPE_SLEEP:
-	case ACPI_BUTTON_TYPE_SLEEPF:
-		if (!acpi_sleep_dir)
-			acpi_sleep_dir = proc_mkdir(ACPI_BUTTON_SUBCLASS_SLEEP,
-						    acpi_button_dir);
-		entry = acpi_sleep_dir;
-		break;
-	case ACPI_BUTTON_TYPE_LID:
-		if (!acpi_lid_dir)
-			acpi_lid_dir = proc_mkdir(ACPI_BUTTON_SUBCLASS_LID,
-						  acpi_button_dir);
-		entry = acpi_lid_dir;
-		break;
-	}
-
-	if (!entry)
-		return -ENODEV;
-	entry->owner = THIS_MODULE;
-
-	acpi_device_dir(device) = proc_mkdir(acpi_device_bid(device), entry);
-	if (!acpi_device_dir(device))
-		return -ENODEV;
-	acpi_device_dir(device)->owner = THIS_MODULE;
-
-	/* 'info' [R] */
-	entry = create_proc_entry(ACPI_BUTTON_FILE_INFO,
-				  S_IRUGO, acpi_device_dir(device));
-	if (!entry)
-		return -ENODEV;
-	else {
-		entry->proc_fops = &acpi_button_info_fops;
-		entry->data = acpi_driver_data(device);
-		entry->owner = THIS_MODULE;
-	}
-
-	/* show lid state [R] */
-	if (button->type == ACPI_BUTTON_TYPE_LID) {
-		entry = create_proc_entry(ACPI_BUTTON_FILE_STATE,
-					  S_IRUGO, acpi_device_dir(device));
-		if (!entry)
-			return -ENODEV;
-		else {
-			entry->proc_fops = &acpi_button_state_fops;
-			entry->data = acpi_driver_data(device);
-			entry->owner = THIS_MODULE;
-		}
-	}
-
-	return 0;
-}
-
-static int acpi_button_remove_fs(struct acpi_device *device)
-{
-	struct acpi_button *button = acpi_driver_data(device);
-
-	if (acpi_device_dir(device)) {
-		if (button->type == ACPI_BUTTON_TYPE_LID)
-			remove_proc_entry(ACPI_BUTTON_FILE_STATE,
-					  acpi_device_dir(device));
-		remove_proc_entry(ACPI_BUTTON_FILE_INFO,
-				  acpi_device_dir(device));
-
-		remove_proc_entry(acpi_device_bid(device),
-				  acpi_device_dir(device)->parent);
-		acpi_device_dir(device) = NULL;
-	}
-
-	return 0;
-}
-
-/* --------------------------------------------------------------------------
-                                Driver Interface
-   -------------------------------------------------------------------------- */
-
 static void acpi_button_notify(acpi_handle handle, u32 event, void *data)
 {
 	struct acpi_button *button = data;
@@ -405,13 +241,9 @@ static int acpi_button_add(struct acpi_d
 		goto err_free_input;
 	}
 
-	error = acpi_button_add_fs(device);
-	if (error)
-		goto err_free_input;
-
 	error = acpi_button_install_notify_handlers(button);
 	if (error)
-		goto err_remove_fs;
+		goto err_free_input;
 
 	snprintf(button->phys, sizeof(button->phys),
 		 "%s/button/input0", acpi_device_hid(device));
@@ -461,8 +293,6 @@ static int acpi_button_add(struct acpi_d
 
  err_remove_handlers:
 	acpi_button_remove_notify_handlers(button);
- err_remove_fs:
-	acpi_button_remove_fs(device);
  err_free_input:
 	input_free_device(input);
  err_free_button:
@@ -480,7 +310,6 @@ static int acpi_button_remove(struct acp
 	button = acpi_driver_data(device);
 
 	acpi_button_remove_notify_handlers(button);
-	acpi_button_remove_fs(device);
 	input_unregister_device(button->input);
 	kfree(button);
 
@@ -489,32 +318,12 @@ static int acpi_button_remove(struct acp
 
 static int __init acpi_button_init(void)
 {
-	int result;
-
-	acpi_button_dir = proc_mkdir(ACPI_BUTTON_CLASS, acpi_root_dir);
-	if (!acpi_button_dir)
-		return -ENODEV;
-	acpi_button_dir->owner = THIS_MODULE;
-	result = acpi_bus_register_driver(&acpi_button_driver);
-	if (result < 0) {
-		remove_proc_entry(ACPI_BUTTON_CLASS, acpi_root_dir);
-		return -ENODEV;
-	}
-
-	return 0;
+	return acpi_bus_register_driver(&acpi_button_driver);
 }
 
 static void __exit acpi_button_exit(void)
 {
 	acpi_bus_unregister_driver(&acpi_button_driver);
-
-	if (acpi_power_dir)
-		remove_proc_entry(ACPI_BUTTON_SUBCLASS_POWER, acpi_button_dir);
-	if (acpi_sleep_dir)
-		remove_proc_entry(ACPI_BUTTON_SUBCLASS_SLEEP, acpi_button_dir);
-	if (acpi_lid_dir)
-		remove_proc_entry(ACPI_BUTTON_SUBCLASS_LID, acpi_button_dir);
-	remove_proc_entry(ACPI_BUTTON_CLASS, acpi_root_dir);
 }
 
 module_init(acpi_button_init);


