Return-Path: <linux-kernel-owner+w=401wt.eu-S1755440AbZCTFD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440AbZCTFD6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 01:03:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751514AbZCTFDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 01:03:47 -0400
Received: from mga02.intel.com ([134.134.136.20]:29243 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750999AbZCTFDp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 01:03:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,393,1233561600"; 
   d="scan'208";a="396059204"
Subject: Re: 2.6.29 acpi regression: acpi_ex_extract_from_field -- div by
 zero
From: Lin Ming <ming.m.lin@intel.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: "Moore, Robert" <robert.moore@intel.com>,
       "lenb@kernel.org" <lenb@kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>
In-Reply-To: <49C26D91.3010904@gmail.com>
References: <49BCDCAA.8040309@gmail.com>
	 <d3f22a0903152046m891dc0aq6ca01eed32a9eb32@mail.gmail.com>
	 <1237174943.4193.37.camel@minggr.sh.intel.com> <49BE7EE6.3070107@gmail.com>
	 <49C0AC13.7040107@gmail.com>  <49C26D91.3010904@gmail.com>
Content-Type: text/plain
Date: Fri, 20 Mar 2009 12:53:30 +0800
Message-Id: <1237524810.879.19.camel@minggr>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-20 at 00:06 +0800, Jiri Slaby wrote:
> On 18.3.2009 09:08, Jiri Slaby wrote:
> > On 16.3.2009 17:31, Jiri Slaby wrote:
> >> On 16.3.2009 04:42, Lin Ming wrote:
> >>>> sometimes, when booting up/resuming from disk, I get an oops[1].
> >>>>
> >>>> obj_desc->common_field.access_bit_width is zero, but even after the
> >>>> loop. Division before the loop is apparently OK.
> >>>
> >>> Would please try below debug patch to see which region filed is
> >>> accessed?
> >
> > I'm confused, but keep trying.
> 
> Got it again. obj_desc->common_field.node is martian too (0x4000000), so 
> the added acpi_get_name dies:
> http://www.fi.muni.cz/~xslaby/sklad/panics/acpi_oops1.png
> 
> Whole common_field seems to be mangled. Ideas?

I should save the field object and node path name at the entry of
acpi_ex_extract_from_field.
Would you please try below debug patch?
I also add a return statement before the fault to disallow the oops to
flood screen.

Thanks.

diff --git a/drivers/acpi/acpica/exfldio.c b/drivers/acpi/acpica/exfldio.c
index ef58ac4..5109f5b 100644
--- a/drivers/acpi/acpica/exfldio.c
+++ b/drivers/acpi/acpica/exfldio.c
@@ -670,6 +670,34 @@ acpi_ex_write_with_update_rule(union acpi_operand_object *obj_desc,
  *
  ******************************************************************************/
 
+void debug_dump_field(union acpi_operand_object *obj_desc)
+{
+	struct acpi_object_field_common *obj_field;
+
+	if (!obj_desc) {
+		printk(KERN_DEBUG "ACPI Debug: NULL field object\n");
+		return;
+	}
+
+	printk(KERN_DEBUG "next_object: %p\n", obj_desc->common.next_object);
+	printk(KERN_DEBUG "descriptor_type: %x\n", obj_desc->common.descriptor_type);
+	printk(KERN_DEBUG "type: %x\n", obj_desc->common.type);
+	printk(KERN_DEBUG "reference_count: %x\n", obj_desc->common.reference_count);
+	printk(KERN_DEBUG "flags: %x\n", obj_desc->common.flags);
+
+	obj_field = &obj_desc->common_field;
+
+	printk(KERN_DEBUG "field_flags: %x\n", obj_field->field_flags);
+	printk(KERN_DEBUG "attribute: %x\n", obj_field->attribute);
+	printk(KERN_DEBUG "access_byte_width: %x\n", obj_field->access_byte_width);
+	printk(KERN_DEBUG "node: %p\n", obj_field->node);
+	printk(KERN_DEBUG "bit_length: %x\n", obj_field->bit_length);
+	printk(KERN_DEBUG "base_byte_offset: %x\n", obj_field->base_byte_offset);
+	printk(KERN_DEBUG "value: %x\n", obj_field->value);
+	printk(KERN_DEBUG "start_field_bit_offset: %x\n", obj_field->start_field_bit_offset);
+	printk(KERN_DEBUG "access_bit_width: %x\n", obj_field->access_bit_width);
+}
+
 acpi_status
 acpi_ex_extract_from_field(union acpi_operand_object *obj_desc,
 			   void *buffer, u32 buffer_length)
@@ -683,9 +711,24 @@ acpi_ex_extract_from_field(union acpi_operand_object *obj_desc,
 	u32 datum_count;
 	u32 field_datum_count;
 	u32 i;
+	struct acpi_buffer name_buffer = { ACPI_ALLOCATE_BUFFER, NULL };
+	union acpi_operand_object backup_obj;
 
 	ACPI_FUNCTION_TRACE(ex_extract_from_field);
 
+	/* backup the object */
+	memcpy(&backup_obj, obj_desc, sizeof(*obj_desc));
+
+	name_buffer.pointer = NULL;
+	if (obj_desc->common_field.node) {
+		status = acpi_get_name(obj_desc->common_field.node,
+				ACPI_FULL_PATHNAME, &name_buffer);
+		if (ACPI_FAILURE(status)) {
+			printk(KERN_DEBUG "ACPI Debug: %s\n",
+				acpi_format_exception(status));
+		}
+	}
+
 	/* Validate target buffer and clear it */
 
 	if (buffer_length <
@@ -765,6 +808,29 @@ acpi_ex_extract_from_field(union acpi_operand_object *obj_desc,
 		    raw_datum >> obj_desc->common_field.start_field_bit_offset;
 	}
 
+	if (obj_desc->common_field.bit_length == 0 ||
+	    obj_desc->common_field.access_bit_width == 0) {
+
+		/* oops, dump the object */
+		if (name_buffer.pointer) {
+			printk(KERN_DEBUG "ACPI Debug: field node path: %s\n",
+				(char *) name_buffer.pointer);
+		}
+
+		printk(KERN_DEBUG "ACPI Debug: The original object:\n");
+		debug_dump_field(&backup_obj);
+
+		printk(KERN_DEBUG "ACPI Debug: The bad object:\n");
+		debug_dump_field(obj_desc);
+
+		kfree(name_buffer.pointer);
+
+		/* we return here to disallow the oops to flood screen */
+		return_ACPI_STATUS(AE_ERROR);
+	}
+
+	kfree(name_buffer.pointer);
+
 	/* Mask off any extra bits in the last datum */
 
 	buffer_tail_bits = obj_desc->common_field.bit_length %


