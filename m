Return-Path: <linux-kernel-owner+w=401wt.eu-S1756080AbYKMXyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080AbYKMXyX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 18:54:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752625AbYKMXyA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 18:54:00 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:41205 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510AbYKMXx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 18:53:58 -0500
Date: Thu, 13 Nov 2008 23:53:54 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: linux-pci@vger.kernel.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] acpiphp: Call _LCK method
Message-ID: <20081113235354.GB17709@srcf.ucam.org>
References: <20081113235255.GA17709@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081113235255.GA17709@srcf.ucam.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Garrett <mjg@redhat.com>

Removable ACPI devices may have _LCK methods to indicate a software 
controlled lock. These should be locked on device insertion and unlocked 
when the user requests the device be ejected. Add support for flagging 
devices with a _LCK method and then call appropriately on the add and 
eject paths.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/pci/hotplug/acpiphp.h      |    1 +
 drivers/pci/hotplug/acpiphp_glue.c |   45 +++++++++++++++++++++++++++++++++++-
 2 files changed, 45 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/hotplug/acpiphp.h b/drivers/pci/hotplug/acpiphp.h
index f9e244d..c07a4e8 100644
--- a/drivers/pci/hotplug/acpiphp.h
+++ b/drivers/pci/hotplug/acpiphp.h
@@ -194,6 +194,7 @@ struct acpiphp_ioapic {
 #define FUNC_HAS_PS2		(0x00000040)
 #define FUNC_HAS_PS3		(0x00000080)
 #define FUNC_HAS_DCK            (0x00000100)
+#define FUNC_HAS_LCK            (0x00000200)
 
 /* function prototypes */
 
diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index e8cef99..a83788d 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -222,6 +222,9 @@ register_slot(acpi_handle handle, u32 lvl, void *context, void **rv)
 	if (ACPI_SUCCESS(acpi_get_handle(handle, "_DCK", &tmp)))
 		newfunc->flags |= FUNC_HAS_DCK;
 
+	if (ACPI_SUCCESS(acpi_get_handle(handle, "_LCK", &tmp)))
+		newfunc->flags |= FUNC_HAS_LCK;
+
 	status = acpi_evaluate_integer(handle, "_SUN", NULL, &sun);
 	if (ACPI_FAILURE(status)) {
 		/*
@@ -1310,6 +1313,21 @@ int acpiphp_eject_slot(struct acpiphp_slot *slot)
 	list_for_each (l, &slot->funcs) {
 		func = list_entry(l, struct acpiphp_func, sibling);
 
+		if ((func->flags & FUNC_HAS_LCK)) {
+			arg_list.count = 1;
+			arg_list.pointer = &arg;
+			arg.type = ACPI_TYPE_INTEGER;
+			arg.integer.value = 0;
+
+			status = acpi_evaluate_object(func->handle, "_LCK",
+						      &arg_list, NULL);
+			if (ACPI_FAILURE(status)) {
+				warn("%s: _LCK failed\n", __func__);
+				return -1;
+			} else
+				break;
+		}
+
 		/* We don't want to call _EJ0 on non-existing functions. */
 		if ((func->flags & FUNC_HAS_EJ0)) {
 			/* _EJ0 method take one argument */
@@ -1318,7 +1336,8 @@ int acpiphp_eject_slot(struct acpiphp_slot *slot)
 			arg.type = ACPI_TYPE_INTEGER;
 			arg.integer.value = 1;
 
-			status = acpi_evaluate_object(func->handle, "_EJ0", &arg_list, NULL);
+			status = acpi_evaluate_object(func->handle, "_EJ0",
+						      &arg_list, NULL);
 			if (ACPI_FAILURE(status)) {
 				warn("%s: _EJ0 failed\n", __func__);
 				return -1;
@@ -1802,6 +1821,11 @@ static int acpiphp_for_each_slot(acpiphp_callback fn, void *data)
 int acpiphp_enable_slot(struct acpiphp_slot *slot)
 {
 	int retval;
+	acpi_status status;
+	struct acpiphp_func *func;
+	struct list_head *l;
+	struct acpi_object_list arg_list;
+	union acpi_object arg;
 
 	mutex_lock(&slot->crit_sect);
 
@@ -1810,6 +1834,25 @@ int acpiphp_enable_slot(struct acpiphp_slot *slot)
 	if (retval)
 		goto err_exit;
 
+	list_for_each(l, &slot->funcs) {
+		func = list_entry(l, struct acpiphp_func, sibling);
+
+		if ((func->flags & FUNC_HAS_LCK)) {
+			arg_list.count = 1;
+			arg_list.pointer = &arg;
+			arg.type = ACPI_TYPE_INTEGER;
+			arg.integer.value = 1;
+
+			status = acpi_evaluate_object(func->handle, "_LCK",
+						      &arg_list, NULL);
+			if (ACPI_FAILURE(status)) {
+				warn("%s: _LCK failed\n", __func__);
+				return -1;
+			} else
+				break;
+		}
+	}
+
 	if (get_slot_status(slot) == ACPI_STA_ALL) {
 		/* configure all functions */
 		retval = enable_device(slot);
-- 
Matthew Garrett | mjg59@srcf.ucam.org
