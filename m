Return-Path: <linux-kernel-owner+w=401wt.eu-S1761060AbXENXBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761060AbXENXBo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 19:01:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756336AbXENXBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 19:01:37 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:50882 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754795AbXENXBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 19:01:36 -0400
Date: Mon, 14 May 2007 16:01:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Con Kolivas <kernel@kolivas.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, ck@vds.kolivas.org
Subject: Re: [PATCH] mm: swap prefetch more improvements
Message-Id: <20070514160123.4b1ab108.akpm@linux-foundation.org>
In-Reply-To: <200705150843.36721.kernel@kolivas.org>
References: <200705141050.55038.kernel@kolivas.org>
	<20070514150032.d3ef6bb1.akpm@linux-foundation.org>
	<200705150843.36721.kernel@kolivas.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 May 2007 08:43:35 +1000
Con Kolivas <kernel@kolivas.org> wrote:

> On Tuesday 15 May 2007 08:00, Andrew Morton wrote:
> > On Mon, 14 May 2007 10:50:54 +1000
> >
> > Con Kolivas <kernel@kolivas.org> wrote:
> > > akpm, please queue on top of "mm: swap prefetch improvements"
> > >
> > > ---
> > > Failed radix_tree_insert wasn't being handled leaving stale kmem.
> > >
> > > The list should be iterated over in the reverse order when prefetching.
> > >
> > > Make the yield within kprefetchd stronger through the use of
> > > cond_resched.
> >
> > hm.
> >
> > > -		might_sleep();
> > > -		if (!prefetch_suitable())
> > > +		/* Yield to anything else running */
> > > +		if (cond_resched() || !prefetch_suitable())
> > >  			goto out_unlocked;
> >
> > So if cond_resched() happened to schedule away, we terminate this
> > swap-tricking attempt.  It's not possible to determine the reasons for this
> > from the code or from the changelog (==bad).
> >
> > How come?
> 
> Hmm I thought the line above that says "yield to anything else running" was 
> explicit enough. The idea is kprefetchd shouldn't run if any other real 
> activity is happening just about anywhere, and a positive cond_resched would 
> indicate likely activity so we just put kprefetchd back to sleep.

But kprefetchd runs as SCHED_BATCH.  Doesn't that mean that some low-prio
background thing (seti?) will disable swap-prefetch?

I mean, if swap-prefetch is actually useful, then it'll still be useful if
the machine happens to be doing some computational work.  It's not obvious
to me that there is linkage between "doing CPU work" and "prefetching is
presently undesirable".


