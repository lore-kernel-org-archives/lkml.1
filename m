Return-Path: <linux-kernel-owner+w=401wt.eu-S1753394AbYKRJFQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394AbYKRJFQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 04:05:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752843AbYKRJEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 04:04:05 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:41962 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbYKRJDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 04:03:52 -0500
X-IronPort-AV: E=Sophos;i="4.33,624,1220241600"; 
   d="scan'208";a="62693727"
From: Bryan Wu <cooloney@kernel.org>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org, mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, Graf Yang <graf.yang@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 5/5] Blackfin arch: SMP supporting patchset: some other misc code
Date: Tue, 18 Nov 2008 17:05:08 +0800
Message-Id: <1226999108-13839-6-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1226999108-13839-1-git-send-email-cooloney@kernel.org>
References: <1226999108-13839-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Graf Yang <graf.yang@analog.com>

Blackfin dual core BF561 processor can support SMP like features.
https://docs.blackfin.uclinux.org/doku.php?id=linux-kernel:smp-like

In this patch, we provide SMP extend to some other misc code

Singed-off-by: Graf Yang <graf.yang@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 arch/blackfin/Kconfig                           |   32 +++++++++++++++++++++-
 arch/blackfin/kernel/vmlinux.lds.S              |    4 +-
 arch/blackfin/mach-bf518/include/mach/mem_map.h |   15 ++++++++++
 arch/blackfin/mach-bf527/include/mach/mem_map.h |   15 ++++++++++
 arch/blackfin/mach-bf533/include/mach/mem_map.h |   15 ++++++++++
 arch/blackfin/mach-bf537/include/mach/mem_map.h |   15 ++++++++++
 arch/blackfin/mach-bf538/include/mach/mem_map.h |   15 ++++++++++
 arch/blackfin/mach-bf548/include/mach/mem_map.h |   15 ++++++++++
 8 files changed, 122 insertions(+), 4 deletions(-)

diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index 004c06c..7fc8a51 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -200,6 +200,32 @@ config BF561
 
 endchoice
 
+config SMP
+	depends on BF561
+	bool "Symmetric multi-processing support"
+	---help---
+	  This enables support for systems with more than one CPU,
+	  like the dual core BF561. If you have a system with only one
+	  CPU, say N. If you have a system with more than one CPU, say Y.
+
+	  If you don't know what to do here, say N.
+
+config NR_CPUS
+	int
+	depends on SMP
+	default 2 if BF561
+
+config IRQ_PER_CPU
+	bool
+	depends on SMP
+	default y
+
+config TICK_SOURCE_SYSTMR0
+	bool
+	select BFIN_GPTIMERS
+	depends on SMP
+	default y
+
 config BF_REV_MIN
 	int
 	default 0 if (BF51x || BF52x || BF54x)
@@ -502,6 +528,7 @@ source kernel/Kconfig.hz
 
 config GENERIC_TIME
 	bool "Generic time"
+	depends on !SMP
 	default y
 
 config GENERIC_CLOCKEVENTS
@@ -576,6 +603,7 @@ endmenu
 
 
 menu "Blackfin Kernel Optimizations"
+	depends on !SMP
 
 comment "Memory Optimizations"
 
@@ -738,7 +766,6 @@ config BFIN_INS_LOWOVERHEAD
 
 endmenu
 
-
 choice
 	prompt "Kernel executes from"
 	help
@@ -804,7 +831,8 @@ config BFIN_ICACHE_LOCK
 choice
 	prompt "Policy"
 	depends on BFIN_DCACHE
-	default BFIN_WB
+	default BFIN_WB if !SMP
+	default BFIN_WT if SMP
 config BFIN_WB
 	bool "Write back"
 	help
diff --git a/arch/blackfin/kernel/vmlinux.lds.S b/arch/blackfin/kernel/vmlinux.lds.S
index 7d12c66..2a48535 100644
--- a/arch/blackfin/kernel/vmlinux.lds.S
+++ b/arch/blackfin/kernel/vmlinux.lds.S
@@ -109,7 +109,7 @@ SECTIONS
 #endif
 
 		DATA_DATA
-		*(.data.*)
+		*(.data)
 		CONSTRUCTORS
 
 		/* make sure the init_task is aligned to the
@@ -161,6 +161,7 @@ SECTIONS
 		*(.con_initcall.init)
 		___con_initcall_end = .;
 	}
+	PERCPU(4)
 	SECURITY_INIT
 	.init.ramfs :
 	{
@@ -236,7 +237,6 @@ SECTIONS
 		. = ALIGN(4);
 		__ebss_l2 = .;
 	}
-
 	/* Force trailing alignment of our init section so that when we
 	 * free our init memory, we don't leave behind a partial page.
 	 */
diff --git a/arch/blackfin/mach-bf518/include/mach/mem_map.h b/arch/blackfin/mach-bf518/include/mach/mem_map.h
index 10f678f..ac95d33 100644
--- a/arch/blackfin/mach-bf518/include/mach/mem_map.h
+++ b/arch/blackfin/mach-bf518/include/mach/mem_map.h
@@ -99,4 +99,19 @@
 #define L1_SCRATCH_START	0xFFB00000
 #define L1_SCRATCH_LENGTH	0x1000
 
+#define get_l1_scratch_start_cpu(cpu)		L1_SCRATCH_START
+#define get_l1_code_start_cpu(cpu)		L1_CODE_START
+#define get_l1_data_a_start_cpu(cpu)		L1_DATA_A_START
+#define get_l1_data_b_start_cpu(cpu)		L1_DATA_B_START
+#define get_l1_scratch_start()			L1_SCRATCH_START
+#define get_l1_code_start()			L1_CODE_START
+#define get_l1_data_a_start()			L1_DATA_A_START
+#define get_l1_data_b_start()			L1_DATA_B_START
+
+#define GET_PDA_SAFE(preg)		\
+	preg.l = _cpu_pda;		\
+	preg.h = _cpu_pda;
+
+#define GET_PDA(preg, dreg)	GET_PDA_SAFE(preg)
+
 #endif				/* _MEM_MAP_518_H_ */
diff --git a/arch/blackfin/mach-bf527/include/mach/mem_map.h b/arch/blackfin/mach-bf527/include/mach/mem_map.h
index ef46dc9..bd7fe0f 100644
--- a/arch/blackfin/mach-bf527/include/mach/mem_map.h
+++ b/arch/blackfin/mach-bf527/include/mach/mem_map.h
@@ -99,4 +99,19 @@
 #define L1_SCRATCH_START	0xFFB00000
 #define L1_SCRATCH_LENGTH	0x1000
 
+#define get_l1_scratch_start_cpu(cpu)		L1_SCRATCH_START
+#define get_l1_code_start_cpu(cpu)		L1_CODE_START
+#define get_l1_data_a_start_cpu(cpu)		L1_DATA_A_START
+#define get_l1_data_b_start_cpu(cpu)		L1_DATA_B_START
+#define get_l1_scratch_start()			L1_SCRATCH_START
+#define get_l1_code_start()			L1_CODE_START
+#define get_l1_data_a_start()			L1_DATA_A_START
+#define get_l1_data_b_start()			L1_DATA_B_START
+
+#define GET_PDA_SAFE(preg)		\
+	preg.l = _cpu_pda;		\
+	preg.h = _cpu_pda;
+
+#define GET_PDA(preg, dreg)	GET_PDA_SAFE(preg)
+
 #endif				/* _MEM_MAP_527_H_ */
diff --git a/arch/blackfin/mach-bf533/include/mach/mem_map.h b/arch/blackfin/mach-bf533/include/mach/mem_map.h
index 581fc6e..d5eaef2 100644
--- a/arch/blackfin/mach-bf533/include/mach/mem_map.h
+++ b/arch/blackfin/mach-bf533/include/mach/mem_map.h
@@ -168,4 +168,19 @@
 #define L1_SCRATCH_START	0xFFB00000
 #define L1_SCRATCH_LENGTH	0x1000
 
+#define get_l1_scratch_start_cpu(cpu)		L1_SCRATCH_START
+#define get_l1_code_start_cpu(cpu)		L1_CODE_START
+#define get_l1_data_a_start_cpu(cpu)		L1_DATA_A_START
+#define get_l1_data_b_start_cpu(cpu)		L1_DATA_B_START
+#define get_l1_scratch_start()			L1_SCRATCH_START
+#define get_l1_code_start()			L1_CODE_START
+#define get_l1_data_a_start()			L1_DATA_A_START
+#define get_l1_data_b_start()			L1_DATA_B_START
+
+#define GET_PDA_SAFE(preg)		\
+	preg.l = _cpu_pda;		\
+	preg.h = _cpu_pda;
+
+#define GET_PDA(preg, dreg)	GET_PDA_SAFE(preg)
+
 #endif				/* _MEM_MAP_533_H_ */
diff --git a/arch/blackfin/mach-bf537/include/mach/mem_map.h b/arch/blackfin/mach-bf537/include/mach/mem_map.h
index 5078b66..be4de76 100644
--- a/arch/blackfin/mach-bf537/include/mach/mem_map.h
+++ b/arch/blackfin/mach-bf537/include/mach/mem_map.h
@@ -176,4 +176,19 @@
 #define L1_SCRATCH_START	0xFFB00000
 #define L1_SCRATCH_LENGTH	0x1000
 
+#define get_l1_scratch_start_cpu(cpu)		L1_SCRATCH_START
+#define get_l1_code_start_cpu(cpu)		L1_CODE_START
+#define get_l1_data_a_start_cpu(cpu)		L1_DATA_A_START
+#define get_l1_data_b_start_cpu(cpu)		L1_DATA_B_START
+#define get_l1_scratch_start()			L1_SCRATCH_START
+#define get_l1_code_start()			L1_CODE_START
+#define get_l1_data_a_start()			L1_DATA_A_START
+#define get_l1_data_b_start()			L1_DATA_B_START
+
+#define GET_PDA_SAFE(preg)		\
+	preg.l = _cpu_pda;		\
+	preg.h = _cpu_pda;
+
+#define GET_PDA(preg, dreg)	GET_PDA_SAFE(preg)
+
 #endif				/* _MEM_MAP_537_H_ */
diff --git a/arch/blackfin/mach-bf538/include/mach/mem_map.h b/arch/blackfin/mach-bf538/include/mach/mem_map.h
index d65d430..c134057 100644
--- a/arch/blackfin/mach-bf538/include/mach/mem_map.h
+++ b/arch/blackfin/mach-bf538/include/mach/mem_map.h
@@ -104,4 +104,19 @@
 #define L1_SCRATCH_START	0xFFB00000
 #define L1_SCRATCH_LENGTH	0x1000
 
+#define get_l1_scratch_start_cpu(cpu)		L1_SCRATCH_START
+#define get_l1_code_start_cpu(cpu)		L1_CODE_START
+#define get_l1_data_a_start_cpu(cpu)		L1_DATA_A_START
+#define get_l1_data_b_start_cpu(cpu)		L1_DATA_B_START
+#define get_l1_scratch_start()			L1_SCRATCH_START
+#define get_l1_code_start()			L1_CODE_START
+#define get_l1_data_a_start()			L1_DATA_A_START
+#define get_l1_data_b_start()			L1_DATA_B_START
+
+#define GET_PDA_SAFE(preg)		\
+	preg.l = _cpu_pda;		\
+	preg.h = _cpu_pda;
+
+#define GET_PDA(preg, dreg)	GET_PDA_SAFE(preg)
+
 #endif				/* _MEM_MAP_538_H_ */
diff --git a/arch/blackfin/mach-bf548/include/mach/mem_map.h b/arch/blackfin/mach-bf548/include/mach/mem_map.h
index a222842..361eb0e 100644
--- a/arch/blackfin/mach-bf548/include/mach/mem_map.h
+++ b/arch/blackfin/mach-bf548/include/mach/mem_map.h
@@ -108,4 +108,19 @@
 #define L1_SCRATCH_START	0xFFB00000
 #define L1_SCRATCH_LENGTH	0x1000
 
+#define get_l1_scratch_start_cpu(cpu)		L1_SCRATCH_START
+#define get_l1_code_start_cpu(cpu)		L1_CODE_START
+#define get_l1_data_a_start_cpu(cpu)		L1_DATA_A_START
+#define get_l1_data_b_start_cpu(cpu)		L1_DATA_B_START
+#define get_l1_scratch_start()			L1_SCRATCH_START
+#define get_l1_code_start()			L1_CODE_START
+#define get_l1_data_a_start()			L1_DATA_A_START
+#define get_l1_data_b_start()			L1_DATA_B_START
+
+#define GET_PDA_SAFE(preg)		\
+	preg.l = _cpu_pda;		\
+	preg.h = _cpu_pda;
+
+#define GET_PDA(preg, dreg)	GET_PDA_SAFE(preg)
+
 #endif/* _MEM_MAP_548_H_ */
-- 
1.5.6.3
