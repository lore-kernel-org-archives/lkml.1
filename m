Return-Path: <linux-kernel-owner+w=401wt.eu-S1756034AbZLTTXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034AbZLTTXR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 14:23:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754618AbZLTTXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 14:23:15 -0500
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:11417 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754276AbZLTTXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 14:23:13 -0500
Subject: [PATCH 1/3] ACPI: processor: open code acpi_processor_cleanup_pdc
To: venkatesh.pallipadi@intel.com, lenb@kernel.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-acpi@vger.kernel.org, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org
Date: Sun, 20 Dec 2009 12:23:11 -0700
Message-ID: <20091220192311.5438.53207.stgit@bob.kio>
In-Reply-To: <20091220190434.4274.67855.stgit@bob.kio>
References: <20091220190434.4274.67855.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have the acpi_object_list * right there in acpi_processor_set_pdc()
so it doesn't seem necessary for an entire helper function just to
free it.

Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/acpi/processor_pdc.c |   15 ++++-----------
 1 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/acpi/processor_pdc.c b/drivers/acpi/processor_pdc.c
index 974de4e..deeba22 100644
--- a/drivers/acpi/processor_pdc.c
+++ b/drivers/acpi/processor_pdc.c
@@ -125,16 +125,6 @@ acpi_processor_eval_pdc(acpi_handle handle, struct acpi_object_list *pdc_in)
 	return status;
 }
 
-static void acpi_processor_cleanup_pdc(struct acpi_processor *pr)
-{
-	if (pr->pdc) {
-		kfree(pr->pdc->pointer->buffer.pointer);
-		kfree(pr->pdc->pointer);
-		kfree(pr->pdc);
-		pr->pdc = NULL;
-	}
-}
-
 void acpi_processor_set_pdc(struct acpi_processor *pr)
 {
 	struct acpi_object_list *obj_list;
@@ -147,7 +137,10 @@ void acpi_processor_set_pdc(struct acpi_processor *pr)
 		return;
 
 	acpi_processor_eval_pdc(pr->handle, obj_list);
-	acpi_processor_cleanup_pdc(pr);
+
+	kfree(obj_list->pointer->buffer.pointer);
+	kfree(obj_list->pointer);
+	kfree(obj_list);
 }
 EXPORT_SYMBOL_GPL(acpi_processor_set_pdc);
 

