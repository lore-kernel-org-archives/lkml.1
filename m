Return-Path: <linux-kernel-owner+w=401wt.eu-S1759450AbZKFQiC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759450AbZKFQiC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 11:38:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758787AbZKFQiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 11:38:00 -0500
Received: from mx1.informatik.uni-stuttgart.de ([129.69.211.41]:37334 "EHLO
	mx1.informatik.uni-stuttgart.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757036AbZKFQiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 11:38:00 -0500
X-Greylist: delayed 645 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Nov 2009 11:38:00 EST
From: Alexander Miller <Miller@fmi.uni-stuttgart.de>
Organization: FMI, =?iso-8859-1?q?Universit=E4t?= Stuttgart
To: linux-kernel@vger.kernel.org
Subject: [PATCH] cpufreq: fix conservative/ondemand behaviour with ignore_nice_load
Date: Fri, 6 Nov 2009 17:27:17 +0100
User-Agent: KMail/1.9.10
Cc: cpufreq@vger.kernel.org, Dave Jones <davej@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911061727.17541.Miller@fmi.uni-stuttgart.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove conversion of nice load to microseconds which caused addition
of times measured in different units and thus unreasonable behaviour
with both governors.                                                  

Signed-off-by: Alexander Miller <Miller@fmi.uni-stuttgart.de>
---
diff -uprN linux-2.6.git/drivers/cpufreq/cpufreq_conservative.c linux/drivers/cpufreq/cpufreq_conservative.c
--- linux-2.6.git/drivers/cpufreq/cpufreq_conservative.c	2009-10-10 15:56:58.010595257 +0200
+++ linux/drivers/cpufreq/cpufreq_conservative.c	2009-10-10 20:56:52.194598889 +0200
@@ -400,20 +400,10 @@ static void dbs_check_cpu(struct cpu_dbs
 		j_dbs_info->prev_cpu_idle = cur_idle_time;
 
 		if (dbs_tuners_ins.ignore_nice) {
-			cputime64_t cur_nice;
-			unsigned long cur_nice_jiffies;
-
-			cur_nice = cputime64_sub(kstat_cpu(j).cpustat.nice,
+			idle_time += (unsigned int) cputime64_sub(
+					 kstat_cpu(j).cpustat.nice,
 					 j_dbs_info->prev_cpu_nice);
-			/*
-			 * Assumption: nice time between sampling periods will
-			 * be less than 2^32 jiffies for 32 bit sys
-			 */
-			cur_nice_jiffies = (unsigned long)
-					cputime64_to_jiffies64(cur_nice);
-
 			j_dbs_info->prev_cpu_nice = kstat_cpu(j).cpustat.nice;
-			idle_time += jiffies_to_usecs(cur_nice_jiffies);
 		}
 
 		if (unlikely(!wall_time || wall_time < idle_time))
diff -uprN linux-2.6.git/drivers/cpufreq/cpufreq_ondemand.c linux/drivers/cpufreq/cpufreq_ondemand.c
--- linux-2.6.git/drivers/cpufreq/cpufreq_ondemand.c	2009-10-10 16:00:40.380595816 +0200
+++ linux/drivers/cpufreq/cpufreq_ondemand.c	2009-10-10 20:56:52.195596654 +0200
@@ -488,20 +488,10 @@ static void dbs_check_cpu(struct cpu_dbs
 		j_dbs_info->prev_cpu_idle = cur_idle_time;
 
 		if (dbs_tuners_ins.ignore_nice) {
-			cputime64_t cur_nice;
-			unsigned long cur_nice_jiffies;
-
-			cur_nice = cputime64_sub(kstat_cpu(j).cpustat.nice,
+			idle_time += (unsigned int) cputime64_sub(
+					 kstat_cpu(j).cpustat.nice,
 					 j_dbs_info->prev_cpu_nice);
-			/*
-			 * Assumption: nice time between sampling periods will
-			 * be less than 2^32 jiffies for 32 bit sys
-			 */
-			cur_nice_jiffies = (unsigned long)
-					cputime64_to_jiffies64(cur_nice);
-
 			j_dbs_info->prev_cpu_nice = kstat_cpu(j).cpustat.nice;
-			idle_time += jiffies_to_usecs(cur_nice_jiffies);
 		}
 
 		if (unlikely(!wall_time || wall_time < idle_time))
