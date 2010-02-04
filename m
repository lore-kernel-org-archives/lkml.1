Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551Ab0BDRgQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 12:36:16 -0500
Received: from kroah.org ([198.145.64.141]:34616 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933056Ab0BDRVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 12:21:36 -0500
X-Mailbox-Line: From linux@linux.site Thu Feb  4 09:14:54 2010
Message-Id: <20100204171453.598550478@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 04 Feb 2010 09:11:43 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Shaohua Li <shaohua.li@intel.com>, Len Brown <len.brown@intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [12/74] ACPI: Add a generic API for _OSC -v2
In-Reply-To: <20100204171850.GA16539@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Shaohua Li <shaohua.li@intel.com>

commit 70023de88c58a81a730ab4d13c51a30e537ec76e upstream.

v2->v1:
.improve debug info as suggedted by Bjorn,Kenji
.API is using uuid string as suggested by Alexey

Add an API to execute _OSC. A lot of devices can have this method, so add a
generic API.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/bus.c   |  122 +++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/acpi.h |    9 +++
 2 files changed, 131 insertions(+)

--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -344,6 +344,128 @@ bool acpi_bus_can_wakeup(acpi_handle han
 
 EXPORT_SYMBOL(acpi_bus_can_wakeup);
 
+static void acpi_print_osc_error(acpi_handle handle,
+	struct acpi_osc_context *context, char *error)
+{
+	struct acpi_buffer buffer = {ACPI_ALLOCATE_BUFFER};
+	int i;
+
+	if (ACPI_FAILURE(acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer)))
+		printk(KERN_DEBUG "%s\n", error);
+	else {
+		printk(KERN_DEBUG "%s:%s\n", (char *)buffer.pointer, error);
+		kfree(buffer.pointer);
+	}
+	printk(KERN_DEBUG"_OSC request data:");
+	for (i = 0; i < context->cap.length; i += sizeof(u32))
+		printk("%x ", *((u32 *)(context->cap.pointer + i)));
+	printk("\n");
+}
+
+static u8 hex_val(unsigned char c)
+{
+	return isdigit(c) ? c - '0' : toupper(c) - 'A' + 10;
+}
+
+static acpi_status acpi_str_to_uuid(char *str, u8 *uuid)
+{
+	int i;
+	static int opc_map_to_uuid[16] = {6, 4, 2, 0, 11, 9, 16, 14, 19, 21,
+		24, 26, 28, 30, 32, 34};
+
+	if (strlen(str) != 36)
+		return AE_BAD_PARAMETER;
+	for (i = 0; i < 36; i++) {
+		if (i == 8 || i == 13 || i == 18 || i == 23) {
+			if (str[i] != '-')
+				return AE_BAD_PARAMETER;
+		} else if (!isxdigit(str[i]))
+			return AE_BAD_PARAMETER;
+	}
+	for (i = 0; i < 16; i++) {
+		uuid[i] = hex_val(str[opc_map_to_uuid[i]]) << 4;
+		uuid[i] |= hex_val(str[opc_map_to_uuid[i] + 1]);
+	}
+	return AE_OK;
+}
+
+acpi_status acpi_run_osc(acpi_handle handle, struct acpi_osc_context *context)
+{
+	acpi_status status;
+	struct acpi_object_list input;
+	union acpi_object in_params[4];
+	union acpi_object *out_obj;
+	u8 uuid[16];
+	u32 errors;
+
+	if (!context)
+		return AE_ERROR;
+	if (ACPI_FAILURE(acpi_str_to_uuid(context->uuid_str, uuid)))
+		return AE_ERROR;
+	context->ret.length = ACPI_ALLOCATE_BUFFER;
+	context->ret.pointer = NULL;
+
+	/* Setting up input parameters */
+	input.count = 4;
+	input.pointer = in_params;
+	in_params[0].type 		= ACPI_TYPE_BUFFER;
+	in_params[0].buffer.length 	= 16;
+	in_params[0].buffer.pointer	= uuid;
+	in_params[1].type 		= ACPI_TYPE_INTEGER;
+	in_params[1].integer.value 	= context->rev;
+	in_params[2].type 		= ACPI_TYPE_INTEGER;
+	in_params[2].integer.value	= context->cap.length/sizeof(u32);
+	in_params[3].type		= ACPI_TYPE_BUFFER;
+	in_params[3].buffer.length 	= context->cap.length;
+	in_params[3].buffer.pointer 	= context->cap.pointer;
+
+	status = acpi_evaluate_object(handle, "_OSC", &input, &context->ret);
+	if (ACPI_FAILURE(status))
+		return status;
+
+	/* return buffer should have the same length as cap buffer */
+	if (context->ret.length != context->cap.length)
+		return AE_NULL_OBJECT;
+
+	out_obj = context->ret.pointer;
+	if (out_obj->type != ACPI_TYPE_BUFFER) {
+		acpi_print_osc_error(handle, context,
+			"_OSC evaluation returned wrong type");
+		status = AE_TYPE;
+		goto out_kfree;
+	}
+	/* Need to ignore the bit0 in result code */
+	errors = *((u32 *)out_obj->buffer.pointer) & ~(1 << 0);
+	if (errors) {
+		if (errors & OSC_REQUEST_ERROR)
+			acpi_print_osc_error(handle, context,
+				"_OSC request failed");
+		if (errors & OSC_INVALID_UUID_ERROR)
+			acpi_print_osc_error(handle, context,
+				"_OSC invalid UUID");
+		if (errors & OSC_INVALID_REVISION_ERROR)
+			acpi_print_osc_error(handle, context,
+				"_OSC invalid revision");
+		if (errors & OSC_CAPABILITIES_MASK_ERROR) {
+			if (((u32 *)context->cap.pointer)[OSC_QUERY_TYPE]
+			    & OSC_QUERY_ENABLE)
+				goto out_success;
+			status = AE_SUPPORT;
+			goto out_kfree;
+		}
+		status = AE_ERROR;
+		goto out_kfree;
+	}
+out_success:
+	return AE_OK;
+
+out_kfree:
+	kfree(context->ret.pointer);
+	context->ret.pointer = NULL;
+	return status;
+}
+EXPORT_SYMBOL(acpi_run_osc);
+
 /* --------------------------------------------------------------------------
                                 Event Management
    -------------------------------------------------------------------------- */
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -253,6 +253,13 @@ void __init acpi_old_suspend_ordering(vo
 void __init acpi_s4_no_nvs(void);
 #endif /* CONFIG_PM_SLEEP */
 
+struct acpi_osc_context {
+	char *uuid_str; /* uuid string */
+	int rev;
+	struct acpi_buffer cap; /* arg2/arg3 */
+	struct acpi_buffer ret; /* free by caller if success */
+};
+
 #define OSC_QUERY_TYPE			0
 #define OSC_SUPPORT_TYPE 		1
 #define OSC_CONTROL_TYPE		2
@@ -265,6 +272,8 @@ void __init acpi_s4_no_nvs(void);
 #define OSC_INVALID_REVISION_ERROR	8
 #define OSC_CAPABILITIES_MASK_ERROR	16
 
+acpi_status acpi_run_osc(acpi_handle handle, struct acpi_osc_context *context);
+
 /* _OSC DW1 Definition (OS Support Fields) */
 #define OSC_EXT_PCI_CONFIG_SUPPORT		1
 #define OSC_ACTIVE_STATE_PWR_SUPPORT 		2


