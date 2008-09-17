Return-Path: <linux-kernel-owner+w=401wt.eu-S1755239AbYIQPnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239AbYIQPnS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 11:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752942AbYIQPnE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 11:43:04 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:36864 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730AbYIQPnD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 11:43:03 -0400
Message-Id: <48D141C9.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 Beta 
Date: Wed, 17 Sep 2008 16:43:37 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <len.brown@intel.com>
Cc: "Andi Kleen" <andi@firstfloor.org>, "linux-acpi" <linux-acpi@intel.com>,
       <robert.moore@intel.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] ACPI: fix FADT parsing (v3)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The (1.0 inherited) separate length fields in the FADT are byte
granular. Further, PM1a/b may have distinct lengths (if using the v2
fields was okay) and may live in distinct address spaces.
acpi_tb_convert_fadt() should account for all of these conditions.

Apart from these changes I'm puzzled by the fact that, not just for
acpi_gbl_xpm1{a,b}_enable, acpi_hw_low_level_{read,write}() get an
explicit size passed rather than using the size found in the passed
GAS. What happens on a platform that defines PM1{a,b} wider than 16
bits? Of course, acpi_hw_low_level_{read,write}() at present are
entirely un-prepared to deal with sizes other than 8, 16, or 32, not
to speak of a non-zero bit_offset or access_width...

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 drivers/acpi/tables/tbfadt.c |   32 +++++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

--- linux-2.6.27-rc6/drivers/acpi/tables/tbfadt.c	2008-08-21 14:37:29.000000000 +0200
+++ 2.6.27-rc6-acpi-fadt-parse/drivers/acpi/tables/tbfadt.c	2008-07-23 13:21:22.000000000 +0200
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
@@ -342,9 +342,20 @@ static void acpi_tb_convert_fadt(void)
 	 * useful to calculate them once, here.
 	 *
 	 * The PM event blocks are split into two register blocks, first is the
-	 * PM Status Register block, followed immediately by the PM Enable Register
-	 * block. Each is of length (pm1_event_length/2)
+	 * PM Status Register block, followed immediately by the PM Enable
+	 * Register block. Each is of length (xpm1x_event_block.bit_width/2).
+	 *
+	 * On various systems the v2 fields (and particularly the bit widths)
+	 * cannot be relied upon, though. Hence resort to using the v1 length
+	 * here (and warn about the inconsistency).
 	 */
+	if (acpi_gbl_FADT.xpm1a_event_block.bit_width
+	    != acpi_gbl_FADT.pm1_event_length * 8)
+		printk(KERN_WARNING "FADT: "
+		       "X_PM1a_EVT_BLK.bit_width (%u) does not match"
+		       " PM1_EVT_LEN (%u)\n",
+		       acpi_gbl_FADT.xpm1a_event_block.bit_width,
+		       acpi_gbl_FADT.pm1_event_length);
 	pm1_register_length = (u8) ACPI_DIV_2(acpi_gbl_FADT.pm1_event_length);
 
 	/* The PM1A register block is required */
@@ -360,13 +371,20 @@ static void acpi_tb_convert_fadt(void)
 	/* The PM1B register block is optional, ignore if not present */
 
 	if (acpi_gbl_FADT.xpm1b_event_block.address) {
+		if (acpi_gbl_FADT.xpm1b_event_block.bit_width
+		    != acpi_gbl_FADT.pm1_event_length * 8)
+			printk(KERN_WARNING "FADT: "
+			       "X_PM1b_EVT_BLK.bit_width (%u) does not match"
+			       " PM1_EVT_LEN (%u)\n",
+			       acpi_gbl_FADT.xpm1b_event_block.bit_width,
+			       acpi_gbl_FADT.pm1_event_length);
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


