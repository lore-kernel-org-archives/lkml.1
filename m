Return-Path: <linux-kernel-owner+w=401wt.eu-S1759227AbYHUSFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759227AbYHUSFa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 14:05:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754581AbYHUSEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 14:04:51 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:50420 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754114AbYHUSEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 14:04:49 -0400
X-IronPort-AV: E=Sophos;i="4.32,246,1217822400"; 
   d="scan'208";a="16837601"
From: Alex Nixon <alex.nixon@citrix.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Alex Nixon <alex.nixon@citrix.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 2/7] x86/paravirt:  Add paravirt hook for wbinvd_halt
Date: Thu, 21 Aug 2008 19:04:43 +0100
Message-Id: <1219341888-23191-2-git-send-email-alex.nixon@citrix.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1219341888-23191-1-git-send-email-alex.nixon@citrix.com>
References: <>
 <1219341888-23191-1-git-send-email-alex.nixon@citrix.com>
X-OriginalArrivalTime: 21 Aug 2008 18:04:49.0115 (UTC) FILETIME=[66D942B0:01C903B8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The native case of wb_invd_halt uses inline asm to ensure the compiler doesn't reorder the sequence of instructions, which has the side-effect of skirting around the paravirt hooks for those instructions.  Thus, create a new hook for this case.

Signed-off-by: Alex Nixon <alex.nixon@citrix.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/paravirt.c  |    1 +
 include/asm-x86/paravirt.h  |    6 ++++++
 include/asm-x86/processor.h |    3 ++-
 3 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index 8ffe4d1..66d6d0d 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -299,6 +299,7 @@ struct pv_irq_ops pv_irq_ops = {
 	.restore_fl = native_restore_fl,
 	.irq_disable = native_irq_disable,
 	.irq_enable = native_irq_enable,
+	.wbinvd_halt = native_wbinvd_halt,
 	.safe_halt = native_safe_halt,
 	.halt = native_halt,
 #ifdef CONFIG_X86_64
diff --git a/include/asm-x86/paravirt.h b/include/asm-x86/paravirt.h
index fd922c3..5360f3f 100644
--- a/include/asm-x86/paravirt.h
+++ b/include/asm-x86/paravirt.h
@@ -194,6 +194,7 @@ struct pv_irq_ops {
 	void (*restore_fl)(unsigned long);
 	void (*irq_disable)(void);
 	void (*irq_enable)(void);
+	void (*wbinvd_halt)(void);
 	void (*safe_halt)(void);
 	void (*halt)(void);
 
@@ -716,6 +717,11 @@ static inline void raw_safe_halt(void)
 	PVOP_VCALL0(pv_irq_ops.safe_halt);
 }
 
+static inline void wbinvd_halt(void)
+{
+	PVOP_VCALL0(pv_irq_ops.wbinvd_halt);
+}
+
 static inline void halt(void)
 {
 	PVOP_VCALL0(pv_irq_ops.safe_halt);
diff --git a/include/asm-x86/processor.h b/include/asm-x86/processor.h
index bcfc727..75db315 100644
--- a/include/asm-x86/processor.h
+++ b/include/asm-x86/processor.h
@@ -558,6 +558,7 @@ static inline void load_sp0(struct tss_struct *tss,
 	native_load_sp0(tss, thread);
 }
 
+#define wbinvd_halt native_wbinvd_halt
 #define set_iopl_mask native_set_iopl_mask
 #endif /* CONFIG_PARAVIRT */
 
@@ -733,7 +734,7 @@ extern unsigned long		idle_nomwait;
  *
  * Systems without cache can just go into halt.
  */
-static inline void wbinvd_halt(void)
+static inline void native_wbinvd_halt(void)
 {
 	mb();
 	/* check for clflush to determine if wbinvd is legal */
-- 
1.5.4.3

