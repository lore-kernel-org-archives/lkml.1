Return-Path: <linux-kernel-owner+w=401wt.eu-S1753964Ab0AaR0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964Ab0AaR0k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 12:26:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753619Ab0AaR0j
	(ORCPT <rfc822;linux-kernel-outgoing-6734>);
	Sun, 31 Jan 2010 12:26:39 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35319 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753136Ab0AaR0j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 12:26:39 -0500
Date: Sun, 31 Jan 2010 18:26:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] timer fix
Message-ID: <20100131172620.GA1022@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-fixes-for-linus

 Thanks,

	Ingo

------------------>
Thomas Gleixner (1):
      clocksource: Prevent potential kgdb dead lock


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
