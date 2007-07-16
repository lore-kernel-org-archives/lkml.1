Return-Path: <linux-kernel-owner+w=401wt.eu-S1758460AbXGPXjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758460AbXGPXjS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 19:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753468AbXGPXjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 19:39:09 -0400
Received: from waste.org ([66.93.16.53]:48445 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751452AbXGPXjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 19:39:07 -0400
Date: Mon, 16 Jul 2007 18:38:50 -0500
From: Matt Mackall <mpm@selenic.com>
To: Rene Herman <rene.herman@gmail.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Jesper Juhl <jesper.juhl@gmail.com>,
       Ray Lee <ray-lk@madrabbit.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
Message-ID: <20070716233849.GE11115@waste.org>
References: <200707111916.35036.jesper.juhl@gmail.com> <2c0942db0707112159v3ee2cd83i74759c7138e273f7@mail.gmail.com> <9a8748490707121324q3b3e6e65ye14ab8e7f089d999@mail.gmail.com> <4696C89E.4010002@goop.org> <9a8748490707121925w5fb22c0o61068f06d66d5845@mail.gmail.com> <4696FC43.3000201@goop.org> <46977C36.8010403@gmail.com> <20070714191737.GA11166@waste.org> <46994BE3.7010608@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46994BE3.7010608@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 15, 2007 at 12:19:15AM +0200, Rene Herman wrote:
> On 07/14/2007 09:17 PM, Matt Mackall wrote:
> 
> >On Fri, Jul 13, 2007 at 03:20:54PM +0200, Rene Herman wrote:
> 
> >>As far as I'm aware, the actual reason for 4K stacks is that after the 
> >>system has been up and running for some time getting "1 physically 
> >>contiguous pages" becomes significantly easier than 2 which wouldn't be 
> >>arbitrary.
> >
> >If there are exactly two free pages in the system, the odds of them
> >being buddies (ie adjacent AND properly aligned) is quite small. The
> >available page pool has to grow quite a bit before the availability of
> >order-1 page pairs approaches 100%. 
> >
> >So if we fail to allocate an 8k stack when we could have allocated a
> >4k stack, we're almost certainly failing significantly prematurely.
> 
> Quite. Ofcourse, saying "our stacks are 1 page" would be the by far easiest 
> solution to that. Personally, I've been running with 4K stacks exclusively 
> on a variety of machines for quite some time now, but I can't say I'm all 
> too adventurous with respect to filesystems (especially) so I'm not sure 
> how many problems remain with 4K stacks. I did recently see Andrew Morton 
> say that problems _do_ still exist. If it's just XFS -- well, heck...

One long-standing problem is DM/LVM. That -may- be fixed now, but I
suspect issues remain.
 
> >As I've pointed out before, it's fairly easy to make our stack
> >growable with a trampoline in the troublesome paths. Something like:
> >
> >int growstack(int headroom, int func, void *data)
> >{
> >	void *new_stack;
> >	int ret;
> >
> >	if (likely(available_stack() > headroom))
> >		return func(data);
> >
> >#ifdef CONFIG_GROWSTACK_STATS
> >	/* gather statistics about stack-heavy paths */
> >#endif
> >	/* warn/abort if we're recursing too deeply */
> >
> >	new_stack = get_free_page();
> >	switch_to_new_stack(new_stack);
> >	ret = func(data);
> >	cleanup_stack(new_stack);
> >	return ret;
> >}
> 
> This would also need something to tell func() where its current_thread_info 
>  is now at.

That'd be handled in the usual way by switch_to_new_stack. That is,
we'd store the location of the old stack at the top of the new stack
and then literally change everything to point to the new stack.

> Which might not be much of a problem. Can't think of much else 
> either but it's the kind of thing you'd _like_ to be a problem just to have 
> an excuse to shoot down an icky notion like that...

It's not any ickier than explicitly calling schedule().

> Would you intend this just as a "make this path work until we fix it 
> properly" kind of thing?

Maybe.

-- 
Mathematics is the supreme nostalgia of our time.
