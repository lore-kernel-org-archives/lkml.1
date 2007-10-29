Return-Path: <linux-kernel-owner+w=401wt.eu-S1755750AbXJ2IEl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755750AbXJ2IEl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 04:04:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752094AbXJ2IEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 04:04:25 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:39639 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751014AbXJ2IEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 04:04:24 -0400
Date: Mon, 29 Oct 2007 08:06:04 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "George G. Davis" <gdavis@mvista.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [RFC, PATCH] locks: remove posix deadlock detection
Message-ID: <20071029080604.508b19ce@the-village.bc.nu>
In-Reply-To: <20071028174321.GB16905@fieldses.org>
References: <20071017185157.GC3785@mvista.com>
	<20071018185759.GU3785@mvista.com>
	<20071026170750.GC13033@fieldses.org>
	<20071026224707.GO13033@fieldses.org>
	<20071028173136.GA16905@fieldses.org>
	<20071028174321.GB16905@fieldses.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Oct 2007 13:43:21 -0400
"J. Bruce Fields" <bfields@fieldses.org> wrote:

> From: J. Bruce Fields <bfields@citi.umich.edu>
> 
> We currently attempt to return -EDEALK to blocking fcntl() file locking
> requests that would create a cycle in the graph of tasks waiting on
> locks.
> 
> This is inefficient: in the general case it requires us determining
> whether we're adding a cycle to an arbitrary directed acyclic graph.
> And this calculation has to be performed while holding a lock (currently
> the BKL) that prevents that graph from changing.
> 
> It has historically been a source of bugs; most recently it was noticed
> that it could loop indefinitely while holding the BKL.
> 
> It seems unlikely to be useful to applications:
> 	- The difficulty of implementation has kept standards from
> 	  requiring it.  (E.g. SUSv3 : "Since implementation of full
> 	  deadlock detection is not always feasible, the [EDEADLK] error
> 	  was made optional.")  So portable applications may not be able to
> 	  depend on it.
> 	- It only detects deadlocks that involve nothing but local posix
> 	  file locks; deadlocks involving network filesystems or other kinds
> 	  of locks or resources are missed.
> 
> It therefore seems best to remove deadlock detection.
> 
> Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>


NAK. This is an ABI change and one that was rejected before when this was
last discussed in detail. Moving it out of BKL makes a ton of sense, even
adding a "don't check" flag makes a lot of sense. Removing the checking
does not.

I'd much rather see


	if (flags & FL_NODLCHECK)
		posix_deadlock_detect(....)


The failure case for removing this feature is obscure and hard to debug
application hangs for the afflicted programs - not nice for users at all.

Alan
