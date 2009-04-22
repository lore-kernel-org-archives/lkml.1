Return-Path: <linux-kernel-owner+w=401wt.eu-S1754304AbZDVPVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304AbZDVPVo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 11:21:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752289AbZDVPVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 11:21:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45710 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751502AbZDVPVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 11:21:30 -0400
Message-ID: <49EF3614.1050806@suse.de>
Date: Wed, 22 Apr 2009 23:21:56 +0800
From: Coly Li <coly.li@suse.de>
Reply-To: coly.li@suse.de
Organization: SuSE Labs
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Cc: Dimitri Sivanich <sivanich@sgi.com>
Subject: [PATCH] uv_time: add parameter to uv_read_rtc()
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

uv_read_rtc() is referenced by read member of struct clocksource clocksource_uv.
In include/linux/clocksource.h, read of struct clocksource is declared as:
cycle_t (*read)(struct clocksource *cs)

This patch adds a dummy parameter (struct clocksource type) to uv_read_rtc() to
fix the incompatible reference in clocksource_uv, and add a NULL parameter in
all places where uv_read_rtc() gets called.

Signed-off-by: Coly Li <coly.li@suse.de>
Cc: Dimitri Sivanich <sivanich@sgi.com>
---
 arch/x86/kernel/uv_time.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/uv_time.c b/arch/x86/kernel/uv_time.c
index 2ffb6c5..583f11d 100644
--- a/arch/x86/kernel/uv_time.c
+++ b/arch/x86/kernel/uv_time.c
@@ -29,7 +29,7 @@

 #define RTC_NAME		"sgi_rtc"

-static cycle_t uv_read_rtc(void);
+static cycle_t uv_read_rtc(struct clocksource *cs);
 static int uv_rtc_next_event(unsigned long, struct clock_event_device *);
 static void uv_rtc_timer_setup(enum clock_event_mode,
 				struct clock_event_device *);
@@ -123,7 +123,7 @@ static int uv_setup_intr(int cpu, u64 expires)
 	/* Initialize comparator value */
 	uv_write_global_mmr64(pnode, UVH_INT_CMPB, expires);

-	return (expires < uv_read_rtc() && !uv_intr_pending(pnode));
+	return (expires < uv_read_rtc(NULL) && !uv_intr_pending(pnode));
 }

 /*
@@ -256,7 +256,7 @@ static int uv_rtc_unset_timer(int cpu)

 	spin_lock_irqsave(&head->lock, flags);

-	if (head->next_cpu == bcpu && uv_read_rtc() >= *t)
+	if (head->next_cpu == bcpu && uv_read_rtc(NULL) >= *t)
 		rc = 1;

 	*t = ULLONG_MAX;
@@ -278,7 +278,7 @@ static int uv_rtc_unset_timer(int cpu)
 /*
  * Read the RTC.
  */
-static cycle_t uv_read_rtc(void)
+static cycle_t uv_read_rtc(struct clocksource *cs)
 {
 	return (cycle_t)uv_read_local_mmr(UVH_RTC);
 }
@@ -291,7 +291,7 @@ static int uv_rtc_next_event(unsigned long delta,
 {
 	int ced_cpu = cpumask_first(ced->cpumask);

-	return uv_rtc_set_timer(ced_cpu, delta + uv_read_rtc());
+	return uv_rtc_set_timer(ced_cpu, delta + uv_read_rtc(NULL));
 }

 /*

-- 
Coly Li
SuSE Labs
