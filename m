Return-Path: <linux-kernel-owner+w=401wt.eu-S1755247AbZBOTRQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247AbZBOTRQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 14:17:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753416AbZBOTRA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 14:17:00 -0500
Received: from casper.infradead.org ([85.118.1.10]:35164 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297AbZBOTQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 14:16:59 -0500
Date: Sun, 15 Feb 2009 11:16:36 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH 1/7] async: Asynchronous function calls to speed up
 kernel boot
Message-ID: <20090215111636.5b6cc507@infradead.org>
In-Reply-To: <20090213232926.924d8740.akpm@linux-foundation.org>
References: <20090107151151.458333c1@infradead.org>
	<20090107151226.58264d07@infradead.org>
	<20090213162200.8fea7e0c.akpm@linux-foundation.org>
	<20090213205949.1ebb441d@infradead.org>
	<20090213232926.924d8740.akpm@linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Feb 2009 23:29:26 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 13 Feb 2009 20:59:49 -0800 Arjan van de Ven
> <arjan@infradead.org> wrote:
> 
> > On Fri, 13 Feb 2009 16:22:00 -0800
> > Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > It means that sometimes, very rarely, the callback function will
> > > be called within the caller's context.
> > 
> > for the cases that use it right now it is ok.
> 
> That doesn't mean it's any good!  There are only two callsites.

.. in mainline.
There's a few more in various maintainer trees.

> 
> Plus there's the issue which I mentioned: if someone _does_ call this
> from atomic context they'll only find out about their bug when the
> GFP_ATOMIC allocation fails.  This is bad!

as far as I know all current and pending callsites can deal with
GFP_KERNEL, so I would just switch it to that for those; solves the
entire issue. (I do need to check the suspend/resume speed improvements,
S/R tends to be tricky with interrupts-off)

Fundamentally there are two types of usecases:

1) The case where you have "just turn this existing function call into
something asynchronous".
2) I want to call <this> thing in a guaranteed different, process,
context.

Both need some degree of synchronization, and I believe the current
synchronization in the async stuff would work for both.

But these two are fundamentally different cases. The former is what is
covered now, the later is what you would like to use.
Both are absolutely valid cases; I just think they need separate APIs
(but can share the backend): a simple one for the simple case and a more
complex one for the second case.

The first case really is replacing the function call with a small
wrapper. (Ideally it'd be a gcc attribute but that's fantasy not
reality).

The second case is a bit more complex, and is allowed to be more
complex because the caller wants to do a more complex thing.
So lets talk requirements for the second case; and please provide
comments/additions/improvements

* The caller needs to provide the memory
   - solves the case of the internal implementation getting a failed
     allocation. BUT it does not solve the caller not getting memory,
     it shifts the complexity to there.
   - ... or needs to cope with the call potentially failing if it
     lets the infrastructure to do the allocation
* The caller needs to wait (at some point) for the operation to
  complete, and then take care of freeing the memory.
  (the memory obviously could be part of some natural structure that
   already has its own lifecycle rules)
* There must be enough worker threads such that deadlocks due to all
  threads waiting on each other will not happen. Practically this
  probably means that if there is no progress, we need to just swallow
  the pill and make more threads. In addition we can borrow the thread
  context of the threads that are waiting for work to complete
  - alternative is to have 2 (or more) classes of work with a reserved
    thread pool for each, but I'm very not fond of this idea, because
    then all the advantages of sharing the implementation go away again,
    and over time we'll end up with many such classes
* The caller is not allowed to use the same memory for scheduling
  multiple outstanding function calls (this is fundamentally different
  from schedule_work, which does allow this).
  - we could make a flag that marks an item as "if the function and data
    are the same silently allow it" but I'm not too fond of that idea,
    it'll be fragile.

Practically: the scheduled function is not allowed to make the metadata
memory go away. At least for those cases where we later want to wait
for the opertation; in principle we could do away with this requirement
if we know nobody will ever wait for the operation.
Second practical issue:
We can have a flag in the metadata that says that the infrastructure is 
supposed to kfree() the metadata at the end. Or we can go wild and stick
a pointer in of the function that needs to be called to free the
metadata.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
