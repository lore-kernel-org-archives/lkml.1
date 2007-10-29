Return-Path: <linux-kernel-owner+w=401wt.eu-S1754433AbXJ2CaH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433AbXJ2CaH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 22:30:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751581AbXJ2C3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 22:29:54 -0400
Received: from mail.fieldses.org ([66.93.2.214]:45488 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751232AbXJ2C3x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 22:29:53 -0400
Date: Sun, 28 Oct 2007 22:29:23 -0400
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Matthew Wilcox <matthew@wil.cx>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "George G. Davis" <gdavis@mvista.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [RFC, PATCH] locks: remove posix deadlock detection
Message-ID: <20071029022922.GD10307@fieldses.org>
References: <20071028173136.GA16905@fieldses.org> <20071028174321.GB16905@fieldses.org> <20071028182732.GK27248@parisc-linux.org> <20071028184052.49abd092@the-village.bc.nu> <20071028201101.GA32359@parisc-linux.org> <1193608230.7561.11.camel@heimdal.trondhjem.org> <20071028224157.GC32359@parisc-linux.org> <20071028224833.66dc4243@the-village.bc.nu> <20071028225559.GD32359@parisc-linux.org> <20071028233826.24907fba@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071028233826.24907fba@the-village.bc.nu>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 28, 2007 at 11:38:26PM +0000, Alan Cox wrote:
> > > The spec and SYSV certainly ignore threading in this situation and you
> > > know that perfectly well (or did in 2004)
> > 
> > The discussion petered out (or that mailing list archive lost articles
> > from the thread) without any kind of resolution, or indeed interest.
> 
> I think the resolution was that the EDEADLK stayed.
> 
> > What is your suggestion for handling this problem?  As it is now, the
> > kernel 'detects' deadlock where there is none, which doesn't seem
> > allowed by SuSv3 either
> 
> Re-read the spec. The EDEADLK doesn't account for threads, only processes.

Do you have in mind a way to take advantage of that distinction?

The practical requirement I see here is that our deadlock detection
should never give false positives.  If we return EDEADLK to applications
with locking schemes that don't actually deadlock, then we're telling
application designers that avoiding deadlock in itself isn't
sufficient--they also have to know our particular deadlock detection
algorithm, so as to avoid giving even the appearance of deadlock.

And if posix file locks are to be useful to threaded applications, then
we have to preserve the same no-false-positives requirement for them as
well.

But, OK, if we can identify unshared current->files at the time we put a
task to sleep, then a slight modification of our current algorithm might
be sufficient to detect any deadlock that involves purely posix file
locks and processes.  And we can tell people that avoiding deadlock is
their problem as soon as any task with a shared current->files is
involved.  (Ditto, I assume, if nfsd/lockd acquires a lock.)

--b.
