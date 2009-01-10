Return-Path: <linux-kernel-owner+w=401wt.eu-S1755487AbZAJV1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487AbZAJV1R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 16:27:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753347AbZAJV1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 16:27:00 -0500
Received: from casper.infradead.org ([85.118.1.10]:39750 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbZAJV07 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 16:26:59 -0500
Date: Sat, 10 Jan 2009 16:29:05 -0500
From: Arjan van de Ven <arjan@infradead.org>
To: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] acpi: Initialize the batter driver asynchronous
Message-ID: <20090110162905.157ac543@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 9c2e4ec16b9e555ec8e1a52392a583543e7146a9 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Sat, 10 Jan 2009 14:19:05 -0500
Subject: [PATCH] acpi: Initialize the batter driver asynchronous

The battery driver tends to take quite some time to initialize (100ms-300ms
is quite typical).
This patch initializes the batter driver asynchronously, so that other
things in the kernel can initialize in parallel to this 300 msec.

As part of this, the batter driver had to move to the back of the acpi init
order (hence the Makefile change). Without this move, the next ACPI driver
would just block on the ACPI/devicee layer semaphores until the battery driver was
done anyway, not gaining any boot time.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 drivers/acpi/Makefile  |    2 +-
 drivers/acpi/battery.c |   15 +++++++++++----
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
index d80f4cc..84f182e 100644
--- a/drivers/acpi/Makefile
+++ b/drivers/acpi/Makefile
@@ -37,7 +37,6 @@ obj-y				+= scan.o
 # Keep EC driver first. Initialization of others depend on it.
 obj-y				+= ec.o
 obj-$(CONFIG_ACPI_AC) 		+= ac.o
-obj-$(CONFIG_ACPI_BATTERY)	+= battery.o
 obj-$(CONFIG_ACPI_BUTTON)	+= button.o
 obj-$(CONFIG_ACPI_FAN)		+= fan.o
 obj-$(CONFIG_ACPI_DOCK)		+= dock.o
@@ -57,5 +56,6 @@ obj-$(CONFIG_ACPI_DEBUG)	+= debug.o
 obj-$(CONFIG_ACPI_NUMA)		+= numa.o
 obj-$(CONFIG_ACPI_HOTPLUG_MEMORY)	+= acpi_memhotplug.o
 obj-$(CONFIG_ACPI_PROCFS_POWER)	+= cm_sbs.o
+obj-$(CONFIG_ACPI_BATTERY)	+= battery.o
 obj-$(CONFIG_ACPI_SBS)		+= sbshc.o
 obj-$(CONFIG_ACPI_SBS)		+= sbs.o
diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index 65132f9..1211799 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -30,6 +30,7 @@
 #include <linux/init.h>
 #include <linux/types.h>
 #include <linux/jiffies.h>
+#include <linux/async.h>
 
 #ifdef CONFIG_ACPI_PROCFS_POWER
 #include <linux/proc_fs.h>
@@ -878,21 +879,27 @@ static struct acpi_driver acpi_battery_driver = {
 		},
 };
 
-static int __init acpi_battery_init(void)
+static void __init acpi_battery_init_async(void *unused, async_cookie_t cookie)
 {
 	if (acpi_disabled)
-		return -ENODEV;
+		return;
 #ifdef CONFIG_ACPI_PROCFS_POWER
 	acpi_battery_dir = acpi_lock_battery_dir();
 	if (!acpi_battery_dir)
-		return -ENODEV;
+		return;
 #endif
 	if (acpi_bus_register_driver(&acpi_battery_driver) < 0) {
 #ifdef CONFIG_ACPI_PROCFS_POWER
 		acpi_unlock_battery_dir(acpi_battery_dir);
 #endif
-		return -ENODEV;
+		return;
 	}
+	return;
+}
+
+static int __init acpi_battery_init(void)
+{
+	async_schedule(acpi_battery_init_async, NULL);
 	return 0;
 }
 
-- 
1.6.0.6



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
