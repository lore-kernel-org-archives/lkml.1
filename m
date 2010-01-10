Return-Path: <linux-kernel-owner+w=401wt.eu-S1753331Ab0AJOEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331Ab0AJOEy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 09:04:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753226Ab0AJOEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 09:04:53 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:56626 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753207Ab0AJOEw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 09:04:52 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH 4/9] ACPI: Add infrastructure for refcounting GPE consumers
Date: Sun, 10 Jan 2010 14:38:34 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc3-rjw; KDE/4.3.3; x86_64; ; )
Cc: "Moore, Robert" <robert.moore@intel.com>, Matthew Garrett <mjg@redhat.com>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Oliver Neukum <oliver@neukum.org>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Shaohua Li <shaohua.li@intel.com>
References: <201001101431.38630.rjw@sisk.pl>
In-Reply-To: <201001101431.38630.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001101438.35087.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Garrett <mjg@redhat.com>

ACPI GPEs may map to multiple devices. The current GPE interface only
provides a mechanism for enabling and disabling GPEs, making it difficult
to change the state of GPEs at runtime without extensive cooperation
between devices. Add an API to allow devices to indicate whether or not
they want their device's GPE to be enabled for both runtime and wakeup
events.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
drivers/acpi/acpica/aclocal.h  |    2 +
 drivers/acpi/acpica/aclocal.h  |    2 
 drivers/acpi/acpica/evxfevnt.c |  161 +++++++++++++++++++++++++++++++++++++++++
 include/acpi/acpixf.h          |    8 ++
 3 files changed, 171 insertions(+)

Index: linux-2.6/drivers/acpi/acpica/aclocal.h
===================================================================
--- linux-2.6.orig/drivers/acpi/acpica/aclocal.h
+++ linux-2.6/drivers/acpi/acpica/aclocal.h
@@ -426,6 +426,8 @@ struct acpi_gpe_event_info {
 	struct acpi_gpe_register_info *register_info;	/* Backpointer to register info */
 	u8 flags;		/* Misc info about this GPE */
 	u8 gpe_number;		/* This GPE */
+	u8 runtime_count;
+	u8 wakeup_count;
 };
 
 /* Information about a GPE register pair, one per each status/enable pair in an array */
Index: linux-2.6/drivers/acpi/acpica/evxfevnt.c
===================================================================
--- linux-2.6.orig/drivers/acpi/acpica/evxfevnt.c
+++ linux-2.6/drivers/acpi/acpica/evxfevnt.c
@@ -201,6 +201,167 @@ ACPI_EXPORT_SYMBOL(acpi_enable_event)
 
 /*******************************************************************************
  *
+ * FUNCTION:    acpi_ref_runtime_gpe
+ *
+ * PARAMETERS:  gpe_device      - Parent GPE Device
+ *              gpe_number      - GPE level within the GPE block
+ *
+ * RETURN:      Status
+ *
+ * DESCRIPTION: Take a reference to a runtime GPE
+ *
+ ******************************************************************************/
+acpi_status acpi_ref_runtime_gpe(acpi_handle gpe_device, u32 gpe_number)
+{
+	acpi_status status = AE_OK;
+	acpi_cpu_flags flags;
+	struct acpi_gpe_event_info *gpe_event_info;
+
+	ACPI_FUNCTION_TRACE(acpi_ref_runtime_gpe);
+
+	flags = acpi_os_acquire_lock(acpi_gbl_gpe_lock);
+
+	/* Ensure that we have a valid GPE number */
+
+	gpe_event_info = acpi_ev_get_gpe_event_info(gpe_device, gpe_number);
+	if (!gpe_event_info) {
+		status = AE_BAD_PARAMETER;
+		goto unlock_and_exit;
+	}
+
+	if (++gpe_event_info->runtime_count == 1)
+		status = acpi_ev_enable_gpe(gpe_event_info, TRUE);
+
+	if (ACPI_FAILURE(status))
+		gpe_event_info->runtime_count--;
+
+unlock_and_exit:
+	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
+	return_ACPI_STATUS(status);
+}
+ACPI_EXPORT_SYMBOL(acpi_ref_runtime_gpe)
+
+/*******************************************************************************
+ *
+ * FUNCTION:    acpi_unref_runtime_gpe
+ *
+ * PARAMETERS:  gpe_device      - Parent GPE Device
+ *              gpe_number      - GPE level within the GPE block
+ *
+ * RETURN:      Status
+ *
+ * DESCRIPTION: Release a reference to a runtime GPE
+ *
+ ******************************************************************************/
+acpi_status acpi_unref_runtime_gpe(acpi_handle gpe_device, u32 gpe_number)
+{
+	acpi_status status = AE_OK;
+	acpi_cpu_flags flags;
+	struct acpi_gpe_event_info *gpe_event_info;
+
+	ACPI_FUNCTION_TRACE(acpi_unref_runtime_gpe);
+
+	flags = acpi_os_acquire_lock(acpi_gbl_gpe_lock);
+
+	/* Ensure that we have a valid GPE number */
+
+	gpe_event_info = acpi_ev_get_gpe_event_info(gpe_device, gpe_number);
+	if (!gpe_event_info) {
+		status = AE_BAD_PARAMETER;
+		goto unlock_and_exit;
+	}
+
+	if (--gpe_event_info->runtime_count == 0)
+		acpi_ev_disable_gpe(gpe_event_info);
+
+unlock_and_exit:
+	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
+	return_ACPI_STATUS(status);
+}
+ACPI_EXPORT_SYMBOL(acpi_unref_runtime_gpe)
+
+/*******************************************************************************
+ *
+ * FUNCTION:    acpi_ref_wakeup_gpe
+ *
+ * PARAMETERS:  gpe_device      - Parent GPE Device
+ *              gpe_number      - GPE level within the GPE block
+ *
+ * RETURN:      Status
+ *
+ * DESCRIPTION: Take a reference to a wakeup GPE
+ *
+ ******************************************************************************/
+acpi_status acpi_ref_wakeup_gpe(acpi_handle gpe_device, u32 gpe_number)
+{
+	acpi_status status = AE_OK;
+	acpi_cpu_flags flags;
+	struct acpi_gpe_event_info *gpe_event_info;
+
+	ACPI_FUNCTION_TRACE(acpi_ref_wakeup_gpe);
+
+	flags = acpi_os_acquire_lock(acpi_gbl_gpe_lock);
+
+	/* Ensure that we have a valid GPE number */
+
+	gpe_event_info = acpi_ev_get_gpe_event_info(gpe_device, gpe_number);
+	if (!gpe_event_info) {
+		status = AE_BAD_PARAMETER;
+		goto unlock_and_exit;
+	}
+
+	if (++gpe_event_info->wakeup_count == 1)
+		acpi_ev_update_gpe_enable_masks(gpe_event_info,
+						ACPI_GPE_ENABLE);
+
+unlock_and_exit:
+	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
+	return_ACPI_STATUS(status);
+}
+ACPI_EXPORT_SYMBOL(acpi_ref_wakeup_gpe)
+
+/*******************************************************************************
+ *
+ * FUNCTION:    acpi_unref_wakeup_gpe
+ *
+ * PARAMETERS:  gpe_device      - Parent GPE Device
+ *              gpe_number      - GPE level within the GPE block
+ *
+ * RETURN:      Status
+ *
+ * DESCRIPTION: Release a reference to a wakeup GPE
+ *
+ ******************************************************************************/
+acpi_status acpi_unref_wakeup_gpe(acpi_handle gpe_device, u32 gpe_number)
+{
+	acpi_status status = AE_OK;
+	acpi_cpu_flags flags;
+	struct acpi_gpe_event_info *gpe_event_info;
+
+	ACPI_FUNCTION_TRACE(acpi_unref_wakeup_gpe);
+
+	flags = acpi_os_acquire_lock(acpi_gbl_gpe_lock);
+
+	/* Ensure that we have a valid GPE number */
+
+	gpe_event_info = acpi_ev_get_gpe_event_info(gpe_device, gpe_number);
+	if (!gpe_event_info) {
+		status = AE_BAD_PARAMETER;
+		goto unlock_and_exit;
+	}
+
+	if (--gpe_event_info->wakeup_count == 0)
+		acpi_ev_update_gpe_enable_masks(gpe_event_info,
+			ACPI_GPE_DISABLE);
+
+unlock_and_exit:
+	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
+	return_ACPI_STATUS(status);
+}
+ACPI_EXPORT_SYMBOL(acpi_unref_wakeup_gpe)
+
+/*******************************************************************************
+ *
  * FUNCTION:    acpi_set_gpe_type
  *
  * PARAMETERS:  gpe_device      - Parent GPE Device
Index: linux-2.6/include/acpi/acpixf.h
===================================================================
--- linux-2.6.orig/include/acpi/acpixf.h
+++ linux-2.6/include/acpi/acpixf.h
@@ -283,6 +283,14 @@ acpi_status acpi_get_event_status(u32 ev
  */
 acpi_status acpi_set_gpe_type(acpi_handle gpe_device, u32 gpe_number, u8 type);
 
+acpi_status acpi_ref_runtime_gpe(acpi_handle gpe_device, u32 gpe_number);
+
+acpi_status acpi_unref_runtime_gpe(acpi_handle gpe_device, u32 gpe_number);
+
+acpi_status acpi_ref_wakeup_gpe(acpi_handle gpe_device, u32 gpe_number);
+
+acpi_status acpi_unref_wakeup_gpe(acpi_handle gpe_device, u32 gpe_number);
+
 acpi_status acpi_enable_gpe(acpi_handle gpe_device, u32 gpe_number);
 
 acpi_status acpi_disable_gpe(acpi_handle gpe_device, u32 gpe_number);

