Return-Path: <linux-kernel-owner+w=401wt.eu-S1762123AbZDQOw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762123AbZDQOw2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 10:52:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761916AbZDQOvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 10:51:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:40389 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761663AbZDQOvP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 10:51:15 -0400
Date: Fri, 17 Apr 2009 14:49:38 GMT
From: tip-bot for Weidong Han <weidong.han@intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       suresh.b.siddha@intel.com, weidong.han@intel.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       weidong.han@intel.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1239957736-6161-6-git-send-email-weidong.han@intel.com>
References: <1239957736-6161-6-git-send-email-weidong.han@intel.com>
Subject: [tip:x86/apic] x86, intr-remap: fix x2apic/intr-remap resume
Message-ID: <tip-752b065ceacda418a1f2c956353fd7b1d55020ea@git.kernel.org>
Git-Commit-ID: 752b065ceacda418a1f2c956353fd7b1d55020ea
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 17 Apr 2009 14:49:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  752b065ceacda418a1f2c956353fd7b1d55020ea
Gitweb:     http://git.kernel.org/tip/752b065ceacda418a1f2c956353fd7b1d55020ea
Author:     Weidong Han <weidong.han@intel.com>
AuthorDate: Fri, 17 Apr 2009 16:42:16 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 17 Apr 2009 16:23:46 +0200

x86, intr-remap: fix x2apic/intr-remap resume

Interrupt remapping was decoupled from x2apic. Shouldn't check
x2apic before resume interrupt remapping. Otherwise, interrupt
remapping won't be resumed when x2apic is not enabled.

[ Impact: fix potential intr-remap resume hang on !x2apic ]

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Weidong Han <weidong.han@intel.com>
Cc: iommu@lists.linux-foundation.org
Cc: dwmw2@infradead.org
Cc: allen.m.kay@intel.com
Cc: fenghua.yu@intel.com
LKML-Reference: <1239957736-6161-6-git-send-email-weidong.han@intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/apic/apic.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 0cf1eea..7b41a32 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -2032,7 +2032,7 @@ static int lapic_resume(struct sys_device *dev)
 		return 0;
 
 	local_irq_save(flags);
-	if (x2apic) {
+	if (intr_remapping_enabled) {
 		ioapic_entries = alloc_ioapic_entries();
 		if (!ioapic_entries) {
 			WARN(1, "Alloc ioapic_entries in lapic resume failed.");
@@ -2048,8 +2048,10 @@ static int lapic_resume(struct sys_device *dev)
 
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
@@ -2097,10 +2099,12 @@ static int lapic_resume(struct sys_device *dev)
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
@@ -2109,7 +2113,6 @@ static int lapic_resume(struct sys_device *dev)
 
 	local_irq_restore(flags);
 
-
 	return 0;
 }
 
