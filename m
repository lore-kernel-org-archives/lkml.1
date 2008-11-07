Return-Path: <linux-kernel-owner+w=401wt.eu-S1753830AbYKGMYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830AbYKGMYb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 07:24:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752450AbYKGMYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 07:24:23 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34821 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752432AbYKGMYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 07:24:22 -0500
Date: Fri, 7 Nov 2008 13:24:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Mike Travis <travis@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpumask: introduce new API, without changing anything
Message-ID: <20081107122400.GA20777@elte.hu>
References: <20081029152849.3883d072.sfr@canb.auug.org.au> <200811021229.16061.rusty@rustcorp.com.au> <alpine.LFD.2.00.0811011834360.3483@nehalem.linux-foundation.org> <200811070949.02914.rusty@rustcorp.com.au> <20081107084016.GF4435@elte.hu> <20081107201139.196fa52b.sfr@canb.auug.org.au> <20081107093911.GD7787@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081107093911.GD7787@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> but the change was not due to some merge conflict, it was a change 
> done to the patch itself.
> 
> The merge conflict happened because Rusty iterated the patch in a 
> non-append manner so two versions of the same patch collided in 
> linux-next.
> 
> So ... what was the change, was it _really_ tested as-is in the 
> linux-next tree for a longer time, or just merged a couple of hours 
> ago?

hm, i just researched it a bit, and the patch Rusty just submitted to 
Linus was not in linux-next it appears, as the modified commit is just 
a few hours old.

Find below the delta patch between the two versions, and an 
analysis/review of the changes. I've started testing it as well, and 
it's looking good so far.

Here is when the new version showed up in linux-next a few hours ago:

| commit 92a8334f1b0ad1f65127bc763ab214d6b60ec966
| Author:     Stephen Rothwell <sfr@canb.auug.org.au>
| AuthorDate: Fri Nov 7 20:44:35 2008 +1100
| Commit:     Stephen Rothwell <sfr@canb.auug.org.au>
| CommitDate: Fri Nov 7 20:44:35 2008 +1100
|
|    Add linux-next specific files for 20081107

It was a new (and modified) quilt-exported commit from "quilt/rr":

| 0c82f41: cpumask:new-API-only
|
| Author:     Rusty Russell <rusty@rustcorp.com.au>
| AuthorDate: Fri Nov 7 11:12:29 2008 +1100
| Commit:     Stephen Rothwell <sfr@canb.auug.org.au>
| CommitDate: Fri Nov 7 11:12:29 2008 +1100

Which collided with a previous version of that patch in the cpus4096 
tree:

| 2d3854a: cpumask: introduce new API, without changing anything
|
| Author:     Rusty Russell <rusty@rustcorp.com.au>
| AuthorDate: Wed Nov 5 13:39:10 2008 +1100
| CommitDate: Thu Nov 6 09:05:33 2008 +0100

"0c82f41: cpumask:new-API-only" thus has only a couple of hours of 
lifetime and the "this has been in linux-next" is only true for that 
short time period.

So ... i've reconstructed what's new in 0c82f41, and i came up with 
the delta patch below.

Review of the delta patch:

- the cpumask_of() is added to the SMP section of cpumask.h but not to
  the UP section. Similarly, some of the other SMP APIs are not 
  declared in the UP section either. (Furthermore, the macros in the 
  UP section should really be inlines, not macros - as akpm noticed it
  too.)

- the free_bootmem_cpumask_var() addition looks good but is a tiny bit
  incomplete: the free_bootmem_cpumask_var() function should be marked 
  __init, like all bootmem methods are.

i guess these changes should be OK.

Note that such types of minor problems are very easy to spot and 
address in an append-only workflow (even if you just emulate it in 
quilt), but are hidden and laborous to extract with an agreesive 
quilt-rebasing history-eating workflow that just exports completely 
new versions of patches.

Just in case you are wondering why i care so much about 'your' patch: 
i'd like it to go upstream. The patch and the plan affects subsystems 
i'm (co-)maintaining, in a nontrivial way, (scheduler, irq and x86 
code), and the cpumask code caused trouble in the past so i'd like to 
know _exactly_ what future changes go into it. Isnt that a fair 
interest?

But your "rr tree" is not suitable at all to follow the development of 
this effort. Deltas are not transparent and reviewable, the changes 
are mixed into other changes and you force me into this kind of review 
and delta patch forensics and that is very inefficient - and it 
obviously harms the end result and wastes time for no good reason.

And yes, when all is said and done and everyone's happy there's no 
problem with eventually collapsing delta patches together into a 
single clean patch.

Most of the time it's not _worth_ touching existing history with 
folding patches: as you can see it from the patch below, there's no 
technical reason why it could not have been a separate delta patch. 
Those changes do not cause _any_ bisection barrier, nor do they cause 
any other of problem either.

And dont get me wrong, destroying the delta was not malice on your 
part in any way, it was "just" a side-effect destruction of 
information that resulted out of your customary work flow. I realize 
that you like and prefer that workflow, and that you have used it for 
years, but you should also accept it when i point out the problems 
that it causes down the line.

And the thing is, a year ago i was in similar shoes and i was on the 
receiving end of similar complaints, and in hindsight i do not regret 
at all having changed to a Git workflow =B-)

	Ingo

----------------->
>From cd83e42c6b0413dcbb548c2ead799111ff7e6a13 Mon Sep 17 00:00:00 2001
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Fri, 7 Nov 2008 11:12:29 +1100
Subject: [PATCH] cpumask: new API, v2

- add cpumask_of()
- add free_bootmem_cpumask_var()

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/cpumask.h |   11 +++++++++++
 lib/cpumask.c           |    5 +++++
 2 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index c8e6661..31caa1b 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -894,6 +894,12 @@ static inline void cpumask_copy(struct cpumask *dstp,
 #define cpumask_any_and(mask1, mask2) cpumask_first_and((mask1), (mask2))
 
 /**
+ * cpumask_of - the cpumask containing just a given cpu
+ * @cpu: the cpu (<= nr_cpu_ids)
+ */
+#define cpumask_of(cpu) (get_cpu_mask(cpu))
+
+/**
  * to_cpumask - convert an NR_CPUS bitmap to a struct cpumask *
  * @bitmap: the bitmap
  *
@@ -946,6 +952,7 @@ typedef struct cpumask *cpumask_var_t;
 bool alloc_cpumask_var(cpumask_var_t *mask, gfp_t flags);
 void alloc_bootmem_cpumask_var(cpumask_var_t *mask);
 void free_cpumask_var(cpumask_var_t mask);
+void free_bootmem_cpumask_var(cpumask_var_t mask);
 
 #else
 typedef struct cpumask cpumask_var_t[1];
@@ -962,6 +969,10 @@ static inline void alloc_bootmem_cpumask_var(cpumask_var_t *mask)
 static inline void free_cpumask_var(cpumask_var_t mask)
 {
 }
+
+static inline void free_bootmem_cpumask_var(cpumask_var_t mask)
+{
+}
 #endif /* CONFIG_CPUMASK_OFFSTACK */
 
 /* The pointer versions of the maps, these will become the primary versions. */
diff --git a/lib/cpumask.c b/lib/cpumask.c
index 5ceb421..2ebc3a9 100644
--- a/lib/cpumask.c
+++ b/lib/cpumask.c
@@ -107,4 +107,9 @@ void free_cpumask_var(cpumask_var_t mask)
 	kfree(mask);
 }
 EXPORT_SYMBOL(free_cpumask_var);
+
+void free_bootmem_cpumask_var(cpumask_var_t mask)
+{
+	free_bootmem((unsigned long)mask, cpumask_size());
+}
 #endif
