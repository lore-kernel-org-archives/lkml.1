Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933478Ab0BDRfu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 12:35:50 -0500
Received: from kroah.org ([198.145.64.141]:34624 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758513Ab0BDRVh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 12:21:37 -0500
X-Mailbox-Line: From linux@linux.site Thu Feb  4 09:14:55 2010
Message-Id: <20100204171455.136424630@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 04 Feb 2010 09:11:45 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Shaohua Li <shaohua.li@intel.com>, Len Brown <len.brown@intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [14/74] ACPI: fix OSC regression that caused aer and pciehp not to load
In-Reply-To: <20100204171850.GA16539@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Shaohua Li <shaohua.li@intel.com>

commit 9dc130fccb874f2959ef313d7922d306dc6d4f75 upstream.

Executing _OSC returns a buffer, which has an acpi object in it.
Don't directly returns the buffer, instead, we return the acpi object's
buffer. This fixes a regression since caller of acpi_run_osc expects
an acpi object's buffer returned.

Tested-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/bus.c |   26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -397,6 +397,7 @@ acpi_status acpi_run_osc(acpi_handle han
 	union acpi_object *out_obj;
 	u8 uuid[16];
 	u32 errors;
+	struct acpi_buffer output = {ACPI_ALLOCATE_BUFFER, NULL};
 
 	if (!context)
 		return AE_ERROR;
@@ -419,16 +420,16 @@ acpi_status acpi_run_osc(acpi_handle han
 	in_params[3].buffer.length 	= context->cap.length;
 	in_params[3].buffer.pointer 	= context->cap.pointer;
 
-	status = acpi_evaluate_object(handle, "_OSC", &input, &context->ret);
+	status = acpi_evaluate_object(handle, "_OSC", &input, &output);
 	if (ACPI_FAILURE(status))
 		return status;
 
-	/* return buffer should have the same length as cap buffer */
-	if (context->ret.length != context->cap.length)
+	if (!output.length)
 		return AE_NULL_OBJECT;
 
-	out_obj = context->ret.pointer;
-	if (out_obj->type != ACPI_TYPE_BUFFER) {
+	out_obj = output.pointer;
+	if (out_obj->type != ACPI_TYPE_BUFFER
+		|| out_obj->buffer.length != context->cap.length) {
 		acpi_print_osc_error(handle, context,
 			"_OSC evaluation returned wrong type");
 		status = AE_TYPE;
@@ -457,11 +458,20 @@ acpi_status acpi_run_osc(acpi_handle han
 		goto out_kfree;
 	}
 out_success:
-	return AE_OK;
+	context->ret.length = out_obj->buffer.length;
+	context->ret.pointer = kmalloc(context->ret.length, GFP_KERNEL);
+	if (!context->ret.pointer) {
+		status =  AE_NO_MEMORY;
+		goto out_kfree;
+	}
+	memcpy(context->ret.pointer, out_obj->buffer.pointer,
+		context->ret.length);
+	status =  AE_OK;
 
 out_kfree:
-	kfree(context->ret.pointer);
-	context->ret.pointer = NULL;
+	kfree(output.pointer);
+	if (status != AE_OK)
+		context->ret.pointer = NULL;
 	return status;
 }
 EXPORT_SYMBOL(acpi_run_osc);


