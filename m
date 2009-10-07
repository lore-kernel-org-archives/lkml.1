Return-Path: <linux-kernel-owner+w=401wt.eu-S1755301AbZJGWIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301AbZJGWIc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 18:08:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755223AbZJGWIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 18:08:31 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:44703 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755173AbZJGWI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 18:08:29 -0400
Subject: [PATCH 5/6] ACPI: dock: combine add|alloc_dock_dependent_device
To: lenb@kernel.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 07 Oct 2009 16:07:52 -0600
Message-ID: <20091007220752.15597.25461.stgit@bob.kio>
In-Reply-To: <20091007220509.15597.65501.stgit@bob.kio>
References: <20091007220509.15597.65501.stgit@bob.kio>
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
index e53d49b..ce36b6c 100644
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
@@ -941,7 +928,6 @@ static DEVICE_ATTR(type, S_IRUGO, show_dock_type, NULL);
 static int dock_add(acpi_handle handle)
 {
 	int ret;
-	struct dock_dependent_device *dd;
 	struct dock_station *ds;
 	struct platform_device *dock_device;
 
@@ -1006,12 +992,9 @@ static int dock_add(acpi_handle handle)
 			    NULL);
 
 	/* add the dock station as a device dependent on itself */
-	dd = alloc_dock_dependent_device(handle);
-	if (!dd) {
-		ret = -ENOMEM;
+	ret = add_dock_dependent_device(ds, handle);
+	if (ret)
 		goto err_unregister5;
-	}
-	add_dock_dependent_device(ds, dd);
 
 	dock_station_count++;
 	list_add(&ds->sibling, &dock_stations);

