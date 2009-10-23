Return-Path: <linux-kernel-owner+w=401wt.eu-S1753149AbZJWXie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149AbZJWXie (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 19:38:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752544AbZJWXhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 19:37:55 -0400
Received: from relay2.sgi.com ([192.48.179.30]:54743 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752804AbZJWXhv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 19:37:51 -0400
Message-Id: <20091023233754.668088000@alcatraz.americas.sgi.com>
References: <20091023233743.439628000@alcatraz.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 23 Oct 2009 18:37:47 -0500
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Jack Steiner <steiner@sgi.com>, Zhang Rui <rui.zhang@intel.com>,
       Len Brown <lenb@kernel.org>, Thomas Renninger <trenn@suse.de>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, Myron Stowe <myron.stowe@hp.com>,
       Feng Tang <feng.tang@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 4/8] SGI x86_64 UV: Limit the number of ACPI messages
Content-Disposition: inline; filename=limit_acpi
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Limit number of ACPI messages of the form:

[    0.000000] ACPI: LSAPIC (acpi_id[0x00] lsapic_id[0x00] lsapic_eid[0x00] enabled)

[   99.638655] processor ACPI0007:00: registered as cooling_device0

Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Myron Stowe <myron.stowe@hp.com>
Cc: Feng Tang <feng.tang@intel.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Mike Travis <travis@sgi.com>
---
 drivers/acpi/fan.c            |    7 ++++++-
 drivers/acpi/processor_core.c |    8 ++++++--
 drivers/acpi/tables.c         |   15 ++++++++++-----
 3 files changed, 22 insertions(+), 8 deletions(-)

--- linux.orig/drivers/acpi/fan.c
+++ linux/drivers/acpi/fan.c
@@ -243,6 +243,7 @@
 	int result = 0;
 	int state = 0;
 	struct thermal_cooling_device *cdev;
+	static int msgcnt;
 
 	if (!device)
 		return -EINVAL;
@@ -267,7 +268,11 @@
 		goto end;
 	}
 
-	dev_info(&device->dev, "registered as cooling_device%d\n", cdev->id);
+	if (msgcnt < 4 || !limit_console_output(false)) {
+		dev_info(&device->dev,
+			"registered as cooling_device%d\n", cdev->id);
+		msgcnt++;
+	}
 
 	device->driver_data = cdev;
 	result = sysfs_create_link(&device->dev.kobj,
--- linux.orig/drivers/acpi/processor_core.c
+++ linux/drivers/acpi/processor_core.c
@@ -775,6 +775,7 @@
 	struct acpi_processor *pr = NULL;
 	int result = 0;
 	struct sys_device *sysdev;
+	static int msgcnt;
 
 	pr = kzalloc(sizeof(struct acpi_processor), GFP_KERNEL);
 	if (!pr)
@@ -845,8 +846,11 @@
 		goto err_power_exit;
 	}
 
-	dev_info(&device->dev, "registered as cooling_device%d\n",
-		 pr->cdev->id);
+	if (msgcnt < 4 || !limit_console_output(false)) {
+		dev_info(&device->dev, "registered as cooling_device%d\n",
+			 pr->cdev->id);
+		msgcnt++;
+	}
 
 	result = sysfs_create_link(&device->dev.kobj,
 				   &pr->cdev->device.kobj,
--- linux.orig/drivers/acpi/tables.c
+++ linux/drivers/acpi/tables.c
@@ -170,11 +170,16 @@
 	case ACPI_MADT_TYPE_LOCAL_SAPIC:
 		{
 			struct acpi_madt_local_sapic *p =
-			    (struct acpi_madt_local_sapic *)header;
-			printk(KERN_INFO PREFIX
-			       "LSAPIC (acpi_id[0x%02x] lsapic_id[0x%02x] lsapic_eid[0x%02x] %s)\n",
-			       p->processor_id, p->id, p->eid,
-			       (p->lapic_flags & ACPI_MADT_ENABLED) ? "enabled" : "disabled");
+				(struct acpi_madt_local_sapic *)header;
+
+			if (p->eid < 8 || !limit_console_output(false))
+				printk(KERN_INFO PREFIX
+					"LSAPIC (acpi_id[0x%02x] "
+						"lsapic_id[0x%02x] "
+						"lsapic_eid[0x%02x] %s)\n",
+					p->processor_id, p->id, p->eid,
+					(p->lapic_flags & ACPI_MADT_ENABLED) ?
+						"enabled" : "disabled");
 		}
 		break;
 

-- 
