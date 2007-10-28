Return-Path: <linux-kernel-owner+w=401wt.eu-S1754348AbXJ1WmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348AbXJ1WmR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 18:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751999AbXJ1WmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 18:42:00 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:48505 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbXJ1Wl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 18:41:59 -0400
Date: Sun, 28 Oct 2007 16:41:57 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "George G. Davis" <gdavis@mvista.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [RFC, PATCH] locks: remove posix deadlock detection
Message-ID: <20071028224157.GC32359@parisc-linux.org>
References: <20071017185157.GC3785@mvista.com> <20071018185759.GU3785@mvista.com> <20071026170750.GC13033@fieldses.org> <20071026224707.GO13033@fieldses.org> <20071028173136.GA16905@fieldses.org> <20071028174321.GB16905@fieldses.org> <20071028182732.GK27248@parisc-linux.org> <20071028184052.49abd092@the-village.bc.nu> <20071028201101.GA32359@parisc-linux.org> <1193608230.7561.11.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1193608230.7561.11.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 28, 2007 at 05:50:30PM -0400, Trond Myklebust wrote:
> > You can't fix the false EDEADLK detection without solving the halting
> > problem.  Best of luck with that.
> 
> I can see that it would be difficult to do efficiently, but basically,
> this boils down to finding a circular path in a graph. That is hardly an
> unsolvable issue...

Bzzt.  You get a false deadlock with multiple threads like so:

Thread A of task B takes lock 1
Thread C of task D takes lock 2
Thread C of task D blocks on lock 1
Thread E of task B blocks on lock 2

We currently declare deadlock at this point (unless the deadlock detection
code has changed since I last looked at it), despite thread A being about
to release lock 1.  Oh, and by the way, thread E is capable of releasing
lock 1, so you can't just say "well, detect by thread instead of by task".

So the only way I can see to accurately detect deadlock is to simulate
the future execution of all threads in task B to see if any of them
will release lock 1 without first gaining lock 2.  Which, I believe,
is halting-equivalent.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
