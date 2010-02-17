Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751070Ab0BQFRe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 00:17:34 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33508 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750847Ab0BQFRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 00:17:33 -0500
Date: Tue, 16 Feb 2010 21:16:46 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: tytso@mit.edu
cc: Jan Kara <jack@suse.cz>, Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, jengelh@medozas.de,
       stable@kernel.org, gregkh@suse.de
Subject: Re: [PATCH] writeback: Fix broken sync writeback
In-Reply-To: <20100217043009.GZ5337@thunk.org>
Message-ID: <alpine.LFD.2.00.1002162052230.4141@localhost.localdomain>
References: <20100212091609.GB1025@kernel.dk> <alpine.LFD.2.00.1002120722270.7792@localhost.localdomain> <20100215141750.GC3434@quack.suse.cz> <alpine.LFD.2.00.1002151601360.18830@localhost.localdomain> <20100216230017.GJ3153@quack.suse.cz>
 <alpine.LFD.2.00.1002161524210.4141@localhost.localdomain> <20100217013336.GK3153@quack.suse.cz> <alpine.LFD.2.00.1002161848370.4141@localhost.localdomain> <20100217043009.GZ5337@thunk.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 16 Feb 2010, tytso@mit.edu wrote:
>
> We've had this logic for a long time, and given the increase in disk
> density, and spindle speeds, the 4MB limit, which might have made
> sense 10 years ago, probably doesn't make sense now.

I still don't think that 4MB is enough on its own to suck quite that 
much. Even a fast device should be perfectly happy with 4MB IOs, or it 
must be sucking really badly. 

In order to see the kinds of problems that got quoted in the original 
thread, there must be something else going on too, methinks (disk light 
was "blinking").

So I would guess that it's also getting stuck on that 

	inode_wait_for_writeback(inode);

inside that loop in wb_writeback(). 

In fact, I'm starting to wonder about that "Nothing written" case. The 
code basically decides that "if I wrote zero pages, I didn't write 
anything at all, so I must wait for the inode to complete old writes in 
order to not busy-loop". Which sounds sensible on the face of it, but the 
thing is, inodes can be dirty without actually having any dirty _pages_ 
associated with them.

Are we perhaps ending up in a situation where we essentially wait 
synchronously on just the inode itself being written out? That would 
explain the "40kB/s" kind of behavior.

If we were actually doing real 4MB chunks, that would _not_ explain 40kB/s 
throughput. 

But if we do a 4MB chunk (for the one file that had real dirty data in 
it), and then do a few hundred trivial "write out the inode data 
_synchronously_" (due to access time changes etc) in between until we hit 
the file that has real dirty data again - now _that_ would explain 40kB/s 
throughput. It's not just seeking around - it's not even trying to push 
multiple IO's to get any elevator going or anything like that.

And then the patch that started this discussion makes sense: it improves 
performance because in between those synchronous inode updates it now 
writes big chunks. But again, it's mostly hiding us just doing insane 
things.

I dunno. Just a theory. The more I look at that code, the uglier it looks. 
And I do get the feeling that the "4MB chunking" is really just making the 
more fundamental problems show up.

			Linus
