Return-Path: <linux-kernel-owner+w=401wt.eu-S1762493AbYBRVEi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762493AbYBRVEi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 16:04:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762143AbYBRVDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 16:03:47 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43142 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760550AbYBRVDp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 16:03:45 -0500
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, andrew.grover@intel.com,
       paul.s.diefenbaugh@intel.com, linux@brodo.de,
       anil.s.keshavamurthy@intel.com, lenb@kernel.org,
       linux-acpi@vger.kernel.org, Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 2/4] use pr->cdev as a condition for cleanup
Date: Mon, 18 Feb 2008 17:56:51 -0300
Message-Id: <1203368213-30528-2-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1203368213-30528-1-git-send-email-gcosta@redhat.com>
References: <1203368213-30528-1-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The acpi_processor_start() function can fail before creating the
sysfs nodes for thermal cooling. In this case, pr->cdev will be NULL,
and the removal code will break.

This patch uses pr->cdev as a criteria for termination of the
mentioned code, and avoids it, if it was never initialized.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 drivers/acpi/processor_core.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
index 9480203..5023410 100644
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -811,10 +811,12 @@ static int acpi_processor_remove(struct 
 
 	acpi_processor_remove_fs(device);
 
-	sysfs_remove_link(&device->dev.kobj, "thermal_cooling");
-	sysfs_remove_link(&pr->cdev->device.kobj, "device");
-	thermal_cooling_device_unregister(pr->cdev);
-	pr->cdev = NULL;
+	if (pr->cdev) {
+		sysfs_remove_link(&device->dev.kobj, "thermal_cooling");
+		sysfs_remove_link(&pr->cdev->device.kobj, "device");
+		thermal_cooling_device_unregister(pr->cdev);
+		pr->cdev = NULL;
+	}
 
 	processors[pr->id] = NULL;
 
-- 
1.4.2

