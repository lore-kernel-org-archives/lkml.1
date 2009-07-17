Return-Path: <linux-kernel-owner+w=401wt.eu-S933693AbZGQAJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933693AbZGQAJf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 20:09:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933786AbZGQAJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 20:09:29 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:39121 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933688AbZGQAFx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 20:05:53 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 08/21] Blackfin: handle BF561 Core B memory regions better when SMP=n
Date: Thu, 16 Jul 2009 20:05:33 -0400
Message-Id: <1247789146-18786-9-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1247789146-18786-1-git-send-email-vapier@gentoo.org>
References: <1247789146-18786-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than assume Core B is always run with caches turned on, let people
load into any of the on-chip memory regions.  It is their business how the
SRAM/Cache regions are utilized, so don't prevent them from being able to
load into them.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/kernel/process.c                  |   14 +++++++-------
 arch/blackfin/mach-bf561/include/mach/mem_map.h |   23 ++++++++++++++++++++++-
 2 files changed, 29 insertions(+), 8 deletions(-)

diff --git a/arch/blackfin/kernel/process.c b/arch/blackfin/kernel/process.c
index 79cad0a..9da36ba 100644
--- a/arch/blackfin/kernel/process.c
+++ b/arch/blackfin/kernel/process.c
@@ -361,7 +361,7 @@ static inline
 int in_mem_const(unsigned long addr, unsigned long size,
                  unsigned long const_addr, unsigned long const_size)
 {
-	return in_mem_const_off(addr, 0, size, const_addr, const_size);
+	return in_mem_const_off(addr, size, 0, const_addr, const_size);
 }
 #define IN_ASYNC(bnum, bctlnum) \
 ({ \
@@ -390,13 +390,13 @@ int bfin_mem_access_type(unsigned long addr, unsigned long size)
 	if (in_mem_const(addr, size, L1_DATA_B_START, L1_DATA_B_LENGTH))
 		return cpu == 0 ? BFIN_MEM_ACCESS_CORE : BFIN_MEM_ACCESS_IDMA;
 #ifdef COREB_L1_CODE_START
-	if (in_mem_const(addr, size, COREB_L1_CODE_START, L1_CODE_LENGTH))
+	if (in_mem_const(addr, size, COREB_L1_CODE_START, COREB_L1_CODE_LENGTH))
 		return cpu == 1 ? BFIN_MEM_ACCESS_ITEST : BFIN_MEM_ACCESS_IDMA;
 	if (in_mem_const(addr, size, COREB_L1_SCRATCH_START, L1_SCRATCH_LENGTH))
 		return cpu == 1 ? BFIN_MEM_ACCESS_CORE_ONLY : -EFAULT;
-	if (in_mem_const(addr, size, COREB_L1_DATA_A_START, L1_DATA_A_LENGTH))
+	if (in_mem_const(addr, size, COREB_L1_DATA_A_START, COREB_L1_DATA_A_LENGTH))
 		return cpu == 1 ? BFIN_MEM_ACCESS_CORE : BFIN_MEM_ACCESS_IDMA;
-	if (in_mem_const(addr, size, COREB_L1_DATA_B_START, L1_DATA_B_LENGTH))
+	if (in_mem_const(addr, size, COREB_L1_DATA_B_START, COREB_L1_DATA_B_LENGTH))
 		return cpu == 1 ? BFIN_MEM_ACCESS_CORE : BFIN_MEM_ACCESS_IDMA;
 #endif
 	if (in_mem_const(addr, size, L2_START, L2_LENGTH))
@@ -472,13 +472,13 @@ int _access_ok(unsigned long addr, unsigned long size)
 	if (in_mem_const_off(addr, size, _ebss_b_l1 - _sdata_b_l1, L1_DATA_B_START, L1_DATA_B_LENGTH))
 		return 1;
 #ifdef COREB_L1_CODE_START
-	if (in_mem_const(addr, size, COREB_L1_CODE_START, L1_CODE_LENGTH))
+	if (in_mem_const(addr, size, COREB_L1_CODE_START, COREB_L1_CODE_LENGTH))
 		return 1;
 	if (in_mem_const(addr, size, COREB_L1_SCRATCH_START, L1_SCRATCH_LENGTH))
 		return 1;
-	if (in_mem_const(addr, size, COREB_L1_DATA_A_START, L1_DATA_A_LENGTH))
+	if (in_mem_const(addr, size, COREB_L1_DATA_A_START, COREB_L1_DATA_A_LENGTH))
 		return 1;
-	if (in_mem_const(addr, size, COREB_L1_DATA_B_START, L1_DATA_B_LENGTH))
+	if (in_mem_const(addr, size, COREB_L1_DATA_B_START, COREB_L1_DATA_B_LENGTH))
 		return 1;
 #endif
 	if (in_mem_const_off(addr, size, _ebss_l2 - _stext_l2, L2_START, L2_LENGTH))
diff --git a/arch/blackfin/mach-bf561/include/mach/mem_map.h b/arch/blackfin/mach-bf561/include/mach/mem_map.h
index a63e15c..5b96ea5 100644
--- a/arch/blackfin/mach-bf561/include/mach/mem_map.h
+++ b/arch/blackfin/mach-bf561/include/mach/mem_map.h
@@ -37,7 +37,6 @@
 
 /* Memory Map for ADSP-BF561 processors */
 
-#ifdef CONFIG_BF561
 #define COREA_L1_CODE_START       0xFFA00000
 #define COREA_L1_DATA_A_START     0xFF800000
 #define COREA_L1_DATA_B_START     0xFF900000
@@ -74,6 +73,28 @@
 #define BFIN_DCACHESIZE	(0*1024)
 #define BFIN_DSUPBANKS	0
 #endif /*CONFIG_BFIN_DCACHE*/
+
+/*
+ * If we are in SMP mode, then the cache settings of Core B will match
+ * the settings of Core A.  If we aren't, then we assume Core B is not
+ * using any cache.  This allows the rest of the kernel to work with
+ * the core in either mode as we are only loading user code into it and
+ * it is the user's problem to make sure they aren't doing something
+ * stupid there.
+ *
+ * Note that we treat the L1 code region as a contiguous blob to make
+ * the rest of the kernel simpler.  Easier to check one region than a
+ * bunch of small ones.  Again, possible misbehavior here is the fault
+ * of the user -- don't try to use memory that doesn't exist.
+ */
+#ifdef CONFIG_SMP
+# define COREB_L1_CODE_LENGTH     L1_CODE_LENGTH
+# define COREB_L1_DATA_A_LENGTH   L1_DATA_A_LENGTH
+# define COREB_L1_DATA_B_LENGTH   L1_DATA_B_LENGTH
+#else
+# define COREB_L1_CODE_LENGTH     0x14000
+# define COREB_L1_DATA_A_LENGTH   0x8000
+# define COREB_L1_DATA_B_LENGTH   0x8000
 #endif
 
 /* Level 2 Memory */
-- 
1.6.3.3

