Return-Path: <linux-kernel-owner+w=401wt.eu-S1757085AbZINUIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757085AbZINUIZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:08:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757052AbZINUIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:08:22 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:53994 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757014AbZINUIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:08:18 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org, Philippe Gerum <rpm@xenomai.org>
Subject: [PATCH 06/72] Blackfin: fix misnomer of some I-pipe helpers
Date: Mon, 14 Sep 2009 16:07:10 -0400
Message-Id: <1252958896-25150-7-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
References: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philippe Gerum <rpm@xenomai.org>

__ipipe_{stall, unstall}_root_raw() identifiers may leave the reader
under the impression that only the virtual state is affected by these
operations, which is wrong. Pick names following the convention used
throughout the interrupt pipeline code.

Signed-off-by: Philippe Gerum <rpm@xenomai.org>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/include/asm/ipipe.h |    7 ------
 arch/blackfin/kernel/ipipe.c      |   44 ++++++++++++++++--------------------
 arch/blackfin/lib/ins.S           |    4 +-
 3 files changed, 22 insertions(+), 33 deletions(-)

diff --git a/arch/blackfin/include/asm/ipipe.h b/arch/blackfin/include/asm/ipipe.h
index 87ba9ad..4617ba6 100644
--- a/arch/blackfin/include/asm/ipipe.h
+++ b/arch/blackfin/include/asm/ipipe.h
@@ -145,10 +145,6 @@ void __ipipe_handle_irq(unsigned irq, struct pt_regs *regs);
 
 int __ipipe_get_irq_priority(unsigned irq);
 
-void __ipipe_stall_root_raw(void);
-
-void __ipipe_unstall_root_raw(void);
-
 void __ipipe_serial_debug(const char *fmt, ...);
 
 asmlinkage void __ipipe_call_irqtail(unsigned long addr);
@@ -234,9 +230,6 @@ int ipipe_start_irq_thread(unsigned irq, struct irq_desc *desc);
 #define task_hijacked(p)		0
 #define ipipe_trap_notify(t, r)  	0
 
-#define __ipipe_stall_root_raw()	do { } while (0)
-#define __ipipe_unstall_root_raw()	do { } while (0)
-
 #define ipipe_init_irq_threads()		do { } while (0)
 #define ipipe_start_irq_thread(irq, desc)	0
 
diff --git a/arch/blackfin/kernel/ipipe.c b/arch/blackfin/kernel/ipipe.c
index a725677..be4f24e 100644
--- a/arch/blackfin/kernel/ipipe.c
+++ b/arch/blackfin/kernel/ipipe.c
@@ -191,30 +191,6 @@ void __ipipe_disable_irqdesc(struct ipipe_domain *ipd, unsigned irq)
 }
 EXPORT_SYMBOL(__ipipe_disable_irqdesc);
 
-void __ipipe_stall_root_raw(void)
-{
-	/*
-	 * This code is called by the ins{bwl} routines (see
-	 * arch/blackfin/lib/ins.S), which are heavily used by the
-	 * network stack. It masks all interrupts but those handled by
-	 * non-root domains, so that we keep decent network transfer
-	 * rates for Linux without inducing pathological jitter for
-	 * the real-time domain.
-	 */
-	__asm__ __volatile__ ("sti %0;" : : "d"(__ipipe_irq_lvmask));
-
-	__set_bit(IPIPE_STALL_FLAG,
-		  &ipipe_root_cpudom_var(status));
-}
-
-void __ipipe_unstall_root_raw(void)
-{
-	__clear_bit(IPIPE_STALL_FLAG,
-		    &ipipe_root_cpudom_var(status));
-
-	__asm__ __volatile__ ("sti %0;" : : "d"(bfin_irq_flags));
-}
-
 int __ipipe_syscall_root(struct pt_regs *regs)
 {
 	struct ipipe_percpu_domain_data *p;
@@ -344,3 +320,23 @@ void ___ipipe_sync_pipeline(unsigned long syncmask)
 
 	__ipipe_sync_stage(syncmask);
 }
+
+void __ipipe_disable_root_irqs_hw(void)
+{
+	/*
+	 * This code is called by the ins{bwl} routines (see
+	 * arch/blackfin/lib/ins.S), which are heavily used by the
+	 * network stack. It masks all interrupts but those handled by
+	 * non-root domains, so that we keep decent network transfer
+	 * rates for Linux without inducing pathological jitter for
+	 * the real-time domain.
+	 */
+	bfin_sti(__ipipe_irq_lvmask);
+	__set_bit(IPIPE_STALL_FLAG, &ipipe_root_cpudom_var(status));
+}
+
+void __ipipe_enable_root_irqs_hw(void)
+{
+	__clear_bit(IPIPE_STALL_FLAG, &ipipe_root_cpudom_var(status));
+	bfin_sti(bfin_irq_flags);
+}
diff --git a/arch/blackfin/lib/ins.S b/arch/blackfin/lib/ins.S
index 1863a6b..3edbd8d 100644
--- a/arch/blackfin/lib/ins.S
+++ b/arch/blackfin/lib/ins.S
@@ -16,7 +16,7 @@
 	[--sp] = rets; \
 	[--sp] = (P5:0); \
 	sp += -12; \
-	call ___ipipe_stall_root_raw; \
+	call ___ipipe_disable_root_irqs_hw; \
 	sp += 12; \
 	(P5:0) = [sp++];
 # define CLI_INNER_NOP
@@ -28,7 +28,7 @@
 #ifdef CONFIG_IPIPE
 # define DO_STI \
 	sp += -12; \
-	call ___ipipe_unstall_root_raw; \
+	call ___ipipe_enable_root_irqs_hw; \
 	sp += 12; \
 2:	rets = [sp++];
 #else
-- 
1.6.4.2

