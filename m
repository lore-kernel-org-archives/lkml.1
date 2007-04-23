Return-Path: <linux-kernel-owner+w=401wt.eu-S1752016AbXDWUII@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016AbXDWUII (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 16:08:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752311AbXDWUII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 16:08:08 -0400
Received: from 1wt.eu ([62.212.114.60]:2230 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752016AbXDWUIG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 16:08:06 -0400
Date: Mon, 23 Apr 2007 22:05:42 +0200
From: Willy Tarreau <w@1wt.eu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Juliusz Chroboczek <jch@pps.jussieu.fr>,
       Con Kolivas <kernel@kolivas.org>, ck list <ck@vds.kolivas.org>,
       Bill Davidsen <davidsen@tmr.com>,
       William Lee Irwin III <wli@holomorphy.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [REPORT] cfs-v4 vs sd-0.44
Message-ID: <20070423200542.GC23004@1wt.eu>
References: <20070420140457.GA14017@elte.hu> <200704220155.20856.kernel@kolivas.org> <20070421160008.GA28783@elte.hu> <200704220959.34978.kernel@kolivas.org> <87647oblx5.fsf@pps.jussieu.fr> <alpine.LFD.0.98.0704221620310.9964@woody.linux-foundation.org> <20070423013429.GB25162@wotan.suse.de> <alpine.LFD.0.98.0704230844410.9964@woody.linux-foundation.org> <20070423191143.GA16849@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070423191143.GA16849@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi !

On Mon, Apr 23, 2007 at 09:11:43PM +0200, Ingo Molnar wrote:
> 
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > but the point I'm trying to make is that X shouldn't get more CPU-time 
> > because it's "more important" (it's not: and as noted earlier, 
> > thinking that it's more important skews the problem and makes for too 
> > *much* scheduling). X should get more CPU time simply because it 
> > should get it's "fair CPU share" relative to the *sum* of the clients, 
> > not relative to any client individually.
> 
> yeah. And this is not a pipe dream and i think it does not need a 
> 'wakeup matrix' or other complexities.
> 
> I am --->.<---- this close to being able to do this very robustly under 
> CFS via simple rules of economy and trade: there the p->wait_runtime 
> metric is intentionally a "physical resource" of "hard-earned right to 
> execute on the CPU, by having waited on it" the sum of which is bound 
> for the whole system.
>
> So while with other, heuristic approaches we always had the problem of 
> creating a "hyper-inflation" of an uneconomic virtual currency that 
> could be freely printed by certain tasks, in CFS the economy of this is 
> strict and the finegrained plus/minus balance is strictly managed by a 
> conservative and independent central bank.
> 
> So we can actually let tasks "trade" in these very physical units of 
> "right to execute on the CPU". A task giving it to another task means 
> that this task _already gave up CPU time in the past_. So it's the 
> robust equivalent of an economy's "money earned" concept, and this 
> "money"'s distribution (and redistribution) is totally fair and totally 
> balanced and is not prone to "inflation".
> 
> The "give scheduler money" transaction can be both an "implicit 
> transaction" (for example when writing to UNIX domain sockets or 
> blocking on a pipe, etc.), or it could be an "explicit transaction": 
> sched_yield_to(). This latter i've already implemented for CFS, but it's 
> much less useful than the really significant implicit ones, the ones 
> which will help X.

I don't think that a task should _give_ its slice to the task it's waiting
on, but it should _lend_ it : if the second task (the server, eg: X) does
not eat everything, maybe the first one will need to use the remains.

We had a good example with glxgears. Glxgears may need more CPU than X on
some machines, less on others. But it needs CPU. So it must not give all
it has to X otherwise it will stop. But it can tell X "hey, if you need
some CPU, I have some here, help yourself". When X has exhausted its slice,
it can then use some from the client. Hmmm no, better, X first serves itself
in the client's share, and may then use (parts of) its own if it needs more.

This would be seen like some CPU ressource buckets. Indeed, it's even a
problem of economy as you said. If you want someone to do something for you,
either it's very quick and simple and he can do it for free once in a while,
or you take all of his time and you have to pay him for this time.

Of course, you don't always know whom X is working for, and this will cause
X to sometimes run for one task on another one's ressources. But as long as
the work is done, it's OK. Hey, after all, many of us sometimes work for
customers in real life and take some of their time to work on the kernel
and everyone is happy with it.

I think that if we could have a (small) list of CPU buckets per task, it
would permit us to do such a thing. We would then have to ensure that
pipes or unix sockets correctly present their buckets to their servers.
If we consider that each task only has its own bucket and can lend it to
one and only one server at a time, it should not look too much horrible.

Basically, just something like this (thinking while typing) :

struct task_struct {
  ...
  struct {
     struct list list;
     int money_left;
  } cpu_bucket;
  ...
}

Then, waking up another process would consist in linking our bucket into
its own bucket list. The server can identify the task it's borrowing
from by looking at which task_struct the list belongs to.

Also, it creates some inheritance between processes. When doing such a
thing :


 $ fgrep DST=1.2.3.4 fw.log | sed -e 's/1.2/A.B/' | gzip -c3 >fw-anon.gz

Then fgrep would lend some CPU to sed which in turn would present them both
to gzip. Maybe we need two lists in order of the structures to be unstacked
upon gzip's sleep() :-/

I don't know if I'm clear enough.

Cheers,
Willy

