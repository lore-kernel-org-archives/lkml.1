Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933605Ab0BPXev (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 18:34:51 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33810 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933129Ab0BPXet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 18:34:49 -0500
Date: Tue, 16 Feb 2010 15:34:01 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jan Kara <jack@suse.cz>
cc: Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, jengelh@medozas.de,
       stable@kernel.org, gregkh@suse.de
Subject: Re: [PATCH] writeback: Fix broken sync writeback
In-Reply-To: <20100216230017.GJ3153@quack.suse.cz>
Message-ID: <alpine.LFD.2.00.1002161524210.4141@localhost.localdomain>
References: <20100212091609.GB1025@kernel.dk> <alpine.LFD.2.00.1002120722270.7792@localhost.localdomain> <20100215141750.GC3434@quack.suse.cz> <alpine.LFD.2.00.1002151601360.18830@localhost.localdomain> <20100216230017.GJ3153@quack.suse.cz>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 17 Feb 2010, Jan Kara wrote:
>
>   The IO size actually does matter for performance because if you switch
> after 4 MB (current value of MAX_WRITEBACK_PAGES) to writing another inode,

No.

Dammit, read the code.

That's my whole _point_. Look at the for-loop.

We DO NOT SWITCH to another inode, because we just continue in the 
for-loop.

This is why I think your patch is crap. You clearly haven't even read the 
code, the patch makes no sense, and there must be something else going on 
than what you _claim_ is going on.

> So I'll post a new patch with a better changelog shortly.

Not "shortly". Because you clearly haven't looked at the code. Look here:

                /*
                 * If we consumed everything, see if we have more
                 */
                if (wbc.nr_to_write <= 0)
                        continue;

and here:

                /*
                 * Did we write something? Try for more
                 */
                if (wbc.nr_to_write < MAX_WRITEBACK_PAGES)
                        continue;

the point is, the way the code is written, it is very much _meant_ to 
write out one file in one go, except it is supposed to chunk it up so that 
you never see _too_ many dirty pages in flight at any time. Because tons 
of dirty pages in the queues makes for bad latency.

Now, I admit that since your patch makes a difference, there is a bug 
somewhere. That's never what I've argued against. What I argue against is 
your patch itself, and your explanation for it. They don't make sense. 

I suspect that there is something else going on. In particular, I wonder 
if multiple calls to "writeback_inodes_wb()" somehow mess up the wbc 
state, and it starts writing the same inode from the beginning, or it 
simply has some bug that means that it moves the inode to the head of the 
queue, or something.

For example, it might be that the logic in writeback_inodes_wb() moves an 
inode back (the "redirty_tail()" cases) in bad ways when it shouldn't. 

See what I'm trying to say? I think your patch probably just hides the 
_real_ bug. Because it really shouldn't matter if we do things in 4MB 
chunks or whatever, because the for-loop should happily continue.

				Linus
