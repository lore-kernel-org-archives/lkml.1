Return-Path: <linux-kernel-owner+w=401wt.eu-S1754140AbYHSGSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140AbYHSGSY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 02:18:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752184AbYHSGSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 02:18:16 -0400
Received: from gw.goop.org ([64.81.55.164]:43372 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752168AbYHSGSP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 02:18:15 -0400
Message-ID: <48AA65A5.8020408@goop.org>
Date: Mon, 18 Aug 2008 23:18:13 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Andi Kleen <andi@firstfloor.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 0 of 9] x86/smp function calls: convert x86 tlb flushes
 to use function calls [POST 2]
References: <patchbomb.1219083817@localhost> <20080819004531.GI9914@elte.hu> <20080819012816.GA7897@elte.hu>
In-Reply-To: <20080819012816.GA7897@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
>
>   
>> nice stuff!
>>
>> I suspect the extra cost might be worth it for two reasons: 1) we 
>> could optimize the cross-call implementation further 2) on systems 
>> where TLB flushes actually matter, the ability to overlap multiple TLB 
>> flushes to the same single CPU might improve workloads.
>>
>> FYI, i've created a new -tip topic for your patches, tip/x86/tlbflush. 
>> It's based on tip/irq/sparseirq (there are a good deal of dependencies 
>> with that topic).
>>     
>
> i threw it into -tip testing for a while - triggered the lockdep warning 
> on 64-bit below.
>
> 	Ingo
>
> ------------>
> checking TSC synchronization [CPU#0 -> CPU#1]: passed.
>
> =============================================
> [ INFO: possible recursive locking detected ]
> 2.6.27-rc3-tip #1
> ---------------------------------------------
> swapper/0 is trying to acquire lock:
>  (&call_function_queues[i].lock){....}, at: [<ffffffff8026cbba>] ipi_call_lock_irq+0x25/0x2e
>
> but task is already holding lock:
>  (&call_function_queues[i].lock){....}, at: [<ffffffff8026cbba>] ipi_call_lock_irq+0x25/0x2e
>   

I think this might be a spurious "holding multiple locks in the same
class" bug.  All the queue locks are presumably in the same class, and
ipi_call_lock_irq() wants to hold them all to lock out any IPIs. 
Spurious because this is the only place which holds more than one queue
lock, and it always locks 0->N.

I guess the fix is to use an outer lock and use spin_lock_nested() (now
that it exists).  Something along these lines?

    J

diff -r 22ebc3296a6f kernel/smp.c
--- a/kernel/smp.c	Mon Aug 18 15:12:14 2008 -0700
+++ b/kernel/smp.c	Mon Aug 18 22:52:22 2008 -0700
@@ -18,6 +18,9 @@
 #else
 #define	NQUEUES	1
 #endif
+
+/* Hold queues_lock when taking more than one queue[].lock at once */
+static DEFINE_SPINLOCK(queues_lock);
 
 static DEFINE_PER_CPU(struct call_single_queue, call_single_queue);
 struct ____cacheline_aligned queue {
@@ -446,8 +449,10 @@
 {
 	int i;
 
+	spin_lock_irq(&queues_lock);
+
 	for(i = 0; i < NQUEUES; i++)
-		spin_lock_irq(&call_function_queues[i].lock);
+		spin_lock_nest_lock(&call_function_queues[i].lock, &queues_lock);
 }
 
 void ipi_call_unlock_irq(void)
@@ -455,7 +460,9 @@
 	int i;
 
 	for(i = 0; i < NQUEUES; i++)
-		spin_unlock_irq(&call_function_queues[i].lock);
+		spin_unlock(&call_function_queues[i].lock);
+
+	spin_unlock_irq(&queues_lock);
 }
 
 


