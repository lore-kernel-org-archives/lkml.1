Return-Path: <linux-kernel-owner+w=401wt.eu-S1759367AbXEIVWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759367AbXEIVWT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 17:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757412AbXEIVWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 17:22:00 -0400
Received: from gate.crashing.org ([63.228.1.57]:40359 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756331AbXEIVV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 17:21:59 -0400
Subject: Re: [rfc] optimise unlock_page
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <npiggin@suse.de>, linux-arch@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>
In-Reply-To: <Pine.LNX.4.64.0705091950080.2909@blonde.wat.veritas.com>
References: <20070508113709.GA19294@wotan.suse.de>
	 <20070508114003.GB19294@wotan.suse.de>
	 <1178659827.14928.85.camel@localhost.localdomain>
	 <20070508224124.GD20174@wotan.suse.de>
	 <20070508225012.GF20174@wotan.suse.de>
	 <Pine.LNX.4.64.0705091950080.2909@blonde.wat.veritas.com>
Content-Type: text/plain
Date: Thu, 10 May 2007 07:21:30 +1000
Message-Id: <1178745690.14928.167.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Not good enough, I'm afraid.  It looks like Ben's right and you need
> a count - and counts in the page struct are a lot harder to add than
> page flags.
> 
> I've now played around with the hangs on my three 4CPU machines
> (all of them in io_schedule below __lock_page, waiting on pages
> which were neither PG_locked nor PG_waiters when I looked).
> 
> Seeing Ben's mail, I thought the answer would be just to remove
> the "_exclusive" from your three prepare_to_wait_exclusive()s.
> That helped, but it didn't eliminate the hangs.

There might be a way ... by having the flags manipulation always
atomically deal with PG_locked and PG_waiters together. This is possible
but we would need even more weirdo bitops abstractions from the arch I'm
afraid... unless we start using atomic_* rather that bitops in order to
manipulate multiple bits at a time.

Ben.


