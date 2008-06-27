Return-Path: <linux-kernel-owner+w=401wt.eu-S1764352AbYF0Vib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764352AbYF0Vib (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 17:38:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761103AbYF0VhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 17:37:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59068 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764201AbYF0VhH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 17:37:07 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@elte.hu, x86@kernel.org
Subject: [PATCH 02/39] provide delay loop for x86_64
Date: Fri, 27 Jun 2008 18:34:09 -0300
Message-Id: <1214602486-17080-3-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1214602486-17080-2-git-send-email-gcosta@redhat.com>
References: <1214602486-17080-1-git-send-email-gcosta@redhat.com>
 <1214602486-17080-2-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is for consistency with i386. We call use_tsc_delay()
at tsc initialization for x86_64, so we'll be always using it.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/tsc_64.c |    1 +
 arch/x86/lib/delay_64.c  |   44 ++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 41 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/tsc_64.c b/arch/x86/kernel/tsc_64.c
index 9898fb0..36ac46f 100644
--- a/arch/x86/kernel/tsc_64.c
+++ b/arch/x86/kernel/tsc_64.c
@@ -258,6 +258,7 @@ void __init tsc_calibrate(void)
 out:
 	for_each_possible_cpu(cpu)
 		set_cyc2ns_scale(tsc_khz, cpu);
+	use_tsc_delay();
 }
 
 /*
diff --git a/arch/x86/lib/delay_64.c b/arch/x86/lib/delay_64.c
index 4c441be..d0326d0 100644
--- a/arch/x86/lib/delay_64.c
+++ b/arch/x86/lib/delay_64.c
@@ -22,13 +22,28 @@
 #include <asm/smp.h>
 #endif
 
-int __devinit read_current_timer(unsigned long *timer_value)
+/* simple loop based delay: */
+static void delay_loop(unsigned long loops)
 {
-	rdtscll(*timer_value);
-	return 0;
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
 }
 
-void __delay(unsigned long loops)
+static void delay_tsc(unsigned long loops)
 {
 	unsigned bclock, now;
 	int cpu;
@@ -63,6 +78,27 @@ void __delay(unsigned long loops)
 	}
 	preempt_enable();
 }
+
+static void (*delay_fn)(unsigned long) = delay_loop;
+
+void use_tsc_delay(void)
+{
+	delay_fn = delay_tsc;
+}
+
+int __devinit read_current_timer(unsigned long *timer_value)
+{
+	if (delay_fn == delay_tsc) {
+		rdtscll(*timer_value);
+		return 0;
+	}
+	return -1;
+}
+
+void __delay(unsigned long loops)
+{
+	delay_fn(loops);
+}
 EXPORT_SYMBOL(__delay);
 
 inline void __const_udelay(unsigned long xloops)
-- 
1.5.5.1

