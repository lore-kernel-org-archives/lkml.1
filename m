Return-Path: <linux-kernel-owner+w=401wt.eu-S1756302AbZFEIKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756302AbZFEIKA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 04:10:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755362AbZFEIFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 04:05:40 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37486 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755133AbZFEIF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 04:05:26 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org, Philippe Gerum <rpm@xenomai.org>,
       Yi Li <yi.li@analog.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 11/62] Blackfin: merge Philippe's recent ipipe patch
Date: Fri,  5 Jun 2009 04:04:20 -0400
Message-Id: <1244189111-19639-12-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
References: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philippe Gerum <rpm@xenomai.org>

ipipe-2.6.28.9-blackfin-git95aafe6.patch

Singed-off-by: Philippe Gerum <rpm@xenomai.org>
Signed-off-by: Yi Li <yi.li@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/include/asm/ipipe.h         |    4 ++--
 arch/blackfin/kernel/ipipe.c              |    9 ++++++---
 arch/blackfin/mach-common/ints-priority.c |    7 -------
 3 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/arch/blackfin/include/asm/ipipe.h b/arch/blackfin/include/asm/ipipe.h
index 343b563..51d0bf5 100644
--- a/arch/blackfin/include/asm/ipipe.h
+++ b/arch/blackfin/include/asm/ipipe.h
@@ -35,10 +35,10 @@
 #include <asm/atomic.h>
 #include <asm/traps.h>
 
-#define IPIPE_ARCH_STRING     "1.9-00"
+#define IPIPE_ARCH_STRING     "1.9-01"
 #define IPIPE_MAJOR_NUMBER    1
 #define IPIPE_MINOR_NUMBER    9
-#define IPIPE_PATCH_NUMBER    0
+#define IPIPE_PATCH_NUMBER    1
 
 #ifdef CONFIG_SMP
 #error "I-pipe/blackfin: SMP not implemented"
diff --git a/arch/blackfin/kernel/ipipe.c b/arch/blackfin/kernel/ipipe.c
index a5de8d4..5fc4248 100644
--- a/arch/blackfin/kernel/ipipe.c
+++ b/arch/blackfin/kernel/ipipe.c
@@ -167,7 +167,7 @@ int __ipipe_check_root(void)
 void __ipipe_enable_irqdesc(struct ipipe_domain *ipd, unsigned irq)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
-	int prio = desc->ic_prio;
+	int prio = __ipipe_get_irq_priority(irq);
 
 	desc->depth = 0;
 	if (ipd != &ipipe_root &&
@@ -178,8 +178,7 @@ EXPORT_SYMBOL(__ipipe_enable_irqdesc);
 
 void __ipipe_disable_irqdesc(struct ipipe_domain *ipd, unsigned irq)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
-	int prio = desc->ic_prio;
+	int prio = __ipipe_get_irq_priority(irq);
 
 	if (ipd != &ipipe_root &&
 	    atomic_dec_and_test(&__ipipe_irq_lvdepth[prio]))
@@ -310,12 +309,16 @@ int ipipe_trigger_irq(unsigned irq)
 
 asmlinkage void __ipipe_sync_root(void)
 {
+	void (*irq_tail_hook)(void) = (void (*)(void))__ipipe_irq_tail_hook;
 	unsigned long flags;
 
 	BUG_ON(irqs_disabled());
 
 	local_irq_save_hw(flags);
 
+	if (irq_tail_hook)
+		irq_tail_hook();
+
 	clear_thread_flag(TIF_IRQ_SYNC);
 
 	if (ipipe_root_cpudom_var(irqpend_himask) != 0)
diff --git a/arch/blackfin/mach-common/ints-priority.c b/arch/blackfin/mach-common/ints-priority.c
index 3498a90..389c5e8 100644
--- a/arch/blackfin/mach-common/ints-priority.c
+++ b/arch/blackfin/mach-common/ints-priority.c
@@ -1139,13 +1139,6 @@ int __init init_arch_irq(void)
 	bfin_write_SIC_IWR(IWR_DISABLE_ALL);
 #endif
 
-#ifdef CONFIG_IPIPE
-	for (irq = 0; irq < NR_IRQS; irq++) {
-		struct irq_desc *desc = irq_to_desc(irq);
-		desc->ic_prio = __ipipe_get_irq_priority(irq);
-	}
-#endif /* CONFIG_IPIPE */
-
 	return 0;
 }
 
-- 
1.6.3.1

