Return-Path: <linux-kernel-owner+w=401wt.eu-S1753954Ab0AZOKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954Ab0AZOKj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 09:10:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753536Ab0AZOKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 09:10:38 -0500
Received: from hera.kernel.org ([140.211.167.34]:52881 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751822Ab0AZOKh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 09:10:37 -0500
Date: Tue, 26 Jan 2010 14:09:45 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       johnstul@us.ibm.com, jason.wessel@windriver.com, schwidefsky@de.ibm.com,
       akpm@linux-foundation.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, jason.wessel@windriver.com,
       johnstul@us.ibm.com, schwidefsky@de.ibm.com, tglx@linutronix.de
In-Reply-To: <1264480000-6997-4-git-send-email-jason.wessel@windriver.com>
References: <1264480000-6997-4-git-send-email-jason.wessel@windriver.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] clocksource: Prevent potential kgdb dead lock
Message-ID: <tip-7b7422a566aa0dc1e582ce263d4c7ff4a772700a@git.kernel.org>
Git-Commit-ID: 7b7422a566aa0dc1e582ce263d4c7ff4a772700a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 26 Jan 2010 14:09:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7b7422a566aa0dc1e582ce263d4c7ff4a772700a
Gitweb:     http://git.kernel.org/tip/7b7422a566aa0dc1e582ce263d4c7ff4a772700a
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue, 26 Jan 2010 12:51:10 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 26 Jan 2010 14:53:16 +0100

clocksource: Prevent potential kgdb dead lock

commit 0f8e8ef7 (clocksource: Simplify clocksource watchdog resume
logic) introduced a potential kgdb dead lock. When the kernel is
stopped by kgdb inside code which holds watchdog_lock then kgdb dead
locks in clocksource_resume_watchdog().

clocksource_resume_watchdog() is called from kbdg via
clocksource_touch_watchdog() to avoid that the clock source watchdog
marks TSC unstable after the kernel has been stopped.

Solve this by replacing spin_lock with a spin_trylock and just return
in case the lock is held. Not resetting the watchdog might result in
TSC becoming marked unstable, but that's an acceptable penalty for
using kgdb.

The timekeeping is anyway easily screwed up by kgdb when the system
uses either jiffies or a clock source which wraps in short intervals
(e.g. pm_timer wraps about every 4.6s), so we really do not have to
worry about that occasional TSC marked unstable side effect.

The second caller of clocksource_resume_watchdog() is
clocksource_resume(). The trylock is safe here as well because the
system is UP at this point, interrupts are disabled and nothing else
can hold watchdog_lock().

Reported-by: Jason Wessel <jason.wessel@windriver.com>
LKML-Reference: <1264480000-6997-4-git-send-email-jason.wessel@windriver.com>
Cc: kgdb-bugreport@lists.sourceforge.net
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/clocksource.c |   18 +++++++++++++++---
 1 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index e85c234..1370083 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -343,7 +343,19 @@ static void clocksource_resume_watchdog(void)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&watchdog_lock, flags);
+	/*
+	 * We use trylock here to avoid a potential dead lock when
+	 * kgdb calls this code after the kernel has been stopped with
+	 * watchdog_lock held. When watchdog_lock is held we just
+	 * return and accept, that the watchdog might trigger and mark
+	 * the monitored clock source (usually TSC) unstable.
+	 *
+	 * This does not affect the other caller clocksource_resume()
+	 * because at this point the kernel is UP, interrupts are
+	 * disabled and nothing can hold watchdog_lock.
+	 */
+	if (!spin_trylock_irqsave(&watchdog_lock, flags))
+		return;
 	clocksource_reset_watchdog();
 	spin_unlock_irqrestore(&watchdog_lock, flags);
 }
@@ -458,8 +470,8 @@ void clocksource_resume(void)
  * clocksource_touch_watchdog - Update watchdog
  *
  * Update the watchdog after exception contexts such as kgdb so as not
- * to incorrectly trip the watchdog.
- *
+ * to incorrectly trip the watchdog. This might fail when the kernel
+ * was stopped in code which holds watchdog_lock.
  */
 void clocksource_touch_watchdog(void)
 {
