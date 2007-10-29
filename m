Return-Path: <linux-kernel-owner+w=401wt.eu-S1756184AbXJ2BNm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184AbXJ2BNm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 21:13:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752982AbXJ2BNc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 21:13:32 -0400
Received: from mail.fieldses.org ([66.93.2.214]:48044 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752538AbXJ2BNb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 21:13:31 -0400
Date: Sun, 28 Oct 2007 21:13:06 -0400
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Matthew Wilcox <matthew@wil.cx>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "George G. Davis" <gdavis@mvista.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [RFC, PATCH] locks: remove posix deadlock detection
Message-ID: <20071029011306.GA10307@fieldses.org>
References: <20071017185157.GC3785@mvista.com> <20071018185759.GU3785@mvista.com> <20071026170750.GC13033@fieldses.org> <20071026224707.GO13033@fieldses.org> <20071028173136.GA16905@fieldses.org> <20071028174321.GB16905@fieldses.org> <20071028182732.GK27248@parisc-linux.org> <20071028184052.49abd092@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071028184052.49abd092@the-village.bc.nu>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 28, 2007 at 06:40:52PM +0000, Alan Cox wrote:
> On Sun, 28 Oct 2007 12:27:32 -0600
> Matthew Wilcox <matthew@wil.cx> wrote:
> 
> > On Sun, Oct 28, 2007 at 01:43:21PM -0400, J. Bruce Fields wrote:
> > > We currently attempt to return -EDEALK to blocking fcntl() file locking
> > > requests that would create a cycle in the graph of tasks waiting on
> > > locks.
> > > 
> > > This is inefficient: in the general case it requires us determining
> > > whether we're adding a cycle to an arbitrary directed acyclic graph.
> > > And this calculation has to be performed while holding a lock (currently
> > > the BKL) that prevents that graph from changing.
> > > 
> > > It has historically been a source of bugs; most recently it was noticed
> > > that it could loop indefinitely while holding the BKL.
> > 
> > It can also return -EDEADLK spuriously.  So yeah, just kill it.
> 
> NAK. This is an ABI change. It was also comprehensively rejected before
> because
> 
> - EDEADLK behaviour is ABI
> - EDEADLK behaviour is required by SuSv3
> - We have no idea what applications may rely on this behaviour.

On the second point I think you're mistaken; see

	http://www.opengroup.org/onlinepubs/009695399/functions/fcntl.html

	"Since implementation of full deadlock detection is not
	always feasible, the [EDEADLK] error was made optional."

The third objection is the one that concerns me most, and is the one I'd
like to understand better.  So I'd be interested in any evidence of
applications that do actually depend on the current behavior.  (Even
hypothetical use cases might be interesting.)  I'm also curious what
other OS's do.

> See the thread
> 	http://osdir.com/ml/file-systems/2004-06/msg00017.html
> 
> so we need to fix the bugs - the lock usage and the looping. At that
> point it merely becomes a performance concern to those who use it, which
> is the proper behaviour. If you want a faster non-checking one use
> flock(), or add another flag that is a Linux "don't check for deadlock"

That's an interesting idea.  The flag might not help as much, since
looking for a cycle in the graph of blocked requests may be more
difficult in the case where we don't know whether the graph is acyclic
to start out with.  (But I don't know--I haven't thought about it much.)

--b.
