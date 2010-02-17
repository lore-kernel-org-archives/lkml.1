Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933916Ab0BQB6R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 20:58:17 -0500
Received: from bld-mail17.adl2.internode.on.net ([150.101.137.102]:55561 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933879Ab0BQB6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 20:58:16 -0500
Date: Wed, 17 Feb 2010 12:57:34 +1100
From: Dave Chinner <david@fromorbit.com>
To: Jan Kara <jack@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, jengelh@medozas.de,
       stable@kernel.org, gregkh@suse.de
Subject: Re: [PATCH] writeback: Fix broken sync writeback
Message-ID: <20100217015734.GH28392@discord.disaster>
References: <20100212091609.GB1025@kernel.dk> <alpine.LFD.2.00.1002120722270.7792@localhost.localdomain> <20100215141750.GC3434@quack.suse.cz> <alpine.LFD.2.00.1002151601360.18830@localhost.localdomain> <20100216230017.GJ3153@quack.suse.cz> <alpine.LFD.2.00.1002161524210.4141@localhost.localdomain> <20100217013336.GK3153@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100217013336.GK3153@quack.suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 17, 2010 at 02:33:37AM +0100, Jan Kara wrote:
> On Tue 16-02-10 15:34:01, Linus Torvalds wrote:
> > On Wed, 17 Feb 2010, Jan Kara wrote:
> > >
> > >   The IO size actually does matter for performance because if you switch
> > > after 4 MB (current value of MAX_WRITEBACK_PAGES) to writing another inode,
> > 
> > No.
> > 
> > Dammit, read the code.
> > 
> > That's my whole _point_. Look at the for-loop.
> > 
> > We DO NOT SWITCH to another inode, because we just continue in the 
> > for-loop.
> > 
> > This is why I think your patch is crap. You clearly haven't even read the 
> > code, the patch makes no sense, and there must be something else going on 
> > than what you _claim_ is going on.
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

That is my understanding of how it works, too.

>   I *think* it is by design - mainly to avoid the situation where someone
> continuously writes a huge file and kupdate or pdflush would never get to
> writing other files with dirty data (at least that's impression I've built
> over the years - heck, even 2.6.16 seems to have this redirty_tail logic
> with a comment about the above livelock).

Right, and there is another condition as well - writing lots of
small files could starve large file writeback as the large file only
got 4MB written back every 30s writeback period because it took that
long to write out all the new files.

IIRC it was in 2.6.16 that both these problems were fixed...

>   I do find this design broken as well as you likely do and think that the
> livelock issue described in the above paragraph should be solved differently
> (e.g. by http://lkml.org/lkml/2010/2/11/321) but that's not a quick fix.
> 
>   The question is what to do now for 2.6.33 and 2.6.32-stable. Personally,
> I think that changing the writeback logic so that it does not switch inodes
> after 4 MB is too risky for these two kernels. So with the above
> explanation would you accept some fix along the lines of original Jens'
> fix?

We've had this sync() writeback behaviour for a long time - my
question is why is it only now a problem?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
