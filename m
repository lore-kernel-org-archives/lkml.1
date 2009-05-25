Return-Path: <linux-kernel-owner+w=401wt.eu-S1753707AbZEYG71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707AbZEYG71 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 02:59:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751919AbZEYG7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 02:59:19 -0400
Received: from smtp.nokia.com ([192.100.122.230]:42687 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbZEYG7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 02:59:19 -0400
From: ext-eero.nurkkala@nokia.com
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, Eero Nurkkala <ext-eero.nurkkala@nokia.com>
Subject: [PATCH] NOHZ: Properly feed cpufreq ondemand governor
Date: Mon, 25 May 2009 09:57:37 +0300
Message-Id: <12432346571351-git-send-email-ext-eero.nurkkala@nokia.com>
X-Mailer: git-send-email 1.5.2
X-OriginalArrivalTime: 25 May 2009 06:59:06.0956 (UTC) FILETIME=[4BE438C0:01C9DD06]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eero Nurkkala <ext-eero.nurkkala@nokia.com>

A call from irq_exit() may occasionally pause the timing
info for cpufreq ondemand governor. This results in the
cpufreq ondemand governor to fail to calculate the 
system load properly. Thus, relocate the checks for this
particular case to keep the governor always functional.

Signed-off-by: Eero Nurkkala <ext-eero.nurkkala@nokia.com>
Reported-by: Tero Kristo <tero.kristo@nokia.com>
---
 kernel/time/tick-sched.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index d3f1ef4..a3562ce 100644
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
+		goto end;
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
-- 
1.5.6.3

