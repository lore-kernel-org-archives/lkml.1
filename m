Return-Path: <linux-kernel-owner+w=401wt.eu-S1750772AbZDHKqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750772AbZDHKqk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 06:46:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761499AbZDHKpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 06:45:46 -0400
Received: from mga01.intel.com ([192.55.52.88]:4289 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760231AbZDHKpp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 06:45:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,344,1235980800"; 
   d="scan'208";a="446095898"
From: "Han, Weidong" <weidong.han@intel.com>
To: Ingo Molnar <mingo@elte.hu>, David Woodhouse <dwmw2@infradead.org>,
       "Kay, Allen M" <allen.m.kay@intel.com>,
       "Yu, Fenghua" <fenghua.yu@intel.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed, 8 Apr 2009 18:44:37 +0800
Subject: [PATCH 2/2] Fix interrup remapping resume
Thread-Topic: [PATCH 2/2] Fix interrup remapping resume
Thread-Index: Acm4NwNJo42Oh6dCS+ySvoPKIdjwZw==
Message-ID: <715D42877B251141A38726ABF5CABF2C01A2F7CAF9@pdsmsx503.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Interrupt remapping is decoupled from x2apic. Shouldn't check x2apic
before resume interrupt remapping. Otherwise, interrupt remapping won't
be resumed when x2apic is not enabled.

Signed-off-by: Weidong Han <weidong.han@intel.com>
---
 arch/x86/kernel/apic/apic.c |   47 ++++++++++++++++++++++---------------------
 1 files changed, 24 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 30c857c..537b145 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1994,24 +1994,24 @@ static int lapic_resume(struct sys_device *dev)
 		return 0;
 
 	local_irq_save(flags);
-	if (x2apic) {
-		ioapic_entries = alloc_ioapic_entries();
-		if (!ioapic_entries) {
-			WARN(1, "Alloc ioapic_entries in lapic resume failed.");
-			return -ENOMEM;
-		}
+	ioapic_entries = alloc_ioapic_entries();
+	if (!ioapic_entries) {
+		WARN(1, "Alloc ioapic_entries in lapic resume failed.");
+		return -ENOMEM;
+	}
 
-		ret = save_IO_APIC_setup(ioapic_entries);
-		if (ret) {
-			WARN(1, "Saving IO-APIC state failed: %d\n", ret);
-			free_ioapic_entries(ioapic_entries);
-			return ret;
-		}
+	ret = save_IO_APIC_setup(ioapic_entries);
+	if (ret) {
+		WARN(1, "Saving IO-APIC state failed: %d\n", ret);
+		free_ioapic_entries(ioapic_entries);
+		return ret;
+	}
+
+	mask_IO_APIC_setup(ioapic_entries);
+	mask_8259A();
 
-		mask_IO_APIC_setup(ioapic_entries);
-		mask_8259A();
+	if (x2apic)
 		enable_x2apic();
-	}
 #else
 	if (!apic_pm_state.active)
 		return 0;
@@ -2059,19 +2059,20 @@ static int lapic_resume(struct sys_device *dev)
 	apic_read(APIC_ESR);
 
 #ifdef CONFIG_INTR_REMAP
-	if (intr_remapping_enabled)
-		reenable_intr_remapping(EIM_32BIT_APIC_ID);
-
-	if (x2apic) {
-		unmask_8259A();
-		restore_IO_APIC_setup(ioapic_entries);
-		free_ioapic_entries(ioapic_entries);
+	if (intr_remapping_enabled) {
+		if (x2apic)
+			reenable_intr_remapping(EIM_32BIT_APIC_ID);
+		else
+			reenable_intr_remapping(EIM_8BIT_APIC_ID);
 	}
+
+	unmask_8259A();
+	restore_IO_APIC_setup(ioapic_entries);
+	free_ioapic_entries(ioapic_entries);
 #endif
 
 	local_irq_restore(flags);
 
-
 	return 0;
 }
 
-- 
1.6.0.4
