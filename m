Return-Path: <linux-kernel-owner+w=401wt.eu-S1755591AbZDVPo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755591AbZDVPo3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 11:44:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752735AbZDVPoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 11:44:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:52333 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752547AbZDVPoS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 11:44:18 -0400
Date: Wed, 22 Apr 2009 15:42:30 GMT
From: tip-bot for Coly Li <coly.li@suse.de>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       hugh@veritas.com, sivanich@sgi.com, coly.li@suse.de,
       akpm@linux-foundation.org, damm@igel.co.jp, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       hugh@veritas.com, coly.li@suse.de, sivanich@sgi.com,
       akpm@linux-foundation.org, damm@igel.co.jp, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <49EF3614.1050806@suse.de>
References: <49EF3614.1050806@suse.de>
Subject: [tip:x86/urgent] uv_time: add parameter to uv_read_rtc()
Message-ID: <tip-c5428e950ad42640f00092949fd17e356dfdeafa@git.kernel.org>
Git-Commit-ID: c5428e950ad42640f00092949fd17e356dfdeafa
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 22 Apr 2009 15:42:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c5428e950ad42640f00092949fd17e356dfdeafa
Gitweb:     http://git.kernel.org/tip/c5428e950ad42640f00092949fd17e356dfdeafa
Author:     Coly Li <coly.li@suse.de>
AuthorDate: Wed, 22 Apr 2009 23:21:56 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 22 Apr 2009 17:41:25 +0200

uv_time: add parameter to uv_read_rtc()

uv_read_rtc() is referenced by read member of struct clocksource clocksource_uv.
In include/linux/clocksource.h, read of struct clocksource is declared as:
cycle_t (*read)(struct clocksource *cs)

This got introduced recently in:

   8e19608: clocksource: pass clocksource to read() callback

But arch/x86/kernel/uv_time.c was not properly converted by that pach.

This patch adds a dummy parameter (struct clocksource type) to uv_read_rtc() to
fix the incompatible reference in clocksource_uv, and add a NULL parameter in
all places where uv_read_rtc() gets called.

[ Impact: cleanup, address compiler warning ]

Signed-off-by: Coly Li <coly.li@suse.de>
Cc: Dimitri Sivanich <sivanich@sgi.com>
Cc: Magnus Damm <damm@igel.co.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hugh@veritas.com>
LKML-Reference: <49EF3614.1050806@suse.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
