Return-Path: <linux-kernel-owner+w=401wt.eu-S1757927AbZKJThj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757927AbZKJThj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 14:37:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757918AbZKJThi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 14:37:38 -0500
Received: from mga14.intel.com ([143.182.124.37]:22553 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757903AbZKJThh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 14:37:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,717,1249282800"; 
   d="scan'208";a="209934418"
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Alexander Miller <Miller@fmi.uni-stuttgart.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
       Dave Jones <davej@redhat.com>
Date: Tue, 10 Nov 2009 11:42:02 -0800
Subject: RE: [PATCH] cpufreq: fix conservative/ondemand behaviour with
 ignore_nice_load
Thread-Topic: [PATCH] cpufreq: fix conservative/ondemand behaviour with
 ignore_nice_load
Thread-Index: Acpe/4mrBq5o+1KgS4SXdKbrJw6wUQDPatvw
Message-ID: <7E82351C108FA840AB1866AC776AEC467631F1E1@orsmsx505.amr.corp.intel.com>
References: <200911061727.17541.Miller@fmi.uni-stuttgart.de>
In-Reply-To: <200911061727.17541.Miller@fmi.uni-stuttgart.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: cpufreq-owner@vger.kernel.org 
>[mailto:cpufreq-owner@vger.kernel.org] On Behalf Of Alexander Miller
>Sent: Friday, November 06, 2009 8:27 AM
>To: linux-kernel@vger.kernel.org
>Cc: cpufreq@vger.kernel.org; Dave Jones
>Subject: [PATCH] cpufreq: fix conservative/ondemand behaviour 
>with ignore_nice_load
>
>Remove conversion of nice load to microseconds which caused addition
>of times measured in different units and thus unreasonable behaviour
>with both governors.                                                  

Can you describe the "unresonable behavior" you are seeing. Is it
with NO_HZ enabled or disabled?

I see there can be a problem with this code when NO_HZ is disabled.
But, the patch below is not the right solution as it will result in
Adding times in different units with NO_HZ enabled.

Thanks,
Venki

>
>Signed-off-by: Alexander Miller <Miller@fmi.uni-stuttgart.de>
>---
>diff -uprN 
>linux-2.6.git/drivers/cpufreq/cpufreq_conservative.c 
>linux/drivers/cpufreq/cpufreq_conservative.c
>--- linux-2.6.git/drivers/cpufreq/cpufreq_conservative.c	
>2009-10-10 15:56:58.010595257 +0200
>+++ linux/drivers/cpufreq/cpufreq_conservative.c	
>2009-10-10 20:56:52.194598889 +0200
>@@ -400,20 +400,10 @@ static void dbs_check_cpu(struct cpu_dbs
> 		j_dbs_info->prev_cpu_idle = cur_idle_time;
> 
> 		if (dbs_tuners_ins.ignore_nice) {
>-			cputime64_t cur_nice;
>-			unsigned long cur_nice_jiffies;
>-
>-			cur_nice = 
>cputime64_sub(kstat_cpu(j).cpustat.nice,
>+			idle_time += (unsigned int) cputime64_sub(
>+					 kstat_cpu(j).cpustat.nice,
> 					 j_dbs_info->prev_cpu_nice);
>-			/*
>-			 * Assumption: nice time between 
>sampling periods will
>-			 * be less than 2^32 jiffies for 32 bit sys
>-			 */
>-			cur_nice_jiffies = (unsigned long)
>-					
>cputime64_to_jiffies64(cur_nice);
>-
> 			j_dbs_info->prev_cpu_nice = 
>kstat_cpu(j).cpustat.nice;
>-			idle_time += jiffies_to_usecs(cur_nice_jiffies);
> 		}
> 
> 		if (unlikely(!wall_time || wall_time < idle_time))
>diff -uprN linux-2.6.git/drivers/cpufreq/cpufreq_ondemand.c 
>linux/drivers/cpufreq/cpufreq_ondemand.c
>--- linux-2.6.git/drivers/cpufreq/cpufreq_ondemand.c	
>2009-10-10 16:00:40.380595816 +0200
>+++ linux/drivers/cpufreq/cpufreq_ondemand.c	2009-10-10 
>20:56:52.195596654 +0200
>@@ -488,20 +488,10 @@ static void dbs_check_cpu(struct cpu_dbs
> 		j_dbs_info->prev_cpu_idle = cur_idle_time;
> 
> 		if (dbs_tuners_ins.ignore_nice) {
>-			cputime64_t cur_nice;
>-			unsigned long cur_nice_jiffies;
>-
>-			cur_nice = 
>cputime64_sub(kstat_cpu(j).cpustat.nice,
>+			idle_time += (unsigned int) cputime64_sub(
>+					 kstat_cpu(j).cpustat.nice,
> 					 j_dbs_info->prev_cpu_nice);
>-			/*
>-			 * Assumption: nice time between 
>sampling periods will
>-			 * be less than 2^32 jiffies for 32 bit sys
>-			 */
>-			cur_nice_jiffies = (unsigned long)
>-					
>cputime64_to_jiffies64(cur_nice);
>-
> 			j_dbs_info->prev_cpu_nice = 
>kstat_cpu(j).cpustat.nice;
>-			idle_time += jiffies_to_usecs(cur_nice_jiffies);
> 		}
> 
> 		if (unlikely(!wall_time || wall_time < idle_time))
>--
>To unsubscribe from this list: send the line "unsubscribe cpufreq" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>