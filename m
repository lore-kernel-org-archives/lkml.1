Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755080Ab0BHKGL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 05:06:11 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:50314 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753959Ab0BHKGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 05:06:09 -0500
Date: Mon, 8 Feb 2010 15:35:55 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Gautham R Shenoy <ego@in.ibm.com>,
       Arun Bharadwaj <arun@linux.vnet.ibm.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: BUG: sched_mc_powersavings broken on pre-Nehalem x86 platforms
Message-ID: <20100208100555.GD2931@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

sched_mc_powersavings is broken in pre-Nehalem x86 platforms due to
contradictory SD flags at MC level and CPU level.  SD_PREFER_SIBLING being set
at MC level is expected to do the following:

a) Disable consolidating tasks to single group in the parent sched domain
(generally single cpu package) 

b) Spread tasks equally across groups at the parent sched domain.

While SD_POWERSAVINGS_BALANCE set at a sched domain will enable logic to
consolidate tasks within minimum number of groups at that sched domain.

Basically SD_POWERSAVINGS_BALANCE at one sched domain and its child domain
having SD_PREFER_SIBLING is contradicting and disabling the
SD_POWERSAVINGS_BALANCE logic in 

        if (local_group && (sds->this_nr_running >= sgs->group_capacity ||
                                !sds->this_nr_running))
                sds->power_savings_balance = 0;

Since sgs.group_capacity is set to '1' by SD_PREFER_SIBLING in child
sched domain.

The attached patch will fix the expected behavior for sched_mc_powersavings > 0
while objective (b) is still an open issue.

The following condition in find_busiest_group()
	sds.max_load <= sds.busiest_load_per_task

	treats unequally loaded groups as balanced as longs they are below
	capacity

Test Results:

The following patch was tested on dual socket quad core non-threaded Xeon:

Running 4 while(1) loops in shell:

echo 1 > /sys/devices/system/cpu/sched_mc_powersavings

Without Patch:
        Running 1 task in one quad core package and 3 in another.
        This is effectively the baseline behavior with sched_mc=0

With patch:
        All 4 tasks running in one quad core package.
        Expected behavior for sched_mc_powersavings>0

--Vaidy

    Fix for sched_mc_powersavigs for pre-Nehalem platforms.
    Child sched domain should clear SD_PREFER_SIBLING if parent will have 
    SD_POWERSAVINGS_BALANCE because they are contradicting.

    Sets the flags correctly based on sched_mc_power_savings.
    
    Signed-off-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 6550415..ef6b7cd 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -866,7 +866,10 @@ static inline int sd_balance_for_mc_power(void)
 	if (sched_smt_power_savings)
 		return SD_POWERSAVINGS_BALANCE;
 
-	return SD_PREFER_SIBLING;
+	if (!sched_mc_power_savings)
+		return SD_PREFER_SIBLING;
+
+	return 0;
 }
 
 static inline int sd_balance_for_package_power(void)

