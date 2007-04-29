Return-Path: <linux-kernel-owner+w=401wt.eu-S933208AbXD2MzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933208AbXD2MzW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 08:55:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933213AbXD2MzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 08:55:22 -0400
Received: from holomorphy.com ([66.93.40.71]:59335 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933208AbXD2MzM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 08:55:12 -0400
Date: Sun, 29 Apr 2007 05:55:22 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Kasper Sandberg <lkml@metanurb.dk>, Willy Tarreau <w@1wt.eu>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>, caglar@pardus.org.tr,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>
Subject: Re: [patch] CFS scheduler, -v6
Message-ID: <20070429125522.GB31925@holomorphy.com>
References: <20070427115526.GA7699@elte.hu> <1177774551.21279.8.camel@localhost> <1177809512.9756.10.camel@localhost> <20070429053022.GB23638@1wt.eu> <20070429065900.GB32281@elte.hu> <20070429071627.GC23638@1wt.eu> <1177842654.5791.85.camel@localhost.localdomain> <20070429111159.GH23638@1wt.eu> <1177848054.9756.30.camel@localhost> <1177848810.5791.104.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1177848810.5791.104.camel@localhost.localdomain>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 29, 2007 at 02:13:30PM +0200, Thomas Gleixner wrote:
> SD is a one to one replacement of the existing scheduler guts - with a
> different behaviour.
> CFS is a huge step into a modular and hierarchical scheduler design,
> which allows more than just implementing a clever scheduler for a single
> purpose. In a hierarchical scheduler you can implement resource
> management and other fancy things, in the monolitic design of the
> current scheduler (and it's proposed replacement SD) you can't. But SD
> can be made one of the modular variants.

The modularity provided is not enough to allow an implementation of
mainline, SD, or nicksched without significant core scheduler impact.

CFS doesn't have all that much to do with scheduler classes. A weak form
of them was done in tandem with the scheduler itself. The modularity
provided is sufficiently weak the advantage is largely prettiness of the
code. So essentially CFS is every bit as monolithic as mainline, SD, et
al, with some dressing that suggests modularity without actually making
any accommodations for alternative policies (e.g. reverting to mainline).

You'll hit the holes in the driver API quite quickly should you attempt
to port mainline to it. You'll hit several missing driver operations
right in schedule(), for starters. At some point you may also notice
that simple enqueue operations are not all that's there. Representing
enqueueing to active vs. expired and head vs. tail are needed for
current mainline to be representible by a set of driver operations.
It's also a bit silly to remove and re-insert a queue element for cfs
(or anything else using a tree-structured heap, which yes, a search
tree is, even if a slow one), which could use a reprioritization driver
operation, but I suppose it won't oops.

You'll also hit the same holes should you attempt to write such a
modularity patch for mainline as opposed to porting current mainline to
the driver API as-given. It takes a bit more work to get something that
actually works for all this, and it borders on disingenuity to
suggest that the scheduler class/driver API as it now stands is
capable of any such thing as porting current mainline, nicksched, or SD
to it without significant code impact to the core scheduler code.

So on both these points, I don't see cfs as being adequate as it now
stands for a modular, hierarchical scheduler design. If we want a truly
modular and hierarchical scheduler design, I'd suggest pursuing it
directly and independently of policy, and furthermore considering the
representability of various policies in the scheduling class/driver API
as a test of its adequacy.


-- wli
