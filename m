Return-Path: <linux-kernel-owner+w=401wt.eu-S1759359AbYHECSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759359AbYHECSq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 22:18:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752612AbYHECSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 22:18:23 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:50900
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbYHECSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 22:18:22 -0400
Date: Tue, 5 Aug 2008 04:18:12 +0200
From: Andrea Arcangeli <andrea@qumranet.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Dave Jones <davej@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, jeremy@goop.org, hugh@veritas.com,
       mingo@elte.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       arjan <arjan@infradead.org>
Subject: Re: [PATCH] workaround minor lockdep bug triggered by
	mm_take_all_locks
Message-ID: <20080805021812.GI12464@duo.random>
References: <20080804162657.GI11476@duo.random> <1217867935.3589.35.camel@twins> <20080804172728.GJ11476@duo.random> <20080804174659.GK11476@duo.random> <20080804175730.GL11476@duo.random> <1217875739.3589.56.camel@twins> <20080804201514.GB12464@duo.random> <1217882242.3589.90.camel@twins> <20080804210954.GC12464@duo.random> <adar694rzks.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adar694rzks.fsf@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2008 at 07:00:03PM -0700, Roland Dreier wrote:
>  > The point is that this is a runtime evaluation of lock orders, if
>  > runtime isn't the lucky one that reproduces the deadlock, it'll find
>  > nothing at all.
> 
> I think the point you miss is that lockdep can report a potential
> deadlock, even if the deadlock does not actually occur.  For example
> suppose there is an AB-BA deadlock somewhere.  For this to actually
> trigger, we have to have one CPU running the AB code path at exactly the
> moment another CPU runs the BA code path, with the right timing so one
> CPU holds A and tries to grab B while the other CPU already holds B.
> 
> With lockdep, we just have to have the AB code path run once at any
> point, and then the BA code path run at any later time (even days after
> the AB code path has released all the locks).  And then we get a
> warning dump that explains the exact potential deadlock.

Thanks a lot for the detailed explanation of check_noncircular. I
agree check_noncircular is surely a good argument not to get rid of
prove-locking as a whole. But check_noncircular is also a red-herring
in this context. It's not check_noncircular trapping here,
check_deadlock traps with false positives instead. The question is
what are those false positives buying us? To avoid a developer to
press sysrq+p or break on kgdb?

Let's focus on check_deadlock->print_deadlock_bug and somebody who's
not beyond the point please explain what print_deadlock_bug reports
that does not actually occur and why it's a good idea to change the
common code to accommodate for its false positives instead of getting
rid of it for good.
