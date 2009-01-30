Return-Path: <linux-kernel-owner+w=401wt.eu-S1754930AbZA3Rp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930AbZA3Rp7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 12:45:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752903AbZA3Rpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 12:45:50 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:37161 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752570AbZA3Rpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 12:45:49 -0500
Date: Fri, 30 Jan 2009 20:45:45 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Steven Rostedt <srostedt@redhat.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-rt-users@vger.kernel.org
Subject: Re: 2.6.28-rt on PowerPC
Message-ID: <20090130174545.GA846@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20090129213429.GA29014@oksana.dev.rtsoft.ru> <1233270043.3833.57.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <1233270043.3833.57.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 29, 2009 at 06:00:43PM -0500, Steven Rostedt wrote:
[...]
> > BUG: sleeping function called from invalid context at kernel/rtmutex.c:683
> > in_atomic(): 1 [00000100], irqs_disabled(): 0, pid: 7, name: sirq-net-rx/0
> > Call Trace:
> > [cf84bc20] [c0008be8] show_stack+0x4c/0x16c (unreliable)
> > [cf84bc60] [c001c194] __might_sleep+0xd8/0xf8
> > [cf84bc70] [c02b7768] rt_spin_lock+0x30/0x78
> > [cf84bc80] [c00800e0] kmem_cache_alloc+0x50/0x17c
> > [cf84bcb0] [c02568a4] ip_append_data+0x974/0x978
> > [cf84bd30] [c027aa0c] icmp_push_reply+0x54/0x128
> > [cf84bd50] [c027b59c] icmp_send+0x284/0x380
> > [cf84be40] [c0277328] __udp4_lib_rcv+0x3d4/0x5a0
> > [cf84bea0] [c0253208] ip_local_deliver_finish+0x74/0x128
[...]
> Turn on CONFIG_PREEMPT_TRACE (not TRACER) and it should show the
> location that left preemption disabled.

Thank you Steven, PREEMPT_TRACE is a great tool indeed (though on
PowerPC it doesn't work out of the box, but easily fixable).

So, the result:

---------------------------
| preempt count: 00000100 ]
| 1-level deep critical section nesting:
----------------------------------------
.. [<c002d9fc>] .... local_bh_disable+0x1c/0x34
.....[<c02afef8>] ..   ( <= icmp_send+0xac/0x388)

icmp_send() calls icmp_xmit_lock() that disables bottom halves,
then icmp_send() calls ip_append_data() that tries to allocate
things with GFP_ATOMIC, which should be OK...

I guess now this isn't true for -rt kernels, correct? A comment
in slab.c ("which in turn implies that nobody does allocations
from atomic contexts") seem to confirm this.

(A bit unrelated question: If that's how things work now (i.e.
GFP_ATOMIC is equal to GFP_KERNEL or vice-versa), how should we
allocate things in IRQF_NODELAY/TIMER interrupts?)

Anyway, this snippet fixes the issue:

diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 6bccfbe..4a4862b 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -222,6 +222,9 @@ static inline struct sock *icmp_xmit_lock(struct net *net)
 		local_bh_enable();
 		return NULL;
 	}
+#ifdef CONFIG_PREEMPT_RT
+	local_bh_enable();
+#endif
 	return sk;
 }
 
--

Now the kernel is able to boot up to the login prompt, cool!

But after a while this pops up:

INFO: task sirq-high/0:4 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
sirq-high/0   D 00000000     0     4      2
Call Trace:
[cf839eb0] [60320800] 0x60320800 (unreliable)
[cf839f70] [c0009b34] __switch_to+0x50/0x74
[cf839f90] [c02ee48c] schedule+0x19c/0x380
[cf839fd0] [c00427ac] kthread+0x34/0x8c
[cf839ff0] [c001354c] kernel_thread+0x4c/0x68
---------------------------
| preempt count: 00000002 ]
| 2-level deep critical section nesting:
----------------------------------------
.. [<c02ee340>] .... schedule+0x50/0x380
.....[<c00427ac>] ..   ( <= kthread+0x34/0x8c)
.. [<c02f0700>] .... _spin_lock_irq+0x2c/0x4c
.....[<c02ee388>] ..   ( <= schedule+0x98/0x380)


And keeps popping up every 120 seconds, though both kernel and
userspace stay alive.

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
