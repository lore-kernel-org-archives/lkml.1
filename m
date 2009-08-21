Return-Path: <linux-kernel-owner+w=401wt.eu-S1755598AbZHUTTD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598AbZHUTTD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 15:19:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754734AbZHUTTC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 15:19:02 -0400
Received: from hera.kernel.org ([140.211.167.34]:56139 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754688AbZHUTTB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 15:19:01 -0400
Date: Fri, 21 Aug 2009 19:18:35 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       johnstul@us.ibm.com, schwidefsky@de.ibm.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       johnstul@us.ibm.com, schwidefsky@de.ibm.com, tglx@linutronix.de
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:timers/core] x86: Do not unregister PIT clocksource on PIT oneshot setup/shutdown
Message-ID: <tip-8cab02dc3c58a12235c6d463ce684dded9696848@git.kernel.org>
Git-Commit-ID: 8cab02dc3c58a12235c6d463ce684dded9696848
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 21 Aug 2009 19:18:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8cab02dc3c58a12235c6d463ce684dded9696848
Gitweb:     http://git.kernel.org/tip/8cab02dc3c58a12235c6d463ce684dded9696848
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 20 Aug 2009 18:19:45 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 21 Aug 2009 21:13:37 +0200

x86: Do not unregister PIT clocksource on PIT oneshot setup/shutdown

This basically reverts commit 1a0c009ac (x86: unregister PIT
clocksource when PIT is disabled) because the problem which was tried
to address with that patch has been solved by commit 3f68535ada
(clocksource: sanity check sysfs clocksource changes).

The problem addressed by the original patch is that PIT could be
selected as clocksource after the system switched the PIT off or set
the PIT into one shot mode which would result in complete timekeeping
wreckage.

Now with the sysfs sanity check in place PIT cannot be selected again
when the system is in oneshot mode. The system will not switch to one
shot mode as long as PIT is installed because PIT is not suitable for
one shot.

The shutdown case which happens when the lapic timer is installed is
covered by the fact that init_pit_clocksource() is called after the
lapic timer take over and then does not install the PIT clocksource
at all.

We should have done the sanity checks back then, but ...

This also solves the locking problem which was reported vs. the
clocksource rework.

LKML-Reference: <new-submission>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>


---
 arch/x86/kernel/i8253.c |   19 -------------------
 1 files changed, 0 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kernel/i8253.c b/arch/x86/kernel/i8253.c
index 5cf36c0..23c1679 100644
--- a/arch/x86/kernel/i8253.c
+++ b/arch/x86/kernel/i8253.c
@@ -19,12 +19,6 @@
 DEFINE_SPINLOCK(i8253_lock);
 EXPORT_SYMBOL(i8253_lock);
 
-#ifdef CONFIG_X86_32
-static void pit_disable_clocksource(void);
-#else
-static inline void pit_disable_clocksource(void) { }
-#endif
-
 /*
  * HPET replaces the PIT, when enabled. So we need to know, which of
  * the two timers is used
@@ -57,12 +51,10 @@ static void init_pit_timer(enum clock_event_mode mode,
 			outb_pit(0, PIT_CH0);
 			outb_pit(0, PIT_CH0);
 		}
-		pit_disable_clocksource();
 		break;
 
 	case CLOCK_EVT_MODE_ONESHOT:
 		/* One shot setup */
-		pit_disable_clocksource();
 		outb_pit(0x38, PIT_MODE);
 		break;
 
@@ -200,17 +192,6 @@ static struct clocksource pit_cs = {
 	.shift		= 20,
 };
 
-static void pit_disable_clocksource(void)
-{
-	/*
-	 * Use mult to check whether it is registered or not
-	 */
-	if (pit_cs.mult) {
-		clocksource_unregister(&pit_cs);
-		pit_cs.mult = 0;
-	}
-}
-
 static int __init init_pit_clocksource(void)
 {
 	 /*
