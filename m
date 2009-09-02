Return-Path: <linux-kernel-owner+w=401wt.eu-S1753304AbZIBSNZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304AbZIBSNZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 14:13:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753268AbZIBSNW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 14:13:22 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:40576 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259AbZIBSNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 14:13:21 -0400
From: Matthew Garrett <mjg@redhat.com>
To: robert.moore@intel.com
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 1/3] ACPI: Add infrastructure for refcounting GPE consumers
Date: Wed,  2 Sep 2009 14:12:51 -0400
Message-Id: <1251915173-10144-1-git-send-email-mjg@redhat.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <20090902181014.GA10917@srcf.ucam.org>
References: <20090902181014.GA10917@srcf.ucam.org>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 146.115.120.20
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACPI GPEs may map to multiple devices. The current GPE interface only
provides a mechanism for enabling and disabling GPEs, making it difficult
to change the state of GPEs at runtime without extensive cooperation
between devices. Add an API to allow devices to indicate whether or not
they want their device's GPE to be enabled for both runtime and wakeup
events.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/acpi/acpica/aclocal.h  |    2 +
 drivers/acpi/acpica/evxfevnt.c |  161 ++++++++++++++++++++++++++++++++++++++++
 include/acpi/acpixf.h          |    8 ++
 3 files changed, 171 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/acpica/aclocal.h b/drivers/acpi/acpica/aclocal.h
index ee986ed..935e351 100644
--- a/drivers/acpi/acpica/aclocal.h
+++ b/drivers/acpi/acpica/aclocal.h
@@ -413,6 +413,8 @@ struct acpi_gpe_event_info {
 	struct acpi_gpe_register_info *register_info;	/* Backpointer to register info */
 	u8 flags;		/* Misc info about this GPE */
 	u8 gpe_number;		/* This GPE */
+	u8 runtime_count;
+	u8 wakeup_count;
 };
 
 /* Information about a GPE register pair, one per each status/enable pair in an array */
diff --git a/drivers/acpi/acpica/evxfevnt.c b/drivers/acpi/acpica/evxfevnt.c
index 4721f58..2a98818 100644
--- a/drivers/acpi/acpica/evxfevnt.c
+++ b/drivers/acpi/acpica/evxfevnt.c
@@ -201,6 +201,167 @@ ACPI_EXPORT_SYMBOL(acpi_enable_event)
 
 /*******************************************************************************
  *
+ * FUNCTION:    acpi_get_runtime_gpe
+ *
+ * PARAMETERS:  gpe_device      - Parent GPE Device
+ *              gpe_number      - GPE level within the GPE block
+ *
+ * RETURN:      Status
+ *
+ * DESCRIPTION: Take a reference to a runtime GPE
+ *
+ ******************************************************************************/
+acpi_status acpi_get_runtime_gpe(acpi_handle gpe_device, u32 gpe_number)
+{
+	acpi_status status = AE_OK;
+	acpi_cpu_flags flags;
+	struct acpi_gpe_event_info *gpe_event_info;
+
+	ACPI_FUNCTION_TRACE(acpi_get_runtime_gpe);
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
+ACPI_EXPORT_SYMBOL(acpi_get_runtime_gpe)
+
+/*******************************************************************************
+ *
+ * FUNCTION:    acpi_put_runtime_gpe
+ *
+ * PARAMETERS:  gpe_device      - Parent GPE Device
+ *              gpe_number      - GPE level within the GPE block
+ *
+ * RETURN:      Status
+ *
+ * DESCRIPTION: Release a reference to a runtime GPE
+ *
+ ******************************************************************************/
+acpi_status acpi_put_runtime_gpe(acpi_handle gpe_device, u32 gpe_number)
+{
+	acpi_status status = AE_OK;
+	acpi_cpu_flags flags;
+	struct acpi_gpe_event_info *gpe_event_info;
+
+	ACPI_FUNCTION_TRACE(acpi_put_runtime_gpe);
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
+ACPI_EXPORT_SYMBOL(acpi_put_runtime_gpe)
+
+/*******************************************************************************
+ *
+ * FUNCTION:    acpi_get_wakeup_gpe
+ *
+ * PARAMETERS:  gpe_device      - Parent GPE Device
+ *              gpe_number      - GPE level within the GPE block
+ *
+ * RETURN:      Status
+ *
+ * DESCRIPTION: Take a reference to a wakeup GPE
+ *
+ ******************************************************************************/
+acpi_status acpi_get_wakeup_gpe(acpi_handle gpe_device, u32 gpe_number)
+{
+	acpi_status status = AE_OK;
+	acpi_cpu_flags flags;
+	struct acpi_gpe_event_info *gpe_event_info;
+
+	ACPI_FUNCTION_TRACE(acpi_get_wakeup_gpe);
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
+ACPI_EXPORT_SYMBOL(acpi_get_wakeup_gpe)
+
+/*******************************************************************************
+ *
+ * FUNCTION:    acpi_put_wakeup_gpe
+ *
+ * PARAMETERS:  gpe_device      - Parent GPE Device
+ *              gpe_number      - GPE level within the GPE block
+ *
+ * RETURN:      Status
+ *
+ * DESCRIPTION: Release a reference to a wakeup GPE
+ *
+ ******************************************************************************/
+acpi_status acpi_put_wakeup_gpe(acpi_handle gpe_device, u32 gpe_number)
+{
+	acpi_status status = AE_OK;
+	acpi_cpu_flags flags;
+	struct acpi_gpe_event_info *gpe_event_info;
+
+	ACPI_FUNCTION_TRACE(acpi_put_wakeup_gpe);
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
+ACPI_EXPORT_SYMBOL(acpi_put_wakeup_gpe)
+
+/*******************************************************************************
+ *
  * FUNCTION:    acpi_set_gpe_type
  *
  * PARAMETERS:  gpe_device      - Parent GPE Device
diff --git a/include/acpi/acpixf.h b/include/acpi/acpixf.h
index 82ec6a3..671e699 100644
--- a/include/acpi/acpixf.h
+++ b/include/acpi/acpixf.h
@@ -280,6 +280,14 @@ acpi_status acpi_get_event_status(u32 event, acpi_event_status * event_status);
  */
 acpi_status acpi_set_gpe_type(acpi_handle gpe_device, u32 gpe_number, u8 type);
 
+acpi_status acpi_get_runtime_gpe(acpi_handle gpe_device, u32 gpe_number);
+
+acpi_status acpi_put_runtime_gpe(acpi_handle gpe_device, u32 gpe_number);
+
+acpi_status acpi_get_wakeup_gpe(acpi_handle gpe_device, u32 gpe_number);
+
+acpi_status acpi_put_wakeup_gpe(acpi_handle gpe_device, u32 gpe_number);
+
 acpi_status acpi_enable_gpe(acpi_handle gpe_device, u32 gpe_number);
 
 acpi_status acpi_disable_gpe(acpi_handle gpe_device, u32 gpe_number);
-- 
1.6.2.5

