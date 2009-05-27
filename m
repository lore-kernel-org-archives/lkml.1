Return-Path: <linux-kernel-owner+w=401wt.eu-S1762583AbZE0L6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762583AbZE0L6U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 07:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760739AbZE0L6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 07:58:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:35058 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758258AbZE0L6E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 07:58:04 -0400
Date: Wed, 27 May 2009 11:57:33 GMT
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
Message-ID: <tip-4e67ac87c460a3c876019fa05149591122ec5287@git.kernel.org>
Git-Commit-ID: 4e67ac87c460a3c876019fa05149591122ec5287
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 27 May 2009 11:57:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4e67ac87c460a3c876019fa05149591122ec5287
Gitweb:     http://git.kernel.org/tip/4e67ac87c460a3c876019fa05149591122ec5287
Author:     Eero Nurkkala <ext-eero.nurkkala@nokia.com>
AuthorDate: Mon, 25 May 2009 09:57:37 +0300
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 27 May 2009 13:55:00 +0200

NOHZ: Properly feed cpufreq ondemand governor

A call from irq_exit() may occasionally pause the timing
info for cpufreq ondemand governor. This results in the
cpufreq ondemand governor to fail to calculate the
system load properly. Thus, relocate the checks for this
particular case to keep the governor always functional.

[ tglx: moved the check to the top of the function ]

Signed-off-by: Eero Nurkkala <ext-eero.nurkkala@nokia.com>
Reported-by: Tero Kristo <tero.kristo@nokia.com>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
LKML-Reference: <12432346571351-git-send-email-ext-eero.nurkkala@nokia.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>


---
 kernel/time/tick-sched.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index d3f1ef4..d3d6f3f 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -218,8 +218,15 @@ void tick_nohz_stop_sched_tick(int inidle)
 	struct clock_event_device *dev = __get_cpu_var(tick_cpu_device).evtdev;
 	int cpu;
 
-	local_irq_save(flags);
+	/*
+	 * Call to tick_nohz_start_idle stops the last_update_time from being
+	 * updated. Thus, it must not be called in the event we are called from
+	 * irq_exit() with the prior state different than idle.
+	 */
+	if (!inidle && !ts->inidle)
+		return;
 
+	local_irq_save(flags);
 	cpu = smp_processor_id();
 	ts = &per_cpu(tick_cpu_sched, cpu);
 	now = tick_nohz_start_idle(ts);
@@ -239,9 +246,6 @@ void tick_nohz_stop_sched_tick(int inidle)
 	if (unlikely(ts->nohz_mode == NOHZ_MODE_INACTIVE))
 		goto end;
 
-	if (!inidle && !ts->inidle)
-		goto end;
-
 	ts->inidle = 1;
 
 	if (need_resched())
