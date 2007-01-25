Return-Path: <linux-kernel-owner+w=401wt.eu-S965250AbXAYFAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965250AbXAYFAa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 00:00:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933225AbXAYFAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 00:00:30 -0500
Received: from cavan.codon.org.uk ([217.147.92.49]:48070 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933217AbXAYFA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 00:00:29 -0500
Date: Thu, 25 Jan 2007 05:00:09 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: David Brownell <david-b@pacbell.net>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de
Message-ID: <20070125050009.GA8672@srcf.ucam.org>
References: <20061219185223.GA13256@srcf.ucam.org> <200612201318.06976.david-b@pacbell.net> <20061221012924.GC32625@srcf.ucam.org> <200612201904.28681.david-b@pacbell.net> <20061221040648.GA1499@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20061221040648.GA1499@srcf.ucam.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: [PATCH] Fix /sys/device/.../power/state regression
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In 2.6.19, support for splitting driver suspend and resume callbacks 
into interrupt and non-interrupt contexts was added. Unfortunately, this 
broke /sys/device/.../power/state support for all devices. In the long 
run, this should be obsoleted by power management support in the 
individual drivers - however, in the case of network drivers (for 
example), currently only three drivers implement any sort of useful 
run-time power management.

This patch allows the bus driver to check whether a specific driver 
requires the split. If not, the 2.6.18 functionality is restored. It 
also alters feature-removals.txt to note that the deprecated 
functionality should not be removed until a replacement actually exists.

Signed-off-by: Matthew Garrett <mjg59@srcf.ucam.org>

--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -9,7 +9,8 @@ be removed from this file.
 What:	/sys/devices/.../power/state
 	dev->power.power_state
 	dpm_runtime_{suspend,resume)()
-When:	July 2007
+	bus->pm_has_noirq_stage()
+When:	Once alternative functionality has been implemented
 Why:	Broken design for runtime control over driver power states, confusing
 	driver-internal runtime power management with:  mechanisms to support
 	system-wide sleep state transitions; event codes that distinguish
diff --git a/Documentation/power/devices.txt b/Documentation/power/devices.txt
index d0e79d5..345cca4 100644
--- a/Documentation/power/devices.txt
+++ b/Documentation/power/devices.txt
@@ -79,6 +79,7 @@ struct bus_type {
 
 	int  (*resume_early)(struct device *dev);
 	int  (*resume)(struct device *dev);
+	int  (*pm_has_noirq_stage)(struct device *dev);
 };
 
 Bus drivers implement those methods as appropriate for the hardware and
@@ -236,6 +237,10 @@ The phases are seen by driver notifications issued in this order:
 	may stay partly usable until this late.  This "late" call may also
 	help when coping with hardware that behaves badly.
 
+	If a bus implements the suspend_late method, it must also provide a
+	pm_has_noirq_stage function in order to determine whether devices 
+	may be suspended during runtime.
+
 The pm_message_t parameter is currently used to refine those semantics
 (described later).
 
@@ -348,7 +353,9 @@ The phases are seen by driver notifications issued in this order:
 	won't be supported on busses that require IRQs in order to
 	interact with devices.
 
-	This reverses the effects of bus.suspend_late().
+	This reverses the effects of bus.suspend_late(). As with suspend_late,
+	if a bus implements this function it must provide a pm_has_noirq_stage
+	function.
 
    2	bus.resume(dev) is called next.  This may be morphed into a device
    	driver call with bus-specific parameters; implementations may sleep.
diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index f9c903b..6bf1218 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -597,6 +597,16 @@ static int platform_resume(struct device * dev)
 	return ret;
 }
 
+static int platform_pm_has_noirq_stage(struct device * dev)
+{
+	int ret = 0;
+	struct platform_driver *drv = to_platform_driver(dev->driver);
+
+	if (dev->driver && (drv->resume_early || drv->suspend_late))
+		ret = 1;
+	return ret;
+}
+
 struct bus_type platform_bus_type = {
 	.name		= "platform",
 	.dev_attrs	= platform_dev_attrs,
@@ -606,6 +616,7 @@ struct bus_type platform_bus_type = {
 	.suspend_late	= platform_suspend_late,
 	.resume_early	= platform_resume_early,
 	.resume		= platform_resume,
+	.pm_has_noirq_stage = platform_pm_has_noirq_stage,
 };
 EXPORT_SYMBOL_GPL(platform_bus_type);
 
diff --git a/drivers/base/power/sysfs.c b/drivers/base/power/sysfs.c
index 2d47517..c4ce060 100644
--- a/drivers/base/power/sysfs.c
+++ b/drivers/base/power/sysfs.c
@@ -46,7 +46,8 @@ static ssize_t state_store(struct device * dev, struct device_attribute *attr, c
 	int error = -EINVAL;
 
 	/* disallow incomplete suspend sequences */
-	if (dev->bus && (dev->bus->suspend_late || dev->bus->resume_early))
+	if (dev->bus && dev->bus->pm_has_noirq_stage 
+			&& dev->bus->pm_has_noirq_stage(dev))
 		return error;
 
 	state.event = PM_EVENT_SUSPEND;
diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index e5ae3a0..c0e4e7a 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -351,6 +351,17 @@ static int pci_device_resume(struct device * dev)
 	return error;
 }
 
+static int pci_device_pm_has_noirq_stage(struct device * dev)
+{
+	int error = 0;
+	struct pci_dev * pci_dev = to_pci_dev(dev);
+	struct pci_driver * drv = pci_dev->driver;
+
+	if (drv && (drv->resume_early || drv->suspend_late))
+		error = 1;
+	return error;
+}
+
 static int pci_device_resume_early(struct device * dev)
 {
 	int error = 0;
@@ -569,6 +580,7 @@ struct bus_type pci_bus_type = {
 	.suspend_late	= pci_device_suspend_late,
 	.resume_early	= pci_device_resume_early,
 	.resume		= pci_device_resume,
+	.pm_has_noirq_stage = pci_device_pm_has_noirq_stage,
 	.shutdown	= pci_device_shutdown,
 	.dev_attrs	= pci_dev_attrs,
 };
diff --git a/include/linux/device.h b/include/linux/device.h
index 49ab53c..1c663c4 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -59,6 +59,7 @@ struct bus_type {
 	int (*suspend)(struct device * dev, pm_message_t state);
 	int (*suspend_late)(struct device * dev, pm_message_t state);
 	int (*resume_early)(struct device * dev);
+	int (*pm_has_noirq_stage)(struct device * dev);
 	int (*resume)(struct device * dev);
 };

-- 
Matthew Garrett | mjg59@srcf.ucam.org
