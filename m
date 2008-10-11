Return-Path: <linux-kernel-owner+w=401wt.eu-S1763052AbYJKGwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763052AbYJKGwh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 02:52:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756836AbYJKGjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 02:39:19 -0400
Received: from vms046pub.verizon.net ([206.46.252.46]:45163 "EHLO
	vms046pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394AbYJKGhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 02:37:09 -0400
Date: Sat, 11 Oct 2008 02:35:46 -0400
From: Len Brown <lenb@kernel.org>
Subject: [PATCH 26/85] ACPI: cpufreq, processor: Detect old BIOS,
 not supporting CPU freq on a recent CPU.
In-reply-to: <1223707005-26864-1-git-send-email-lenb@kernel.org>
In-reply-to: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Thomas Renninger <trenn@suse.de>, Andi Kleen <ak@linux.intel.com>,
       Len Brown <len.brown@intel.com>
Message-id: <910dfae298f7b3dae0e9a52736182a3b0559ca35.1223706853.git.len.brown@intel.com>
Organization: Intel Open Source Technology Center
X-Mailer: git-send-email 1.6.0.2.307.gc427
References: <1223707005-26864-1-git-send-email-lenb@kernel.org>
References: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Renninger <trenn@suse.de>

On Intel CPUs it is rather common and a good hint that BIOSes which do provide
_PPC func, but not the frequencies itself in _PSS function, are old and need
to be updated for CPU freq support.

Tell the user/vendor he has a BIOS/firmware problem.
Make use of FW_BUG interface to give vendors and users the ability to
automatically check with (or let linuxfirmwarekit do that):
dmesg |grep "Firmware Bug"

Signed-off-by: Thomas Renninger <trenn@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/processor_perflib.c |   18 +++++++++++++++---
 1 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/processor_perflib.c b/drivers/acpi/processor_perflib.c
index 80c251e..242f814 100644
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
1.5.5.1

