Return-Path: <linux-kernel-owner+w=401wt.eu-S1760139AbXKHBGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760139AbXKHBGb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 20:06:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758294AbXKHBGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 20:06:13 -0500
Received: from waste.org ([66.93.16.53]:53171 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757367AbXKHBGM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 20:06:12 -0500
Date: Wed, 7 Nov 2007 19:03:47 -0600
From: Matt Mackall <mpm@selenic.com>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Marin Mitov <mitov@issp.bas.bg>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: is minimum udelay() not respected in preemptible SMP kernel-2.6.23?
Message-ID: <20071108010347.GP19691@waste.org>
References: <200711071921.52330.mitov@issp.bas.bg> <20071107123045.c6d4b855.akpm@linux-foundation.org> <20071108002027.GV17536@waste.org> <200711080131.01243.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711080131.01243.ak@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 08, 2007 at 01:31:00AM +0100, Andi Kleen wrote:
> On Thursday 08 November 2007 01:20, Matt Mackall wrote:
> > On Wed, Nov 07, 2007 at 12:30:45PM -0800, Andrew Morton wrote:
> > > Ow.  Yes, from my reading delay_tsc() can return early (or after
> > > heat-death-of-the-universe) if the TSCs are offset and if preemption
> > > migrates the calling task between CPUs.
> > >
> > > I suppose a lameo fix would be to disable preemption in delay_tsc().
> >
> > preempt_disable is lousy documentation here. This and other cases
> > (lots of per_cpu users, IIRC) actually want a migrate_disable() which
> > is a proper subset. We can simply implement migrate_disable() as
> > preempt_disable() for now and come back later and implement a proper
> > migrate_disable() that still allows preemption (and thus avoids the
> > latency).
> 
> We could actually do this right now. migrate_disable() can be just changing
> the cpu affinity of the current thread to current cpu and then restoring it 
> afterwards. That should even work from interrupt context.

Yes, that's one way. But we need somewhere to stash the old flags.
Expanding the task struct sucks. Jamming another bit in the preempt
count sucks.

But I think we'd be best off stashing a single bit somewhere and
checking it at migrate time (relatively infrequent) rather than
copying and zeroing out a potentially enormous affinity mask every
time we disable migration (often, and in fast paths). Perhaps adding
TASK_PINNED to the task state flags would do it?

> get_cpu() etc. could be changed to use this then too.

Some users of get_cpu might be relying on it to avoid actual
preemption. In other words, we should have introduced a
migrate_disable() when we first discovered the preempt/per_cpu
conflict.

-- 
Mathematics is the supreme nostalgia of our time.
