Return-Path: <linux-kernel-owner+w=401wt.eu-S1756892AbXJ3PwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756892AbXJ3PwR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 11:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754950AbXJ3PwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 11:52:04 -0400
Received: from mail.fieldses.org ([66.93.2.214]:41746 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754903AbXJ3PwB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 11:52:01 -0400
Date: Tue, 30 Oct 2007 11:51:52 -0400
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "George G. Davis" <gdavis@mvista.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [RFC, PATCH] locks: remove posix deadlock detection
Message-ID: <20071030155152.GC21595@fieldses.org>
References: <20071017185157.GC3785@mvista.com> <20071018185759.GU3785@mvista.com> <20071026170750.GC13033@fieldses.org> <20071026224707.GO13033@fieldses.org> <20071028173136.GA16905@fieldses.org> <20071028174321.GB16905@fieldses.org> <20071029080604.508b19ce@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071029080604.508b19ce@the-village.bc.nu>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2007 at 08:06:04AM +0000, Alan Cox wrote:
> On Sun, 28 Oct 2007 13:43:21 -0400
> "J. Bruce Fields" <bfields@fieldses.org> wrote:
> 
> > From: J. Bruce Fields <bfields@citi.umich.edu>
> > 
> > We currently attempt to return -EDEALK to blocking fcntl() file locking
> > requests that would create a cycle in the graph of tasks waiting on
> > locks.
> > 
> > This is inefficient: in the general case it requires us determining
> > whether we're adding a cycle to an arbitrary directed acyclic graph.
> > And this calculation has to be performed while holding a lock (currently
> > the BKL) that prevents that graph from changing.
> > 
> > It has historically been a source of bugs; most recently it was noticed
> > that it could loop indefinitely while holding the BKL.
> > 
> > It seems unlikely to be useful to applications:
> > 	- The difficulty of implementation has kept standards from
> > 	  requiring it.  (E.g. SUSv3 : "Since implementation of full
> > 	  deadlock detection is not always feasible, the [EDEADLK] error
> > 	  was made optional.")  So portable applications may not be able to
> > 	  depend on it.
> > 	- It only detects deadlocks that involve nothing but local posix
> > 	  file locks; deadlocks involving network filesystems or other kinds
> > 	  of locks or resources are missed.
> > 
> > It therefore seems best to remove deadlock detection.
> > 
> > Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
> 
> 
> NAK. This is an ABI change

OK, fair enough.

> and one that was rejected before when this was last discussed in
> detail.

That previous discussion (http://marc.info/?t=108652857400003&r=1&w=2)
read the spec wrong and--now that I reread it--failed to address the
original bug report.  In fact it looks to me like the actual bug
reported:

	http://bugzilla.kernel.org/show_bug.cgi?id=2829

was probably a minor variant of the one which George Davis stumbled on
again here.  That's a little depressing.

> Moving it out of BKL makes a ton of sense,

That would at least reduce the impact of bugs here, yeah.  It would be
great to figure out how to start getting locks.c and lockd out from
under the BKL, but I don't personally have the time now.  (And I believe
there's been a failed attempt or two so it's not completely easy.)

> even adding a "don't check" flag makes a lot of sense.

That's an idea I'll keep in mind, though I'm not convinced it'll help
much (or that applications would actually use it).

> The failure case for removing this feature is obscure and hard to debug
> application hangs for the afflicted programs - not nice for users at all.

Yeah.  I'd still be curious for any data about applications that
actually rely on posix deadlock detection, though.

--b.
