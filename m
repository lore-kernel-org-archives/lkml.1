Return-Path: <linux-kernel-owner+w=401wt.eu-S1756954AbZCQViX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756954AbZCQViX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 17:38:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756103AbZCQViN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 17:38:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:33295 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754317AbZCQViM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 17:38:12 -0400
Message-ID: <49C017D0.6030502@kernel.org>
Date: Tue, 17 Mar 2009 14:36:16 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>, Jan Beulich <jbeulich@novell.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: [PATCH] acpi: remove the wrong warning about xpm1a_event_block.bit_width
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: fix warning

it seems there are some merging problems.

that bit_width is already divided by 2. so I got warning from all servers.

also in that case do try to the fallback like comments saying.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/acpi/acpica/tbfadt.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

Index: linux-2.6/drivers/acpi/acpica/tbfadt.c
===================================================================
--- linux-2.6.orig/drivers/acpi/acpica/tbfadt.c
+++ linux-2.6/drivers/acpi/acpica/tbfadt.c
@@ -447,13 +447,16 @@ static void acpi_tb_convert_fadt(void)
 	 * cannot be relied upon, though. Hence resort to using the v1 length
 	 * here (and warn about the inconsistency).
 	 */
-	if (acpi_gbl_FADT.xpm1a_event_block.bit_width
-	    != acpi_gbl_FADT.pm1_event_length * 8)
+	if (acpi_gbl_FADT.xpm1a_event_block.bit_width * 2
+	    != acpi_gbl_FADT.pm1_event_length * 8) {
 		printk(KERN_WARNING "FADT: "
 		       "X_PM1a_EVT_BLK.bit_width (%u) does not match"
 		       " PM1_EVT_LEN (%u)\n",
-		       acpi_gbl_FADT.xpm1a_event_block.bit_width,
+		       acpi_gbl_FADT.xpm1a_event_block.bit_width * 2,
 		       acpi_gbl_FADT.pm1_event_length);
+		pm1_register_byte_width = (u8) ACPI_DIV_2(acpi_gbl_FADT.pm1_event_length);
+		acpi_gbl_FADT.xpm1a_event_block.bit_width = pm1_register_byte_width * 8;
+	}
 
 	/* The PM1A register block is required */
 
@@ -469,13 +472,16 @@ static void acpi_tb_convert_fadt(void)
 	/* The PM1B register block is optional, ignore if not present */
 
 	if (acpi_gbl_FADT.xpm1b_event_block.address) {
-		if (acpi_gbl_FADT.xpm1b_event_block.bit_width
-		    != acpi_gbl_FADT.pm1_event_length * 8)
+		if (acpi_gbl_FADT.xpm1b_event_block.bit_width * 2
+		    != acpi_gbl_FADT.pm1_event_length * 8) {
 			printk(KERN_WARNING "FADT: "
 			       "X_PM1b_EVT_BLK.bit_width (%u) does not match"
 			       " PM1_EVT_LEN (%u)\n",
-			       acpi_gbl_FADT.xpm1b_event_block.bit_width,
+			       acpi_gbl_FADT.xpm1b_event_block.bit_width * 2,
 			       acpi_gbl_FADT.pm1_event_length);
+			pm1_register_byte_width = (u8) ACPI_DIV_2(acpi_gbl_FADT.pm1_event_length);
+			acpi_gbl_FADT.xpm1b_event_block.bit_width = pm1_register_byte_width * 8;
+		}
 		acpi_tb_init_generic_address(&acpi_gbl_xpm1b_enable,
 					     acpi_gbl_FADT.xpm1b_event_block.space_id,
 					     pm1_register_byte_width,
