Return-Path: <linux-kernel-owner+w=401wt.eu-S932079AbZLTTUI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079AbZLTTUI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 14:20:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756058AbZLTTTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 14:19:54 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:2800 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756033AbZLTTTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 14:19:45 -0500
Subject: [PATCH 08/11] ACPI: processor: change acpi_processor_eval_pdc
	interface
To: venkatesh.pallipadi@intel.com, lenb@kernel.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-acpi@vger.kernel.org, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org
Date: Sun, 20 Dec 2009 12:19:45 -0700
Message-ID: <20091220191944.4274.97945.stgit@bob.kio>
In-Reply-To: <20091220190434.4274.67855.stgit@bob.kio>
References: <20091220190434.4274.67855.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

acpi_processor_eval_pdc() really only needs a handle and an
acpi_object_list * to do its work.

No need to pass in a struct acpi_processor *, so let's be more specific
about what we want.

Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/acpi/processor_pdc.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/acpi/processor_pdc.c b/drivers/acpi/processor_pdc.c
index 23d2828..974de4e 100644
--- a/drivers/acpi/processor_pdc.c
+++ b/drivers/acpi/processor_pdc.c
@@ -97,13 +97,11 @@ static struct acpi_object_list *acpi_processor_alloc_pdc(void)
  * _PDC is required for a BIOS-OS handshake for most of the newer
  * ACPI processor features.
  */
-static int acpi_processor_eval_pdc(struct acpi_processor *pr)
+static int
+acpi_processor_eval_pdc(acpi_handle handle, struct acpi_object_list *pdc_in)
 {
-	struct acpi_object_list *pdc_in = pr->pdc;
 	acpi_status status = AE_OK;
 
-	if (!pdc_in)
-		return status;
 	if (idle_nomwait) {
 		/*
 		 * If mwait is disabled for CPU C-states, the C2C3_FFH access
@@ -118,7 +116,7 @@ static int acpi_processor_eval_pdc(struct acpi_processor *pr)
 		buffer[2] &= ~(ACPI_PDC_C_C2C3_FFH | ACPI_PDC_C_C1_FFH);
 
 	}
-	status = acpi_evaluate_object(pr->handle, "_PDC", pdc_in, NULL);
+	status = acpi_evaluate_object(handle, "_PDC", pdc_in, NULL);
 
 	if (ACPI_FAILURE(status))
 		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
@@ -148,9 +146,7 @@ void acpi_processor_set_pdc(struct acpi_processor *pr)
 	if (!obj_list)
 		return;
 
-	pr->pdc = obj_list;
-
-	acpi_processor_eval_pdc(pr);
+	acpi_processor_eval_pdc(pr->handle, obj_list);
 	acpi_processor_cleanup_pdc(pr);
 }
 EXPORT_SYMBOL_GPL(acpi_processor_set_pdc);

