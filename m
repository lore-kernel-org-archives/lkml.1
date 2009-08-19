Return-Path: <linux-kernel-owner+w=401wt.eu-S1751601AbZHSJrA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751601AbZHSJrA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 05:47:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751492AbZHSJq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 05:46:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:46640 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751457AbZHSJq6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 05:46:58 -0400
Date: Wed, 19 Aug 2009 09:46:35 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       schwidefsky@de.ibm.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       schwidefsky@de.ibm.com, tglx@linutronix.de
In-Reply-To: <alpine.LFD.2.00.0908171038420.2782@localhost.localdomain>
References: <alpine.LFD.2.00.0908171038420.2782@localhost.localdomain>
Subject: [tip:timers/core] clocksource: Protect the watchdog rating changes with clocksource_mutex
Message-ID: <tip-d0981a1b21a03866c8da7f44e35e389c2e0d6061@git.kernel.org>
Git-Commit-ID: d0981a1b21a03866c8da7f44e35e389c2e0d6061
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 19 Aug 2009 09:46:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d0981a1b21a03866c8da7f44e35e389c2e0d6061
Gitweb:     http://git.kernel.org/tip/d0981a1b21a03866c8da7f44e35e389c2e0d6061
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 19 Aug 2009 11:26:09 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 19 Aug 2009 11:42:48 +0200

clocksource: Protect the watchdog rating changes with clocksource_mutex

Martin pointed out that commit 6ea41d2529 (clocksource: Call
clocksource_change_rating() outside of watchdog_lock) has a
theoretical reference count problem. The calls to
clocksource_change_rating() are now done outside of the clocksource
mutex and outside of the watchdog lock. A concurrent
clocksource_unregister() could remove the clock.

Split out the code which changes the rating from
clocksource_change_rating() into __clocksource_change_rating().

Protect the clocksource_watchdog_work() code sequence with the
clocksource_mutex() and call __clocksource_change_rating().

LKML-Reference: <alpine.LFD.2.00.0908171038420.2782@localhost.localdomain>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>


---
 kernel/time/clocksource.c |   18 +++++++++++++-----
 1 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 02dc22d..c6bff11 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -131,6 +131,7 @@ static cycle_t watchdog_last;
 static int watchdog_running;
 
 static void clocksource_watchdog_work(struct work_struct *work);
+static void __clocksource_change_rating(struct clocksource *cs, int rating);
 
 /*
  * Interval: 0.5sec Threshold: 0.0625s
@@ -309,6 +310,7 @@ static void clocksource_watchdog_work(struct work_struct *work)
 	unsigned long flags;
 	LIST_HEAD(unstable);
 
+	mutex_lock(&clocksource_mutex);
 	spin_lock_irqsave(&watchdog_lock, flags);
 	list_for_each_entry_safe(cs, tmp, &watchdog_list, wd_list)
 		if (cs->flags & CLOCK_SOURCE_UNSTABLE) {
@@ -322,8 +324,9 @@ static void clocksource_watchdog_work(struct work_struct *work)
 	/* Needs to be done outside of watchdog lock */
 	list_for_each_entry_safe(cs, tmp, &unstable, wd_list) {
 		list_del_init(&cs->wd_list);
-		clocksource_change_rating(cs, 0);
+		__clocksource_change_rating(cs, 0);
 	}
+	mutex_unlock(&clocksource_mutex);
 }
 
 #else /* CONFIG_CLOCKSOURCE_WATCHDOG */
@@ -470,16 +473,21 @@ int clocksource_register(struct clocksource *cs)
 }
 EXPORT_SYMBOL(clocksource_register);
 
+static void __clocksource_change_rating(struct clocksource *cs, int rating)
+{
+	list_del(&cs->list);
+	cs->rating = rating;
+	clocksource_enqueue(cs);
+	clocksource_select();
+}
+
 /**
  * clocksource_change_rating - Change the rating of a registered clocksource
  */
 void clocksource_change_rating(struct clocksource *cs, int rating)
 {
 	mutex_lock(&clocksource_mutex);
-	list_del(&cs->list);
-	cs->rating = rating;
-	clocksource_enqueue(cs);
-	clocksource_select();
+	__clocksource_change_rating(cs, rating);
 	mutex_unlock(&clocksource_mutex);
 }
 EXPORT_SYMBOL(clocksource_change_rating);
