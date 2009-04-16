Return-Path: <linux-kernel-owner+w=401wt.eu-S1753732AbZDPIk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732AbZDPIk2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 04:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752292AbZDPIkQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 04:40:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43632 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752395AbZDPIkO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 04:40:14 -0400
Date: Thu, 16 Apr 2009 10:39:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH] tracing: add #include <linux/delay.h> to fix build failure
	in test_work()
Message-ID: <20090416083934.GB9813@elte.hu>
References: <20090416021830.556671772@goodmis.org> <20090416021928.239106997@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090416021928.239106997@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> From: Steven Rostedt <srostedt@redhat.com>
> 
> As events start to become popular, and the new way to add tracing 
> infrastructure into ftrace, it is important to catch any problems 
> that might happen with a mistake in the TRACE_EVENT macro.
> 
> This patch introduces a startup self test on the registered trace 
> events. Note, it can only do a generic test, any type of testing 
> that needs more involement is needed to be implemented by the 
> tracepoint creators.
> 
> The test goes down one by one enabling a trace point and running 
> some random tasks (random in the sense that I just made them up). 
> Those tasks are creating threads, grabbing mutexes and spinlocks 
> and using workqueues.
> 
> After testing each event individually, it does the same test after
> enabling each system of trace points. Like sched, irq, lockdep.
> 
> Then finally it enables all tracepoints and performs the tasks 
> again. The output to the console on bootup will look like this 
> when everything works:
> 
> Running tests on trace events:
> Testing event kfree_skb: OK
> Testing event kmalloc: OK
> Testing event kmem_cache_alloc: OK
> Testing event kmalloc_node: OK
> Testing event kmem_cache_alloc_node: OK
> Testing event kfree: OK
> Testing event kmem_cache_free: OK
> Testing event irq_handler_exit: OK
> Testing event irq_handler_entry: OK
> Testing event softirq_entry: OK
> Testing event softirq_exit: OK
> Testing event lock_acquire: OK
> Testing event lock_release: OK
> Testing event sched_kthread_stop: OK
> Testing event sched_kthread_stop_ret: OK
> Testing event sched_wait_task: OK
> Testing event sched_wakeup: OK
> Testing event sched_wakeup_new: OK
> Testing event sched_switch: OK
> Testing event sched_migrate_task: OK
> Testing event sched_process_free: OK
> Testing event sched_process_exit: OK
> Testing event sched_process_wait: OK
> Testing event sched_process_fork: OK
> Testing event sched_signal_send: OK
> Running tests on trace event systems:
> Testing event system skb: OK
> Testing event system kmem: OK
> Testing event system irq: OK
> Testing event system lockdep: OK
> Testing event system sched: OK
> Running tests on all trace events:
> Testing all events: OK

Thanks Steve, really nice!

FYI, it needed the small build fix below.

	Ingo

------------------------>
>From 63c14122a54c26122ccdbe596123f8e2b75c3116 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Thu, 16 Apr 2009 10:26:51 +0200
Subject: [PATCH] tracing: add #include <linux/delay.h> to fix build failure in test_work()
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

This build failure occured on a few rare configs:

 kernel/trace/trace_events.c: In function ‘test_work’:
 kernel/trace/trace_events.c:975: error: implicit declaration of function ‘udelay’
 kernel/trace/trace_events.c:980: error: implicit declaration of function ‘msleep’

delay.h is included in way too many other headers, hiding cases
where new usage is added without header inclusion.

Impact: build fix
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/trace/trace_events.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 96934f0..791501d 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -15,6 +15,7 @@
 #include <linux/uaccess.h>
 #include <linux/module.h>
 #include <linux/ctype.h>
+#include <linux/delay.h>
 
 #include "trace_output.h"
 
