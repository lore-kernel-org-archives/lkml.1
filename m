Return-Path: <linux-kernel-owner+w=401wt.eu-S1762323AbYD3LC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762323AbYD3LC1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 07:02:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757043AbYD3LCR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 07:02:17 -0400
Received: from relay2.sgi.com ([192.48.171.30]:36117 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756909AbYD3LCQ (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 07:02:16 -0400
Date: Wed, 30 Apr 2008 21:01:59 +1000
From: David Chinner <dgc@sgi.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: Announce: Semaphore-Removal tree
Message-ID: <20080430110159.GN108924158@sgi.com>
References: <20080425170021.GH14990@parisc-linux.org> <20080428051040.GH103491721@sgi.com> <20080428122004.GT14990@parisc-linux.org> <20080429000929.GF108924158@sgi.com> <20080430100612.GI14976@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080430100612.GI14976@parisc-linux.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2008 at 04:06:13AM -0600, Matthew Wilcox wrote:
> On Tue, Apr 29, 2008 at 10:09:30AM +1000, David Chinner wrote:
> > > 2. l_flushsema
> > > 
> > > This seems to be a completion.  ie you're using it to wait for the log
> > > to be flushed.
> > 
> > Yes, that could probably be a completion. I'm assuming that a completion
> > can handle several thousand waiting processes, right?
> 
> By the way ... is it common that you get several thousand waiting
> processes?  I ask because you wake them all up, then the herd thunders
> into the l_icloglock spinlock.  Or is this a worst-case scenario that
> happens once in a blue moon?

I'm thinking of a certain 2048p machine at NASA where they run
MPI jobs that do synchronised exit() calls with about 6-7 open
file descriptors that all run into ->release at the same time
and try to do EOF truncation transcations all at the same time.

We get the first 100-200 processes filling all the log buffers
and forcing them to disk, and then the rest start waiting on
the flush sema.

Given that we're already pushing 4096p support for the next gen
machines, this problem isn't going to get any better...

> If l_flushsema does typically get more than one waiter, we can instead
> wake the waiters one at a time.

The current code does them one at a time, but in such a way that is
not any better than a thundering herd. wake_up_all() is probably
a more efficient thundering herd as it doesn't require picking up
and dropping a spinlock for every task being woken.

I think that we need to redesign this code to prevent the thundering
herd problem - it's not problem solvable by just changing the wakeup
call. Besides, the evidence points to the fact that a thundering
herd on the flush sema is not the limiting factor in thoughput.
There's still several layers of the onion to peel before
we get to that point.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
