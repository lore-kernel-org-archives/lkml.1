Return-Path: <linux-kernel-owner+w=401wt.eu-S1765190AbXKOQdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765190AbXKOQdm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 11:33:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758101AbXKOQde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 11:33:34 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49148 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758201AbXKOQdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 11:33:33 -0500
Date: Thu, 15 Nov 2007 08:32:22 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bron Gondwana <brong@fastmail.fm>
cc: Christian Kujau <lists@nerdbynature.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       robm@fastmail.fm
Subject: Re: mmap dirty limits on 32 bit kernels (Was: [BUG] New Kernel
 Bugs)
In-Reply-To: <20071115115049.GA8297@brong.net>
Message-ID: <alpine.LFD.0.9999.0711150818320.2786@woody.linux-foundation.org>
References: <20071113.043207.44732743.davem@davemloft.net> <20071113110259.44c56d42.akpm@linux-foundation.org> <alpine.DEB.0.9999.0711132055550.7865@sheep.housecafe.de> <20071113130411.26ccae12.akpm@linux-foundation.org> <alpine.DEB.0.99999.0711132239350.3960@sheep.housecafe.de>
 <20071115040708.GB15302@brong.net> <alpine.LFD.0.9999.0711142020220.2786@woody.linux-foundation.org> <20071115052538.GA21522@brong.net> <alpine.LFD.0.9999.0711142130090.2786@woody.linux-foundation.org> <alpine.LFD.0.9999.0711142148380.2786@woody.linux-foundation.org>
 <20071115115049.GA8297@brong.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 15 Nov 2007, Bron Gondwana wrote:
> 
> I guess we'll be doing the one-liner kernel mod and testing
> that then.

The thing to look at is "get_dirty_limits()" in mm/page-writeback.c, and 
in this particular case it's the

	unsigned long available_memory = determine_dirtyable_memory();

that's going to bite you. In particular, note the

	x -= highmem_dirtyable_memory(x);

that we do in determine_dirtyable_memory().

So in this case, if you basically remove that line, it will allow all of 
memory to be dirtied (including highmem), and then the background_ratio 
will work on the whole 6GB.

HOWEVER! It's worth noting that we also have some other old legacy cruft 
there that may interfere with your code. In particular, if you look at the 
top of "get_dirty_limits()", it *also* does a

        unmapped_ratio = 100 - ((global_page_state(NR_FILE_MAPPED) +
                                global_page_state(NR_ANON_PAGES)) * 100) /
                                        available_memory;

        dirty_ratio = vm_dirty_ratio;
        if (dirty_ratio > unmapped_ratio / 2)
                dirty_ratio = unmapped_ratio / 2;

and that whole "unmapped_ratio" comparison is probably bogus these days, 
since we now take the mapped dirty pages into account. That code harks 
back to the days before we did that, and dirty ratios only affected 
non-mapped pages.

And in particular, now that I look at it, I wonder if it can even go 
negative (because "available_memory" may be *smaller* than the 
NR_FILE_MAPPED|ANON_PAGES sum!).

We'll fix up a negative value anyway (because of the clamping of 
dirty_ratio to no less than 5), but the point is that the whole 
"unmapped_ratio" thing probably doesn't make sense any more, and may well 
make the dirty_ratio not work for you, because you may have a very small 
unmapped_ratio that effectively makes all dirty limits always clamp to a 
very small value.

So regardless, I think you may want to try the appended patch *first*.

If this patch makes a difference, please holler. I think it's the correct 
thing to do, but I'm not going to actually commit it without somebody 
saying that it makes a difference (and preferably Peter Zijlstra and 
Andrew acking it too).

Only *after* testing this change is it probably a good idea to test the 
real hack of then removing the highmem_dirtyable_memory() thing. 

Peter? Andrew?

		Linus

---
 mm/page-writeback.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 81a91e6..d55cfca 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -297,20 +297,12 @@ get_dirty_limits(long *pbackground, long *pdirty, long *pbdi_dirty,
 {
 	int background_ratio;		/* Percentages */
 	int dirty_ratio;
-	int unmapped_ratio;
 	long background;
 	long dirty;
 	unsigned long available_memory = determine_dirtyable_memory();
 	struct task_struct *tsk;
 
-	unmapped_ratio = 100 - ((global_page_state(NR_FILE_MAPPED) +
-				global_page_state(NR_ANON_PAGES)) * 100) /
-					available_memory;
-
 	dirty_ratio = vm_dirty_ratio;
-	if (dirty_ratio > unmapped_ratio / 2)
-		dirty_ratio = unmapped_ratio / 2;
-
 	if (dirty_ratio < 5)
 		dirty_ratio = 5;
 
