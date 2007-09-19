Return-Path: <linux-kernel-owner+w=401wt.eu-S1756892AbXISWAI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756892AbXISWAI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 18:00:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752930AbXISV75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 17:59:57 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48881 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313AbXISV74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 17:59:56 -0400
Date: Wed, 19 Sep 2007 23:58:14 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Chuck Ebbert <cebbert@redhat.com>,
       Antoine Martin <antoine@nagafix.co.uk>,
       Satyam Sharma <satyam.sharma@gmail.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: CFS: some bad numbers with Java/database threading [FIXED]
Message-ID: <20070919235814.4147f574@lappy>
In-Reply-To: <20070919214105.GA12245@elte.hu>
References: <a781481a0709140306k3faf3585haae26853fe81381c@mail.gmail.com>
	<46EAA7E4.8020700@nagafix.co.uk>
	<20070914153216.GA27213@elte.hu>
	<46F00417.7080301@redhat.com>
	<20070918224656.GA26719@elte.hu>
	<46F058EE.1080408@redhat.com>
	<20070919191837.GA19500@elte.hu>
	<alpine.LFD.0.999.0709191230230.16478@woody.linux-foundation.org>
	<20070919195633.GA23595@elte.hu>
	<alpine.LFD.0.999.0709191306530.16478@woody.linux-foundation.org>
	<20070919214105.GA12245@elte.hu>
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.11.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Sep 2007 23:41:05 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > Btw, the "enqueue at the end" could easily be a statistical thing, not 
> > an absolute thing. So it's possible that we could perhaps implement 
> > the CFS "yield()" using the same logic as we have now, except *not* 
> > calling the "update_stats()" stuff:
> > 
> > 	__dequeue_entity(..);
> > 	__enqueue_entity(..);
> > 
> > and then just force the "fair_key" of the to something that 
> > *statistically* means that it should be at the end of its nice queue.
> > 
> > I dunno.
> 
> i thought a bit about the statistical approach, and it's good in 
> principle, but it has an implementational problem/complication: if there 
> are only yielding tasks in the system, then the "queue rightwards in the 
> tree, statistically" approach cycles through the key-space artificially 
> fast. That can cause various problems. (this means that the 
> workload-flag patch that uses yield_granularity is buggy as well. The 
> queue-rightmost patch did not have this problem.)
> 
> So right now there are only two viable options i think: either do the 
> current weak thing, or do the rightmost thing. The statistical method 
> might work too, but it needs more thought and more testing - i'm not 
> sure we can get that ready for 2.6.23.
> 
> So what we have as working code right now is the two extremes, and apps 
> will really mostly prefer either the first (if they dont truly want to 
> use yield but somehow it got into their code) or the second (if they 
> want some massive delay). So while it does not have a good QoI, how 
> about doing a compat_yield sysctl that allows the turning on of the 
> "queue rightmost" logic? Find tested patch below.
> 
> Peter, what do you think?

I have to agree that for .23 we can't do much more than this. And tasks
moving to the right without actually doing work and advancing
fair_clock do scare me a little.

Also, while I agree with Linus' definition of sched_yield, I'm afraid
it will cause 'regressions' for all the interactivity people out there.
Somehow this yield thing has made it into all sorts of unfortunate
places like video drivers, so a heavy penalizing yield will hurt them.

