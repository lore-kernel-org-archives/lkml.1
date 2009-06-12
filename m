Return-Path: <linux-kernel-owner+w=401wt.eu-S1759626AbZFLQZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759626AbZFLQZn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 12:25:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759131AbZFLQYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 12:24:55 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:39054 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755370AbZFLQYy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 12:24:54 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Robin Getz <robin.getz@analog.com>
Subject: [PATCH 01/27] Blackfin: only handle CPLB protection violations when MPU is enabled
Date: Fri, 12 Jun 2009 12:24:19 -0400
Message-Id: <1244823885-22410-2-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244823885-22410-1-git-send-email-vapier@gentoo.org>
References: <1244823885-22410-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robin Getz <robin.getz@analog.com>

We don't need to handle CPLB protection violations unless we are running
with the MPU on.  Fix the entry code to call common trap_c, and remove the
code which is never run.  This allows the traps test suite to run on older
boards with the MPU disabled.

URL: http://blackfin.uclinux.org/gf/tracker/5129
Signed-off-by: Robin Getz <robin.getz@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/kernel/cplb-nompu/cplbmgr.c |   54 ++---------------------------
 arch/blackfin/mach-common/entry.S         |   11 ++++--
 2 files changed, 10 insertions(+), 55 deletions(-)

diff --git a/arch/blackfin/kernel/cplb-nompu/cplbmgr.c b/arch/blackfin/kernel/cplb-nompu/cplbmgr.c
index 8cbb47c..12b0308 100644
--- a/arch/blackfin/kernel/cplb-nompu/cplbmgr.c
+++ b/arch/blackfin/kernel/cplb-nompu/cplbmgr.c
@@ -28,6 +28,7 @@
 #include <asm/cplbinit.h>
 #include <asm/cplb.h>
 #include <asm/mmu_context.h>
+#include <asm/traps.h>
 
 /*
  * WARNING
@@ -100,28 +101,6 @@ static inline void write_icplb_data(int cpu, int idx, unsigned long data,
 #endif
 }
 
-/*
- * Given the contents of the status register, return the index of the
- * CPLB that caused the fault.
- */
-static inline int faulting_cplb_index(int status)
-{
-	int signbits = __builtin_bfin_norm_fr1x32(status & 0xFFFF);
-	return 30 - signbits;
-}
-
-/*
- * Given the contents of the status register and the DCPLB_DATA contents,
- * return true if a write access should be permitted.
- */
-static inline int write_permitted(int status, unsigned long data)
-{
-	if (status & FAULT_USERSUPV)
-		return !!(data & CPLB_SUPV_WR);
-	else
-		return !!(data & CPLB_USER_WR);
-}
-
 /* Counters to implement round-robin replacement.  */
 static int icplb_rr_index[NR_CPUS] PDT_ATTR;
 static int dcplb_rr_index[NR_CPUS] PDT_ATTR;
@@ -245,43 +224,16 @@ MGR_ATTR static int dcplb_miss(int cpu)
 	return CPLB_RELOADED;
 }
 
-MGR_ATTR static noinline int dcplb_protection_fault(int cpu)
-{
-	int status = bfin_read_DCPLB_STATUS();
-
-	nr_dcplb_prot[cpu]++;
-
-	if (likely(status & FAULT_RW)) {
-		int idx = faulting_cplb_index(status);
-		unsigned long regaddr = DCPLB_DATA0 + idx * 4;
-		unsigned long data = bfin_read32(regaddr);
-
-		/* Check if fault is to dirty a clean page */
-		if (!(data & CPLB_WT) && !(data & CPLB_DIRTY) &&
-		    write_permitted(status, data)) {
-
-			dcplb_tbl[cpu][idx].data = data;
-			bfin_write32(regaddr, data);
-			return CPLB_RELOADED;
-		}
-	}
-
-	return CPLB_PROT_VIOL;
-}
-
 MGR_ATTR int cplb_hdr(int seqstat, struct pt_regs *regs)
 {
 	int cause = seqstat & 0x3f;
 	unsigned int cpu = smp_processor_id();
 	switch (cause) {
-	case 0x2C:
+	case VEC_CPLB_I_M:
 		return icplb_miss(cpu);
-	case 0x26:
+	case VEC_CPLB_M:
 		return dcplb_miss(cpu);
 	default:
-		if (unlikely(cause == 0x23))
-			return dcplb_protection_fault(cpu);
-
 		return CPLB_UNKNOWN_ERR;
 	}
 }
diff --git a/arch/blackfin/mach-common/entry.S b/arch/blackfin/mach-common/entry.S
index da0558a..25c6aa4 100644
--- a/arch/blackfin/mach-common/entry.S
+++ b/arch/blackfin/mach-common/entry.S
@@ -42,6 +42,7 @@
 #include <asm/thread_info.h>  /* TIF_NEED_RESCHED */
 #include <asm/asm-offsets.h>
 #include <asm/trace.h>
+#include <asm/traps.h>
 
 #include <asm/context.S>
 
@@ -84,13 +85,15 @@ ENTRY(_ex_workaround_261)
 	if !cc jump _bfin_return_from_exception;
 	/* fall through */
 	R7 = P4;
-	R6 = 0x26;	/* Data CPLB Miss */
+	R6 = VEC_CPLB_M;	/* Data CPLB Miss */
 	cc = R6 == R7;
 	if cc jump _ex_dcplb_miss (BP);
-	R6 = 0x23;	/* Data CPLB Miss */
+#ifdef CONFIG_MPU
+	R6 = VEC_CPLB_VL;	/* Data CPLB Violation */
 	cc = R6 == R7;
 	if cc jump _ex_dcplb_viol (BP);
-	/* Handle 0x23 Data CPLB Protection Violation
+#endif
+	/* Handle Data CPLB Protection Violation
 	 * and Data CPLB Multiple Hits - Linux Trap Zero
 	 */
 	jump _ex_trap_c;
@@ -270,7 +273,7 @@ ENTRY(_bfin_return_from_exception)
 	r6.l = lo(SEQSTAT_EXCAUSE);
 	r6.h = hi(SEQSTAT_EXCAUSE);
 	r7 = r7 & r6;
-	r6 = 0x25;
+	r6 = VEC_UNCOV;
 	CC = R7 == R6;
 	if CC JUMP _double_fault;
 #endif
-- 
1.6.3.1

