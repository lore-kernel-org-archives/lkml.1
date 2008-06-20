Return-Path: <linux-kernel-owner+w=401wt.eu-S1755479AbYFTTLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479AbYFTTLr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 15:11:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751593AbYFTTLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 15:11:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45375 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751105AbYFTTLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 15:11:39 -0400
Date: Fri, 20 Jun 2008 12:10:14 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Christian Borntraeger <borntraeger@de.ibm.com>
cc: LKML <linux-kernel@vger.kernel.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: lmbench regression due to cond_resched nullification change
 26-rc5 vs. 25
In-Reply-To: <200806201014.43576.borntraeger@de.ibm.com>
Message-ID: <alpine.LFD.1.10.0806201153470.3167@woody.linux-foundation.org>
References: <200806201014.43576.borntraeger@de.ibm.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 20 Jun 2008, Christian Borntraeger wrote:
> 
> On a 6-way s390 I have seen some interesting regression in 2.6.26-rc5 vs. 
> 2.6.25 for the lmbench benchmark.
> 
> For example select file 500:
> 23 microseconds
> 32 microseconds
> 
> Several lmbench tests show a regression but I only bisected the select test 
> case so far:
> -------------------------<snip---------------------
> 
> commit c714a534d85576af21b06be605ca55cb2fb887ee
> 
>     Make 'cond_resched()' nullification depend on PREEMPT_BKL
> 
> Reverting that patch gives me the 2.6.25 performance. 
> 
> I think the patch is fine from the correctness point of view (do resched 
> inside BKL protected zones if its safe) but I dont understand why it has a 
> large impact on the select microbenchmark. Any ideas? Is it simply the 
> overhead of _cond_resched?

Yeah, I do think that it really is simply the overhead of _cond_resched.

Most places that use cond_resched() and friends do it in fairly heavy 
loops. That inner select() loop, in contrast, is rather heavily optimized, 
partly exactly because it's one of the hottest loops in one of the lmbench 
benchmarks.

Of course, it *can* also be simply that it now reschedules more, and a lot 
of lmbench benchmarks are very sensitive to scheduling behaviour. 
Batch-mode is almost invariably more efficient than any fine-grained 
scheduling can ever be, so there is always a performance count in having 
low latency.

There's also a third (and rather funny) reason the "cond_resched()" may be 
unnecessarily expensive in that loop: the "need_resched" bit may be set 
because that very same running thread was woken up! So we may end up 
deciding to reschedule because the thread thinks it needs to wake itself 
up ;)

[ That third case happens because the way we avoid race conditions with 
  going to sleep while a wakeup event happens is that we *mark* ourselves 
  as being sleeping before we actually do all the tests in lmbench. ]

So there's a few different things that may make that conditional 
reschedule a bad thing in the poll() loop.

But quite frankly, regardless of exactly why it happens, it absolutely 
makes no sense to even have that cond_resched() in the _innermost_ loop - 
the one that is called for every single fd. It's much better to move the 
conditional reschedule out a bit.

That inner loop was very much designed to compile into nice assembly 
language, and it's possible that the cond_resched() simply causes extra 
register pressure and keeps us from keeping the bitmasks in registers etc.

So this trivial patch, which moves the cond_resched() to be outside the 
single-word select() loop, would be a good idea _regardless_. Does it make 
any difference for you? If it's purely a "code generation got worse" 
issue, it should help a bit.

		Linus

---
 fs/select.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/select.c b/fs/select.c
index 8dda969..da0e882 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -249,7 +249,6 @@ int do_select(int n, fd_set_bits *fds, s64 *timeout)
 						retval++;
 					}
 				}
-				cond_resched();
 			}
 			if (res_in)
 				*rinp = res_in;
@@ -257,6 +256,7 @@ int do_select(int n, fd_set_bits *fds, s64 *timeout)
 				*routp = res_out;
 			if (res_ex)
 				*rexp = res_ex;
+			cond_resched();
 		}
 		wait = NULL;
 		if (retval || !*timeout || signal_pending(current))
