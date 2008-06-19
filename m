Return-Path: <linux-kernel-owner+w=401wt.eu-S1755569AbYFSCN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569AbYFSCN2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 22:13:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751833AbYFSCNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 22:13:20 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:62731 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbYFSCNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 22:13:19 -0400
Date: Wed, 18 Jun 2008 22:13:00 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
Subject: [stable PATCH 2.6.21] ACPICA: Ignore ACPI table signature for Load()
 operator
X-X-Sender: lenb@localhost.localdomain
To: stable@kernel.org
Cc: linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <alpine.LFD.1.10.0806182211330.3613@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Moore <robert.moore@intel.com>

upstream bc45b1d39a925b56796bebf8a397a0491489d85c

Only "SSDT" is acceptable to the ACPI spec, but tables are
seen with OEMx and null sigs. Therefore, signature validation
is worthless.  Apparently MS ACPI accepts such signatures, ACPICA
must be compatible.

Without this patch booting with acpi_osi="!Windows 2006" is required
for several machines to function properly with cpufreq.

http://bugzilla.kernel.org/show_bug.cgi?id=9919
http://bugzilla.kernel.org/show_bug.cgi?id=10383
http://bugzilla.kernel.org/show_bug.cgi?id=10454
https://bugzilla.novell.com/show_bug.cgi?id=396311

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/tables/tbinstal.c |   25 +++++++------------------
 1 files changed, 7 insertions(+), 18 deletions(-)

Index: linux-2.6.21.y/drivers/acpi/tables/tbinstal.c
===================================================================
--- linux-2.6.21.y.orig/drivers/acpi/tables/tbinstal.c
+++ linux-2.6.21.y/drivers/acpi/tables/tbinstal.c
@@ -123,17 +123,13 @@ acpi_tb_add_table(struct acpi_table_desc
 		}
 	}
 
-	/* The table must be either an SSDT or a PSDT */
-
-	if ((!ACPI_COMPARE_NAME(table_desc->pointer->signature, ACPI_SIG_PSDT))
-	    &&
-	    (!ACPI_COMPARE_NAME(table_desc->pointer->signature, ACPI_SIG_SSDT)))
-	{
-		ACPI_ERROR((AE_INFO,
-			    "Table has invalid signature [%4.4s], must be SSDT or PSDT",
-			    table_desc->pointer->signature));
-		return_ACPI_STATUS(AE_BAD_SIGNATURE);
-	}
+	/*
+	 * Originally, we checked the table signature for "SSDT" or "PSDT" here.
+	 * Next, we added support for OEMx tables, signature "OEM".
+	 * Valid tables were encountered with a null signature, so we've just
+	 * given up on validating the signature, since it seems to be a waste
+	 * of code. The original code was removed (05/2008).
+	 */
 
 	(void)acpi_ut_acquire_mutex(ACPI_MTX_TABLES);
 
