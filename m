Return-Path: <linux-kernel-owner+w=401wt.eu-S1755109Ab0AZXpV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755109Ab0AZXpV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:45:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753614Ab0AZXpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:45:14 -0500
Received: from kroah.org ([198.145.64.141]:35568 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755004Ab0AZXoa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:44:30 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:33 2010
Message-Id: <20100126233933.720024657@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:35:03 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       linux-acpi@vger.kernel.org, Len Brown <len.brown@intel.com>
Subject: [97/98] ACPI: enable C2 and Turbo-mode on Nehalem notebooks on A/C
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Len Brown <len.brown@intel.com>

upstream in 2.6.33-rc:  5d76b6f6c17572e662f5c99c2023adae92100855

Refreshed here for 2.6.32.y, applies w/ offset back to 2.6.29.y.

Linux has always ignored ACPI BIOS C2 with exit latency > 100 usec,
and the ACPI spec is clear that is correct FADT-supplied C2.

However, the ACPI spec explicitly states that _CST-supplied C-states
have no latency limits.

So move the 100usec C2 test out of the code shared
by FADT and _CST code-paths, and into the FADT-specific path.

This bug has not been visible until Nehalem, which advertises
a CPU-C2 worst case exit latency on servers of 205usec.
That (incorrect) figure is being used by BIOS writers
on mobile Nehalem systems for the AC configuration.
Thus, Linux ignores C2 leaving just C1, which is
saves less power, and also impacts performance
by preventing the use of turbo mode.

http://bugzilla.kernel.org/show_bug.cgi?id=15064

Tested-by: Alex Chiang <achiang@hp.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/processor_idle.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -299,6 +299,17 @@ static int acpi_processor_get_power_info
 	pr->power.states[ACPI_STATE_C2].latency = acpi_gbl_FADT.C2latency;
 	pr->power.states[ACPI_STATE_C3].latency = acpi_gbl_FADT.C3latency;
 
+	/*
+	 * FADT specified C2 latency must be less than or equal to
+	 * 100 microseconds.
+	 */
+	if (acpi_gbl_FADT.C2latency > ACPI_PROCESSOR_MAX_C2_LATENCY) {
+		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
+			"C2 latency too large [%d]\n", acpi_gbl_FADT.C2latency));
+		/* invalidate C2 */
+		pr->power.states[ACPI_STATE_C2].address = 0;
+	}
+
 	ACPI_DEBUG_PRINT((ACPI_DB_INFO,
 			  "lvl2[0x%08x] lvl3[0x%08x]\n",
 			  pr->power.states[ACPI_STATE_C2].address,
@@ -495,16 +506,6 @@ static void acpi_processor_power_verify_
 		return;
 
 	/*
-	 * C2 latency must be less than or equal to 100
-	 * microseconds.
-	 */
-	else if (cx->latency > ACPI_PROCESSOR_MAX_C2_LATENCY) {
-		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
-				  "latency too large [%d]\n", cx->latency));
-		return;
-	}
-
-	/*
 	 * Otherwise we've met all of our C2 requirements.
 	 * Normalize the C2 latency to expidite policy
 	 */


