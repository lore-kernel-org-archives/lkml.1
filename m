Return-Path: <linux-kernel-owner+w=401wt.eu-S1756603AbZCJWhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756603AbZCJWhk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 18:37:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755174AbZCJWha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 18:37:30 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:9087 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754162AbZCJWh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 18:37:29 -0400
Date: Tue, 10 Mar 2009 16:37:27 -0600
From: Alex Chiang <achiang@hp.com>
To: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, djwong@us.ibm.com,
       vegard.nossum@gmail.com, Trent Piepho <xyzzy@speakeasy.org>
Subject: Re: [PATCH v3 07/11] PCI: Introduce /sys/bus/pci/devices/.../remove
Message-ID: <20090310223727.GA25665@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>, jbarnes@virtuousgeek.org,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	djwong@us.ibm.com, vegard.nossum@gmail.com,
	Trent Piepho <xyzzy@speakeasy.org>
References: <20090309052933.3918.86601.stgit@bob.kio> <20090309054911.3918.91600.stgit@bob.kio> <20090309185255.GK32589@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090309185255.GK32589@ldl.fc.hp.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Alex Chiang <achiang@hp.com>:
> This is an updated version of this patch. It fixes a bug where we
> would remove a bridge even if it still had children.
> 
> Now we check for children before attempting to remove the bridge.

This is another updated version of the patch.

It adds a mutex for the sysfs callback function.

This mutex, along with another sysfs patch that I plan on posting
soon, should help prevent an oops that a crazy user might induce
with the following loop:

	# while true ; do echo 1 > /sys/bus/pci/devices/.../remove ; done

I'm posting this updated version so that Vegard can drop it into
his test setup that he had.

When I post v4 of this entire patch series, I'll have a full
changelog, etc.

Thanks.

/ac


commit 53cb428d7a26be7b3ea38f6d7f30cd33cc1e6b4a
Author: Alex Chiang <achiang@hp.com>
Date:   Tue Mar 10 16:32:45 2009 -0600

    PCI: Introduce /sys/bus/pci/devices/.../remove
    
    This patch adds an attribute named "remove" to a PCI device's sysfs
    directory.  Writing a non-zero value to this attribute will remove the PCI
    device and any children of it.
    
    Trent Piepho wrote the original implementation and documentation.
    
    Cc: djwong@us.ibm.com
    Cc: Trent Piepho <xyzzy@speakeasy.org>
    Signed-off-by: Alex Chiang <achiang@hp.com>

diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
index ea4aee2..5b1ddde 100644
--- a/Documentation/ABI/testing/sysfs-bus-pci
+++ b/Documentation/ABI/testing/sysfs-bus-pci
@@ -50,6 +50,14 @@ Description:
 		re-discover previously removed devices.
 		Depends on CONFIG_HOTPLUG.
 
+What:		/sys/bus/pci/devices/.../remove
+Date:		January 2009
+Contact:	Linux PCI developers <linux-pci@vger.kernel.org>
+Description:
+		Writing a non-zero value to this attribute will
+		hot-remove the PCI device and any of its children.
+		Depends on CONFIG_HOTPLUG.
+
 What:		/sys/bus/pci/devices/.../vpd
 Date:		February 2008
 Contact:	Ben Hutchings <bhutchings@solarflare.com>
diff --git a/Documentation/filesystems/sysfs-pci.txt b/Documentation/filesystems/sysfs-pci.txt
index 9f8740c..26e4b8b 100644
--- a/Documentation/filesystems/sysfs-pci.txt
+++ b/Documentation/filesystems/sysfs-pci.txt
@@ -12,6 +12,7 @@ that support it.  For example, a given bus might look like this:
      |   |-- enable
      |   |-- irq
      |   |-- local_cpus
+     |   |-- remove
      |   |-- resource
      |   |-- resource0
      |   |-- resource1
@@ -36,6 +37,7 @@ files, each with their own function.
        enable	           Whether the device is enabled (ascii, rw)
        irq		   IRQ number (ascii, ro)
        local_cpus	   nearby CPU mask (cpumask, ro)
+       remove		   remove device from kernel's list (ascii, wo)
        resource		   PCI resource host addresses (ascii, ro)
        resource0..N	   PCI resource N, if present (binary, mmap)
        resource0_wc..N_wc  PCI WC map resource N, if prefetchable (binary, mmap)
@@ -46,6 +48,7 @@ files, each with their own function.
 
   ro - read only file
   rw - file is readable and writable
+  wo - write only file
   mmap - file is mmapable
   ascii - file contains ascii text
   binary - file contains binary data
@@ -73,6 +76,13 @@ that the device must be enabled for a rom read to return data succesfully.
 In the event a driver is not bound to the device, it can be enabled using the
 'enable' file, documented above.
 
+The 'remove' file is used to remove the PCI device, by writing a non-zero
+integer to the file.  This does not involve any kind of hot-plug functionality,
+e.g. powering off the device.  The device is removed from the kernel's list of
+PCI devices, the sysfs directory for it is removed, and the device will be
+removed from any drivers attached to it. Removal of PCI root buses is
+disallowed.
+
 Accessing legacy resources through sysfs
 ----------------------------------------
 
diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index a29fc3b..11bc9b1 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -219,6 +219,51 @@ msi_bus_store(struct device *dev, struct device_attribute *attr,
 	return count;
 }
 
+#ifdef CONFIG_HOTPLUG
+static DEFINE_MUTEX(pci_remove_mutex);
+static void remove_callback(struct device *dev)
+{
+	int bridge = 0;
+	struct pci_dev *pdev = to_pci_dev(dev);
+
+	mutex_lock(&pci_remove_mutex);
+
+	if (pdev->subordinate)
+		bridge = 1;
+
+	pci_remove_bus_device(pdev);
+	if (bridge && list_empty(&pdev->bus->devices))
+		pci_remove_bus(pdev->bus);
+	pci_dev_put(pdev);
+
+	mutex_unlock(&pci_remove_mutex);
+}
+
+static ssize_t
+remove_store(struct device *dev, struct device_attribute *dummy,
+	     const char *buf, size_t count)
+{
+	int ret = 0;
+	unsigned long val;
+	struct pci_dev *pdev = to_pci_dev(dev);
+
+	if (strict_strtoul(buf, 0, &val) < 0)
+		return -EINVAL;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (pdev->subordinate && pci_is_root_bus(pdev->bus))
+		return -EBUSY;
+
+	if (val)
+		ret = device_schedule_callback(dev, remove_callback);
+	if (ret)
+		count = ret;
+	return count;
+}
+#endif
+
 struct device_attribute pci_dev_attrs[] = {
 	__ATTR_RO(resource),
 	__ATTR_RO(vendor),
@@ -237,6 +282,9 @@ struct device_attribute pci_dev_attrs[] = {
 	__ATTR(broken_parity_status,(S_IRUGO|S_IWUSR),
 		broken_parity_status_show,broken_parity_status_store),
 	__ATTR(msi_bus, 0644, msi_bus_show, msi_bus_store),
+#ifdef CONFIG_HOTPLUG
+	__ATTR(remove, S_IWUSR, NULL, remove_store),
+#endif
 	__ATTR_NULL,
 };
 
