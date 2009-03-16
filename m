Return-Path: <linux-kernel-owner+w=401wt.eu-S1753337AbZCPDvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337AbZCPDvd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 23:51:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751673AbZCPDvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 23:51:22 -0400
Received: from mga09.intel.com ([134.134.136.24]:37433 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197AbZCPDvV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 23:51:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,370,1233561600"; 
   d="scan'208";a="498013421"
Subject: Re: 2.6.29 acpi regression: acpi_ex_extract_from_field -- div by
 zero
From: Lin Ming <ming.m.lin@intel.com>
To: jirislaby@gmail.com
Cc: robert.moore@intel.com, lenb@kernel.org, linux-acpi@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       torvalds@linux-foundation.org
In-Reply-To: <d3f22a0903152046m891dc0aq6ca01eed32a9eb32@mail.gmail.com>
References: <49BCDCAA.8040309@gmail.com>
	 <d3f22a0903152046m891dc0aq6ca01eed32a9eb32@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 16 Mar 2009 11:42:23 +0800
Message-Id: <1237174943.4193.37.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Hi,
> 
> sometimes, when booting up/resuming from disk, I get an oops[1].
> 
> obj_desc->common_field.access_bit_width is zero, but even after the
> loop. Division before the loop is apparently OK.

Would please try below debug patch to see which region filed is
accessed?

diff --git a/drivers/acpi/acpica/exfldio.c b/drivers/acpi/acpica/exfldio.c
index ef58ac4..10ac0c8 100644
--- a/drivers/acpi/acpica/exfldio.c
+++ b/drivers/acpi/acpica/exfldio.c
@@ -683,6 +683,7 @@ acpi_ex_extract_from_field(union acpi_operand_object *obj_desc,
 	u32 datum_count;
 	u32 field_datum_count;
 	u32 i;
+	struct acpi_buffer name_buffer = { ACPI_ALLOCATE_BUFFER, NULL };
 
 	ACPI_FUNCTION_TRACE(ex_extract_from_field);
 
@@ -765,6 +766,20 @@ acpi_ex_extract_from_field(union acpi_operand_object *obj_desc,
 		    raw_datum >> obj_desc->common_field.start_field_bit_offset;
 	}
 
+	if (obj_desc->common_field.bit_length == 0 ||
+	    obj_desc->common_field.access_bit_width == 0) {
+		status = acpi_get_name(obj_desc->common_field.node,
+				ACPI_FULL_PATHNAME, &name_buffer);
+		if (ACPI_FAILURE(status)) {
+			printk(KERN_DEBUG "ACPI Debug: %s\n",
+				acpi_format_exception(status));
+		} else {
+			printk(KERN_DEBUG "ACPI Debug: field node path: %s\n",
+				(char *) name_buffer.pointer);
+			kfree(name_buffer.pointer);
+		}
+	}
+
 	/* Mask off any extra bits in the last datum */
 
 	buffer_tail_bits = obj_desc->common_field.bit_length %

---
Lin Ming

> 
> This is the case:
>        /* Mask off any extra bits in the last datum */
> 
>        buffer_tail_bits = obj_desc->common_field.bit_length %
>            obj_desc->common_field.access_bit_width;
> 
> .L39:
>        xorl    %edx, %edx      #
>        movzbl  37(%rbx), %esi  #
> <variable>.common_field.access_bit_width,
> <variable>.common_field.access_bit_width
>        movl    24(%rbx), %eax  # <variable>.common_field.bit_length,
> <variable>.common_field.bit_length
> --------------- here:
>        divl    %esi    # <variable>.common_field.access_bit_width
>        movl    %edx, %ecx      #, tmp121
>        testl   %edx, %edx      # tmp121
>        je      .L41    #,
> 
> [1] http://www.fi.muni.cz/~xslaby/sklad/panics/acpi_oops.png
> --


