Return-Path: <linux-kernel-owner+w=401wt.eu-S934400AbXGMGJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934400AbXGMGJo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 02:09:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752254AbXGMGJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 02:09:37 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:32915 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752992AbXGMGJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 02:09:36 -0400
Date: Thu, 12 Jul 2007 23:09:34 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Len Brown <len.brown@intel.com>
cc: linux-kernel@vger.kernel.org, travis@sgi.com, ak@suse.de
Subject: ACPI: Use cpu_physical_id() instead oif arch_cpu_to_apicid
Message-ID: <Pine.LNX.4.64.0707122307460.17074@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

processor_core.c currently tries to determine the apicid by special casing
for IA64 and x86. The desired information is readily available via

	cpu_physical_id()

on IA64, i386 and x86_64.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 drivers/acpi/processor_core.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

Index: linux-2.6.22-rc6-mm1/drivers/acpi/processor_core.c
===================================================================
--- linux-2.6.22-rc6-mm1.orig/drivers/acpi/processor_core.c	2007-07-12 23:02:11.000000000 -0700
+++ linux-2.6.22-rc6-mm1/drivers/acpi/processor_core.c	2007-07-12 23:03:37.000000000 -0700
@@ -417,12 +417,6 @@ static int map_lsapic_id(struct acpi_sub
 	return 0;
 }
 
-#ifdef CONFIG_IA64
-#define arch_cpu_to_apicid 	ia64_cpu_to_sapicid
-#else
-#define arch_cpu_to_apicid 	x86_cpu_to_apicid
-#endif
-
 static int map_madt_entry(u32 acpi_id)
 {
 	unsigned long madt_end, entry;
@@ -496,7 +490,7 @@ static int get_cpu_id(acpi_handle handle
 		return apic_id;
 
 	for (i = 0; i < NR_CPUS; ++i) {
-		if (arch_cpu_to_apicid[i] == apic_id)
+		if (cpu_physical_id(i) == apic_id)
 			return i;
 	}
 	return -1;
