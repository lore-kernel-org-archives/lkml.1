Return-Path: <linux-kernel-owner+w=401wt.eu-S1754157AbYIKAbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157AbYIKAbx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 20:31:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752297AbYIKAbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 20:31:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45536 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752067AbYIKAbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 20:31:41 -0400
Date: Wed, 10 Sep 2008 17:31:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Machek <pavel@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       ak@linux.intel.com, hare@suse.de
Subject: Re: catch calls of acpi_driver_data on pointer of wrong type
Message-Id: <20080910173102.53e19f92.akpm@linux-foundation.org>
In-Reply-To: <20080910141151.GA13669@elf.ucw.cz>
References: <20080910141151.GA13669@elf.ucw.cz>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Sep 2008 16:11:51 +0200
Pavel Machek <pavel@suse.cz> wrote:

> 
> Catch attempts to use of acpi_driver_data on pointers of wrong type.
> 
> Signed-off-by: Pavel Machek <pavel@suse.cz>
> Cc: Hannes Reinecke <hare@suse.de>
> 
> ---
> commit 76c9074075cd9208cf386f37ebd932a00557643a
> tree 02589a15c23f430c7728560e4ba51077d41a6eff
> parent d4a51ebfa2ffc3320d7eab269dc1ca84e86719f5
> author Pavel <pavel@amd.ucw.cz> Wed, 10 Sep 2008 16:10:28 +0200
> committer Pavel <pavel@amd.ucw.cz> Wed, 10 Sep 2008 16:10:28 +0200
> 
>  include/acpi/acpi_bus.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
> index a5ac0bc..641656e 100644
> --- a/include/acpi/acpi_bus.h
> +++ b/include/acpi/acpi_bus.h
> @@ -300,7 +300,7 @@ struct acpi_device {
>  	enum acpi_bus_removal_type removal_type;	/* indicate for different removal type */
>  };
>  
> -#define acpi_driver_data(d)	((d)->driver_data)
> +#define acpi_driver_data(d)	((void) (d == (struct acpi_device *) 0), d)->driver_data
>  #define to_acpi_device(d)	container_of(d, struct acpi_device, dev)
>  #define to_acpi_driver(d)	container_of(d, struct acpi_driver, drv)
>  

Let us not try to implement a C compiler in cpp, for that is perverse.

Behold my amazingness:

static inline void *acpi_driver_data(struct acpi_device *d)
{
	return d->driver_data;
}


Implementing this requires that we fix all the idiotic crap which uses
acpi_driver_data() as an lvalue, but fixing idiotic crap is rarely a
bad thing, no?

Something like this...

 drivers/acpi/ac.c             |    2 +-
 drivers/acpi/asus_acpi.c      |    2 +-
 drivers/acpi/battery.c        |    2 +-
 drivers/acpi/button.c         |    2 +-
 drivers/acpi/container.c      |    2 +-
 drivers/acpi/ec.c             |    4 ++--
 drivers/acpi/fan.c            |    2 +-
 drivers/acpi/pcc_acpi.c       |    2 +-
 drivers/acpi/pci_link.c       |    2 +-
 drivers/acpi/pci_root.c       |    2 +-
 drivers/acpi/power.c          |    4 ++--
 drivers/acpi/processor_core.c |    2 +-
 drivers/acpi/sbs.c            |    2 +-
 drivers/acpi/sbshc.c          |    4 ++--
 drivers/acpi/scan.c           |    4 ++--
 drivers/acpi/thermal.c        |    2 +-
 drivers/acpi/video.c          |    6 +++---
 include/acpi/acpi_bus.h       |    6 +++++-
 18 files changed, 28 insertions(+), 24 deletions(-)

diff -puN include/acpi/acpi_bus.h~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix include/acpi/acpi_bus.h
--- a/include/acpi/acpi_bus.h~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix
+++ a/include/acpi/acpi_bus.h
@@ -300,7 +300,11 @@ struct acpi_device {
 	enum acpi_bus_removal_type removal_type;	/* indicate for different removal type */
 };
 
-#define acpi_driver_data(d)	((void) (d == (struct acpi_device *) 0), d)->driver_data
+static inline void *acpi_driver_data(struct acpi_device *d)
+{
+	return d->driver_data;
+}
+
 #define to_acpi_device(d)	container_of(d, struct acpi_device, dev)
 #define to_acpi_driver(d)	container_of(d, struct acpi_driver, drv)
 
diff -puN drivers/acpi/scan.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix drivers/acpi/scan.c
--- a/drivers/acpi/scan.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix
+++ a/drivers/acpi/scan.c
@@ -391,7 +391,7 @@ static int acpi_device_remove(struct dev
 			acpi_drv->ops.remove(acpi_dev, acpi_dev->removal_type);
 	}
 	acpi_dev->driver = NULL;
-	acpi_driver_data(dev) = NULL;
+	dev->driver_data = NULL;
 
 	put_device(dev);
 	return 0;
@@ -545,7 +545,7 @@ acpi_bus_driver_init(struct acpi_device 
 	result = driver->ops.add(device);
 	if (result) {
 		device->driver = NULL;
-		acpi_driver_data(device) = NULL;
+		device->driver_data = NULL;
 		return result;
 	}
 
diff -puN drivers/acpi/ec.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix drivers/acpi/ec.c
--- a/drivers/acpi/ec.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix
+++ a/drivers/acpi/ec.c
@@ -792,7 +792,7 @@ static int acpi_ec_add(struct acpi_devic
 
 	if (!first_ec)
 		first_ec = ec;
-	acpi_driver_data(device) = ec;
+	device->driver_data = ec;
 	acpi_ec_add_fs(device);
 	pr_info(PREFIX "GPE = 0x%lx, I/O: command/status = 0x%lx, data = 0x%lx\n",
 			  ec->gpe, ec->command_addr, ec->data_addr);
@@ -817,7 +817,7 @@ static int acpi_ec_remove(struct acpi_de
 	}
 	mutex_unlock(&ec->lock);
 	acpi_ec_remove_fs(device);
-	acpi_driver_data(device) = NULL;
+	device->driver_data = NULL;
 	if (ec == first_ec)
 		first_ec = NULL;
 	kfree(ec);
diff -puN drivers/acpi/pci_root.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix drivers/acpi/pci_root.c
--- a/drivers/acpi/pci_root.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix
+++ a/drivers/acpi/pci_root.c
@@ -206,7 +206,7 @@ static int __devinit acpi_pci_root_add(s
 	root->device = device;
 	strcpy(acpi_device_name(device), ACPI_PCI_ROOT_DEVICE_NAME);
 	strcpy(acpi_device_class(device), ACPI_PCI_ROOT_CLASS);
-	acpi_driver_data(device) = root;
+	device->driver_data = root;
 
 	device->ops.bind = acpi_pci_bind;
 
diff -puN drivers/acpi/pci_link.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix drivers/acpi/pci_link.c
--- a/drivers/acpi/pci_link.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix
+++ a/drivers/acpi/pci_link.c
@@ -737,7 +737,7 @@ static int acpi_pci_link_add(struct acpi
 	link->device = device;
 	strcpy(acpi_device_name(device), ACPI_PCI_LINK_DEVICE_NAME);
 	strcpy(acpi_device_class(device), ACPI_PCI_LINK_CLASS);
-	acpi_driver_data(device) = link;
+	device->driver_data = link;
 
 	mutex_lock(&acpi_link_lock);
 	result = acpi_pci_link_get_possible(link);
diff -puN drivers/acpi/power.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix drivers/acpi/power.c
--- a/drivers/acpi/power.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix
+++ a/drivers/acpi/power.c
@@ -679,7 +679,7 @@ static int acpi_power_add(struct acpi_de
 	strcpy(resource->name, device->pnp.bus_id);
 	strcpy(acpi_device_name(device), ACPI_POWER_DEVICE_NAME);
 	strcpy(acpi_device_class(device), ACPI_POWER_CLASS);
-	acpi_driver_data(device) = resource;
+	device->driver_data = resource;
 
 	/* Evalute the object to get the system level and resource order. */
 	status = acpi_evaluate_object(device->handle, NULL, NULL, &buffer);
@@ -755,7 +755,7 @@ static int acpi_power_resume(struct acpi
 	if (!device || !acpi_driver_data(device))
 		return -EINVAL;
 
-	resource = (struct acpi_power_resource *)acpi_driver_data(device);
+	resource = acpi_driver_data(device);
 
 	result = acpi_power_get_state(device->handle, &state);
 	if (result)
diff -puN drivers/acpi/ac.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix drivers/acpi/ac.c
--- a/drivers/acpi/ac.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix
+++ a/drivers/acpi/ac.c
@@ -269,7 +269,7 @@ static int acpi_ac_add(struct acpi_devic
 	ac->device = device;
 	strcpy(acpi_device_name(device), ACPI_AC_DEVICE_NAME);
 	strcpy(acpi_device_class(device), ACPI_AC_CLASS);
-	acpi_driver_data(device) = ac;
+	device->driver_data = ac;
 
 	result = acpi_ac_get_state(ac);
 	if (result)
diff -puN drivers/acpi/button.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix drivers/acpi/button.c
--- a/drivers/acpi/button.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix
+++ a/drivers/acpi/button.c
@@ -384,7 +384,7 @@ static int acpi_button_add(struct acpi_d
 		return -ENOMEM;
 
 	button->device = device;
-	acpi_driver_data(device) = button;
+	device->driver_data = button;
 
 	button->input = input = input_allocate_device();
 	if (!input) {
diff -puN drivers/acpi/battery.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix drivers/acpi/battery.c
--- a/drivers/acpi/battery.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix
+++ a/drivers/acpi/battery.c
@@ -804,7 +804,7 @@ static int acpi_battery_add(struct acpi_
 	battery->device = device;
 	strcpy(acpi_device_name(device), ACPI_BATTERY_DEVICE_NAME);
 	strcpy(acpi_device_class(device), ACPI_BATTERY_CLASS);
-	acpi_driver_data(device) = battery;
+	device->driver_data = battery;
 	mutex_init(&battery->lock);
 	acpi_battery_update(battery);
 #ifdef CONFIG_ACPI_PROCFS_POWER
diff -puN drivers/acpi/fan.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix drivers/acpi/fan.c
--- a/drivers/acpi/fan.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix
+++ a/drivers/acpi/fan.c
@@ -265,7 +265,7 @@ static int acpi_fan_add(struct acpi_devi
 
 	dev_info(&device->dev, "registered as cooling_device%d\n", cdev->id);
 
-	acpi_driver_data(device) = cdev;
+	device->driver_data = cdev;
 	result = sysfs_create_link(&device->dev.kobj,
 				   &cdev->device.kobj,
 				   "thermal_cooling");
diff -puN drivers/acpi/video.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix drivers/acpi/video.c
--- a/drivers/acpi/video.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix
+++ a/drivers/acpi/video.c
@@ -1500,7 +1500,7 @@ acpi_video_bus_get_one_device(struct acp
 
 		strcpy(acpi_device_name(device), ACPI_VIDEO_DEVICE_NAME);
 		strcpy(acpi_device_class(device), ACPI_VIDEO_CLASS);
-		acpi_driver_data(device) = data;
+		device->driver_data = data;
 
 		data->device_id = device_id;
 		data->video = video;
@@ -1990,7 +1990,7 @@ static int acpi_video_bus_add(struct acp
 	video->device = device;
 	strcpy(acpi_device_name(device), ACPI_VIDEO_BUS_NAME);
 	strcpy(acpi_device_class(device), ACPI_VIDEO_CLASS);
-	acpi_driver_data(device) = video;
+	device->driver_data = video;
 
 	acpi_video_bus_find_cap(video);
 	error = acpi_video_bus_check(video);
@@ -2066,7 +2066,7 @@ static int acpi_video_bus_add(struct acp
 	acpi_video_bus_remove_fs(device);
  err_free_video:
 	kfree(video);
-	acpi_driver_data(device) = NULL;
+	device->driver_data = NULL;
 
 	return error;
 }
diff -puN drivers/acpi/processor_core.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix drivers/acpi/processor_core.c
--- a/drivers/acpi/processor_core.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix
+++ a/drivers/acpi/processor_core.c
@@ -818,7 +818,7 @@ static int acpi_processor_add(struct acp
 	pr->handle = device->handle;
 	strcpy(acpi_device_name(device), ACPI_PROCESSOR_DEVICE_NAME);
 	strcpy(acpi_device_class(device), ACPI_PROCESSOR_CLASS);
-	acpi_driver_data(device) = pr;
+	device->driver_data = pr;
 
 	return 0;
 }
diff -puN drivers/acpi/container.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix drivers/acpi/container.c
--- a/drivers/acpi/container.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix
+++ a/drivers/acpi/container.c
@@ -108,7 +108,7 @@ static int acpi_container_add(struct acp
 	container->handle = device->handle;
 	strcpy(acpi_device_name(device), ACPI_CONTAINER_DEVICE_NAME);
 	strcpy(acpi_device_class(device), ACPI_CONTAINER_CLASS);
-	acpi_driver_data(device) = container;
+	device->driver_data = container;
 
 	ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Device <%s> bid <%s>\n",
 			  acpi_device_name(device), acpi_device_bid(device)));
diff -puN drivers/acpi/thermal.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix drivers/acpi/thermal.c
--- a/drivers/acpi/thermal.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix
+++ a/drivers/acpi/thermal.c
@@ -1647,7 +1647,7 @@ static int acpi_thermal_add(struct acpi_
 	strcpy(tz->name, device->pnp.bus_id);
 	strcpy(acpi_device_name(device), ACPI_THERMAL_DEVICE_NAME);
 	strcpy(acpi_device_class(device), ACPI_THERMAL_CLASS);
-	acpi_driver_data(device) = tz;
+	device->driver_data = tz;
 	mutex_init(&tz->lock);
 
 
diff -puN drivers/acpi/asus_acpi.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix drivers/acpi/asus_acpi.c
--- a/drivers/acpi/asus_acpi.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix
+++ a/drivers/acpi/asus_acpi.c
@@ -1321,7 +1321,7 @@ static int asus_hotk_add(struct acpi_dev
 	hotk->handle = device->handle;
 	strcpy(acpi_device_name(device), ACPI_HOTK_DEVICE_NAME);
 	strcpy(acpi_device_class(device), ACPI_HOTK_CLASS);
-	acpi_driver_data(device) = hotk;
+	device->driver_data = hotk;
 	hotk->device = device;
 
 	result = asus_hotk_check();
diff -puN drivers/acpi/pcc_acpi.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix drivers/acpi/pcc_acpi.c
--- a/drivers/acpi/pcc_acpi.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix
+++ a/drivers/acpi/pcc_acpi.c
@@ -657,7 +657,7 @@ static int acpi_pcc_hotkey_add(struct ac
 	pcc->device = device;
 	pcc->handle = device->handle;
 	pcc->num_sifr = num_sifr;
-	acpi_driver_data(device) = pcc;
+	device->driver_data = pcc;
 	strcpy(acpi_device_name(device), ACPI_PCC_DEVICE_NAME);
 	strcpy(acpi_device_class(device), ACPI_PCC_CLASS);
 
diff -puN drivers/acpi/sbshc.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix drivers/acpi/sbshc.c
--- a/drivers/acpi/sbshc.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix
+++ a/drivers/acpi/sbshc.c
@@ -282,7 +282,7 @@ static int acpi_smbus_hc_add(struct acpi
 	hc->ec = acpi_driver_data(device->parent);
 	hc->offset = (val >> 8) & 0xff;
 	hc->query_bit = val & 0xff;
-	acpi_driver_data(device) = hc;
+	device->driver_data = hc;
 
 	acpi_ec_add_query_handler(hc->ec, hc->query_bit, NULL, smbus_alarm, hc);
 	printk(KERN_INFO PREFIX "SBS HC: EC = 0x%p, offset = 0x%0x, query_bit = 0x%0x\n",
@@ -303,7 +303,7 @@ static int acpi_smbus_hc_remove(struct a
 	hc = acpi_driver_data(device);
 	acpi_ec_remove_query_handler(hc->ec, hc->query_bit);
 	kfree(hc);
-	acpi_driver_data(device) = NULL;
+	device->driver_data = NULL;
 	return 0;
 }
 
diff -puN drivers/acpi/sbs.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix drivers/acpi/sbs.c
--- a/drivers/acpi/sbs.c~acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix
+++ a/drivers/acpi/sbs.c
@@ -931,7 +931,7 @@ static int acpi_sbs_add(struct acpi_devi
 	sbs->device = device;
 	strcpy(acpi_device_name(device), ACPI_SBS_DEVICE_NAME);
 	strcpy(acpi_device_class(device), ACPI_SBS_CLASS);
-	acpi_driver_data(device) = sbs;
+	device->driver_data = sbs;
 
 	result = acpi_charger_add(sbs);
 	if (result)
_

