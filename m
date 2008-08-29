Return-Path: <linux-kernel-owner+w=401wt.eu-S1754147AbYH2NTH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147AbYH2NTH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 09:19:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754306AbYH2NSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 09:18:43 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:35953 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569AbYH2NSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 09:18:42 -0400
Date: Fri, 29 Aug 2008 18:45:15 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: sched_mc_power_savings broken with CGROUPS+CPUSETS
Message-ID: <20080829131514.GS4801@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
Mail-Followup-To: Linux Kernel <linux-kernel@vger.kernel.org>,
	Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
	Gautham R Shenoy <ego@in.ibm.com>,
	Balbir Singh <balbir@linux.vnet.ibm.com>,
	Suresh B Siddha <suresh.b.siddha@intel.com>,
	Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

sched_mc_power_savings seems to be broken with CGROUPS+CPUSETS.
When CONFIG_CPUSETS=y the attached BUG_ON() is being hit.

I added a BUG_ON to check if SD_POWERSAVINGS_BALANCE is set at
SD_LV_CPU whenever sched_mc_power_savings is set.

This BUG is hit when config CONFIG_CPUSETS (depends on CONFIG_CGROUPS)
is just compiled in while this is never hit when they are compiled
out.  The fact that SD_POWERSAVINGS_BALANCE being cleared even when
sched_mc_power_savings = 1 completely breaks the
sched_mc_power_savings heuristics.

To recreate the problem, 
Have sched_mc power savings enabled CONFIG_SCHED_MC=y
Add this BUG_ON()

echo 1 > /sys/devices/system/cpu/sched_mc_power_savings

Try these these on a multi core x86 box.

sched_mc_power_savings seems to be broken from 2.6.26-rc1, but
I do not have a confirmation that the root cause is same in all
successive versions. sched_mc_power_savings works perfect in 
2.6.25.

Please help me root cause the issue.  Please point me to changes that
may potential cause this bug.

Thanks,
Vaidy

Signed-off-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>

Index: linux-2.6.27-rc5/kernel/sched.c
===================================================================
--- linux-2.6.27-rc5.orig/kernel/sched.c	2008-08-29 17:48:56.000000000 +0000
+++ linux-2.6.27-rc5/kernel/sched.c	2008-08-29 18:16:09.000000000 +0000
@@ -3375,6 +3375,8 @@
 
 out_balanced:
 #if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
+	BUG_ON(sched_mc_power_savings && sd->level == SD_LV_CPU && 
+		!(sd->flags & SD_POWERSAVINGS_BALANCE)); 
 	if (idle == CPU_NOT_IDLE || !(sd->flags & SD_POWERSAVINGS_BALANCE))
 		goto ret;
 
