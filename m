Return-Path: <linux-kernel-owner+w=401wt.eu-S1765297AbYDOQQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765297AbYDOQQa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 12:16:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753196AbYDOQQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 12:16:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60741 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761754AbYDOQQU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 12:16:20 -0400
Date: Tue, 15 Apr 2008 18:15:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Christoph Lameter <clameter@sgi.com>, Mel Gorman <mel@csn.ul.ie>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Yinghai.Lu@sun.com
Subject: Re: [bug] SLUB + mm/slab.c boot crash in -rc9
Message-ID: <20080415161532.GA15088@elte.hu>
References: <20080411074145.GA4944@elte.hu> <84144f020804110121l8444aafl4631071b34c458fe@mail.gmail.com> <84144f020804110150q367260f6k473380a1309db878@mail.gmail.com> <20080411085411.GA10181@elte.hu> <84144f020804110205u3d073e76lbcdd36ec293a169b@mail.gmail.com> <84144f020804110208m41414c0h2ed71b85efbb426c@mail.gmail.com> <84144f020804110211w4ae41414od24cf2de72453e13@mail.gmail.com> <20080415062534.GA9172@elte.hu> <alpine.LFD.1.00.0804150838161.2879@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0804150838161.2879@woody.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Tue, 15 Apr 2008, Ingo Molnar wrote:
> >
> > debug output is:
> > 
> >   http://redhat.com/~mingo/misc/log-Thu_Apr_10_10_41_16_CEST_2008.bad.rc9
> > 
> > so it's probably the first few page allocations (setup_cpu_cache()) 
> > going wrong already - suggesting a some fundamental borkage in SLAB?
> 
> Well, I think it suggests some fundamental borkage in the page 
> allocator.
> 
> That first warn-on is from the "alloc_pages_node()" returning NULL at 
> bootup. Sure, it could be that the arguments are bogus, but that 
> sounds unlikely since none of that is dependent on any kconfig stuff.
> 
> The fact that it happens with both SLUB/SLAB makes that even more 
> obvious.
> 
> Now, you don't have fault injection on, so it can't be that, and your 
> debug entry for *z == NULL didn' trigger in alloc_pages, so it's no 
> that one either.
> 
> However, if __alloc_pages() failed, I would have expected to see the 
> "memory allocation failed" printk. Why didn't it? Is 
> printk_ratelimit() broken at boot (last_msg start out as zero - maybe 
> i should start out as a negative number)?

btw., now with a second full day spent on this regression, i have 
figured out a workaround the hard way: increasing SECTION_SIZE_BITS in 
include/asm-x86/sparsemem.h from 26 to 27 makes it go away. (i.e. we use 
section chunks of 128 MB instead of 64 MB before) I've given up on 
analyzing the crash site - it seems rather random and uninformative and 
just suggests page allocator borkage.

So this seems like a general sparsemem borkage. PAE uses a shift of 30 
due to page->flags shortage (which masks this bug), 64-bit uses 27 which 
too probably masks this bug.

Since this is a !NUMA config and !PAE as well, NODES_SHIFT is 0, 
ZONES_SHIFT is 2, so the theory of running out of bits in page->flags is 
wrong as well.

I also tried a hack to double the size of all sparsemem mem_map 
allocations (on the theory of an overflow there) - but it didnt help.

So i think we need to go down further into the page allocator. Perhaps 
the buddy bitmaps are wrongly sized somewhere. I'm grasping at straws.

Btw., Mel Gorman has reproduced crashes with my bzImage on his box (and 
a hang with my config, using his build), so i think we can eliminate hw 
and build environment specialities as a cause.

	Ingo
