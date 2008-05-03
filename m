Return-Path: <linux-kernel-owner+w=401wt.eu-S1765116AbYECQia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765116AbYECQia (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 12:38:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759440AbYECQiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 12:38:21 -0400
Received: from saeurebad.de ([85.214.36.134]:38294 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759075AbYECQiT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 12:38:19 -0400
X-Mailbox-Line: From hannes@symbol.fehenstaub.lan Sat May  3 17:28:00 2008
Message-Id: <20080503152502.191599824@symbol.fehenstaub.lan>
User-Agent: quilt/0.46-1
Date: Sat, 03 May 2008 17:25:02 +0200
From: Johannes Weiner <hannes@saeurebad.de>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [RFC 0/2] Rootmem: boot-time memory allocator
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I was spending some time and work on the bootmem allocator the last
few weeks and came to the conclusion that its current design is not
appropriate anymore.

As Ingo said in another email, NUMA technologies will become weirder,
nodes whose PFNs span other nodes for example and it makes bootmem
code become an unreadable mess.

So I sat down two days ago and rewrote the allocator, here is the
result: rootmem!

The biggest difference to the old design is that there is only one
bitmap for all PFNs of all nodes together, so the overlapping PFN
problems simply dissolve and fun like allocations crossing node
boundaries work implicitely.  The new API requires every node used by
the allocator to be registered and after that the bitmap gets
allocated and the allocator enabled.

I chose to add a new allocator rather than replacing bootmem at once
because that would have required all callsites to switch in one go,
which would be a lot.  The new allocator can be adopted more slowly
and I added a compatibility API for everything besides actually
setting up the allocator.  When the last user dies, bootmem can be
dropped completely (including pgdat->bdata, whee..)

The main ideas from bootmem have been stolen^W preserved but the new
design allowed me to shrink the code a lot and express things more
simple and clear:

$ sloc.awk < mm/bootmem.c
455 lines of code, 65 lines of comments (520 lines total)

$ sloc.awk < mm/rootmem.c
243 lines of code, 96 lines of comments (339 lines total)

The first patch contains rootmem itself while the second one is a
quick hack to get it working on my 32bit x86 box.

Sparsemem support and some convenience functions are still missing,
but the core should be more or less complete.

Migration on arch-code is not that exciting, see the second patch.
The main difference is that you first register all nodes and then pass
rootmem_setup() a pfn where the bitmap should be placed.

I can not test on anything but 32bit uma x86, so node specific code
works only theoretically.

I can not garuantee uncorrupted memory either :)

Applies to Linus' head.

	Hannes

