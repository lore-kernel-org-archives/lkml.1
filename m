Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557Ab0BVTMH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 14:12:07 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:36190 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754147Ab0BVTMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 14:12:01 -0500
Subject: [PATCH v2 11/12] ACPI: processor: push file static MADT pointer into
	internal map_madt_entry()
To: lenb@kernel.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Date: Mon, 22 Feb 2010 12:12:00 -0700
Message-ID: <20100222191200.19752.90558.stgit@bob.kio>
In-Reply-To: <20100222190145.19752.20978.stgit@bob.kio>
References: <20100222190145.19752.20978.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no real need for a pointer to the MADT to be global. The only
function who uses it is map_madt_entry.

This allows us to remove some more ugly #ifdefs.

Acked-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/acpi/processor_core.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
index ee9bce1..791ac7b 100644
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -43,8 +43,6 @@ static struct dmi_system_id __cpuinitdata processor_idle_dmi_table[] = {
 };
 
 #ifdef CONFIG_SMP
-static struct acpi_table_madt *madt;
-
 static int map_lapic_id(struct acpi_subtable_header *entry,
 		 u32 acpi_id, int *apic_id)
 {
@@ -100,8 +98,17 @@ static int map_lsapic_id(struct acpi_subtable_header *entry,
 static int map_madt_entry(int type, u32 acpi_id)
 {
 	unsigned long madt_end, entry;
+	static struct acpi_table_madt *madt;
+	static int read_madt;
 	int apic_id = -1;
 
+	if (!read_madt) {
+		if (ACPI_FAILURE(acpi_get_table(ACPI_SIG_MADT, 0,
+					(struct acpi_table_header **)&madt)))
+			madt = NULL;
+		read_madt++;
+	}
+
 	if (!madt)
 		return apic_id;
 
@@ -335,13 +342,6 @@ early_init_pdc(acpi_handle handle, u32 lvl, void *context, void **rv)
 
 void __init acpi_early_processor_set_pdc(void)
 {
-
-#ifdef CONFIG_SMP
-	if (ACPI_FAILURE(acpi_get_table(ACPI_SIG_MADT, 0,
-				(struct acpi_table_header **)&madt)))
-		madt = NULL;
-#endif
-
 	/*
 	 * Check whether the system is DMI table. If yes, OSPM
 	 * should not use mwait for CPU-states.

