Return-Path: <linux-kernel-owner+w=401wt.eu-S1423000AbXDRNIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423000AbXDRNIg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 09:08:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423001AbXDRNIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 09:08:36 -0400
Received: from holomorphy.com ([66.93.40.71]:60037 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422999AbXDRNIf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 09:08:35 -0400
Date: Wed, 18 Apr 2007 06:08:13 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Matt Mackall <mpm@selenic.com>
Cc: Nick Piggin <npiggin@suse.de>, Peter Williams <pwil3058@bigpond.net.au>,
       Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       Ingo Molnar <mingo@elte.hu>, ck list <ck@vds.kolivas.org>,
       Bill Huey <billh@gnuppy.monkey.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070418130813.GA31925@holomorphy.com>
References: <20070417042954.GG25513@wotan.suse.de> <20070417060955.GO8915@holomorphy.com> <20070417061503.GC1057@wotan.suse.de> <20070417062621.GL2986@holomorphy.com> <20070417070155.GF1057@wotan.suse.de> <20070417213954.GE11166@waste.org> <20070418031511.GA18452@wotan.suse.de> <20070418043831.GR11115@waste.org> <20070418050024.GF18452@wotan.suse.de> <20070418055525.GS11115@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070418055525.GS11115@waste.org>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2007 at 12:55:25AM -0500, Matt Mackall wrote:
> Why are processes special? Should user A be able to get more CPU time
> for his job than user B by splitting it into N parallel jobs? Should
> we be fair per process, per user, per thread group, per session, per
> controlling terminal? Some weighted combination of the preceding?[2]

On a side note, I think a combination of all of the above is a very
good idea, plus process groups (pgrp's). All the make -j loads should
come up in one pgrp of one session for one user and hence should be
automatically kept isolated in its own corner by such policies. Thread
bombs, forkbombs, and so on get handled too, which is good when on e.g.
a compileserver and someone rudely spawns too many tasks.

Thinking of the scheduler as a CPU bandwidth allocator, this means
handing out shares of CPU bandwidth to all users on the system, which
in turn hand out shares of bandwidth to all sessions, which in turn
hand out shares of bandwidth to all process groups, which in turn hand
out shares of bandwidth to all thread groups, which in turn hand out
shares of bandwidth to threads. The event handlers for the scheduler
need not deal with this apart from task creation and exit and various
sorts of process ID changes (e.g. setsid(), setpgrp(), setuid(), etc.).
They just determine what the scheduler sees as ->load_weight or some
analogue of ->static_prio, though it is possible to do this by means of
data structure organization instead of numerical prioritization. It'd
probably have to be calculated on the fly by, say, doing fixpoint
arithmetic something like
    user_share(p)*session_share(p)*pgrp_share(p)*tgrp_share(p)*task_share(p)
so that readjusting the shares of aggregates doesn't have to traverse
lists and remains O(1). Each of the share computations can instead just
do some analogue of the calculation p->load_weight/rq->raw_weighted_load
in fixpoint, though precision issues with this make me queasy. There is
maybe a slight nasty point in that the ->raw_weighted_load analogue for
users or whatever the highest level chosen is ends up being global. One
might as well get users in there and omit intermediate levels if any are
to be omitted so that the truly global state is as read-only as possible.

I suppose jacking up the fixpoint precision to 128-bit or 256-bit all
below the radix point (our max is 1.0 after all) until precision issues
vanish can be done but the idea of that much number crunching in the
scheduler makes me rather uncomfortable. I hope u64 or u32 [2] can be
gotten away with as far as fixpoint goes.


-- wli
