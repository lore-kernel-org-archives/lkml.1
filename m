Return-Path: <linux-kernel-owner+w=401wt.eu-S1753725AbZJRLO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725AbZJRLO3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 07:14:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752777AbZJRLO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 07:14:28 -0400
Received: from ozlabs.org ([203.10.76.45]:54375 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752688AbZJRLO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 07:14:27 -0400
Date: Sun, 18 Oct 2009 22:13:00 +1100
From: Anton Blanchard <anton@samba.org>
To: benh@kernel.crashing.org, mingo@elte.hu, paulus@samba.org,
       a.p.zijlstra@chello.nl
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] powerpc perf_event: Add alignment-faults and
	emulation-faults software events
Message-ID: <20091018111300.GM4808@kryten>
References: <20091018110929.GK4808@kryten> <20091018111126.GL4808@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091018111126.GL4808@kryten>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hook up the alignment-faults and emulation-faults events for powerpc.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: linux.trees.git/arch/powerpc/include/asm/emulated_ops.h
===================================================================
--- linux.trees.git.orig/arch/powerpc/include/asm/emulated_ops.h	2009-09-22 13:45:07.000000000 +1000
+++ linux.trees.git/arch/powerpc/include/asm/emulated_ops.h	2009-09-22 13:45:27.000000000 +1000
@@ -19,6 +19,7 @@
 #define _ASM_POWERPC_EMULATED_OPS_H
 
 #include <asm/atomic.h>
+#include <linux/perf_event.h>
 
 
 #ifdef CONFIG_PPC_EMULATED_STATS
@@ -71,7 +72,18 @@ extern void ppc_warn_emulated_print(cons
 
 #endif /* !CONFIG_PPC_EMULATED_STATS */
 
-#define PPC_WARN_EMULATED(type, regs)	__PPC_WARN_EMULATED(type)
-#define PPC_WARN_ALIGNMENT(type, regs)	__PPC_WARN_EMULATED(type)
+#define PPC_WARN_EMULATED(type, regs)					\
+	do {								\
+		perf_sw_event(PERF_COUNT_SW_EMULATION_FAULTS,		\
+			1, 0, regs, 0);					\
+		__PPC_WARN_EMULATED(type);				\
+	} while (0)
+
+#define PPC_WARN_ALIGNMENT(type, regs)					\
+	do {								\
+		perf_sw_event(PERF_COUNT_SW_ALIGNMENT_FAULTS,		\
+			1, 0, regs, regs->dar);				\
+		__PPC_WARN_EMULATED(type);				\
+	} while (0)
 
 #endif /* _ASM_POWERPC_EMULATED_OPS_H */
