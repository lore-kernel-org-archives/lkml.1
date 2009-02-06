Return-Path: <linux-kernel-owner+w=401wt.eu-S1754345AbZBFIvJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754345AbZBFIvJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 03:51:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752330AbZBFIuy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 03:50:54 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:47846 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752288AbZBFIux (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 03:50:53 -0500
Message-ID: <498BF9DA.5030302@openvz.org>
Date: Fri, 06 Feb 2009 11:50:34 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kirill Korotaev <dev@openvz.org>
Subject: [PATCH] x86: fix hpet timer reinit for x86_64 (v2)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for late response - took some time to re-check this...

There's a small problem with hpet_rtc_reinit function - it checks
for the
	hpet_readl(HPET_COUNTER) - hpet_t1_cmp > 0
to continue increasing both the HPET_T1_CMP (register) and the 
hpet_t1_cmp (variable).

But since the HPET_COUNTER is always 32-bit, if the hpet_t1_cmp
is 64-bit this condition will always be FALSE once the latter hits
the 32-bit boundary, and we can have a situation, when we don't
increase the HPET_T1_CMP register high enough.

The result - timer stops ticking, since HPET_T1_CMP becomes less, 
than the COUNTER and never increased again. Symptoms were observed
in user space. An application doing read() on /dev/rtc blocked 
sometimes for a long periods of time (as turned out - until the
counter gets wrap around).

The fix is to properly check for one counter being ahead of another
the way it's done for jiffies.

Plush, change the hpet_t1_cmp to u32 to save 4 bytes from .bss ;)

Reported-by: Kirill Korotaev <dev@openvz.org>
Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 64d5ad0..388254f 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -897,7 +897,7 @@ static unsigned long hpet_rtc_flags;
 static int hpet_prev_update_sec;
 static struct rtc_time hpet_alarm_time;
 static unsigned long hpet_pie_count;
-static unsigned long hpet_t1_cmp;
+static u32 hpet_t1_cmp;
 static unsigned long hpet_default_delta;
 static unsigned long hpet_pie_delta;
 static unsigned long hpet_pie_limit;
@@ -905,6 +905,14 @@ static unsigned long hpet_pie_limit;
 static rtc_irq_handler irq_handler;
 
 /*
+ * Check that the hpet counter c1 is ahead of the c2
+ */
+static inline int hpet_cnt_ahead(u32 c1, u32 c2)
+{
+	return (s32)(c2 - c1) < 0;
+}
+
+/*
  * Registers a IRQ handler.
  */
 int hpet_register_irq_handler(rtc_irq_handler handler)
@@ -1075,7 +1083,7 @@ static void hpet_rtc_timer_reinit(void)
 		hpet_t1_cmp += delta;
 		hpet_writel(hpet_t1_cmp, HPET_T1_CMP);
 		lost_ints++;
-	} while ((long)(hpet_readl(HPET_COUNTER) - hpet_t1_cmp) > 0);
+	} while (!hpet_cnt_ahead(hpet_t1_cmp, hpet_readl(HPET_COUNTER)));
 
 	if (lost_ints) {
 		if (hpet_rtc_flags & RTC_PIE)
