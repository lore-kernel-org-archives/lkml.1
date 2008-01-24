Return-Path: <linux-kernel-owner+w=401wt.eu-S1754683AbYAXJ67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683AbYAXJ67 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 04:58:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752883AbYAXJ6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 04:58:50 -0500
Received: from mga02.intel.com ([134.134.136.20]:8272 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752439AbYAXJ6t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 04:58:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,243,1199692800"; 
   d="scan'208";a="329263212"
Subject: [PATCH] ACPI: create proc entry 'power' only if C2 or C3 is
	supported
From: Yi Yang <yi.y.yang@intel.com>
Reply-To: yi.y.yang@intel.com
To: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, lenb@kernel.org,
       acpi-bugzilla@lists.sourceforge.net
In-Reply-To: <1199762486.3551.22.camel@yangyi-dev.bj.intel.com>
References: <1198738022.8950.3.camel@yangyi-dev.bj.intel.com>
	 <1198744900.3640.4.camel@yangyi-dev.bj.intel.com>
	 <1198916553.3806.2.camel@yangyi-dev.bj.intel.com>
	 <1199434602.19185.1.camel@yangyi-dev.bj.intel.com>
	 <1199688961.3551.19.camel@yangyi-dev.bj.intel.com>
	 <1199762486.3551.22.camel@yangyi-dev.bj.intel.com>
Content-Type: text/plain
Organization: Intel
Date: Thu, 24 Jan 2008 08:45:32 +0800
Message-Id: <1201135532.3969.3.camel@yangyi-dev.bj.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: ACPI: Create proc entry 'power' only C2 or C3 is supported
From: Yi Yang <yi.y.yang@intel.com>

ACPI processor idle driver makes sense only if the processor supports
C2 or C3. For legacy C0 and C1, just the original pm_idle is working
, statistics info about promotion, demotion, latency, usage and
duration are empty or 0, so these are misleading, users'll think their
CPUs support C states (C2 or C3), /proc/acpi/processor/CPU*/power
shouldn't exist for this case at all.

This patch fixes this issue, it makes ACPI processor idle driver to create
proc entry only if the processor supports C2 or C3.


Signed-off-by: Yi Yang <yi.y.yang@intel.com>
---
 processor_idle.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

--- a/drivers/acpi/processor_idle.c	2008-01-24 05:34:29.000000000 +0800
+++ b/drivers/acpi/processor_idle.c	2008-01-24 07:04:59.000000000 +0800
@@ -1738,17 +1738,17 @@ int __cpuinit acpi_processor_power_init(
 			pm_idle = acpi_processor_idle;
 		}
 #endif
-	}
 
-	/* 'power' [R] */
-	entry = create_proc_entry(ACPI_PROCESSOR_FILE_POWER,
-				  S_IRUGO, acpi_device_dir(device));
-	if (!entry)
-		return -EIO;
-	else {
-		entry->proc_fops = &acpi_processor_power_fops;
-		entry->data = acpi_driver_data(device);
-		entry->owner = THIS_MODULE;
+		/* 'power' [R] */
+		entry = create_proc_entry(ACPI_PROCESSOR_FILE_POWER,
+					  S_IRUGO, acpi_device_dir(device));
+		if (!entry)
+			return -EIO;
+		else {
+			entry->proc_fops = &acpi_processor_power_fops;
+			entry->data = acpi_driver_data(device);
+			entry->owner = THIS_MODULE;
+		}
 	}
 
 	return 0;
@@ -1763,7 +1763,8 @@ int acpi_processor_power_exit(struct acp
 #endif
 	pr->flags.power_setup_done = 0;
 
-	if (acpi_device_dir(device))
+	if (acpi_device_dir(device) &&
+		((pr->flags.power) && (!boot_option_idle_override)))
 		remove_proc_entry(ACPI_PROCESSOR_FILE_POWER,
 				  acpi_device_dir(device));
 


