Return-Path: <linux-kernel-owner+w=401wt.eu-S1750905AbXA2QXE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750905AbXA2QXE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 11:23:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750912AbXA2QXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 11:23:04 -0500
Received: from mout0.freenet.de ([194.97.50.131]:49176 "EHLO mout0.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910AbXA2QXD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 11:23:03 -0500
From: Karsten Wiese <fzu@wemgehoertderstaat.de>
To: Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.20-rc6-mm2
Date: Mon, 29 Jan 2007 17:22:41 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <20070129001207.71ea3470.akpm@osdl.org>
In-Reply-To: <20070129001207.71ea3470.akpm@osdl.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200701291722.41705.fzu@wemgehoertderstaat.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

with dynticks and highres_timers enabled, cpufreq_ondemand makes mess here on
an AMD64 UP.
cpufreq_ondemand assumes that jiffies advance at exactly the same pace as the
sum of all kstat_cpu(cpu).cpustat.* members.
This isn't the case here as dmesg output from patch below shows.

Is cpufreq_ondemand correct assuming
 "jiffies advance at exactly the same pace as the
  sum of all kstat_cpu(cpu).cpustat.* members"?
Or is "dynticks and highres_timers"'s behaviour of incrementing the
sum of  kstat_cpu(cpu).cpustat.* members faster than jiffies?

      Karsten



diff -pur rc6-mm2/drivers/cpufreq/cpufreq_ondemand.c rc6-mm2-kw/drivers/cpufreq/cpufreq_ondemand.c
--- rc6-mm2/drivers/cpufreq/cpufreq_ondemand.c	2007-01-29 10:40:39.000000000 +0100
+++ rc6-mm2-kw/drivers/cpufreq/cpufreq_ondemand.c	2007-01-29 11:37:08.000000000 +0100
@@ -370,7 +370,15 @@ static void dbs_check_cpu(struct cpu_dbs
 		if (tmp_idle_ticks < idle_ticks)
 			idle_ticks = tmp_idle_ticks;
 	}
-	load = (100 * (total_ticks - idle_ticks)) / total_ticks;
+	if (total_ticks < idle_ticks) {
+		static bool did;
+		if (!did) {
+			printk(KERN_INFO"%s: t%u < i%u\n", __FUNCTION__, total_ticks, idle_ticks);
+			did = true;
+		}
+		load = 0;
+	} else
+		load = (100 * (total_ticks - idle_ticks)) / total_ticks;
 
 	/* Check for frequency increase */
 	if (load > dbs_tuners_ins.up_threshold) {
