Return-Path: <linux-kernel-owner+w=401wt.eu-S1756500AbYAJHQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756500AbYAJHQW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 02:16:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752770AbYAJHQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 02:16:11 -0500
Received: from mga02.intel.com ([134.134.136.20]:4282 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752759AbYAJHQJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 02:16:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,265,1196668800"; 
   d="scan'208";a="320268594"
Subject: [PATCH] ACPI: Add sysfs interface for acpi device wakeup
From: Yi Yang <yi.y.yang@intel.com>
Reply-To: yi.y.yang@intel.com
To: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, lenb@kernel.org,
       acpi-bugzilla@lists.sourceforge.net
In-Reply-To: <1199688961.3551.19.camel@yangyi-dev.bj.intel.com>
References: <1198738022.8950.3.camel@yangyi-dev.bj.intel.com>
	 <1198744900.3640.4.camel@yangyi-dev.bj.intel.com>
	 <1198916553.3806.2.camel@yangyi-dev.bj.intel.com>
	 <1199434602.19185.1.camel@yangyi-dev.bj.intel.com>
	 <1199688961.3551.19.camel@yangyi-dev.bj.intel.com>
Content-Type: text/plain
Organization: Intel
Date: Thu, 10 Jan 2008 06:21:46 +0800
Message-Id: <1199917306.9596.3.camel@yangyi-dev.bj.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: ACPI: convert procfs to sysfs for /proc/acpi/wakeup
From: Yi Yang <yi.y.yang@intel.com>

/proc/acpi/wakeup is deprecated but it has to exist because
we haven't a sysfs interface to replace it yet, this patch
converts /proc/acpi/wakeup to sysfs interface, under every
acpi device sysfs node, a user can see a directory "wakeup"
if the acpi device can support wakeup, there are six files
under this directory:

acpi_bus_id  bus_id  pci_id  run_wakeup  sleep_state  status

All the files are read-only exclude "status" which is used
to enable or disable wakeup of the acpi device.

"acpi_bus_id" is acpi bus ID of the acpi device.

"bus_id" is pci bus id of the device associated to the acpi
device, it will be empty if there isn't any device associated
to it.

"pci_id" is PCI ID of the pci device associated to the acpi
device, it will be empty if there isn't any device associated
to it.

"run_wake" is a flag indicating if a wakeup process is being
handled.

"sleep_state" is sleep state of the acpi device such as "S0".

"status" is wakeup status of the acpi device, it is enabled
or disabled, a user can change it be echoing "0", "1",
"disabled" or "enabled" to /sys/devices/.../wakeup/status. 

Here is the test result:

[root@localhost ~]# cat /proc/acpi/wakeup
Device  S-state   Status   Sysfs node           PCI ID
C093      S5     disabled  pci:0000:00:1e.0     0x2448
C0E8      S3     disabled  pci:0000:00:1d.0     0x27c8
C0EF      S3     disabled  pci:0000:00:1d.1     0x27c9
C0F0      S3     disabled  pci:0000:00:1d.2     0x27ca
C0F1      S3     disabled  pci:0000:00:1d.3     0x27cb
C0F2      S3     disabled  pci:0000:00:1d.7     0x27cc
C0F9      S0     disabled  pci:0000:00:1c.0     0x27d0
C21D      S0     disabled  pci:0000:08:00.0     0x16fd
C109      S5     disabled  pci:0000:00:1c.1     0x27d2
C228      S5     disabled  pci:0000:10:00.0     0x4222
C10F      S5     disabled  pci:0000:00:1c.3     0x27d6
C229      S5     disabled
[root@localhost ~]# find /sys -name "*" | grep sleep_state
/sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:05/wakeup/sleep_state
/sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:0d/wakeup/sleep_state
/sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:11/wakeup/sleep_state
/sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:15/wakeup/sleep_state
/sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:19/wakeup/sleep_state
/sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:1d/wakeup/sleep_state
/sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:2b/wakeup/sleep_state
/sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:2b/device:2c/wakeup/sleep_state
/sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:2d/wakeup/sleep_state
/sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:2d/device:2e/wakeup/sleep_state
/sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:2f/wakeup/sleep_state
/sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:2f/device:30/wakeup/sleep_state
[root@localhost ~]# ls /sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:2f/device:30/wakeup
acpi_bus_id  bus_id  pci_id  run_wakeup  sleep_state  status
[root@localhost ~]# cat /sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:2f/device:30/acpi_bus_id
cat: /sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:2f/device:30/acpi_bus_id: No such file or directory
[root@localhost ~]# cat /sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:2f/device:30/wakeup/acpi_bus_id
C229
[root@localhost ~]# cat /sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:2f/device:30/wakeup/sleep_state
S5
[root@localhost ~]# cat /sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:2f/device:30/wakeup/status
disabled
[root@localhost ~]# cat /sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:2f/device:30/wakeup/bus_id

[root@localhost ~]# cat /sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:2f/device:30/wakeup/pci_id

[root@localhost ~]# echo 1 > /sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:2f/device:30/wakeup/status
[root@localhost ~]# cat /sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:2f/device:30/wakeup/status
enabled
[root@localhost ~]# cat /proc/acpi/wakeup
Device  S-state   Status   Sysfs node           PCI ID
C093      S5     disabled  pci:0000:00:1e.0     0x2448
C0E8      S3     disabled  pci:0000:00:1d.0     0x27c8
C0EF      S3     disabled  pci:0000:00:1d.1     0x27c9
C0F0      S3     disabled  pci:0000:00:1d.2     0x27ca
C0F1      S3     disabled  pci:0000:00:1d.3     0x27cb
C0F2      S3     disabled  pci:0000:00:1d.7     0x27cc
C0F9      S0     enabled   pci:0000:00:1c.0     0x27d0
C21D      S0     enabled   pci:0000:08:00.0     0x16fd
C109      S5     enabled   pci:0000:00:1c.1     0x27d2
C228      S5     enabled   pci:0000:10:00.0     0x4222
C10F      S5     enabled   pci:0000:00:1c.3     0x27d6
C229      S5     enabled
[root@localhost ~]# vi /var/log/dmesg
[root@localhost ~]# dmesg | grep "same GPE"
ACPI: 'C0F9' and 'C229' have the same GPE, can't disable/enable one seperately
ACPI: 'C21D' and 'C229' have the same GPE, can't disable/enable one seperately
ACPI: 'C109' and 'C229' have the same GPE, can't disable/enable one seperately
ACPI: 'C228' and 'C229' have the same GPE, can't disable/enable one seperately
ACPI: 'C10F' and 'C229' have the same GPE, can't disable/enable one seperately
[root@localhost ~]# cat /sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/*/wakeup/status
disabled
disabled
disabled
disabled
disabled
disabled
enabled
enabled
enabled
[root@localhost ~]# cat /sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/*/*/wakeup/status
enabled
enabled
enabled
[root@localhost ~]#


Signed-off-by: Yi Yang <yi.y.yang@intel.com>
---
 scan.c |  184 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 180 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 5b4d462..c3786a0 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -6,8 +6,10 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/acpi.h>
+#include <linux/pci.h>
 
 #include <acpi/acpi_drivers.h>
+#include <acpi/acpi_bus.h>
 #include <acpi/acinterp.h>	/* for acpi_ex_eisa_id_to_string() */
 
 #define _COMPONENT		ACPI_BUS_COMPONENT
@@ -188,8 +190,171 @@ acpi_device_path_show(struct device *dev, struct device_attribute *attr, char *b
   end:
 	return result;
 }
+
 static DEVICE_ATTR(path, 0444, acpi_device_path_show, NULL);
 
+static char enabled[] = "enabled";
+static char disabled[] = "disabled";
+static char unsupported[] = "unsupported";
+
+static ssize_t
+acpi_device_status_show(struct device *dev, struct device_attribute *attr,
+			char *buf)
+{
+	struct acpi_device *acpi_dev = to_acpi_device(dev);
+	int result = 0;
+	char *tmpp = NULL;
+
+	if (!acpi_dev->wakeup.flags.valid)
+		tmpp = unsupported;
+	else
+		tmpp = acpi_dev->wakeup.state.enabled ? enabled : disabled;
+	result = sprintf(buf, "%s\n", tmpp);
+	return result;
+}
+
+static ssize_t
+acpi_device_status_store(struct device *dev, struct device_attribute *attr,
+		const char *buf, size_t count)
+{
+	struct list_head *node, *next;
+	struct acpi_device *acpi_dev = to_acpi_device(dev);
+	size_t len = count;
+	char *tmpp = NULL;
+
+	tmpp = memchr(buf, '\n', count);
+	if (tmpp != NULL)
+		len = tmpp - buf;
+
+	spin_lock(&acpi_device_lock);
+	if ((len == 1) && ((buf[0] == '0') || (buf[0] == '1')))
+		acpi_dev->wakeup.state.enabled = buf[0] - '0';
+	else if ((len == strlen(enabled))
+		 && (strnicmp(buf, enabled, strlen(enabled)) == 0))
+		acpi_dev->wakeup.state.enabled = 1;
+	else if ((len == strlen(disabled))
+		 && (strnicmp(buf, disabled, strlen(disabled)) == 0))
+		acpi_dev->wakeup.state.enabled = 0;
+	else {
+		spin_unlock(&acpi_device_lock);
+		return -EINVAL;
+	}
+
+	list_for_each_safe(node, next, &acpi_wakeup_device_list) {
+		struct acpi_device *dev = container_of(node,
+						       struct
+						       acpi_device,
+						       wakeup_list);
+
+		if ((dev != acpi_dev)
+		    && (dev->wakeup.gpe_number == acpi_dev->wakeup.gpe_number)
+		    && (dev->wakeup.gpe_device ==
+				acpi_dev->wakeup.gpe_device)) {
+			printk(KERN_WARNING
+			       "ACPI: '%s' and '%s' have the same GPE, "
+			       "can't disable/enable one seperately\n",
+			       dev->pnp.bus_id, acpi_dev->pnp.bus_id);
+			dev->wakeup.state.enabled =
+					acpi_dev->wakeup.state.enabled;
+		}
+	}
+	spin_unlock(&acpi_device_lock);
+
+	return count;
+}
+
+static DEVICE_ATTR(status, 0644, acpi_device_status_show,
+			acpi_device_status_store);
+
+static ssize_t
+acpi_device_acpi_bus_id_show(struct device *dev, struct device_attribute *attr,
+				char *buf)
+{
+	struct acpi_device *acpi_dev = to_acpi_device(dev);
+
+	return sprintf(buf, "%s\n", acpi_dev->pnp.bus_id);
+}
+
+static DEVICE_ATTR(acpi_bus_id, 0444, acpi_device_acpi_bus_id_show, NULL);
+
+
+static ssize_t
+acpi_device_sleep_state_show(struct device *dev, struct device_attribute *attr,
+				char *buf)
+{
+	struct acpi_device *acpi_dev = to_acpi_device(dev);
+
+	return sprintf(buf, "S%d\n", (u32) acpi_dev->wakeup.sleep_state);
+}
+
+static DEVICE_ATTR(sleep_state, 0444, acpi_device_sleep_state_show, NULL);
+
+static ssize_t
+acpi_device_run_wakeup_show(struct device *dev, struct device_attribute *attr,
+			    char *buf)
+{
+	struct acpi_device *acpi_dev = to_acpi_device(dev);
+
+	return sprintf(buf, "%d\n", acpi_dev->wakeup.flags.run_wake ? 1 : 0);
+}
+
+static DEVICE_ATTR(run_wakeup, 0444, acpi_device_run_wakeup_show, NULL);
+
+static ssize_t
+acpi_device_bus_id_show(struct device *dev, struct device_attribute *attr,
+			char *buf)
+{
+	struct acpi_device *acpi_dev = to_acpi_device(dev);
+	struct device *ldev = NULL;
+	int result = 0;
+
+	ldev = acpi_get_physical_device(acpi_dev->handle);
+	if (ldev)
+		result = sprintf(buf, "%s:%s\n",
+				 ldev->bus ? ldev->bus->name : "no-bus",
+				 ldev->bus_id);
+	else
+		result = sprintf(buf, "\n");
+
+	return result;
+}
+
+static DEVICE_ATTR(bus_id, 0444, acpi_device_bus_id_show, NULL);
+
+static ssize_t
+acpi_device_pci_id_show(struct device *dev, struct device_attribute *attr,
+			char *buf)
+{
+	struct acpi_device *acpi_dev = to_acpi_device(dev);
+	struct device *ldev = NULL;
+	int result = 0;
+
+	ldev = acpi_get_physical_device(acpi_dev->handle);
+	if (ldev)
+		result = sprintf(buf, "0x%04x\n", to_pci_dev(ldev)->device);
+	else
+		result = sprintf(buf, "\n");
+
+	return result;
+}
+
+static DEVICE_ATTR(pci_id, 0444, acpi_device_pci_id_show, NULL);
+
+static struct attribute *acpi_wakeup_attrs[] = {
+	&dev_attr_acpi_bus_id.attr,
+	&dev_attr_sleep_state.attr,
+	&dev_attr_status.attr,
+	&dev_attr_run_wakeup.attr,
+	&dev_attr_bus_id.attr,
+	&dev_attr_pci_id.attr,
+	NULL,
+};
+
+static struct attribute_group acpi_wakeup_attr_group = {
+	.name   = "wakeup",
+	.attrs  = acpi_wakeup_attrs,
+};
+
 static int acpi_device_setup_files(struct acpi_device *dev)
 {
 	acpi_status status;
@@ -201,19 +366,19 @@ static int acpi_device_setup_files(struct acpi_device *dev)
 	 */
 	if(dev->handle) {
 		result = device_create_file(&dev->dev, &dev_attr_path);
-		if(result)
+		if (result)
 			goto end;
 	}
 
 	if(dev->flags.hardware_id) {
 		result = device_create_file(&dev->dev, &dev_attr_hid);
-		if(result)
+		if (result)
 			goto end;
 	}
 
 	if (dev->flags.hardware_id || dev->flags.compatible_ids){
 		result = device_create_file(&dev->dev, &dev_attr_modalias);
-		if(result)
+		if (result)
 			goto end;
 	}
 
@@ -222,8 +387,16 @@ static int acpi_device_setup_files(struct acpi_device *dev)
          * hot-removal function from userland.
          */
 	status = acpi_get_handle(dev->handle, "_EJ0", &temp);
-	if (ACPI_SUCCESS(status))
+	if (ACPI_SUCCESS(status)) {
 		result = device_create_file(&dev->dev, &dev_attr_eject);
+		if (result)
+			goto end;
+	}
+
+	if (dev->wakeup.flags.valid)
+		result = sysfs_create_group(&dev->dev.kobj,
+				&acpi_wakeup_attr_group);
+
   end:
 	return result;
 }
@@ -248,6 +421,9 @@ static void acpi_device_remove_files(struct acpi_device *dev)
 		device_remove_file(&dev->dev, &dev_attr_hid);
 	if(dev->handle)
 		device_remove_file(&dev->dev, &dev_attr_path);
+
+	if (dev->wakeup.flags.valid)
+		sysfs_remove_group(&dev->dev.kobj, &acpi_wakeup_attr_group);
 }
 /* --------------------------------------------------------------------------
 			ACPI Bus operations


