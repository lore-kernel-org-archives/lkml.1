Return-Path: <linux-kernel-owner+w=401wt.eu-S1755492AbZFWL2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492AbZFWL2z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 07:28:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752984AbZFWL2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 07:28:48 -0400
Received: from brick.kernel.dk ([93.163.65.50]:42451 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752771AbZFWL2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 07:28:47 -0400
Date: Tue, 23 Jun 2009 13:28:50 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, hch@infradead.org
Subject: Re: merging the per-bdi writeback patchset
Message-ID: <20090623112849.GA31415@kernel.dk>
References: <20090623191803.2230.A69D9226@jp.fujitsu.com> <20090623105645.GX31415@kernel.dk> <20090623201225.223F.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090623201225.223F.A69D9226@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23 2009, KOSAKI Motohiro wrote:
> > On Tue, Jun 23 2009, KOSAKI Motohiro wrote:
> > > Hi
> > > 
> > > > On Tue, Jun 23 2009, Andrew Morton wrote:
> > > > > On Tue, 23 Jun 2009 10:11:56 +0200 Jens Axboe <jens.axboe@oracle.com> wrote:
> > > > > 
> > > > > > Things are looking good for this patchset and it's been in -next for
> > > > > > almost a week without any reports of problems. So I'd like to merge it
> > > > > > for 2.6.31 if at all possible. Any objections?
> > > > > 
> > > > > erk.  I was rather expecting I'd have time to have a look at it all.
> > > > 
> > > > OK, we can wait if we have to, just trying to avoid having to keep this
> > > > fresh for one full cycle. I have posted this patchset 11 times though
> > > > over months, so it's not like it's a new piece of work :-)
> > > > 
> > > > > It's unclear to me actually _why_ the performance changes which were
> > > > > observed have actually occurred.  In fact it's a bit unclear (to me)
> > > > > why the patchset was written and what it sets out to achieve :(
> > > > 
> > > > It started out trying to get rid of the pdflush uneven writeout. If you
> > > > look at various pdflush intensive workloads, even on a single disk you
> > > > often have 5 or more pdflush threads working the same device. It's just
> > > > not optimal. Another issue was starvation with request allocation. Given
> > > > that pdflush does non-blocking writes (it has to, by design), pdflush
> > > > can potentially be starved if someone else is working the device.
> > > 
> > > Can you please make reproduce program and post mesurement result?
> > > I hope to mesure the same program on my box.
> > 
> > For which issue? Lumpy writeout can often be observed just by doing
> > buffered writes to a bunch of files.
> 
> Yes, I know current behavior is not perfectly optimal.
> but I haven't seen it cause serious issue.
> 
> Then, I guess you have big degression workload, yes? if so, I hope to
> see it.

Not really, I was just interested in making it more optimal. I work from
various fio job files, one case that is sped up greatly is doing random
writes with mmap to an otherwise buffered file. pdflush is both lumpy
and a lot slower there, even with many pdflush threads active. Looking
at disk utilization, pdflush doesn't manage more than ~80% for that. The
per-bdi writeback is completely smooth and gets about as close to 100%
utilization as possible (around ~98% there). And this is just one 1
disk, the per-bdi writeback scales nicely upwards. pdflush falls flat.

And then there are lots of cases where the performance is the same. For
many workloads, pdflush isn't really very active.

> > > Plus, Can you please write more vervose patch description? your patch is a
> > > bit harder review.
> > 
> > OK, I can probably improve on that. Do you mean the general description
> > of the patchset, or some of the individual patches?
> 
> Hopefully both. honestly I haven't understand your main worryed issue.

Does the above help? It's all about making the writeback more
consistent. So getting rid of the lumpy writeback and eliminating the
pdflush starvation were the prime motivators.

-- 
Jens Axboe

