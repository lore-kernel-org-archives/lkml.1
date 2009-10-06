Return-Path: <linux-kernel-owner+w=401wt.eu-S933432AbZJFVUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933432AbZJFVUz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 17:20:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933423AbZJFVUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 17:20:54 -0400
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:54444 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933422AbZJFVUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 17:20:54 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlsFAPZQy0pMROOX/2dsb2JhbACBUtJyhCoE
Date: Tue, 6 Oct 2009 17:20:15 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: [PATCH] tree rcu: Add debug RCU head option (v2)
Message-ID: <20091006212015.GB3934@Krystal>
References: <20091005235817.GA30691@Krystal> <20091006002441.GH6949@linux.vnet.ibm.com> <20091006020018.GA8901@Krystal> <20091006021417.GB8901@Krystal> <20091006030156.GC8901@Krystal> <20091006040235.GA6732@linux.vnet.ibm.com> <20091006051400.GA24465@Krystal> <20091006053051.GB24465@Krystal> <20091006054618.GA28121@Krystal> <20091006132831.GB6732@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20091006132831.GB6732@linux.vnet.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 16:24:18 up 49 days,  7:13,  3 users,  load average: 0.19, 0.19,
	0.18
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> On Tue, Oct 06, 2009 at 01:46:18AM -0400, Mathieu Desnoyers wrote:
> > * Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
> > > * Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
> > > > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > > 
> > > > > Classic RCU does have known bugs in its dyntick interface, which was one
> > > > > of the factors motivating its removal from mainline.  ;-)
> > > > > 
> > > > > 							Thanx, Paul
> > > > 
> > > > Recreated the problem with a simple test-case not involving lttng:
> > > > 
> > > > kernel 2.6.30.9
> > > > TREE RCU
> > > > 
> > > > loading this hacky module:
> > > > 
> > > 
> > > Please forget about this hacky module test case. It was not actually
> > > hung, just really slow when 8 cpus where up to get the prompt back from
> > > 1000 synchronize_sched() calls.
> > 
> > The only reliable way I can reproduce this on TREE RCU is with my
> > tracepoint.c and marker.c code with cpu hotplug/unplug. I'll dig into
> > those internals before blaming RCU itself. ;)
> 
> Well, I am not 100% certain that we have ever gotten the combination of
> any RCU and CPU hotplug working completely correctly.  I certainly never
> have done a formal proof of the two...

Hrm, yes. Well, even my vunmap problem seemed to be somewhat related to
a combination with CPU hotplug.

I moved the immediate values implementation to text_poke() instead. I
still get hangs when busy-looping cpu hotplug/unplug and marker
armall/disarmall.

I give up for now, I spent too much time on this already ;)
At least it works well on tree rcu as long as no cpu hotplug is done.
Here is the updated version of the DEBUG_RCU_HEAD. Could be useful.

Thanks,

Mathieu


tree rcu: Add debug RCU head option

Poisoning the rcu_head callback list. Only for rcu tree for now.

Helps finding racy users of call_rcu(), which results in hangs because list
entries are overwritten and/or skipped.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: mingo@elte.hu
CC: akpm@linux-foundation.org
---
 include/linux/rcupdate.h |   11 +++++++++++
 include/net/dst.h        |    2 ++
 kernel/rcutree.c         |   10 ++++++++++
 lib/Kconfig.debug        |    9 +++++++++
 4 files changed, 32 insertions(+)

Index: linux-2.6-lttng/include/linux/rcupdate.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/rcupdate.h	2009-10-06 12:32:22.000000000 -0400
+++ linux-2.6-lttng/include/linux/rcupdate.h	2009-10-06 12:33:30.000000000 -0400
@@ -49,6 +49,9 @@
 struct rcu_head {
 	struct rcu_head *next;
 	void (*func)(struct rcu_head *head);
+#ifdef CONFIG_DEBUG_RCU_HEAD
+	struct rcu_head *debug;
+#endif
 };
 
 /* Internal to kernel, but needed by rcupreempt.h. */
@@ -64,11 +67,19 @@ extern int rcu_scheduler_active;
 #error "Unknown RCU implementation specified to kernel configuration"
 #endif /* #else #if defined(CONFIG_CLASSIC_RCU) */
 
+#ifdef CONFIG_DEBUG_RCU_HEAD
+#define RCU_HEAD_INIT 	{ .next = NULL, .func = NULL, .debug = NULL }
+#define RCU_HEAD(head) struct rcu_head head = RCU_HEAD_INIT
+#define INIT_RCU_HEAD(ptr) do { \
+       (ptr)->next = NULL; (ptr)->func = NULL; (ptr)->debug = NULL; \
+} while (0)
+#else
 #define RCU_HEAD_INIT 	{ .next = NULL, .func = NULL }
 #define RCU_HEAD(head) struct rcu_head head = RCU_HEAD_INIT
 #define INIT_RCU_HEAD(ptr) do { \
        (ptr)->next = NULL; (ptr)->func = NULL; \
 } while (0)
+#endif
 
 /**
  * rcu_read_lock - mark the beginning of an RCU read-side critical section.
Index: linux-2.6-lttng/kernel/rcutree.c
===================================================================
--- linux-2.6-lttng.orig/kernel/rcutree.c	2009-10-06 12:32:22.000000000 -0400
+++ linux-2.6-lttng/kernel/rcutree.c	2009-10-06 13:15:23.000000000 -0400
@@ -38,6 +38,7 @@
 #include <asm/atomic.h>
 #include <linux/bitops.h>
 #include <linux/module.h>
+#include <linux/poison.h>
 #include <linux/completion.h>
 #include <linux/moduleparam.h>
 #include <linux/percpu.h>
@@ -927,6 +928,10 @@ static void rcu_do_batch(struct rcu_data
 		next = list->next;
 		prefetch(next);
 		trace_rcu_tree_callback(list);
+#ifdef DEBUG_RCU_HEAD
+		WARN_ON_ONCE(list->debug != LIST_POISON1);
+		list->debug = NULL;
+#endif
 		list->func(list);
 		list = next;
 		if (++count >= rdp->blimit)
@@ -1194,6 +1199,11 @@ __call_rcu(struct rcu_head *head, void (
 	unsigned long flags;
 	struct rcu_data *rdp;
 
+#ifdef DEBUG_RCU_HEAD
+	WARN_ON_ONCE(head->debug);
+	head->debug = LIST_POISON1;
+#endif
+
 	head->func = func;
 	head->next = NULL;
 
Index: linux-2.6-lttng/lib/Kconfig.debug
===================================================================
--- linux-2.6-lttng.orig/lib/Kconfig.debug	2009-10-06 12:32:22.000000000 -0400
+++ linux-2.6-lttng/lib/Kconfig.debug	2009-10-06 12:32:26.000000000 -0400
@@ -598,6 +598,15 @@ config DEBUG_LIST
 
 	  If unsure, say N.
 
+config DEBUG_RCU_HEAD
+	bool "Debug RCU callbacks"
+	depends on DEBUG_KERNEL
+	depends on TREE_RCU
+	help
+	  Enable this to turn on debugging of RCU list heads (call_rcu() usage).
+	  Seems to find problems more quickly with stress-tests in single-cpu
+	  mode.
+
 config DEBUG_SG
 	bool "Debug SG table operations"
 	depends on DEBUG_KERNEL
Index: linux-2.6-lttng/include/net/dst.h
===================================================================
--- linux-2.6-lttng.orig/include/net/dst.h	2009-10-06 12:32:31.000000000 -0400
+++ linux-2.6-lttng/include/net/dst.h	2009-10-06 12:32:52.000000000 -0400
@@ -175,7 +175,9 @@ static inline void dst_hold(struct dst_e
 	 * If your kernel compilation stops here, please check
 	 * __pad_to_align_refcnt declaration in struct dst_entry
 	 */
+#ifndef CONFIG_DEBUG_RCU_HEAD
 	BUILD_BUG_ON(offsetof(struct dst_entry, __refcnt) & 63);
+#endif
 	atomic_inc(&dst->__refcnt);
 }
 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
