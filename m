Return-Path: <linux-kernel-owner+w=401wt.eu-S1754919AbYKMUaJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919AbYKMUaJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 15:30:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752009AbYKMU3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 15:29:55 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:36135 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007AbYKMU3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 15:29:54 -0500
Date: Thu, 13 Nov 2008 20:29:49 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: linux-pci@vger.kernel.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] acpiphp: Call _LCK method
Message-ID: <20081113202949.GB11107@srcf.ucam.org>
References: <20081113202739.GA11107@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081113202739.GA11107@srcf.ucam.org>
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
index 955aae4..a17984a 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -220,6 +233,9 @@ register_slot(acpi_handle handle, u32 lvl, void *context, void **rv)
 	if (ACPI_SUCCESS(acpi_get_handle(handle, "_DCK", &tmp)))
 		newfunc->flags |= FUNC_HAS_DCK;
 
+	if (ACPI_SUCCESS(acpi_get_handle(handle, "_LCK", &tmp)))
+		newfunc->flags |= FUNC_HAS_LCK;
+
 	status = acpi_evaluate_integer(handle, "_SUN", NULL, &sun);
 	if (ACPI_FAILURE(status)) {
 		/*
@@ -1308,6 +1324,20 @@ int acpiphp_eject_slot(struct acpiphp_slot *slot)
 	list_for_each (l, &slot->funcs) {
 		func = list_entry(l, struct acpiphp_func, sibling);
 
+		if ((func->flags & FUNC_HAS_LCK)) {
+			arg_list.count = 1;
+			arg_list.pointer = &arg;
+			arg.type = ACPI_TYPE_INTEGER;
+			arg.integer.value = 0;
+
+			status = acpi_evaluate_object(func->handle, "_LCK", &arg_list, NULL);
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
@@ -1800,6 +1830,11 @@ static int acpiphp_for_each_slot(acpiphp_callback fn, void *data)
 int acpiphp_enable_slot(struct acpiphp_slot *slot)
 {
 	int retval;
+	acpi_status status;
+	struct acpiphp_func *func;
+	struct list_head *l;
+	struct acpi_object_list arg_list;
+	union acpi_object arg;
 
 	mutex_lock(&slot->crit_sect);
 
@@ -1808,6 +1843,24 @@ int acpiphp_enable_slot(struct acpiphp_slot *slot)
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
+			status = acpi_evaluate_object(func->handle, "_LCK", &arg_list, NULL);
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
