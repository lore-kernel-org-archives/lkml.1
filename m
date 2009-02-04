Return-Path: <linux-kernel-owner+w=401wt.eu-S1754834AbZBDKkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834AbZBDKkv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 05:40:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752009AbZBDKkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 05:40:43 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:40815 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751816AbZBDKkm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 05:40:42 -0500
Message-ID: <4989709F.1050207@openvz.org>
Date: Wed, 04 Feb 2009 13:40:31 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kirill Korotaev <dev@openvz.org>
Subject: [PATCH] x86: fix hpet timer reinit for x86_64
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
than the COUNTER and never increased again.

The solution is to cut the upper 32-bit from the hpet_t1_cmp
variable to make the comparison to HPET_COUNTER correct.

Reported-by: Kirill Korotaev <dev@openvz.org>
Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 64d5ad0..ec319d1 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -1075,7 +1075,7 @@ static void hpet_rtc_timer_reinit(void)
 		hpet_t1_cmp += delta;
 		hpet_writel(hpet_t1_cmp, HPET_T1_CMP);
 		lost_ints++;
-	} while ((long)(hpet_readl(HPET_COUNTER) - hpet_t1_cmp) > 0);
+	} while ((long)(hpet_readl(HPET_COUNTER) - (u32)hpet_t1_cmp) > 0);
 
 	if (lost_ints) {
 		if (hpet_rtc_flags & RTC_PIE)
