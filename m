Return-Path: <linux-kernel-owner+w=401wt.eu-S965746AbXCLLwF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965746AbXCLLwF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 07:52:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965744AbXCLLwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 07:52:05 -0400
Received: from mx1.suse.de ([195.135.220.2]:59747 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965726AbXCLLwC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 07:52:02 -0400
Date: Mon, 12 Mar 2007 12:52:01 +0100
From: Nick Piggin <npiggin@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Roland McGrath <roland@redhat.com>, akpm@linux-foundation.org,
       mm-commits@vger.kernel.org, drepper@redhat.com, oleg@tv-sign.ru,
       sebastien.dugue@bull.net, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch] change futex_wait() to hrtimers
Message-ID: <20070312115201.GI28546@wotan.suse.de>
References: <200703110814.l2B8EaI1007615@shell0.pdx.osdl.net> <20070312011259.3834A1801C4@magilla.sf.frob.com> <20070312091006.GF21024@elte.hu> <20070312091628.GE28546@wotan.suse.de> <20070312110204.GD2231@elte.hu> <20070312111331.GF28546@wotan.suse.de> <20070312111958.GA14573@elte.hu> <20070312112955.GH28546@wotan.suse.de> <20070312113829.GA18759@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070312113829.GA18759@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2007 at 12:38:29PM +0100, Ingo Molnar wrote:
> 
> * Nick Piggin <npiggin@suse.de> wrote:
> 
> > > the issue is this: your fix reduces the effects of the bug but it is 
> > > still fundamentally incomplete because of the use of timer_list. So
> > 
> > But using schedule_timeout is not a bug. Userspace timeouts are always 
> > defined to be "at least".
> 
> but what you are adding isnt a plain schedule_timeout(), it is a restart 
> block handling loop. And for those restart blocks that relate to 
> timeouts, we only use hrtimers. I am not making this up to annoy you: 
> take a look at all the current restart block handlers - they are hrtimer 
> based, for exactly this reason.

So why do you say it is fundamentally incomplete?

> > > instead of trying to fix the bug the wrong way, please try to fix it 
> > > the right way, ontop of an already existing and tested patch, ok? 
> > > That also enables the other neat stuff Thomas talked about.
> > 
> > Well that's nice, but I have a bugfix here which probably needs to get 
> > backported to stable kernels and distro kernels.
> 
> yes but your patch already exists for them which they can pick up.
> 
> really, this is a common Linux principle: fix it completely and fix it 
> the right way. You are applying it yourself on a daily basis when having 
> the maintainer hat on =B-)

I still didn't get anything wrong pointed out with the patch, though.

I'm not arguing against using hrtimers here to fix it the "right way".

> > It should be just as easy to rebase the hrtimer patch on top of my 
> > fix. Considering that you've had it for a year, I don't think it needs 
> > to be added right before my fix.
> 
> your latest patch looks quite kludgy, exactly due to the issues that 
> were mentioned.

I don't see what is kludgy, unless you consider converting to and from
absolute timeouts. But the userspace API is relative time based, so
hrtimers doesn't change that.

> > > hm. I'm wondering how this wasnt noticed sooner - this futex_wait 
> > > behavior has been there for like forever.
> > 
> > People ignore LTP test failures, and programs probably try to avoid 
> > exercising the nuances of the unix signal API, I guess.
> 
> then there's no rush and lets do this the right way, ok?

There is no rush to use hrtimers. I would have thought it fairly important
to actually reach correctness, though. We're not talking about completely
changing the design of something such that it will take a lot of work to
"fix it properly". If that were the issue, then I would consider the
hrtimer conversion as part of the fix.

And if you talk about doing it the right way, then I don't think it is
strictly the right way to reimplement the function, including known bugs,
to be slightly more efficient, and *then* fixing those bugs. I'd actually
consider it better to fix the bugs first, not only because of the backport
issue, but because it generally makes it easier to track the injection and
removal points of bugs in the history.
