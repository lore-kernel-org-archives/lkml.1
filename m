Return-Path: <linux-kernel-owner+w=401wt.eu-S1756596AbZFEILn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756596AbZFEILn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 04:11:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753866AbZFEIFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 04:05:53 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37492 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754767AbZFEIF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 04:05:29 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 16/62] Blackfin: simplify the do_flush macro
Date: Fri,  5 Jun 2009 04:04:25 -0400
Message-Id: <1244189111-19639-17-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
References: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify the do_flush macro now that we don't need to take into account
a second instruction being used together.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 arch/blackfin/mach-common/cache.S |   30 +++++++++++++++---------------
 1 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/arch/blackfin/mach-common/cache.S b/arch/blackfin/mach-common/cache.S
index c295e8f..d9666fe 100644
--- a/arch/blackfin/mach-common/cache.S
+++ b/arch/blackfin/mach-common/cache.S
@@ -15,6 +15,13 @@
 
 .text
 
+/* 05000443 - IFLUSH cannot be last instruction in hardware loop */
+#if ANOMALY_05000443
+# define BROK_FLUSH_INST "IFLUSH"
+#else
+# define BROK_FLUSH_INST "no anomaly! yeah!"
+#endif
+
 /* Since all L1 caches work the same way, we use the same method for flushing
  * them.  Only the actual flush instruction differs.  We write this in asm as
  * GCC can be hard to coax into writing nice hardware loops.
@@ -23,7 +30,7 @@
  * R0 = start address
  * R1 = end address
  */
-.macro do_flush flushins:req optflushins optnopins label
+.macro do_flush flushins:req label
 
 	R2 = -L1_CACHE_BYTES;
 
@@ -44,22 +51,15 @@
 \label :
 .endif
 	P0 = R0;
+
 	LSETUP (1f, 2f) LC1 = P1;
 1:
-.ifnb \optflushins
-	\optflushins [P0];
-.endif
-#if ANOMALY_05000443
-.ifb \optnopins
-2:
-.endif
+.ifeqs "\flushins", BROK_FLUSH_INST
 	\flushins [P0++];
-.ifnb \optnopins
-2:	\optnopins;
-.endif
-#else
+2:	nop;
+.else
 2:	\flushins [P0++];
-#endif
+.endif
 
 	RTS;
 .endm
@@ -77,7 +77,7 @@ ENTRY(_blackfin_icache_flush_range)
  */
 	P0 = R0;
 	IFLUSH[P0];
-	do_flush IFLUSH, , nop
+	do_flush IFLUSH
 ENDPROC(_blackfin_icache_flush_range)
 
 /* Throw away all D-cached data in specified region without any obligation to
@@ -91,7 +91,7 @@ ENDPROC(_blackfin_dcache_invalidate_range)
 
 /* Flush all data cache lines assocoiated with this memory area */
 ENTRY(_blackfin_dcache_flush_range)
-	do_flush FLUSH, , , .Ldfr
+	do_flush FLUSH, .Ldfr
 ENDPROC(_blackfin_dcache_flush_range)
 
 /* Our headers convert the page structure to an address, so just need to flush
-- 
1.6.3.1

