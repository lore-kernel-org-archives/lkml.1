Return-Path: <linux-kernel-owner+w=401wt.eu-S1752989AbYIPJOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989AbYIPJOW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 05:14:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750993AbYIPJON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 05:14:13 -0400
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:40110 "EHLO
	e28esmtp07.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750965AbYIPJOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 05:14:12 -0400
Date: Tue, 16 Sep 2008 14:42:31 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: ego@in.ibm.com, tglx@linutronix.de, mingo@elte.hu, a.p.zijlstra@chello.nl,
       andi@firstfloor.org, venkatesh.pallipadi@intel.com,
       vatsa@linux.vnet.ibm.com
Subject: [RFC PATCH 0/1]: timers: Timer Migration
Message-ID: <20080916091219.GA1068@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
Mail-Followup-To: linux-kernel@vger.kernel.org,
	linux-pm@lists.linux-foundation.org, ego@in.ibm.com,
	tglx@linutronix.de, mingo@elte.hu, a.p.zijlstra@chello.nl,
	andi@firstfloor.org, venkatesh.pallipadi@intel.com,
	vatsa@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

An idle cpu on which device drivers have initialized timers, has to be frequently woken up to service the timers. So, consolidation of timers onto a fewer number of cpus is important. Migration of
timers from idle cpus onto lesser idle cpus is necessary. Currently, timers are migrated during the cpu offline operation. However cpu-hotplug for the sake of idle system power management is too
heavy. So, this patch implements a lightweight timer migration framework.

Also, in a multi-core, multi-package system, it is always desirable to have all the timers firing on the cpus present in the same package. This would enable us to place the idle package in deep sleep
state. So, migration of timers is required for this.

A per_cpu sysfs hook is created at /sys/devices/system/cpu/cpuX/timer_migration. By echo-ing 1 to cpuX/timer_migration, all regular and hrtimers from cpuX are migrated to cpu0. The fact that all
timers are migrated from cpuX to cpu0 is demonstrated by making a note of /proc/interrupts.

$:echo 1 > /sys/devices/system/cpu/cpu3/timer_migration
$:cat /proc/interrupts > file1; sleep 30 ; cat /proc/interrupts > file2
$:diff file1 file2 | grep LOC
< LOC:       5276       2100       2676       1647       2415       1803       2275       2977   Local timer interrupts
> LOC:       6991       2195       2774       1647       2562       1900       2497       3075   Local timer interrupts

As we can observe, first we are enabling timer migration in cpu3. As a result, the number of local timer interrupts on cpu3 over the next 30 seconds are zero. cpu3  has been totally rid of all regular
and hrtimers.

Please refer to the following paper for details:

http://ols.fedoraproject.org/OLS/Reprints-2008/srinivasan1-reprint.pdf


thanks,
Arun
