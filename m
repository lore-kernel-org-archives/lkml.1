Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965557Ab0BZRhR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 12:37:17 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:57785
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965523Ab0BZRgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 12:36:07 -0500
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMab9bhzz1202hzzz32i87h6bh43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KYGM7O-02-2LL-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 03/15] oprofile/x86: remove OPROFILE_IBS config option
Date: Fri, 26 Feb 2010 18:29:55 +0100
Message-ID: <1267205407-6523-4-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1267205407-6523-1-git-send-email-robert.richter@amd.com>
References: <1267205407-6523-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 26 Feb 2010 17:35:47.0085 (UTC) FILETIME=[215E13D0:01CAB70A]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OProfile support for IBS is now for several versions in the
kernel. The feature is stable now and the code can be activated
permanently.

As a side effect IBS now works also on nosmp configs.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/Kconfig                     |   14 --------------
 arch/x86/oprofile/op_model_amd.c |   31 +------------------------------
 2 files changed, 1 insertions(+), 44 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index d677872..06a1372 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -15,20 +15,6 @@ config OPROFILE
 
 	  If unsure, say N.
 
-config OPROFILE_IBS
-	bool "OProfile AMD IBS support (EXPERIMENTAL)"
-	default n
-	depends on OPROFILE && SMP && X86
-	help
-          Instruction-Based Sampling (IBS) is a new profiling
-          technique that provides rich, precise program performance
-          information. IBS is introduced by AMD Family10h processors
-          (AMD Opteron Quad-Core processor "Barcelona") to overcome
-          the limitations of conventional performance counter
-          sampling.
-
-	  If unsure, say N.
-
 config OPROFILE_EVENT_MULTIPLEX
 	bool "OProfile multiplexing support (EXPERIMENTAL)"
 	default n
diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index 39686c2..2b9c68d 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -22,6 +22,7 @@
 #include <asm/ptrace.h>
 #include <asm/msr.h>
 #include <asm/nmi.h>
+#include <asm/apic.h>
 
 #include "op_x86_model.h"
 #include "op_counter.h"
@@ -43,8 +44,6 @@
 
 static unsigned long reset_value[NUM_VIRT_COUNTERS];
 
-#ifdef CONFIG_OPROFILE_IBS
-
 /* IbsFetchCtl bits/masks */
 #define IBS_FETCH_RAND_EN		(1ULL<<57)
 #define IBS_FETCH_VAL			(1ULL<<49)
@@ -72,8 +71,6 @@ struct op_ibs_config {
 
 static struct op_ibs_config ibs_config;
 
-#endif
-
 #ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
 
 static void op_mux_fill_in_addresses(struct op_msrs * const msrs)
@@ -185,8 +182,6 @@ static void op_amd_setup_ctrs(struct op_x86_model_spec const *model,
 	}
 }
 
-#ifdef CONFIG_OPROFILE_IBS
-
 static inline void
 op_amd_handle_ibs(struct pt_regs * const regs,
 		  struct op_msrs const * const msrs)
@@ -272,15 +267,6 @@ static void op_amd_stop_ibs(void)
 		wrmsrl(MSR_AMD64_IBSOPCTL, 0);
 }
 
-#else
-
-static inline void op_amd_handle_ibs(struct pt_regs * const regs,
-				    struct op_msrs const * const msrs) { }
-static inline void op_amd_start_ibs(void) { }
-static inline void op_amd_stop_ibs(void) { }
-
-#endif
-
 static int op_amd_check_ctrs(struct pt_regs * const regs,
 			     struct op_msrs const * const msrs)
 {
@@ -355,8 +341,6 @@ static void op_amd_shutdown(struct op_msrs const * const msrs)
 	}
 }
 
-#ifdef CONFIG_OPROFILE_IBS
-
 static u8 ibs_eilvt_off;
 
 static inline void apic_init_ibs_nmi_per_cpu(void *arg)
@@ -507,19 +491,6 @@ static void op_amd_exit(void)
 	ibs_exit();
 }
 
-#else
-
-/* no IBS support */
-
-static int op_amd_init(struct oprofile_operations *ops)
-{
-	return 0;
-}
-
-static void op_amd_exit(void) {}
-
-#endif /* CONFIG_OPROFILE_IBS */
-
 struct op_x86_model_spec op_amd_spec = {
 	.num_counters		= NUM_COUNTERS,
 	.num_controls		= NUM_CONTROLS,
-- 
1.6.6


