Return-Path: <linux-kernel-owner+w=401wt.eu-S1763325AbYJKG5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763325AbYJKG5q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 02:57:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754389AbYJKGkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 02:40:20 -0400
Received: from vms044pub.verizon.net ([206.46.252.44]:39146 "EHLO
	vms044pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303AbYJKGg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 02:36:59 -0400
Date: Sat, 11 Oct 2008 02:35:53 -0400
From: Len Brown <lenb@kernel.org>
Subject: [PATCH 33/85] ACPI: fix hotplug race
In-reply-to: <1223707005-26864-1-git-send-email-lenb@kernel.org>
In-reply-to: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Zhang Rui <rui.zhang@intel.com>, Shaohua Li <shaohua.li@intel.com>,
       Len Brown <len.brown@intel.com>
Message-id: <19cd847ab24fefe9e50101ec94479e0400a08650.1223706853.git.len.brown@intel.com>
Organization: Intel Open Source Technology Center
X-Mailer: git-send-email 1.6.0.2.307.gc427
References: <1223707005-26864-1-git-send-email-lenb@kernel.org>
References: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Rui <rui.zhang@intel.com>

The hotplug notification handler and drivers' notification handler all
run in one workqueue.  Before hotplug removes an acpi device, the
device driver's notification handler is already be recorded to run just
after global notification handler.  After hotplug notification handler
runs, acpica will notice a NULL notification handler and crash.

So now we run run hotplug in another workqueue and wait
for all acpi notication handlers finish.
This was found in battery hotplug, but actually all
hotplug can be affected.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/dock.c     |   25 ++++++++++++++++++++++++-
 drivers/acpi/osl.c      |   46 +++++++++++++++++++++++++++++++++++++++++-----
 include/acpi/acpiosxf.h |    3 +++
 3 files changed, 68 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
index 2563bc6..4b395b1 100644
--- a/drivers/acpi/dock.c
+++ b/drivers/acpi/dock.c
@@ -748,6 +748,20 @@ static void dock_notify(acpi_handle handle, u32 event, void *data)
 	}
 }
 
+struct dock_data {
+	acpi_handle handle;
+	unsigned long event;
+	struct dock_station *ds;
+};
+
+static void acpi_dock_deferred_cb(void *context)
+{
+	struct dock_data *data = (struct dock_data *)context;
+
+	dock_notify(data->handle, data->event, data->ds);
+	kfree(data);
+}
+
 static int acpi_dock_notifier_call(struct notifier_block *this,
 	unsigned long event, void *data)
 {
@@ -759,7 +773,16 @@ static int acpi_dock_notifier_call(struct notifier_block *this,
 		return 0;
 	list_for_each_entry(dock_station, &dock_stations, sibiling) {
 		if (dock_station->handle == handle) {
-			dock_notify(handle, event, dock_station);
+			struct dock_data *dock_data;
+
+			dock_data = kmalloc(sizeof(*dock_data), GFP_KERNEL);
+			if (!dock_data)
+				return 0;
+			dock_data->handle = handle;
+			dock_data->event = event;
+			dock_data->ds = dock_station;
+			acpi_os_hotplug_execute(acpi_dock_deferred_cb,
+				dock_data);
 			return 0 ;
 		}
 	}
diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 235a138..750e0df 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -682,6 +682,22 @@ static void acpi_os_execute_deferred(struct work_struct *work)
 	return;
 }
 
+static void acpi_os_execute_hp_deferred(struct work_struct *work)
+{
+	struct acpi_os_dpc *dpc = container_of(work, struct acpi_os_dpc, work);
+	if (!dpc) {
+		printk(KERN_ERR PREFIX "Invalid (NULL) context\n");
+		return;
+	}
+
+	acpi_os_wait_events_complete(NULL);
+
+	dpc->function(dpc->context);
+	kfree(dpc);
+
+	return;
+}
+
 /*******************************************************************************
  *
  * FUNCTION:    acpi_os_execute
@@ -697,12 +713,13 @@ static void acpi_os_execute_deferred(struct work_struct *work)
  *
  ******************************************************************************/
 
-acpi_status acpi_os_execute(acpi_execute_type type,
-			    acpi_osd_exec_callback function, void *context)
+static acpi_status __acpi_os_execute(acpi_execute_type type,
+	acpi_osd_exec_callback function, void *context, int hp)
 {
 	acpi_status status = AE_OK;
 	struct acpi_os_dpc *dpc;
 	struct workqueue_struct *queue;
+	int ret;
 	ACPI_DEBUG_PRINT((ACPI_DB_EXEC,
 			  "Scheduling function [%p(%p)] for deferred execution.\n",
 			  function, context));
@@ -726,9 +743,17 @@ acpi_status acpi_os_execute(acpi_execute_type type,
 	dpc->function = function;
 	dpc->context = context;
 
-	INIT_WORK(&dpc->work, acpi_os_execute_deferred);
-	queue = (type == OSL_NOTIFY_HANDLER) ? kacpi_notify_wq : kacpid_wq;
-	if (!queue_work(queue, &dpc->work)) {
+	if (!hp) {
+		INIT_WORK(&dpc->work, acpi_os_execute_deferred);
+		queue = (type == OSL_NOTIFY_HANDLER) ?
+			kacpi_notify_wq : kacpid_wq;
+		ret = queue_work(queue, &dpc->work);
+	} else {
+		INIT_WORK(&dpc->work, acpi_os_execute_hp_deferred);
+		ret = schedule_work(&dpc->work);
+	}
+
+	if (!ret) {
 		ACPI_DEBUG_PRINT((ACPI_DB_ERROR,
 			  "Call to queue_work() failed.\n"));
 		status = AE_ERROR;
@@ -737,8 +762,19 @@ acpi_status acpi_os_execute(acpi_execute_type type,
 	return_ACPI_STATUS(status);
 }
 
+acpi_status acpi_os_execute(acpi_execute_type type,
+			    acpi_osd_exec_callback function, void *context)
+{
+	return __acpi_os_execute(type, function, context, 0);
+}
 EXPORT_SYMBOL(acpi_os_execute);
 
+acpi_status acpi_os_hotplug_execute(acpi_osd_exec_callback function,
+	void *context)
+{
+	return __acpi_os_execute(0, function, context, 1);
+}
+
 void acpi_os_wait_events_complete(void *context)
 {
 	flush_workqueue(kacpid_wq);
diff --git a/include/acpi/acpiosxf.h b/include/acpi/acpiosxf.h
index 3f93a6b..b91440a 100644
--- a/include/acpi/acpiosxf.h
+++ b/include/acpi/acpiosxf.h
@@ -193,6 +193,9 @@ acpi_status
 acpi_os_execute(acpi_execute_type type,
 		acpi_osd_exec_callback function, void *context);
 
+acpi_status
+acpi_os_hotplug_execute(acpi_osd_exec_callback function, void *context);
+
 void acpi_os_wait_events_complete(void *context);
 
 void acpi_os_sleep(acpi_integer milliseconds);
-- 
1.5.5.1

