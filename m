Return-Path: <linux-kernel-owner+w=401wt.eu-S1755229AbYBRVFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229AbYBRVFS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 16:05:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762150AbYBRVDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 16:03:51 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43150 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762151AbYBRVDt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 16:03:49 -0500
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, andrew.grover@intel.com,
       paul.s.diefenbaugh@intel.com, linux@brodo.de,
       anil.s.keshavamurthy@intel.com, lenb@kernel.org,
       linux-acpi@vger.kernel.org, Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 3/4] provide error handling for unclean objects
Date: Mon, 18 Feb 2008 17:56:52 -0300
Message-Id: <1203368213-30528-3-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1203368213-30528-2-git-send-email-gcosta@redhat.com>
References: <1203368213-30528-1-git-send-email-gcosta@redhat.com>
 <1203368213-30528-2-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously, if acpi_processor_start() failed to
create sysfs nodes, it would leave stuff to be cleaned,
that won't perish in acpi_processor_remove(),
since we'll have pr->cdev == NULL.

This patch cleans those objects.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 drivers/acpi/processor_core.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
index 5023410..06a230a 100644
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -680,11 +680,12 @@ #endif
 	result = sysfs_create_link(&device->dev.kobj, &cdev->device.kobj,
 					"thermal_cooling");
 	if (result)
-		return result;
+		goto err_thermal;
+
 	result = sysfs_create_link(&cdev->device.kobj, &device->dev.kobj,
 					"device");
 	if (result)
-		return result;
+		goto err_sysfs;
 
 	pr->cdev = cdev;
 
@@ -694,9 +695,13 @@ #endif
 		printk(" %d throttling states", pr->throttling.state_count);
 		printk(")\n");
 	}
+	return result;
 
-      end:
-
+err_sysfs:
+	sysfs_remove_link(&device->dev.kobj, "thermal_cooling");
+err_thermal:
+	thermal_cooling_device_unregister(pr->cdev);
+end:
 	return result;
 }
 
-- 
1.4.2

