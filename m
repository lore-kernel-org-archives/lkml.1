Return-Path: <linux-kernel-owner+w=401wt.eu-S1758602AbYCAKZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758602AbYCAKZ2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 05:25:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753310AbYCAKZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 05:25:17 -0500
Received: from www.tglx.de ([62.245.132.106]:44126 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750921AbYCAKZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 05:25:15 -0500
Message-Id: <20080301100019.640027768@linutronix.de>
User-Agent: quilt/0.46-1
Date: Sat, 01 Mar 2008 10:24:52 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Greg KH <greg@kroah.com>
Subject: [patch 0/2] object debugging infrastructure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can see an ever repeating problem pattern with objects of any kind in
the kernel:

1) free of active objects
2) reinitialization of active objects

Both problems can be hard to debug because the symptoms surface at a
point where we have no chance to decode the root cause anymore. One
problem spot are kernel timers, where the detection of the problem
often happens in interrupt context and usually causes the machine to
panic.

While working on a timer related bug report I had to hack in
specialized code into the timer subsystem to get a reasonable hint for
the root cause. This debug hack was fine for temporary use, but far
from a mergeable solution due to the intrusiveness into the timer code
and the lack of the ability to detect and report the root cause
instantly and at the same time keeping the system operational so that
we have a decent chance to get hold of the debug information without
special debugging aids like serial consoles.

The problems described above are not restricted to timers, but timers
tend to expose it usually in a full system crash. Other objects are
less explosive, but the symptoms caused by such mistakes can be even
harder to debug.

Instead of creating specialized debugging code for the timer subsystem
a generic infrastructure is created which allows developers to verify
their code and provides an easy to enable debug facility for users in
case of trouble.

The debugobjects core code keeps track of operations on static and
dynamic objects by inserting them into a hashed list and sanity
checking them on object operations and providing additional checks
whenever kernel memory is freed.

The tracked object operations are:
- initializing an object
- adding an object to a subsystem list
- deleting an object from a subsystem list

Each operation is sanity checked before the operation is executed and
the subsystem specific code can provide a fixup function which prevents
the damage of the operation. When the sanity check triggers a warning
message and a stack trace is printed.

The list of operations can be extended if the need arises. For now it's
limited to the requirements of the first user (timers).

The core code enqueues the objects into hash buckets. The hash index
is generated from the address of the object to simplify the lookup for
the check on k/vfree. Each bucket has it's own spinlock to avoid
contention on a global lock.

The debug code can be compiled in without being active. The runtime
overhead is minimal and could be optimized by asm alternatives. A
kernel command line option enables the debugging code.

A recent real world debugging session shows the usefulness:

Initial bug report:

BUG: unable to handle kernel NULL pointer dereference at 00000000
IP: [<c0131f3e>] get_next_timer_interrupt+0xfe/0x210
....
Call Trace:
 [<c014627c>] ? tick_nohz_stop_sched_tick+0x13c/0x350
....

The reporter was asked to enable list debugging:

kernel BUG at lib/list_debug.c:33!
...
 [<c0131776>] ? internal_add_timer+0x36/0xb0
 [<c01434ca>] ? clocksource_watchdog+0x22a/0x240
....

Enabling slab poisoning identified the problem as use after free:

BUG: unable to handle kernel paging request at 6b6b6b6b
IP: [<c0131f3e>] get_next_timer_interrupt+0xfe/0x210
....

The above debug informations had to be transscripted from the monitor
due to a full machine crash and at no point it gave any useful hint of
the root cause.

Enabling the object debugging code gave:

Feb 27 07:24:22 kkbox kernel: ODEBUG: free active object: timer_list
Feb 27 07:24:22 kkbox kernel: WARNING: at lib/debugobjects.c:63 debug_print_object+0x64/0x66()
...
Feb 27 07:24:22 kkbox kernel:  [<c01f57e6>] debug_print_object+0x64/0x66
Feb 27 07:24:22 kkbox kernel:  [<c01f5860>] debug_check_no_obj_freed+0x78/0xd5
Feb 27 07:24:22 kkbox kernel:  [<c017dc04>] kfree+0x6c/0xce
Feb 27 07:24:22 kkbox kernel:  [<f9077cbb>] ? l2cap_conn_del+0x5c/0x64 [l2cap]
Feb 27 07:24:22 kkbox kernel:  [<f9077cbb>] l2cap_conn_del+0x5c/0x64 [l2cap]
Feb 27 07:24:22 kkbox kernel:  [<f9077ce5>] l2cap_disconn_ind+0x22/0x27 [l2cap]
Feb 27 07:24:22 kkbox kernel:  [<f8e552fd>] hci_event_packet+0x628/0x19b7 [bluetooth]

The debug information was retrieved from the syslog on a full operational
system, because the fixup code deactivated the timer before returning to
the calling code. The location of the culprit was exactly pointed out by
the stack trace.

Comments, suggestions are welcome as usual.

Thanks,
	tglx

-- 

