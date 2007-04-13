Return-Path: <linux-kernel-owner+w=401wt.eu-S1753632AbXDMMJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632AbXDMMJ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 08:09:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753564AbXDMMJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 08:09:57 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39932 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753519AbXDMMJ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 08:09:56 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070413100416.GC31487@wotan.suse.de> 
References: <20070413100416.GC31487@wotan.suse.de> 
To: Nick Piggin <npiggin@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] generic rwsems 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Fri, 13 Apr 2007 13:09:42 +0100
Message-ID: <25821.1176466182@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <npiggin@suse.de> wrote:

> This patch converts all architectures to a generic rwsem implementation,
> which will compile down to the same code for i386, or powerpc, for
> example,

> and will allow some (eg. x86-64) to move away from spinlock based rwsems.

Which are better on UP kernels because spinlocks degrade to nothing, and then
you're left with a single disable/enable interrupt pair per operation, and no
requirement for atomic ops at all.

What you propose may wind up with several per op because if the CPU does not
support atomic ops directly and cannot emulate them through other atomic ops,
then these have to be emulated by:

	atomic_op() {
		spin_lock_irqsave
		do op
		spin_unlock_irqrestore
	}

> Move to an architecture independent rwsem implementation, using the
> better of the two rwsem implementations

That's not necessarily the case, as I said above.

Furthermore, the spinlock implementation struct is smaller on 64-bit machines,
and is less prone to counter overrun on 32-bit machines.

> Out-of-line the fastpaths, to bring rw-semaphores into line with
> mutexes and spinlocks WRT our icache vs function call policy.

That should depend on whether you optimise for space or for speed.  Function
calls are relatively heavyweight.

Please re-inline and fix Ingo's mess if you must clean up.  Take the i386
version, for instance, I'd made it so that the compiler didn't know it was
taking a function call when it went down the slow path, thus meaning the
compiler didn't have to deal with that.  Furthermore, it only interpolated two
or three instructions into the calling code in the fastpath.  It's a real shame
that gcc inline asm doesn't allow you to use status flags as boolean returns,
otherwise I could reduce that even further.

> Spinlock based rwsems are inferior to atomic based ones one most
> architectures that can do atomic ops without spinlocks:

Note the "most" in your statement...

Think about it.  This algorithm is only optimal where XADD is available.  If
you don't have XADD, but you do have LL/SC or CMPXCHG, you can do better.

If the only atomic op you have is XCHG, then this is a really poor choice;
similarly if you are using a UP-compiled kernel.

David
