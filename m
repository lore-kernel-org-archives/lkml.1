Return-Path: <linux-kernel-owner+w=401wt.eu-S1753292AbXKSXx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292AbXKSXx1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 18:53:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751951AbXKSXxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 18:53:19 -0500
Received: from relay1.sgi.com ([192.48.171.29]:44970 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751925AbXKSXxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 18:53:18 -0500
Date: Mon, 19 Nov 2007 15:53:16 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: akpm@linux-foundation.org
cc: linux-kernel@vger.kernel.org, travis@sgi.com,
       Len Brown <len.brown@intel.com>
Subject: ACPI: Avoid references to impossible processors.
Message-ID: <Pine.LNX.4.64.0711191551320.15720@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ACPI uses NR_CPUS in various loops and in some it accesses per cpu
data of processors that are not present(!) and that will never be present.

The pointers to per cpu data are typically not initialized for processors
that are not present. So we seem to be reading something here from offset 0
in memory.

Make ACPI use nr_cpu_ids instead. That stops at the end of the possible
processors.

Convert one loop to NR_CPUS to use the cpu_possible map instead. That way
ranges of processor that can never be brought online are skipped during
the loop.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 drivers/acpi/processor_core.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

Index: linux-2.6/drivers/acpi/processor_core.c
===================================================================
--- linux-2.6.orig/drivers/acpi/processor_core.c	2007-11-19 15:45:05.041140492 -0800
+++ linux-2.6/drivers/acpi/processor_core.c	2007-11-19 15:48:22.513639920 -0800
@@ -494,7 +494,7 @@ static int get_cpu_id(acpi_handle handle
 	if (apic_id == -1)
 		return apic_id;
 
-	for (i = 0; i < NR_CPUS; ++i) {
+	for_each_possible_cpu(i) {
 		if (cpu_physical_id(i) == apic_id)
 			return i;
 	}
@@ -638,7 +638,7 @@ static int __cpuinit acpi_processor_star
 		return 0;
 	}
 
-	BUG_ON((pr->id >= NR_CPUS) || (pr->id < 0));
+	BUG_ON((pr->id >= nr_cpu_ids) || (pr->id < 0));
 
 	/*
 	 * Buggy BIOS check
@@ -771,7 +771,7 @@ static int acpi_processor_remove(struct 
 
 	pr = acpi_driver_data(device);
 
-	if (pr->id >= NR_CPUS) {
+	if (pr->id >= nr_cpu_ids) {
 		kfree(pr);
 		return 0;
 	}
@@ -842,7 +842,7 @@ int acpi_processor_device_add(acpi_handl
 	if (!pr)
 		return -ENODEV;
 
-	if ((pr->id >= 0) && (pr->id < NR_CPUS)) {
+	if ((pr->id >= 0) && (pr->id < nr_cpu_ids)) {
 		kobject_uevent(&(*device)->dev.kobj, KOBJ_ONLINE);
 	}
 	return 0;
@@ -880,13 +880,13 @@ acpi_processor_hotplug_notify(acpi_handl
 			break;
 		}
 
-		if (pr->id >= 0 && (pr->id < NR_CPUS)) {
+		if (pr->id >= 0 && (pr->id < nr_cpu_ids)) {
 			kobject_uevent(&device->dev.kobj, KOBJ_OFFLINE);
 			break;
 		}
 
 		result = acpi_processor_start(device);
-		if ((!result) && ((pr->id >= 0) && (pr->id < NR_CPUS))) {
+		if ((!result) && ((pr->id >= 0) && (pr->id < nr_cpu_ids))) {
 			kobject_uevent(&device->dev.kobj, KOBJ_ONLINE);
 		} else {
 			printk(KERN_ERR PREFIX "Device [%s] failed to start\n",
@@ -909,7 +909,7 @@ acpi_processor_hotplug_notify(acpi_handl
 			return;
 		}
 
-		if ((pr->id < NR_CPUS) && (cpu_present(pr->id)))
+		if ((pr->id < nr_cpu_ids) && (cpu_present(pr->id)))
 			kobject_uevent(&device->dev.kobj, KOBJ_OFFLINE);
 		break;
 	default:
