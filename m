Return-Path: <linux-kernel-owner+w=401wt.eu-S1760132AbYJMV3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760132AbYJMV3V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 17:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754451AbYJMV3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 17:29:08 -0400
Received: from mga14.intel.com ([143.182.124.37]:26743 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754071AbYJMV3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 17:29:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,405,1220252400"; 
   d="scan'208";a="59312201"
Date: Mon, 13 Oct 2008 14:28:39 -0700
Message-Id: <200810132128.m9DLSdal028794@los-vmm.sc.intel.com>
Subject: [PATCH] Fix possible NULL ptr dereference in ACPI code
To: linux-kernel@vger.kernel.org
From: donald.d.dugger@intel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Code in file `drivers/acpi/pci_link.c' is attempting to evaluate the _DIS
method to disable a link.  Unfortunately, the method code unconditionally
uses the last argument as a pointer on success so passing a NULL could
wind up dereferencing 0.  This patch just passes an appropriate pointer
to avoid this issue.

Signed-off-by: Don Dugger <donald.d.dugger@intel.com>

----- cut here for acpi-1013.patch -----
diff --git a/drivers/acpi/pci_link.c b/drivers/acpi/pci_link.c
index cf47805..1d03a1f 100644
--- a/drivers/acpi/pci_link.c
+++ b/drivers/acpi/pci_link.c
@@ -671,6 +671,7 @@ int acpi_pci_link_free_irq(acpi_handle handle)
 {
 	struct acpi_device *device = NULL;
 	struct acpi_pci_link *link = NULL;
+	union acpi_operand_object *dummy;
 	acpi_status result;
 
 
@@ -709,7 +710,7 @@ int acpi_pci_link_free_irq(acpi_handle handle)
 			  acpi_device_bid(link->device)));
 
 	if (link->refcnt == 0) {
-		acpi_ut_evaluate_object(link->device->handle, "_DIS", 0, NULL);
+		acpi_ut_evaluate_object(link->device->handle, "_DIS", 0, &dummy);
 	}
 	mutex_unlock(&acpi_link_lock);
 	return (link->irq.active);
@@ -721,6 +722,7 @@ int acpi_pci_link_free_irq(acpi_handle handle)
 
 static int acpi_pci_link_add(struct acpi_device *device)
 {
+	union acpi_operand_object *dummy;
 	int result = 0;
 	struct acpi_pci_link *link = NULL;
 	int i = 0;
@@ -773,7 +775,7 @@ static int acpi_pci_link_add(struct acpi_device *device)
 
       end:
 	/* disable all links -- to be activated on use */
-	acpi_ut_evaluate_object(device->handle, "_DIS", 0, NULL);
+	acpi_ut_evaluate_object(device->handle, "_DIS", 0, &dummy);
 	mutex_unlock(&acpi_link_lock);
 
 	if (result)
