Return-Path: <linux-kernel-owner+w=401wt.eu-S1753227AbYKSJDE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227AbYKSJDE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 04:03:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752308AbYKSJCs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 04:02:48 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54731 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752016AbYKSJCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 04:02:46 -0500
Date: Wed, 19 Nov 2008 10:02:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: ftrace: preemptoff selftest not working
Message-ID: <20081119090223.GA25282@elte.hu>
References: <20081118125359.GA4417@osiris.boeblingen.de.ibm.com> <alpine.DEB.1.10.0811180826510.15003@gandalf.stny.rr.com> <20081118135221.GE31146@elte.hu> <alpine.DEB.1.10.0811180931270.15003@gandalf.stny.rr.com> <20081118144751.GA30358@elte.hu> <20081118170635.GB4417@osiris.boeblingen.de.ibm.com> <alpine.DEB.1.10.0811181220530.15003@gandalf.stny.rr.com> <20081118205558.GA6243@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081118205558.GA6243@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>  #ifdef CONFIG_FTRACE_STARTUP_TEST
> +	/*
> +	 * When this gets called we hold the BKL which means that preemption
> +	 * is disabled. Various trace selftests however need to disable
> +	 * and enable preemption for successful tests. So we drop the BKL here
> +	 * and grab it after the tests again.
> +	 */
> +	unlock_kernel();
>  	if (type->selftest) {
>  		struct tracer *saved_tracer = current_trace;
>  		struct trace_array *tr = &global_trace;
> @@ -562,6 +569,7 @@ int register_tracer(struct tracer *type)
>  		}
>  		printk(KERN_CONT "PASSED\n");
>  	}
> +	lock_kernel();

dropping the BKL was a good idea, but the code flow was not 
investigated thoroughly enough, which caused this crash to trigger in 
-tip testing:

calling  utsname_sysctl_init+0x0/0x11 @ 1
initcall utsname_sysctl_init+0x0/0x11 returned 0 after 0 usecs
calling  init_sched_switch_trace+0x0/0xf @ 1
Testing tracer sched_switch: PASSED
initcall init_sched_switch_trace+0x0/0xf returned 0 after 101562 usecs
calling  init_stack_trace+0x0/0xf @ 1
Testing tracer sysprof: PASSED
initcall init_stack_trace+0x0/0xf returned 0 after 105468 usecs
calling  init_irqsoff_tracer+0x0/0x11 @ 1
Testing tracer irqsoff: .. no entries found ..FAILED!
initcall init_irqsoff_tracer+0x0/0x11 returned 0 after 3906 usecs
calling  init_mmio_trace+0x0/0xf @ 1
------------[ cut here ]------------
Kernel BUG at c0c0a915 [verbose debug info unavailable]
invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC
last sysfs file: 

Pid: 1, comm: swapper Not tainted (2.6.28-rc5-tip #53704) 
EIP: 0060:[<c0c0a915>] EFLAGS: 00010286 CPU: 1
EIP is at unlock_kernel+0x10/0x2b
EAX: ffffffff EBX: 00000000 ECX: 00000000 EDX: f7030000
ESI: c12da19c EDI: 00000000 EBP: f7039f54 ESP: f7039f54
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process swapper (pid: 1, ti=f7038000 task=f7030000 task.ti=f7038000)
Stack:
 f7039f6c c0164d30 c013fed8 a7d8d7b4 00000000 00000000 f7039f74 c12fb78a
 f7039fd0 c0101132 c12fb77d 00000000 6f727200 6f632072 2d206564 c1002031
 0000000f f7039fa2 f7039fb0 3531b171 00000000 00000000 0000002f c12ca480
Call Trace:
 [<c0164d30>] ? register_tracer+0x66/0x13f
 [<c013fed8>] ? ktime_get+0x19/0x1b
 [<c12fb78a>] ? init_mmio_trace+0xd/0xf
 [<c0101132>] ? do_one_initcall+0x4a/0x111
 [<c12fb77d>] ? init_mmio_trace+0x0/0xf
 [<c015c7e6>] ? init_irq_proc+0x46/0x59
 [<c12e851d>] ? kernel_init+0x104/0x152
 [<c12e8419>] ? kernel_init+0x0/0x152
 [<c01038b7>] ? kernel_thread_helper+0x7/0x10
Code: 58 14 43 75 0a b8 00 9b 2d c1 e8 51 43 7a ff 64 a1 00 a0 37 c1 89 58 14 5b 5d c3 55 64 8b 15 00 a0 37 c1 83 7a 14 00 89 e5 79 04 <0f> 0b eb fe 8b 42 14 48 85 c0 89 42 14 79 0a b8 00 9b 2d c1 e8 
EIP: [<c0c0a915>] unlock_kernel+0x10/0x2b SS:ESP 0068:f7039f54
---[ end trace a7919e7f17c0a725 ]---
Kernel panic - not syncing: Attempted to kill init!

the patch below fixes it.

	Ingo

-------------------->
>From 86fa2f60674540df0b34f5c547ed0c1cf3a8f212 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Wed, 19 Nov 2008 10:00:15 +0100
Subject: [PATCH] ftrace: fix selftest locking

Impact: fix self-test boot crash

Self-test failure forgot to re-lock the BKL - crashing the next
initcall:

Testing tracer irqsoff: .. no entries found ..FAILED!
initcall init_irqsoff_tracer+0x0/0x11 returned 0 after 3906 usecs
calling  init_mmio_trace+0x0/0xf @ 1
------------[ cut here ]------------
Kernel BUG at c0c0a915 [verbose debug info unavailable]
invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC
last sysfs file:

Pid: 1, comm: swapper Not tainted (2.6.28-rc5-tip #53704)
EIP: 0060:[<c0c0a915>] EFLAGS: 00010286 CPU: 1
EIP is at unlock_kernel+0x10/0x2b
EAX: ffffffff EBX: 00000000 ECX: 00000000 EDX: f7030000
ESI: c12da19c EDI: 00000000 EBP: f7039f54 ESP: f7039f54
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process swapper (pid: 1, ti=f7038000 task=f7030000 task.ti=f7038000)
Stack:
 f7039f6c c0164d30 c013fed8 a7d8d7b4 00000000 00000000 f7039f74 c12fb78a
 f7039fd0 c0101132 c12fb77d 00000000 6f727200 6f632072 2d206564 c1002031
 0000000f f7039fa2 f7039fb0 3531b171 00000000 00000000 0000002f c12ca480
Call Trace:
 [<c0164d30>] ? register_tracer+0x66/0x13f
 [<c013fed8>] ? ktime_get+0x19/0x1b
 [<c12fb78a>] ? init_mmio_trace+0xd/0xf
 [<c0101132>] ? do_one_initcall+0x4a/0x111
 [<c12fb77d>] ? init_mmio_trace+0x0/0xf
 [<c015c7e6>] ? init_irq_proc+0x46/0x59
 [<c12e851d>] ? kernel_init+0x104/0x152
 [<c12e8419>] ? kernel_init+0x0/0x152
 [<c01038b7>] ? kernel_thread_helper+0x7/0x10
Code: 58 14 43 75 0a b8 00 9b 2d c1 e8 51 43 7a ff 64 a1 00 a0 37 c1 89 58 14 5b 5d c3 55 64 8b 15 00 a0 37 c1 83 7a 14 00 89 e5 79 04 <0f> 0b eb fe 8b 42 14 48 85 c0 89 42 14 79 0a b8 00 9b 2d c1 e8
EIP: [<c0c0a915>] unlock_kernel+0x10/0x2b SS:ESP 0068:f7039f54
---[ end trace a7919e7f17c0a725 ]---
Kernel panic - not syncing: Attempted to kill init!

So clean up the flow a bit.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/trace/trace.c |   25 +++++++++++++------------
 1 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 1689212..24b6238 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -520,7 +520,15 @@ int register_tracer(struct tracer *type)
 		return -1;
 	}
 
+	/*
+	 * When this gets called we hold the BKL which means that
+	 * preemption is disabled. Various trace selftests however
+	 * need to disable and enable preemption for successful tests.
+	 * So we drop the BKL here and grab it after the tests again.
+	 */
+	unlock_kernel();
 	mutex_lock(&trace_types_lock);
+
 	for (t = trace_types; t; t = t->next) {
 		if (strcmp(type->name, t->name) == 0) {
 			/* already found */
@@ -532,13 +540,6 @@ int register_tracer(struct tracer *type)
 	}
 
 #ifdef CONFIG_FTRACE_STARTUP_TEST
-	/*
-	 * When this gets called we hold the BKL which means that preemption
-	 * is disabled. Various trace selftests however need to disable
-	 * and enable preemption for successful tests. So we drop the BKL here
-	 * and grab it after the tests again.
-	 */
-	unlock_kernel();
 	if (type->selftest) {
 		struct tracer *saved_tracer = current_trace;
 		struct trace_array *tr = &global_trace;
@@ -550,9 +551,9 @@ int register_tracer(struct tracer *type)
 		 * internal tracing to verify that everything is in order.
 		 * If we fail, we do not register this tracer.
 		 */
-		for_each_tracing_cpu(i) {
+		for_each_tracing_cpu(i)
 			tracing_reset(tr, i);
-		}
+
 		current_trace = type;
 		/* the test is responsible for initializing and enabling */
 		pr_info("Testing tracer %s: ", type->name);
@@ -564,12 +565,11 @@ int register_tracer(struct tracer *type)
 			goto out;
 		}
 		/* Only reset on passing, to avoid touching corrupted buffers */
-		for_each_tracing_cpu(i) {
+		for_each_tracing_cpu(i)
 			tracing_reset(tr, i);
-		}
+
 		printk(KERN_CONT "PASSED\n");
 	}
-	lock_kernel();
 #endif
 
 	type->next = trace_types;
@@ -580,6 +580,7 @@ int register_tracer(struct tracer *type)
 
  out:
 	mutex_unlock(&trace_types_lock);
+	lock_kernel();
 
 	return ret;
 }
