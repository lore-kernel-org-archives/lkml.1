Return-Path: <linux-kernel-owner+w=401wt.eu-S1765998AbXGOQRp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765998AbXGOQRp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 12:17:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762716AbXGOQFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 12:05:42 -0400
Received: from www.osadl.org ([213.239.205.134]:42630 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762326AbXGOQFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 12:05:22 -0400
Message-Id: <20070715155542.157804851@inhelltoy.tec.linutronix.de>
References: <20070715155510.341941668@inhelltoy.tec.linutronix.de>
User-Agent: quilt/0.46-1
Date: Sun, 15 Jul 2007 16:11:15 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@suse.de>, Chris Wright <chrisw@sous-sol.org>
Subject: [patch-mm 33/33] i386/x8664: cleanup the shared hpet code
Content-Disposition: inline; filename=i386-hpet-sharing-optimize.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove hpet_readl/writel from vsyscall.h, where it does not belong
anyway. Use the hpet code itself.

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>

---
 arch/i386/kernel/hpet.c       |    6 +-----
 include/asm-i386/hpet.h       |    2 ++
 include/asm-x86_64/vsyscall.h |    3 ---
 3 files changed, 3 insertions(+), 8 deletions(-)

Index: linux-2.6.22-rc6-mm/include/asm-i386/hpet.h
===================================================================
--- linux-2.6.22-rc6-mm.orig/include/asm-i386/hpet.h	2007-07-15 17:48:10.000000000 +0200
+++ linux-2.6.22-rc6-mm/include/asm-i386/hpet.h	2007-07-15 17:48:24.000000000 +0200
@@ -66,6 +66,7 @@
 extern unsigned long hpet_address;
 extern int is_hpet_enabled(void);
 extern int hpet_enable(void);
+extern unsigned long hpet_readl(unsigned long a);
 
 #ifdef CONFIG_HPET_EMULATE_RTC
 
@@ -85,6 +86,7 @@ extern irqreturn_t hpet_rtc_interrupt(in
 #else
 
 static inline int hpet_enable(void) { return 0; }
+static inline unsigned long hpet_readl(unsigned long a) { return 0; }
 
 #endif /* CONFIG_HPET_TIMER */
 #endif /* _I386_HPET_H */
Index: linux-2.6.22-rc6-mm/include/asm-x86_64/vsyscall.h
===================================================================
--- linux-2.6.22-rc6-mm.orig/include/asm-x86_64/vsyscall.h	2007-07-15 17:48:10.000000000 +0200
+++ linux-2.6.22-rc6-mm/include/asm-x86_64/vsyscall.h	2007-07-15 17:48:24.000000000 +0200
@@ -29,9 +29,6 @@ enum vsyscall_num {
 #define VGETCPU_RDTSCP	1
 #define VGETCPU_LSL	2
 
-#define hpet_readl(a)           readl((const void __iomem *)fix_to_virt(FIX_HPET_BASE) + a)
-#define hpet_writel(d,a)        writel(d, (void __iomem *)fix_to_virt(FIX_HPET_BASE) + a)
-
 extern int __vgetcpu_mode;
 extern volatile unsigned long __jiffies;
 
Index: linux-2.6.22-rc6-mm/arch/i386/kernel/hpet.c
===================================================================
--- linux-2.6.22-rc6-mm.orig/arch/i386/kernel/hpet.c	2007-07-15 17:48:10.000000000 +0200
+++ linux-2.6.22-rc6-mm/arch/i386/kernel/hpet.c	2007-07-15 17:48:24.000000000 +0200
@@ -24,11 +24,7 @@
 unsigned long hpet_address;
 static void __iomem *hpet_virt_address;
 
-/* Temporary hack. Cleanup after x86_64 clock events conversion */
-#undef hpet_readl
-#undef hpet_writel
-
-static inline unsigned long hpet_readl(unsigned long a)
+unsigned long hpet_readl(unsigned long a)
 {
 	return readl(hpet_virt_address + a);
 }

-- 

