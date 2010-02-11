Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752428Ab0BKKwc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 05:52:32 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:49586 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751358Ab0BKKw2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 05:52:28 -0500
Date: Thu, 11 Feb 2010 11:52:20 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Thomas Renninger <trenn@suse.de>
Cc: Darren Jenkins <darrenrjenkins@gmail.com>, Len Brown <lenb@kernel.org>,
       Zhang Rui <rui.zhang@intel.com>,
       H Hartley Sweeten <hsweeten@visionengravers.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux ACPI <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Janitors <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH] drivers/acpi/processor_thermal.c
In-Reply-To: <201002111124.51070.trenn@suse.de>
Message-ID: <Pine.LNX.4.64.1002111150510.2412@ask.diku.dk>
References: <1265882211.27789.1.camel@ICE-BOX> <201002111124.51070.trenn@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Feb 2010, Thomas Renninger wrote:

> Eh, 
> 
> what is this for?:
> static inline void *acpi_driver_data(struct acpi_device *d)
> {
>         return d->driver_data;
> }
> 
> On Thursday 11 February 2010 10:56:51 Darren Jenkins wrote:
> > There are a few places where a pointer is dereferenced with acpi_driver_data()
> > before a NULL test. This re-orders the code to fix these issues.
> > 
> > Coverity CID: 2752 2751 2750
> > 
> > Signed-off-by: Darren Jenkins <darrenrjenkins@gmail.com>
> > ---
> >  drivers/acpi/processor_thermal.c |   28 ++++++++++++++++++++--------
> >  1 files changed, 20 insertions(+), 8 deletions(-)
> > 
> > diff --git a/drivers/acpi/processor_thermal.c b/drivers/acpi/processor_thermal.c
> > index 6deafb4..ec33554 100644
> > --- a/drivers/acpi/processor_thermal.c
> > +++ b/drivers/acpi/processor_thermal.c
> > @@ -379,9 +379,14 @@ processor_get_max_state(struct thermal_cooling_device *cdev,
> >  			unsigned long *state)
> >  {
> >  	struct acpi_device *device = cdev->devdata;
> > -	struct acpi_processor *pr = acpi_driver_data(device);
> > +	struct acpi_processor *pr;
> >  
> > -	if (!device || !pr)
> > +	if (!device)
> > +		return -EINVAL;
> > +
> > +	pr = acpi_driver_data(device);
> Better use (here and at other places):
> device->driver_data
> instead of
> acpi_driver_data(device)
> 
> if you touch this anyway.
> Then such bugs like the one you address here, don't happen
> anymore in the future.
> If you have some more time you might want to revert all the
> other instances and revert the acpi_driver_data declaration
> in include/acpi/acpi_bus.h


A potential patch that gets rid of the uses is below.  I don't have time 
to look at this in more detail at the moment, but perhaps someone else 
would like to do so.  The semantic patch (http://coccinelle.lip6.fr) 
involved is:

@@
struct acpi_device *d;
@@

- acpi_driver_data(d)
+ d->driver_data

julia

---------------
diff -u -p a/arch/x86/kernel/cpu/cpufreq/longhaul.c b/arch/x86/kernel/cpu/cpufreq/longhaul.c
--- a/arch/x86/kernel/cpu/cpufreq/longhaul.c 2009-12-03 14:09:47.000000000 +0100
+++ b/arch/x86/kernel/cpu/cpufreq/longhaul.c 2010-02-11 12:48:46.000000000 +0100
@@ -699,7 +699,7 @@ static acpi_status longhaul_walk_callbac
 	if (acpi_bus_get_device(obj_handle, &d))
 		return 0;
 
-	*return_value = acpi_driver_data(d);
+	*return_value = d->driver_data;
 	return 1;
 }
 
diff -u -p a/drivers/acpi/ac.c b/drivers/acpi/ac.c
--- a/drivers/acpi/ac.c 2009-10-17 10:35:58.000000000 +0200
+++ b/drivers/acpi/ac.c 2010-02-11 12:48:47.000000000 +0100
@@ -201,7 +201,7 @@ static int acpi_ac_add_fs(struct acpi_de
 	/* 'state' [R] */
 	entry = proc_create_data(ACPI_AC_FILE_STATE,
 				 S_IRUGO, acpi_device_dir(device),
-				 &acpi_ac_fops, acpi_driver_data(device));
+				 &acpi_ac_fops, device->driver_data);
 	if (!entry)
 		return -ENODEV;
 	return 0;
@@ -227,7 +227,7 @@ static int acpi_ac_remove_fs(struct acpi
 
 static void acpi_ac_notify(struct acpi_device *device, u32 event)
 {
-	struct acpi_ac *ac = acpi_driver_data(device);
+	struct acpi_ac *ac = device->driver_data;
 
 
 	if (!ac)
@@ -309,9 +309,9 @@ static int acpi_ac_resume(struct acpi_de
 {
 	struct acpi_ac *ac;
 	unsigned old_state;
-	if (!device || !acpi_driver_data(device))
+	if (!device || !device->driver_data)
 		return -EINVAL;
-	ac = acpi_driver_data(device);
+	ac = device->driver_data;
 	old_state = ac->state;
 	if (acpi_ac_get_state(ac))
 		return 0;
@@ -327,10 +327,10 @@ static int acpi_ac_remove(struct acpi_de
 	struct acpi_ac *ac = NULL;
 
 
-	if (!device || !acpi_driver_data(device))
+	if (!device || !device->driver_data)
 		return -EINVAL;
 
-	ac = acpi_driver_data(device);
+	ac = device->driver_data;
 
 #ifdef CONFIG_ACPI_SYSFS_POWER
 	if (ac->charger.dev)
diff -u -p a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
--- a/drivers/acpi/acpi_memhotplug.c 2009-12-03 14:09:47.000000000 +0100
+++ b/drivers/acpi/acpi_memhotplug.c 2010-02-11 12:48:47.000000000 +0100
@@ -184,7 +184,7 @@ acpi_memory_get_device(acpi_handle handl
 	}
 
       end:
-	*mem_device = acpi_driver_data(device);
+	*mem_device = device->driver_data;
 	if (!(*mem_device)) {
 		printk(KERN_ERR "\n driver data not found");
 		return -ENODEV;
@@ -370,7 +370,7 @@ static void acpi_memory_device_notify(ac
 			printk(KERN_ERR PREFIX "Device doesn't exist\n");
 			break;
 		}
-		mem_device = acpi_driver_data(device);
+		mem_device = device->driver_data;
 		if (!mem_device) {
 			printk(KERN_ERR PREFIX "Driver Data is NULL\n");
 			break;
@@ -453,10 +453,10 @@ static int acpi_memory_device_remove(str
 	struct acpi_memory_device *mem_device = NULL;
 
 
-	if (!device || !acpi_driver_data(device))
+	if (!device || !device->driver_data)
 		return -EINVAL;
 
-	mem_device = acpi_driver_data(device);
+	mem_device = device->driver_data;
 	kfree(mem_device);
 
 	return 0;
diff -u -p a/drivers/acpi/battery.c b/drivers/acpi/battery.c
--- a/drivers/acpi/battery.c 2010-01-29 18:29:07.000000000 +0100
+++ b/drivers/acpi/battery.c 2010-02-11 12:48:46.000000000 +0100
@@ -838,7 +838,7 @@ static int acpi_battery_add_fs(struct ac
 					 acpi_battery_file[i].mode,
 					 acpi_device_dir(device),
 					 &acpi_battery_file[i].ops,
-					 acpi_driver_data(device));
+					 device->driver_data);
 		if (!entry)
 			return -ENODEV;
 	}
@@ -866,7 +866,7 @@ static void acpi_battery_remove_fs(struc
 
 static void acpi_battery_notify(struct acpi_device *device, u32 event)
 {
-	struct acpi_battery *battery = acpi_driver_data(device);
+	struct acpi_battery *battery = device->driver_data;
 
 	if (!battery)
 		return;
@@ -922,9 +922,9 @@ static int acpi_battery_remove(struct ac
 {
 	struct acpi_battery *battery = NULL;
 
-	if (!device || !acpi_driver_data(device))
+	if (!device || !device->driver_data)
 		return -EINVAL;
-	battery = acpi_driver_data(device);
+	battery = device->driver_data;
 #ifdef CONFIG_ACPI_PROCFS_POWER
 	acpi_battery_remove_fs(device);
 #endif
@@ -942,7 +942,7 @@ static int acpi_battery_resume(struct ac
 	struct acpi_battery *battery;
 	if (!device)
 		return -EINVAL;
-	battery = acpi_driver_data(device);
+	battery = device->driver_data;
 	battery->update_time = 0;
 	acpi_battery_update(battery);
 	return 0;
diff -u -p a/drivers/acpi/button.c b/drivers/acpi/button.c
--- a/drivers/acpi/button.c 2010-01-20 13:04:05.000000000 +0100
+++ b/drivers/acpi/button.c 2010-02-11 12:48:46.000000000 +0100
@@ -162,7 +162,7 @@ static struct proc_dir_entry *acpi_lid_d
 
 static int acpi_button_add_fs(struct acpi_device *device)
 {
-	struct acpi_button *button = acpi_driver_data(device);
+	struct acpi_button *button = device->driver_data;
 	struct proc_dir_entry *entry = NULL;
 
 	switch (button->type) {
@@ -214,7 +214,7 @@ static int acpi_button_add_fs(struct acp
 
 static int acpi_button_remove_fs(struct acpi_device *device)
 {
-	struct acpi_button *button = acpi_driver_data(device);
+	struct acpi_button *button = device->driver_data;
 
 	if (acpi_device_dir(device)) {
 		if (button->type == ACPI_BUTTON_TYPE_LID)
@@ -265,7 +265,7 @@ EXPORT_SYMBOL(acpi_lid_open);
 
 static int acpi_lid_send_state(struct acpi_device *device)
 {
-	struct acpi_button *button = acpi_driver_data(device);
+	struct acpi_button *button = device->driver_data;
 	unsigned long long state;
 	acpi_status status;
 	int ret;
@@ -294,7 +294,7 @@ static int acpi_lid_send_state(struct ac
 
 static void acpi_button_notify(struct acpi_device *device, u32 event)
 {
-	struct acpi_button *button = acpi_driver_data(device);
+	struct acpi_button *button = device->driver_data;
 	struct input_dev *input;
 
 	switch (event) {
@@ -326,7 +326,7 @@ static void acpi_button_notify(struct ac
 
 static int acpi_button_resume(struct acpi_device *device)
 {
-	struct acpi_button *button = acpi_driver_data(device);
+	struct acpi_button *button = device->driver_data;
 
 	if (button->type == ACPI_BUTTON_TYPE_LID)
 		return acpi_lid_send_state(device);
@@ -444,7 +444,7 @@ static int acpi_button_add(struct acpi_d
 
 static int acpi_button_remove(struct acpi_device *device, int type)
 {
-	struct acpi_button *button = acpi_driver_data(device);
+	struct acpi_button *button = device->driver_data;
 
 	if (device->wakeup.flags.valid) {
 		acpi_unref_runtime_gpe(device->wakeup.gpe_device,
diff -u -p a/drivers/acpi/container.c b/drivers/acpi/container.c
--- a/drivers/acpi/container.c 2009-12-03 14:09:47.000000000 +0100
+++ b/drivers/acpi/container.c 2010-02-11 12:48:46.000000000 +0100
@@ -122,7 +122,7 @@ static int acpi_container_remove(struct 
 	acpi_status status = AE_OK;
 	struct acpi_container *pc = NULL;
 
-	pc = acpi_driver_data(device);
+	pc = device->driver_data;
 	kfree(pc);
 	return status;
 }
diff -u -p a/drivers/acpi/ec.c b/drivers/acpi/ec.c
--- a/drivers/acpi/ec.c 2010-01-29 18:29:07.000000000 +0100
+++ b/drivers/acpi/ec.c 2010-02-11 12:48:48.000000000 +0100
@@ -693,7 +693,7 @@ static int acpi_ec_add_fs(struct acpi_de
 
 	entry = proc_create_data(ACPI_EC_FILE_INFO, S_IRUGO,
 				 acpi_device_dir(device),
-				 &acpi_ec_info_ops, acpi_driver_data(device));
+				 &acpi_ec_info_ops, device->driver_data);
 	if (!entry)
 		return -ENODEV;
 	return 0;
@@ -880,7 +880,7 @@ static int acpi_ec_remove(struct acpi_de
 	if (!device)
 		return -EINVAL;
 
-	ec = acpi_driver_data(device);
+	ec = device->driver_data;
 	ec_remove_handlers(ec);
 	mutex_lock(&ec->lock);
 	list_for_each_entry_safe(handler, tmp, &ec->list, node) {
@@ -1058,7 +1058,7 @@ error:
 
 static int acpi_ec_suspend(struct acpi_device *device, pm_message_t state)
 {
-	struct acpi_ec *ec = acpi_driver_data(device);
+	struct acpi_ec *ec = device->driver_data;
 	/* Stop using GPE */
 	acpi_disable_gpe(NULL, ec->gpe);
 	return 0;
@@ -1066,7 +1066,7 @@ static int acpi_ec_suspend(struct acpi_d
 
 static int acpi_ec_resume(struct acpi_device *device)
 {
-	struct acpi_ec *ec = acpi_driver_data(device);
+	struct acpi_ec *ec = device->driver_data;
 	/* Enable use of GPE back */
 	acpi_enable_gpe(NULL, ec->gpe);
 	return 0;
diff -u -p a/drivers/acpi/fan.c b/drivers/acpi/fan.c
--- a/drivers/acpi/fan.c 2009-12-17 08:30:13.000000000 +0100
+++ b/drivers/acpi/fan.c 2010-02-11 12:48:47.000000000 +0100
@@ -298,7 +298,7 @@ static int acpi_fan_add(struct acpi_devi
 
 static int acpi_fan_remove(struct acpi_device *device, int type)
 {
-	struct thermal_cooling_device *cdev = acpi_driver_data(device);
+	struct thermal_cooling_device *cdev = device->driver_data;
 
 	if (!device || !cdev)
 		return -EINVAL;
diff -u -p a/drivers/acpi/pci_link.c b/drivers/acpi/pci_link.c
--- a/drivers/acpi/pci_link.c 2010-01-20 13:04:05.000000000 +0100
+++ b/drivers/acpi/pci_link.c 2010-02-11 12:48:46.000000000 +0100
@@ -599,7 +599,7 @@ int acpi_pci_link_allocate_irq(acpi_hand
 		return -1;
 	}
 
-	link = acpi_driver_data(device);
+	link = device->driver_data;
 	if (!link) {
 		printk(KERN_ERR PREFIX "Invalid link context\n");
 		return -1;
@@ -653,7 +653,7 @@ int acpi_pci_link_free_irq(acpi_handle h
 		return -1;
 	}
 
-	link = acpi_driver_data(device);
+	link = device->driver_data;
 	if (!link) {
 		printk(KERN_ERR PREFIX "Invalid link context\n");
 		return -1;
@@ -771,7 +771,7 @@ static int acpi_pci_link_remove(struct a
 {
 	struct acpi_pci_link *link;
 
-	link = acpi_driver_data(device);
+	link = device->driver_data;
 
 	mutex_lock(&acpi_link_lock);
 	list_del(&link->list);
diff -u -p a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
--- a/drivers/acpi/pci_root.c 2010-01-20 13:04:05.000000000 +0100
+++ b/drivers/acpi/pci_root.c 2010-02-11 12:48:46.000000000 +0100
@@ -544,7 +544,7 @@ end:
 
 static int acpi_pci_root_start(struct acpi_device *device)
 {
-	struct acpi_pci_root *root = acpi_driver_data(device);
+	struct acpi_pci_root *root = device->driver_data;
 
 	pci_bus_add_devices(root->bus);
 	return 0;
@@ -552,7 +552,7 @@ static int acpi_pci_root_start(struct ac
 
 static int acpi_pci_root_remove(struct acpi_device *device, int type)
 {
-	struct acpi_pci_root *root = acpi_driver_data(device);
+	struct acpi_pci_root *root = device->driver_data;
 
 	device_set_run_wake(root->bus->bridge, false);
 	pci_acpi_remove_pm_notifier(device);
diff -u -p a/drivers/acpi/power.c b/drivers/acpi/power.c
--- a/drivers/acpi/power.c 2010-01-20 13:04:05.000000000 +0100
+++ b/drivers/acpi/power.c 2010-02-11 12:48:46.000000000 +0100
@@ -127,7 +127,7 @@ acpi_power_get_context(acpi_handle handl
 		return result;
 	}
 
-	*resource = acpi_driver_data(device);
+	*resource = device->driver_data;
 	if (!*resource)
 		return -ENODEV;
 
@@ -618,7 +618,7 @@ static int acpi_power_add_fs(struct acpi
 	/* 'status' [R] */
 	entry = proc_create_data(ACPI_POWER_FILE_STATUS,
 				 S_IRUGO, acpi_device_dir(device),
-				 &acpi_power_fops, acpi_driver_data(device));
+				 &acpi_power_fops, device->driver_data);
 	if (!entry)
 		return -EIO;
 	return 0;
@@ -710,10 +710,10 @@ static int acpi_power_remove(struct acpi
 	struct list_head *node, *next;
 
 
-	if (!device || !acpi_driver_data(device))
+	if (!device || !device->driver_data)
 		return -EINVAL;
 
-	resource = acpi_driver_data(device);
+	resource = device->driver_data;
 
 	acpi_power_remove_fs(device);
 
@@ -736,10 +736,10 @@ static int acpi_power_resume(struct acpi
 	struct acpi_power_resource *resource = NULL;
 	struct acpi_power_reference *ref;
 
-	if (!device || !acpi_driver_data(device))
+	if (!device || !device->driver_data)
 		return -EINVAL;
 
-	resource = acpi_driver_data(device);
+	resource = device->driver_data;
 
 	result = acpi_power_get_state(device->handle, &state);
 	if (result)
diff -u -p a/drivers/acpi/power_meter.c b/drivers/acpi/power_meter.c
--- a/drivers/acpi/power_meter.c 2010-01-29 18:29:07.000000000 +0100
+++ b/drivers/acpi/power_meter.c 2010-02-11 12:48:46.000000000 +0100
@@ -841,10 +841,10 @@ static void acpi_power_meter_notify(stru
 	struct acpi_power_meter_resource *resource;
 	int res;
 
-	if (!device || !acpi_driver_data(device))
+	if (!device || !device->driver_data)
 		return;
 
-	resource = acpi_driver_data(device);
+	resource = device->driver_data;
 
 	mutex_lock(&resource->lock);
 	switch (event) {
@@ -934,10 +934,10 @@ static int acpi_power_meter_remove(struc
 {
 	struct acpi_power_meter_resource *resource;
 
-	if (!device || !acpi_driver_data(device))
+	if (!device || !device->driver_data)
 		return -EINVAL;
 
-	resource = acpi_driver_data(device);
+	resource = device->driver_data;
 	hwmon_device_unregister(resource->hwmon_dev);
 
 	free_capabilities(resource);
@@ -951,10 +951,10 @@ static int acpi_power_meter_resume(struc
 {
 	struct acpi_power_meter_resource *resource;
 
-	if (!device || !acpi_driver_data(device))
+	if (!device || !device->driver_data)
 		return -EINVAL;
 
-	resource = acpi_driver_data(device);
+	resource = device->driver_data;
 	free_capabilities(resource);
 	read_capabilities(resource);
 
diff -u -p a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
--- a/drivers/acpi/processor_core.c 2010-01-12 18:05:01.000000000 +0100
+++ b/drivers/acpi/processor_core.c 2010-02-11 12:48:47.000000000 +0100
@@ -309,7 +309,7 @@ static int __cpuinit acpi_processor_add_
 	entry = proc_create_data(ACPI_PROCESSOR_FILE_INFO,
 				 S_IRUGO, acpi_device_dir(device),
 				 &acpi_processor_info_fops,
-				 acpi_driver_data(device));
+				 device->driver_data);
 	if (!entry)
 		return -EIO;
 
@@ -318,7 +318,7 @@ static int __cpuinit acpi_processor_add_
 				 S_IFREG | S_IRUGO | S_IWUSR,
 				 acpi_device_dir(device),
 				 &acpi_processor_throttling_fops,
-				 acpi_driver_data(device));
+				 device->driver_data);
 	if (!entry)
 		return -EIO;
 
@@ -327,7 +327,7 @@ static int __cpuinit acpi_processor_add_
 				 S_IFREG | S_IRUGO | S_IWUSR,
 				 acpi_device_dir(device),
 				 &acpi_processor_limit_fops,
-				 acpi_driver_data(device));
+				 device->driver_data);
 	if (!entry)
 		return -EIO;
 	return 0;
@@ -528,7 +528,7 @@ static int acpi_processor_get_info(struc
 	int cpu_index, device_declaration = 0;
 	static int cpu0_initialized;
 
-	pr = acpi_driver_data(device);
+	pr = device->driver_data;
 	if (!pr)
 		return -EINVAL;
 
@@ -653,7 +653,7 @@ static DEFINE_PER_CPU(void *, processor_
 
 static void acpi_processor_notify(struct acpi_device *device, u32 event)
 {
-	struct acpi_processor *pr = acpi_driver_data(device);
+	struct acpi_processor *pr = device->driver_data;
 	int saved;
 
 	if (!pr)
@@ -822,10 +822,10 @@ static int acpi_processor_remove(struct 
 	struct acpi_processor *pr = NULL;
 
 
-	if (!device || !acpi_driver_data(device))
+	if (!device || !device->driver_data)
 		return -EINVAL;
 
-	pr = acpi_driver_data(device);
+	pr = device->driver_data;
 
 	if (pr->id >= nr_cpu_ids)
 		goto free;
@@ -944,7 +944,7 @@ static void __ref acpi_processor_hotplug
 				    "Device don't exist, dropping EJECT\n");
 			break;
 		}
-		pr = acpi_driver_data(device);
+		pr = device->driver_data;
 		if (!pr) {
 			printk(KERN_ERR PREFIX
 				    "Driver data is NULL, dropping EJECT\n");
diff -u -p a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
--- a/drivers/acpi/processor_idle.c 2010-01-29 18:29:07.000000000 +0100
+++ b/drivers/acpi/processor_idle.c 2010-02-11 12:48:46.000000000 +0100
@@ -1212,7 +1212,7 @@ int __cpuinit acpi_processor_power_init(
 	entry = proc_create_data(ACPI_PROCESSOR_FILE_POWER,
 				 S_IRUGO, acpi_device_dir(device),
 				 &acpi_processor_power_fops,
-				 acpi_driver_data(device));
+				 device->driver_data);
 	if (!entry)
 		return -EIO;
 #endif
diff -u -p a/drivers/acpi/processor_thermal.c b/drivers/acpi/processor_thermal.c
--- a/drivers/acpi/processor_thermal.c 2010-01-20 13:04:05.000000000 +0100
+++ b/drivers/acpi/processor_thermal.c 2010-02-11 12:48:47.000000000 +0100
@@ -256,7 +256,7 @@ int acpi_processor_set_thermal_limit(acp
 	if (result)
 		return result;
 
-	pr = acpi_driver_data(device);
+	pr = device->driver_data;
 	if (!pr)
 		return -ENODEV;
 
@@ -379,7 +379,7 @@ processor_get_max_state(struct thermal_c
 			unsigned long *state)
 {
 	struct acpi_device *device = cdev->devdata;
-	struct acpi_processor *pr = acpi_driver_data(device);
+	struct acpi_processor *pr = device->driver_data;
 
 	if (!device || !pr)
 		return -EINVAL;
@@ -393,7 +393,7 @@ processor_get_cur_state(struct thermal_c
 			unsigned long *cur_state)
 {
 	struct acpi_device *device = cdev->devdata;
-	struct acpi_processor *pr = acpi_driver_data(device);
+	struct acpi_processor *pr = device->driver_data;
 
 	if (!device || !pr)
 		return -EINVAL;
@@ -409,7 +409,7 @@ processor_set_cur_state(struct thermal_c
 			unsigned long state)
 {
 	struct acpi_device *device = cdev->devdata;
-	struct acpi_processor *pr = acpi_driver_data(device);
+	struct acpi_processor *pr = device->driver_data;
 	int result = 0;
 	int max_pstate;
 
diff -u -p a/drivers/acpi/sbs.c b/drivers/acpi/sbs.c
--- a/drivers/acpi/sbs.c 2010-01-20 13:04:05.000000000 +0100
+++ b/drivers/acpi/sbs.c 2010-02-11 12:48:46.000000000 +0100
@@ -973,7 +973,7 @@ static int acpi_sbs_remove(struct acpi_d
 
 	if (!device)
 		return -EINVAL;
-	sbs = acpi_driver_data(device);
+	sbs = device->driver_data;
 	if (!sbs)
 		return -EINVAL;
 	mutex_lock(&sbs->lock);
diff -u -p a/drivers/acpi/sbshc.c b/drivers/acpi/sbshc.c
--- a/drivers/acpi/sbshc.c 2010-01-03 21:18:12.000000000 +0100
+++ b/drivers/acpi/sbshc.c 2010-02-11 12:48:46.000000000 +0100
@@ -301,7 +301,7 @@ static int acpi_smbus_hc_remove(struct a
 	if (!device)
 		return -EINVAL;
 
-	hc = acpi_driver_data(device);
+	hc = device->driver_data;
 	acpi_ec_remove_query_handler(hc->ec, hc->query_bit);
 	kfree(hc);
 	device->driver_data = NULL;
diff -u -p a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
--- a/drivers/acpi/thermal.c 2009-12-03 14:09:47.000000000 +0100
+++ b/drivers/acpi/thermal.c 2010-02-11 12:48:47.000000000 +0100
@@ -1215,7 +1215,7 @@ static int acpi_thermal_add_fs(struct ac
 	entry = proc_create_data(ACPI_THERMAL_FILE_STATE,
 				 S_IRUGO, acpi_device_dir(device),
 				 &acpi_thermal_state_fops,
-				 acpi_driver_data(device));
+				 device->driver_data);
 	if (!entry)
 		return -ENODEV;
 
@@ -1223,7 +1223,7 @@ static int acpi_thermal_add_fs(struct ac
 	entry = proc_create_data(ACPI_THERMAL_FILE_TEMPERATURE,
 				 S_IRUGO, acpi_device_dir(device),
 				 &acpi_thermal_temp_fops,
-				 acpi_driver_data(device));
+				 device->driver_data);
 	if (!entry)
 		return -ENODEV;
 
@@ -1232,7 +1232,7 @@ static int acpi_thermal_add_fs(struct ac
 				 S_IRUGO,
 				 acpi_device_dir(device),
 				 &acpi_thermal_trip_fops,
-				 acpi_driver_data(device));
+				 device->driver_data);
 	if (!entry)
 		return -ENODEV;
 
@@ -1241,7 +1241,7 @@ static int acpi_thermal_add_fs(struct ac
 				 S_IFREG | S_IRUGO | S_IWUSR,
 				 acpi_device_dir(device),
 				 &acpi_thermal_cooling_fops,
-				 acpi_driver_data(device));
+				 device->driver_data);
 	if (!entry)
 		return -ENODEV;
 
@@ -1250,7 +1250,7 @@ static int acpi_thermal_add_fs(struct ac
 				 S_IFREG | S_IRUGO | S_IWUSR,
 				 acpi_device_dir(device),
 				 &acpi_thermal_polling_fops,
-				 acpi_driver_data(device));
+				 device->driver_data);
 	if (!entry)
 		return -ENODEV;
 	return 0;
@@ -1283,7 +1283,7 @@ static int acpi_thermal_remove_fs(struct
 
 static void acpi_thermal_notify(struct acpi_device *device, u32 event)
 {
-	struct acpi_thermal *tz = acpi_driver_data(device);
+	struct acpi_thermal *tz = device->driver_data;
 
 
 	if (!tz)
@@ -1417,10 +1417,10 @@ static int acpi_thermal_remove(struct ac
 {
 	struct acpi_thermal *tz = NULL;
 
-	if (!device || !acpi_driver_data(device))
+	if (!device || !device->driver_data)
 		return -EINVAL;
 
-	tz = acpi_driver_data(device);
+	tz = device->driver_data;
 
 	acpi_thermal_remove_fs(device);
 	acpi_thermal_unregister_thermal_zone(tz);
@@ -1435,10 +1435,10 @@ static int acpi_thermal_resume(struct ac
 	int i, j, power_state, result;
 
 
-	if (!device || !acpi_driver_data(device))
+	if (!device || !device->driver_data)
 		return -EINVAL;
 
-	tz = acpi_driver_data(device);
+	tz = device->driver_data;
 
 	for (i = 0; i < ACPI_THERMAL_MAX_ACTIVE; i++) {
 		if (!(&tz->trips.active[i]))
diff -u -p a/drivers/acpi/video.c b/drivers/acpi/video.c
--- a/drivers/acpi/video.c 2010-01-29 18:29:07.000000000 +0100
+++ b/drivers/acpi/video.c 2010-02-11 12:48:47.000000000 +0100
@@ -400,7 +400,7 @@ static int video_get_max_state(struct th
 			       long *state)
 {
 	struct acpi_device *device = cooling_dev->devdata;
-	struct acpi_video_device *video = acpi_driver_data(device);
+	struct acpi_video_device *video = device->driver_data;
 
 	*state = video->brightness->count - 3;
 	return 0;
@@ -410,7 +410,7 @@ static int video_get_cur_state(struct th
 			       long *state)
 {
 	struct acpi_device *device = cooling_dev->devdata;
-	struct acpi_video_device *video = acpi_driver_data(device);
+	struct acpi_video_device *video = device->driver_data;
 	unsigned long long level;
 	int offset;
 
@@ -429,7 +429,7 @@ static int
 video_set_cur_state(struct thermal_cooling_device *cooling_dev, unsigned long state)
 {
 	struct acpi_device *device = cooling_dev->devdata;
-	struct acpi_video_device *video = acpi_driver_data(device);
+	struct acpi_video_device *video = device->driver_data;
 	int level;
 
 	if ( state >= video->brightness->count - 2)
@@ -1358,7 +1358,7 @@ static int acpi_video_device_add_fs(stru
 	struct proc_dir_entry *entry, *device_dir;
 	struct acpi_video_device *vid_dev;
 
-	vid_dev = acpi_driver_data(device);
+	vid_dev = device->driver_data;
 	if (!vid_dev)
 		return -ENODEV;
 
@@ -1369,7 +1369,7 @@ static int acpi_video_device_add_fs(stru
 
 	/* 'info' [R] */
 	entry = proc_create_data("info", S_IRUGO, device_dir,
-			&acpi_video_device_info_fops, acpi_driver_data(device));
+			&acpi_video_device_info_fops, device->driver_data);
 	if (!entry)
 		goto err_remove_dir;
 
@@ -1377,7 +1377,7 @@ static int acpi_video_device_add_fs(stru
 	entry = proc_create_data("state", S_IFREG | S_IRUGO | S_IWUSR,
 				 device_dir,
 				 &acpi_video_device_state_fops,
-				 acpi_driver_data(device));
+				 device->driver_data);
 	if (!entry)
 		goto err_remove_info;
 
@@ -1385,14 +1385,14 @@ static int acpi_video_device_add_fs(stru
 	entry = proc_create_data("brightness", S_IFREG | S_IRUGO | S_IWUSR,
 				 device_dir,
 				 &acpi_video_device_brightness_fops,
-				 acpi_driver_data(device));
+				 device->driver_data);
 	if (!entry)
 		goto err_remove_state;
 
 	/* 'EDID' [R] */
 	entry = proc_create_data("EDID", S_IRUGO, device_dir,
 				 &acpi_video_device_EDID_fops,
-				 acpi_driver_data(device));
+				 device->driver_data);
 	if (!entry)
 		goto err_remove_brightness;
 
@@ -1416,7 +1416,7 @@ static int acpi_video_device_remove_fs(s
 	struct acpi_video_device *vid_dev;
 	struct proc_dir_entry *device_dir;
 
-	vid_dev = acpi_driver_data(device);
+	vid_dev = device->driver_data;
 	if (!vid_dev || !vid_dev->video || !vid_dev->video->dir)
 		return -ENODEV;
 
@@ -1632,7 +1632,7 @@ acpi_video_bus_write_DOS(struct file *fi
 
 static int acpi_video_bus_add_fs(struct acpi_device *device)
 {
-	struct acpi_video_bus *video = acpi_driver_data(device);
+	struct acpi_video_bus *video = device->driver_data;
 	struct proc_dir_entry *device_dir;
 	struct proc_dir_entry *entry;
 
@@ -1643,21 +1643,21 @@ static int acpi_video_bus_add_fs(struct 
 	/* 'info' [R] */
 	entry = proc_create_data("info", S_IRUGO, device_dir,
 				 &acpi_video_bus_info_fops,
-				 acpi_driver_data(device));
+				 device->driver_data);
 	if (!entry)
 		goto err_remove_dir;
 
 	/* 'ROM' [R] */
 	entry = proc_create_data("ROM", S_IRUGO, device_dir,
 				 &acpi_video_bus_ROM_fops,
-				 acpi_driver_data(device));
+				 device->driver_data);
 	if (!entry)
 		goto err_remove_info;
 
 	/* 'POST_info' [R] */
 	entry = proc_create_data("POST_info", S_IRUGO, device_dir,
 				 &acpi_video_bus_POST_info_fops,
-				 acpi_driver_data(device));
+				 device->driver_data);
 	if (!entry)
 		goto err_remove_rom;
 
@@ -1665,7 +1665,7 @@ static int acpi_video_bus_add_fs(struct 
 	entry = proc_create_data("POST", S_IFREG | S_IRUGO | S_IWUSR,
 				 device_dir,
 				 &acpi_video_bus_POST_fops,
-				 acpi_driver_data(device));
+				 device->driver_data);
 	if (!entry)
 		goto err_remove_post_info;
 
@@ -1673,7 +1673,7 @@ static int acpi_video_bus_add_fs(struct 
 	entry = proc_create_data("DOS", S_IFREG | S_IRUGO | S_IWUSR,
 				 device_dir,
 				 &acpi_video_bus_DOS_fops,
-				 acpi_driver_data(device));
+				 device->driver_data);
 	if (!entry)
 		goto err_remove_post;
 
@@ -2111,7 +2111,7 @@ static int acpi_video_bus_stop_devices(s
 
 static void acpi_video_bus_notify(struct acpi_device *device, u32 event)
 {
-	struct acpi_video_bus *video = acpi_driver_data(device);
+	struct acpi_video_bus *video = device->driver_data;
 	struct input_dev *input;
 	int keycode;
 
@@ -2233,10 +2233,10 @@ static int acpi_video_resume(struct acpi
 	struct acpi_video_device *video_device;
 	int i;
 
-	if (!device || !acpi_driver_data(device))
+	if (!device || !device->driver_data)
 		return -EINVAL;
 
-	video = acpi_driver_data(device);
+	video = device->driver_data;
 
 	for (i = 0; i < video->attached_count; i++) {
 		video_device = video->attached_array[i].bind_info;
@@ -2381,10 +2381,10 @@ static int acpi_video_bus_remove(struct 
 	struct acpi_video_bus *video = NULL;
 
 
-	if (!device || !acpi_driver_data(device))
+	if (!device || !device->driver_data)
 		return -EINVAL;
 
-	video = acpi_driver_data(device);
+	video = device->driver_data;
 
 	acpi_video_bus_stop_devices(video);
 	acpi_video_bus_put_devices(video);
diff -u -p a/drivers/i2c/busses/i2c-scmi.c b/drivers/i2c/busses/i2c-scmi.c
--- a/drivers/i2c/busses/i2c-scmi.c 2009-12-03 14:09:47.000000000 +0100
+++ b/drivers/i2c/busses/i2c-scmi.c 2010-02-11 12:48:47.000000000 +0100
@@ -409,7 +409,7 @@ err:
 
 static int acpi_smbus_cmi_remove(struct acpi_device *device, int type)
 {
-	struct acpi_smbus_cmi *smbus_cmi = acpi_driver_data(device);
+	struct acpi_smbus_cmi *smbus_cmi = device->driver_data;
 
 	i2c_del_adapter(&smbus_cmi->adapter);
 	kfree(smbus_cmi);
diff -u -p a/drivers/platform/x86/asus_acpi.c b/drivers/platform/x86/asus_acpi.c
--- a/drivers/platform/x86/asus_acpi.c 2009-12-29 11:37:46.000000000 +0100
+++ b/drivers/platform/x86/asus_acpi.c 2010-02-11 12:48:46.000000000 +0100
@@ -1063,7 +1063,7 @@ asus_proc_add(char *name, const struct f
 	struct proc_dir_entry *proc;
 
 	proc = proc_create_data(name, mode, acpi_device_dir(device),
-				proc_fops, acpi_driver_data(device));
+				proc_fops, device->driver_data);
 	if (!proc) {
 		printk(KERN_WARNING "  Unable to create %s fs entry\n", name);
 		return -1;
diff -u -p a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
--- a/drivers/platform/x86/eeepc-laptop.c 2010-01-20 13:04:06.000000000 +0100
+++ b/drivers/platform/x86/eeepc-laptop.c 2010-02-11 12:48:46.000000000 +0100
@@ -1193,7 +1193,7 @@ static void eeepc_input_exit(struct eeep
  */
 static void eeepc_acpi_notify(struct acpi_device *device, u32 event)
 {
-	struct eeepc_laptop *eeepc = acpi_driver_data(device);
+	struct eeepc_laptop *eeepc = device->driver_data;
 	u16 count;
 
 	if (event > ACPI_MAX_SYS_NOTIFY)
@@ -1433,7 +1433,7 @@ fail_platform:
 
 static int eeepc_acpi_remove(struct acpi_device *device, int type)
 {
-	struct eeepc_laptop *eeepc = acpi_driver_data(device);
+	struct eeepc_laptop *eeepc = device->driver_data;
 
 	eeepc_backlight_exit(eeepc);
 	eeepc_rfkill_exit(eeepc);
diff -u -p a/drivers/platform/x86/fujitsu-laptop.c b/drivers/platform/x86/fujitsu-laptop.c
--- a/drivers/platform/x86/fujitsu-laptop.c 2009-12-24 11:27:00.000000000 +0100
+++ b/drivers/platform/x86/fujitsu-laptop.c 2010-02-11 12:48:46.000000000 +0100
@@ -732,7 +732,7 @@ err_stop:
 
 static int acpi_fujitsu_remove(struct acpi_device *device, int type)
 {
-	struct fujitsu_t *fujitsu = acpi_driver_data(device);
+	struct fujitsu_t *fujitsu = device->driver_data;
 	struct input_dev *input = fujitsu->input;
 
 	input_unregister_device(input);
@@ -939,7 +939,7 @@ err_stop:
 
 static int acpi_fujitsu_hotkey_remove(struct acpi_device *device, int type)
 {
-	struct fujitsu_hotkey_t *fujitsu_hotkey = acpi_driver_data(device);
+	struct fujitsu_hotkey_t *fujitsu_hotkey = device->driver_data;
 	struct input_dev *input = fujitsu_hotkey->input;
 
 #if defined(CONFIG_LEDS_CLASS) || defined(CONFIG_LEDS_CLASS_MODULE)
diff -u -p a/drivers/platform/x86/intel_menlow.c b/drivers/platform/x86/intel_menlow.c
--- a/drivers/platform/x86/intel_menlow.c 2009-12-03 14:09:48.000000000 +0100
+++ b/drivers/platform/x86/intel_menlow.c 2010-02-11 12:48:46.000000000 +0100
@@ -198,7 +198,7 @@ static int intel_menlow_memory_add(struc
 
 static int intel_menlow_memory_remove(struct acpi_device *device, int type)
 {
-	struct thermal_cooling_device *cdev = acpi_driver_data(device);
+	struct thermal_cooling_device *cdev = device->driver_data;
 
 	if (!device || !cdev)
 		return -EINVAL;
diff -u -p a/drivers/platform/x86/panasonic-laptop.c b/drivers/platform/x86/panasonic-laptop.c
--- a/drivers/platform/x86/panasonic-laptop.c 2009-04-13 16:04:30.000000000 +0200
+++ b/drivers/platform/x86/panasonic-laptop.c 2010-02-11 12:48:46.000000000 +0100
@@ -364,7 +364,7 @@ static ssize_t show_numbatt(struct devic
 			    char *buf)
 {
 	struct acpi_device *acpi = to_acpi_device(dev);
-	struct pcc_acpi *pcc = acpi_driver_data(acpi);
+	struct pcc_acpi *pcc = acpi->driver_data;
 
 	if (!acpi_pcc_retrieve_biosdata(pcc, pcc->sinf))
 		return -EIO;
@@ -376,7 +376,7 @@ static ssize_t show_lcdtype(struct devic
 			    char *buf)
 {
 	struct acpi_device *acpi = to_acpi_device(dev);
-	struct pcc_acpi *pcc = acpi_driver_data(acpi);
+	struct pcc_acpi *pcc = acpi->driver_data;
 
 	if (!acpi_pcc_retrieve_biosdata(pcc, pcc->sinf))
 		return -EIO;
@@ -388,7 +388,7 @@ static ssize_t show_mute(struct device *
 			 char *buf)
 {
 	struct acpi_device *acpi = to_acpi_device(dev);
-	struct pcc_acpi *pcc = acpi_driver_data(acpi);
+	struct pcc_acpi *pcc = acpi->driver_data;
 
 	if (!acpi_pcc_retrieve_biosdata(pcc, pcc->sinf))
 		return -EIO;
@@ -400,7 +400,7 @@ static ssize_t show_sticky(struct device
 			   char *buf)
 {
 	struct acpi_device *acpi = to_acpi_device(dev);
-	struct pcc_acpi *pcc = acpi_driver_data(acpi);
+	struct pcc_acpi *pcc = acpi->driver_data;
 
 	if (!acpi_pcc_retrieve_biosdata(pcc, pcc->sinf))
 		return -EIO;
@@ -412,7 +412,7 @@ static ssize_t set_sticky(struct device 
 			  const char *buf, size_t count)
 {
 	struct acpi_device *acpi = to_acpi_device(dev);
-	struct pcc_acpi *pcc = acpi_driver_data(acpi);
+	struct pcc_acpi *pcc = acpi->driver_data;
 	int val;
 
 	if (count && sscanf(buf, "%i", &val) == 1 &&
@@ -531,7 +531,7 @@ static void acpi_pcc_generate_keyinput(s
 
 static void acpi_pcc_hotkey_notify(struct acpi_device *device, u32 event)
 {
-	struct pcc_acpi *pcc = acpi_driver_data(device);
+	struct pcc_acpi *pcc = device->driver_data;
 
 	switch (event) {
 	case HKEY_NOTIFY:
@@ -585,7 +585,7 @@ static int acpi_pcc_init_input(struct pc
 
 static int acpi_pcc_hotkey_resume(struct acpi_device *device)
 {
-	struct pcc_acpi *pcc = acpi_driver_data(device);
+	struct pcc_acpi *pcc = device->driver_data;
 	acpi_status status = AE_OK;
 
 	if (device == NULL || pcc == NULL)
@@ -701,7 +701,7 @@ static int __init acpi_pcc_init(void)
 
 static int acpi_pcc_hotkey_remove(struct acpi_device *device, int type)
 {
-	struct pcc_acpi *pcc = acpi_driver_data(device);
+	struct pcc_acpi *pcc = device->driver_data;
 
 	if (!device || !pcc)
 		return -EINVAL;
diff -u -p a/drivers/platform/x86/topstar-laptop.c b/drivers/platform/x86/topstar-laptop.c
--- a/drivers/platform/x86/topstar-laptop.c 2009-09-23 13:12:24.000000000 +0200
+++ b/drivers/platform/x86/topstar-laptop.c 2010-02-11 12:48:47.000000000 +0100
@@ -73,7 +73,7 @@ static void acpi_topstar_notify(struct a
 	struct tps_key_entry *key;
 	static bool dup_evnt[2];
 	bool *dup;
-	struct topstar_hkey *hkey = acpi_driver_data(device);
+	struct topstar_hkey *hkey = device->driver_data;
 
 	/* 0x83 and 0x84 key events comes duplicated... */
 	if (event == 0x83 || event == 0x84) {
@@ -212,7 +212,7 @@ add_err:
 
 static int acpi_topstar_remove(struct acpi_device *device, int type)
 {
-	struct topstar_hkey *tps_hkey = acpi_driver_data(device);
+	struct topstar_hkey *tps_hkey = device->driver_data;
 
 	acpi_topstar_fncx_switch(device, false);
 
