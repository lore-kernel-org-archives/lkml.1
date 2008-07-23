Return-Path: <linux-kernel-owner+w=401wt.eu-S1753815AbYGWPpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815AbYGWPpe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 11:45:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751433AbYGWPp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 11:45:27 -0400
Received: from mga02.intel.com ([134.134.136.20]:61817 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751914AbYGWPp0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 11:45:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,239,1215414000"; 
   d="scan'208";a="364206142"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Endless ACPI errors on Linus tree (5b664cb235)
Date: Wed, 23 Jul 2008 08:43:49 -0700
Message-ID: <9D39833986E69849A2A8E74C1078B6B3B68DDD@orsmsx415.amr.corp.intel.com>
In-reply-to: <488731DD.76E4.0078.0@novell.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Endless ACPI errors on Linus tree (5b664cb235)
Thread-Index: AcjstxtTLqcog5YgToOFCSsR3t8P3QAIw2Ew
References: <s5hzlof1ll2.wl%tiwai@suse.de> <87od4vqvaj.fsf@basil.nowhere.org> <s5htzencp02.wl%tiwai@suse.de> <s5hr69rz57u.wl%tiwai@suse.de> <s5hk5fjurag.wl%tiwai@suse.de> <4880DE15.76E4.0078.0@novell.com> <s5habgfdu5e.wl%tiwai@suse.de> <20080718165814.GF32051@basil.nowhere.org> <s5hmykexm53.wl%tiwai@suse.de> <488460E0.76E4.0078.0@novell.com> <20080721084354.GB20258@basil.nowhere.org> <488731DD.76E4.0078.0@novell.com>
From: "Moore, Robert" <robert.moore@intel.com>
To: "Jan Beulich" <jbeulich@novell.com>, "Andi Kleen" <andi@firstfloor.org>,
       "Len Brown" <lenb@kernel.org>
Cc: "Andrew Paprocki" <andrew@ishiboo.com>, "Takashi Iwai" <tiwai@suse.de>,
       "LKML" <linux-kernel@vger.kernel.org>,
       "Gough, Robert" <robert.gough@intel.com>
X-OriginalArrivalTime: 23 Jul 2008 15:43:50.0224 (UTC) FILETIME=[E6FA2D00:01C8ECDA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Couple of thoughts.

I think we must use the V2 field if it is present and the address value
is > 32 bits.

What if the V2 address is < 32 bits but does not match the V1 address?

>-----Original Message-----
>From: Jan Beulich [mailto:jbeulich@novell.com]
>Sent: Wednesday, July 23, 2008 4:28 AM
>To: Andi Kleen; Len Brown
>Cc: Moore, Robert; Andrew Paprocki; Takashi Iwai; LKML
>Subject: Re: Endless ACPI errors on Linus tree (5b664cb235)
>
>>>> Andi Kleen <andi@firstfloor.org> 21.07.08 10:43 >>>
>>> That would basically mean there's no way to use the v2 fields here -
all
>>> the code could do is report the inconsitency, but it would have to
use
>>> the v1 field in any case. That's really a shame, and as before I'm
>>> somewhat hesitant to do so. The only way I could easily find myself
>>> doing this would be to introduce a command line option controlling
the
>>> behavior here, but that would need to be done outside of the ACPICA
>>> code I'd assume.
>>>
>>> Andi, Bob, Len?
>>
>>I think we should only use v1 FADT fields for now and ignore v2.
>
>Here we go:
>
>Subject: ACPI: fix FADT parsing (v3)
>
>The (1.0 inherited) separate length fields in the FADT are byte
>granular. Further, PM1a/b may live in distinct address spaces, and they
>also could have different widths (if using the respective v2 fields was
>okay, which in practice it apparently isn't). acpi_tb_convert_fadt()
>should account for all of these conditions.
>
>Signed-off-by: Jan Beulich <jbeulich@novell.com>
>
>---
> drivers/acpi/tables/tbfadt.c |   32 +++++++++++++++++++++++++-------
> 1 file changed, 25 insertions(+), 7 deletions(-)
>
>--- linux-2.6.26/drivers/acpi/tables/tbfadt.c	2008-07-13
>23:51:29.000000000 +0200
>+++ 2.6.26-acpi-fadt-parse/drivers/acpi/tables/tbfadt.c
2008-07-23
>13:21:22.000000000 +0200
>@@ -50,7 +50,7 @@ ACPI_MODULE_NAME("tbfadt")
> /* Local prototypes */
> static void inline
> acpi_tb_init_generic_address(struct acpi_generic_address
*generic_address,
>-			     u8 bit_width, u64 address);
>+			     u8 byte_width, u64 address);
>
> static void acpi_tb_convert_fadt(void);
>
>@@ -111,7 +111,7 @@ static struct acpi_fadt_info fadt_info_t
>  * FUNCTION:    acpi_tb_init_generic_address
>  *
>  * PARAMETERS:  generic_address     - GAS struct to be initialized
>- *              bit_width           - Width of this register
>+ *              byte_width          - Width of this register
>  *              Address             - Address of the register
>  *
>  * RETURN:      None
>@@ -124,7 +124,7 @@ static struct acpi_fadt_info fadt_info_t
>
> static void inline
> acpi_tb_init_generic_address(struct acpi_generic_address
*generic_address,
>-			     u8 bit_width, u64 address)
>+			     u8 byte_width, u64 address)
> {
>
> 	/*
>@@ -136,7 +136,7 @@ acpi_tb_init_generic_address(struct acpi
> 	/* All other fields are byte-wide */
>
> 	generic_address->space_id = ACPI_ADR_SPACE_SYSTEM_IO;
>-	generic_address->bit_width = bit_width;
>+	generic_address->bit_width = byte_width << 3;
> 	generic_address->bit_offset = 0;
> 	generic_address->access_width = 0;
> }
>@@ -342,9 +342,20 @@ static void acpi_tb_convert_fadt(void)
> 	 * useful to calculate them once, here.
> 	 *
> 	 * The PM event blocks are split into two register blocks, first
is
>the
>-	 * PM Status Register block, followed immediately by the PM
Enable
>Register
>-	 * block. Each is of length (pm1_event_length/2)
>+	 * PM Status Register block, followed immediately by the PM
Enable
>+	 * Register block. Each is of length
(xpm1x_event_block.bit_width/2).
>+	 *
>+	 * On various systems the v2 fields (and particularly the bit
widths)
>+	 * cannot be relied upon, though. Hence resort to using the v1
length
>+	 * here (and warn about the inconsistency).
> 	 */
>+	if (acpi_gbl_FADT.xpm1a_event_block.bit_width
>+	    != acpi_gbl_FADT.pm1_event_length * 8)
>+		printk(KERN_WARNING "FADT: "
>+		       "X_PM1a_EVT_BLK.bit_width (%u) does not match"
>+		       " PM1_EVT_LEN (%u)\n",
>+		       acpi_gbl_FADT.xpm1a_event_block.bit_width,
>+		       acpi_gbl_FADT.pm1_event_length);
> 	pm1_register_length = (u8)
>ACPI_DIV_2(acpi_gbl_FADT.pm1_event_length);
>
> 	/* The PM1A register block is required */
>@@ -360,13 +371,20 @@ static void acpi_tb_convert_fadt(void)
> 	/* The PM1B register block is optional, ignore if not present */
>
> 	if (acpi_gbl_FADT.xpm1b_event_block.address) {
>+		if (acpi_gbl_FADT.xpm1b_event_block.bit_width
>+		    != acpi_gbl_FADT.pm1_event_length * 8)
>+			printk(KERN_WARNING "FADT: "
>+			       "X_PM1b_EVT_BLK.bit_width (%u) does not
match"
>+			       " PM1_EVT_LEN (%u)\n",
>+
acpi_gbl_FADT.xpm1b_event_block.bit_width,
>+			       acpi_gbl_FADT.pm1_event_length);
> 		acpi_tb_init_generic_address(&acpi_gbl_xpm1b_enable,
> 					     pm1_register_length,
>
(acpi_gbl_FADT.xpm1b_event_block.
> 					      address +
pm1_register_length));
> 		/* Don't forget to copy space_id of the GAS */
> 		acpi_gbl_xpm1b_enable.space_id =
>-		    acpi_gbl_FADT.xpm1a_event_block.space_id;
>+		    acpi_gbl_FADT.xpm1b_event_block.space_id;
>
> 	}
> }
>

