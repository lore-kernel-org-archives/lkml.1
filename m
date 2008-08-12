Return-Path: <linux-kernel-owner+w=401wt.eu-S1752653AbYHLIFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653AbYHLIFj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 04:05:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751490AbYHLIFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 04:05:24 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:44307 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751575AbYHLIFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 04:05:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Message-Id;
  b=rYrN516Mv2w+3UEBdL6WjixwO07yJGnKEHDt3COFdUbBRD/0pXzVEvouOWJuCKCtq6F2/i2oQKgzUD2hF/joLvNmEjiMUYojJ4hp+8jBHpvlP7ttXuGTKqd/fwaN8zEwLFftDZpehGYxLoVn7GsaPJFj3/oXi3FCZWcqR/tZctI=  ;
X-YMail-OSG: MrtUMbEVM1nPmMfOudb.81AUGEFkoc2FcbN6KhGy0eldQPSSRUp2l3cnSCPYdcLx4UEGt2KZrOJsg1WDtV2fZRRL6YWXRH6hRsK8LgNJVmFWCCjfgfTscEwAe7sBuZ4Qj6IvvpyinrgVwn2U3M.IkB3s
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [git pull] core fixes
Date: Tue, 12 Aug 2008 18:05:13 +1000
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "David S. Miller" <davem@davemloft.net>
References: <20080811222026.GA20579@elte.hu> <200808121613.24846.nickpiggin@yahoo.com.au>
In-Reply-To: <200808121613.24846.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_6QUoIl1RjpG1zc2"
Message-Id: <200808121805.14009.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_6QUoIl1RjpG1zc2
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Tuesday 12 August 2008 16:13, Nick Piggin wrote:
> On Tuesday 12 August 2008 08:20, Ingo Molnar wrote:

> > Nick Piggin (1):
> >       generic-ipi: fix stack and rcu interaction bug in
> > smp_call_function_mask()
>
> I'm still not 100% sure that I have this patch right... I might have seen
> a lockup trace implicating the smp call function path... which may have
> been due to some other problem or a different bug in the new call function
> code, but if some more people can take a look at it before merging?

OK indeed it did have a couple of bugs. Firstly, I wasn't freeing the
data properly in the alloc && wait case. Secondly, I wasn't resetting
CSD_FLAG_WAIT in the for each cpu loop (so only the first CPU would
wait).

After those fixes, the patch boots and runs with the kmalloc commented
out (so it always executes the slowpath).


--Boundary-00=_6QUoIl1RjpG1zc2
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="kernel-smp-call-function-fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="kernel-smp-call-function-fix.patch"

Index: linux-2.6/kernel/smp.c
===================================================================
--- linux-2.6.orig/kernel/smp.c	2008-08-12 17:45:07.000000000 +1000
+++ linux-2.6/kernel/smp.c	2008-08-12 18:02:27.000000000 +1000
@@ -135,7 +135,8 @@ void generic_smp_call_function_interrupt
 			 */
 			smp_wmb();
 			data->csd.flags &= ~CSD_FLAG_WAIT;
-		} else
+		}
+		if (data->csd.flags & CSD_FLAG_ALLOC)
 			call_rcu(&data->rcu_head, rcu_free_call_data);
 	}
 	rcu_read_unlock();
@@ -260,6 +261,42 @@ void __smp_call_function_single(int cpu,
 	generic_exec_single(cpu, data);
 }
 
+/* Dummy function */
+static void quiesce_dummy(void *unused)
+{
+}
+
+/*
+ * Ensure stack based data used in call function mask is safe to free.
+ *
+ * This is needed by smp_call_function_mask when using on-stack data, because
+ * a single call function queue is shared by all CPUs, and any CPU may pick up
+ * the data item on the queue at any time before it is deleted. So we need to
+ * ensure that all CPUs have transitioned through a quiescent state after
+ * this call.
+ *
+ * This is a very slow function, implemented by sending synchronous IPIs to
+ * all possible CPUs. For this reason, we have to alloc data rather than use
+ * stack based data even in the case of synchronous calls. The stack based
+ * data is then just used for deadlock/oom fallback which will be very rare.
+ *
+ * If a faster scheme can be made, we could go back to preferring stack based
+ * data -- the data allocation/free is non-zero cost.
+ */
+static void smp_call_function_mask_quiesce_stack(cpumask_t mask)
+{
+	struct call_single_data data;
+	int cpu;
+
+	data.func = quiesce_dummy;
+	data.info = NULL;
+
+	for_each_cpu_mask(cpu, mask) {
+		data.flags = CSD_FLAG_WAIT;
+		generic_exec_single(cpu, &data);
+	}
+}
+
 /**
  * smp_call_function_mask(): Run a function on a set of other CPUs.
  * @mask: The set of cpus to run on.
@@ -285,6 +322,7 @@ int smp_call_function_mask(cpumask_t mas
 	cpumask_t allbutself;
 	unsigned long flags;
 	int cpu, num_cpus;
+	int slowpath = 0;
 
 	/* Can deadlock when called with interrupts disabled */
 	WARN_ON(irqs_disabled());
@@ -306,15 +344,16 @@ int smp_call_function_mask(cpumask_t mas
 		return smp_call_function_single(cpu, func, info, wait);
 	}
 
-	if (!wait) {
-		data = kmalloc(sizeof(*data), GFP_ATOMIC);
-		if (data)
-			data->csd.flags = CSD_FLAG_ALLOC;
-	}
-	if (!data) {
+	data = kmalloc(sizeof(*data), GFP_ATOMIC);
+	if (data) {
+		data->csd.flags = CSD_FLAG_ALLOC;
+		if (wait)
+			data->csd.flags |= CSD_FLAG_WAIT;
+	} else {
 		data = &d;
 		data->csd.flags = CSD_FLAG_WAIT;
 		wait = 1;
+		slowpath = 1;
 	}
 
 	spin_lock_init(&data->lock);
@@ -331,8 +370,11 @@ int smp_call_function_mask(cpumask_t mas
 	arch_send_call_function_ipi(mask);
 
 	/* optionally wait for the CPUs to complete */
-	if (wait)
+	if (wait) {
 		csd_flag_wait(&data->csd);
+		if (unlikely(slowpath))
+			smp_call_function_mask_quiesce_stack(mask);
+	}
 
 	return 0;
 }

--Boundary-00=_6QUoIl1RjpG1zc2--
