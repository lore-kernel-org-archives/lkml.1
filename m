Return-Path: <linux-kernel-owner+w=401wt.eu-S1762133AbYJKGxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762133AbYJKGxS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 02:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756878AbYJKGjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 02:39:25 -0400
Received: from vms172069pub.verizon.net ([206.46.172.69]:32774 "EHLO
	vms172069pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753474AbYJKGhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 02:37:08 -0400
Date: Sat, 11 Oct 2008 02:36:00 -0400
From: Len Brown <lenb@kernel.org>
Subject: [PATCH 40/85] ACPI suspend: Always use the 32-bit waking vector
In-reply-to: <1223707005-26864-1-git-send-email-lenb@kernel.org>
In-reply-to: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>
Message-id: <2918799361e725d95903dc597ad89228700377e6.1223706853.git.len.brown@intel.com>
Organization: Intel Open Source Technology Center
X-Mailer: git-send-email 1.6.0.2.307.gc427
References: <1223707005-26864-1-git-send-email-lenb@kernel.org>
References: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

According to the ACPI specification 2.0c and later, the 64-bit waking vector
should be cleared and the 32-bit waking vector should be used, unless we want
the wake-up code to be called by the BIOS in Protected Mode.  Moreover, some
systems (for example HP dv5-1004nr) are known to fail to resume if the 64-bit
waking vector is used.  Therefore, modify the code to clear the 64-bit waking
vector, for FACS version 1 or greater, and set the 32-bit one before suspend.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/hardware/hwsleep.c |   39 ++++++++++++---------------------------
 1 files changed, 12 insertions(+), 27 deletions(-)

diff --git a/drivers/acpi/hardware/hwsleep.c b/drivers/acpi/hardware/hwsleep.c
index 130a44b..25dccdf 100644
--- a/drivers/acpi/hardware/hwsleep.c
+++ b/drivers/acpi/hardware/hwsleep.c
@@ -78,19 +78,17 @@ acpi_set_firmware_waking_vector(acpi_physical_address physical_address)
 		return_ACPI_STATUS(status);
 	}
 
-	/* Set the vector */
+	/*
+	 * According to the ACPI specification 2.0c and later, the 64-bit
+	 * waking vector should be cleared and the 32-bit waking vector should
+	 * be used, unless we want the wake-up code to be called by the BIOS in
+	 * Protected Mode.  Some systems (for example HP dv5-1004nr) are known
+	 * to fail to resume if the 64-bit vector is used.
+	 */
+	if (facs->version >= 1)
+		facs->xfirmware_waking_vector = 0;
 
-	if ((facs->length < 32) || (!(facs->xfirmware_waking_vector))) {
-		/*
-		 * ACPI 1.0 FACS or short table or optional X_ field is zero
-		 */
-		facs->firmware_waking_vector = (u32) physical_address;
-	} else {
-		/*
-		 * ACPI 2.0 FACS with valid X_ field
-		 */
-		facs->xfirmware_waking_vector = physical_address;
-	}
+	facs->firmware_waking_vector = (u32)physical_address;
 
 	return_ACPI_STATUS(AE_OK);
 }
@@ -134,20 +132,7 @@ acpi_get_firmware_waking_vector(acpi_physical_address * physical_address)
 	}
 
 	/* Get the vector */
-
-	if ((facs->length < 32) || (!(facs->xfirmware_waking_vector))) {
-		/*
-		 * ACPI 1.0 FACS or short table or optional X_ field is zero
-		 */
-		*physical_address =
-		    (acpi_physical_address) facs->firmware_waking_vector;
-	} else {
-		/*
-		 * ACPI 2.0 FACS with valid X_ field
-		 */
-		*physical_address =
-		    (acpi_physical_address) facs->xfirmware_waking_vector;
-	}
+	*physical_address = (acpi_physical_address)facs->firmware_waking_vector;
 
 	return_ACPI_STATUS(AE_OK);
 }
-- 
1.5.5.1

