Return-Path: <linux-kernel-owner+w=401wt.eu-S1754600Ab0AZE14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600Ab0AZE14 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 23:27:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754477Ab0AZE1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 23:27:52 -0500
Received: from mail.windriver.com ([147.11.1.11]:64523 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754469Ab0AZE1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 23:27:51 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, mingo@elte.hu,
       Jason Wessel <jason.wessel@windriver.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       John Stultz <johnstul@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Magnus Damm <damm@igel.co.jp>
Subject: [PATCH 3/4] kgdb,clocksource: Prevent kernel hang in kernel debugger
Date: Mon, 25 Jan 2010 22:26:39 -0600
Message-Id: <1264480000-6997-4-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1264480000-6997-1-git-send-email-jason.wessel@windriver.com>
References: <1264480000-6997-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 26 Jan 2010 04:26:47.0583 (UTC) FILETIME=[C60512F0:01CA9E3F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a regression fix against: 0f8e8ef7c204988246da5a42d576b7fa5277a8e4

Spin locks were added to the clocksource_resume_watchdog() which cause
the kernel debugger to deadlock on an SMP system frequently.

The kernel debugger can try for the lock, but if it fails it should
continue to touch the clocksource watchdog anyway, else it will trip
if the general kernel execution has been paused for too long.

This introduces an possible race condition where the kernel debugger
might not process the list correctly if a clocksource is being added
or removed at the time of this call.  This race is sufficiently rare vs
having the kernel debugger hang the kernel

CC: Thomas Gleixner <tglx@linutronix.de>
CC: Martin Schwidefsky <schwidefsky@de.ibm.com>
CC: John Stultz <johnstul@us.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Magnus Damm <damm@igel.co.jp>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 kernel/time/clocksource.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index e85c234..74f9ba6 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -463,7 +463,12 @@ void clocksource_resume(void)
  */
 void clocksource_touch_watchdog(void)
 {
-	clocksource_resume_watchdog();
+	unsigned long flags;
+
+	int got_lock = spin_trylock_irqsave(&watchdog_lock, flags);
+	clocksource_reset_watchdog();
+	if (got_lock)
+		spin_unlock_irqrestore(&watchdog_lock, flags);
 }
 
 /**
-- 
1.6.3.3

