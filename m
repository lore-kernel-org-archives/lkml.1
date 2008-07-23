Return-Path: <linux-kernel-owner+w=401wt.eu-S1753207AbYGWL1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207AbYGWL1j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 07:27:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750875AbYGWL1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 07:27:31 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:15315 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbYGWL13 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 07:27:29 -0400
Message-Id: <488731DD.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Wed, 23 Jul 2008 12:27:57 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Andi Kleen" <andi@firstfloor.org>, "Len Brown" <lenb@kernel.org>
Cc: <robert.moore@intel.com>, "Andrew Paprocki" <andrew@ishiboo.com>,
       "Takashi Iwai" <tiwai@suse.de>, "LKML" <linux-kernel@vger.kernel.org>
Subject: Re: Endless ACPI errors on Linus tree (5b664cb235)
References: <s5hzlof1ll2.wl%tiwai@suse.de>
 <87od4vqvaj.fsf@basil.nowhere.org> <s5htzencp02.wl%tiwai@suse.de>
 <s5hr69rz57u.wl%tiwai@suse.de> <s5hk5fjurag.wl%tiwai@suse.de>
 <4880DE15.76E4.0078.0@novell.com> <s5habgfdu5e.wl%tiwai@suse.de>
 <20080718165814.GF32051@basil.nowhere.org> <s5hmykexm53.wl%tiwai@suse.de>
 <488460E0.76E4.0078.0@novell.com>
 <20080721084354.GB20258@basil.nowhere.org>
In-Reply-To: <20080721084354.GB20258@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Andi Kleen <andi@firstfloor.org> 21.07.08 10:43 >>>
>> That would basically mean there's no way to use the v2 fields here - all
>> the code could do is report the inconsitency, but it would have to use
>> the v1 field in any case. That's really a shame, and as before I'm
>> somewhat hesitant to do so. The only way I could easily find myself
>> doing this would be to introduce a command line option controlling the
>> behavior here, but that would need to be done outside of the ACPICA
>> code I'd assume.
>> 
>> Andi, Bob, Len?
>
>I think we should only use v1 FADT fields for now and ignore v2.

Here we go:

Subject: ACPI: fix FADT parsing (v3)

The (1.0 inherited) separate length fields in the FADT are byte
granular. Further, PM1a/b may live in distinct address spaces, and they
also could have different widths (if using the respective v2 fields was
okay, which in practice it apparently isn't). acpi_tb_convert_fadt()
should account for all of these conditions.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 drivers/acpi/tables/tbfadt.c |   32 +++++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

--- linux-2.6.26/drivers/acpi/tables/tbfadt.c	2008-07-13 23:51:29.000000000 +0200
+++ 2.6.26-acpi-fadt-parse/drivers/acpi/tables/tbfadt.c	2008-07-23 13:21:22.000000000 +0200
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


