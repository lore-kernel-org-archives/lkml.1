Return-Path: <linux-kernel-owner+w=401wt.eu-S1756606AbYJKGlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606AbYJKGlV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 02:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753904AbYJKGhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 02:37:17 -0400
Received: from vms046pub.verizon.net ([206.46.252.46]:45163 "EHLO
	vms046pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753753AbYJKGhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 02:37:13 -0400
Date: Sat, 11 Oct 2008 02:36:09 -0400
From: Len Brown <lenb@kernel.org>
Subject: [PATCH 49/85] ACPI: WMI: Enable event methods when registering
 notifiers
In-reply-to: <1223707005-26864-1-git-send-email-lenb@kernel.org>
In-reply-to: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>,
       Carlos Corbacho <carlos@strangeworlds.co.uk>,
       Len Brown <len.brown@intel.com>
Message-id: <a66bfa7a4726e9cbdc985133af728a4bd9925d96.1223706853.git.len.brown@intel.com>
Organization: Intel Open Source Technology Center
X-Mailer: git-send-email 1.6.0.2.307.gc427
References: <1223707005-26864-1-git-send-email-lenb@kernel.org>
References: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Garrett <mjg@redhat.com>

According to the ACPI-WMI spec, event blocks may provide a function call
for enabling/disabling them. This patch adds support for making these
calls when registering or removing notifications. Without this, my Dell
firmware provides no data in the event notification.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Carlos Corbacho <carlos@strangeworlds.co.uk>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/wmi.c |   39 +++++++++++++++++++++++++++++++++++++--
 1 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/wmi.c b/drivers/acpi/wmi.c
index cfe2c83..5464cfc 100644
--- a/drivers/acpi/wmi.c
+++ b/drivers/acpi/wmi.c
@@ -217,6 +217,35 @@ static bool find_guid(const char *guid_string, struct wmi_block **out)
 	return 0;
 }
 
+static acpi_status wmi_method_enable(struct wmi_block *wblock, int enable)
+{
+	struct guid_block *block = NULL;
+	char method[5];
+	struct acpi_object_list input;
+	union acpi_object params[1];
+	acpi_status status;
+	acpi_handle handle;
+
+	block = &wblock->gblock;
+	handle = wblock->handle;
+
+	if (!block)
+		return AE_NOT_EXIST;
+
+	input.count = 1;
+	input.pointer = params;
+	params[0].type = ACPI_TYPE_INTEGER;
+	params[0].integer.value = enable;
+
+	snprintf(method, 5, "WE%02X", block->notify_id);
+	status = acpi_evaluate_object(handle, method, &input, NULL);
+
+	if (status != AE_OK && status != AE_NOT_FOUND)
+		return status;
+	else
+		return AE_OK;
+}
+
 /*
  * Exported WMI functions
  */
@@ -427,6 +456,7 @@ acpi_status wmi_install_notify_handler(const char *guid,
 wmi_notify_handler handler, void *data)
 {
 	struct wmi_block *block;
+	acpi_status status;
 
 	if (!guid || !handler)
 		return AE_BAD_PARAMETER;
@@ -441,7 +471,9 @@ wmi_notify_handler handler, void *data)
 	block->handler = handler;
 	block->handler_data = data;
 
-	return AE_OK;
+	status = wmi_method_enable(block, 1);
+
+	return status;
 }
 EXPORT_SYMBOL_GPL(wmi_install_notify_handler);
 
@@ -453,6 +485,7 @@ EXPORT_SYMBOL_GPL(wmi_install_notify_handler);
 acpi_status wmi_remove_notify_handler(const char *guid)
 {
 	struct wmi_block *block;
+	acpi_status status;
 
 	if (!guid)
 		return AE_BAD_PARAMETER;
@@ -464,10 +497,12 @@ acpi_status wmi_remove_notify_handler(const char *guid)
 	if (!block->handler)
 		return AE_NULL_ENTRY;
 
+	status = wmi_method_enable(block, 0);
+
 	block->handler = NULL;
 	block->handler_data = NULL;
 
-	return AE_OK;
+	return status;
 }
 EXPORT_SYMBOL_GPL(wmi_remove_notify_handler);
 
-- 
1.5.5.1

