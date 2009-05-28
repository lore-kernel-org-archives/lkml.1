Return-Path: <linux-kernel-owner+w=401wt.eu-S1761583AbZE1IBl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761583AbZE1IBl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 04:01:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756667AbZE1IBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 04:01:33 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:34442 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759318AbZE1IBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 04:01:32 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: mingo@elte.hu
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 1/3] x86: apic, restore irqs on fail paths
Date: Thu, 28 May 2009 09:54:47 +0200
Message-Id: <1243497289-18591-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lapic_resume forgets to restore interrupts on fail paths.
Fix that.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/apic/apic.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 07cffc1..fc65544 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -2029,7 +2029,7 @@ static int lapic_resume(struct sys_device *dev)
 	unsigned int l, h;
 	unsigned long flags;
 	int maxlvt;
-	int ret;
+	int ret = 0;
 	struct IO_APIC_route_entry **ioapic_entries = NULL;
 
 	if (!apic_pm_state.active)
@@ -2040,14 +2040,15 @@ static int lapic_resume(struct sys_device *dev)
 		ioapic_entries = alloc_ioapic_entries();
 		if (!ioapic_entries) {
 			WARN(1, "Alloc ioapic_entries in lapic resume failed.");
-			return -ENOMEM;
+			ret = -ENOMEM;
+			goto restore;
 		}
 
 		ret = save_IO_APIC_setup(ioapic_entries);
 		if (ret) {
 			WARN(1, "Saving IO-APIC state failed: %d\n", ret);
 			free_ioapic_entries(ioapic_entries);
-			return ret;
+			goto restore;
 		}
 
 		mask_IO_APIC_setup(ioapic_entries);
@@ -2099,10 +2100,10 @@ static int lapic_resume(struct sys_device *dev)
 		restore_IO_APIC_setup(ioapic_entries);
 		free_ioapic_entries(ioapic_entries);
 	}
-
+restore:
 	local_irq_restore(flags);
 
-	return 0;
+	return ret;
 }
 
 /*
-- 
1.6.3

