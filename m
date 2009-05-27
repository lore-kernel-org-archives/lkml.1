Return-Path: <linux-kernel-owner+w=401wt.eu-S1763476AbZE0MzN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763476AbZE0MzN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 08:55:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762367AbZE0MzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 08:55:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:51214 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759354AbZE0My5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 08:54:57 -0400
Date: Wed, 27 May 2009 12:54:31 GMT
From: tip-bot for Eero Nurkkala <ext-eero.nurkkala@nokia.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       venkatesh.pallipadi@intel.com, riel@redhat.com, tero.kristo@nokia.com,
       ext-eero.nurkkala@nokia.com, tglx@linutronix.de
Reply-To: riel@redhat.com, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, tero.kristo@nokia.com,
       ext-eero.nurkkala@nokia.com, venkatesh.pallipadi@intel.com,
       tglx@linutronix.de
In-Reply-To: <12432346571351-git-send-email-ext-eero.nurkkala@nokia.com>
References: <12432346571351-git-send-email-ext-eero.nurkkala@nokia.com>
Subject: [tip:timers/urgent] NOHZ: Properly feed cpufreq ondemand governor
Message-ID: <tip-cf1240033cc81216a18eec0ca71466f7fe4eeda8@git.kernel.org>
Git-Commit-ID: cf1240033cc81216a18eec0ca71466f7fe4eeda8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 27 May 2009 12:54:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cf1240033cc81216a18eec0ca71466f7fe4eeda8
Gitweb:     http://git.kernel.org/tip/cf1240033cc81216a18eec0ca71466f7fe4eeda8
Author:     Eero Nurkkala <ext-eero.nurkkala@nokia.com>
AuthorDate: Mon, 25 May 2009 09:57:37 +0300
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 27 May 2009 14:51:47 +0200

NOHZ: Properly feed cpufreq ondemand governor

A call from irq_exit() may occasionally pause the timing
info for cpufreq ondemand governor. This results in the
cpufreq ondemand governor to fail to calculate the
system load properly. Thus, relocate the checks for this
particular case to keep the governor always functional.

Signed-off-by: Eero Nurkkala <ext-eero.nurkkala@nokia.com>
Reported-by: Tero Kristo <tero.kristo@nokia.com>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
LKML-Reference: <12432346571351-git-send-email-ext-eero.nurkkala@nokia.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>


---
 kernel/time/tick-sched.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index d3f1ef4..233b4e7 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -222,6 +222,15 @@ void tick_nohz_stop_sched_tick(int inidle)
 
 	cpu = smp_processor_id();
 	ts = &per_cpu(tick_cpu_sched, cpu);
+
+	/*
+	 * Call to tick_nohz_start_idle stops the last_update_time from being
+	 * updated. Thus, it must not be called in the event we are called from
+	 * irq_exit() with the prior state different than idle.
+	 */
+	if (!inidle && !ts->inidle)
+		return;
+
 	now = tick_nohz_start_idle(ts);
 
 	/*
@@ -239,9 +248,6 @@ void tick_nohz_stop_sched_tick(int inidle)
 	if (unlikely(ts->nohz_mode == NOHZ_MODE_INACTIVE))
 		goto end;
 
-	if (!inidle && !ts->inidle)
-		goto end;
-
 	ts->inidle = 1;
 
 	if (need_resched())
