Return-Path: <linux-kernel-owner+w=401wt.eu-S1761551AbZJIWjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761551AbZJIWjk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 18:39:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756535AbZJIWjj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 18:39:39 -0400
Received: from kroah.org ([198.145.64.141]:55018 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761521AbZJIWji (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 18:39:38 -0400
Subject: patch pit-fixes-to-unbreak-suspend-resume.patch added to 2.6.31-stable tree
To: johnstul@us.ibm.com, linux-kernel@vger.kernel.org, tglx@linutronix.de
Cc: <stable@kernel.org>, <stable-commits@vger.kernel.org>
From: <gregkh@suse.de>
Date: Fri, 09 Oct 2009 15:35:21 -0700
In-Reply-To: <1255033906.4846.12.camel@localhost.localdomain>
Message-Id: <20091009223822.9A5B348A43@coco.kroah.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that we have just queued up the patch titled

    Subject: PIT fixes to unbreak suspend/resume (bug #14222)

to the 2.6.31-stable tree.  Its filename is

    pit-fixes-to-unbreak-suspend-resume.patch

A git repo of this tree can be found at 
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary


>From johnstul@us.ibm.com  Fri Oct  9 15:32:22 2009
From: john stultz <johnstul@us.ibm.com>
Date: Thu, 08 Oct 2009 13:31:45 -0700
Subject: PIT fixes to unbreak suspend/resume (bug #14222)
To: stable@kernel.org, lkml <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux@rainbow-software.org
Message-ID: <1255033906.4846.12.camel@localhost.localdomain>

From: john stultz <johnstul@us.ibm.com>

Resolved differently upstream in commit 8cab02dc3c58a12235c6d463ce684dded9696848

Ondrej Zary reported a suspend/resume hang with 2.6.31 in bug #14222.

http://bugzilla.kernel.org/show_bug.cgi?id=14222

The hang was bisected to c7121843685de2bf7f3afd3ae1d6a146010bf1fc
however, that was really just the last straw that caused the issue.

The problem was that on suspend, the PIT is removed as a clocksource,
and was using the mult value essentially as a is_enabled() flag. The
mult adjustments done in the commit above caused that usage to break,
causing bad list manipulation and the oops.

Further, on resume, the PIT clocksource is never restored, causing the
system to run in a degraded mode with jiffies as the clocksource.

This issue has since been resolved in 2.6.32-rc by commit
8cab02dc3c58a12235c6d463ce684dded9696848 which removes the clocksource
disabling on suspend. Testing shows no issues there.

So the following patch rectifies the situation for 2.6.31 users of the
PIT clocksource that use suspend and resume (which is probably not that
many).

Many thanks to Ondrej for helping narrow down what was happening, what
caused it, and verifying the fix.

---------------

Avoid using the unprotected clocksource.mult value as an "is_registered"
flag, instead us an explicit flag variable. This avoids possible list
corruption if the clocksource is double-unregistered.

Also re-register the PIT clocksource on resume so folks don't have to
use jiffies after suspend.


Signed-off-by: John Stultz <johnstul@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/i8253.c |   27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

--- a/arch/x86/kernel/i8253.c
+++ b/arch/x86/kernel/i8253.c
@@ -21,8 +21,10 @@ EXPORT_SYMBOL(i8253_lock);
 
 #ifdef CONFIG_X86_32
 static void pit_disable_clocksource(void);
+static void pit_enable_clocksource(void);
 #else
 static inline void pit_disable_clocksource(void) { }
+static inline void pit_enable_clocksource(void) { }
 #endif
 
 /*
@@ -67,7 +69,7 @@ static void init_pit_timer(enum clock_ev
 		break;
 
 	case CLOCK_EVT_MODE_RESUME:
-		/* Nothing to do here */
+		pit_enable_clocksource();
 		break;
 	}
 	spin_unlock(&i8253_lock);
@@ -200,19 +202,27 @@ static struct clocksource pit_cs = {
 	.shift		= 20,
 };
 
+int pit_cs_registered;
 static void pit_disable_clocksource(void)
 {
-	/*
-	 * Use mult to check whether it is registered or not
-	 */
-	if (pit_cs.mult) {
+	if (pit_cs_registered) {
 		clocksource_unregister(&pit_cs);
-		pit_cs.mult = 0;
+		pit_cs_registered = 0;
+	}
+}
+
+static void pit_enable_clocksource(void)
+{
+	if (!pit_cs_registered && !clocksource_register(&pit_cs)) {
+		pit_cs_registered = 1;
 	}
 }
 
+
+
 static int __init init_pit_clocksource(void)
 {
+	int ret;
 	 /*
 	  * Several reasons not to register PIT as a clocksource:
 	  *
@@ -226,7 +236,10 @@ static int __init init_pit_clocksource(v
 
 	pit_cs.mult = clocksource_hz2mult(CLOCK_TICK_RATE, pit_cs.shift);
 
-	return clocksource_register(&pit_cs);
+	ret = clocksource_register(&pit_cs);
+	if (!ret)
+		pit_cs_registered = 1;
+	return ret;
 }
 arch_initcall(init_pit_clocksource);
 


Patches currently in stable-queue which might be from johnstul@us.ibm.com are

queue-2.6.31/futex-fix-requeue_pi-key-imbalance.patch
queue-2.6.31/pit-fixes-to-unbreak-suspend-resume.patch
