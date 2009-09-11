Return-Path: <linux-kernel-owner+w=401wt.eu-S1755832AbZIKSXD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832AbZIKSXD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 14:23:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755764AbZIKSXB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 14:23:01 -0400
Received: from hera.kernel.org ([140.211.167.34]:46755 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754243AbZIKSXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 14:23:00 -0400
Date: Fri, 11 Sep 2009 18:22:27 GMT
From: tip-bot for Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       johnstul@us.ibm.com, schwidefsky@de.ibm.com, jens.axboe@oracle.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       johnstul@us.ibm.com, schwidefsky@de.ibm.com, jens.axboe@oracle.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090911153305.3fe9a361@skybase>
References: <20090911153305.3fe9a361@skybase>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] clocksource: Resolve cpu hotplug dead lock with TSC unstable, fix crash
Message-ID: <tip-f79e0258ea1f04d63db499479b5fb855dff6dbc5@git.kernel.org>
Git-Commit-ID: f79e0258ea1f04d63db499479b5fb855dff6dbc5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 11 Sep 2009 18:22:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f79e0258ea1f04d63db499479b5fb855dff6dbc5
Gitweb:     http://git.kernel.org/tip/f79e0258ea1f04d63db499479b5fb855dff6dbc5
Author:     Martin Schwidefsky <schwidefsky@de.ibm.com>
AuthorDate: Fri, 11 Sep 2009 15:33:05 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 11 Sep 2009 20:17:18 +0200

clocksource: Resolve cpu hotplug dead lock with TSC unstable, fix crash

The watchdog timer is started after the watchdog clocksource
and at least one watched clocksource have been registered. The
clocksource work element watchdog_work is initialized just
before the clocksource timer is started. This is too late for
the clocksource_mark_unstable call from native_cpu_up. To fix
this use a static initializer for watchdog_work.

This resolves a boot crash reported by multiple people.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: John Stultz <johnstul@us.ibm.com>
LKML-Reference: <20090911153305.3fe9a361@skybase>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/time/clocksource.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index a0af4ff..5697155 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -123,10 +123,12 @@ static DEFINE_MUTEX(clocksource_mutex);
 static char override_name[32];
 
 #ifdef CONFIG_CLOCKSOURCE_WATCHDOG
+static void clocksource_watchdog_work(struct work_struct *work);
+
 static LIST_HEAD(watchdog_list);
 static struct clocksource *watchdog;
 static struct timer_list watchdog_timer;
-static struct work_struct watchdog_work;
+static DECLARE_WORK(watchdog_work, clocksource_watchdog_work);
 static DEFINE_SPINLOCK(watchdog_lock);
 static cycle_t watchdog_last;
 static int watchdog_running;
@@ -257,7 +259,6 @@ static inline void clocksource_start_watchdog(void)
 {
 	if (watchdog_running || !watchdog || list_empty(&watchdog_list))
 		return;
-	INIT_WORK(&watchdog_work, clocksource_watchdog_work);
 	init_timer(&watchdog_timer);
 	watchdog_timer.function = clocksource_watchdog;
 	watchdog_last = watchdog->read(watchdog);
