Return-Path: <linux-kernel-owner+w=401wt.eu-S1760135AbXEaR2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760135AbXEaR2i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 13:28:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754782AbXEaR2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 13:28:31 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58412 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817AbXEaR2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 13:28:30 -0400
Date: Thu, 31 May 2007 19:28:28 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Stephane Eranian <eranian@hpl.hp.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/22] 2.6.22-rc3 perfmon2 : common core functions
Message-ID: <20070531172828.GC2538@one.firstfloor.org>
References: <200705291348.l4TDmRvL019775@frankl.hpl.hp.com> <p73ira9ca0d.fsf@bingen.suse.de> <20070531171616.GC23939@frankl.hpl.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070531171616.GC23939@frankl.hpl.hp.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2007 at 10:16:17AM -0700, Stephane Eranian wrote:
> Andi,
> 
> On Thu, May 31, 2007 at 05:01:38PM +0200, Andi Kleen wrote:
> > Stephane Eranian <eranian@frankl.hpl.hp.com> writes:
> > 
> > The interface looks very complicated. Is there anything 
> > in there that you feel is not strictly needed and should be eliminated
> > before merging? After merging it will be more difficult.
> > 
> Please pinpoint calls/data structure which you find are complicated.

It's mostly the sheer size of all of them together.

> All the features currently supported are used by some tools and have
> been requested by users.

But are they actually all used? Is there something you would
like to get rid of because it turned out more trouble than gain?
Now is the time to do it.

> > > +#define ulp(_x) ((unsigned long *)_x)
> > 
> > Don't use such non standard macros please.
> 
> That goes back to the argument earlier about bitmap.h using unsigned long
> and not u64. To avoid compiler warning, I used this macro. I do want
> to use the bitmap macros (instead of inventing my own). Andrew once
> asked if we should not fix bitmap.h instead.

I mean just use the cast if you mean the cast. That makes the readers'
life much easier.

> There parameter is checked on entry from perfmon syscalls to fail
> if necessary. So there can potentially be a race with the perfmon init.

A simple flag is not racy.

> Are you talking about the overflow of the message queue?

Yes.

> I made sure there was enough features in perfmon to support Oprofile and reuse its
> kernel code base. The changes to the user level daemon are fairly limited. It was my
> goal to ensure that Oprofile users would not see major disruptions. The wording is
> the documentation was maybe too strong.

I would prefer if oprofile would still work. It doesn't need to work
in parallel but it should be possible to use it when perfmon
is not active, but compiled in. That shouldn't be that difficult,
should it?

> > Weird thing to export. That's purely an internal implementation detail isn't it?
> 
> Yes, but that could be leveraged by tools to optimize the number of argument they
> want to pass per call.

Well is it?  And how would that be implemented? assembler stubs? 
switch statements? Doesn't make much sense to me.

> > > +   * smpl_buffer_mem_max(RW): maximum amount of memory usable for sampling buffers.
> > > +   		-1 means all that is available.
> > 
> > -1 seems dangerous. 
> 
> I could use a % of available memory. Is there another subsystem that ttries to size
> its buffer based on available memory at boot time?

Yes plenty, e.g. for hash tables. But then the heuristics
tend to be wrong. Just because I have 16GB of RAM doesn't 
mean I really want 8GB of perfmon tables.

But how about using mlock per process limits instead?

-Andi
