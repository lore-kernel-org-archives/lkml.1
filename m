Return-Path: <linux-kernel-owner+w=401wt.eu-S1757387AbYJPWcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757387AbYJPWcx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 18:32:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755528AbYJPWcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 18:32:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60078 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755107AbYJPWcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 18:32:45 -0400
Date: Thu, 16 Oct 2008 15:32:00 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Kumar Gala <galak@kernel.crashing.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Becky Bruce <becky.bruce@freescale.com>
Subject: Re: [git pull] core kernel updates for v2.6.28
In-Reply-To: <20081015125023.GA6702@elte.hu>
Message-ID: <alpine.LFD.2.00.0810161518320.3288@nehalem.linux-foundation.org>
References: <20081015125023.GA6702@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 15 Oct 2008, Ingo Molnar wrote:
> 
> Please pull the latest core-v28-for-linus git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-v28-for-linus
> 
> this is a combination of the following topics:
>    ...
>    core/resources

Ok, the resource_size_t -> generic phys_addr_t changes conflicted with the 
PowerPC changes I had merged yesterday. The resolution wasn't overly 
complex, but I'm sure I screwed something up anyway. Can the involved 
Power people take a look (looks like BenH, Kumar, Becky to me), and 
Jeremy/Ingo on the generic resource side?

> Frederic Weisbecker (1):
>       softirq, warning fix: correct a format to avoid a warning

Ingo, stop dicking around with this crap. You apparently fixed some 
warning that I never saw by turning it into a warning that I _do_ see:

  kernel/softirq.c: In function ¡__do_softirq¢:
  kernel/softirq.c:216: warning: format ¡%d¢ expects type ¡int¢, but argument 2 has type ¡long int¢

and as far as I can tell, you damn well should have seen it if you ever 
compile a 64-bit kernel!

The fact is, that second argument was a "ptrdiff_t", which is neither 
"int" nor "long".  It should be "%td" I think. But the thing is, when you 
fix a warning, you should damn well know what the hell you're doing, not 
just shut it up.

Fixing warnings without knowing what is going on is WORSE than leaving the 
warning alone. Leaving it alone at least keeps the status quo. Fixing it 
without looking deeply enough at it has the potential to change a known 
issue to a new issue and just moves bugs around, making the whole process 
irritating and harder to handle/debug.

So PLEASE don't take even 'trivial' warning fixes unless you actually know 
what is going on, or you trust the person very deeply to know.

Anyway, the correct fix is appended, but I haven't actually tested it.

		Linus

---
 kernel/softirq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/softirq.c b/kernel/softirq.c
index be7a829..37d67aa 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -210,7 +210,7 @@ restart:
 			h->action(h);
 
 			if (unlikely(prev_count != preempt_count())) {
-				printk(KERN_ERR "huh, entered softirq %d %p"
+				printk(KERN_ERR "huh, entered softirq %td %p"
 				       "with preempt_count %08x,"
 				       " exited with %08x?\n", h - softirq_vec,
 				       h->action, prev_count, preempt_count());
