Return-Path: <linux-kernel-owner+w=401wt.eu-S1764644AbYHDVcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764644AbYHDVcW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 17:32:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763111AbYHDVa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 17:30:29 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:41159
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764303AbYHDVaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 17:30:24 -0400
Date: Mon, 4 Aug 2008 23:30:18 +0200
From: Andrea Arcangeli <andrea@qumranet.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Dave Jones <davej@redhat.com>,
       Roland Dreier <rdreier@cisco.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, jeremy@goop.org, hugh@veritas.com,
       mingo@elte.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       arjan <arjan@infradead.org>
Subject: Re: [PATCH] workaround minor lockdep bug triggered by
	mm_take_all_locks
Message-ID: <20080804213018.GD12464@duo.random>
References: <20080804162657.GI11476@duo.random> <1217867935.3589.35.camel@twins> <20080804172728.GJ11476@duo.random> <20080804174659.GK11476@duo.random> <20080804175730.GL11476@duo.random> <1217875739.3589.56.camel@twins> <20080804201514.GB12464@duo.random> <1217882242.3589.90.camel@twins> <20080804210954.GC12464@duo.random> <84144f020808041414x2c1c8b82n5939b82e9a2ca99d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020808041414x2c1c8b82n5939b82e9a2ca99d@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2008 at 12:14:48AM +0300, Pekka Enberg wrote:
> Sometimes it's hard to actually trigger a deadlock condition during
> development, especially if you're not developing on a big iron
> machine.

My understand is that lockdep can't do static analysis of code, it's
not a checker. It can only evaluate the locks in the order the cpu
takes them. And if the CPU never takes them in the wrong order because
only your unlikely to happen slow path takes them in the wrong order
while the other cpus hold them in the opposite order, lockdep can't
say nothing at all, how could it? If it would say something when the
cpu doesn't deadlock a moment later, then it would be a false positive
99% of the time.

So now we learn lockdep also lead developers to think if their code
doesn't generate lockdep errors it will be safe in production, so
again more damage thanks to lockdep.

Lockdep is a printk that reports that you were incredibly lucky, that
you got the lock inversion during development even if there was only
once chance in a thousand, and that you can celebrate. But I know I
can figure it out by myself when the system has crashed without
something eating all cpu and polluting kernel common code to tell me.

In other words I imagine lockdep as something like this:

	char *ptr = NULL
	BUG_ON(!ptr); /* this is lockdep */
	*ptr = 100;

Luckily nobody dreams to add BUG_ON that checks for null pointer to
dereference, as there's the mmu for that.

The same way for the null pointer dereference, there are zerocost
means to debug all sort of kernel crashing deadlocks.

Now perhaps I misunderstood lockdep entirely but I doubt as this thing
is driven by calls made by the spin_lock functions, and it can't know
anything about the spin_lock that haven't been run by the cpu yet.
