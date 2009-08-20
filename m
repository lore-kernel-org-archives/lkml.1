Return-Path: <linux-kernel-owner+w=401wt.eu-S1754593AbZHTODh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593AbZHTODh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 10:03:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754373AbZHTODg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 10:03:36 -0400
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:53317 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754308AbZHTODf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 10:03:35 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEADf0jEpMRdTz/2dsb2JhbACBU9YCgiqBbgWBTw
Date: Thu, 20 Aug 2009 10:03:35 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Josh Triplett <josht@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       peterz@infradead.org, rostedt@goodmis.org, hugh.dickins@tiscali.co.uk,
       benh@kernel.crashing.org
Subject: Re: [PATCH -tip/core/rcu 1/6] Cleanups and fixes for RCU in face
	of heavy CPU-hotplug stress
Message-ID: <20090820140335.GA31773@Krystal>
References: <20090815165153.GA8886@linux.vnet.ibm.com> <1250533487.2709.14.camel@josh-work.beaverton.ibm.com> <20090817192036.GJ6760@linux.vnet.ibm.com> <20090818152643.GA5549@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090818152643.GA5549@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 09:28:56 up 2 days, 18 min,  3 users,  load average: 0.03, 0.13,
	0.21
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> FYI, i've started triggering hangs in -tip testing recently, during 
> CPU hotplug tests:
> 
> [   57.632003] eth0: no IPv6 routers present
> [  103.564010] kmemleak: 29 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
> [  200.380003] Hangcheck: hangcheck value past margin!
> [  248.192003] INFO: task S99local:2974 blocked for more than 120 seconds.
> [  248.194532] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  248.202330] S99local      D 0000000c  6256  2974   2687 0x00000000
> [  248.208929]  9c7ebe90 00000086 6b67ef8b 0000000c 9f25a610 81a69869 00000001 820b6990
> [  248.216123]  820b6990 820b6990 9c6e4c20 9c6e4eb4 82c78990 00000000 6b993559 0000000c
> [  248.220616]  9c7ebe90 8105f22a 9c6e4eb4 9c6e4c20 00000001 9c7ebe98 9c7ebeb4 81a65cb3
> [  248.229990] Call Trace:
> [  248.234049]  [<81a69869>] ? _spin_unlock_irqrestore+0x22/0x37
> [  248.239769]  [<8105f22a>] ? prepare_to_wait+0x48/0x4e
> [  248.244796]  [<81a65cb3>] rcu_barrier_cpu_hotplug+0xaa/0xc9
> [  248.250343]  [<8105f029>] ? autoremove_wake_function+0x0/0x38
> [  248.256063]  [<81062cf2>] notifier_call_chain+0x49/0x71
> [  248.261263]  [<81062da0>] raw_notifier_call_chain+0x11/0x13
> [  248.266809]  [<81a0b475>] _cpu_down+0x272/0x288
> [  248.271316]  [<81a0b4d5>] cpu_down+0x4a/0xa2
> [  248.275563]  [<81a0c48a>] store_online+0x2a/0x5e
> [  248.280156]  [<81a0c460>] ? store_online+0x0/0x5e
> [  248.284836]  [<814ddc35>] sysdev_store+0x20/0x28
> [  248.289429]  [<8112e403>] sysfs_write_file+0xb8/0xe3
> [  248.294369]  [<8112e34b>] ? sysfs_write_file+0x0/0xe3
> [  248.299396]  [<810e4c8f>] vfs_write+0x91/0x120
> [  248.303817]  [<810e4dc1>] sys_write+0x40/0x65
> [  248.308150]  [<81002d73>] sysenter_do_call+0x12/0x28
> 
> config and bootlog attached. I'd suspect one of these patches:
> 
> 684ca5c: rcu: Fix typo in rcu_irq_exit() comment header
> b612ba8: rcu: Make rcupreempt_trace.c look at offline CPUs
> 8064d54: rcu: Make preemptable RCU scan all CPUs when summing RCU counters
> 2e59755: rcu: Simplify RCU CPU-hotplug notification
> 799e64f: cpu hotplug: Introduce cpu_notifier() to handle !HOTPLUG_CPU case
> 2756962: rcu: Split hierarchical RCU initialization into boot-time and CPU-online piece
> 
> Any ideas?
> 

[...]

> [    0.484001] Booting processor 1 APIC 0x1 ip 0x6000
> [    0.004000] Initializing CPU#1
> [    0.004000] masked ExtINT on CPU#1
> [    0.004000] Calibrating delay loop... 2007.04 BogoMIPS (lpj=4014080)
> [    0.004000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
> [    0.004000] CPU: L2 Cache: 512K (64 bytes/line)
> [    0.004000] CPU: Physical Processor ID: 0
> [    0.004000] CPU: Processor Core ID: 1
> [    0.004000] mce: CPU supports 5 MCE banks
> [    0.588001] CPU1: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 02

I would not trust this architecture for synchronization tests. There has
been reports of a hardware bug affecting the cmpxchg instruction in the
field. The load fence normally implied by the semantic seems to be
missing. AFAIK, AMD never acknowledged the problem.

So far I have proposed a best effort fix for this (patching in an lfence
after cmpxchg), but userspace would still be buggy.

http://lkml.indiana.edu/hypermail/linux/kernel/0904.2/03024.html

However, in this particular RCU case, __wait_event() calls
prepare_to_wait() which uses set_current_state(). This in turn uses
xchg(), which has an implied memory barrier. This barrier is required
for proper ordering of the condition test wrt preparing the wait queue.
Maybe it would be worth checking if amd did not screw up the xchg
instruction too on this architecture.

So I am not saying that there is not another bug hidden somewhere, but
until this can be reproduced on a different architecture, I think we
should consider that the problem might be caused by missing hardware
synchronization.

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
