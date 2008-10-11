Return-Path: <linux-kernel-owner+w=401wt.eu-S1763057AbYJKGvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763057AbYJKGvR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 02:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755554AbYJKGjD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 02:39:03 -0400
Received: from vms046pub.verizon.net ([206.46.252.46]:45163 "EHLO
	vms046pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823AbYJKGhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 02:37:16 -0400
Date: Sat, 11 Oct 2008 02:36:11 -0400
From: Len Brown <lenb@kernel.org>
Subject: [PATCH 51/85] ACPI: fix FADT parsing
In-reply-to: <1223707005-26864-1-git-send-email-lenb@kernel.org>
In-reply-to: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jan Beulich <jbeulich@novell.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Len Brown <len.brown@intel.com>
Message-id: <fcea94ba0773a4bf78d109f2acd72d003f0621f6.1223706853.git.len.brown@intel.com>
Organization: Intel Open Source Technology Center
X-Mailer: git-send-email 1.6.0.2.307.gc427
References: <1223707005-26864-1-git-send-email-lenb@kernel.org>
References: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Beulich <jbeulich@novell.com>

The (1.0 inherited) separate length fields in the FADT are byte granular.
Further, PM1a/b may have distinct lengths (if using the v2 fields was
okay) and may live in distinct address spaces.  acpi_tb_convert_fadt()
should account for all of these conditions.

Apart from these changes I'm puzzled by the fact that, not just for
acpi_gbl_xpm1{a,b}_enable, acpi_hw_low_level_{read,write}() get an
explicit size passed rather than using the size found in the passed GAS.
What happens on a platform that defines PM1{a,b} wider than 16 bits?  Of
course, acpi_hw_low_level_{read,write}() at present are entirely
un-prepared to deal with sizes other than 8, 16, or 32, not to speak of a
non-zero bit_offset or access_width...

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/tables/tbfadt.c |   32 +++++++++++++++++++++++++-------
 1 files changed, 25 insertions(+), 7 deletions(-)

diff --git a/drivers/acpi/tables/tbfadt.c b/drivers/acpi/tables/tbfadt.c
index a4a41ba..2c7885e 100644
--- a/drivers/acpi/tables/tbfadt.c
+++ b/drivers/acpi/tables/tbfadt.c
@@ -50,7 +50,7 @@ ACPI_MODULE_NAME("tbfadt")
 /* Local prototypes */
 static void inline
 acpi_tb_init_generic_address(struct acpi_generic_address *generic_address,
-			     u8 bit_width, u64 address);
+			     u8 byte_width, u64 address);
 
 static void acpi_tb_convert_fadt(void);
 
@@ -111,7 +111,7 @@ static struct acpi_fadt_info fadt_info_table[] = {
  * FUNCTION:    acpi_tb_init_generic_address
  *
  * PARAMETERS:  generic_address     - GAS struct to be initialized
- *              bit_width           - Width of this register
+ *              byte_width          - Width of this register
  *              Address             - Address of the register
  *
  * RETURN:      None
@@ -124,7 +124,7 @@ static struct acpi_fadt_info fadt_info_table[] = {
 
 static void inline
 acpi_tb_init_generic_address(struct acpi_generic_address *generic_address,
-			     u8 bit_width, u64 address)
+			     u8 byte_width, u64 address)
 {
 
 	/*
@@ -136,7 +136,7 @@ acpi_tb_init_generic_address(struct acpi_generic_address *generic_address,
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
-- 
1.5.5.1

