Return-Path: <linux-kernel-owner+w=401wt.eu-S1756911AbYE0RYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911AbYE0RYx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 13:24:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752629AbYE0RYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 13:24:43 -0400
Received: from mail.windriver.com ([147.11.1.11]:33700 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752219AbYE0RYm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 13:24:42 -0400
Message-ID: <483C4391.8040002@windriver.com>
Date: Tue, 27 May 2008 12:23:29 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, a.p.zijlstra@chello.nl
Subject: [PATCH] softlockup: fix NMI hangs due to lock race - 2.6.26-rc regression
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 May 2008 17:23:24.0166 (UTC) FILETIME=[5E2DA260:01C8C01E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The touch_nmi_watchdog() routine on x86 ultimately calls
touch_softlockup_watchdog().  The problem is that to touch the
softlockup watchdog, the cpu_clock code has to be called which could
involve multiple cpu locks and can lead to a hard hang if one of the
locks is held by a processor that is not going to return anytime soon
(such as could be the case with kgdb or perhaps even with some other
kind of exception).

This patch causes the public version of the
touch_softlockup_watchdog() to defer the cpu clock access to a later
point.

The test case for this problem is to use the following kernel config
options:

CONFIG_KGDB_TESTS=y
CONFIG_KGDB_TESTS_ON_BOOT=y
CONFIG_KGDB_TESTS_BOOT_STRING="V1F100I100000"

It should be noted that kgdb test suite and these options were not
available until 2.6.26-rc2, so it was necessary to patch the kgdb 
test suite during the bisection.

I would consider this patch a regression fix because the problem first
appeared in commit 27ec4407790d075c325e1f4da0a19c56953cce23 when some
logic was added to try to periodically sync the clocks.  It was
possible to work around this particular problem by simply not
performing the sync anytime the system was in a critical context.
This was ok until commit 3e51f33fcc7f55e6df25d15b55ed10c8b4da84cd,
which added config option CONFIG_HAVE_UNSTABLE_SCHED_CLOCK and some
multi-cpu locks to sync the clocks.  It became clear that accessing
this code from an nmi was the source of the lockups.  Avoiding the
access to the low level clock code from an code inside the NMI
processing also fixed the problem with the 27ec44... commit.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>

---
 kernel/softlockup.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/kernel/softlockup.c
+++ b/kernel/softlockup.c
@@ -49,12 +49,17 @@ static unsigned long get_timestamp(int t
 	return cpu_clock(this_cpu) >> 30LL;  /* 2^30 ~= 10^9 */
 }
 
-void touch_softlockup_watchdog(void)
+static void __touch_softlockup_watchdog(void)
 {
 	int this_cpu = raw_smp_processor_id();
 
 	__raw_get_cpu_var(touch_timestamp) = get_timestamp(this_cpu);
 }
+
+void touch_softlockup_watchdog(void)
+{
+	__raw_get_cpu_var(touch_timestamp) = 0;
+}
 EXPORT_SYMBOL(touch_softlockup_watchdog);
 
 void touch_all_softlockup_watchdogs(void)
@@ -80,7 +85,7 @@ void softlockup_tick(void)
 	unsigned long now;
 
 	if (touch_timestamp == 0) {
-		touch_softlockup_watchdog();
+		__touch_softlockup_watchdog();
 		return;
 	}
 
@@ -95,7 +100,7 @@ void softlockup_tick(void)
 
 	/* do not print during early bootup: */
 	if (unlikely(system_state != SYSTEM_RUNNING)) {
-		touch_softlockup_watchdog();
+		__touch_softlockup_watchdog();
 		return;
 	}
 
@@ -214,7 +219,7 @@ static int watchdog(void *__bind_cpu)
 	sched_setscheduler(current, SCHED_FIFO, &param);
 
 	/* initialize timestamp */
-	touch_softlockup_watchdog();
+	__touch_softlockup_watchdog();
 
 	set_current_state(TASK_INTERRUPTIBLE);
 	/*
@@ -223,7 +228,7 @@ static int watchdog(void *__bind_cpu)
 	 * debug-printout triggers in softlockup_tick().
 	 */
 	while (!kthread_should_stop()) {
-		touch_softlockup_watchdog();
+		__touch_softlockup_watchdog();
 		schedule();
 
 		if (kthread_should_stop())
