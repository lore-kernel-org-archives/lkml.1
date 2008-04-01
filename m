Return-Path: <linux-kernel-owner+w=401wt.eu-S1760778AbYDBAAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760778AbYDBAAe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 20:00:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757387AbYDAX6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 19:58:52 -0400
Received: from smtp03.mtu.ru ([62.5.255.50]:64045 "EHLO smtp03.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756783AbYDAX6u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 19:58:50 -0400
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] [MIPS] unexport null_perf_irq() and make it static
Date: Wed,  2 Apr 2008 03:58:38 +0400
Message-Id: <1207094318-21748-6-git-send-email-dmitri.vorobiev@gmail.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1207094318-21748-1-git-send-email-dmitri.vorobiev@gmail.com>
References: <1207094318-21748-1-git-send-email-dmitri.vorobiev@gmail.com>
X-DCC-STREAM-Metrics: smtp03.mtu.ru 10002; Body=0 Fuz1=0 Fuz2=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch unexports the null_perf_irq() symbol, and simultaneously
makes this function static.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
---
 arch/mips/kernel/time.c              |    4 +---
 arch/mips/oprofile/op_impl.h         |    1 -
 arch/mips/oprofile/op_model_mipsxx.c |    5 ++++-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/mips/kernel/time.c b/arch/mips/kernel/time.c
index d70ce5c..1f467d5 100644
--- a/arch/mips/kernel/time.c
+++ b/arch/mips/kernel/time.c
@@ -49,13 +49,11 @@ int update_persistent_clock(struct timespec now)
 	return rtc_mips_set_mmss(now.tv_sec);
 }
 
-int null_perf_irq(void)
+static int null_perf_irq(void)
 {
 	return 0;
 }
 
-EXPORT_SYMBOL(null_perf_irq);
-
 int (*perf_irq)(void) = null_perf_irq;
 
 EXPORT_SYMBOL(perf_irq);
diff --git a/arch/mips/oprofile/op_impl.h b/arch/mips/oprofile/op_impl.h
index fa6b4aa..2bfc17c 100644
--- a/arch/mips/oprofile/op_impl.h
+++ b/arch/mips/oprofile/op_impl.h
@@ -10,7 +10,6 @@
 #ifndef OP_IMPL_H
 #define OP_IMPL_H 1
 
-extern int null_perf_irq(void);
 extern int (*perf_irq)(void);
 
 /* Per-counter configuration as set via oprofilefs.  */
diff --git a/arch/mips/oprofile/op_model_mipsxx.c b/arch/mips/oprofile/op_model_mipsxx.c
index ccbea22..12e840f 100644
--- a/arch/mips/oprofile/op_model_mipsxx.c
+++ b/arch/mips/oprofile/op_model_mipsxx.c
@@ -31,6 +31,8 @@
 
 #define M_COUNTER_OVERFLOW		(1UL      << 31)
 
+int (*save_perf_irq)(void);
+
 #ifdef CONFIG_MIPS_MT_SMP
 #define WHAT		(M_TC_EN_VPE | M_PERFCTL_VPEID(smp_processor_id()))
 #define vpe_id()	smp_processor_id()
@@ -355,6 +357,7 @@ static int __init mipsxx_init(void)
 		return -ENODEV;
 	}
 
+	save_perf_irq = perf_irq;
 	perf_irq = mipsxx_perfcount_handler;
 
 	return 0;
@@ -367,7 +370,7 @@ static void mipsxx_exit(void)
 	counters = counters_per_cpu_to_total(counters);
 	reset_counters(counters);
 
-	perf_irq = null_perf_irq;
+	perf_irq = save_perf_irq;
 }
 
 struct op_mips_model op_model_mipsxx_ops = {
-- 
1.5.3

