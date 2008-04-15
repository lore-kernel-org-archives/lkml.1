Return-Path: <linux-kernel-owner+w=401wt.eu-S1763049AbYDOKDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763049AbYDOKDj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 06:03:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755549AbYDOKDb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 06:03:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35829 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755304AbYDOKDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 06:03:31 -0400
Date: Tue, 15 Apr 2008 12:03:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Christoph Lameter <clameter@sgi.com>, Nick Piggin <npiggin@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Yinghai.Lu@sun.com
Subject: Re: [bug] mm/slab.c boot crash in -git, "kernel BUG at
	mm/slab.c:2103!"
Message-ID: <20080415100305.GA27296@elte.hu>
References: <20080411074145.GA4944@elte.hu> <84144f020804110121l8444aafl4631071b34c458fe@mail.gmail.com> <84144f020804110150q367260f6k473380a1309db878@mail.gmail.com> <20080411085411.GA10181@elte.hu> <84144f020804110205u3d073e76lbcdd36ec293a169b@mail.gmail.com> <84144f020804110208m41414c0h2ed71b85efbb426c@mail.gmail.com> <84144f020804110211w4ae41414od24cf2de72453e13@mail.gmail.com> <20080411092452.GE10801@elte.hu> <20080415093628.GD20316@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080415093628.GD20316@csn.ul.ie>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mel Gorman <mel@csn.ul.ie> wrote:

> [    0.000000] Warning only 4GB will be used.
> [    0.000000] Use a HIGHMEM64G enabled kernel.
> [    0.000000] Entering add_active_range(0, 0, 1048576) 0 entries of 256 used
> 
> It's recognised and only memory below 4GB is registered and it's all 
> on node 0. However, I do note that it also registers all the holes as 
> valid memory. The memory should never get freed because it should be 
> reserved during boot by reserve_bootmem() but it still raises an 
> eyebrow.

32-bit does memory_present() calls to register all RAM - and those calls 
are correct (they do not include holes) and the resulting sparse memory 
section layout looks correct, and all the mem_map[] chunk allocations 
succeed as well.

furthermore, when freeing memory from bootmem allocator into the buddy 
allocator we consult the e820 map again via a page_is_ram() call, so we 
make sure holes do not end up in the memory map and in the free page 
pool. (all rounded to section boundaries of course)

> [    0.000000] early_node_map[1] active PFN ranges
> [    0.000000]     0:        0 ->  1048576
> [    0.000000] On node 0 totalpages: 1048576
> [    0.000000]   DMA zone: 32 pages used for memmap
> [    0.000000]   DMA zone: 0 pages reserved
> [    0.000000]   DMA zone: 4064 pages, LIFO batch:0
> [    0.000000]   Normal zone: 1760 pages used for memmap
> [    0.000000]   Normal zone: 223520 pages, LIFO batch:31
> [    0.000000]   HighMem zone: 6400 pages used for memmap
> [    0.000000]   HighMem zone: 812800 pages, LIFO batch:31
> [    0.000000]   Movable zone: 0 pages used for memmap
> 
> And from this, it looks like memmap is getting setup. So far, it looks
> like basic initialisation was ok.

yep. I did a few extra printouts to make sure, but came to the same 
conclusion. The system boots fine with the same config on v2.6.24.

	Ingo
