Return-Path: <linux-kernel-owner+w=401wt.eu-S1759835AbYEIWQN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759835AbYEIWQN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 18:16:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759576AbYEIWPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 18:15:54 -0400
Received: from [194.117.236.238] ([194.117.236.238]:37108 "EHLO
	heracles.linux360.ro" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1758573AbYEIWPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 18:15:51 -0400
Date: Sat, 10 May 2008 01:13:57 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, pmckenne@us.ibm.com,
       LKML <linux-kernel@vger.kernel.org>
Subject: Using markers w/ preemptible RCU in early code
Message-ID: <20080510011357.5466a631@linux360.ro>
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm working on the kmemtrace GSoC project and I'm having a little
problem.

My code inserts probes during early code (just after kmem_cache_init()).
This works on the classic RCU. But on the preemptible RCU, this
triggers BUG()s (supposedly on each probe, there are two), although the
kernel runs fine:

> BUG: scheduling while atomic: swapper/0/0x00000002
> Pid: 0, comm: swapper Not tainted 2.6.25-00002-gf80e324-dirty #16
> 
> Call Trace:
>  [<ffffffff802365f5>] __schedule_bug+0x65/0x70
>  [<ffffffff804f8bb0>] thread_return+0x346/0x566
>  [<ffffffff802734ba>] ? get_marker+0x23a/0x260
>  [<ffffffff8025fbc6>] ? put_online_cpus+0x46/0x70
>  [<ffffffff80270c88>] __synchronize_sched+0x48/0x80
>  [<ffffffff802741a2>] marker_probe_register+0x152/0x660
>  [<ffffffff8029af10>] ? kmemtrace_probe_alloc+0x0/0x1b0
>  [<ffffffff8029ad6d>] kmemtrace_init+0x4d/0xd0
>  [<ffffffff80693c05>] start_kernel+0x205/0x300
>  [<ffffffff806931b2>] _sinittext+0x1b2/0x200

The is triggered by the following code in marker_probe_register():
#ifdef CONFIG_PREEMPT_RCU
	synchronize_sched();    /* Until we have the call_rcu_sched() */
#endif

Since preemption and SMP are disabled during early code, we could do
something like:
diff --git a/kernel/marker.c b/kernel/marker.c
index 005b959..84964dc 100644
--- a/kernel/marker.c
+++ b/kernel/marker.c
@@ -23,6 +23,7 @@
 #include <linux/rcupdate.h>
 #include <linux/marker.h>
 #include <linux/err.h>
+#include <linux/hardirq.h>
 
 extern struct marker __start___markers[];
 extern struct marker __stop___markers[];
@@ -672,7 +673,9 @@ int marker_probe_register(const char *name, const char *format,
 	/* write rcu_pending before calling the RCU callback */
 	smp_wmb();
 #ifdef CONFIG_PREEMPT_RCU
-	synchronize_sched();	/* Until we have the call_rcu_sched() */
+	/* We are not preemptible when registering probes in early code */
+	if (likely(preemptible()))
+		synchronize_sched();	/* Until we have the call_rcu_sched() */
 #endif
 	call_rcu(&entry->rcu, free_old_closure);
 end:

Is this the best approach? marker_probe_register() isn't a hot path, so
that check won't mess up the performance. Anyway, this works for me.


	Eduard

(forgot LKML, added now.)
