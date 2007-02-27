Return-Path: <linux-kernel-owner+w=401wt.eu-S1750913AbXB0PcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750913AbXB0PcT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 10:32:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751593AbXB0PcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 10:32:19 -0500
Received: from mtagate8.de.ibm.com ([195.212.29.157]:53569 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbXB0PcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 10:32:18 -0500
Date: Tue, 27 Feb 2007 16:30:51 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       john stultz <johnstul@us.ibm.com>
Subject: timer/hrtimer & cpu hotplug lockdep complaints
Message-ID: <20070227153051.GD7911@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

lockdep tells us that we have a possible circular locking dependency.
The output below is incomplete since our console driver deadlocked on
del_timer()...

    <4>Processor 4 spun down
    <4>
    <4>=======================================================
    <4>[ INFO: possible circular locking dependency detected ]
    <4>2.6.20-23.x.20070222-s390xdebug #1
    <4>-------------------------------------------------------
    <4>bash/1447 is trying to acquire lock:
    <4> (base_lock_keys + cpu#5){++..}, at: [<000000000013b686>] timer_cpu_notify+0xd2/0x3a4
    <4>
    <4>but task is already holding lock:
    <4> (base_lock_keys + cpu#7){++..}, at: [<000000000013b67c>] timer_cpu_notify+0xc8/0x3a4
    <4>
    <4>which lock already depends on the new lock.
    <4>
    <4>
    <4>the existing dependency chain (in reverse order) is:
    <4>
    <4>-> #1 (base_lock_keys + cpu#7){++..}:
    <4>       [<0000000000158380>] __lock_acquire+0xe40/0xf78
    <4>       [<000000000015854a>] lock_acquire+0x92/0xb8
    <4>       [<0000000000441eea>] _spin_lock+0x52/0x6c
    <4>       [<000000000013b686>] timer_cpu_notify+0xd2/0x3a4
    <4>       [<0000000000443c44>] notifier_call_chain+0x64/0x88
    <4>       [<000000000014200a>] raw_notifier_call_chain+0x26/0x38
    <4>       [<000000000015deee>] cpu_down+0x25e/0x350
    <4>       [<00000000002cb650>] store_online+0x64/0xb8

The problem in this case is the cpu hotplug code in kernel/timer.c:

	migrate_timers(...)
	...
	old_base = per_cpu(tvec_bases, cpu);
	new_base = get_cpu_var(tvec_bases);

	local_irq_disable();
	spin_lock(&new_base->lock);
	spin_lock(&old_base->lock);

takes per-cpu locks once in A-B order and once in B-A order, depending
on from which cpu another one gets killed. This should be ok, since
migrate_timers() can only be active on one cpu and therefore no deadlock
should occur...
The same problem is present in kernel/hrtimer.c btw.
Any idea how to fix this? Just adding a lockdep_off/on between the two
spin_lock()s will fix this, but I don't like it.

Btw.: this is the call trace that lead to the deadlock when printing the
lockdep message. Looks like it is a bad idea if the console driver needs
to take a lock that lockdep wants to complain about. But I don't think
this needs to be fixed.

 0 _raw_spin_lock+326 [0x2a90ee]
 1 _spin_lock_irqsave+108 [0x442198]
 2 lock_timer_base+64 [0x13c758]
 3 del_timer+84 [0x13cfc4]
 4 raw3215_write+610 [0x340fb6]
 5 con3215_write+96 [0x3410a4]
 6 __call_console_drivers+194 [0x12d95a]
 7 _call_console_drivers+142 [0x12da06]
 8 release_console_sem+460 [0x12dfc4]
 9 vprintk+546 [0x12e922]
10 printk+82 [0x12da9e]
11 __print_symbol+220 [0x162f40]
12 print_stack_trace+136 [0x152664]
13 print_circular_bug_entry+104 [0x154f84]
14 print_circular_bug_header+260 [0x1560fc]
15 check_noncircular+354 [0x15752e]
16 __lock_acquire+2970 [0x1580da]
17 lock_acquire+146 [0x15854a]
18 _spin_lock+82 [0x441eea]
19 timer_cpu_notify+210 [0x13b686]
20 notifier_call_chain+100 [0x443c44]
21 raw_notifier_call_chain+38 [0x14200a]
22 cpu_down+606 [0x15deee]
23 store_online+100 [0x2cb650]
24 sysdev_store+72 [0x2c56d0]
25 sysfs_write_file+286 [0x20ea52]
26 vfs_write+210 [0x1ad74e]
27 sys_write+86 [0x1adf7a]
28 sysc_noemu+16 [0x111ad0]
