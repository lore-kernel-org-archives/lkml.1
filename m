Return-Path: <linux-kernel-owner+w=401wt.eu-S1752880AbXDQIxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880AbXDQIxq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 04:53:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752885AbXDQIxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 04:53:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56050 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752868AbXDQIxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 04:53:45 -0400
Date: Tue, 17 Apr 2007 10:52:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: William Lee Irwin III <wli@holomorphy.com>
Cc: Peter Williams <pwil3058@bigpond.net.au>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [patch] CFS (Completely Fair Scheduler), v2
Message-ID: <20070417085239.GA15562@elte.hu>
References: <20070416220715.GA4071@elte.hu> <46246D61.8010300@bigpond.net.au> <20070417075146.GM2986@holomorphy.com> <20070417081606.GB5076@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070417081606.GB5076@elte.hu>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> * William Lee Irwin III <wli@holomorphy.com> wrote:
> 
> > On Tue, Apr 17, 2007 at 04:46:57PM +1000, Peter Williams wrote:
> >
> > > Have you considered using rq->raw_weighted_load instead of 
> > > rq->nr_running in calculating fair_clock?  This would take the 
> > > nice value (or RT priority) of the other tasks into account when 
> > > determining what's fair.
> > 
> > I suspect you mean 
> > (curr->load_weight*delta_exec)/rq->raw_weighted_load in 
> > update_curr().
> 
> good idea, i'll try that.

i'll try another thing too: we could perhaps get rid of rq->nr_running 
and only use raw_weighted_load, because now the only main remaining 
property of ->nr_running is "is it zero or not".

[ ->nr_running's only other significant use is 'group_capacity', but in
  reality it is only interested in whether all CPUs in the group are
  busy and what the combined cpu power of that group is, and this could
  be restructured to use rq->curr and cpu_power - and become independent
  of nr_running. ]

[ then there are other details like load-average, but we could change
  that to be weighted-cpu-load driven - that makes sense anyway: a
  reniced task should have less effect on the 'system load' than a
  non-reniced task. ]

that would be one less variable to maintain in the scheduler hotpath, 
and it would make smpnice an effective _replacement_ for nr_running, 
instead of an add-on thing that costs a bit of performance.

	Ingo
