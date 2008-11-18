Return-Path: <linux-kernel-owner+w=401wt.eu-S1752864AbYKRMyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864AbYKRMyR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 07:54:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751671AbYKRMyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 07:54:04 -0500
Received: from mtagate7.de.ibm.com ([195.212.29.156]:40400 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbYKRMyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 07:54:02 -0500
Date: Tue, 18 Nov 2008 13:54:00 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: ftrace: preemptoff selftest not working
Message-ID: <20081118125359.GA4417@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

I was wondering why the preemptoff and preemptirqsoff tracer selftests
don't work on s390. After all its just that they get called from
non-preemptible context:

kernel_init() will execute all initcalls, however the first line in
kernel_init() is lock_kernel(), which causes the preempt_count to be
increased. Any later calls to add_preempt_count() (especially those
from the selftests) will therefore not result in a call to
trace_preempt_off() since the check below in add_preempt_count()
will be false:

	if (preempt_count() == val)
		trace_preempt_off(CALLER_ADDR0, get_parent_ip(CALLER_ADDR1));

Hence the trace buffer will be empty.
The patch below makes the selftests working for me, since then they run
in preemptible context. But it is ugly and I'm not proposing it for
upstream ;)

Just wanted to make you aware that there is a bug.

---
 init/main.c                  |    4 ++++
 kernel/trace/trace_irqsoff.c |    3 +--
 2 files changed, 5 insertions(+), 2 deletions(-)

Index: linux-2.6/kernel/trace/trace_irqsoff.c
===================================================================
--- linux-2.6.orig/kernel/trace/trace_irqsoff.c
+++ linux-2.6/kernel/trace/trace_irqsoff.c
@@ -482,7 +482,7 @@ static struct tracer preemptirqsoff_trac
 # define register_preemptirqsoff(trace) do { } while (0)
 #endif
 
-__init static int init_irqsoff_tracer(void)
+int init_irqsoff_tracer(void)
 {
 	register_irqsoff(irqsoff_tracer);
 	register_preemptoff(preemptoff_tracer);
@@ -490,4 +490,3 @@ __init static int init_irqsoff_tracer(vo
 
 	return 0;
 }
-device_initcall(init_irqsoff_tracer);
Index: linux-2.6/init/main.c
===================================================================
--- linux-2.6.orig/init/main.c
+++ linux-2.6/init/main.c
@@ -789,6 +789,8 @@ static void run_init_process(char *init_
 	kernel_execve(init_filename, argv_init, envp_init);
 }
 
+extern int init_irqsoff_tracer(void);
+
 /* This is a non __init function. Force it to be noinline otherwise gcc
  * makes it inline to init() and it becomes part of init.text section
  */
@@ -800,6 +802,8 @@ static int noinline init_post(void)
 	system_state = SYSTEM_RUNNING;
 	numa_default_policy();
 
+	init_irqsoff_tracer();
+
 	if (sys_open((const char __user *) "/dev/console", O_RDWR, 0) < 0)
 		printk(KERN_WARNING "Warning: unable to open an initial console.\n");
 
