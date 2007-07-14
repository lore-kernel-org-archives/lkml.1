Return-Path: <linux-kernel-owner+w=401wt.eu-S1764014AbXGNTSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764014AbXGNTSR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 15:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761403AbXGNTSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 15:18:00 -0400
Received: from waste.org ([66.93.16.53]:48439 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760546AbXGNTR7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 15:17:59 -0400
Date: Sat, 14 Jul 2007 14:17:38 -0500
From: Matt Mackall <mpm@selenic.com>
To: Rene Herman <rene.herman@gmail.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Jesper Juhl <jesper.juhl@gmail.com>,
       Ray Lee <ray-lk@madrabbit.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
Message-ID: <20070714191737.GA11166@waste.org>
References: <200707111916.35036.jesper.juhl@gmail.com> <2c0942db0707112159v3ee2cd83i74759c7138e273f7@mail.gmail.com> <9a8748490707121324q3b3e6e65ye14ab8e7f089d999@mail.gmail.com> <4696C89E.4010002@goop.org> <9a8748490707121925w5fb22c0o61068f06d66d5845@mail.gmail.com> <4696FC43.3000201@goop.org> <46977C36.8010403@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46977C36.8010403@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2007 at 03:20:54PM +0200, Rene Herman wrote:
> On 07/13/2007 06:14 AM, Jeremy Fitzhardinge wrote:
> 
> >Jesper Juhl wrote:
> 
> >>Yes and no.  If that will get things moving in the direction of
> >>getting rid of the stack size as a config option, then I'm all for it.
> >>But on the other hand it is my personal opinion that this is an area
> >>where we should just make up our minds as to whether we want 4K or 8K
> >>stacks and whether we want interrupt stacks or not, and then not have
> >>it configurable at all.  
> >
> >Well, smaller stacks are better where possible, but there's nothing 
> >magic about 4k.
> 
> Except offcourse it happens to also be the value of PAGE_SIZE at least on 
> x86...
> 
> >Sure, its mostly enough, but there's no particular reason to believe it
> >will be enough for everything.  You could state a priori that all kernel
> >code paths must fit into 4k of stack, but that's pretty arbitrary.
> 
> As far as I'm aware, the actual reason for 4K stacks is that after the 
> system has been up and running for some time getting "1 physically 
> contiguous pages" becomes significantly easier than 2 which wouldn't be 
> arbitrary.

If there are exactly two free pages in the system, the odds of them
being buddies (ie adjacent AND properly aligned) is quite small. The
available page pool has to grow quite a bit before the availability of
order-1 page pairs approaches 100%. 

So if we fail to allocate an 8k stack when we could have allocated a
4k stack, we're almost certainly failing significantly prematurely.

As I've pointed out before, it's fairly easy to make our stack
growable with a trampoline in the troublesome paths. Something like:

int growstack(int headroom, int func, void *data)
{
	void *new_stack;
	int ret;

	if (likely(available_stack() > headroom))
		return func(data);

#ifdef CONFIG_GROWSTACK_STATS
	/* gather statistics about stack-heavy paths */
#endif
	/* warn/abort if we're recursing too deeply */

	new_stack = get_free_page();
	switch_to_new_stack(new_stack);
	ret = func(data);
	cleanup_stack(new_stack);
	return ret;
}

-- 
Mathematics is the supreme nostalgia of our time.
