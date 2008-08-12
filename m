Return-Path: <linux-kernel-owner+w=401wt.eu-S1752875AbYHLJ0D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875AbYHLJ0D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 05:26:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751663AbYHLJZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 05:25:54 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35999 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751516AbYHLJZx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 05:25:53 -0400
Date: Tue, 12 Aug 2008 11:25:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [git pull] core fixes
Message-ID: <20080812092534.GA7177@elte.hu>
References: <20080811222026.GA20579@elte.hu> <200808121613.24846.nickpiggin@yahoo.com.au> <200808121805.14009.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808121805.14009.nickpiggin@yahoo.com.au>
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


* Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> On Tuesday 12 August 2008 16:13, Nick Piggin wrote:
> > On Tuesday 12 August 2008 08:20, Ingo Molnar wrote:
> 
> > > Nick Piggin (1):
> > >       generic-ipi: fix stack and rcu interaction bug in
> > > smp_call_function_mask()
> >
> > I'm still not 100% sure that I have this patch right... I might have 
> > seen a lockup trace implicating the smp call function path... which 
> > may have been due to some other problem or a different bug in the 
> > new call function code, but if some more people can take a look at 
> > it before merging?
> 
> OK indeed it did have a couple of bugs. Firstly, I wasn't freeing the 
> data properly in the alloc && wait case. Secondly, I wasn't resetting 
> CSD_FLAG_WAIT in the for each cpu loop (so only the first CPU would 
> wait).
> 
> After those fixes, the patch boots and runs with the kmalloc commented
> out (so it always executes the slowpath).

thanks! I've applied the delta fix below to tip/core/urgent. In my 
testing the previous version didnt cause problems either because we 
seldom excercise this slowpath. (Jeremy had trouble reproducing the 
on-stack corruption even with targeted tests.)

We'll soon start using the generic-ipi facilities for TLB flushes on x86 
and perhaps even reuse the IPI itself for the reschedule IPI - that 
should put it all under heavier scrutiny.

	Ingo

----------------->
>From c2fc11985db304572322f1dcdcb0f71337315006 Mon Sep 17 00:00:00 2001
From: Nick Piggin <nickpiggin@yahoo.com.au>
Date: Tue, 12 Aug 2008 18:05:13 +1000
Subject: [PATCH] generic-ipi: fix stack and rcu interaction bug in smp_call_function_mask(), fix

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

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/smp.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/kernel/smp.c b/kernel/smp.c
index e6084f6..782e2b9 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -135,7 +135,8 @@ void generic_smp_call_function_interrupt(void)
 			 */
 			smp_wmb();
 			data->csd.flags &= ~CSD_FLAG_WAIT;
-		} else
+		}
+		if (data->csd.flags & CSD_FLAG_ALLOC)
 			call_rcu(&data->rcu_head, rcu_free_call_data);
 	}
 	rcu_read_unlock();
@@ -289,10 +290,11 @@ static void smp_call_function_mask_quiesce_stack(cpumask_t mask)
 
 	data.func = quiesce_dummy;
 	data.info = NULL;
-	data.flags = CSD_FLAG_WAIT;
 
-	for_each_cpu_mask(cpu, mask)
+	for_each_cpu_mask(cpu, mask) {
+		data.flags = CSD_FLAG_WAIT;
 		generic_exec_single(cpu, &data);
+	}
 }
 
 /**
@@ -371,7 +373,7 @@ int smp_call_function_mask(cpumask_t mask, void (*func)(void *), void *info,
 	if (wait) {
 		csd_flag_wait(&data->csd);
 		if (unlikely(slowpath))
-			smp_call_function_mask_quiesce_stack(allbutself);
+			smp_call_function_mask_quiesce_stack(mask);
 	}
 
 	return 0;
