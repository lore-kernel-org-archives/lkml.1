Return-Path: <linux-kernel-owner+w=401wt.eu-S932436AbXHJWGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932436AbXHJWGi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 18:06:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754374AbXHJWBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 18:01:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57712 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754653AbXHJWBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 18:01:11 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au, ak@suse.de,
       mingo@elte.hu, chrisw@sous-sol.org, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       lguest@ozlabs.org, glommer@gmail.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 19/25 -v2] time-related functions paravirt provisions
Date: Fri, 10 Aug 2007 16:12:31 -0300
Message-Id: <11867732511513-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11867732461037-git-send-email-gcosta@redhat.com>
References: <1186773157329-git-send-email-gcosta@redhat.com> <11867731633002-git-send-email-gcosta@redhat.com> <11867731681763-git-send-email-gcosta@redhat.com> <11867731732274-git-send-email-gcosta@redhat.com> <11867731781610-git-send-email-gcosta@redhat.com> <11867731831138-git-send-email-gcosta@redhat.com> <11867731882768-git-send-email-gcosta@redhat.com> <11867731932688-git-send-email-gcosta@redhat.com> <11867731981891-git-send-email-gcosta@redhat.com> <1186773203887-git-send-email-gcosta@redhat.com> <11867732082735-git-send-email-gcosta@redhat.com> <11867732121974-git-send-email-gcosta@redhat.com> <1186773217875-git-send-email-gcosta@redhat.com> <11867732221652-git-send-email-gcosta@redhat.com> <11867732273108-git-send-email-gcosta@redhat.com> <11867732323106-git-send-email-gcosta@redhat.com> <11867732373232-git-send-email-gcosta@redhat.com> <11867732424024-git-send-email-gcosta@redhat.com> <11867732461037-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add provisions for time related functions so they
can be later replaced by paravirt versions.

it basically encloses {g,s}et_wallclock inside the
already existent functions update_persistent_clock and
read_persistent_clock, and defines {s,g}et_wallclock
to the core of such functions.

The timer interrupt setup also have to be replaced.
The job is done by time_init_hook().

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86_64/kernel/time.c |   37 +++++++++++++++++++++++++------------
 include/asm-x86_64/time.h |   18 ++++++++++++++++++
 2 files changed, 43 insertions(+), 12 deletions(-)

diff --git a/arch/x86_64/kernel/time.c b/arch/x86_64/kernel/time.c
index 6d48a4e..29fcd91 100644
--- a/arch/x86_64/kernel/time.c
+++ b/arch/x86_64/kernel/time.c
@@ -42,6 +42,7 @@
 #include <asm/sections.h>
 #include <linux/hpet.h>
 #include <asm/apic.h>
+#include <asm/time.h>
 #include <asm/hpet.h>
 #include <asm/mpspec.h>
 #include <asm/nmi.h>
@@ -82,18 +83,12 @@ EXPORT_SYMBOL(profile_pc);
  * sheet for details.
  */
 
-static int set_rtc_mmss(unsigned long nowtime)
+int do_set_rtc_mmss(unsigned long nowtime)
 {
 	int retval = 0;
 	int real_seconds, real_minutes, cmos_minutes;
 	unsigned char control, freq_select;
 
-/*
- * IRQs are disabled when we're called from the timer interrupt,
- * no need for spin_lock_irqsave()
- */
-
-	spin_lock(&rtc_lock);
 
 /*
  * Tell the clock it's being set and stop it.
@@ -143,14 +138,22 @@ static int set_rtc_mmss(unsigned long nowtime)
 	CMOS_WRITE(control, RTC_CONTROL);
 	CMOS_WRITE(freq_select, RTC_FREQ_SELECT);
 
-	spin_unlock(&rtc_lock);
-
 	return retval;
 }
 
 int update_persistent_clock(struct timespec now)
 {
-	return set_rtc_mmss(now.tv_sec);
+	int retval;
+
+/*
+ * IRQs are disabled when we're called from the timer interrupt,
+ * no need for spin_lock_irqsave()
+ */
+	spin_lock(&rtc_lock);
+	retval = set_wallclock(now.tv_sec);
+	spin_unlock(&rtc_lock);
+
+	return retval;
 }
 
 void main_timer_handler(void)
@@ -195,7 +198,7 @@ static irqreturn_t timer_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-unsigned long read_persistent_clock(void)
+unsigned long do_get_cmos_time(void)
 {
 	unsigned int year, mon, day, hour, min, sec;
 	unsigned long flags;
@@ -246,6 +249,11 @@ unsigned long read_persistent_clock(void)
 	return mktime(year, mon, day, hour, min, sec);
 }
 
+unsigned long read_persistent_clock(void)
+{
+	return get_wallclock();
+}
+
 /* calibrate_cpu is used on systems with fixed rate TSCs to determine
  * processor frequency */
 #define TICK_COUNT 100000000
@@ -365,6 +373,11 @@ static struct irqaction irq0 = {
 	.name		= "timer"
 };
 
+inline void time_init_hook()
+{
+	setup_irq(0, &irq0);
+}
+
 void __init time_init(void)
 {
 	if (nohpet)
@@ -403,7 +416,7 @@ void __init time_init(void)
 		cpu_khz / 1000, cpu_khz % 1000);
 	init_tsc_clocksource();
 
-	setup_irq(0, &irq0);
+	do_time_init();
 }
 
 /*
diff --git a/include/asm-x86_64/time.h b/include/asm-x86_64/time.h
new file mode 100644
index 0000000..9a72355
--- /dev/null
+++ b/include/asm-x86_64/time.h
@@ -0,0 +1,18 @@
+#ifndef _ASM_X86_64_TIME_H
+#define _ASM_X86_64_TIME_H
+
+inline void time_init_hook(void);
+unsigned long do_get_cmos_time(void);
+int do_set_rtc_mmss(unsigned long nowtime);
+
+#ifdef CONFIG_PARAVIRT
+#include <asm/paravirt.h>
+#else /* !CONFIG_PARAVIRT */
+
+#define get_wallclock() do_get_cmos_time()
+#define set_wallclock(x) do_set_rtc_mmss(x)
+#define do_time_init() time_init_hook()
+
+#endif /* CONFIG_PARAVIRT */
+
+#endif
-- 
1.4.4.2

