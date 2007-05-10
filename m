Return-Path: <linux-kernel-owner+w=401wt.eu-S1760451AbXEJTP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760451AbXEJTP2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 15:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756919AbXEJTPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 15:15:17 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:57390 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755760AbXEJTPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 15:15:15 -0400
Date: Thu, 10 May 2007 20:14:52 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Nick Piggin <npiggin@suse.de>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [rfc] optimise unlock_page
In-Reply-To: <20070510033736.GA19196@wotan.suse.de>
Message-ID: <Pine.LNX.4.64.0705101935590.18496@blonde.wat.veritas.com>
References: <20070508113709.GA19294@wotan.suse.de> <20070508114003.GB19294@wotan.suse.de>
 <1178659827.14928.85.camel@localhost.localdomain> <20070508224124.GD20174@wotan.suse.de>
 <20070508225012.GF20174@wotan.suse.de> <Pine.LNX.4.64.0705091950080.2909@blonde.wat.veritas.com>
 <20070510033736.GA19196@wotan.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 10 May 2007 19:15:12.0990 (UTC) FILETIME=[88BCAFE0:01C79337]
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAABmluYm94AG5waWdnaW5Ac3VzZS5kZQBsaW51eC1hcmNoQHZnZXIua2VybmVsLm9yZwBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnAGFrcG1AbGludXgtZm91bmRhdGlvbi5vcmcAYmVuaEBrZXJuZWwuY3Jhc2hpbmcub3JnAGxpbnV4LW1tQGt2YWNrLm9yZwA=
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2007, Nick Piggin wrote:
> 
> OK, I found a simple bug after pulling out my hair for a while :)
> With this, a 4-way system survives a couple of concurrent make -j250s
> quite nicely (wheras they eventually locked up before).
> 
> The problem is that the bit wakeup function did not go through with
> the wakeup if it found the bit (ie. PG_locked) set. This meant that
> waiters would not get a chance to reset PG_waiters.

That makes a lot of sense.  And this version seems stable to me,
I've found no problems so far: magic!

Well, on the x86_64 I have seen a few of your io_schedule_timeout
printks under load; but suspect those are no fault of your changes,
but reflect some actual misbehaviour down towards the disk end (when
kernel default moved from AS to CFQ, I had to stick with AS because
CFQ ran my tests very much slower on that one machine: something odd
going on that I've occasionally wasted time looking into but never
tracked down - certainly long-locked pages are a feature of that).

> However you probably weren't referring to that particular problem
> when you imagined the need for a full count, or the slippery 3rd
> task... I wasn't able to derive any such problems with the basic
> logic, so if there was a bug there, it would still be unfixed in this
> patch.

I've been struggling to conjure up and exorcise the race that seemed
so obvious to me yesterday.  I was certainly imagining one task on
its way between SetPageWaiters and io_schedule, when the unlock_page
comes, wakes, and lets another waiter take the lock.  Probably I was
forgetting the essence of prepare_to_wait, that this task would then
fall through io_schedule as if woken as part of that batch.  Until
demonstrated otherwise, let's assume I was utterly mistaken.

In addition to 3 hours of load on the three machines, I've gone back
and applied this new patch (and the lock bitops; remembering to shift
PG_waiters up) to 2.6.21-rc3-mm2 on which I did the earlier lmbench
testing, on those three machines.

On the PowerPC G5, these changes pretty much balance out your earlier
changes (not just the one fix-fault-vs-invalidate patch, but the whole
group which came in with that - it'd take me a while to tell exactly
what, easiest to send you a diff if you want it), in those lmbench
fork, exec, sh, mmap, fault tests.  On the P4 Xeons, they improve
the numbers significantly, but only retrieve half the regression.

So here it looks like a good change; but not enough to atone ;)

Hugh
