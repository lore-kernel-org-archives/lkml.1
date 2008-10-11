Return-Path: <linux-kernel-owner+w=401wt.eu-S1761806AbYJKGrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761806AbYJKGrr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 02:47:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753076AbYJKGid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 02:38:33 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:40791 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbYJKGh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 02:37:27 -0400
Date: Sat, 11 Oct 2008 02:35:57 -0400
From: Len Brown <lenb@kernel.org>
Subject: [PATCH 37/85] dock: fix for ATA bay in a dock station
In-reply-to: <1223707005-26864-1-git-send-email-lenb@kernel.org>
In-reply-to: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Shaohua Li <shaohua.li@intel.com>, Len Brown <len.brown@intel.com>
Message-id: <61b836958371c717d1e6d4fea1d2c512969ad20b.1223706853.git.len.brown@intel.com>
Organization: Intel Open Source Technology Center
X-Mailer: git-send-email 1.6.0.2.307.gc427
References: <1223707005-26864-1-git-send-email-lenb@kernel.org>
References: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shaohua Li <shaohua.li@intel.com>

an ATA bay can be in a dock and itself can be ejected separately.
This patch handles such eject bay. Found by Holger.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/dock.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
index ac7dfef..c877cc5 100644
--- a/drivers/acpi/dock.c
+++ b/drivers/acpi/dock.c
@@ -609,6 +609,7 @@ register_hotplug_dock_device(acpi_handle handle, struct acpi_dock_ops *ops,
 {
 	struct dock_dependent_device *dd;
 	struct dock_station *dock_station;
+	int ret = -EINVAL;
 
 	if (!dock_station_count)
 		return -ENODEV;
@@ -618,16 +619,21 @@ register_hotplug_dock_device(acpi_handle handle, struct acpi_dock_ops *ops,
 	 * this would include the dock station itself
 	 */
 	list_for_each_entry(dock_station, &dock_stations, sibiling) {
+		/*
+		 * An ATA bay can be in a dock and itself can be ejected
+		 * seperately, so there are two 'dock stations' which need the
+		 * ops
+		 */
 		dd = find_dock_dependent_device(dock_station, handle);
 		if (dd) {
 			dd->ops = ops;
 			dd->context = context;
 			dock_add_hotplug_device(dock_station, dd);
-			return 0;
+			ret = 0;
 		}
 	}
 
-	return -EINVAL;
+	return ret;
 }
 
 EXPORT_SYMBOL_GPL(register_hotplug_dock_device);
@@ -1078,8 +1084,8 @@ find_dock(acpi_handle handle, u32 lvl, void *context, void **rv)
 static acpi_status
 find_bay(acpi_handle handle, u32 lvl, void *context, void **rv)
 {
-	/* If bay is in a dock, it's already handled */
-	if (is_ejectable_bay(handle) && !is_dock_device(handle))
+	/* If bay is a dock, it's already handled */
+	if (is_ejectable_bay(handle) && !is_dock(handle))
 		dock_add(handle);
 	return AE_OK;
 }
-- 
1.5.5.1

