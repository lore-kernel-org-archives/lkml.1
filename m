Return-Path: <linux-kernel-owner+w=401wt.eu-S1754834AbYFJPWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834AbYFJPWa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 11:22:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752826AbYFJPWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 11:22:19 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:33568 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752689AbYFJPWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 11:22:18 -0400
X-Greylist: delayed 1496 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Jun 2008 11:22:18 EDT
Subject: Re: [PATCH 1/10] Add generic helpers for arch IPI function calls
From: Catalin Marinas <catalin.marinas@arm.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, npiggin@suse.de,
       linux-arch@vger.kernel.org, jeremy@goop.org, mingo@elte.hu,
       paulmck@linux.vnet.ibm.com, Russell King <rmk+lkml@arm.linux.org.uk>
In-Reply-To: <1212051504-12561-2-git-send-email-jens.axboe@oracle.com>
References: <1212051504-12561-1-git-send-email-jens.axboe@oracle.com>
	 <1212051504-12561-2-git-send-email-jens.axboe@oracle.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Tue, 10 Jun 2008 15:51:25 +0100
Message-Id: <1213109485.24701.107.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Jun 2008 14:51:26.0053 (UTC) FILETIME=[75248150:01C8CB09]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 2008-05-29 at 10:58 +0200, Jens Axboe wrote:
> This adds kernel/smp.c which contains helpers for IPI function calls. In
> addition to supporting the existing smp_call_function() in a more efficient
> manner, it also adds a more scalable variant called smp_call_function_single()
> for calling a given function on a single CPU only.
[...]
> + * You must not call this function with disabled interrupts or from a
> + * hardware interrupt handler or from a bottom half handler.
> + */
> +int smp_call_function_mask(cpumask_t mask, void (*func)(void *), void *info,
> +			   int wait)
> +{
> +	struct call_function_data d;
> +	struct call_function_data *data = NULL;
> +	cpumask_t allbutself;
> +	unsigned long flags;
> +	int cpu, num_cpus;
> +
> +	/* Can deadlock when called with interrupts disabled */
> +	WARN_ON(irqs_disabled());

I was thinking whether this condition can be removed and allow the
smp_call_function*() to be called with IRQs disabled. At a quick look,
it seems to be possible if the csd_flag_wait() function calls the IPI
handlers directly when the IRQs are disabled (see the patch below).

This would be useful on ARM11MPCore based systems where the cache
maintenance operations are not detected by the snoop control unit and
this affects the DMA calls like dma_map_single(). There doesn't seem to
be any restriction on calls to dma_map_single() and hence we cannot
broadcast the cache operation to the other CPUs. I could implement this
in the ARM specific code using spin_try_lock (on an IPI-specific lock
held during the cross-call) and polling for an IPI if a lock cannot be
acquired (meaning that a different CPU is issuing an IPI) but I was
wondering whether this would be possible in a more generic way.

Please let me know what you think or whether deadlocks are still
possible (or any other solution apart from hardware fixes :-)). Thanks.

diff --git a/kernel/smp.c b/kernel/smp.c
index ef6de3d..2c63e81 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -54,6 +54,10 @@ static void csd_flag_wait(struct call_single_data *data)
 		smp_mb();
 		if (!(data->flags & CSD_FLAG_WAIT))
 			break;
+		if (irqs_disabled()) {
+			generic_smp_call_function_single_interrupt();
+			generic_smp_call_function_interrupt();
+		}
 		cpu_relax();
 	} while (1);
 }
@@ -208,9 +212,6 @@ int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
 	/* prevent preemption and reschedule on another processor */
 	int me = get_cpu();
 
-	/* Can deadlock when called with interrupts disabled */
-	WARN_ON(irqs_disabled());
-
 	if (cpu == me) {
 		local_irq_save(flags);
 		func(info);
@@ -250,9 +251,6 @@ EXPORT_SYMBOL(smp_call_function_single);
  */
 void __smp_call_function_single(int cpu, struct call_single_data *data)
 {
-	/* Can deadlock when called with interrupts disabled */
-	WARN_ON((data->flags & CSD_FLAG_WAIT) && irqs_disabled());
-
 	generic_exec_single(cpu, data);
 }
 
@@ -279,9 +277,6 @@ int smp_call_function_mask(cpumask_t mask, void (*func)(void *), void *info,
 	unsigned long flags;
 	int cpu, num_cpus;
 
-	/* Can deadlock when called with interrupts disabled */
-	WARN_ON(irqs_disabled());
-
 	cpu = smp_processor_id();
 	allbutself = cpu_online_map;
 	cpu_clear(cpu, allbutself);


-- 
Catalin

