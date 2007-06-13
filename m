Return-Path: <linux-kernel-owner+w=401wt.eu-S1758522AbXFMMsI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758522AbXFMMsI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 08:48:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757740AbXFMMr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 08:47:57 -0400
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:62703 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757878AbXFMMr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 08:47:56 -0400
Subject: [PATCH RT] fix migrating softirq [cause of network hang]
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>
Content-Type: text/plain
Date: Wed, 13 Jun 2007 08:47:16 -0400
Message-Id: <1181738836.10408.54.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Softirqs are bound to a single CPU.  That is to say, that once a softirq
function starts to run, it will stay on the CPU that it is running on
while it's running.

In RT, softirqs are threads, and we have a softirq thread per cpu. Each
softirq thread is bound to a single CPU that it represents.

In order to speed things up and lower context switches in RT, if a
softirq thread is of the same priority as an interrupt thread, then when
the interrupt thread is about to exit, it tests to see if any softirq
threads need to be run on that cpu. Instead of running the softirq
thread, it simply performs the functions for the softirq within the
interrupt thread.

The problem is, nothing prevents the interrupt thread from migrating.

So while the interrupt thread is running the softirq function, it may
migrate to another CPU in the middle of that function. This means that
any CPU data that the softirq is touching can be corrupted.

I was experiencing a network hang that sometimes would come back, and
sometimes not. Using my logdev debugger, I started to debug this
problem.  I came across this at the moment of the hang:


[  389.131279] cpu:0 (IRQ-11:427) tcp_rcv_established:4056 rcv_nxt=-1665585797
[  389.131615] cpu:1 192.168.23.72:22 <== 192.168.23.60:41352 ack:2629381499 seq:1773074099 (----A-) len:0 win:790 end_seq:1773074099
[  389.131626] cpu:1 (IRQ-11:427) ip_finish_output2:187 dst->hh=ffff81003b213080
[  389.131635] cpu:1 (IRQ-11:427) ip_finish_output2:189 hh_output=ffffffff80429009


Here we see IRQ-11 in the process of finishing up the softirq-net-tx
function. In the middle of it, we receive a packet, and that must have
pushed the interrupt thread over to CPU 1, and it finished up the
softirq there.

This patch temporarily binds the hardirq thread on the CPU that it runs
the softirqs on.  With this patch I have not seen my network hang. I ran
it over night, doing compiles and such, and it seems fine. I would be
able to cause the hang with various loads within a minute, now I can't
cause it after several minutes.

I'm assuming that this fix may fix other bugs too.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Index: linux-2.6.21.4-rt12/kernel/softirq.c
===================================================================
--- linux-2.6.21.4-rt12.orig/kernel/softirq.c
+++ linux-2.6.21.4-rt12/kernel/softirq.c
@@ -426,8 +426,25 @@ void do_softirq_from_hardirq(void)
 	current->flags &= ~PF_HARDIRQ;
 	current->flags |= PF_SOFTIRQ;
 
+#ifdef CONFIG_PREEMPT_HARDIRQS
+	{
+	cpumask_t save_cpus_allowed, cpus_allowed;
+
+	/* Don't let ourselves migrate */
+	save_cpus_allowed = current->cpus_allowed;
+	cpu_set(smp_processor_id(), cpus_allowed);
+	set_cpus_allowed(current, cpus_allowed);
+#endif
+
 	___do_softirq(1);
 
+#ifdef CONFIG_PREEMPT_HARDIRQS
+	/* Put back our original mask. */
+	WARN_ON(!cpus_equal(current->cpus_allowed, cpus_allowed));
+	set_cpus_allowed(current, save_cpus_allowed);
+	}
+#endif
+
 #ifndef CONFIG_PREEMPT_SOFTIRQS
 	trace_softirq_exit();
 #endif


