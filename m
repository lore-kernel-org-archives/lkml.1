Return-Path: <linux-kernel-owner+w=401wt.eu-S933707AbZINUJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933707AbZINUJW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:09:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933700AbZINUJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:09:18 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:54176 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933653AbZINUJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:09:03 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Robin Getz <robin.getz@analog.com>
Subject: [PATCH 60/72] Blackfin: workaround anomaly 05000283
Date: Mon, 14 Sep 2009 16:08:04 -0400
Message-Id: <1252958896-25150-61-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
References: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robin Getz <robin.getz@analog.com>

Make sure our interrupt entry code with exact hardware errors handles
anomaly 05000283 (infinite stall in system MMR kill) so we don't stall
while under load.

Signed-off-by: Robin Getz <robin.getz@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/include/asm/entry.h     |   30 ++++++++++++++++++++++++++----
 arch/blackfin/mach-common/entry.S     |   18 ++----------------
 arch/blackfin/mach-common/interrupt.S |   19 +++----------------
 3 files changed, 31 insertions(+), 36 deletions(-)

diff --git a/arch/blackfin/include/asm/entry.h b/arch/blackfin/include/asm/entry.h
index ec58efc..55b808f 100644
--- a/arch/blackfin/include/asm/entry.h
+++ b/arch/blackfin/include/asm/entry.h
@@ -36,6 +36,21 @@
 # define LOAD_IPIPE_IPEND
 #endif
 
+/*
+ * Workaround for anomalies 05000283 and 05000315
+ */
+#if ANOMALY_05000283 || ANOMALY_05000315
+# define ANOMALY_283_315_WORKAROUND(preg, dreg)		\
+	cc = dreg == dreg;				\
+	preg.h = HI(CHIPID);				\
+	preg.l = LO(CHIPID);				\
+	if cc jump 1f;					\
+	dreg.l = W[preg];				\
+1:
+#else
+# define ANOMALY_283_315_WORKAROUND(preg, dreg)
+#endif /* ANOMALY_05000283 || ANOMALY_05000315 */
+
 #ifndef CONFIG_EXACT_HWERR
 /* As a debugging aid - we save IPEND when DEBUG_KERNEL is on,
  * otherwise it is a waste of cycles.
@@ -88,17 +103,22 @@
  * As you can see by the code - we actually need to do two SSYNCS - one to
  * make sure the read/writes complete, and another to make sure the hardware
  * error is recognized by the core.
+ *
+ * The extra nop before the SSYNC is to make sure we work around 05000244,
+ * since the 283/315 workaround includes a branch to the end
  */
 #define INTERRUPT_ENTRY(N)						\
-    SSYNC;								\
-    SSYNC;								\
     [--sp] = SYSCFG;							\
     [--sp] = P0;	/*orig_p0*/					\
     [--sp] = R0;	/*orig_r0*/					\
     [--sp] = (R7:0,P5:0);						\
     R1 = ASTAT;								\
+    ANOMALY_283_315_WORKAROUND(p0, r0)					\
     P0.L = LO(ILAT);							\
     P0.H = HI(ILAT);							\
+    NOP;								\
+    SSYNC;								\
+    SSYNC;								\
     R0 = [P0];								\
     CC = BITTST(R0, EVT_IVHW_P);					\
     IF CC JUMP 1f;							\
@@ -118,15 +138,17 @@
     RTI;
 
 #define TIMER_INTERRUPT_ENTRY(N)					\
-    SSYNC;								\
-    SSYNC;								\
     [--sp] = SYSCFG;							\
     [--sp] = P0;	/*orig_p0*/					\
     [--sp] = R0;	/*orig_r0*/					\
     [--sp] = (R7:0,P5:0);						\
     R1 = ASTAT;								\
+    ANOMALY_283_315_WORKAROUND(p0, r0)					\
     P0.L = LO(ILAT);							\
     P0.H = HI(ILAT);							\
+    NOP;								\
+    SSYNC;								\
+    SSYNC;								\
     R0 = [P0];								\
     CC = BITTST(R0, EVT_IVHW_P);					\
     IF CC JUMP 1f;							\
diff --git a/arch/blackfin/mach-common/entry.S b/arch/blackfin/mach-common/entry.S
index a9b15aa..01af24c 100644
--- a/arch/blackfin/mach-common/entry.S
+++ b/arch/blackfin/mach-common/entry.S
@@ -513,14 +513,7 @@ ENTRY(_trap) /* Exception: 4th entry into system event table(supervisor mode)*/
 	ssync;
 #endif
 
-#if ANOMALY_05000283 || ANOMALY_05000315
-	cc = r7 == r7;
-	p5.h = HI(CHIPID);
-	p5.l = LO(CHIPID);
-	if cc jump 1f;
-	r7.l = W[p5];
-1:
-#endif
+	ANOMALY_283_315_WORKAROUND(p5, r7)
 
 #ifdef CONFIG_DEBUG_DOUBLEFAULT
 	/*
@@ -1134,14 +1127,7 @@ ENTRY(_early_trap)
 	SAVE_ALL_SYS
 	trace_buffer_stop(p0,r0);
 
-#if ANOMALY_05000283 || ANOMALY_05000315
-	cc = r5 == r5;
-	p4.h = HI(CHIPID);
-	p4.l = LO(CHIPID);
-	if cc jump 1f;
-	r5.l = W[p4];
-1:
-#endif
+	ANOMALY_283_315_WORKAROUND(p4, r5)
 
 	/* Turn caches off, to ensure we don't get double exceptions */
 
diff --git a/arch/blackfin/mach-common/interrupt.S b/arch/blackfin/mach-common/interrupt.S
index c754ff7..82d417e 100644
--- a/arch/blackfin/mach-common/interrupt.S
+++ b/arch/blackfin/mach-common/interrupt.S
@@ -119,14 +119,8 @@ __common_int_entry:
 	fp = 0;
 #endif
 
-#if ANOMALY_05000283 || ANOMALY_05000315
-	cc = r7 == r7;
-	p5.h = HI(CHIPID);
-	p5.l = LO(CHIPID);
-	if cc jump 1f;
-	r7.l = W[p5];
-1:
-#endif
+	ANOMALY_283_315_WORKAROUND(p5, r7)
+
 	r1 =  sp;
 	SP += -12;
 #ifdef CONFIG_IPIPE
@@ -158,14 +152,7 @@ ENTRY(_evt_ivhw)
 	fp = 0;
 #endif
 
-#if ANOMALY_05000283 || ANOMALY_05000315
-	cc = r7 == r7;
-	p5.h = HI(CHIPID);
-	p5.l = LO(CHIPID);
-	if cc jump 1f;
-	r7.l = W[p5];
-1:
-#endif
+	ANOMALY_283_315_WORKAROUND(p5, r7)
 
 	/* Handle all stacked hardware errors
 	 * To make sure we don't hang forever, only do it 10 times
-- 
1.6.4.2

