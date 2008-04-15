Return-Path: <linux-kernel-owner+w=401wt.eu-S1758859AbYDOQE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758859AbYDOQE2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 12:04:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753150AbYDOQEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 12:04:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42799 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750840AbYDOQET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 12:04:19 -0400
Date: Tue, 15 Apr 2008 09:02:53 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Christoph Lameter <clameter@sgi.com>, Mel Gorman <mel@csn.ul.ie>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Yinghai.Lu@sun.com
Subject: Re: [bug] SLUB + mm/slab.c boot crash in -rc9
In-Reply-To: <20080415062534.GA9172@elte.hu>
Message-ID: <alpine.LFD.1.00.0804150838161.2879@woody.linux-foundation.org>
References: <20080411074145.GA4944@elte.hu> <84144f020804110121l8444aafl4631071b34c458fe@mail.gmail.com> <84144f020804110150q367260f6k473380a1309db878@mail.gmail.com> <20080411085411.GA10181@elte.hu> <84144f020804110205u3d073e76lbcdd36ec293a169b@mail.gmail.com>
 <84144f020804110208m41414c0h2ed71b85efbb426c@mail.gmail.com> <84144f020804110211w4ae41414od24cf2de72453e13@mail.gmail.com> <20080415062534.GA9172@elte.hu>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 15 Apr 2008, Ingo Molnar wrote:
>
> debug output is:
> 
>   http://redhat.com/~mingo/misc/log-Thu_Apr_10_10_41_16_CEST_2008.bad.rc9
> 
> so it's probably the first few page allocations (setup_cpu_cache()) 
> going wrong already - suggesting a some fundamental borkage in SLAB?

Well, I think it suggests some fundamental borkage in the page allocator.

That first warn-on is from the "alloc_pages_node()" returning NULL at 
bootup. Sure, it could be that the arguments are bogus, but that sounds 
unlikely since none of that is dependent on any kconfig stuff.

The fact that it happens with both SLUB/SLAB makes that even more obvious.

Now, you don't have fault injection on, so it can't be that, and your 
debug entry for *z == NULL didn' trigger in alloc_pages, so it's no that 
one either. 

However, if __alloc_pages() failed, I would have expected to see the 
"memory allocation failed" printk. Why didn't it? Is printk_ratelimit() 
broken at boot (last_msg start out as zero - maybe i should start out as 
a negative number)?

			Linus
