Return-Path: <linux-kernel-owner+w=401wt.eu-S1757880AbYACPmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757880AbYACPmr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 10:42:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753303AbYACPmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 10:42:21 -0500
Received: from mail.suse.de ([195.135.220.2]:48612 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752797AbYACPmP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 10:42:15 -0500
From: Andi Kleen <ak@suse.de>
References: <20080103442.621670000@suse.de>
In-Reply-To: <20080103442.621670000@suse.de>
To: tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: [PATCH x86] [1/16] Make clocksource watchdog cycle through online CPUs
Message-Id: <20080103154214.B618F14DDB@wotan.suse.de>
Date: Thu,  3 Jan 2008 16:42:14 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This way it checks if the clocks are synchronized between CPUs too.
This might be able to detect slowly drifting TSCs which only
go wrong over longer time.

Cc: tglx@linutronix.de

Signed-off-by: Andi Kleen <ak@suse.de>

---
 kernel/time/clocksource.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

Index: linux/kernel/time/clocksource.c
===================================================================
--- linux.orig/kernel/time/clocksource.c
+++ linux/kernel/time/clocksource.c
@@ -142,8 +142,13 @@ static void clocksource_watchdog(unsigne
 	}
 
 	if (!list_empty(&watchdog_list)) {
-		__mod_timer(&watchdog_timer,
-			    watchdog_timer.expires + WATCHDOG_INTERVAL);
+		/* Cycle through CPUs to check if the CPUs stay synchronized to
+		 * each other. */
+		int next_cpu = next_cpu(raw_smp_processor_id(), cpu_online_map);
+		if (next_cpu >= NR_CPUS)
+			next_cpu = first_cpu(cpu_online_map);
+		watchdog_timer.expires += WATCHDOG_INTERVAL;
+		add_timer_on(&watchdog_timer, next_cpu);
 	}
 	spin_unlock(&watchdog_lock);
 }
@@ -165,7 +170,7 @@ static void clocksource_check_watchdog(s
 		if (!started && watchdog) {
 			watchdog_last = watchdog->read();
 			watchdog_timer.expires = jiffies + WATCHDOG_INTERVAL;
-			add_timer(&watchdog_timer);
+			add_timer_on(&watchdog_timer, first_cpu(cpu_online_map));
 		}
 	} else {
 		if (cs->flags & CLOCK_SOURCE_IS_CONTINUOUS)
@@ -186,7 +191,8 @@ static void clocksource_check_watchdog(s
 				watchdog_last = watchdog->read();
 				watchdog_timer.expires =
 					jiffies + WATCHDOG_INTERVAL;
-				add_timer(&watchdog_timer);
+				add_timer_on(&watchdog_timer,
+						first_cpu(cpu_online_map));
 			}
 		}
 	}
