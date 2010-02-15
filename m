Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547Ab0BOORn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 09:17:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47386 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751805Ab0BOORm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 09:17:42 -0500
Date: Mon, 15 Feb 2010 15:17:51 +0100
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, jack@suse.cz,
       jengelh@medozas.de, stable@kernel.org, gregkh@suse.de
Subject: Re: [PATCH] writeback: Fix broken sync writeback
Message-ID: <20100215141750.GC3434@quack.suse.cz>
References: <20100212091609.GB1025@kernel.dk>
 <alpine.LFD.2.00.1002120722270.7792@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1002120722270.7792@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 12-02-10 07:45:04, Linus Torvalds wrote:
> On Fri, 12 Feb 2010, Jens Axboe wrote:
> > 
> > This fixes it by using the passed in page writeback count, instead of
> > doing MAX_WRITEBACK_PAGES batches, which gets us much better performance
> > (Jan reports it's up from ~400KB/sec to 10MB/sec) and makes sync(1)
> > finish properly even when new pages are being dirted.
> 
> This seems broken.
> 
> The whole point of MAX_WRITEBACK_PAGES was to make sure that we don't 
> generate a single IO bigger than a couple of MB. And then we have that 
> loop around things to do multiple chunks. Your change to use nr_pages 
> seems to make the whole looping totally pointless, and breaks that "don't 
> do huge hunks" logic.
> 
> So I don't think that your patch is correct.
> 
> That said, I _do_ believe you when you say it makes a difference, which 
> makes me think there is a bug there. I just don't think you fixed the 
> right bug, and your change just happens to do what you wanted by pure 
> random luck.
  A few points to this:
Before Jens rewritten the writeback code to use per-bdi flusher threads
MAX_WRITEBACK_PAGES applied only to writeback done by pdflush and kupdate.
So for example sync used .nr_pages like in the suggested patch. So Jens'
patch was just trying to get back to the old behavior...

Personally, I don't see why VM shouldn't generate IO from a single inode
larger than a few MB for data integrity syncs. There are two reasons I know
about for MAX_WRITEBACK_PAGES:
 a) avoid livelocking of writeout when the file is continuously grown
    (even nastier is when the file is sparse and huge and the writer just
    fills the huge hole with data gradually)
 b) avoid holding I_SYNC for too long because that could block tasks being
    write-throttled.

I find a) a valid reason but MAX_WRITEBACK_PAGES workarounds the livelock
only for background writeback where we cycle through all inodes and do not
care whether we ever make the inode clean. Limiting data integrity
writeback to MAX_WRITEBACK_PAGES just makes things *worse* because you give
processes more time to generate new dirty pages. Using dirtied_when does
not solve this because the inode dirty timestamp is updated only at
clean->dirty transition but inode never gets clean.

I don't think b) is a very valid reason anymore. Currently, throttled task
writes all inodes from the BDI and the I_SYNC locked inode is just skipped.
It can only be a problem when that inode would be the only one with big
enough amount of dirty data. Then the throttled thread will only exit
balance_dirty_pages as soon as the amount of dirty data at that BDI drops
below the BDI dirty threshold.

> The _real_ bug seems to bethe one you mentioned, but then ignored:
> 
> > Instead of flushing everything older than the sync run, it will do 
> > chunks of normal MAX_WRITEBACK_PAGES writeback and restart over and 
> > over.
> 
> and it would seem that the _logical_ way to fix it would be something like 
> the appended...
> 
> Hmm? Even when you do a 'fdatasync()', it's not going to guarantee that 
> any _future_ data is written back, so the 'oldest_jif' thing would seem to 
> be sane regardless of sync mode.
> 
>   NOTE NOTE NOTE! I do have to admit that this patch scares me, because 
>   there could be some bug in the 'older_than_this' logic that means that 
>   somebody sets it even if the inode is already dirty. So this patch makes 
>   conceptual sense to me, and I think it's the right thing to do, but I 
>   also suspect that we do not actually have a lot of test coverage of the 
>   whole 'older_than_this' logic, because it historically has been just a
>   small optimization for kupdated.
A similar logic to what you are suggesting is actually already there.  See
'start' variable in writeback_inodes_wb(). It was there exactly to avoid
sync(1) livelocks but it is assuming that writeback_inodes_wb() handles all
the IO for the sync. Not that it is called just to write
MAX_WRITEBACK_PAGES. So the only danger of your patch using older_than_this
would be that the ordering on wb->b_dirty list isn't always by dirty time.

But as I wrote above the main problem I see in your patch is that it does
not avoid all the cases of livelocks.


								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
