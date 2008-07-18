Return-Path: <linux-kernel-owner+w=401wt.eu-S1755542AbYGRJse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542AbYGRJse (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 05:48:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753796AbYGRJs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 05:48:26 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:23378 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753698AbYGRJsZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 05:48:25 -0400
Message-Id: <48808313.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Fri, 18 Jul 2008 10:48:35 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Len Brown" <lenb@kernel.org>, "Andi Kleen" <ak@linux.intel.com>
Cc: "Robert Moore" <robert.moore@intel.com>,
       "Andrew Paprocki" <andrew@ishiboo.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "LKML" <linux-kernel@vger.kernel.org>
Subject: RE: ACPI WARNING: at
	drivers/acpi/tables/tbfadt.c:348acpi_tb_create_local_fadt+0x147/0x2f4()
References: <76366b180807161929i4eb9462exc3d2255e0ec881e8@mail.gmail.com>
 <76366b180807162034y1e725b15t7658c331bb89b52@mail.gmail.com>
 <487F2629.76E4.0078.0@novell.com> <487F0B85.4030202@linux.intel.com>
 <487F29B2.76E4.0078.0@novell.com> <487F3AFA.7090908@linux.intel.com>
 <76366b180807170603qaf669a5q625fc166a2045756@mail.gmail.com>
 <487F6C32.76E4.0078.0@novell.com>
 <76366b180807170732i112d54bcl49f630a3064f87f@mail.gmail.com>
 <487F81A6.76E4.0078.0@novell.com>
 <9D39833986E69849A2A8E74C1078B6B3ADFA66@orsmsx415.amr.corp.intel.com>
In-Reply-To: <9D39833986E69849A2A8E74C1078B6B3ADFA66@orsmsx415.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> "Moore, Robert" <robert.moore@intel.com> 17.07.08 19:20 >>>
>So far, in the number of the cases like this that I've seen, it's the v2
>fields that have problems. Perhaps the heuristic should be something
>like "if there is an inconsistency between the v1 and v2 fields, fall
>back to v1". 

Here's the updated (i.e. replacement) patch. Andrew P., any chance you
could test this on your system?

The (1.0 inherited) separate length fields in the FADT are byte
granular. Further, PM1a/b may have distinct lengths and live in
distinct address spaces. acpi_tb_convert_fadt() should account for
all of these conditions.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 drivers/acpi/tables/tbfadt.c |   39 ++++++++++++++++++++++++++++++++-------
 1 file changed, 32 insertions(+), 7 deletions(-)

--- linux-2.6.26/drivers/acpi/tables/tbfadt.c	2008-07-13 23:51:29.000000000 +0200
+++ 2.6.26-acpi-fadt-parse/drivers/acpi/tables/tbfadt.c	2008-07-18 10:43:55.000000000 +0200
@@ -50,7 +50,7 @@ ACPI_MODULE_NAME("tbfadt")
 /* Local prototypes */
 static void inline
 acpi_tb_init_generic_address(struct acpi_generic_address *generic_address,
-			     u8 bit_width, u64 address);
+			     u8 byte_width, u64 address);
 
 static void acpi_tb_convert_fadt(void);
 
@@ -111,7 +111,7 @@ static struct acpi_fadt_info fadt_info_t
  * FUNCTION:    acpi_tb_init_generic_address
  *
  * PARAMETERS:  generic_address     - GAS struct to be initialized
- *              bit_width           - Width of this register
+ *              byte_width          - Width of this register
  *              Address             - Address of the register
  *
  * RETURN:      None
@@ -124,7 +124,7 @@ static struct acpi_fadt_info fadt_info_t
 
 static void inline
 acpi_tb_init_generic_address(struct acpi_generic_address *generic_address,
-			     u8 bit_width, u64 address)
+			     u8 byte_width, u64 address)
 {
 
 	/*
@@ -136,7 +136,7 @@ acpi_tb_init_generic_address(struct acpi
 	/* All other fields are byte-wide */
 
 	generic_address->space_id = ACPI_ADR_SPACE_SYSTEM_IO;
-	generic_address->bit_width = bit_width;
+	generic_address->bit_width = byte_width << 3;
 	generic_address->bit_offset = 0;
 	generic_address->access_width = 0;
 }
@@ -343,9 +343,21 @@ static void acpi_tb_convert_fadt(void)
 	 *
 	 * The PM event blocks are split into two register blocks, first is the
 	 * PM Status Register block, followed immediately by the PM Enable Register
-	 * block. Each is of length (pm1_event_length/2)
+	 * block. Each is of length (xpm1x_event_block.bit_width/2)
 	 */
-	pm1_register_length = (u8) ACPI_DIV_2(acpi_gbl_FADT.pm1_event_length);
+	if (!ACPI_MOD_16(acpi_gbl_FADT.xpm1a_event_block.bit_width))
+		pm1_register_length = (u8) ACPI_DIV_16(acpi_gbl_FADT
+						       .xpm1a_event_block
+						       .bit_width);
+	else {
+		printk(KERN_WARNING "FADT: "
+		       "X_PM1a_EVT_BLK.bit_width=%u is invalid,"
+		       " falling back to PM1_EVT_LEN=%u\n",
+		       acpi_gbl_FADT.xpm1a_event_block.bit_width,
+		       acpi_gbl_FADT.pm1_event_length);
+		pm1_register_length = (u8) ACPI_DIV_2(acpi_gbl_FADT
+						      .pm1_event_length);
+	}
 
 	/* The PM1A register block is required */
 
@@ -360,13 +372,26 @@ static void acpi_tb_convert_fadt(void)
 	/* The PM1B register block is optional, ignore if not present */
 
 	if (acpi_gbl_FADT.xpm1b_event_block.address) {
+		if (!ACPI_MOD_16(acpi_gbl_FADT.xpm1b_event_block.bit_width))
+			pm1_register_length = (u8) ACPI_DIV_16(acpi_gbl_FADT
+							       .xpm1b_event_block
+							       .bit_width);
+		else {
+			printk(KERN_WARNING "FADT: "
+			       "X_PM1b_EVT_BLK.bit_width=%u is invalid,"
+			       " falling back to PM1_EVT_LEN=%u\n",
+			       acpi_gbl_FADT.xpm1b_event_block.bit_width,
+			       acpi_gbl_FADT.pm1_event_length);
+			pm1_register_length = (u8) ACPI_DIV_2(acpi_gbl_FADT
+							       .pm1_event_length);
+		}
 		acpi_tb_init_generic_address(&acpi_gbl_xpm1b_enable,
 					     pm1_register_length,
 					     (acpi_gbl_FADT.xpm1b_event_block.
 					      address + pm1_register_length));
 		/* Don't forget to copy space_id of the GAS */
 		acpi_gbl_xpm1b_enable.space_id =
-		    acpi_gbl_FADT.xpm1a_event_block.space_id;
+		    acpi_gbl_FADT.xpm1b_event_block.space_id;
 
 	}
 }


