Return-Path: <linux-kernel-owner+w=401wt.eu-S1754505AbXD2Aip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505AbXD2Aip (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 20:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754500AbXD2Aip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 20:38:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:55896 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754514AbXD2Ain (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 20:38:43 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: stable@kernel.org
Subject: [2.6.21.stable PATCH] ACPI: Fix 2.6.21 boot regression on P4/HT
Date: Sat, 28 Apr 2007 20:37:26 -0400
User-Agent: KMail/1.9.5
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704282037.26662.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Up through 2.6.20 we cleared the FADT.CSTATE_CONTROL field
for FADT versions before r3, because it made no sense
for that reserved field to be set for pre-ACPI 2.0 systems.

It turns out that not clearing this field exposes
Linux to SMM BIOS failures, so do the same in 2.6.21.

http://bugzilla.kernel.org/show_bug.cgi?id=8346

Signed-off-by: Len Brown <len.brown@intel.com>
---
diff --git a/drivers/acpi/tables/tbfadt.c b/drivers/acpi/tables/tbfadt.c
index 807c711..d341491 100644
--- a/drivers/acpi/tables/tbfadt.c
+++ b/drivers/acpi/tables/tbfadt.c
@@ -347,6 +347,20 @@ static void acpi_tb_convert_fadt(void)
 		acpi_gbl_xpm1b_enable.space_id = acpi_gbl_FADT.xpm1a_event_block.space_id;
 
 	}
+	/*
+	 * _CST object and C States change notification start with
+	 * ACPI 2.0 (FADT r3).  Although the field should be Reserved
+	 * and 0 before then, some pre-r3 FADT set this field and
+	 * it results in SMM-related boot failures.  For them, clear it.
+	 */
+	if ((acpi_gbl_FADT.header.revision < 3) &&
+		(acpi_gbl_FADT.cst_control != 0)) {
+			ACPI_WARNING((AE_INFO,
+				"Ignoring BIOS FADT r%u C-state control",
+				acpi_gbl_FADT.header.revision));
+		 	acpi_gbl_FADT.cst_control = 0;
+	}
+
 }
 
 /******************************************************************************
