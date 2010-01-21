Return-Path: <linux-kernel-owner+w=401wt.eu-S1754543Ab0AUNzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543Ab0AUNzz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 08:55:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751987Ab0AUNzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 08:55:52 -0500
Received: from hera.kernel.org ([140.211.167.34]:46414 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753932Ab0AUNzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 08:55:33 -0500
Date: Thu, 21 Jan 2010 13:54:58 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1263374859.4244.192.camel@laptop>
References: <1263374859.4244.192.camel@laptop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Fix perf_event_do_pending() fallback callsite
Message-ID: <tip-fe432200abb0d64f409895168d9ad8fbb9d8e6c6@git.kernel.org>
Git-Commit-ID: fe432200abb0d64f409895168d9ad8fbb9d8e6c6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 21 Jan 2010 13:54:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fe432200abb0d64f409895168d9ad8fbb9d8e6c6
Gitweb:     http://git.kernel.org/tip/fe432200abb0d64f409895168d9ad8fbb9d8e6c6
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 18 Jan 2010 09:08:26 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 21 Jan 2010 13:40:39 +0100

perf: Fix perf_event_do_pending() fallback callsite

Paul questioned the context in which we should call
perf_event_do_pending(). After looking at that I found that it should be
called from IRQ context these days, however the fallback call-site is
placed in softirq context. Ammend this by placing the callback in the IRQ
timer path.

Reported-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1263374859.4244.192.camel@laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/timer.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index 15533b7..c61a794 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1198,6 +1198,7 @@ void update_process_times(int user_tick)
 	run_local_timers();
 	rcu_check_callbacks(cpu, user_tick);
 	printk_tick();
+	perf_event_do_pending();
 	scheduler_tick();
 	run_posix_cpu_timers(p);
 }
@@ -1209,8 +1210,6 @@ static void run_timer_softirq(struct softirq_action *h)
 {
 	struct tvec_base *base = __get_cpu_var(tvec_bases);
 
-	perf_event_do_pending();
-
 	hrtimer_run_pending();
 
 	if (time_after_eq(jiffies, base->timer_jiffies))
