Return-Path: <linux-kernel-owner+w=401wt.eu-S934264AbZJNWrN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934264AbZJNWrN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 18:47:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762104AbZJNWrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 18:47:10 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:48004 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758657AbZJNWrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 18:47:08 -0400
Subject: [PATCH v2 2/6] ACPI: dock: combine add|alloc_dock_dependent_device
To: lenb@kernel.org
From: Alex Chiang <achiang@hp.com>
Cc: shaohua.li@intel.com, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Date: Wed, 14 Oct 2009 16:46:21 -0600
Message-ID: <20091014224621.18044.31133.stgit@bob.kio>
In-Reply-To: <20091014224415.18044.88208.stgit@bob.kio>
References: <20091014224415.18044.88208.stgit@bob.kio>
User-Agent: StGit/0.14.3.386.gb02d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no real need to have a separate allocation step when adding
a dock dependent device.

Combining the two functions is both logical and helps with legibility.

Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/acpi/dock.c |   55 ++++++++++++++++++---------------------------------
 1 files changed, 19 insertions(+), 36 deletions(-)

diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
index 642c7dd..10cf833 100644
--- a/drivers/acpi/dock.c
+++ b/drivers/acpi/dock.c
@@ -93,40 +93,30 @@ struct dock_dependent_device {
  *                         Dock Dependent device functions                   *
  *****************************************************************************/
 /**
- *  alloc_dock_dependent_device - allocate and init a dependent device
- *  @handle: the acpi_handle of the dependent device
+ * add_dock_dependent_device - associate a device with the dock station
+ * @handle: handle of the dependent device
+ * @ds: The dock station
  *
- *  Allocate memory for a dependent device structure for a device referenced
- *  by the acpi handle
+ * Add the dependent device to the dock's dependent device list.
  */
-static struct dock_dependent_device *
-alloc_dock_dependent_device(acpi_handle handle)
+static int
+add_dock_dependent_device(acpi_handle handle, struct dock_station *ds)
 {
 	struct dock_dependent_device *dd;
 
 	dd = kzalloc(sizeof(*dd), GFP_KERNEL);
-	if (dd) {
-		dd->handle = handle;
-		INIT_LIST_HEAD(&dd->list);
-		INIT_LIST_HEAD(&dd->hotplug_list);
-	}
-	return dd;
-}
+	if (!dd)
+		return -ENOMEM;
+
+	dd->handle = handle;
+	INIT_LIST_HEAD(&dd->list);
+	INIT_LIST_HEAD(&dd->hotplug_list);
 
-/**
- * add_dock_dependent_device - associate a device with the dock station
- * @ds: The dock station
- * @dd: The dependent device
- *
- * Add the dependent device to the dock's dependent device list.
- */
-static void
-add_dock_dependent_device(struct dock_station *ds,
-			  struct dock_dependent_device *dd)
-{
 	spin_lock(&ds->dd_lock);
 	list_add_tail(&dd->list, &ds->dependent_devices);
 	spin_unlock(&ds->dd_lock);
+
+	return 0;
 }
 
 /**
@@ -826,7 +816,6 @@ find_dock_devices(acpi_handle handle, u32 lvl, void *context, void **rv)
 	acpi_status status;
 	acpi_handle tmp, parent;
 	struct dock_station *ds = context;
-	struct dock_dependent_device *dd;
 
 	status = acpi_bus_get_ejd(handle, &tmp);
 	if (ACPI_FAILURE(status)) {
@@ -840,11 +829,9 @@ find_dock_devices(acpi_handle handle, u32 lvl, void *context, void **rv)
 			goto fdd_out;
 	}
 
-	if (tmp == ds->handle) {
-		dd = alloc_dock_dependent_device(handle);
-		if (dd)
-			add_dock_dependent_device(ds, dd);
-	}
+	if (tmp == ds->handle)
+		add_dock_dependent_device(ds, handle);
+
 fdd_out:
 	return AE_OK;
 }
@@ -946,7 +933,6 @@ static DEVICE_ATTR(type, S_IRUGO, show_dock_type, NULL);
 static int dock_add(acpi_handle handle)
 {
 	int ret;
-	struct dock_dependent_device *dd;
 	struct dock_station *dock_station;
 	struct platform_device *dock_device;
 
@@ -1010,12 +996,9 @@ static int dock_add(acpi_handle handle)
 			    NULL);
 
 	/* add the dock station as a device dependent on itself */
-	dd = alloc_dock_dependent_device(handle);
-	if (!dd) {
-		ret = -ENOMEM;
+	ret = add_dock_dependent_device(dock_station, handle);
+	if (ret)
 		goto err_unregister5;
-	}
-	add_dock_dependent_device(dock_station, dd);
 
 	dock_station_count++;
 	list_add(&dock_station->sibling, &dock_stations);

