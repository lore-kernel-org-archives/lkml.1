Return-Path: <linux-kernel-owner+w=401wt.eu-S1761718AbXGYKKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761718AbXGYKKW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 06:10:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756337AbXGYKKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 06:10:10 -0400
Received: from gate.crashing.org ([63.228.1.57]:55122 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755698AbXGYKKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 06:10:09 -0400
Subject: Re: [patch] mm: reduce pagetable-freeing latencies
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Hugh Dickins <hugh@veritas.com>
In-Reply-To: <20070725094605.GA9045@one.firstfloor.org>
References: <20070724083855.GA858@elte.hu>
	 <20070724015441.8604d85d.akpm@linux-foundation.org>
	 <1185270045.5439.249.camel@localhost.localdomain>
	 <p73abtmt2y7.fsf@bingen.suse.de>
	 <1185312559.5439.276.camel@localhost.localdomain>
	 <1185345850.8197.64.camel@twins> <20070725094605.GA9045@one.firstfloor.org>
Content-Type: text/plain
Date: Wed, 25 Jul 2007 20:08:13 +1000
Message-Id: <1185358093.5439.325.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-07-25 at 11:46 +0200, Andi Kleen wrote:
> > You could perhaps use C99 variable length arrays to avoid the stack
> > waste when not needed, however Andi once told me that generates rather
> > dubious code.
> 
> It generates frame pointers, but that's not that bad.  I'm not 
> aware of any other bad side effects. Ok the compiler will limit
> your goto usage, but that's more a good thing.
> 
> But since you always have to strictly limit the array in kernel code anyways
> you could as well just allocate the fixed limit.

Plan is fixed array or 4 or maybe 8 entries (pointers), that shouldn't
be -too- bad. The code path I'm a bit worried about is
unmap_mapping_ranges() which goes into zapping page tables from deep
within filesystems.

At worst, I can reduce the fixed array to 1 entry. That means that if
the batch can't manage to get a page to use for the page list, it will
end up doing the flush for each page :-) But that should rarely happen,
in fact, I would expect it to be able to get a page the next time around
because it just freed one...

Ben.


