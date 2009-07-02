Return-Path: <linux-kernel-owner+w=401wt.eu-S1754116AbZGBJs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbZGBJs5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 05:48:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751993AbZGBJsu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 05:48:50 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:34664 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751059AbZGBJst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 05:48:49 -0400
Subject: Re: [PATCH] kmemleak: Fix scheduling-while-atomic bug
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       git-commits-head@vger.kernel.org
In-Reply-To: <20090701093015.GA6862@elte.hu>
References: <200907010300.n6130rRf026194@hera.kernel.org>
	 <20090701075332.GA17252@elte.hu>
	 <1246439937.8492.18.camel@pc1117.cambridge.arm.com>
	 <20090701093015.GA6862@elte.hu>
Content-Type: text/plain
Organization: ARM Ltd
Date: Thu, 02 Jul 2009 10:48:28 +0100
Message-Id: <1246528108.13320.19.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Jul 2009 09:48:29.0490 (UTC) FILETIME=[40EE5920:01C9FAFA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Now that your patch was merged, I propose adding a few more
cond_resched() calls, useful for the !PREEMPT case:


kmemleak: Add more cond_resched() calls in the scanning thread

From: Catalin Marinas <catalin.marinas@arm.com>

Following recent patch to no longer reschedule in the scan_block()
function, we need a few more cond_resched() calls in the kmemleak_scan()
function (useful if PREEMPT is disabled).

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 mm/kmemleak.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 013f188..b4f675e 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -932,13 +932,16 @@ static void kmemleak_scan(void)
 
 	/* data/bss scanning */
 	scan_block(_sdata, _edata, NULL);
+	cond_resched();
 	scan_block(__bss_start, __bss_stop, NULL);
 
 #ifdef CONFIG_SMP
 	/* per-cpu sections scanning */
-	for_each_possible_cpu(i)
+	for_each_possible_cpu(i) {
+		cond_resched();
 		scan_block(__per_cpu_start + per_cpu_offset(i),
 			   __per_cpu_end + per_cpu_offset(i), NULL);
+	}
 #endif
 
 	/*
@@ -960,6 +963,7 @@ static void kmemleak_scan(void)
 			/* only scan if page is in use */
 			if (page_count(page) == 0)
 				continue;
+			cond_resched();
 			scan_block(page, page + 1, NULL);
 		}
 	}
@@ -969,6 +973,7 @@ static void kmemleak_scan(void)
 	 * not enabled by default.
 	 */
 	if (kmemleak_stack_scan) {
+		cond_resched();
 		read_lock(&tasklist_lock);
 		for_each_process(task)
 			scan_block(task_stack_page(task),


-- 
Catalin

