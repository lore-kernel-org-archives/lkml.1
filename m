Return-Path: <linux-kernel-owner+w=401wt.eu-S1752940AbYHPTXL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940AbYHPTXL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 15:23:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751959AbYHPTVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 15:21:51 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:11974 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbYHPTVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 15:21:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=jULWMvb6MPagC/k4XFIFJXB7oKMj7tcQyPo2ArLHXd9UEZYs+7gMIdV+bOvYqPz6b9
         nCHl/6V5ZZD03EFuo04rtpskCzu/MrVozRqhXBvjnGikcVH43YJl3wQuZZ2+M+1QSPJ5
         51Lhff2RNRHzxwMpqpkL1dimQErI6Dg8t2Y50=
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de, macro@linux-mips.org,
       linux-kernel@vger.kernel.org
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [PATCH 2/6] x86: apic - unify lapic_resume
Date: Sat, 16 Aug 2008 23:21:51 +0400
Message-Id: <722b5bc0303212ca203cadeedae5ede3e23eccb7.1218914042.git.gorcunov@gmail.com>
X-Mailer: git-send-email 1.6.0.rc1.34.g0fe8c
In-Reply-To: <f87881899957b7aa08b827cdc6b5dd8cf53e4730.1218914042.git.gorcunov@gmail.com>
References: <1218914515-26377-1-git-send-email-gorcunov@gmail.com>
 <f87881899957b7aa08b827cdc6b5dd8cf53e4730.1218914042.git.gorcunov@gmail.com>
In-Reply-To: <f87881899957b7aa08b827cdc6b5dd8cf53e4730.1218914042.git.gorcunov@gmail.com>
References: <f87881899957b7aa08b827cdc6b5dd8cf53e4730.1218914042.git.gorcunov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---
 arch/x86/kernel/apic_32.c |   29 ++++++++++++++++++-----------
 arch/x86/kernel/apic_64.c |   19 +++++++++++++++----
 2 files changed, 33 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index 3131603..3d40213 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -1606,16 +1606,21 @@ static int lapic_resume(struct sys_device *dev)
 
 	local_irq_save(flags);
 
-	/*
-	 * Make sure the APICBASE points to the right address
-	 *
-	 * FIXME! This will be wrong if we ever support suspend on
-	 * SMP! We'll need to do this as part of the CPU restore!
-	 */
-	rdmsr(MSR_IA32_APICBASE, l, h);
-	l &= ~MSR_IA32_APICBASE_BASE;
-	l |= MSR_IA32_APICBASE_ENABLE | mp_lapic_addr;
-	wrmsr(MSR_IA32_APICBASE, l, h);
+#ifdef CONFIG_X86_64
+	if (x2apic)
+		enable_x2apic();
+	else
+#endif
+		/*
+		 * Make sure the APICBASE points to the right address
+		 *
+		 * FIXME! This will be wrong if we ever support suspend on
+		 * SMP! We'll need to do this as part of the CPU restore!
+		 */
+		rdmsr(MSR_IA32_APICBASE, l, h);
+		l &= ~MSR_IA32_APICBASE_BASE;
+		l |= MSR_IA32_APICBASE_ENABLE | mp_lapic_addr;
+		wrmsr(MSR_IA32_APICBASE, l, h);
 
 	apic_write(APIC_LVTERR, ERROR_APIC_VECTOR | APIC_LVT_MASKED);
 	apic_write(APIC_ID, apic_pm_state.apic_id);
@@ -1625,7 +1630,7 @@ static int lapic_resume(struct sys_device *dev)
 	apic_write(APIC_SPIV, apic_pm_state.apic_spiv);
 	apic_write(APIC_LVT0, apic_pm_state.apic_lvt0);
 	apic_write(APIC_LVT1, apic_pm_state.apic_lvt1);
-#ifdef CONFIG_X86_MCE_P4THERMAL
+#if defined(CONFIG_X86_MCE_P4THERMAL) || defined(CONFIG_X86_MCE_INTEL)
 	if (maxlvt >= 5)
 		apic_write(APIC_LVTTHMR, apic_pm_state.apic_thmr);
 #endif
@@ -1639,7 +1644,9 @@ static int lapic_resume(struct sys_device *dev)
 	apic_write(APIC_LVTERR, apic_pm_state.apic_lvterr);
 	apic_write(APIC_ESR, 0);
 	apic_read(APIC_ESR);
+
 	local_irq_restore(flags);
+
 	return 0;
 }
 
diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index d834b75..e542a2d 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -1412,13 +1412,22 @@ static int lapic_resume(struct sys_device *dev)
 	maxlvt = lapic_get_maxlvt();
 
 	local_irq_save(flags);
-	if (!x2apic) {
+
+#ifdef CONFIG_X86_64
+	if (x2apic)
+		enable_x2apic();
+	else
+#endif
+		/*
+		 * Make sure the APICBASE points to the right address
+		 *
+		 * FIXME! This will be wrong if we ever support suspend on
+		 * SMP! We'll need to do this as part of the CPU restore!
+		 */
 		rdmsr(MSR_IA32_APICBASE, l, h);
 		l &= ~MSR_IA32_APICBASE_BASE;
 		l |= MSR_IA32_APICBASE_ENABLE | mp_lapic_addr;
 		wrmsr(MSR_IA32_APICBASE, l, h);
-	} else
-		enable_x2apic();
 
 	apic_write(APIC_LVTERR, ERROR_APIC_VECTOR | APIC_LVT_MASKED);
 	apic_write(APIC_ID, apic_pm_state.apic_id);
@@ -1428,7 +1437,7 @@ static int lapic_resume(struct sys_device *dev)
 	apic_write(APIC_SPIV, apic_pm_state.apic_spiv);
 	apic_write(APIC_LVT0, apic_pm_state.apic_lvt0);
 	apic_write(APIC_LVT1, apic_pm_state.apic_lvt1);
-#ifdef CONFIG_X86_MCE_INTEL
+#if defined(CONFIG_X86_MCE_P4THERMAL) || defined(CONFIG_X86_MCE_INTEL)
 	if (maxlvt >= 5)
 		apic_write(APIC_LVTTHMR, apic_pm_state.apic_thmr);
 #endif
@@ -1442,7 +1451,9 @@ static int lapic_resume(struct sys_device *dev)
 	apic_write(APIC_LVTERR, apic_pm_state.apic_lvterr);
 	apic_write(APIC_ESR, 0);
 	apic_read(APIC_ESR);
+
 	local_irq_restore(flags);
+
 	return 0;
 }
 
-- 
1.6.0.rc1.34.g0fe8c

