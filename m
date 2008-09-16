Return-Path: <linux-kernel-owner+w=401wt.eu-S1754372AbYIPMG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754372AbYIPMG5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 08:06:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752670AbYIPMGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 08:06:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:44090 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696AbYIPMGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 08:06:48 -0400
Subject: Re: [RFC PATCH 0/1]: timers: Timer Migration
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: arun@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       ego@in.ibm.com, tglx@linutronix.de, mingo@elte.hu, andi@firstfloor.org,
       venkatesh.pallipadi@intel.com, vatsa@linux.vnet.ibm.com
In-Reply-To: <20080916091219.GA1068@linux.vnet.ibm.com>
References: <20080916091219.GA1068@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Tue, 16 Sep 2008 14:05:30 +0200
Message-Id: <1221566730.6943.16.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-09-16 at 14:42 +0530, Arun R Bharadwaj wrote:
> Hi,

80 char lines please.

> An idle cpu on which device drivers have initialized timers, has to be
> frequently woken up to service the timers. So, consolidation of timers
> onto a fewer number of cpus is important. Migration of
> timers from idle cpus onto lesser idle cpus is necessary. Currently,
> timers are migrated during the cpu offline operation. However
> cpu-hotplug for the sake of idle system power management is too
> heavy. So, this patch implements a lightweight timer migration
> framework.
> 
> Also, in a multi-core, multi-package system, it is always desirable to
> have all the timers firing on the cpus present in the same package.
> This would enable us to place the idle package in deep sleep
> state. So, migration of timers is required for this.
> 
> A per_cpu sysfs hook is created
> at /sys/devices/system/cpu/cpuX/timer_migration. By echo-ing 1 to
> cpuX/timer_migration, all regular and hrtimers from cpuX are migrated
> to cpu0. The fact that all
> timers are migrated from cpuX to cpu0 is demonstrated by making a note
> of /proc/interrupts.

This seems like an exceedingly dumb idea - cpu 0 might be a long long
way from x and by pushing all timers to cpu0 you might actually overload
cpu 0.

Initially you talked about packages an moving timers to busy cpus -
which is something else altogether.

> $:echo 1 > /sys/devices/system/cpu/cpu3/timer_migration
> $:cat /proc/interrupts > file1; sleep 30 ; cat /proc/interrupts >
> file2
> $:diff file1 file2 | grep LOC
> < LOC:       5276       2100       2676       1647       2415
> 1803       2275       2977   Local timer interrupts
> > LOC:       6991       2195       2774       1647       2562
> 1900       2497       3075   Local timer interrupts
> 
> As we can observe, first we are enabling timer migration in cpu3. As a
> result, the number of local timer interrupts on cpu3 over the next 30
> seconds are zero. cpu3  has been totally rid of all regular
> and hrtimers.
> 
> Please refer to the following paper for details:
> 
> http://ols.fedoraproject.org/OLS/Reprints-2008/srinivasan1-reprint.pdf

If there's anything worth reading in there it should have been mentioned
in this email and preferably in some comment in the code and Kconfig
help as well.

