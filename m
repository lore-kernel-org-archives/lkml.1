Return-Path: <linux-kernel-owner+w=401wt.eu-S1762237AbZDIFji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762237AbZDIFji (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 01:39:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760844AbZDIFhs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 01:37:48 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58072
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1760129AbZDIFhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 01:37:46 -0400
Date: Wed, 08 Apr 2009 22:37:37 -0700 (PDT)
Message-Id: <20090408.223737.30805073.davem@davemloft.net>
To: tj@kernel.org
CC: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/12]: sparc64: Use BUILD_BUG_ON() in trap_init().
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: David S. Miller <davem@davemloft.net>
---
 arch/sparc/kernel/traps_64.c |  171 ++++++++++++++++++++++--------------------
 1 files changed, 91 insertions(+), 80 deletions(-)

diff --git a/arch/sparc/kernel/traps_64.c b/arch/sparc/kernel/traps_64.c
index d073aab..10f7bb9 100644
--- a/arch/sparc/kernel/traps_64.c
+++ b/arch/sparc/kernel/traps_64.c
@@ -2531,86 +2531,97 @@ extern void tsb_config_offsets_are_bolixed_dave(void);
 void __init trap_init(void)
 {
 	/* Compile time sanity check. */
-	if (TI_TASK != offsetof(struct thread_info, task) ||
-	    TI_FLAGS != offsetof(struct thread_info, flags) ||
-	    TI_CPU != offsetof(struct thread_info, cpu) ||
-	    TI_FPSAVED != offsetof(struct thread_info, fpsaved) ||
-	    TI_KSP != offsetof(struct thread_info, ksp) ||
-	    TI_FAULT_ADDR != offsetof(struct thread_info, fault_address) ||
-	    TI_KREGS != offsetof(struct thread_info, kregs) ||
-	    TI_UTRAPS != offsetof(struct thread_info, utraps) ||
-	    TI_EXEC_DOMAIN != offsetof(struct thread_info, exec_domain) ||
-	    TI_REG_WINDOW != offsetof(struct thread_info, reg_window) ||
-	    TI_RWIN_SPTRS != offsetof(struct thread_info, rwbuf_stkptrs) ||
-	    TI_GSR != offsetof(struct thread_info, gsr) ||
-	    TI_XFSR != offsetof(struct thread_info, xfsr) ||
-	    TI_USER_CNTD0 != offsetof(struct thread_info, user_cntd0) ||
-	    TI_USER_CNTD1 != offsetof(struct thread_info, user_cntd1) ||
-	    TI_KERN_CNTD0 != offsetof(struct thread_info, kernel_cntd0) ||
-	    TI_KERN_CNTD1 != offsetof(struct thread_info, kernel_cntd1) ||
-	    TI_PCR != offsetof(struct thread_info, pcr_reg) ||
-	    TI_PRE_COUNT != offsetof(struct thread_info, preempt_count) ||
-	    TI_NEW_CHILD != offsetof(struct thread_info, new_child) ||
-	    TI_SYS_NOERROR != offsetof(struct thread_info, syscall_noerror) ||
-	    TI_RESTART_BLOCK != offsetof(struct thread_info, restart_block) ||
-	    TI_KUNA_REGS != offsetof(struct thread_info, kern_una_regs) ||
-	    TI_KUNA_INSN != offsetof(struct thread_info, kern_una_insn) ||
-	    TI_FPREGS != offsetof(struct thread_info, fpregs) ||
-	    (TI_FPREGS & (64 - 1)))
-		thread_info_offsets_are_bolixed_dave();
-
-	if (TRAP_PER_CPU_THREAD != offsetof(struct trap_per_cpu, thread) ||
-	    (TRAP_PER_CPU_PGD_PADDR !=
-	     offsetof(struct trap_per_cpu, pgd_paddr)) ||
-	    (TRAP_PER_CPU_CPU_MONDO_PA !=
-	     offsetof(struct trap_per_cpu, cpu_mondo_pa)) ||
-	    (TRAP_PER_CPU_DEV_MONDO_PA !=
-	     offsetof(struct trap_per_cpu, dev_mondo_pa)) ||
-	    (TRAP_PER_CPU_RESUM_MONDO_PA !=
-	     offsetof(struct trap_per_cpu, resum_mondo_pa)) ||
-	    (TRAP_PER_CPU_RESUM_KBUF_PA !=
-	     offsetof(struct trap_per_cpu, resum_kernel_buf_pa)) ||
-	    (TRAP_PER_CPU_NONRESUM_MONDO_PA !=
-	     offsetof(struct trap_per_cpu, nonresum_mondo_pa)) ||
-	    (TRAP_PER_CPU_NONRESUM_KBUF_PA !=
-	     offsetof(struct trap_per_cpu, nonresum_kernel_buf_pa)) ||
-	    (TRAP_PER_CPU_FAULT_INFO !=
-	     offsetof(struct trap_per_cpu, fault_info)) ||
-	    (TRAP_PER_CPU_CPU_MONDO_BLOCK_PA !=
-	     offsetof(struct trap_per_cpu, cpu_mondo_block_pa)) ||
-	    (TRAP_PER_CPU_CPU_LIST_PA !=
-	     offsetof(struct trap_per_cpu, cpu_list_pa)) ||
-	    (TRAP_PER_CPU_TSB_HUGE !=
-	     offsetof(struct trap_per_cpu, tsb_huge)) ||
-	    (TRAP_PER_CPU_TSB_HUGE_TEMP !=
-	     offsetof(struct trap_per_cpu, tsb_huge_temp)) ||
-	    (TRAP_PER_CPU_IRQ_WORKLIST_PA !=
-	     offsetof(struct trap_per_cpu, irq_worklist_pa)) ||
-	    (TRAP_PER_CPU_CPU_MONDO_QMASK !=
-	     offsetof(struct trap_per_cpu, cpu_mondo_qmask)) ||
-	    (TRAP_PER_CPU_DEV_MONDO_QMASK !=
-	     offsetof(struct trap_per_cpu, dev_mondo_qmask)) ||
-	    (TRAP_PER_CPU_RESUM_QMASK !=
-	     offsetof(struct trap_per_cpu, resum_qmask)) ||
-	    (TRAP_PER_CPU_NONRESUM_QMASK !=
-	     offsetof(struct trap_per_cpu, nonresum_qmask)) ||
-	    (TRAP_PER_CPU_PER_CPU_BASE !=
-	     offsetof(struct trap_per_cpu, __per_cpu_base)))
-		trap_per_cpu_offsets_are_bolixed_dave();
-
-	if ((TSB_CONFIG_TSB !=
-	     offsetof(struct tsb_config, tsb)) ||
-	    (TSB_CONFIG_RSS_LIMIT !=
-	     offsetof(struct tsb_config, tsb_rss_limit)) ||
-	    (TSB_CONFIG_NENTRIES !=
-	     offsetof(struct tsb_config, tsb_nentries)) ||
-	    (TSB_CONFIG_REG_VAL !=
-	     offsetof(struct tsb_config, tsb_reg_val)) ||
-	    (TSB_CONFIG_MAP_VADDR !=
-	     offsetof(struct tsb_config, tsb_map_vaddr)) ||
-	    (TSB_CONFIG_MAP_PTE !=
-	     offsetof(struct tsb_config, tsb_map_pte)))
-		tsb_config_offsets_are_bolixed_dave();
+	BUILD_BUG_ON(TI_TASK != offsetof(struct thread_info, task) ||
+		     TI_FLAGS != offsetof(struct thread_info, flags) ||
+		     TI_CPU != offsetof(struct thread_info, cpu) ||
+		     TI_FPSAVED != offsetof(struct thread_info, fpsaved) ||
+		     TI_KSP != offsetof(struct thread_info, ksp) ||
+		     TI_FAULT_ADDR != offsetof(struct thread_info,
+					       fault_address) ||
+		     TI_KREGS != offsetof(struct thread_info, kregs) ||
+		     TI_UTRAPS != offsetof(struct thread_info, utraps) ||
+		     TI_EXEC_DOMAIN != offsetof(struct thread_info,
+						exec_domain) ||
+		     TI_REG_WINDOW != offsetof(struct thread_info,
+					       reg_window) ||
+		     TI_RWIN_SPTRS != offsetof(struct thread_info,
+					       rwbuf_stkptrs) ||
+		     TI_GSR != offsetof(struct thread_info, gsr) ||
+		     TI_XFSR != offsetof(struct thread_info, xfsr) ||
+		     TI_USER_CNTD0 != offsetof(struct thread_info,
+					       user_cntd0) ||
+		     TI_USER_CNTD1 != offsetof(struct thread_info,
+					       user_cntd1) ||
+		     TI_KERN_CNTD0 != offsetof(struct thread_info,
+					       kernel_cntd0) ||
+		     TI_KERN_CNTD1 != offsetof(struct thread_info,
+					       kernel_cntd1) ||
+		     TI_PCR != offsetof(struct thread_info, pcr_reg) ||
+		     TI_PRE_COUNT != offsetof(struct thread_info,
+					      preempt_count) ||
+		     TI_NEW_CHILD != offsetof(struct thread_info, new_child) ||
+		     TI_SYS_NOERROR != offsetof(struct thread_info,
+						syscall_noerror) ||
+		     TI_RESTART_BLOCK != offsetof(struct thread_info,
+						  restart_block) ||
+		     TI_KUNA_REGS != offsetof(struct thread_info,
+					      kern_una_regs) ||
+		     TI_KUNA_INSN != offsetof(struct thread_info,
+					      kern_una_insn) ||
+		     TI_FPREGS != offsetof(struct thread_info, fpregs) ||
+		     (TI_FPREGS & (64 - 1)));
+
+	BUILD_BUG_ON(TRAP_PER_CPU_THREAD != offsetof(struct trap_per_cpu,
+						     thread) ||
+		     (TRAP_PER_CPU_PGD_PADDR !=
+		      offsetof(struct trap_per_cpu, pgd_paddr)) ||
+		     (TRAP_PER_CPU_CPU_MONDO_PA !=
+		      offsetof(struct trap_per_cpu, cpu_mondo_pa)) ||
+		     (TRAP_PER_CPU_DEV_MONDO_PA !=
+		      offsetof(struct trap_per_cpu, dev_mondo_pa)) ||
+		     (TRAP_PER_CPU_RESUM_MONDO_PA !=
+		      offsetof(struct trap_per_cpu, resum_mondo_pa)) ||
+		     (TRAP_PER_CPU_RESUM_KBUF_PA !=
+		      offsetof(struct trap_per_cpu, resum_kernel_buf_pa)) ||
+		     (TRAP_PER_CPU_NONRESUM_MONDO_PA !=
+		      offsetof(struct trap_per_cpu, nonresum_mondo_pa)) ||
+		     (TRAP_PER_CPU_NONRESUM_KBUF_PA !=
+		      offsetof(struct trap_per_cpu, nonresum_kernel_buf_pa)) ||
+		     (TRAP_PER_CPU_FAULT_INFO !=
+		      offsetof(struct trap_per_cpu, fault_info)) ||
+		     (TRAP_PER_CPU_CPU_MONDO_BLOCK_PA !=
+		      offsetof(struct trap_per_cpu, cpu_mondo_block_pa)) ||
+		     (TRAP_PER_CPU_CPU_LIST_PA !=
+		      offsetof(struct trap_per_cpu, cpu_list_pa)) ||
+		     (TRAP_PER_CPU_TSB_HUGE !=
+		      offsetof(struct trap_per_cpu, tsb_huge)) ||
+		     (TRAP_PER_CPU_TSB_HUGE_TEMP !=
+		      offsetof(struct trap_per_cpu, tsb_huge_temp)) ||
+		     (TRAP_PER_CPU_IRQ_WORKLIST_PA !=
+		      offsetof(struct trap_per_cpu, irq_worklist_pa)) ||
+		     (TRAP_PER_CPU_CPU_MONDO_QMASK !=
+		      offsetof(struct trap_per_cpu, cpu_mondo_qmask)) ||
+		     (TRAP_PER_CPU_DEV_MONDO_QMASK !=
+		      offsetof(struct trap_per_cpu, dev_mondo_qmask)) ||
+		     (TRAP_PER_CPU_RESUM_QMASK !=
+		      offsetof(struct trap_per_cpu, resum_qmask)) ||
+		     (TRAP_PER_CPU_NONRESUM_QMASK !=
+		      offsetof(struct trap_per_cpu, nonresum_qmask)) ||
+		     (TRAP_PER_CPU_PER_CPU_BASE !=
+		      offsetof(struct trap_per_cpu, __per_cpu_base)));
+
+	BUILD_BUG_ON((TSB_CONFIG_TSB !=
+		      offsetof(struct tsb_config, tsb)) ||
+		     (TSB_CONFIG_RSS_LIMIT !=
+		      offsetof(struct tsb_config, tsb_rss_limit)) ||
+		     (TSB_CONFIG_NENTRIES !=
+		      offsetof(struct tsb_config, tsb_nentries)) ||
+		     (TSB_CONFIG_REG_VAL !=
+		      offsetof(struct tsb_config, tsb_reg_val)) ||
+		     (TSB_CONFIG_MAP_VADDR !=
+		      offsetof(struct tsb_config, tsb_map_vaddr)) ||
+		     (TSB_CONFIG_MAP_PTE !=
+		      offsetof(struct tsb_config, tsb_map_pte)));
 
 	/* Attach to the address space of init_task.  On SMP we
 	 * do this in smp.c:smp_callin for other cpus.
-- 
1.6.2.2

