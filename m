Return-Path: <linux-kernel-owner+w=401wt.eu-S1757849AbXI2PGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757849AbXI2PGZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 11:06:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754161AbXI2PGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 11:06:17 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:45959 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878AbXI2PGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 11:06:16 -0400
Subject: Re: [PATCH 05/12] mm: trylock_page
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
       Zach Brown <zach.brown@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org
In-Reply-To: <200709281311.37616.nickpiggin@yahoo.com.au>
References: <20070928074200.436463000@chello.nl>
	 <20070928080041.891125000@chello.nl>
	 <200709281311.37616.nickpiggin@yahoo.com.au>
Content-Type: text/plain
Date: Sat, 29 Sep 2007 17:01:34 +0200
Message-Id: <1191078095.18147.126.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2007-09-28 at 13:11 +1000, Nick Piggin wrote:
> On Friday 28 September 2007 17:42, Peter Zijlstra wrote:
> > Replace raw TestSetPageLocked() usage with trylock_page()
> 
> I have such a thing queued too, for the lock bitops patches for when 2.6.24
> opens, Andrew promises me :).
> 
> I guess they should be identical, except I don't like doing trylock_page in
> place of SetPageLocked, for memory ordering performance and aesthetic
> reasons... I've got an init_page_locked (or set_page_locked... I can't
> remember, the patch is at home).

Sure, that might work, or we could just make it so that add_to_*_cache
is never passed an unlocked page. But sure...

> Fine idea to lockdep the page lock, anyway. Does it show up any of the
> buffered write deadlock possibilities? :)

Not yet, it might just be that the concessions done to annotate this
type of lock were too severe.

What I basically did was treat all the page locks as a single recursive
lock.

> buffer lock is another notable bit-mutex that might be converted (I have
> the patch to do the similar nice !tas->trylock conversion for that too). I
> think it is used widely enough by tricky code that it would be useful to
> annotate as well.

Not at all familiar with that lock, but yeah, we could have a look at
doing that too.

> Unfortunately we can't convert bit_spinlock.h easily, I guess?

Yeah, the space constraints make that rather hard. Each of these locks
needs some form of external meta-data.

For the page lock I used one lock instance per file system type.

