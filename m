Return-Path: <linux-kernel-owner+w=401wt.eu-S1753919AbXJ2CLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919AbXJ2CLT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 22:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751261AbXJ2CLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 22:11:08 -0400
Received: from mail.fieldses.org ([66.93.2.214]:40737 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001AbXJ2CLH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 22:11:07 -0400
Date: Sun, 28 Oct 2007 22:10:36 -0400
To: Matthew Wilcox <matthew@wil.cx>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "George G. Davis" <gdavis@mvista.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [RFC, PATCH] locks: remove posix deadlock detection
Message-ID: <20071029021036.GC10307@fieldses.org>
References: <20071018185759.GU3785@mvista.com> <20071026170750.GC13033@fieldses.org> <20071026224707.GO13033@fieldses.org> <20071028173136.GA16905@fieldses.org> <20071028174321.GB16905@fieldses.org> <20071028182732.GK27248@parisc-linux.org> <20071028184052.49abd092@the-village.bc.nu> <20071028201101.GA32359@parisc-linux.org> <1193608230.7561.11.camel@heimdal.trondhjem.org> <20071028224157.GC32359@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071028224157.GC32359@parisc-linux.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 28, 2007 at 04:41:57PM -0600, Matthew Wilcox wrote:
> On Sun, Oct 28, 2007 at 05:50:30PM -0400, Trond Myklebust wrote:
> > > You can't fix the false EDEADLK detection without solving the halting
> > > problem.  Best of luck with that.
> > 
> > I can see that it would be difficult to do efficiently, but basically,
> > this boils down to finding a circular path in a graph. That is hardly an
> > unsolvable issue...
> 
> Bzzt.  You get a false deadlock with multiple threads like so:
> 
> Thread A of task B takes lock 1
> Thread C of task D takes lock 2
> Thread C of task D blocks on lock 1
> Thread E of task B blocks on lock 2

Oh neat, I missed that case, thanks for pointing it out.

> We currently declare deadlock at this point (unless the deadlock detection
> code has changed since I last looked at it), despite thread A being about
> to release lock 1.  Oh, and by the way, thread E is capable of releasing
> lock 1, so you can't just say "well, detect by thread instead of by task".
> 
> So the only way I can see to accurately detect deadlock is to simulate
> the future execution of all threads in task B to see if any of them
> will release lock 1 without first gaining lock 2.

Hm.  It's annoying, but I'm not convinced it's *that* annoying.  We're
not trying to predict whether a deadlock could arise as the result of
future behavior.  We're just trying to determine whether granting the
current lock request results in an immediate deadlock consisting purely
of posix file locks.

But yes, I'm assume it's possible, for example, that a thread-exit could
race with a lock request, with the result that we see no deadlock at the
time we handle the lock request, even though at that point the last task
with the ability to solve the problem is already exiting.

Supposing that we're willing to permit the request in such cases and
return EDEADLK only in cases where we're positive there's a deadlock, is
there still some useful subset of cases where we could return EDEADLK?
For example, could we take note of tasks that, when they block on a
lock, have a current->files with reference count one, and only follow
cycles consisting of such blocks?

I'm still not convinced it's worth the trouble, but I suspect you're
overstating the difficulty.

--b.
