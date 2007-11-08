Return-Path: <linux-kernel-owner+w=401wt.eu-S1760994AbXKHPpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760994AbXKHPpx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 10:45:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757649AbXKHPpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 10:45:46 -0500
Received: from waste.org ([66.93.16.53]:35191 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755715AbXKHPpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 10:45:45 -0500
Date: Thu, 8 Nov 2007 09:43:53 -0600
From: Matt Mackall <mpm@selenic.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Marin Mitov <mitov@issp.bas.bg>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>
Subject: Re: is minimum udelay() not respected in preemptible SMP kernel-2.6.23?
Message-ID: <20071108154353.GT19691@waste.org>
References: <200711071921.52330.mitov@issp.bas.bg> <20071107123045.c6d4b855.akpm@linux-foundation.org> <20071108002027.GV17536@waste.org> <1194513081.6289.130.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1194513081.6289.130.camel@twins>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 08, 2007 at 10:11:21AM +0100, Peter Zijlstra wrote:
> On Wed, 2007-11-07 at 18:20 -0600, Matt Mackall wrote:
> 
> >  This and other cases
> > (lots of per_cpu users, IIRC) actually want a migrate_disable() which
> > is a proper subset. 
> 
> The disadvantage of migrate_disable() is that it complicates the
> load-balancer

Hmm, I'm surprised it's more than a one-liner. Something like

if (cannot_migrate(task))
	continue;

But I'm certainly not the expert here. Perhaps this one-liner introduces the
"unplannable O(N) overhead" Ingo mentions in the email you referenced.

> but more importantly, that it does bring a form of latencies with it
> that are hard to measure. Using preempt_disable() for these current
> per-cpu users basically forces them to keep it short.

Ok, so maybe we've got implementation issues to tackle. But still: a)
preempt_disable is inherently misdocumentation (preemption is not the
real problem) and b) preemption is a bigger hammer than needed. At the
very least, we should introduce migrate_disable as an alias for
preempt_disable so we can document intent.

At any rate, in the current context, we're talking about actually
disabling preempt in a *delay loop*. Let's find a fix for that.

> Also see:
> http://lkml.org/lkml/2007/7/23/338

Heh, I'd completely forgotten about this thread and thought I was
having an original idea! Must have never seen Ingo's followup.

Ingo's complaint about it being "a per-task BKL" is interesting. I've
occassionally wondered if it makes sense to make some of these
primitives take a "documentation parameter" - a pointer to an object
that does nothing more than indicate the object of interest.

-- 
Mathematics is the supreme nostalgia of our time.
