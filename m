Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634Ab0BVTMl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 14:12:41 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:6790 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754492Ab0BVTLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 14:11:55 -0500
Subject: [PATCH v2 10/12] ACPI: processor: refactor internal map_lsapic_id()
To: lenb@kernel.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Date: Mon, 22 Feb 2010 12:11:55 -0700
Message-ID: <20100222191155.19752.95091.stgit@bob.kio>
In-Reply-To: <20100222190145.19752.20978.stgit@bob.kio>
References: <20100222190145.19752.20978.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Un-nest the if statements for readability.

Remove comments that re-state the obvious.

Change the control flow so that we no longer need a temp variable.

Acked-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/acpi/processor_core.c |   20 +++++---------------
 1 files changed, 5 insertions(+), 15 deletions(-)

diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
index 18fa633..ee9bce1 100644
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -83,27 +83,17 @@ static int map_lsapic_id(struct acpi_subtable_header *entry,
 {
 	struct acpi_madt_local_sapic *lsapic =
 		(struct acpi_madt_local_sapic *)entry;
-	u32 tmp = (lsapic->id << 8) | lsapic->eid;
 
-	/* Only check enabled APICs*/
 	if (!(lsapic->lapic_flags & ACPI_MADT_ENABLED))
 		return 0;
 
-	/* Device statement declaration type */
 	if (device_declaration) {
-		if (entry->length < 16)
-			printk(KERN_ERR PREFIX
-			    "Invalid LSAPIC with Device type processor (SAPIC ID %#x)\n",
-			    tmp);
-		else if (lsapic->uid == acpi_id)
-			goto found;
-	/* Processor statement declaration type */
-	} else if (lsapic->processor_id == acpi_id)
-		goto found;
+		if ((entry->length < 16) || (lsapic->uid != acpi_id))
+			return 0;
+	} else if (lsapic->processor_id != acpi_id)
+		return 0;
 
-	return 0;
-found:
-	*apic_id = tmp;
+	*apic_id = (lsapic->id << 8) | lsapic->eid;
 	return 1;
 }
 

