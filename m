Return-Path: <linux-kernel-owner+w=401wt.eu-S1759765AbZDQIlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759765AbZDQIlw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 04:41:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759519AbZDQIl2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 04:41:28 -0400
Received: from mga11.intel.com ([192.55.52.93]:52348 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759448AbZDQIlV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 04:41:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,203,1239001200"; 
   d="scan'208";a="448762656"
From: Weidong Han <weidong.han@intel.com>
To: mingo@elte.hu, dwmw2@infradead.org, allen.m.kay@intel.com,
       fenghua.yu@intel.com
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       Weidong Han <weidong.han@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH 5/5] x86: fix x2apic/intr-remap resume
Date: Fri, 17 Apr 2009 16:42:16 +0800
Message-Id: <1239957736-6161-6-git-send-email-weidong.han@intel.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1239957736-6161-1-git-send-email-weidong.han@intel.com>
References: <1239957736-6161-1-git-send-email-weidong.han@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Interrupt remapping was decoupled from x2apic. Shouldn't check
x2apic before resume interrupt remapping. Otherwise, interrupt
remapping won't be resumed when x2apic is not enabled.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Weidong Han <weidong.han@intel.com>
---
 arch/x86/kernel/apic/apic.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 39b621c..03b591e 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1987,7 +1987,7 @@ static int lapic_resume(struct sys_device *dev)
 		return 0;
 
 	local_irq_save(flags);
-	if (x2apic) {
+	if (intr_remapping_enabled) {
 		ioapic_entries = alloc_ioapic_entries();
 		if (!ioapic_entries) {
 			WARN(1, "Alloc ioapic_entries in lapic resume failed.");
@@ -2003,8 +2003,10 @@ static int lapic_resume(struct sys_device *dev)
 
 		mask_IO_APIC_setup(ioapic_entries);
 		mask_8259A();
-		enable_x2apic();
 	}
+
+	if (x2apic)
+		enable_x2apic();
 #else
 	if (!apic_pm_state.active)
 		return 0;
@@ -2052,10 +2054,12 @@ static int lapic_resume(struct sys_device *dev)
 	apic_read(APIC_ESR);
 
 #ifdef CONFIG_INTR_REMAP
-	if (intr_remapping_enabled)
-		reenable_intr_remapping(EIM_32BIT_APIC_ID);
+	if (intr_remapping_enabled) {
+		if (x2apic)
+			reenable_intr_remapping(EIM_32BIT_APIC_ID);
+		else
+			reenable_intr_remapping(EIM_8BIT_APIC_ID);
 
-	if (x2apic) {
 		unmask_8259A();
 		restore_IO_APIC_setup(ioapic_entries);
 		free_ioapic_entries(ioapic_entries);
@@ -2064,7 +2068,6 @@ static int lapic_resume(struct sys_device *dev)
 
 	local_irq_restore(flags);
 
-
 	return 0;
 }
 
-- 
1.6.0.4

