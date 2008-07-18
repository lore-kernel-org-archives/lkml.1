Return-Path: <linux-kernel-owner+w=401wt.eu-S1759523AbYGRQQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759523AbYGRQQm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 12:16:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755581AbYGRQQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 12:16:33 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:40312 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755255AbYGRQQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 12:16:32 -0400
Message-Id: <4880DE15.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Fri, 18 Jul 2008 17:16:53 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Takashi Iwai" <tiwai@suse.de>
Cc: "Andi Kleen" <andi@firstfloor.org>, <robert.moore@intel.com>,
       "Len Brown" <lenb@kernel.org>, "LKML" <linux-kernel@vger.kernel.org>
Subject: Re: Endless ACPI errors on Linus tree (5b664cb235)
References: <s5hzlof1ll2.wl%tiwai@suse.de>
 <87od4vqvaj.fsf@basil.nowhere.org> <s5htzencp02.wl%tiwai@suse.de>
 <s5hr69rz57u.wl%tiwai@suse.de> <s5hk5fjurag.wl%tiwai@suse.de>
In-Reply-To: <s5hk5fjurag.wl%tiwai@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=__Part84AD41E5.4__="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME message. If you are reading this text, you may want to 
consider changing to a mail reader or gateway that understands how to 
properly handle MIME multipart messages.

--=__Part84AD41E5.4__=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

>OK, found out the bad commit via bisect.
>Reverting below fixes the boot problem.
>
>
>commit 01a5bba576b9364b33f61f0cd9fa70c2cf5535e2
>Author: Jan Beulich <jbeulich@novell.com>
>Date:   Wed Jul 16 23:27:08 2008 +0200
>
>    Fix FADT parsing
   =20
After someone else observed some problem with this patch earlier, I had
already sent out attached patch as a replacement one. Any chance you
could also try this with your box?

Thanks, Jan


--=__Part84AD41E5.4__=
Content-Type: text/plain; name="linux-2.6.26-acpi-fadt-parse.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename="linux-2.6.26-acpi-fadt-parse.patch"

The (1.0 inherited) separate length fields in the FADT are byte
granular. Further, PM1a/b may have distinct lengths and live in
distinct address spaces. acpi_tb_convert_fadt() should account for
all of these conditions.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 drivers/acpi/tables/tbfadt.c |   39 ++++++++++++++++++++++++++++++++------=
-
 1 file changed, 32 insertions(+), 7 deletions(-)

--- linux-2.6.26/drivers/acpi/tables/tbfadt.c	2008-07-13 23:51:29.0000000=
00 +0200
+++ 2.6.26-acpi-fadt-parse/drivers/acpi/tables/tbfadt.c	2008-07-18 =
10:43:55.000000000 +0200
@@ -50,7 +50,7 @@ ACPI_MODULE_NAME("tbfadt")
 /* Local prototypes */
 static void inline
 acpi_tb_init_generic_address(struct acpi_generic_address *generic_address,=

-			     u8 bit_width, u64 address);
+			     u8 byte_width, u64 address);
=20
 static void acpi_tb_convert_fadt(void);
=20
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
=20
 static void inline
 acpi_tb_init_generic_address(struct acpi_generic_address *generic_address,=

-			     u8 bit_width, u64 address)
+			     u8 byte_width, u64 address)
 {
=20
 	/*
@@ -136,7 +136,7 @@ acpi_tb_init_generic_address(struct acpi
 	/* All other fields are byte-wide */
=20
 	generic_address->space_id =3D ACPI_ADR_SPACE_SYSTEM_IO;
-	generic_address->bit_width =3D bit_width;
+	generic_address->bit_width =3D byte_width << 3;
 	generic_address->bit_offset =3D 0;
 	generic_address->access_width =3D 0;
 }
@@ -343,9 +343,21 @@ static void acpi_tb_convert_fadt(void)
 	 *
 	 * The PM event blocks are split into two register blocks, first =
is the
 	 * PM Status Register block, followed immediately by the PM Enable =
Register
-	 * block. Each is of length (pm1_event_length/2)
+	 * block. Each is of length (xpm1x_event_block.bit_width/2)
 	 */
-	pm1_register_length =3D (u8) ACPI_DIV_2(acpi_gbl_FADT.pm1_event_len=
gth);
+	if (!ACPI_MOD_16(acpi_gbl_FADT.xpm1a_event_block.bit_width))
+		pm1_register_length =3D (u8) ACPI_DIV_16(acpi_gbl_FADT
+						       .xpm1a_event_block
+						       .bit_width);
+	else {
+		printk(KERN_WARNING "FADT: "
+		       "X_PM1a_EVT_BLK.bit_width=3D%u is invalid,"
+		       " falling back to PM1_EVT_LEN=3D%u\n",
+		       acpi_gbl_FADT.xpm1a_event_block.bit_width,
+		       acpi_gbl_FADT.pm1_event_length);
+		pm1_register_length =3D (u8) ACPI_DIV_2(acpi_gbl_FADT
+						      .pm1_event_length);
+	}
=20
 	/* The PM1A register block is required */
=20
@@ -360,13 +372,26 @@ static void acpi_tb_convert_fadt(void)
 	/* The PM1B register block is optional, ignore if not present */
=20
 	if (acpi_gbl_FADT.xpm1b_event_block.address) {
+		if (!ACPI_MOD_16(acpi_gbl_FADT.xpm1b_event_block.bit_width)=
)
+			pm1_register_length =3D (u8) ACPI_DIV_16(acpi_gbl_F=
ADT
+							       .xpm1b_event=
_block
+							       .bit_width);=

+		else {
+			printk(KERN_WARNING "FADT: "
+			       "X_PM1b_EVT_BLK.bit_width=3D%u is invalid,"
+			       " falling back to PM1_EVT_LEN=3D%u\n",
+			       acpi_gbl_FADT.xpm1b_event_block.bit_width,
+			       acpi_gbl_FADT.pm1_event_length);
+			pm1_register_length =3D (u8) ACPI_DIV_2(acpi_gbl_FA=
DT
+							       .pm1_event_l=
ength);
+		}
 		acpi_tb_init_generic_address(&acpi_gbl_xpm1b_enable,
 					     pm1_register_length,
 					     (acpi_gbl_FADT.xpm1b_event_blo=
ck.
 					      address + pm1_register_length=
));
 		/* Don't forget to copy space_id of the GAS */
 		acpi_gbl_xpm1b_enable.space_id =3D
-		    acpi_gbl_FADT.xpm1a_event_block.space_id;
+		    acpi_gbl_FADT.xpm1b_event_block.space_id;
=20
 	}
 }

--=__Part84AD41E5.4__=--
