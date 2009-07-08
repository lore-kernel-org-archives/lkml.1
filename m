Return-Path: <linux-kernel-owner+w=401wt.eu-S1756283AbZGHNeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283AbZGHNeU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 09:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755322AbZGHNeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 09:34:13 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:58617 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755223AbZGHNeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 09:34:13 -0400
Subject: Re: [PATCH] kmemleak: Fix scheduling-while-atomic bug
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <20090701093015.GA6862@elte.hu>
References: <200907010300.n6130rRf026194@hera.kernel.org>
	 <20090701075332.GA17252@elte.hu>
	 <1246439937.8492.18.camel@pc1117.cambridge.arm.com>
	 <20090701093015.GA6862@elte.hu>
Content-Type: text/plain
Organization: ARM Ltd
Date: Wed, 08 Jul 2009 14:33:16 +0100
Message-Id: <1247059996.6595.36.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Jul 2009 13:33:17.0008 (UTC) FILETIME=[A698C500:01C9FFD0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Wed, 2009-07-01 at 11:30 +0200, Ingo Molnar wrote:
> * Catalin Marinas <catalin.marinas@arm.com> wrote:
> 
> > > The minimal fix below removes scan_yield() and adds a 
> > > cond_resched() to the outmost (safe) place of the scanning 
> > > thread. This solves the regression.
> > 
> > With CONFIG_PREEMPT disabled it won't reschedule during the bss 
> > scanning but I don't see this as a real issue (task stacks 
> > scanning probably takes longer anyway).
> 
> Yeah. I suspect one more cond_resched() could be added - i just 
> didnt see an obvious place for it, given that scan_block() is being 
> called with asymetric held-locks contexts.

I tried with a few cond_resched() calls in the kmemleak_scan() function
but it looks like a significant (well, 1-2 seconds, depending on the
hardware) amount of time is spent in scanning the data and bss sections.
The patch below makes the system with !PREEMPT more responsive during
the scanning episodes.

Are you ok with this approach? Thanks.


kmemleak: Add more cond_resched() calls in the scanning thread

From: Catalin Marinas <catalin.marinas@arm.com>

Following recent fix to no longer reschedule in the scan_block()
function, the system may become unresponsive with !PREEMPT. This patch
re-adds the cond_resched() call to scan_block() but conditioned by the
allow_resched parameter.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ingo Molnar <mingo@elte.hu>
---
 mm/kmemleak.c |   19 +++++++++++--------
 1 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 6006553..93f1481 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -807,7 +807,7 @@ static int scan_should_stop(void)
  * found to the gray list.
  */
 static void scan_block(void *_start, void *_end,
-		       struct kmemleak_object *scanned)
+		       struct kmemleak_object *scanned, int allow_resched)
 {
 	unsigned long *ptr;
 	unsigned long *start = PTR_ALIGN(_start, BYTES_PER_POINTER);
@@ -818,6 +818,8 @@ static void scan_block(void *_start, void *_end,
 		unsigned long pointer = *ptr;
 		struct kmemleak_object *object;
 
+		if (allow_resched)
+			cond_resched();
 		if (scan_should_stop())
 			break;
 
@@ -881,12 +883,12 @@ static void scan_object(struct kmemleak_object *object)
 		goto out;
 	if (hlist_empty(&object->area_list))
 		scan_block((void *)object->pointer,
-			   (void *)(object->pointer + object->size), object);
+			   (void *)(object->pointer + object->size), object, 0);
 	else
 		hlist_for_each_entry(area, elem, &object->area_list, node)
 			scan_block((void *)(object->pointer + area->offset),
 				   (void *)(object->pointer + area->offset
-					    + area->length), object);
+					    + area->length), object, 0);
 out:
 	spin_unlock_irqrestore(&object->lock, flags);
 }
@@ -931,14 +933,14 @@ static void kmemleak_scan(void)
 	rcu_read_unlock();
 
 	/* data/bss scanning */
-	scan_block(_sdata, _edata, NULL);
-	scan_block(__bss_start, __bss_stop, NULL);
+	scan_block(_sdata, _edata, NULL, 1);
+	scan_block(__bss_start, __bss_stop, NULL, 1);
 
 #ifdef CONFIG_SMP
 	/* per-cpu sections scanning */
 	for_each_possible_cpu(i)
 		scan_block(__per_cpu_start + per_cpu_offset(i),
-			   __per_cpu_end + per_cpu_offset(i), NULL);
+			   __per_cpu_end + per_cpu_offset(i), NULL, 1);
 #endif
 
 	/*
@@ -960,7 +962,7 @@ static void kmemleak_scan(void)
 			/* only scan if page is in use */
 			if (page_count(page) == 0)
 				continue;
-			scan_block(page, page + 1, NULL);
+			scan_block(page, page + 1, NULL, 1);
 		}
 	}
 
@@ -972,7 +974,8 @@ static void kmemleak_scan(void)
 		read_lock(&tasklist_lock);
 		for_each_process(task)
 			scan_block(task_stack_page(task),
-				   task_stack_page(task) + THREAD_SIZE, NULL);
+				   task_stack_page(task) + THREAD_SIZE,
+				   NULL, 0);
 		read_unlock(&tasklist_lock);
 	}
 


-- 
Catalin

