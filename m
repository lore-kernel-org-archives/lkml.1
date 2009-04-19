Return-Path: <linux-kernel-owner+w=401wt.eu-S1760088AbZDSI1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760088AbZDSI1n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 04:27:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757445AbZDSI02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 04:26:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:55383 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757342AbZDSI00 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 04:26:26 -0400
Date: Sun, 19 Apr 2009 08:25:39 GMT
From: tip-bot for Weidong Han <weidong.han@intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       weidong.han@intel.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
       David.Woodhouse@intel.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       weidong.han@intel.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
       David.Woodhouse@intel.com, mingo@elte.hu
In-Reply-To: <1239957736-6161-6-git-send-email-weidong.han@intel.com>
References: <1239957736-6161-6-git-send-email-weidong.han@intel.com>
Subject: [tip:x86/apic] x86, intr-remap: fix x2apic/intr-remap resume
Message-ID: <tip-9a2755c3569e4db92bd9b1daadeddb4045b0cccd@git.kernel.org>
Git-Commit-ID: 9a2755c3569e4db92bd9b1daadeddb4045b0cccd
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 19 Apr 2009 08:25:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9a2755c3569e4db92bd9b1daadeddb4045b0cccd
Gitweb:     http://git.kernel.org/tip/9a2755c3569e4db92bd9b1daadeddb4045b0cccd
Author:     Weidong Han <weidong.han@intel.com>
AuthorDate: Fri, 17 Apr 2009 16:42:16 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 19 Apr 2009 10:22:05 +0200

x86, intr-remap: fix x2apic/intr-remap resume

Interrupt remapping was decoupled from x2apic. Shouldn't check
x2apic before resume interrupt remapping. Otherwise, interrupt
remapping won't be resumed when x2apic is not enabled.

[ Impact: fix potential intr-remap resume hang on !x2apic ]

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Weidong Han <weidong.han@intel.com>
Acked-by: David Woodhouse <David.Woodhouse@intel.com>
Cc: iommu@lists.linux-foundation.org
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
 
