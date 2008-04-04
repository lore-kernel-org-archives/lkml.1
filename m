Return-Path: <linux-kernel-owner+w=401wt.eu-S1757393AbYDDMXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393AbYDDMXn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 08:23:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751462AbYDDMXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 08:23:35 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:39766
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751432AbYDDMXf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 08:23:35 -0400
Message-Id: <47F639FD.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Fri, 04 Apr 2008 13:23:57 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <len.brown@intel.com>
Cc: "linux-acpi" <linux-acpi@intel.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] fix ACPI FADT parsing
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The (1.0 inherited) separate length fields in the FADT are byte
granular. Further, PM1a/b may have distinct lengths and live in
distinct address spaces. acpi_tb_convert_fadt() should account for
all of these conditions.

Apart from these changes I'm puzzled by the fact that, not just for
acpi_gbl_xpm1{a,b}_enable, acpi_hw_low_level_{read,write}() get an
explicit size passed rather than using the size found in the passed
GAS. What happens on a platform that defines PM1{a,b} wider than 16
bits? Of course, acpi_hw_low_level_{read,write}() at present are
entirely un-prepared to deal with sizes other than 8, 16, or 32, not
to speak of a non-zero bit_offset or access_width...

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 drivers/acpi/tables/tbfadt.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- linux-2.6.25-rc8/drivers/acpi/tables/tbfadt.c	2007-10-09 22:31:38.000000000 +0200
+++ 2.6.25-rc8-acpi-fadt-parse/drivers/acpi/tables/tbfadt.c	2008-04-03 11:12:33.000000000 +0200
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
@@ -343,9 +343,11 @@ static void acpi_tb_convert_fadt(void)
 	 *
 	 * The PM event blocks are split into two register blocks, first is the
 	 * PM Status Register block, followed immediately by the PM Enable Register
-	 * block. Each is of length (pm1_event_length/2)
+	 * block. Each is of length (xpm1x_event_block.bit_width/2)
 	 */
-	pm1_register_length = (u8) ACPI_DIV_2(acpi_gbl_FADT.pm1_event_length);
+	WARN_ON(ACPI_MOD_16(acpi_gbl_FADT.xpm1a_event_block.bit_width));
+	pm1_register_length = (u8) ACPI_DIV_16(acpi_gbl_FADT
+					       .xpm1a_event_block.bit_width);
 
 	/* The PM1A register block is required */
 
@@ -360,13 +362,17 @@ static void acpi_tb_convert_fadt(void)
 	/* The PM1B register block is optional, ignore if not present */
 
 	if (acpi_gbl_FADT.xpm1b_event_block.address) {
+		WARN_ON(ACPI_MOD_16(acpi_gbl_FADT.xpm1b_event_block.bit_width));
+		pm1_register_length = (u8) ACPI_DIV_16(acpi_gbl_FADT
+						       .xpm1b_event_block
+						       .bit_width);
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



