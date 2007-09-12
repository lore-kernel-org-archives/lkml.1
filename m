Return-Path: <linux-kernel-owner+w=401wt.eu-S933877AbXILCA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933877AbXILCA6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 22:00:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933106AbXILB5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 21:57:10 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:48665 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760895AbXILB4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 21:56:48 -0400
Message-Id: <20070912015646.938985912@sgi.com>
References: <20070912015644.927677070@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 11 Sep 2007 18:56:51 -0700
From: travis@sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <ak@suse.de>, Christoph Lameter <clameter@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, sparclinux@vger.kernel.org
Subject: [PATCH 07/10] x86: acpi-use-cpu_physical_id (v3)
Content-Disposition: inline; filename=acpi-use-cpu_physical_id
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is from an earlier message from Christoph Lameter:

    processor_core.c currently tries to determine the apicid by special casing
    for IA64 and x86. The desired information is readily available via

	    cpu_physical_id()

    on IA64, i386 and x86_64.

    Signed-off-by: Christoph Lameter <clameter@sgi.com>

Additionally, boot_cpu_id needed to be exported to fix compile errors in
dma code when !CONFIG_SMP.

Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86_64/kernel/mpparse.c  |    2 ++
 drivers/acpi/processor_core.c |    8 +-------
 2 files changed, 3 insertions(+), 7 deletions(-)

--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -419,12 +419,6 @@
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
@@ -498,7 +492,7 @@
 		return apic_id;
 
 	for (i = 0; i < NR_CPUS; ++i) {
-		if (arch_cpu_to_apicid[i] == apic_id)
+		if (cpu_physical_id(i) == apic_id)
 			return i;
 	}
 	return -1;
--- a/arch/x86_64/kernel/mpparse.c
+++ b/arch/x86_64/kernel/mpparse.c
@@ -57,6 +57,8 @@
 
 /* Processor that is doing the boot up */
 unsigned int boot_cpu_id = -1U;
+EXPORT_SYMBOL(boot_cpu_id);
+
 /* Internal processor count */
 unsigned int num_processors __cpuinitdata = 0;
 

-- 
