Return-Path: <linux-kernel-owner+w=401wt.eu-S1754673AbYKMU17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673AbYKMU17 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 15:27:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752354AbYKMU1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 15:27:47 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:47343 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080AbYKMU1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 15:27:44 -0500
Date: Thu, 13 Nov 2008 20:27:39 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: linux-pci@vger.kernel.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] acpiphp: Identify more removable slots
Message-ID: <20081113202739.GA11107@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Garrett <mjg@redhat.com>

According to section 6.3.6 of the ACPI spec, the presence of an _RMV 
method that evaluates to 1 is sufficient to indicate that a slot is 
removable without needing an eject method. This patch refactors the 
ejectable slot detection code a little in order to flag these slots as 
ejectable and register them. Acpihp therefore binds to the expresscard 
slot on my HP test machine.

Signed-off-by: Matthew Garrett <mjg@redhat.com>

---

diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index 955aae4..a17984a 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -74,7 +74,7 @@ static void handle_hotplug_event_func(acpi_handle handle, u32 type, void *contex
  * Ejectable slot should satisfy at least these conditions:
  *
  *  1. has _ADR method
- *  2. has _EJ0 method
+ *  2. has _EJ0 method or _RMV method
  *
  * optionally
  *
@@ -87,6 +87,7 @@ static int is_ejectable(acpi_handle handle)
 {
 	acpi_status status;
 	acpi_handle tmp;
+	int ret = 0;
 
 	status = acpi_get_handle(handle, "_ADR", &tmp);
 	if (ACPI_FAILURE(status)) {
@@ -94,11 +95,14 @@ static int is_ejectable(acpi_handle handle)
 	}
 
 	status = acpi_get_handle(handle, "_EJ0", &tmp);
-	if (ACPI_FAILURE(status)) {
-		return 0;
-	}
+	if (ACPI_SUCCESS(status))
+		ret = 1;
+
+	status = acpi_get_handle(handle, "_RMV", &tmp);
+	if (ACPI_SUCCESS(status))
+		ret = 1;
 
-	return 1;
+	return ret;
 }
 
 
@@ -182,17 +186,26 @@ register_slot(acpi_handle handle, u32 lvl, void *context, void **rv)
 	struct acpiphp_func *newfunc;
 	acpi_handle tmp;
 	acpi_status status = AE_OK;
-	unsigned long long adr, sun;
-	int device, function, retval;
+	unsigned long long adr, sun, removable;
+	int device, function, retval, valid = 0;
 
 	status = acpi_evaluate_integer(handle, "_ADR", NULL, &adr);
 
 	if (ACPI_FAILURE(status))
 		return AE_OK;
 
-	status = acpi_get_handle(handle, "_EJ0", &tmp);
+	status = acpi_get_handle(handle, "_RMV", &tmp);
+	if (ACPI_SUCCESS(status)) {
+		acpi_evaluate_integer(handle, "_RMV", NULL, &removable);
+		if (removable)
+			valid = 1;
+	}
 
-	if (ACPI_FAILURE(status) && !(is_dock_device(handle)))
+	status = acpi_get_handle(handle, "_EJ0", &tmp);
+	if (ACPI_SUCCESS(status) || is_dock_device(handle))
+		valid = 1;
+
+	if (!valid)
 		return AE_OK;
 
 	device = (adr >> 16) & 0xffff;

-- 
Matthew Garrett | mjg59@srcf.ucam.org
