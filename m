Return-Path: <linux-kernel-owner+w=401wt.eu-S1756400AbYJPLnB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756400AbYJPLnB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 07:43:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754770AbYJPLmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 07:42:53 -0400
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:46204 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635AbYJPLmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 07:42:52 -0400
Date: Thu, 16 Oct 2008 17:12:39 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: a.p.zijlstra@chello.nl, ego@in.ibm.com, tglx@linutronix.de, mingo@elte.hu,
       andi@firstfloor.org, venkatesh.pallipadi@intel.com,
       vatsa@linux.vnet.ibm.com, arjan@infradead.org, arun@linux.vnet.ibm.com
Subject: [RFC PATCH 0/4] timers: Timer migration
Message-ID: <20081016114239.GA7641@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
Mail-Followup-To: linux-kernel@vger.kernel.org,
	linux-pm@lists.linux-foundation.org, a.p.zijlstra@chello.nl,
	ego@in.ibm.com, tglx@linutronix.de, mingo@elte.hu,
	andi@firstfloor.org, venkatesh.pallipadi@intel.com,
	vatsa@linux.vnet.ibm.com, arjan@infradead.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

(This is merely for discussion purposes and not for inclusion).

This is a re-work of the earlier patch which i had sent.
Link to the earlier patch - http://lkml.org/lkml/2008/9/16/40
I have made the following changes from my previous patch:

1) Created a new framework for identifying cpu-pinned hrtimers,so
that such hrtimers are ignored during migration of timers.

2)A better sysfs interface which allows you to echo a target cpu
number to the per-cpu sysfs entry and all timers are migrated
to that cpu, instead of choosing cpu0 by default.

This patch set is based on the kernel version 2.6.27.


Here's a brief introduction as to why we need timer migration.

An idle cpu on which device drivers have initialized timers, or any
timer that is (re)queued from a softirq context has to be
frequently woken up to service the timers. So, consolidation of timers
onto a fewer number of cpus is important. Migration of timers from
idle cpus onto lesser idle cpus is necessary. Currently, timers are
migrated during the cpu offline operation. However cpu-hotplug for the
sake of idle system power management is too heavy. So, this patch
implements a lightweight timer migration framework.

Also, in machines with large number of CPUs, when utilization is not
high enough, but is not 0% either, we would want to consolidate all
the system activity to as fewer number of packages as possible.

a) Interrupts are usually re-routed using the power-aware irqbalance
daemon.

b) For tasks, we have hooks in the scheduler which can consolidate tasks to
a fewer number of CPUs.

c) The remaining part of the system activity is the timers, which can be
queued from a task or a softirq context.

c-1)If they're queued from the task context, then they migrate whenever the
task is migrated.

c-2) However, if they're requeued from a softirq context, then it's not
possible to currently migrate them unless the CPU is offlined.

Hence, the need for a minimalistic framework which allows to
migrate the last remaining system activity from the last few
idle-but-serving-timers CPUs of an otherwise idle package, to a package
which is already having some amount of system activity on them.

Also, this kind of a framework will be helpful for a certain class of
applications like the High Performance (HPC) applications, where we
would want to restrict the system housekeeping activities to as fewer
number of CPUs as possible, in order to minimize the jitter caused by
these housekeeping activities.


Lastly, the algorithm which decides to which cpu the timer should be
migrated to should be conservative in the sense that, it should
migrate only if the target cpu is sufficiently busy so that it is not
woken up from an idle state. In that case where even target cpu is
idle, the penalty of wake up would be same on either of the cpus.

Tests carried out:

a) I have tested this patch by stressing the system using a script
which continuously hotplug-add and removes the cpus.

b) Also ran kernbench. The kernbench results with and without my patches
on were fairly similar.

