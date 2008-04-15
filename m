Return-Path: <linux-kernel-owner+w=401wt.eu-S1762992AbYDOUSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762992AbYDOUSR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 16:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751536AbYDOUSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 16:18:04 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48823 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751444AbYDOUSD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 16:18:03 -0400
Date: Tue, 15 Apr 2008 22:17:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <clameter@sgi.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Yinghai.Lu@sun.com, apw@shadowen.org,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [bug] SLUB + mm/slab.c boot crash in -rc9
Message-ID: <20080415201734.GA25628@elte.hu>
References: <84144f020804110205u3d073e76lbcdd36ec293a169b@mail.gmail.com> <84144f020804110208m41414c0h2ed71b85efbb426c@mail.gmail.com> <84144f020804110211w4ae41414od24cf2de72453e13@mail.gmail.com> <20080415062534.GA9172@elte.hu> <alpine.LFD.1.00.0804150838161.2879@woody.linux-foundation.org> <20080415161532.GA15088@elte.hu> <alpine.LFD.1.00.0804151010500.2879@woody.linux-foundation.org> <Pine.LNX.4.64.0804151232080.1785@schroedinger.engr.sgi.com> <20080415195430.GA23015@elte.hu> <Pine.LNX.4.64.0804151255390.1785@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804151255390.1785@schroedinger.engr.sgi.com>
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


* Christoph Lameter <clameter@sgi.com> wrote:

> > Pretty please, could you pay more than cursory attention to this bug 
> > i already spent two full days on and which is blocking the v2.6.25 
> > release?
> 
> Yeah trying to get to understand how exactly sparsemem works and how 
> the 32 bit highmem stuff interacts with it... Sorry not code that I am 
> an expert in nor the platform that I am familiar with. Code mods there 
> required heavy review from multiple parties with expertise in various 
> subjects.

yeah - sorry about that impatient flame. And it could still be anything 
from the page allocator to bootmem - or some completely unrelated piece 
of code corrupting some key data structure.

sparsemem is supposed to work roughly like this on x86 (32-bit):

- the x86 memory map comes from the bios via e820.

- those individual chunks of e820-enumerated memory get
  registered with mm/sparse.c's data structures via memory_present()
  callbacks. [btw., this should be renamed to register_memory_present()
  or register_sparse_range() - something less opaque.]

- there's really just 3 RAM areas that matter on this box, and the last 
  one is unusable for !PAE, which leaves 2.

- there's a 256 MB PCI aperture hole at 0xf0000000.

- out of the 64 sparse memory chunk the first 60 get filled in (all have 
  at least partially some RAM content) - the last 4 [the PCI aperture 
  hole] remains !present.

- we pass in an array of 3 zones to free_area_init_nodes().

- we free the lowmem pages into the buddy allocator via the usual 
  generic setup

- we have a special loop for highmem pages in arch/x86/mm/init_32.c, 
  set_highmem_pages_init(). This just goes through the PFNs one by one 
  and does an explicit __free_page() on all RAM pages that are in the 
  mem_map[] and which are non-reserved.

and that's it roughly.

my current guess would have been some bootmem regression/interaction 
that messes up the buddy bitmaps - but i just reverted to the v2.6.24 
version of bootmem.c and that crashes too ...

	Ingo
