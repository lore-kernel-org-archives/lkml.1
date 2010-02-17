Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933703Ab0BQADS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 19:03:18 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52814 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933678Ab0BQADK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 19:03:10 -0500
Date: Tue, 16 Feb 2010 16:01:58 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jan Kara <jack@suse.cz>
cc: Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, jengelh@medozas.de,
       stable@kernel.org, gregkh@suse.de
Subject: Re: [PATCH] writeback: Fix broken sync writeback
In-Reply-To: <alpine.LFD.2.00.1002161524210.4141@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1002161536050.4141@localhost.localdomain>
References: <20100212091609.GB1025@kernel.dk> <alpine.LFD.2.00.1002120722270.7792@localhost.localdomain> <20100215141750.GC3434@quack.suse.cz> <alpine.LFD.2.00.1002151601360.18830@localhost.localdomain> <20100216230017.GJ3153@quack.suse.cz>
 <alpine.LFD.2.00.1002161524210.4141@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 16 Feb 2010, Linus Torvalds wrote:
> 
> For example, it might be that the logic in writeback_inodes_wb() moves an 
> inode back (the "redirty_tail()" cases) in bad ways when it shouldn't. 

Or another example: perhaps we screw up the inode list ordering when we 
move the inodes between b_dirty <-> b_io <-> b_more_io?

And if we put inodes on the b_more_io list, do we perhaps then end up 
doing too much waiting in inode_wait_for_writeback()?

See what I'm saying? Your patch - by just submitting the maximal sized 
buffers - may well end up hiding the real problem. But if there is a real 
problem in that whole list manipulation or waiting, then that problem 
still exists for async writeback.

Wouldn't it be better to fix the real problem, so that async writeback 
also gets the correct IO patterns? 

NOTE! It's entirely possible that we do end up wanting to really submit 
the maximal dirty IO for synchronous dirty writeback, in order to get 
better IO patterns. So maybe your patch ends up being the right one in the 
end. But I really _really_ want to understand this.

But right now, that patch seems like voodoo programming to me, and I 
personally suspect that the real problem is in the horribly complex 
b_io/b_more_io interaction. Or one of the _other_ horribly complex details 
in the write-back logic (even just writing back a single inode is 
complicated, see all the logic about "range_start/range_end" in the lower 
level write_cache_pages() function).

Our whole writeback code is very very complicated. I don't like it. But 
that's also why I want to feel like I understand the patch when I apply 
it.

			Linus
