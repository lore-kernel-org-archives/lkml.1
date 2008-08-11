Return-Path: <linux-kernel-owner+w=401wt.eu-S1754795AbYHKDtq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795AbYHKDtq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 23:49:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753862AbYHKDti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 23:49:38 -0400
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:34265 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753843AbYHKDth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 23:49:37 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Message-Id;
  b=29d6KQVuedP/SH++x5X3O6H5ttU1PcNsczurunbYUHxV3adIXce95ZHlhOJb6ZntDFjKagbN89AKd90cPx/u/2uED9wVfQBOgF1VDv6+v6BHQ7jmF+1X/sL0dbMggNAPKCwgHYYg2Ulh27sW/K6PSZPX4wvgwFT+XkQnYZwv+lA=  ;
X-YMail-OSG: O95.WKwVM1nMUolYisJZf2pIUvfy8YV6i3iCR..xkhXQFUvlrqf08b6n0CRi9l1.G2KJj2roUpTfLyVGbgIQlu62yH73UUY7rfxag5kxc_kymygkbPKcxTVCTGNGqL047OcVcH320brjHm6_5u5PfblO
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: [PATCH] stack and rcu interaction bug in smp_call_function_mask()
Date: Mon, 11 Aug 2008 13:49:30 +1000
User-Agent: KMail/1.9.5
Cc: Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       npiggin@suse.de, linux-kernel <linux-kernel@vger.kernel.org>,
       suresh.b.siddha@intel.com
References: <20080808193753.GA21964@linux-os.sc.intel.com> <200808101624.15112.nickpiggin@yahoo.com.au>
In-Reply-To: <200808101624.15112.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_Kb7nIS1ioWW2RsD"
Message-Id: <200808111349.30463.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_Kb7nIS1ioWW2RsD
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Sunday 10 August 2008 16:24, Nick Piggin wrote:

> I'd suggest something like the attached (untested) patch as the simple
> fix for now.
>
> I expect the benefits from the less synchronized, multiple-in-flight-data
> global queue will still outweigh the costs of dynamic allocations. But
> if worst comes to worst then we just go back to a globally synchronous
> one-at-a-time implementation, but that would be pretty sad!

Just needed a little fix and it appears to boot now. I think it does
the right thing...

--Boundary-00=_Kb7nIS1ioWW2RsD
Content-Type: text/x-diff;
  charset="utf-8";
  name="kernel-smp-call-function-fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="kernel-smp-call-function-fix.patch"

Index: linux-2.6/kernel/smp.c
===================================================================
--- linux-2.6.orig/kernel/smp.c
+++ linux-2.6/kernel/smp.c
@@ -260,6 +260,41 @@ void __smp_call_function_single(int cpu,
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
+	data.flags = CSD_FLAG_WAIT;
+
+	for_each_cpu_mask(cpu, mask)
+		generic_exec_single(cpu, &data);
+}
+
 /**
  * smp_call_function_mask(): Run a function on a set of other CPUs.
  * @mask: The set of cpus to run on.
@@ -285,6 +320,7 @@ int smp_call_function_mask(cpumask_t mas
 	cpumask_t allbutself;
 	unsigned long flags;
 	int cpu, num_cpus;
+	int slowpath = 0;
 
 	/* Can deadlock when called with interrupts disabled */
 	WARN_ON(irqs_disabled());
@@ -306,15 +342,16 @@ int smp_call_function_mask(cpumask_t mas
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
@@ -331,8 +368,11 @@ int smp_call_function_mask(cpumask_t mas
 	arch_send_call_function_ipi(mask);
 
 	/* optionally wait for the CPUs to complete */
-	if (wait)
+	if (wait) {
 		csd_flag_wait(&data->csd);
+		if (unlikely(slowpath))
+			smp_call_function_mask_quiesce_stack(allbutself);
+	}
 
 	return 0;
 }

--Boundary-00=_Kb7nIS1ioWW2RsD--
