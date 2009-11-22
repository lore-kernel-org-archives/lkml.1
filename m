Return-Path: <linux-kernel-owner+w=401wt.eu-S1752471AbZKVHob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471AbZKVHob (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 02:44:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752204AbZKVHob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 02:44:31 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:38925 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129AbZKVHoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 02:44:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=IfdJ66DoSrhygs0ALsd6D0+Fb8axw2rUOhCt5F07Cd/hpa1BhkbKYtuDDyt6JZznWH
         x0nq3PRqpK9cQK1aFGW+1o+FveuBYdmkVldTpHKgax/aRXhSGmqBhLJc3ciE5xeAHw3P
         iGg2lQhojGrTIqvpkHo8o6IUFc8OcMx5KRIGg=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, Thomas Gleixner <tglx@linutronix.de>,
       Michal Simek <monstr@monstr.eu>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Wu Zhangjin <wuzhangjin@gmail.com>
Subject: [PATCH v2] MIPS: Add a high resolution sched_clock() via cnt32_to_63().
Date: Sun, 22 Nov 2009 15:44:20 +0800
Message-Id: <dae45f23b5d34f64fc60a445015e7dfe05aa0d07.1258875717.git.wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Zhangjin <wuzhangjin@gmail.com>

(This v2 revision adds the missing CONFIG_HR_SCHED_CLOCK around
 sched_clock().)

This patch adds a cnt32_to_63() and MIPS c0 count based sched_clock(),
which can provide high resolution. and also, two new kernel options are
added. the HR_SCHED_CLOCK is used to enable/disable this sched_clock(),
and the HT_SCHED_CLOCK_UPDATE is used to allow whether update the
sched_clock() automatically.

Without it, the Ftrace for MIPS will give useless timestamp information.

Because cnt32_to_63() needs to be called at least once per half period
to work properly, Differ from the old version, this v1 revision set up a
kernel timer to ensure the requirement of some MIPSs which have short c0
count period.

Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
---
 arch/mips/Kconfig           |   30 +++++++++++++++++++++
 arch/mips/kernel/csrc-r4k.c |   60 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 90 insertions(+), 0 deletions(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index b342197..6264f97 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -1952,6 +1952,36 @@ config NR_CPUS
 source "kernel/time/Kconfig"
 
 #
+# High Resolution sched_clock() Configuration
+#
+
+config HR_SCHED_CLOCK
+	bool "High Resolution sched_clock()"
+	depends on CSRC_R4K
+	default n
+	help
+	  This option enables the MIPS c0 count based high resolution
+	  sched_clock().
+
+	  If you need a ns precision timestamp, You are recommended to enable
+	  this option. For example, If you are using the Ftrace subsystem to do
+	  real time tracing, this option is needed.
+
+	  If unsure, disable it.
+
+config HR_SCHED_CLOCK_UPDATE
+	bool "Update sched_clock() automatically"
+	depends on HR_SCHED_CLOCK
+	default y
+	help
+	  Because Some of the MIPS c0 count period is quite short and because
+	  cnt32_to_63() needs to be called at least once per half period to
+	  work properly, a kernel timer is needed to set up to ensure this
+	  requirement is always met.
+
+	  If unusre, enable it.
+
+#
 # Timer Interrupt Frequency Configuration
 #
 
diff --git a/arch/mips/kernel/csrc-r4k.c b/arch/mips/kernel/csrc-r4k.c
index e95a3cd..4e52cca 100644
--- a/arch/mips/kernel/csrc-r4k.c
+++ b/arch/mips/kernel/csrc-r4k.c
@@ -6,10 +6,64 @@
  * Copyright (C) 2007 by Ralf Baechle
  */
 #include <linux/clocksource.h>
+#include <linux/cnt32_to_63.h>
+#include <linux/timer.h>
 #include <linux/init.h>
 
 #include <asm/time.h>
 
+/*
+ * MIPS' sched_clock implementation.
+ *
+ * because cnt32_to_63() needs to be called at least once per half period to
+ * work properly, and some of the MIPS' frequency is very low, perhaps a kernel
+ * timer is needed to be set up to ensure this requirement is always met.
+ * please refer to  arch/arm/plat-orion/time.c and include/linux/cnt32_to_63.h
+ */
+static unsigned long __maybe_unused tclk2ns_scale;
+static unsigned long __maybe_unused tclk2ns_scale_factor;
+
+#ifdef CONFIG_HR_SCHED_CLOCK
+unsigned long long notrace sched_clock(void)
+{
+	unsigned long long v = cnt32_to_63(read_c0_count());
+	return (v * tclk2ns_scale) >> tclk2ns_scale_factor;
+}
+#endif
+
+static void __init __maybe_unused setup_sched_clock(struct clocksource *cs)
+{
+	unsigned long long v;
+
+	v = cs->mult;
+	/*
+	 * We want an even value to automatically clear the top bit
+	 * returned by cnt32_to_63() without an additional run time
+	 * instruction. So if the LSB is 1 then round it up.
+	 */
+	if (v & 1)
+		v++;
+	tclk2ns_scale = v;
+	tclk2ns_scale_factor = cs->shift;
+}
+
+static struct timer_list __maybe_unused cnt32_to_63_keepwarm_timer;
+
+static void __maybe_unused cnt32_to_63_keepwarm(unsigned long data)
+{
+	mod_timer(&cnt32_to_63_keepwarm_timer, round_jiffies(jiffies + data));
+	(void) sched_clock();
+}
+
+static void __maybe_unused setup_sched_clock_update(unsigned long tclk)
+{
+	unsigned long data;
+
+	data = (0xffffffffUL / tclk / 2 - 2) * HZ;
+	setup_timer(&cnt32_to_63_keepwarm_timer, cnt32_to_63_keepwarm, data);
+	mod_timer(&cnt32_to_63_keepwarm_timer, round_jiffies(jiffies + data));
+}
+
 static cycle_t c0_hpt_read(struct clocksource *cs)
 {
 	return read_c0_count();
@@ -32,7 +86,13 @@ int __init init_r4k_clocksource(void)
 
 	clocksource_set_clock(&clocksource_mips, mips_hpt_frequency);
 
+#ifdef CONFIG_HR_SCHED_CLOCK
+	setup_sched_clock(&clocksource_mips);
+#endif
 	clocksource_register(&clocksource_mips);
 
+#ifdef CONFIG_HR_SCHED_CLOCK_UPDATE
+	setup_sched_clock_update(mips_hpt_frequency);
+#endif
 	return 0;
 }
-- 
1.6.2.1

