Return-Path: <linux-kernel-owner+w=401wt.eu-S1760494AbYHDSte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760494AbYHDSte (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 14:49:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758435AbYHDStA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 14:49:00 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:26731 "EHLO
	viefep17-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760270AbYHDSs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 14:48:58 -0400
X-SourceIP: 80.57.229.25
Subject: Re: [RFC][PATCH 7/7] lockdep: spin_lock_nest_lock()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrea Arcangeli <andrea@qumranet.com>
Cc: Dave Jones <davej@redhat.com>, Roland Dreier <rdreier@cisco.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, jeremy@goop.org, hugh@veritas.com,
       mingo@elte.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080804172728.GJ11476@duo.random>
References: <20080804130317.994042639@chello.nl>
	 <20080804131012.246115111@chello.nl> <ada63qgvppx.fsf@cisco.com>
	 <1217859571.3589.7.camel@twins> <aday73cua99.fsf@cisco.com>
	 <1217860332.3589.11.camel@twins> <20080804145318.GA17867@redhat.com>
	 <1217861763.3589.13.camel@twins> <20080804162657.GI11476@duo.random>
	 <1217867935.3589.35.camel@twins>  <20080804172728.GJ11476@duo.random>
Content-Type: text/plain
Date: Mon, 04 Aug 2008 20:48:49 +0200
Message-Id: <1217875729.3589.54.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-04 at 19:27 +0200, Andrea Arcangeli wrote:
> On Mon, Aug 04, 2008 at 06:38:55PM +0200, Peter Zijlstra wrote:
> > You also need CONFIG_PROVE_LOCKING, but I'll assume that's set too.
> 
> Sorry, that wasn't the problem, but my current testing passed because
> of another error... to test this report I rebuilt a kvm configured for
> rhel not for mainline so it wasn't the right test...
> 
> When "long ago" I tested that this was working fine (actually when
> Andrew asked me), I guess lockdep was working because the
> implementation with the vmalloc array was slightly different,
> otherwise I don't know. I'm fairly certain that it worked fine at some
> point, and I didn't expect the refactoring to generate false positives.
> 
> > Dave Jones just handed me:
> > 
> >   https://bugzilla.redhat.com/show_bug.cgi?id=457779
> 
> I can reproduce this now yes after a 'make sync'.
> 
> Obviously this is a bug in lockdep that it trips over this otherwise
> if lockdep was right the kernel should deadlock while this is just a
> false positive and everything runs fine.
> 
> I assume it can't understand the spinlock address is different (I
> think it uses the address as key only for static locks), so I wonder
> if you could call print_deadlock_bug() from the failure path of the
> spinlock to solve this?
> 
> Do things like double_rq_lock works just because rq1 and rq2 don't
> have the same name like in my case where all locks are called "mapping"->?

Lockdep doesn't look at individual lock instances, but instead works on
lock classes. The rq locks used to have a separate class each, but the
third patch in this series changes that.

The advantage of not working on lock instances is that the dependency
graph becomes much smaller, and it will report problems much earlier,
the down-side is that you will have to augment the information a little.

Normally locks are grouped in classes based on their init site; eg.
every instance initialized by a particular spin_lock_init() will belong
to the same class.

Besides this grouping, you can use things like spin_lock_nested(), which
can be used to annotate simple recursion (up to 8 sub-classes).

Then there is the possibility to explicitly create classes and assign
locks to classes using lockdep_set_class().

Either way - there is a limit of MAX_LOCK_DEPTH (48) locks that can be
tracked per task (including nesting interrupts).

Making that dynamic is rather challenging - as it would involve
allocating memory while potentially holding allocator locks.

> > David Miller just did a patch that might fix that.
> 
> Woow cool, after 11 months I lost any hope that lockdep could ever
> work in that environment... Was it an actual bug or is this some way
> to lower the complexity of the graph build?

He reduced the search complexity of the graph, look at the first patch
in this series.

