Return-Path: <linux-kernel-owner+w=401wt.eu-S1755107AbZBDOfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755107AbZBDOfV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 09:35:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752065AbZBDOfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 09:35:06 -0500
Received: from ns2.suse.de ([195.135.220.15]:34125 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253AbZBDOfD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 09:35:03 -0500
Message-ID: <4989A784.3030604@suse.de>
Date: Wed, 04 Feb 2009 15:34:44 +0100
From: Frank Seidel <fseidel@suse.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: linux kernel <linux-kernel@vger.kernel.org>
Cc: akpm@linux-foundation.org, linux-acpi@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, len.brown@intel.com,
       shaohuhua.li@intel.com, kristen.c.accardi@intel.com, frank@f-seidel.de,
       fseidel@suse.de
Subject: [PATCH] ACPI: add missing KERN_* constants to printks
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frank Seidel <frank@f-seidel.de>

According to kerneljanitors todo list all printk calls should
have an according KERN_* constant.
Those are the missing peaces here for the acpi subsystem.

Signed-off-by: Frank Seidel <frank@f-seidel.de>
---
 drivers/acpi/container.c      |    5 +++--
 drivers/acpi/dock.c           |    8 ++++----
 drivers/acpi/osl.c            |    4 ++--
 drivers/acpi/pci_irq.c        |    4 ++--
 drivers/acpi/pci_link.c       |   14 +++++++-------
 drivers/acpi/processor_core.c |    5 +++--
 drivers/acpi/processor_idle.c |    4 ++--
 drivers/acpi/sleep.c          |   10 +++++-----
 drivers/acpi/video.c          |    2 +-
 9 files changed, 29 insertions(+), 27 deletions(-)

--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -1260,7 +1260,7 @@ static int acpi_video_bus_POST_info_seq_
 			printk(KERN_WARNING PREFIX
 			       "This indicates a BIOS bug. Please contact the manufacturer.\n");
 		}
-		printk("%llx\n", options);
+		printk(KERN_WARNING "%llx\n", options);
 		seq_printf(seq, "can POST: <integrated video>");
 		if (options & 2)
 			seq_printf(seq, " <PCI video>");
--- a/drivers/acpi/container.c
+++ b/drivers/acpi/container.c
@@ -163,7 +163,7 @@ static void container_notify_cb(acpi_han
 	case ACPI_NOTIFY_BUS_CHECK:
 		/* Fall through */
 	case ACPI_NOTIFY_DEVICE_CHECK:
-		printk("Container driver received %s event\n",
+		printk(KERN_WARNING "Container driver received %s event\n",
 		       (type == ACPI_NOTIFY_BUS_CHECK) ?
 		       "ACPI_NOTIFY_BUS_CHECK" : "ACPI_NOTIFY_DEVICE_CHECK");
 		status = acpi_bus_get_device(handle, &device);
@@ -174,7 +174,8 @@ static void container_notify_cb(acpi_han
 					kobject_uevent(&device->dev.kobj,
 						       KOBJ_ONLINE);
 				else
-					printk("Failed to add container\n");
+					printk(KERN_WARNING
+					       "Failed to add container\n");
 			}
 		} else {
 			if (ACPI_SUCCESS(status)) {
--- a/drivers/acpi/pci_irq.c
+++ b/drivers/acpi/pci_irq.c
@@ -400,12 +400,12 @@ int acpi_pci_irq_enable(struct pci_dev *
 		dev_warn(&dev->dev, "PCI INT %c: no GSI", pin_name(pin));
 		/* Interrupt Line values above 0xF are forbidden */
 		if (dev->irq > 0 && (dev->irq <= 0xF)) {
-			printk(" - using IRQ %d\n", dev->irq);
+			printk(KERN_WARNING " - using IRQ %d\n", dev->irq);
 			acpi_register_gsi(dev->irq, ACPI_LEVEL_SENSITIVE,
 					  ACPI_ACTIVE_LOW);
 			return 0;
 		} else {
-			printk("\n");
+			printk(KERN_WARNING "\n");
 			return 0;
 		}
 	}
--- a/drivers/acpi/pci_link.c
+++ b/drivers/acpi/pci_link.c
@@ -593,7 +593,7 @@ static int acpi_pci_link_allocate(struct
 		return -ENODEV;
 	} else {
 		acpi_irq_penalty[link->irq.active] += PIRQ_PENALTY_PCI_USING;
-		printk(PREFIX "%s [%s] enabled at IRQ %d\n",
+		printk(KERN_WARNING PREFIX "%s [%s] enabled at IRQ %d\n",
 		       acpi_device_name(link->device),
 		       acpi_device_bid(link->device), link->irq.active);
 	}
@@ -751,21 +751,21 @@ static int acpi_pci_link_add(struct acpi
 	       acpi_device_bid(device));
 	for (i = 0; i < link->irq.possible_count; i++) {
 		if (link->irq.active == link->irq.possible[i]) {
-			printk(" *%d", link->irq.possible[i]);
+			printk(KERN_INFO " *%d", link->irq.possible[i]);
 			found = 1;
 		} else
-			printk(" %d", link->irq.possible[i]);
+			printk(KERN_INFO " %d", link->irq.possible[i]);
 	}
 
-	printk(")");
+	printk(KERN_INFO ")");
 
 	if (!found)
-		printk(" *%d", link->irq.active);
+		printk(KERN_INFO " *%d", link->irq.active);
 
 	if (!link->device->status.enabled)
-		printk(", disabled.");
+		printk(KERN_INFO ", disabled.");
 
-	printk("\n");
+	printk(KERN_INFO "\n");
 
 	/* TBD: Acquire/release lock */
 	list_add_tail(&link->node, &acpi_link.entries);
--- a/drivers/acpi/dock.c
+++ b/drivers/acpi/dock.c
@@ -984,7 +984,7 @@ static int dock_add(acpi_handle handle)
 
 	ret = device_create_file(&dock_device->dev, &dev_attr_docked);
 	if (ret) {
-		printk("Error %d adding sysfs file\n", ret);
+		printk(KERN_ERR "Error %d adding sysfs file\n", ret);
 		platform_device_unregister(dock_device);
 		kfree(dock_station);
 		dock_station = NULL;
@@ -992,7 +992,7 @@ static int dock_add(acpi_handle handle)
 	}
 	ret = device_create_file(&dock_device->dev, &dev_attr_undock);
 	if (ret) {
-		printk("Error %d adding sysfs file\n", ret);
+		printk(KERN_ERR "Error %d adding sysfs file\n", ret);
 		device_remove_file(&dock_device->dev, &dev_attr_docked);
 		platform_device_unregister(dock_device);
 		kfree(dock_station);
@@ -1001,7 +1001,7 @@ static int dock_add(acpi_handle handle)
 	}
 	ret = device_create_file(&dock_device->dev, &dev_attr_uid);
 	if (ret) {
-		printk("Error %d adding sysfs file\n", ret);
+		printk(KERN_ERR "Error %d adding sysfs file\n", ret);
 		device_remove_file(&dock_device->dev, &dev_attr_docked);
 		device_remove_file(&dock_device->dev, &dev_attr_undock);
 		platform_device_unregister(dock_device);
@@ -1011,7 +1011,7 @@ static int dock_add(acpi_handle handle)
 	}
 	ret = device_create_file(&dock_device->dev, &dev_attr_flags);
 	if (ret) {
-		printk("Error %d adding sysfs file\n", ret);
+		printk(KERN_ERR "Error %d adding sysfs file\n", ret);
 		device_remove_file(&dock_device->dev, &dev_attr_docked);
 		device_remove_file(&dock_device->dev, &dev_attr_undock);
 		device_remove_file(&dock_device->dev, &dev_attr_uid);
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -1861,9 +1861,9 @@ int __cpuinit acpi_processor_power_init(
 		printk(KERN_INFO PREFIX "CPU%d (power states:", pr->id);
 		for (i = 1; i <= pr->power.count; i++)
 			if (pr->power.states[i].valid)
-				printk(" C%d[C%d]", i,
+				printk(KERN_INFO " C%d[C%d]", i,
 				       pr->power.states[i].type);
-		printk(")\n");
+		printk(KERN_INFO ")\n");
 
 #ifndef CONFIG_CPU_IDLE
 		if (pr->id == 0) {
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -228,10 +228,10 @@ void acpi_os_vprintf(const char *fmt, va
 	if (acpi_in_debugger) {
 		kdb_printf("%s", buffer);
 	} else {
-		printk("%s", buffer);
+		printk(KERN_WARNING "%s", buffer);
 	}
 #else
-	printk("%s", buffer);
+	printk(KERN_WARNING "%s", buffer);
 #endif
 }
 
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -742,8 +742,9 @@ static int __cpuinit acpi_processor_star
 	if (pr->flags.throttling) {
 		printk(KERN_INFO PREFIX "%s [%s] (supports",
 		       acpi_device_name(device), acpi_device_bid(device));
-		printk(" %d throttling states", pr->throttling.state_count);
-		printk(")\n");
+		printk(KERN_INFO
+		       " %d throttling states", pr->throttling.state_count);
+		printk(KERN_INFO ")\n");
 	}
 
       end:
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -679,7 +679,7 @@ static void acpi_power_off_prepare(void)
 static void acpi_power_off(void)
 {
 	/* acpi_sleep_prepare(ACPI_STATE_S5) should have already been called */
-	printk("%s called\n", __func__);
+	printk(KERN_DEBUG "%s called\n", __func__);
 	local_irq_disable();
 	acpi_enable_wakeup_device(ACPI_STATE_S5);
 	acpi_enter_sleep_state(ACPI_STATE_S5);
@@ -706,7 +706,7 @@ int __init acpi_sleep_init(void)
 		status = acpi_get_sleep_type_data(i, &type_a, &type_b);
 		if (ACPI_SUCCESS(status)) {
 			sleep_states[i] = 1;
-			printk(" S%d", i);
+			printk(KERN_INFO " S%d", i);
 		}
 	}
 
@@ -720,7 +720,7 @@ int __init acpi_sleep_init(void)
 		hibernation_set_ops(old_suspend_ordering ?
 			&acpi_hibernation_ops_old : &acpi_hibernation_ops);
 		sleep_states[ACPI_STATE_S4] = 1;
-		printk(" S4");
+		printk(KERN_INFO " S4");
 		if (!nosigcheck) {
 			acpi_get_table(ACPI_SIG_FACS, 1,
 				(struct acpi_table_header **)&facs);
@@ -733,11 +733,11 @@ int __init acpi_sleep_init(void)
 	status = acpi_get_sleep_type_data(ACPI_STATE_S5, &type_a, &type_b);
 	if (ACPI_SUCCESS(status)) {
 		sleep_states[ACPI_STATE_S5] = 1;
-		printk(" S5");
+		printk(KERN_INFO " S5");
 		pm_power_off_prepare = acpi_power_off_prepare;
 		pm_power_off = acpi_power_off;
 	}
-	printk(")\n");
+	printk(KERN_INFO ")\n");
 	/*
 	 * Register the tts_notifier to reboot notifier list so that the _TTS
 	 * object can also be evaluated when the system enters S5.
