Return-Path: <linux-kernel-owner+w=401wt.eu-S1755739Ab0ATHGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755739Ab0ATHGx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 02:06:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755699Ab0ATHGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 02:06:38 -0500
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:38600 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324Ab0ATHGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 02:06:36 -0500
Subject: [PATCH 2/2] ACPI: processor: only evaluate _PDC once per processor
To: lenb@kernel.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Date: Wed, 20 Jan 2010 00:06:35 -0700
Message-ID: <20100120070635.19777.51848.stgit@bob.kio>
In-Reply-To: <20100120070403.19777.31978.stgit@bob.kio>
References: <20100120070403.19777.31978.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we evaluate _PDC in the early path, we do not want to evaluate
it again when the processor driver is loaded.

Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/acpi/processor_pdc.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/processor_pdc.c b/drivers/acpi/processor_pdc.c
index 2944e7d..54f0214 100644
--- a/drivers/acpi/processor_pdc.c
+++ b/drivers/acpi/processor_pdc.c
@@ -125,6 +125,8 @@ acpi_processor_eval_pdc(acpi_handle handle, struct acpi_object_list *pdc_in)
 	return status;
 }
 
+static int early_pdc_done;
+
 void acpi_processor_set_pdc(acpi_handle handle)
 {
 	struct acpi_object_list *obj_list;
@@ -132,6 +134,9 @@ void acpi_processor_set_pdc(acpi_handle handle)
 	if (arch_has_acpi_pdc() == false)
 		return;
 
+	if (early_pdc_done)
+		return;
+
 	obj_list = acpi_processor_alloc_pdc();
 	if (!obj_list)
 		return;
@@ -199,4 +204,6 @@ void acpi_early_processor_set_pdc(void)
 	acpi_walk_namespace(ACPI_TYPE_PROCESSOR, ACPI_ROOT_OBJECT,
 			    ACPI_UINT32_MAX,
 			    early_init_pdc, NULL, NULL, NULL);
+
+	early_pdc_done = 1;
 }

