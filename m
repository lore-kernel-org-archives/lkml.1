Return-Path: <linux-kernel-owner+w=401wt.eu-S1763704AbYF0ViB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763704AbYF0ViB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 17:38:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764202AbYF0VhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 17:37:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59061 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764177AbYF0VhA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 17:37:00 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@elte.hu, x86@kernel.org
Subject: [PATCH 05/39] integrate delay functions
Date: Fri, 27 Jun 2008 18:34:12 -0300
Message-Id: <1214602486-17080-6-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1214602486-17080-5-git-send-email-gcosta@redhat.com>
References: <1214602486-17080-1-git-send-email-gcosta@redhat.com>
 <1214602486-17080-2-git-send-email-gcosta@redhat.com>
 <1214602486-17080-3-git-send-email-gcosta@redhat.com>
 <1214602486-17080-4-git-send-email-gcosta@redhat.com>
 <1214602486-17080-5-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

delay_32.c, delay_64.c are now equal, and are integrated into delay.c

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/lib/Makefile   |    2 +-
 arch/x86/lib/delay.c    |  137 ++++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/lib/delay_32.c |  138 -----------------------------------------------
 arch/x86/lib/delay_64.c |  128 -------------------------------------------
 4 files changed, 138 insertions(+), 267 deletions(-)
 create mode 100644 arch/x86/lib/delay.c
 delete mode 100644 arch/x86/lib/delay_32.c
 delete mode 100644 arch/x86/lib/delay_64.c

diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index 84aa288..700c2c3 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -4,7 +4,7 @@
 
 obj-$(CONFIG_SMP) := msr-on-cpu.o
 
-lib-y := delay_$(BITS).o
+lib-y := delay.o
 lib-y += thunk_$(BITS).o
 lib-y += usercopy_$(BITS).o getuser_$(BITS).o putuser_$(BITS).o
 lib-y += memcpy_$(BITS).o
diff --git a/arch/x86/lib/delay.c b/arch/x86/lib/delay.c
new file mode 100644
index 0000000..f456860
--- /dev/null
+++ b/arch/x86/lib/delay.c
@@ -0,0 +1,137 @@
+/*
+ *	Precise Delay Loops for i386
+ *
+ *	Copyright (C) 1993 Linus Torvalds
+ *	Copyright (C) 1997 Martin Mares <mj@atrey.karlin.mff.cuni.cz>
+ *	Copyright (C) 2008 Jiri Hladky <hladky _dot_ jiri _at_ gmail _dot_ com>
+ *
+ *	The __delay function must _NOT_ be inlined as its execution time
+ *	depends wildly on alignment on many x86 processors. The additional
+ *	jump magic is needed to get the timing stable on all the CPU's
+ *	we have to worry about.
+ */
+
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/timex.h>
+#include <linux/preempt.h>
+#include <linux/delay.h>
+#include <linux/init.h>
+
+#include <asm/processor.h>
+#include <asm/delay.h>
+#include <asm/timer.h>
+
+#ifdef CONFIG_SMP
+# include <asm/smp.h>
+#endif
+
+/* simple loop based delay: */
+static void delay_loop(unsigned long loops)
+{
+	asm volatile(
+		"	test %0,%0	\n"
+		"	jz 3f		\n"
+		"	jmp 1f		\n"
+
+		".align 16		\n"
+		"1:	jmp 2f		\n"
+
+		".align 16		\n"
+		"2:	dec %0		\n"
+		"	jnz 2b		\n"
+		"3:	dec %0		\n"
+
+		: /* we don't need output */
+		:"a" (loops)
+	);
+}
+
+/* TSC based delay: */
+static void delay_tsc(unsigned long loops)
+{
+	unsigned long bclock, now;
+	int cpu;
+
+	preempt_disable();
+	cpu = smp_processor_id();
+	rdtscl(bclock);
+	for (;;) {
+		rdtscl(now);
+		if ((now - bclock) >= loops)
+			break;
+
+		/* Allow RT tasks to run */
+		preempt_enable();
+		rep_nop();
+		preempt_disable();
+
+		/*
+		 * It is possible that we moved to another CPU, and
+		 * since TSC's are per-cpu we need to calculate
+		 * that. The delay must guarantee that we wait "at
+		 * least" the amount of time. Being moved to another
+		 * CPU could make the wait longer but we just need to
+		 * make sure we waited long enough. Rebalance the
+		 * counter for this CPU.
+		 */
+		if (unlikely(cpu != smp_processor_id())) {
+			loops -= (now - bclock);
+			cpu = smp_processor_id();
+			rdtscl(bclock);
+		}
+	}
+	preempt_enable();
+}
+
+/*
+ * Since we calibrate only once at boot, this
+ * function should be set once at boot and not changed
+ */
+static void (*delay_fn)(unsigned long) = delay_loop;
+
+void use_tsc_delay(void)
+{
+	delay_fn = delay_tsc;
+}
+
+int __devinit read_current_timer(unsigned long *timer_val)
+{
+	if (delay_fn == delay_tsc) {
+		rdtscll(*timer_val);
+		return 0;
+	}
+	return -1;
+}
+
+void __delay(unsigned long loops)
+{
+	delay_fn(loops);
+}
+EXPORT_SYMBOL(__delay);
+
+inline void __const_udelay(unsigned long xloops)
+{
+	int d0;
+
+	xloops *= 4;
+	asm("mull %%edx"
+		:"=d" (xloops), "=&a" (d0)
+		:"1" (xloops), "0"
+		(cpu_data(raw_smp_processor_id()).loops_per_jiffy * (HZ/4)));
+
+	__delay(++xloops);
+}
+EXPORT_SYMBOL(__const_udelay);
+
+void __udelay(unsigned long usecs)
+{
+	__const_udelay(usecs * 0x000010c7); /* 2**32 / 1000000 (rounded up) */
+}
+EXPORT_SYMBOL(__udelay);
+
+void __ndelay(unsigned long nsecs)
+{
+	__const_udelay(nsecs * 0x00005); /* 2**32 / 1000000000 (rounded up) */
+}
+EXPORT_SYMBOL(__ndelay);
diff --git a/arch/x86/lib/delay_32.c b/arch/x86/lib/delay_32.c
deleted file mode 100644
index 0b659a3..0000000
--- a/arch/x86/lib/delay_32.c
+++ /dev/null
@@ -1,138 +0,0 @@
-/*
- *	Precise Delay Loops for i386
- *
- *	Copyright (C) 1993 Linus Torvalds
- *	Copyright (C) 1997 Martin Mares <mj@atrey.karlin.mff.cuni.cz>
- *	Copyright (C) 2008 Jiri Hladky <hladky _dot_ jiri _at_ gmail _dot_ com>
- *
- *	The __delay function must _NOT_ be inlined as its execution time
- *	depends wildly on alignment on many x86 processors. The additional
- *	jump magic is needed to get the timing stable on all the CPU's
- *	we have to worry about.
- */
-
-#include <linux/module.h>
-#include <linux/sched.h>
-#include <linux/timex.h>
-#include <linux/preempt.h>
-#include <linux/delay.h>
-#include <linux/init.h>
-
-#include <asm/processor.h>
-#include <asm/delay.h>
-#include <asm/timer.h>
-
-#ifdef CONFIG_SMP
-# include <asm/smp.h>
-#endif
-
-/* simple loop based delay: */
-static void delay_loop(unsigned long loops)
-{
-	__asm__ __volatile__(
-		"	test %0,%0	\n"
-		"	jz 3f		\n"
-		"	jmp 1f		\n"
-
-		".align 16		\n"
-		"1:	jmp 2f		\n"
-
-		".align 16		\n"
-		"2:	dec %0		\n"
-		"	jnz 2b		\n"
-		"3:	dec %0		\n"
-
-		: /* we don't need output */
-		:"a" (loops)
-	);
-}
-
-/* TSC based delay: */
-static void delay_tsc(unsigned long loops)
-{
-	unsigned long bclock, now;
-	int cpu;
-
-	preempt_disable();
-	cpu = smp_processor_id();
-	rdtscl(bclock);
-	for (;;) {
-		rdtscl(now);
-		if ((now - bclock) >= loops)
-			break;
-
-		/* Allow RT tasks to run */
-		preempt_enable();
-		rep_nop();
-		preempt_disable();
-
-		/*
-		 * It is possible that we moved to another CPU, and
-		 * since TSC's are per-cpu we need to calculate
-		 * that. The delay must guarantee that we wait "at
-		 * least" the amount of time. Being moved to another
-		 * CPU could make the wait longer but we just need to
-		 * make sure we waited long enough. Rebalance the
-		 * counter for this CPU.
-		 */
-		if (unlikely(cpu != smp_processor_id())) {
-			loops -= (now - bclock);
-			cpu = smp_processor_id();
-			rdtscl(bclock);
-		}
-	}
-	preempt_enable();
-}
-
-/*
- * Since we calibrate only once at boot, this
- * function should be set once at boot and not changed
- */
-static void (*delay_fn)(unsigned long) = delay_loop;
-
-void use_tsc_delay(void)
-{
-	delay_fn = delay_tsc;
-}
-
-int __devinit read_current_timer(unsigned long *timer_val)
-{
-	if (delay_fn == delay_tsc) {
-		rdtscll(*timer_val);
-		return 0;
-	}
-	return -1;
-}
-
-void __delay(unsigned long loops)
-{
-	delay_fn(loops);
-}
-
-inline void __const_udelay(unsigned long xloops)
-{
-	int d0;
-
-	xloops *= 4;
-	__asm__("mull %%edx"
-		:"=d" (xloops), "=&a" (d0)
-		:"1" (xloops), "0"
-		(cpu_data(raw_smp_processor_id()).loops_per_jiffy * (HZ/4)));
-
-	__delay(++xloops);
-}
-
-void __udelay(unsigned long usecs)
-{
-	__const_udelay(usecs * 0x000010c7); /* 2**32 / 1000000 (rounded up) */
-}
-
-void __ndelay(unsigned long nsecs)
-{
-	__const_udelay(nsecs * 0x00005); /* 2**32 / 1000000000 (rounded up) */
-}
-
-EXPORT_SYMBOL(__delay);
-EXPORT_SYMBOL(__const_udelay);
-EXPORT_SYMBOL(__udelay);
-EXPORT_SYMBOL(__ndelay);
diff --git a/arch/x86/lib/delay_64.c b/arch/x86/lib/delay_64.c
deleted file mode 100644
index ff3dfec..0000000
--- a/arch/x86/lib/delay_64.c
+++ /dev/null
@@ -1,128 +0,0 @@
-/*
- *	Precise Delay Loops for x86-64
- *
- *	Copyright (C) 1993 Linus Torvalds
- *	Copyright (C) 1997 Martin Mares <mj@atrey.karlin.mff.cuni.cz>
- *
- *	The __delay function must _NOT_ be inlined as its execution time
- *	depends wildly on alignment on many x86 processors. 
- */
-
-#include <linux/module.h>
-#include <linux/sched.h>
-#include <linux/timex.h>
-#include <linux/preempt.h>
-#include <linux/delay.h>
-#include <linux/init.h>
-
-#include <asm/delay.h>
-#include <asm/msr.h>
-
-#ifdef CONFIG_SMP
-#include <asm/smp.h>
-#endif
-
-/* simple loop based delay: */
-static void delay_loop(unsigned long loops)
-{
-	asm volatile(
-		"	test %0,%0	\n"
-		"	jz 3f		\n"
-		"	jmp 1f		\n"
-
-		".align 16		\n"
-		"1:	jmp 2f		\n"
-
-		".align 16		\n"
-		"2:	dec %0		\n"
-		"	jnz 2b		\n"
-		"3:	dec %0		\n"
-
-		: /* we don't need output */
-		:"a" (loops)
-	);
-}
-
-static void delay_tsc(unsigned long loops)
-{
-	unsigned bclock, now;
-	int cpu;
-
-	preempt_disable();
-	cpu = smp_processor_id();
-	rdtscl(bclock);
-	for (;;) {
-		rdtscl(now);
-		if ((now - bclock) >= loops)
-			break;
-
-		/* Allow RT tasks to run */
-		preempt_enable();
-		rep_nop();
-		preempt_disable();
-
-		/*
-		 * It is possible that we moved to another CPU, and
-		 * since TSC's are per-cpu we need to calculate
-		 * that. The delay must guarantee that we wait "at
-		 * least" the amount of time. Being moved to another
-		 * CPU could make the wait longer but we just need to
-		 * make sure we waited long enough. Rebalance the
-		 * counter for this CPU.
-		 */
-		if (unlikely(cpu != smp_processor_id())) {
-			loops -= (now - bclock);
-			cpu = smp_processor_id();
-			rdtscl(bclock);
-		}
-	}
-	preempt_enable();
-}
-
-static void (*delay_fn)(unsigned long) = delay_loop;
-
-void use_tsc_delay(void)
-{
-	delay_fn = delay_tsc;
-}
-
-int __devinit read_current_timer(unsigned long *timer_value)
-{
-	if (delay_fn == delay_tsc) {
-		rdtscll(*timer_value);
-		return 0;
-	}
-	return -1;
-}
-
-void __delay(unsigned long loops)
-{
-	delay_fn(loops);
-}
-EXPORT_SYMBOL(__delay);
-
-inline void __const_udelay(unsigned long xloops)
-{
-	int d0;
-	xloops *= 4;
-	__asm__("mull %%edx"
-		:"=d" (xloops), "=&a" (d0)
-		:"1" (xloops), "0"
-		(cpu_data(raw_smp_processor_id()).loops_per_jiffy * (HZ/4)));
-
-	__delay(++xloops);
-}
-
-EXPORT_SYMBOL(__const_udelay);
-
-void __udelay(unsigned long usecs)
-{
-	__const_udelay(usecs * 0x000010c7);  /* 2**32 / 1000000 (rounded up) */
-}
-EXPORT_SYMBOL(__udelay);
-
-void __ndelay(unsigned long nsecs)
-{
-	__const_udelay(nsecs * 0x00005);  /* 2**32 / 1000000000 (rounded up) */
-}
-EXPORT_SYMBOL(__ndelay);
-- 
1.5.5.1

