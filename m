Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934000Ab0BQDgy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 22:36:54 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58802 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933959Ab0BQDgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 22:36:53 -0500
Date: Tue, 16 Feb 2010 19:35:35 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jan Kara <jack@suse.cz>
cc: Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, jengelh@medozas.de,
       stable@kernel.org, gregkh@suse.de
Subject: Re: [PATCH] writeback: Fix broken sync writeback
In-Reply-To: <20100217013336.GK3153@quack.suse.cz>
Message-ID: <alpine.LFD.2.00.1002161848370.4141@localhost.localdomain>
References: <20100212091609.GB1025@kernel.dk> <alpine.LFD.2.00.1002120722270.7792@localhost.localdomain> <20100215141750.GC3434@quack.suse.cz> <alpine.LFD.2.00.1002151601360.18830@localhost.localdomain> <20100216230017.GJ3153@quack.suse.cz>
 <alpine.LFD.2.00.1002161524210.4141@localhost.localdomain> <20100217013336.GK3153@quack.suse.cz>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 17 Feb 2010, Jan Kara wrote:
>
>   I've read the code. Maybe I'm missing something but look:
> writeback_inodes_wb(nr_to_write = 1024)
>   -> queue_io() - queues inodes from wb->b_dirty list to wb->b_io list
>   ...
>   writeback_single_inode()
>     ...writes 1024 pages.
>     if we haven't written everything in the inode (more than 1024 dirty
>     pages) we end up doing either requeue_io() or redirty_tail(). In the
>     first case the inode is put to b_more_io list, in the second case to
>     the tail of b_dirty list. In either case it will not receive further
>     writeout until we go through all other members of current b_io list.
> 
>   So I claim we currently *do* switch to another inode after 4 MB. That
> is a fact.

Ok, I think that's the bug. I do agree that it may well be intentional, 
but considering the performance impact, I suspect it's been "intentional 
without any performance numbers".

Which just makes me very unhappy to just paper it over for the sync case, 
and leave the now known-broken state alone for the async case. That really 
isn't how we want to do things.

That said, if we've done this forever, I can certainly see the allure to 
just keep doing it, and then handle the sync case separately. 

>   I do find this design broken as well as you likely do and think that the
> livelock issue described in the above paragraph should be solved differently
> (e.g. by http://lkml.org/lkml/2010/2/11/321) but that's not a quick fix.

Hmm. The thing is, the new radix tree bit you propose also sounds like 
overdesigning things. 

If we really do switch inodes (which I obviously didn't expect, even if I 
may have been aware of it many years ago), then the max rate limiting is 
just always bad.

If it's bad for synchronous syncs, then it's bad for background syncing 
too, and I'd rather get rid of the MAX_WRITEBACK_PAGES thing entirely - 
since the whole latency argument goes away if we don't always honor it 
("Oh, we have good latency - _except_ if you do 'sync()' to synchronously 
write something out" - that's just insane).

>   The question is what to do now for 2.6.33 and 2.6.32-stable. Personally,
> I think that changing the writeback logic so that it does not switch inodes
> after 4 MB is too risky for these two kernels. So with the above
> explanation would you accept some fix along the lines of original Jens'
> fix?

What is affected if we just remove MAX_WRITEBACK_PAGES entirely (as 
opposed to the patch under discussion that effectively removes it for 
WB_SYNC_ALL)?

I see balance_dirty_pages -> bdi_start_writeback, but that if anything 
would be something that I think would be better off with efficient 
writeback, and doesn't seem like it should try to round-robin over inodes 
for latency reasons.

But I guess we can do it in stages, if it's about "minimal changes for 
2.6.32/33.

			Linus
