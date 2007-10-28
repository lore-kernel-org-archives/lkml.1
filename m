Return-Path: <linux-kernel-owner+w=401wt.eu-S1756012AbXJ1SjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012AbXJ1SjU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 14:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752223AbXJ1SjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 14:39:07 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:58722 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751101AbXJ1SjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 14:39:05 -0400
Date: Sun, 28 Oct 2007 18:40:52 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthew Wilcox <matthew@wil.cx>
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "George G. Davis" <gdavis@mvista.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [RFC, PATCH] locks: remove posix deadlock detection
Message-ID: <20071028184052.49abd092@the-village.bc.nu>
In-Reply-To: <20071028182732.GK27248@parisc-linux.org>
References: <20071017185157.GC3785@mvista.com>
	<20071018185759.GU3785@mvista.com>
	<20071026170750.GC13033@fieldses.org>
	<20071026224707.GO13033@fieldses.org>
	<20071028173136.GA16905@fieldses.org>
	<20071028174321.GB16905@fieldses.org>
	<20071028182732.GK27248@parisc-linux.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Oct 2007 12:27:32 -0600
Matthew Wilcox <matthew@wil.cx> wrote:

> On Sun, Oct 28, 2007 at 01:43:21PM -0400, J. Bruce Fields wrote:
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
> 
> It can also return -EDEADLK spuriously.  So yeah, just kill it.

NAK. This is an ABI change. It was also comprehensively rejected before
because

- EDEADLK behaviour is ABI
- EDEADLK behaviour is required by SuSv3
- We have no idea what applications may rely on this behaviour.

and also SuSv3 is required by LSB

See the thread
	http://osdir.com/ml/file-systems/2004-06/msg00017.html

so we need to fix the bugs - the lock usage and the looping. At that
point it merely becomes a performance concern to those who use it, which
is the proper behaviour. If you want a faster non-checking one use
flock(), or add another flag that is a Linux "don't check for deadlock"

Alan
