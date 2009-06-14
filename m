Return-Path: <linux-kernel-owner+w=401wt.eu-S1759240AbZFNMC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759240AbZFNMC1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 08:02:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758640AbZFNMBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 08:01:30 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:52652 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758571AbZFNMB3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 08:01:29 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 03/17] Blackfin: only build irqpanic.c when needed
Date: Sun, 14 Jun 2009 08:01:04 -0400
Message-Id: <1244980878-2124-4-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244980878-2124-1-git-send-email-vapier@gentoo.org>
References: <1244980878-2124-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The irq_panic function is only used when CONFIG_DEBUG_ICACHE_CHECK is
enabled, so move the conditional build to the Makefile rather than
wrapping all of the contents of the file.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/mach-common/Makefile   |    3 ++-
 arch/blackfin/mach-common/irqpanic.c |   11 ++---------
 2 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/arch/blackfin/mach-common/Makefile b/arch/blackfin/mach-common/Makefile
index 1f3228e..dd8b2dc 100644
--- a/arch/blackfin/mach-common/Makefile
+++ b/arch/blackfin/mach-common/Makefile
@@ -4,7 +4,7 @@
 
 obj-y := \
 	cache.o cache-c.o entry.o head.o \
-	interrupt.o irqpanic.o arch_checks.o ints-priority.o
+	interrupt.o arch_checks.o ints-priority.o
 
 obj-$(CONFIG_BFIN_ICACHE_LOCK) += lock.o
 obj-$(CONFIG_PM)          += pm.o dpmc_modes.o
@@ -12,3 +12,4 @@ obj-$(CONFIG_CPU_FREQ)    += cpufreq.o
 obj-$(CONFIG_CPU_VOLTAGE) += dpmc.o
 obj-$(CONFIG_SMP)         += smp.o
 obj-$(CONFIG_BFIN_KERNEL_CLOCK) += clocks-init.o
+obj-$(CONFIG_DEBUG_ICACHE_CHECK) += irqpanic.o
diff --git a/arch/blackfin/mach-common/irqpanic.c b/arch/blackfin/mach-common/irqpanic.c
index 05004df..883e324 100644
--- a/arch/blackfin/mach-common/irqpanic.c
+++ b/arch/blackfin/mach-common/irqpanic.c
@@ -30,21 +30,17 @@
 #include <linux/module.h>
 #include <linux/kernel_stat.h>
 #include <linux/sched.h>
-#include <asm/traps.h>
 #include <asm/blackfin.h>
 
-#ifdef CONFIG_DEBUG_ICACHE_CHECK
 #define L1_ICACHE_START 0xffa10000
 #define L1_ICACHE_END   0xffa13fff
-void irq_panic(int reason, struct pt_regs *regs) __attribute__ ((l1_text));
-#endif
 
 /*
  * irq_panic - calls panic with string setup
  */
+__attribute__ ((l1_text))
 asmlinkage void irq_panic(int reason, struct pt_regs *regs)
 {
-#ifdef CONFIG_DEBUG_ICACHE_CHECK
 	unsigned int cmd, tag, ca, cache_hi, cache_lo, *pa;
 	unsigned short i, j, die;
 	unsigned int bad[10][6];
@@ -126,9 +122,6 @@ asmlinkage void irq_panic(int reason, struct pt_regs *regs)
 			     bad[j][3], bad[j][4], bad[j][5]);
 		}
 		panic("icache coherency error");
-	} else {
+	} else
 		printk(KERN_EMERG "icache checked, and OK\n");
-	}
-#endif
-
 }
-- 
1.6.3.1

