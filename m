Return-Path: <linux-kernel-owner+w=401wt.eu-S1757055AbZFEIPS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757055AbZFEIPS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 04:15:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755689AbZFEIGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 04:06:25 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37509 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754788AbZFEIFh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 04:05:37 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 27/62] Blackfin: workaround anomaly 05000227
Date: Fri,  5 Jun 2009 04:04:36 -0400
Message-Id: <1244189111-19639-28-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
References: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Workaround anomaly 05000227 by only using the scratch pad for stack when
absolutely necessary.  The core code which reprograms clocks really only
touches MMRs directly with constants.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/mach-common/head.S |   18 +++++++++++-------
 1 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/arch/blackfin/mach-common/head.S b/arch/blackfin/mach-common/head.S
index 698d4c0..01d62ff 100644
--- a/arch/blackfin/mach-common/head.S
+++ b/arch/blackfin/mach-common/head.S
@@ -30,8 +30,6 @@ ENTRY(__init_clear_bss)
 	rts;
 ENDPROC(__init_clear_bss)
 
-#define INITIAL_STACK	(L1_SCRATCH_START + L1_SCRATCH_LENGTH - 12)
-
 ENTRY(__start)
 	/* R0: argument of command line string, passed from uboot, save it */
 	R7 = R0;
@@ -148,8 +146,8 @@ ENTRY(__start)
 #endif
 
 	/* Initialize stack pointer */
-	sp.l = lo(INITIAL_STACK);
-	sp.h = hi(INITIAL_STACK);
+	sp.l = _init_thread_union;
+	sp.h = _init_thread_union;
 	fp = sp;
 	usp = sp;
 
@@ -189,7 +187,15 @@ ENTRY(__start)
 	/* Put The Code for PLL Programming and SDRAM Programming in L1 ISRAM */
 	call _bfin_relocate_l1_mem;
 #ifdef CONFIG_BFIN_KERNEL_CLOCK
+	/* Only use on-chip scratch space for stack when absolutely required
+	 * to avoid Anomaly 05000227 ... we know the init_clocks() func only
+	 * uses L1 text and stack space and no other memory region.
+	 */
+# define KERNEL_CLOCK_STACK (L1_SCRATCH_START + L1_SCRATCH_LENGTH - 12)
+	sp.l = lo(KERNEL_CLOCK_STACK);
+	sp.h = hi(KERNEL_CLOCK_STACK);
 	call _init_clocks;
+	sp = usp;	/* usp hasnt been touched, so restore from there */
 #endif
 
 	/* This section keeps the processor in supervisor mode
@@ -243,9 +249,7 @@ ENTRY(_real_start)
 	call _cmdline_init;
 
 	/* Load the current thread pointer and stack */
-	sp.l = _init_thread_union;
-	sp.h = _init_thread_union;
-	p1 = THREAD_SIZE (z);
+	p1 = THREAD_SIZE + 4 (z);	/* +4 is for reti loading */
 	sp = sp + p1;
 	usp = sp;
 	fp = sp;
-- 
1.6.3.1

