Return-Path: <linux-kernel-owner+w=401wt.eu-S1755380AbYIWVEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380AbYIWVEr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 17:04:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752749AbYIWVEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 17:04:39 -0400
Received: from gw.goop.org ([64.81.55.164]:52161 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752733AbYIWVEi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 17:04:38 -0400
Message-ID: <48D959E8.4000303@goop.org>
Date: Tue, 23 Sep 2008 14:04:40 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <srostedt@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Definition of sched_clock broken
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel/sched_clock.c has the comment:

 * The clock: sched_clock_cpu() is monotonic per cpu, and should be somewhat
 * consistent between cpus (never more than 2 jiffies difference).


The two jiffy restriction is way too restrictive.

Historically sched_clock() is intended to measure the amount of
schedulable time occurring on a CPU.  On a virtual cpu, that is affected
by the amount of physical cpu time the hypervisor schedules for a vcpu,
and can therefore advance in a very non-continuous way, depending on the
overall load on the host system.  It is, however, the only timebase that
gives the kernel a reasonable hope of determining how much cpu a process
actually got scheduled.

The net result is that the sched_clock timebase is 1) monotonic, 2)
loses arbitrary amounts of time against a system monotonic clock, 3)
per-cpu, with 4) arbitrary drift between different cpu's sched_clocks.

Tying the sched_clocks of different cpus together in any way loses these
properties, and just turns it into another system wide monotonic clock,
which seems redundant given that we already have one (I understand that
the relatively loose synchronization allows it to be implemented more
efficiently than a normal monotonic clock).

At the moment the x86 sched_clock is hooked through paravirt_ops so that
the underlying hypervisor can provide precise scheduled time
information, with the hope that the scheduler will use it to make better
decisions.  However if the scheduler needs to be lied to then I can do
that too, but it's a pity to throw away information that's available to it.

    J
