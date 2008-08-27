Return-Path: <linux-kernel-owner+w=401wt.eu-S1756294AbYH0N1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756294AbYH0N1k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 09:27:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755090AbYH0N1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 09:27:15 -0400
Received: from mx2.suse.de ([195.135.220.15]:39700 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754663AbYH0N1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 09:27:13 -0400
From: Thomas Renninger <trenn@suse.de>
To: ak@linux.intel.com
Cc: bjorn.helgaas@hp.com, linux-kernel@vger.kernel.org, arjan@linux.intel.com,
       linux-acpi@vger.kernel.org, ckornacker@suse.de,
       Thomas Renninger <trenn@suse.de>
Subject: [PATCH 3/3] CPUFREQ: processor.ko: Try to detect old BIOS, not supporting CPU freq on a recent CPU.
Date: Wed, 27 Aug 2008 15:27:11 +0200
Message-Id: <1219843631-26015-4-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <200808210919.07642.bjorn.helgaas@hp.com>
References: <200808210919.07642.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Intel CPUs it is rather common and a good hint that BIOSes which do provide
_PPC func, but not the frequencies itself in _PSS function, are old and need
to be updated for CPU freq support.
Tell the user he has a BIOS/firmware problem.

Signed-off-by: Thomas Renninger <trenn@suse.de>
---
 drivers/acpi/processor_perflib.c |   18 +++++++++++++++---
 1 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/processor_perflib.c b/drivers/acpi/processor_perflib.c
index 0133af4..3a2886f 100644
--- a/drivers/acpi/processor_perflib.c
+++ b/drivers/acpi/processor_perflib.c
@@ -38,6 +38,7 @@
 
 #include <asm/uaccess.h>
 #endif
+#include <asm/cpufeature.h>
 
 #include <acpi/acpi_bus.h>
 #include <acpi/processor.h>
@@ -334,7 +335,6 @@ static int acpi_processor_get_performance_info(struct acpi_processor *pr)
 	acpi_status status = AE_OK;
 	acpi_handle handle = NULL;
 
-
 	if (!pr || !pr->performance || !pr->handle)
 		return -EINVAL;
 
@@ -347,13 +347,25 @@ static int acpi_processor_get_performance_info(struct acpi_processor *pr)
 
 	result = acpi_processor_get_performance_control(pr);
 	if (result)
-		return result;
+		goto update_bios;
 
 	result = acpi_processor_get_performance_states(pr);
 	if (result)
-		return result;
+		goto update_bios;
 
 	return 0;
+
+	/*
+	 * Having _PPC but missing frequencies (_PSS, _PCT) is a very good hint that
+	 * the BIOS is older than the CPU and does not know its frequencies
+	 */
+ update_bios:
+	if (ACPI_SUCCESS(acpi_get_handle(pr->handle, "_PPC", &handle))){
+		if(boot_cpu_has(X86_FEATURE_EST))
+			printk(KERN_WARNING FW_BUG "BIOS needs update for CPU "
+			       "frequency support\n");
+	}
+	return result;
 }
 
 int acpi_processor_notify_smm(struct module *calling_module)
-- 
1.5.4.5

