Return-Path: <linux-kernel-owner+w=401wt.eu-S1754989AbXHNHxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989AbXHNHxQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 03:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753307AbXHNHqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 03:46:45 -0400
Received: from canuck.infradead.org ([209.217.80.40]:55449 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819AbXHNHq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 03:46:28 -0400
Date: Tue, 14 Aug 2007 00:29:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: [patch 11/12] CPUFREQ: ondemand: fix tickless accounting and
	software coordination bug
Message-ID: <20070814072940.GK15025@kroah.com>
References: <20070814072244.882283903@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="cpufreq-ondemand-fix-tickless-accounting-and-software-coordination-bug.patch"
In-Reply-To: <20070814072813.GA15025@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>

With tickless kernel and software coordination os P-states, ondemand
can look at wrong idle statistics. This can happen when ondemand sampling
is happening on CPU 0 and due to software coordination sampling also looks at
utilization of CPU 1. If CPU 1 is in tickless state at that moment, its idle
statistics will not be uptodate and CPU 0 thinks CPU 1 is idle for less
amount of time than it actually is.

This can be resolved by looking at all the busy times of CPUs, which is
accurate, even with tickless, and use that to determine idle time in a
round about way (total time - busy time).

Thanks to Arjan for originally reporting the ondemand bug on
Lenovo T61.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Dave Jones <davej@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/cpufreq/cpufreq_ondemand.c |   25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -96,15 +96,25 @@ static struct dbs_tuners {
 
 static inline cputime64_t get_cpu_idle_time(unsigned int cpu)
 {
-	cputime64_t retval;
+	cputime64_t idle_time;
+	cputime64_t cur_jiffies;
+	cputime64_t busy_time;
 
-	retval = cputime64_add(kstat_cpu(cpu).cpustat.idle,
-			kstat_cpu(cpu).cpustat.iowait);
+	cur_jiffies = jiffies64_to_cputime64(get_jiffies_64());
+	busy_time = cputime64_add(kstat_cpu(cpu).cpustat.user,
+			kstat_cpu(cpu).cpustat.system);
 
-	if (dbs_tuners_ins.ignore_nice)
-		retval = cputime64_add(retval, kstat_cpu(cpu).cpustat.nice);
+	busy_time = cputime64_add(busy_time, kstat_cpu(cpu).cpustat.irq);
+	busy_time = cputime64_add(busy_time, kstat_cpu(cpu).cpustat.softirq);
+	busy_time = cputime64_add(busy_time, kstat_cpu(cpu).cpustat.steal);
 
-	return retval;
+	if (!dbs_tuners_ins.ignore_nice) {
+		busy_time = cputime64_add(busy_time,
+				kstat_cpu(cpu).cpustat.nice);
+	}
+
+	idle_time = cputime64_sub(cur_jiffies, busy_time);
+	return idle_time;
 }
 
 /*
@@ -339,7 +349,8 @@ static void dbs_check_cpu(struct cpu_dbs
 	cur_jiffies = jiffies64_to_cputime64(get_jiffies_64());
 	total_ticks = (unsigned int) cputime64_sub(cur_jiffies,
 			this_dbs_info->prev_cpu_wall);
-	this_dbs_info->prev_cpu_wall = cur_jiffies;
+	this_dbs_info->prev_cpu_wall = get_jiffies_64();
+
 	if (!total_ticks)
 		return;
 	/*

-- 
