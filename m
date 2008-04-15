Return-Path: <linux-kernel-owner+w=401wt.eu-S1763275AbYDOF6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763275AbYDOF6x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 01:58:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754435AbYDOF6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 01:58:42 -0400
Received: from mga01.intel.com ([192.55.52.88]:33123 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754281AbYDOF6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 01:58:40 -0400
X-ExtLoop1: 1
Subject: Re: [PATCH 2.6.25-rc7 001/001] ACPI: workaround for buggy BIOS to
	ignore error LINK CRS method
From: Zhao Yakui <yakui.zhao@intel.com>
To: NoWhereMan <uncommonnonsense@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, Len Brown <lenb@kernel.org>
In-Reply-To: <f7430a760804100523t6483dc0cn144429ee7024a7f2@mail.gmail.com>
References: <f7430a760804090842s44ece7bh216d5d28e347955@mail.gmail.com>
	 <20080409161251.0c0e73e9.akpm@linux-foundation.org>
	 <1207824057.8704.12.camel@yakui_zhao.sh.intel.com>
	 <f7430a760804100523t6483dc0cn144429ee7024a7f2@mail.gmail.com>
Content-Type: multipart/mixed; boundary="=-OG/LZqt5dV0mWDjve3Oe"
Date: Tue, 15 Apr 2008 21:49:45 +0800
Message-Id: <1208267385.12372.11.camel@yakui_zhao.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-OG/LZqt5dV0mWDjve3Oe
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Thu, 2008-04-10 at 14:23 +0200, NoWhereMan wrote:
> On Thu, Apr 10, 2008 at 12:40 PM, Zhao Yakui <yakui.zhao@intel.com> wrote:
> > On Wed, 2008-04-09 at 16:12 -0700, Andrew Morton wrote:
> 
> >  > That patch is about four months old.  Hopefully there was a reason why we
> >  > dodn't proceed with it?
> >  It seems that the system can work after applying the patch.
> >  But the patch depends on the returned result(-ENODEV).
> >  > if (ACPI_FAILURE(status)) {
> >  >               ACPI_EXCEPTION((AE_INFO, status, "Evaluating _CRS"));
> >  >                result = -ENODEV;
> >   >               goto end;
> >   >       }
> >  Now I am writing another workaround patch about this problem.
> 
Will you please try the workaround patch and see whether the problem can
be fixed?
Thanks.
> I'll try to help, testing the new patch on my system

--=-OG/LZqt5dV0mWDjve3Oe
Content-Disposition: attachment; filename=crs_debug.patch
Content-Type: text/x-patch; name=crs_debug.patch; charset=utf-8
Content-Transfer-Encoding: 7bit

An integer is returned by _CRS/_PRS object of LINK device
for some broken bios( the HID of LINK device is "PNP0C0F").
In such case irq_number will be constructed as the Extended
IRQ descriptor.
The content of the buffer should be the following:
0x89,0x06,0x00,0x0D,0x01,0x0,0x00,0x00,0x00,0x79,0x00.
And the length of the buffer is 11.

---
 drivers/acpi/resources/rsutils.c |   47 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 45 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/acpi/resources/rsutils.c
===================================================================
--- linux-2.6.orig/drivers/acpi/resources/rsutils.c
+++ linux-2.6/drivers/acpi/resources/rsutils.c
@@ -611,7 +611,11 @@ acpi_rs_get_method_data(acpi_handle hand
 			char *path, struct acpi_buffer *ret_buffer)
 {
 	union acpi_operand_object *obj_desc;
+	struct acpi_namespace_node *device_node = NULL;
 	acpi_status status;
+	u8 *ptr = NULL;
+	u32 irq_number = 0;
+	struct acpica_device_id hid;
 
 	ACPI_FUNCTION_TRACE(rs_get_method_data);
 
@@ -622,9 +626,48 @@ acpi_rs_get_method_data(acpi_handle hand
 	status =
 	    acpi_ut_evaluate_object(handle, path, ACPI_BTYPE_BUFFER, &obj_desc);
 	if (ACPI_FAILURE(status)) {
-		return_ACPI_STATUS(status);
+		/*
+		 * An integer is returned by _CRS/_PRS object of LINK device
+		 * for some broken bios( the HID of LINK device is "PNP0C0F").
+		 * In such case irq_number will be constructed as the Extended
+		 * IRQ descriptor.
+		 * The content of the buffer should be the following:
+		 * 0x89,0x06,0x00,0x0D,0x01,0x0,0x00,0x00,0x00,0x79,0x00.
+		 * And the length of the buffer is 11.
+		 */
+		device_node = acpi_ns_map_handle_to_node(handle);
+		status = acpi_ut_execute_HID(device_node, &hid);
+		/* Now only LINK device is supported */
+		if (ACPI_FAILURE(status) || ACPI_STRNCMP(hid.value,
+					"PNP0C0F", sizeof(hid.value))) {
+			ACPI_WARNING((AE_INFO , "Only LINK device supports "
+				" the workaround patch"));
+			return_ACPI_STATUS(AE_SUPPORT);
+		}
+
+		status = acpi_ut_evaluate_object(handle, path,
+				ACPI_BTYPE_INTEGER, &obj_desc);
+		if (ACPI_FAILURE(status))
+			return_ACPI_STATUS(status);
+
+		if (ACPI_GET_OBJECT_TYPE(obj_desc) == ACPI_TYPE_INTEGER) {
+			#define IRQ_OFFSET	5
+		 	char fixed_irq_buffer[] = { 0x89, 0x06, 0x0, 0x0D,
+				0x01, 0x0, 0x0, 0x0, 0x0, 0x79, 0x0 };
+			irq_number = obj_desc->integer.value;
+			acpi_ut_remove_reference(obj_desc);
+			obj_desc = acpi_ut_create_buffer_object(
+					sizeof(fixed_irq_buffer));
+			if (!obj_desc)
+				return_ACPI_STATUS(AE_NO_MEMORY);
+
+			ptr = obj_desc->buffer.pointer;
+			ACPI_MEMCPY(ptr, fixed_irq_buffer,
+					sizeof(fixed_irq_buffer));
+			ptr += IRQ_OFFSET;
+			ACPI_MOVE_32_TO_32(ptr, &irq_number);
+		}
 	}
-
 	/*
 	 * Make the call to create a resource linked list from the
 	 * byte stream buffer that comes back from the method

--=-OG/LZqt5dV0mWDjve3Oe--

