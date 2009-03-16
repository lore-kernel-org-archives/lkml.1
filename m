Return-Path: <linux-kernel-owner+w=401wt.eu-S1760158AbZCPLLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760158AbZCPLLU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 07:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754297AbZCPLLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 07:11:08 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:47544 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608AbZCPLLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 07:11:07 -0400
Date: Mon, 16 Mar 2009 16:40:45 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: a.p.zijlstra@chello.nl, ego@in.ibm.com, tglx@linutronix.de, mingo@elte.hu,
       andi@firstfloor.org, venkatesh.pallipadi@intel.com,
       vatsa@linux.vnet.ibm.com, arjan@infradead.org,
       svaidy@linux.vnet.ibm.com, arun@linux.vnet.ibm.com
Subject: [v3 PATCH 0/4] timers: Framework for migration of timers
Message-ID: <20090316111045.GA4686@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


In an SMP system, tasks are scheduled on different CPUs by the
scheduler, interrupts are managed by irqbalancer daemon, but timers
are still stuck to the CPUs that they have been initialised.  Timers
queued by tasks gets re-queued on the CPU where the task gets to run
next, but timers from IRQ context like the ones in device drivers are
still stuck on the CPU they were initialised.  This framework will
help move all 'movable timers' using a sysctl interface.

Iteration v2 of this patch can be found at
http://lkml.org/lkml/2009/3/4/130


Changelog: v2->v3

-removed the sysfs interface for enabling timer migration
and instead created a /proc/sys sysctl, which can turn off
timer_migration when CONFIG_SCHED_DEBUG =y.(as suggested by Ingo)

-modified the interface to identify pinned regular timers,
made it cleaner and simpler to understand.(as suggested by Oleg)


The following patches are included:
PATCH 1/4 - framework to identify pinned timers.
PATCH 2/4 - identifying the existing pinned hrtimers.
PATCH 3/4 - /proc/sys sysctl hook to enable timer migration.
PATCH 4/4 - logic to enable timer migration.

The patchset is based on the latest tip/master.

Timer migration is enabled by default as suggested by Ingo.
It can be turned off when CONFIG_SCHED_DEBUG=y by

echo 0 > /proc/sys/kernel/timer_migration


Benchmark tested: Kernbench

Kernbench results on an 2-socket, quad-core machine
Averaged over 3 iterations.
sched_mc_power_savings = 2

------------------------------------------------------------------------
|No. of	    Time taken(s)      Time Taken(s)	      Time Taken(s)    |
|Threads  Patch Not Applied (Migration Disabled)   (Migration Enabled) |
|								       |
|  32	     64.02		64.05			63.73	       |
|  16	     63.31		63.71			62.91	       |
|   8	     67.20		67.38			67.32	       |
|   4	    115.67	       114.72		       114.54	       |
|   2	    222.21	       220.63		       218.13	       |
------------------------------------------------------------------------


TODO:

-Yet to implement Oleg's comment on my previous post PATCH 4/4.
Current code seems to be working fine. Working on it to implement
what has been suggested.


Please let me know your comments.

--arun
