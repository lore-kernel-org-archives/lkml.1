Return-Path: <linux-kernel-owner+w=401wt.eu-S1755213AbZJGWI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213AbZJGWI1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 18:08:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755173AbZJGWI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 18:08:26 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:1193 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755146AbZJGWIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 18:08:24 -0400
Subject: [PATCH 4/6] ACPI: dock: add struct dock_station * directly to
	platform device data
To: lenb@kernel.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 07 Oct 2009 16:07:47 -0600
Message-ID: <20091007220747.15597.90592.stgit@bob.kio>
In-Reply-To: <20091007220509.15597.65501.stgit@bob.kio>
References: <20091007220509.15597.65501.stgit@bob.kio>
User-Agent: StGit/0.14.3.386.gb02d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of adding a (struct dock_station **) to our dock device's
platform data, we can add the (struct dock_station *) directly.

This change saves us some silly casting.

Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/acpi/dock.c |   19 +++++++------------
 1 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
index 1d693a1..e53d49b 100644
--- a/drivers/acpi/dock.c
+++ b/drivers/acpi/dock.c
@@ -857,8 +857,7 @@ static ssize_t show_docked(struct device *dev,
 {
 	struct acpi_device *tmp;
 
-	struct dock_station *dock_station = *((struct dock_station **)
-		dev->platform_data);
+	struct dock_station *dock_station = dev->platform_data;
 
 	if (ACPI_SUCCESS(acpi_bus_get_device(dock_station->handle, &tmp)))
 		return snprintf(buf, PAGE_SIZE, "1\n");
@@ -872,8 +871,7 @@ static DEVICE_ATTR(docked, S_IRUGO, show_docked, NULL);
 static ssize_t show_flags(struct device *dev,
 			  struct device_attribute *attr, char *buf)
 {
-	struct dock_station *dock_station = *((struct dock_station **)
-		dev->platform_data);
+	struct dock_station *dock_station = dev->platform_data;
 	return snprintf(buf, PAGE_SIZE, "%d\n", dock_station->flags);
 
 }
@@ -886,8 +884,7 @@ static ssize_t write_undock(struct device *dev, struct device_attribute *attr,
 			   const char *buf, size_t count)
 {
 	int ret;
-	struct dock_station *dock_station = *((struct dock_station **)
-		dev->platform_data);
+	struct dock_station *dock_station = dev->platform_data;
 
 	if (!count)
 		return -EINVAL;
@@ -905,8 +902,7 @@ static ssize_t show_dock_uid(struct device *dev,
 			     struct device_attribute *attr, char *buf)
 {
 	unsigned long long lbuf;
-	struct dock_station *dock_station = *((struct dock_station **)
-		dev->platform_data);
+	struct dock_station *dock_station = dev->platform_data;
 	acpi_status status = acpi_evaluate_integer(dock_station->handle,
 					"_UID", NULL, &lbuf);
 	if (ACPI_FAILURE(status))
@@ -919,8 +915,7 @@ static DEVICE_ATTR(uid, S_IRUGO, show_dock_uid, NULL);
 static ssize_t show_dock_type(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
-	struct dock_station *dock_station = *((struct dock_station **)
-		dev->platform_data);
+	struct dock_station *dock_station = dev->platform_data;
 	char *type;
 
 	if (dock_station->flags & DOCK_IS_DOCK)
@@ -972,8 +967,8 @@ static int dock_add(acpi_handle handle)
 	if (ret)
 		goto err_free;
 
-	platform_device_add_data(dock_device, &ds,
-		sizeof(struct dock_station *));
+	platform_device_add_data(dock_device, ds,
+		sizeof(struct dock_station));
 
 	/* we want the dock device to send uevents */
 	dev_set_uevent_suppress(&dock_device->dev, 0);

