Return-Path: <linux-kernel-owner+w=401wt.eu-S1756126AbZGIUZg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126AbZGIUZg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 16:25:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754125AbZGIUZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 16:25:27 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:30668 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993AbZGIUZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 16:25:25 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: "Stephen J. Gowdy" <gowdy@cern.ch>
Subject: [Bug 13751] 2.6.30 oops with acpi/button
Date: Thu, 9 Jul 2009 14:25:07 -0600
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       bugme-daemon@bugzilla.kernel.org, Matthew Garrett <mjg@redhat.com>
References: <alpine.LRH.2.00.0907090806560.5445@localhost.localdomain>
In-Reply-To: <alpine.LRH.2.00.0907090806560.5445@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_kIlVKvjU7Kr0ZWB"
Message-Id: <200907091425.08119.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_kIlVKvjU7Kr0ZWB
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

>  	I've not had time to go back to it but with 2.6.30 I get an oops 
> when I close the lid on my HP Compaq 6910p laptop.

I opened this bugzilla for the oops:
  http://bugzilla.kernel.org/show_bug.cgi?id=13751

Other reports that may be related:
  http://lkml.indiana.edu/hypermail/linux/kernel/0906.2/02139.html
  https://bugs.launchpad.net/ubuntu/hardy/+source/hotkey-setup/+bug/157691

I see floundering and workarounds in the reports above, but no
real solution yet.

The oops is a page fault on the IP, which means we branched into
the weeds, possibly by following a bad function pointer:

  BUG: unable to handle kernel paging request at ffff88007f223c30
  IP: [<ffff88007f223c30>] 0xffff88007f223c30

One possible cause is a module that doesn't clean up properly
when it is unloaded.  Can you reproduce the problem with
CONFIG_MODULE_UNLOAD turned off?

I doubt this is a button driver problem, but attached is a patch that
reverts the driver to the 2.6.29 version.  Can you try it out?

Bjorn

--Boundary-00=_kIlVKvjU7Kr0ZWB
Content-Type: text/x-diff;
  charset="iso 8859-15";
  name="button.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="button.patch"

commit e82e0de17d168f1352da986053943e98aa41a47a
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Thu Jul 9 09:45:38 2009 -0600

diff --git a/drivers/acpi/button.c b/drivers/acpi/button.c
index 9195deb..c2f0606 100644
--- a/drivers/acpi/button.c
+++ b/drivers/acpi/button.c
@@ -1,5 +1,5 @@
 /*
- *  button.c - ACPI Button Driver
+ *  acpi_button.c - ACPI Button Driver ($Revision: 30 $)
  *
  *  Copyright (C) 2001, 2002 Andy Grover <andrew.grover@intel.com>
  *  Copyright (C) 2001, 2002 Paul Diefenbaugh <paul.s.diefenbaugh@intel.com>
@@ -41,13 +41,17 @@
 
 #define ACPI_BUTTON_SUBCLASS_POWER	"power"
 #define ACPI_BUTTON_HID_POWER		"PNP0C0C"
-#define ACPI_BUTTON_DEVICE_NAME_POWER	"Power Button"
+#define ACPI_BUTTON_DEVICE_NAME_POWER	"Power Button (CM)"
+#define ACPI_BUTTON_DEVICE_NAME_POWERF	"Power Button (FF)"
 #define ACPI_BUTTON_TYPE_POWER		0x01
+#define ACPI_BUTTON_TYPE_POWERF		0x02
 
 #define ACPI_BUTTON_SUBCLASS_SLEEP	"sleep"
 #define ACPI_BUTTON_HID_SLEEP		"PNP0C0E"
-#define ACPI_BUTTON_DEVICE_NAME_SLEEP	"Sleep Button"
+#define ACPI_BUTTON_DEVICE_NAME_SLEEP	"Sleep Button (CM)"
+#define ACPI_BUTTON_DEVICE_NAME_SLEEPF	"Sleep Button (FF)"
 #define ACPI_BUTTON_TYPE_SLEEP		0x03
+#define ACPI_BUTTON_TYPE_SLEEPF		0x04
 
 #define ACPI_BUTTON_SUBCLASS_LID	"lid"
 #define ACPI_BUTTON_HID_LID		"PNP0C0D"
@@ -74,7 +78,6 @@ MODULE_DEVICE_TABLE(acpi, button_device_ids);
 static int acpi_button_add(struct acpi_device *device);
 static int acpi_button_remove(struct acpi_device *device, int type);
 static int acpi_button_resume(struct acpi_device *device);
-static void acpi_button_notify(struct acpi_device *device, u32 event);
 static int acpi_button_info_open_fs(struct inode *inode, struct file *file);
 static int acpi_button_state_open_fs(struct inode *inode, struct file *file);
 
@@ -86,11 +89,11 @@ static struct acpi_driver acpi_button_driver = {
 		.add = acpi_button_add,
 		.resume = acpi_button_resume,
 		.remove = acpi_button_remove,
-		.notify = acpi_button_notify,
 	},
 };
 
 struct acpi_button {
+	struct acpi_device *device;	/* Fixed button kludge */
 	unsigned int type;
 	struct input_dev *input;
 	char phys[32];			/* for input device */
@@ -121,10 +124,14 @@ static struct proc_dir_entry *acpi_button_dir;
 
 static int acpi_button_info_seq_show(struct seq_file *seq, void *offset)
 {
-	struct acpi_device *device = seq->private;
+	struct acpi_button *button = seq->private;
+
+	if (!button || !button->device)
+		return 0;
 
 	seq_printf(seq, "type:                    %s\n",
-		   acpi_device_name(device));
+		   acpi_device_name(button->device));
+
 	return 0;
 }
 
@@ -135,11 +142,14 @@ static int acpi_button_info_open_fs(struct inode *inode, struct file *file)
 
 static int acpi_button_state_seq_show(struct seq_file *seq, void *offset)
 {
-	struct acpi_device *device = seq->private;
+	struct acpi_button *button = seq->private;
 	acpi_status status;
 	unsigned long long state;
 
-	status = acpi_evaluate_integer(device->handle, "_LID", NULL, &state);
+	if (!button || !button->device)
+		return 0;
+
+	status = acpi_evaluate_integer(button->device->handle, "_LID", NULL, &state);
 	seq_printf(seq, "state:      %s\n",
 		   ACPI_FAILURE(status) ? "unsupported" :
 			(state ? "open" : "closed"));
@@ -157,17 +167,24 @@ static struct proc_dir_entry *acpi_lid_dir;
 
 static int acpi_button_add_fs(struct acpi_device *device)
 {
-	struct acpi_button *button = acpi_driver_data(device);
 	struct proc_dir_entry *entry = NULL;
+	struct acpi_button *button;
+
+	if (!device || !acpi_driver_data(device))
+		return -EINVAL;
+
+	button = acpi_driver_data(device);
 
 	switch (button->type) {
 	case ACPI_BUTTON_TYPE_POWER:
+	case ACPI_BUTTON_TYPE_POWERF:
 		if (!acpi_power_dir)
 			acpi_power_dir = proc_mkdir(ACPI_BUTTON_SUBCLASS_POWER,
 						    acpi_button_dir);
 		entry = acpi_power_dir;
 		break;
 	case ACPI_BUTTON_TYPE_SLEEP:
+	case ACPI_BUTTON_TYPE_SLEEPF:
 		if (!acpi_sleep_dir)
 			acpi_sleep_dir = proc_mkdir(ACPI_BUTTON_SUBCLASS_SLEEP,
 						    acpi_button_dir);
@@ -191,7 +208,8 @@ static int acpi_button_add_fs(struct acpi_device *device)
 	/* 'info' [R] */
 	entry = proc_create_data(ACPI_BUTTON_FILE_INFO,
 				 S_IRUGO, acpi_device_dir(device),
-				 &acpi_button_info_fops, device);
+				 &acpi_button_info_fops,
+				 acpi_driver_data(device));
 	if (!entry)
 		return -ENODEV;
 
@@ -199,7 +217,8 @@ static int acpi_button_add_fs(struct acpi_device *device)
 	if (button->type == ACPI_BUTTON_TYPE_LID) {
 		entry = proc_create_data(ACPI_BUTTON_FILE_STATE,
 					 S_IRUGO, acpi_device_dir(device),
-					 &acpi_button_state_fops, device);
+					 &acpi_button_state_fops,
+					 acpi_driver_data(device));
 		if (!entry)
 			return -ENODEV;
 	}
@@ -229,35 +248,34 @@ static int acpi_button_remove_fs(struct acpi_device *device)
 /* --------------------------------------------------------------------------
                                 Driver Interface
    -------------------------------------------------------------------------- */
-static int acpi_lid_send_state(struct acpi_device *device)
+static int acpi_lid_send_state(struct acpi_button *button)
 {
-	struct acpi_button *button = acpi_driver_data(device);
 	unsigned long long state;
 	acpi_status status;
 
-	status = acpi_evaluate_integer(device->handle, "_LID", NULL, &state);
+	status = acpi_evaluate_integer(button->device->handle, "_LID", NULL,
+					&state);
 	if (ACPI_FAILURE(status))
 		return -ENODEV;
-
 	/* input layer checks if event is redundant */
 	input_report_switch(button->input, SW_LID, !state);
 	input_sync(button->input);
 	return 0;
 }
 
-static void acpi_button_notify(struct acpi_device *device, u32 event)
+static void acpi_button_notify(acpi_handle handle, u32 event, void *data)
 {
-	struct acpi_button *button = acpi_driver_data(device);
+	struct acpi_button *button = data;
 	struct input_dev *input;
 
+	if (!button || !button->device)
+		return;
+
 	switch (event) {
-	case ACPI_FIXED_HARDWARE_EVENT:
-		event = ACPI_BUTTON_NOTIFY_STATUS;
-		/* fall through */
 	case ACPI_BUTTON_NOTIFY_STATUS:
 		input = button->input;
 		if (button->type == ACPI_BUTTON_TYPE_LID) {
-			acpi_lid_send_state(device);
+			acpi_lid_send_state(button);
 		} else {
 			int keycode = test_bit(KEY_SLEEP, input->keybit) ?
 						KEY_SLEEP : KEY_POWER;
@@ -268,35 +286,102 @@ static void acpi_button_notify(struct acpi_device *device, u32 event)
 			input_sync(input);
 		}
 
-		acpi_bus_generate_proc_event(device, event, ++button->pushed);
+		acpi_bus_generate_proc_event(button->device, event,
+					++button->pushed);
 		break;
 	default:
 		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
 				  "Unsupported event [0x%x]\n", event));
 		break;
 	}
+
+	return;
 }
 
-static int acpi_button_resume(struct acpi_device *device)
+static acpi_status acpi_button_notify_fixed(void *data)
 {
-	struct acpi_button *button = acpi_driver_data(device);
+	struct acpi_button *button = data;
 
-	if (button->type == ACPI_BUTTON_TYPE_LID)
-		return acpi_lid_send_state(device);
+	if (!button)
+		return AE_BAD_PARAMETER;
+
+	acpi_button_notify(button->device->handle, ACPI_BUTTON_NOTIFY_STATUS, button);
+
+	return AE_OK;
+}
+
+static int acpi_button_install_notify_handlers(struct acpi_button *button)
+{
+	acpi_status status;
+
+	switch (button->type) {
+	case ACPI_BUTTON_TYPE_POWERF:
+		status =
+		    acpi_install_fixed_event_handler(ACPI_EVENT_POWER_BUTTON,
+						     acpi_button_notify_fixed,
+						     button);
+		break;
+	case ACPI_BUTTON_TYPE_SLEEPF:
+		status =
+		    acpi_install_fixed_event_handler(ACPI_EVENT_SLEEP_BUTTON,
+						     acpi_button_notify_fixed,
+						     button);
+		break;
+	default:
+		status = acpi_install_notify_handler(button->device->handle,
+						     ACPI_DEVICE_NOTIFY,
+						     acpi_button_notify,
+						     button);
+		break;
+	}
+
+	return ACPI_FAILURE(status) ? -ENODEV : 0;
+}
+
+static int acpi_button_resume(struct acpi_device *device)
+{
+	struct acpi_button *button;
+	if (!device)
+		return -EINVAL;
+	button = acpi_driver_data(device);
+	if (button && button->type == ACPI_BUTTON_TYPE_LID)
+		return acpi_lid_send_state(button);
 	return 0;
 }
 
+static void acpi_button_remove_notify_handlers(struct acpi_button *button)
+{
+	switch (button->type) {
+	case ACPI_BUTTON_TYPE_POWERF:
+		acpi_remove_fixed_event_handler(ACPI_EVENT_POWER_BUTTON,
+						acpi_button_notify_fixed);
+		break;
+	case ACPI_BUTTON_TYPE_SLEEPF:
+		acpi_remove_fixed_event_handler(ACPI_EVENT_SLEEP_BUTTON,
+						acpi_button_notify_fixed);
+		break;
+	default:
+		acpi_remove_notify_handler(button->device->handle,
+					   ACPI_DEVICE_NOTIFY,
+					   acpi_button_notify);
+		break;
+	}
+}
+
 static int acpi_button_add(struct acpi_device *device)
 {
+	int error;
 	struct acpi_button *button;
 	struct input_dev *input;
-	char *hid, *name, *class;
-	int error;
+
+	if (!device)
+		return -EINVAL;
 
 	button = kzalloc(sizeof(struct acpi_button), GFP_KERNEL);
 	if (!button)
 		return -ENOMEM;
 
+	button->device = device;
 	device->driver_data = button;
 
 	button->input = input = input_allocate_device();
@@ -305,29 +390,40 @@ static int acpi_button_add(struct acpi_device *device)
 		goto err_free_button;
 	}
 
-	hid = acpi_device_hid(device);
-	name = acpi_device_name(device);
-	class = acpi_device_class(device);
-
-	if (!strcmp(hid, ACPI_BUTTON_HID_POWER) ||
-	    !strcmp(hid, ACPI_BUTTON_HID_POWERF)) {
+	/*
+	 * Determine the button type (via hid), as fixed-feature buttons
+	 * need to be handled a bit differently than generic-space.
+	 */
+	if (!strcmp(acpi_device_hid(device), ACPI_BUTTON_HID_POWER)) {
 		button->type = ACPI_BUTTON_TYPE_POWER;
-		strcpy(name, ACPI_BUTTON_DEVICE_NAME_POWER);
-		sprintf(class, "%s/%s",
+		strcpy(acpi_device_name(device), ACPI_BUTTON_DEVICE_NAME_POWER);
+		sprintf(acpi_device_class(device), "%s/%s",
 			ACPI_BUTTON_CLASS, ACPI_BUTTON_SUBCLASS_POWER);
-	} else if (!strcmp(hid, ACPI_BUTTON_HID_SLEEP) ||
-		   !strcmp(hid, ACPI_BUTTON_HID_SLEEPF)) {
+	} else if (!strcmp(acpi_device_hid(device), ACPI_BUTTON_HID_POWERF)) {
+		button->type = ACPI_BUTTON_TYPE_POWERF;
+		strcpy(acpi_device_name(device),
+		       ACPI_BUTTON_DEVICE_NAME_POWERF);
+		sprintf(acpi_device_class(device), "%s/%s",
+			ACPI_BUTTON_CLASS, ACPI_BUTTON_SUBCLASS_POWER);
+	} else if (!strcmp(acpi_device_hid(device), ACPI_BUTTON_HID_SLEEP)) {
 		button->type = ACPI_BUTTON_TYPE_SLEEP;
-		strcpy(name, ACPI_BUTTON_DEVICE_NAME_SLEEP);
-		sprintf(class, "%s/%s",
+		strcpy(acpi_device_name(device), ACPI_BUTTON_DEVICE_NAME_SLEEP);
+		sprintf(acpi_device_class(device), "%s/%s",
+			ACPI_BUTTON_CLASS, ACPI_BUTTON_SUBCLASS_SLEEP);
+	} else if (!strcmp(acpi_device_hid(device), ACPI_BUTTON_HID_SLEEPF)) {
+		button->type = ACPI_BUTTON_TYPE_SLEEPF;
+		strcpy(acpi_device_name(device),
+		       ACPI_BUTTON_DEVICE_NAME_SLEEPF);
+		sprintf(acpi_device_class(device), "%s/%s",
 			ACPI_BUTTON_CLASS, ACPI_BUTTON_SUBCLASS_SLEEP);
-	} else if (!strcmp(hid, ACPI_BUTTON_HID_LID)) {
+	} else if (!strcmp(acpi_device_hid(device), ACPI_BUTTON_HID_LID)) {
 		button->type = ACPI_BUTTON_TYPE_LID;
-		strcpy(name, ACPI_BUTTON_DEVICE_NAME_LID);
-		sprintf(class, "%s/%s",
+		strcpy(acpi_device_name(device), ACPI_BUTTON_DEVICE_NAME_LID);
+		sprintf(acpi_device_class(device), "%s/%s",
 			ACPI_BUTTON_CLASS, ACPI_BUTTON_SUBCLASS_LID);
 	} else {
-		printk(KERN_ERR PREFIX "Unsupported hid [%s]\n", hid);
+		printk(KERN_ERR PREFIX "Unsupported hid [%s]\n",
+			    acpi_device_hid(device));
 		error = -ENODEV;
 		goto err_free_input;
 	}
@@ -336,9 +432,14 @@ static int acpi_button_add(struct acpi_device *device)
 	if (error)
 		goto err_free_input;
 
-	snprintf(button->phys, sizeof(button->phys), "%s/button/input0", hid);
+	error = acpi_button_install_notify_handlers(button);
+	if (error)
+		goto err_remove_fs;
 
-	input->name = name;
+	snprintf(button->phys, sizeof(button->phys),
+		 "%s/button/input0", acpi_device_hid(device));
+
+	input->name = acpi_device_name(device);
 	input->phys = button->phys;
 	input->id.bustype = BUS_HOST;
 	input->id.product = button->type;
@@ -346,11 +447,13 @@ static int acpi_button_add(struct acpi_device *device)
 
 	switch (button->type) {
 	case ACPI_BUTTON_TYPE_POWER:
+	case ACPI_BUTTON_TYPE_POWERF:
 		input->evbit[0] = BIT_MASK(EV_KEY);
 		set_bit(KEY_POWER, input->keybit);
 		break;
 
 	case ACPI_BUTTON_TYPE_SLEEP:
+	case ACPI_BUTTON_TYPE_SLEEPF:
 		input->evbit[0] = BIT_MASK(EV_KEY);
 		set_bit(KEY_SLEEP, input->keybit);
 		break;
@@ -363,9 +466,9 @@ static int acpi_button_add(struct acpi_device *device)
 
 	error = input_register_device(input);
 	if (error)
-		goto err_remove_fs;
+		goto err_remove_handlers;
 	if (button->type == ACPI_BUTTON_TYPE_LID)
-		acpi_lid_send_state(device);
+		acpi_lid_send_state(button);
 
 	if (device->wakeup.flags.valid) {
 		/* Button's GPE is run-wake GPE */
@@ -377,9 +480,13 @@ static int acpi_button_add(struct acpi_device *device)
 		device->wakeup.state.enabled = 1;
 	}
 
-	printk(KERN_INFO PREFIX "%s [%s]\n", name, acpi_device_bid(device));
+	printk(KERN_INFO PREFIX "%s [%s]\n",
+	       acpi_device_name(device), acpi_device_bid(device));
+
 	return 0;
 
+ err_remove_handlers:
+	acpi_button_remove_notify_handlers(button);
  err_remove_fs:
 	acpi_button_remove_fs(device);
  err_free_input:
@@ -391,11 +498,18 @@ static int acpi_button_add(struct acpi_device *device)
 
 static int acpi_button_remove(struct acpi_device *device, int type)
 {
-	struct acpi_button *button = acpi_driver_data(device);
+	struct acpi_button *button;
+
+	if (!device || !acpi_driver_data(device))
+		return -EINVAL;
 
+	button = acpi_driver_data(device);
+
+	acpi_button_remove_notify_handlers(button);
 	acpi_button_remove_fs(device);
 	input_unregister_device(button->input);
 	kfree(button);
+
 	return 0;
 }
 
@@ -406,7 +520,6 @@ static int __init acpi_button_init(void)
 	acpi_button_dir = proc_mkdir(ACPI_BUTTON_CLASS, acpi_root_dir);
 	if (!acpi_button_dir)
 		return -ENODEV;
-
 	result = acpi_bus_register_driver(&acpi_button_driver);
 	if (result < 0) {
 		remove_proc_entry(ACPI_BUTTON_CLASS, acpi_root_dir);

--Boundary-00=_kIlVKvjU7Kr0ZWB--
