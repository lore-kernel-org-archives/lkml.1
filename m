Return-Path: <linux-kernel-owner+w=401wt.eu-S1757177AbZCDMNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757177AbZCDMNk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 07:13:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750968AbZCDMN3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 07:13:29 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:50973 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753612AbZCDMN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 07:13:28 -0500
Date: Wed, 4 Mar 2009 17:42:49 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: a.p.zijlstra@chello.nl, ego@in.ibm.com, tglx@linutronix.de, mingo@elte.hu,
       andi@firstfloor.org, venkatesh.pallipadi@intel.com,
       vatsa@linux.vnet.ibm.com, arjan@infradead.org, arun@linux.vnet.ibm.com,
       svaidy@linux.vnet.ibm.com
Subject: [v2 PATCH 0/4] timers: framework for migration between CPU
Message-ID: <20090304121249.GA9855@linux.vnet.ibm.com>
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
help move all 'movable timers' from one CPU to any other CPU of choice
using a sysfs interface.

Original posting can be found here --> http://lkml.org/lkml/2009/2/20/121

Based on Ingo's suggestion, I have extended the scheduler power-saving
code, which already identifies an idle load balancer CPU, to also attract
all the attractable sources of timers, automatically.

Also, I have removed the per-cpu sysfs interface and instead created a
single entry at /sys/devices/system/cpu/enable_timer_migration.
This allows users to enable timer migration as a policy and let
the kernel decide the target CPU to move timers and also decide on
the thresholds on when to initiate a timer migration and when to stop.

Timers from idle cpus are migrated to the idle-load-balancer-cpu.
The idle load balancer is one of the idle cpus that has the sched
ticks running and does other system management tasks and load
balancing on behalf of other idle cpus.  Attracting timers from
other idle cpus will reduce wakeups for them while increasing the
probability of overlap with sched ticks on the idle load balancer cpu.

However, this technique has drawbacks if the idle load balancer cpu
is re-nominated too often based on the system behaviour leading to
ping-pong of the timers in the system. This issue can be solved by
optimising the selection of the idle load balancer cpu as described
by Gautham in the following patch http://lkml.org/lkml/2008/9/23/82.

If the idle-load-balancer is selected from a semi-idle package by
including Gautham's patch, then we are able to experimentally verify
consistent selection of idle-load-balancer cpu and timers are also
consolidated to this cpu.

The following patches are included:
PATCH 1/4 - framework to identify pinned timers.
PATCH 2/4 - identifying the existing pinned hrtimers.
PATCH 3/4 - sysfs hook to enable timer migration.
PATCH 4/4 - logic to enable timer migration.

The patchset is based on the latest tip/master.


The following experiment was carried out to demonstrate the
functionality of the patch.
The machine used is a 2 socket, quad core machine, with HT enabled.

I run a `make -j4` pinned to 4 CPUs.
I have used a driver which continuously queues timers on a CPU.
With the timers queued I measure the sleep state residency
for a period of 10s.
Next, I enable timer migration and measure the sleep state
residency period.
The comparison in sleep state residency values is posted below.

Also the difference in Local Timer Interrupt rate(LOC) rate
from /proc/interrupts is posted below.

This enables timer migration.

	echo 1 > /sys/devices/system/cpu/enable_timer_migration

similarly,

	echo 0 > /sys/devices/system/cpu/enable_timer_migration
disables timer migration.


$taskset -c 4,5,6,7 make -j4

my_driver queuing timers continuously on CPU 10.

idle load balancer currently on CPU 15


Case1: Without timer migration		Case2: With timer migration

   --------------------			   --------------------
   | Core | LOC Count |			   | Core | LOC Count |
   | 4    |   2504    |			   | 4    |   2503    |
   | 5    |   2502    |			   | 5    |   2503    |
   | 6    |   2502    |			   | 6    |   2502    |
   | 7    |   2498    |			   | 7    |   2500    |
   | 10   |   2501    |			   | 10   |     35    |
   | 15   |   2501    |			   | 15   |   2501    |
   --------------------			   --------------------

   ---------------------		   --------------------
   | Core | Sleep time |		   | Core | Sleep time |
   | 4    |    0.47168 |		   | 4    |    0.49601 |
   | 5    |    0.44301 |		   | 5    |    0.37153 |
   | 6    |    0.38979 |		   | 6    |    0.51286 |
   | 7    |    0.42829 |		   | 7    |    0.49635 |
   | 10   |    9.86652 |		   | 10   |   10.04216 |
   | 15   |    0.43048 |		   | 15   |    0.49056 |
   ---------------------		   ---------------------

Here, all the timers queued by the driver on CPU10 are moved to CPU15,
which is the idle load balancer.


--arun
