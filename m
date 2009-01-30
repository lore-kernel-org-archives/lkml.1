Return-Path: <linux-kernel-owner+w=401wt.eu-S1754588AbZA3Ovp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588AbZA3Ovp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 09:51:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751756AbZA3Ovh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 09:51:37 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57743 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751631AbZA3Ovg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 09:51:36 -0500
Date: Fri, 30 Jan 2009 15:51:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, npiggin@suse.de,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH -v4] use per cpu data for single cpu ipi calls
Message-ID: <20090130145105.GB31009@elte.hu>
References: <alpine.DEB.1.10.0901290958170.13065@gandalf.stny.rr.com> <alpine.LFD.2.00.0901290912320.3123@localhost.localdomain> <alpine.DEB.1.10.0901291232570.27527@gandalf.stny.rr.com> <alpine.LFD.2.00.0901290959540.3123@localhost.localdomain> <1233253380.4495.123.camel@laptop> <alpine.LFD.2.00.0901291030510.3123@localhost.localdomain> <1233254680.4495.126.camel@laptop> <20090130112310.GI30821@kernel.dk> <1233318733.4495.174.camel@laptop> <1233320548.4495.181.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233320548.4495.181.camel@laptop>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> Author: Steven Rostedt <rostedt@goodmis.org>
> Date:   Thu Jan 29 10:08:01 2009 -0500
> 
>     generic-ipi: use per cpu data for single cpu ipi calls
> 
>     The smp_call_function can be passed a wait parameter telling it to
>     wait for all the functions running on other CPUs to complete before
>     returning, or to return without waiting. Unfortunately, this is
>     currently just a suggestion and not manditory. That is, the
>     smp_call_function can decide not to return and wait instead.
> 
>     The reason for this is because it uses kmalloc to allocate storage
>     to send to the called CPU and that CPU will free it when it is done.
>     But if we fail to allocate the storage, the stack is used instead.
>     This means we must wait for the called CPU to finish before
>     continuing.
> 
>     Unfortunatly, some callers do no abide by this hint and act as if
>     the non-wait option is mandatory. The MTRR code for instance will
>     deadlock if the smp_call_function is set to wait. This is because
>     the smp_call_function will wait for the other CPUs to finish their
>     called functions, but those functions are waiting on the caller to
>     continue.
> 
>     This patch changes the generic smp_call_function code to use per cpu
>     variables if the allocation of the data fails for a single CPU call. The
>     smp_call_function_many will fall back to the smp_call_function_single
>     if it fails its alloc. The smp_call_function_single is modified
>     to not force the wait state.
> 
>     Since we now are using a single data per cpu we must synchronize the
>     callers to prevent a second caller modifying the data before the
>     first called IPI functions complete. To do so, I added a flag to
>     the call_single_data called CSD_FLAG_LOCK. When the single CPU is
>     called (which can be called when a many call fails an alloc), we
>     set the LOCK bit on this per cpu data. When the caller finishes
>     it clears the LOCK bit.
> 
>     The caller must wait till the LOCK bit is cleared before setting
>     it. When it is cleared, there is no IPI function using it.
> 
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Acked-by: Jens Axboe <jens.axboe@oracle.com>
> ---
>  kernel/smp.c |   36 +++++++++++++++++++++++++++++++++---
>  1 files changed, 33 insertions(+), 3 deletions(-)

ok, i've updated the commit in tip/core/urgent with the commit line 
removal and the updated description. Find it below - any objections?

	Ingo

--------------------->
>From 05257ef396a72daef9ef57e01c8dc0d55351c5c7 Mon Sep 17 00:00:00 2001
From: Steven Rostedt <rostedt@goodmis.org>
Date: Thu, 29 Jan 2009 10:08:01 -0500
Subject: [PATCH] generic-ipi: use per cpu data for single cpu ipi calls

The smp_call_function can be passed a wait parameter telling it to
wait for all the functions running on other CPUs to complete before
returning, or to return without waiting. Unfortunately, this is
currently just a suggestion and not manditory. That is, the
smp_call_function can decide not to return and wait instead.

The reason for this is because it uses kmalloc to allocate storage
to send to the called CPU and that CPU will free it when it is done.
But if we fail to allocate the storage, the stack is used instead.
This means we must wait for the called CPU to finish before
continuing.

Unfortunatly, some callers do no abide by this hint and act as if
the non-wait option is mandatory. The MTRR code for instance will
deadlock if the smp_call_function is set to wait. This is because
the smp_call_function will wait for the other CPUs to finish their
called functions, but those functions are waiting on the caller to
continue.

This patch changes the generic smp_call_function code to use per cpu
variables if the allocation of the data fails for a single CPU call. The
smp_call_function_many will fall back to the smp_call_function_single
if it fails its alloc. The smp_call_function_single is modified
to not force the wait state.

Since we now are using a single data per cpu we must synchronize the
callers to prevent a second caller modifying the data before the
first called IPI functions complete. To do so, I added a flag to
the call_single_data called CSD_FLAG_LOCK. When the single CPU is
called (which can be called when a many call fails an alloc), we
set the LOCK bit on this per cpu data. When the caller finishes
it clears the LOCK bit.

The caller must wait till the LOCK bit is cleared before setting
it. When it is cleared, there is no IPI function using it.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/smp.c |   36 +++++++++++++++++++++++++++++++++---
 1 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/kernel/smp.c b/kernel/smp.c
index 5cfa0e5..bbedbb7 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -18,6 +18,7 @@ __cacheline_aligned_in_smp DEFINE_SPINLOCK(call_function_lock);
 enum {
 	CSD_FLAG_WAIT		= 0x01,
 	CSD_FLAG_ALLOC		= 0x02,
+	CSD_FLAG_LOCK		= 0x04,
 };
 
 struct call_function_data {
@@ -186,6 +187,9 @@ void generic_smp_call_function_single_interrupt(void)
 			if (data_flags & CSD_FLAG_WAIT) {
 				smp_wmb();
 				data->flags &= ~CSD_FLAG_WAIT;
+			} else if (data_flags & CSD_FLAG_LOCK) {
+				smp_wmb();
+				data->flags &= ~CSD_FLAG_LOCK;
 			} else if (data_flags & CSD_FLAG_ALLOC)
 				kfree(data);
 		}
@@ -196,6 +200,8 @@ void generic_smp_call_function_single_interrupt(void)
 	}
 }
 
+static DEFINE_PER_CPU(struct call_single_data, csd_data);
+
 /*
  * smp_call_function_single - Run a function on a specific CPU
  * @func: The function to run. This must be fast and non-blocking.
@@ -224,14 +230,38 @@ int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
 		func(info);
 		local_irq_restore(flags);
 	} else if ((unsigned)cpu < nr_cpu_ids && cpu_online(cpu)) {
-		struct call_single_data *data = NULL;
+		struct call_single_data *data;
 
 		if (!wait) {
+			/*
+			 * We are calling a function on a single CPU
+			 * and we are not going to wait for it to finish.
+			 * We first try to allocate the data, but if we
+			 * fail, we fall back to use a per cpu data to pass
+			 * the information to that CPU. Since all callers
+			 * of this code will use the same data, we must
+			 * synchronize the callers to prevent a new caller
+			 * from corrupting the data before the callee
+			 * can access it.
+			 *
+			 * The CSD_FLAG_LOCK is used to let us know when
+			 * the IPI handler is done with the data.
+			 * The first caller will set it, and the callee
+			 * will clear it. The next caller must wait for
+			 * it to clear before we set it again. This
+			 * will make sure the callee is done with the
+			 * data before a new caller will use it.
+			 */
 			data = kmalloc(sizeof(*data), GFP_ATOMIC);
 			if (data)
 				data->flags = CSD_FLAG_ALLOC;
-		}
-		if (!data) {
+			else {
+				data = &per_cpu(csd_data, me);
+				while (data->flags & CSD_FLAG_LOCK)
+					cpu_relax();
+				data->flags = CSD_FLAG_LOCK;
+			}
+		} else {
 			data = &d;
 			data->flags = CSD_FLAG_WAIT;
 		}
