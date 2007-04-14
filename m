Return-Path: <linux-kernel-owner+w=401wt.eu-S965426AbXDNIhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965426AbXDNIhT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 04:37:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932431AbXDNIhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 04:37:19 -0400
Received: from 1wt.eu ([62.212.114.60]:1825 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932212AbXDNIhR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 04:37:17 -0400
Date: Sat, 14 Apr 2007 10:36:25 +0200
From: Willy Tarreau <w@1wt.eu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070414083625.GM943@1wt.eu>
References: <20070413202100.GA9957@elte.hu> <20070414020424.GB14544@wotan.suse.de> <20070414063254.GB14875@elte.hu> <20070414064334.GA19463@elte.hu> <20070414080833.GL943@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070414080833.GL943@1wt.eu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 14, 2007 at 10:08:34AM +0200, Willy Tarreau wrote:
> On Sat, Apr 14, 2007 at 08:43:34AM +0200, Ingo Molnar wrote:
> > 
> > * Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > Nick noticed that upon fork we change parent->wait_runtime but we do 
> > > not requeue it within the rbtree.
> > 
> > this fix is not complete - because the child runqueue is locked here, 
> > not the parent's. I've fixed this properly in my tree and have uploaded 
> > a new sched-modular+cfs.patch. (the effects of the original bug are 
> > mostly harmless, the rbtree position gets corrected the first time the 
> > parent reschedules. The fix might improve heavy forker handling.)
> 
> It looks like it did not reach your public dir yet.
> 
> BTW, I've given it a try. It seems pretty usable. I have also tried
> the usual meaningless "glxgears" test with 12 of them at the same time,
> and they rotate very smoothly, there is absolutely no pause in any of
> them. But they don't all run at same speed, and top reports their CPU
> load varying from 3.4 to 10.8%, with what looks like more CPU is
> assigned to the first processes, and less CPU for the last ones. But
> this is just a rough observation on a stupid test, I would not call
> that one scientific in any way (and X has its share in the test too).

Follow-up: I think this is mostly X-related. I've started 100 scheddos,
and all get the same CPU percentage. Interestingly, mpg123 in parallel
does never skip at all because it needs quite less than 1% CPU and gets
its fair share at a load of 112. Xterms are slow to respond to typing
with the 12 gears and 100 scheddos, and expectedly it was X which was
starving. renicing it to -5 restores normal feeling with very slow
but smooth gear rotations. Leaving X niced at 0 and killing the gears
also restores normal behaviour.

All in all, it seems logical that processes which serve many others
become a bottleneck for them.

Forking becomes very slow above a load of 100 it seems. Sometimes,
the shell takes 2 or 3 seconds to return to prompt after I run
"scheddos &"

Those are very promising results, I nearly observe the same responsiveness
as I had on a solaris 10 with 10k running processes on a bigger machine.

I would be curious what a mysql test result would look like now.

Regards,
Willy

