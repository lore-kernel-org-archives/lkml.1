Return-Path: <linux-kernel-owner+w=401wt.eu-S1753367AbXJ2DYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367AbXJ2DYW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 23:24:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751287AbXJ2DYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 23:24:12 -0400
Received: from pat.uio.no ([129.240.10.15]:40245 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751118AbXJ2DYL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 23:24:11 -0400
Subject: Re: [RFC, PATCH] locks: remove posix deadlock detection
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "George G. Davis" <gdavis@mvista.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <20071028224157.GC32359@parisc-linux.org>
References: <20071017185157.GC3785@mvista.com>
	 <20071018185759.GU3785@mvista.com> <20071026170750.GC13033@fieldses.org>
	 <20071026224707.GO13033@fieldses.org> <20071028173136.GA16905@fieldses.org>
	 <20071028174321.GB16905@fieldses.org>
	 <20071028182732.GK27248@parisc-linux.org>
	 <20071028184052.49abd092@the-village.bc.nu>
	 <20071028201101.GA32359@parisc-linux.org>
	 <1193608230.7561.11.camel@heimdal.trondhjem.org>
	 <20071028224157.GC32359@parisc-linux.org>
Content-Type: text/plain
Date: Sun, 28 Oct 2007 23:26:12 -0400
Message-Id: <1193628372.7561.48.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.063)
X-UiO-Scanned: 6A7AB1D4772ADE1AF07F2A6262109E9D9432F4B3
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 140 total 4768122 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2007-10-28 at 16:41 -0600, Matthew Wilcox wrote:
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
> 
> We currently declare deadlock at this point (unless the deadlock detection
> code has changed since I last looked at it), despite thread A being about
> to release lock 1.  Oh, and by the way, thread E is capable of releasing
> lock 1, so you can't just say "well, detect by thread instead of by task".
> 
> So the only way I can see to accurately detect deadlock is to simulate
> the future execution of all threads in task B to see if any of them
> will release lock 1 without first gaining lock 2.  Which, I believe,
> is halting-equivalent.

As several people have told you, the SUSv3 section on fcntl and
deadlocks reads as follows:

        "A potential for deadlock occurs if a process controlling a
        locked region is put to sleep by attempting to lock another
        process' locked region. If the system detects that sleeping
        until a locked region is unlocked would cause a deadlock,
        fcntl() shall fail with an [EDEADLK] error."

There is no mention there or anywhere else of a need to make exceptions
when dealing with threads. The posix locking model is _process_ based,
and so our deadlock detection only needs to take that into account.
If programmers choose to play tricksy little games with threads, then it
is their responsibility to ensure that the application doesn't get into
a situation where the posix deadlock detection model breaks down.

Trond

