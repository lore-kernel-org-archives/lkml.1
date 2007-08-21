Return-Path: <linux-kernel-owner+w=401wt.eu-S1760317AbXHUGzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760317AbXHUGzS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 02:55:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760533AbXHUGxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 02:53:23 -0400
Received: from canuck.infradead.org ([209.217.80.40]:44199 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760494AbXHUGxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 02:53:22 -0400
Date: Mon, 20 Aug 2007 23:55:03 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Len Brown <len.brown@intel.com>, Bob Moore <robert.moore@intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 09/20] ACPICA: Clear reserved fields for incoming ACPI 1.0
	FADTs
Message-ID: <20070821065503.GJ5275@kroah.com>
References: <20070821064251.972690753@blue.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="acpica-clear-reserved-fields-for-incoming-acpi-1.0-fadts.patch"
In-Reply-To: <20070821065210.GA5275@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Bob Moore <robert.moore@intel.com>

ACPICA: Clear reserved fields for incoming ACPI 1.0 FADTs

Fixed a problem with the internal FADT conversion where ACPI 1.0
FADTs that contained invalid non-zero values in reserved fields
could cause later failures because these fields have meaning in
later revisions of the FADT. For incoming ACPI 1.0 FADTs, these
fields are now always zeroed. (Preferred_PM_Profile, PSTATE_CNT,
CST_CNT, IAPC_BOOT_FLAGS.)

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/tables/tbfadt.c |   44 +++++++++++++++++++++++++------------------
 1 file changed, 26 insertions(+), 18 deletions(-)

--- a/drivers/acpi/tables/tbfadt.c
+++ b/drivers/acpi/tables/tbfadt.c
@@ -211,14 +211,17 @@ void acpi_tb_parse_fadt(acpi_native_uint
  * DESCRIPTION: Get a local copy of the FADT and convert it to a common format.
  *              Performs validation on some important FADT fields.
  *
+ * NOTE:        We create a local copy of the FADT regardless of the version.
+ *
  ******************************************************************************/
 
 void acpi_tb_create_local_fadt(struct acpi_table_header *table, u32 length)
 {
 
 	/*
-	 * Check if the FADT is larger than what we know about (ACPI 2.0 version).
-	 * Truncate the table, but make some noise.
+	 * Check if the FADT is larger than the largest table that we expect
+	 * (the ACPI 2.0/3.0 version). If so, truncate the table, and issue
+	 * a warning.
 	 */
 	if (length > sizeof(struct acpi_table_fadt)) {
 		ACPI_WARNING((AE_INFO,
@@ -227,10 +230,12 @@ void acpi_tb_create_local_fadt(struct ac
 			      sizeof(struct acpi_table_fadt)));
 	}
 
-	/* Copy the entire FADT locally. Zero first for tb_convert_fadt */
+	/* Clear the entire local FADT */
 
 	ACPI_MEMSET(&acpi_gbl_FADT, 0, sizeof(struct acpi_table_fadt));
 
+	/* Copy the original FADT, up to sizeof (struct acpi_table_fadt) */
+
 	ACPI_MEMCPY(&acpi_gbl_FADT, table,
 		    ACPI_MIN(length, sizeof(struct acpi_table_fadt)));
 
@@ -251,7 +256,7 @@ void acpi_tb_create_local_fadt(struct ac
  * RETURN:      None
  *
  * DESCRIPTION: Converts all versions of the FADT to a common internal format.
- *              -> Expand all 32-bit addresses to 64-bit.
+ *              Expand all 32-bit addresses to 64-bit.
  *
  * NOTE:        acpi_gbl_FADT must be of size (struct acpi_table_fadt),
  *              and must contain a copy of the actual FADT.
@@ -292,8 +297,23 @@ static void acpi_tb_convert_fadt(void)
 	}
 
 	/*
-	 * Expand the 32-bit V1.0 addresses to the 64-bit "X" generic address
-	 * structures as necessary.
+	 * For ACPI 1.0 FADTs (revision 1 or 2), ensure that reserved fields which
+	 * should be zero are indeed zero. This will workaround BIOSs that
+	 * inadvertently place values in these fields.
+	 *
+	 * The ACPI 1.0 reserved fields that will be zeroed are the bytes located at
+	 * offset 45, 55, 95, and the word located at offset 109, 110.
+	 */
+	if (acpi_gbl_FADT.header.revision < 3) {
+		acpi_gbl_FADT.preferred_profile = 0;
+		acpi_gbl_FADT.pstate_control = 0;
+		acpi_gbl_FADT.cst_control = 0;
+		acpi_gbl_FADT.boot_flags = 0;
+	}
+
+	/*
+	 * Expand the ACPI 1.0 32-bit V1.0 addresses to the ACPI 2.0 64-bit "X"
+	 * generic address structures as necessary.
 	 */
 	for (i = 0; i < ACPI_FADT_INFO_ENTRIES; i++) {
 		target =
@@ -349,18 +369,6 @@ static void acpi_tb_convert_fadt(void)
 		    acpi_gbl_FADT.xpm1a_event_block.space_id;
 
 	}
-
-	/*
-	 * For ACPI 1.0 FADTs, ensure that reserved fields (which should be zero)
-	 * are indeed zero. This will workaround BIOSs that inadvertently placed
-	 * values in these fields.
-	 */
-	if (acpi_gbl_FADT.header.revision < 3) {
-		acpi_gbl_FADT.preferred_profile = 0;
-		acpi_gbl_FADT.pstate_control = 0;
-		acpi_gbl_FADT.cst_control = 0;
-		acpi_gbl_FADT.boot_flags = 0;
-	}
 }
 
 /******************************************************************************

-- 
