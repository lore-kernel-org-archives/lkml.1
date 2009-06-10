Return-Path: <linux-kernel-owner+w=401wt.eu-S1761561AbZFJT4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761561AbZFJT4b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 15:56:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761470AbZFJTzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 15:55:35 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:7669 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761091AbZFJTzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 15:55:22 -0400
Subject: [PATCH v3 04/12] ACPI: rearrange acpi_pci_bind/acpi_pci_unbind in
	pci_bind.c
To: lenb@kernel.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Date: Wed, 10 Jun 2009 13:55:25 -0600
Message-ID: <20090610195525.28982.43678.stgit@bob.kio>
In-Reply-To: <20090610194714.28982.51363.stgit@bob.kio>
References: <20090610194714.28982.51363.stgit@bob.kio>
User-Agent: StGit/0.14.3.347.g594a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a pure code movement patch that does $subject in order
to make the following patch easier to read and review.

No functional change.

Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/acpi/pci_bind.c |   90 ++++++++++++++++++++++++-----------------------
 1 files changed, 45 insertions(+), 45 deletions(-)

diff --git a/drivers/acpi/pci_bind.c b/drivers/acpi/pci_bind.c
index 236765c..c283c29 100644
--- a/drivers/acpi/pci_bind.c
+++ b/drivers/acpi/pci_bind.c
@@ -109,6 +109,51 @@ acpi_status acpi_get_pci_id(acpi_handle handle, struct acpi_pci_id *id)
 
 EXPORT_SYMBOL(acpi_get_pci_id);
 
+static int acpi_pci_unbind(struct acpi_device *device)
+{
+	int result = 0;
+	acpi_status status;
+	struct acpi_pci_data *data;
+	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
+
+
+	if (!device || !device->parent)
+		return -EINVAL;
+
+	status = acpi_get_name(device->handle, ACPI_FULL_PATHNAME, &buffer);
+	if (ACPI_FAILURE(status))
+		return -ENODEV;
+
+	ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Unbinding PCI device [%s]...\n",
+			  (char *) buffer.pointer));
+	kfree(buffer.pointer);
+
+	status =
+	    acpi_get_data(device->handle, acpi_pci_data_handler,
+			  (void **)&data);
+	if (ACPI_FAILURE(status)) {
+		result = -ENODEV;
+		goto end;
+	}
+
+	status = acpi_detach_data(device->handle, acpi_pci_data_handler);
+	if (ACPI_FAILURE(status)) {
+		ACPI_EXCEPTION((AE_INFO, status,
+				"Unable to detach data from device %s",
+				acpi_device_bid(device)));
+		result = -ENODEV;
+		goto end;
+	}
+	if (data->dev->subordinate) {
+		acpi_pci_irq_del_prt(data->id.segment, data->bus->number);
+	}
+	pci_dev_put(data->dev);
+	kfree(data);
+
+      end:
+	return result;
+}
+
 static int acpi_pci_bind(struct acpi_device *device)
 {
 	int result = 0;
@@ -253,51 +298,6 @@ static int acpi_pci_bind(struct acpi_device *device)
 	return result;
 }
 
-static int acpi_pci_unbind(struct acpi_device *device)
-{
-	int result = 0;
-	acpi_status status;
-	struct acpi_pci_data *data;
-	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
-
-
-	if (!device || !device->parent)
-		return -EINVAL;
-
-	status = acpi_get_name(device->handle, ACPI_FULL_PATHNAME, &buffer);
-	if (ACPI_FAILURE(status))
-		return -ENODEV;
-
-	ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Unbinding PCI device [%s]...\n",
-			  (char *) buffer.pointer));
-	kfree(buffer.pointer);
-
-	status =
-	    acpi_get_data(device->handle, acpi_pci_data_handler,
-			  (void **)&data);
-	if (ACPI_FAILURE(status)) {
-		result = -ENODEV;
-		goto end;
-	}
-
-	status = acpi_detach_data(device->handle, acpi_pci_data_handler);
-	if (ACPI_FAILURE(status)) {
-		ACPI_EXCEPTION((AE_INFO, status,
-				"Unable to detach data from device %s",
-				acpi_device_bid(device)));
-		result = -ENODEV;
-		goto end;
-	}
-	if (data->dev->subordinate) {
-		acpi_pci_irq_del_prt(data->id.segment, data->bus->number);
-	}
-	pci_dev_put(data->dev);
-	kfree(data);
-
-      end:
-	return result;
-}
-
 int
 acpi_pci_bind_root(struct acpi_device *device,
 		   struct acpi_pci_id *id, struct pci_bus *bus)

