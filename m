Return-Path: <linux-kernel-owner+w=401wt.eu-S1758905AbYJKGly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758905AbYJKGly (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 02:41:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754129AbYJKGh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 02:37:28 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:40791 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709AbYJKGhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 02:37:12 -0400
Date: Sat, 11 Oct 2008 02:35:50 -0400
From: Len Brown <lenb@kernel.org>
Subject: [PATCH 30/85] dock: add _LCK support
In-reply-to: <1223707005-26864-1-git-send-email-lenb@kernel.org>
In-reply-to: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Shaohua Li <shaohua.li@intel.com>, Len Brown <len.brown@intel.com>
Message-id: <406f692d0803d73acd3984c1e11719d3a913fd5e.1223706853.git.len.brown@intel.com>
Organization: Intel Open Source Technology Center
X-Mailer: git-send-email 1.6.0.2.307.gc427
References: <1223707005-26864-1-git-send-email-lenb@kernel.org>
References: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shaohua Li <shaohua.li@intel.com>

support _LCK method, which is a optional method for hotplug

lenb: we have not seen _LCK used in the field yet

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/dock.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
index 78d27ce..7bdf93b 100644
--- a/drivers/acpi/dock.c
+++ b/drivers/acpi/dock.c
@@ -452,6 +452,25 @@ static inline void complete_undock(struct dock_station *ds)
 	ds->flags &= ~(DOCK_UNDOCKING);
 }
 
+static void dock_lock(struct dock_station *ds, int lock)
+{
+	struct acpi_object_list arg_list;
+	union acpi_object arg;
+	acpi_status status;
+
+	arg_list.count = 1;
+	arg_list.pointer = &arg;
+	arg.type = ACPI_TYPE_INTEGER;
+	arg.integer.value = !!lock;
+	status = acpi_evaluate_object(ds->handle, "_LCK", &arg_list, NULL);
+	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
+		if (lock)
+			printk(KERN_WARNING PREFIX "Locking device failed\n");
+		else
+			printk(KERN_WARNING PREFIX "Unlocking device failed\n");
+	}
+}
+
 /**
  * dock_in_progress - see if we are in the middle of handling a dock event
  * @ds: the dock station
@@ -577,6 +596,7 @@ static int handle_eject_request(struct dock_station *ds, u32 event)
 
 	hotplug_dock_devices(ds, ACPI_NOTIFY_EJECT_REQUEST);
 	undock(ds);
+	dock_lock(ds, 0);
 	eject_dock(ds);
 	if (dock_present(ds)) {
 		printk(KERN_ERR PREFIX "Unable to undock!\n");
@@ -617,6 +637,7 @@ static void dock_notify(acpi_handle handle, u32 event, void *data)
 			hotplug_dock_devices(ds, event);
 			complete_dock(ds);
 			dock_event(ds, event, DOCK_EVENT);
+			dock_lock(ds, 1);
 		}
 		break;
 	case ACPI_NOTIFY_DEVICE_CHECK:
-- 
1.5.5.1

