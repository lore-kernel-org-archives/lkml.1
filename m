Return-Path: <linux-kernel-owner+w=401wt.eu-S1756463AbZFEISi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756463AbZFEISi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 04:18:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755579AbZFEIGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 04:06:44 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37466 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755741AbZFEIF6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 04:05:58 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org, Graf Yang <graf.yang@analog.com>
Subject: [PATCH 36/62] Blackfin: work around anomaly 05000220
Date: Fri,  5 Jun 2009 04:04:45 -0400
Message-Id: <1244189111-19639-37-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
References: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Graf Yang <graf.yang@analog.com>

When possible, work around anomaly 05000220 (external memory is write
back cached, but L2 is not cached).  If not possible, detect the
conditions at build time and reject any qualifying configurations.

Signed-off-by: Graf Yang <graf.yang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/Kconfig                   |   24 +++++++++++++++------
 arch/blackfin/include/asm/cplb.h        |   35 ++++++++++++++++--------------
 arch/blackfin/mach-common/arch_checks.c |    7 ++++++
 3 files changed, 43 insertions(+), 23 deletions(-)

diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index c04e7a4..f1a7969 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -913,7 +913,7 @@ config BFIN_ICACHE_LOCK
 	bool "Enable Instruction Cache Locking"
 
 choice
-	prompt "Policy"
+	prompt "External memory cache policy"
 	depends on BFIN_DCACHE
 	default BFIN_WB if !SMP
 	default BFIN_WT if SMP
@@ -954,12 +954,22 @@ config BFIN_WT
 
 endchoice
 
-config BFIN_L2_CACHEABLE
-	bool "Cache L2 SRAM"
-	depends on (BFIN_DCACHE || BFIN_ICACHE) && (BF54x || (BF561 && !SMP))
-	default n
-	help
-	  Select to make L2 SRAM cacheable in L1 data and instruction cache.
+choice
+	prompt "L2 SRAM cache policy"
+	depends on (BF54x || BF561)
+	default BFIN_L2_WT
+config BFIN_L2_WB
+	bool "Write back"
+	depends on !SMP
+
+config BFIN_L2_WT
+	bool "Write through"
+	depends on !SMP
+
+config BFIN_L2_NOT_CACHED
+	bool "Not cached"
+
+endchoice
 
 config MPU
 	bool "Enable the memory protection unit (EXPERIMENTAL)"
diff --git a/arch/blackfin/include/asm/cplb.h b/arch/blackfin/include/asm/cplb.h
index ad566ff..a75a6a9 100644
--- a/arch/blackfin/include/asm/cplb.h
+++ b/arch/blackfin/include/asm/cplb.h
@@ -53,29 +53,32 @@
 #define SDRAM_DGENERIC   (CPLB_L1_CHBL | CPLB_WT | CPLB_L1_AOW  | CPLB_COMMON)
 #endif
 
+#define SDRAM_DNON_CHBL  (CPLB_COMMON)
+#define SDRAM_EBIU       (CPLB_COMMON)
+#define SDRAM_OOPS       (CPLB_VALID | ANOMALY_05000158_WORKAROUND | CPLB_LOCK | CPLB_DIRTY)
+
 #define L1_DMEMORY       (CPLB_LOCK | CPLB_COMMON)
 
 #ifdef CONFIG_SMP
-#define L2_ATTR           (INITIAL_T | I_CPLB | D_CPLB)
-#define L2_IMEMORY         (CPLB_COMMON | CPLB_LOCK)
-#define L2_DMEMORY         (CPLB_COMMON | CPLB_LOCK)
+#define L2_ATTR          (INITIAL_T | I_CPLB | D_CPLB)
+#define L2_IMEMORY       (CPLB_COMMON)
+#define L2_DMEMORY       (CPLB_LOCK | CPLB_COMMON)
 
 #else
-#ifdef CONFIG_BFIN_L2_CACHEABLE
-#define L2_IMEMORY        (SDRAM_IGENERIC)
-#define L2_DMEMORY        (SDRAM_DGENERIC)
-#else
-#define L2_IMEMORY        (CPLB_COMMON)
-#define L2_DMEMORY        (CPLB_COMMON)
-#endif /* CONFIG_BFIN_L2_CACHEABLE */
-
-#define L2_ATTR           (INITIAL_T | SWITCH_T | I_CPLB | D_CPLB)
+#define L2_ATTR          (INITIAL_T | SWITCH_T | I_CPLB | D_CPLB)
+#define L2_IMEMORY       (SDRAM_IGENERIC)
+
+# if defined(CONFIG_BFIN_L2_WB)
+# define L2_DMEMORY      (CPLB_L1_CHBL | CPLB_COMMON)
+# elif defined(CONFIG_BFIN_L2_WT)
+# define L2_DMEMORY      (CPLB_L1_CHBL | CPLB_WT | CPLB_L1_AOW  | CPLB_COMMON)
+# elif defined(CONFIG_BFIN_L2_NOT_CACHED)
+# define L2_DMEMORY      (CPLB_COMMON)
+# else
+# define L2_DMEMORY      (0)
+# endif
 #endif /* CONFIG_SMP */
 
-#define SDRAM_DNON_CHBL  (CPLB_COMMON)
-#define SDRAM_EBIU       (CPLB_COMMON)
-#define SDRAM_OOPS       (CPLB_VALID | ANOMALY_05000158_WORKAROUND | CPLB_LOCK | CPLB_DIRTY)
-
 #define SIZE_1K 0x00000400      /* 1K */
 #define SIZE_4K 0x00001000      /* 4K */
 #define SIZE_1M 0x00100000      /* 1M */
diff --git a/arch/blackfin/mach-common/arch_checks.c b/arch/blackfin/mach-common/arch_checks.c
index 80d39b2..da93d92 100644
--- a/arch/blackfin/mach-common/arch_checks.c
+++ b/arch/blackfin/mach-common/arch_checks.c
@@ -71,3 +71,10 @@
 #if ANOMALY_05000448
 # error You are using a part with anomaly 05000448, this issue causes random memory read/write failures - that means random crashes.
 #endif
+
+/* if 220 exists, can not set External Memory WB and L2 not_cached, either External Memory not_cached and L2 WB */
+#if ANOMALY_05000220 && \
+	((defined(CONFIG_BFIN_WB) && defined(CONFIG_BFIN_L2_NOT_CACHED)) || \
+	 (!defined(CONFIG_BFIN_DCACHE) && defined(CONFIG_BFIN_L2_WB)))
+# error You are exposing Anomaly 220 in this config, either config L2 as Write Through, or make External Memory WB.
+#endif
-- 
1.6.3.1

