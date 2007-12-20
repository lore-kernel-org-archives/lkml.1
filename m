Return-Path: <linux-kernel-owner+w=401wt.eu-S935777AbXLTQFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935777AbXLTQFf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 11:05:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757941AbXLTQF1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 11:05:27 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:43385 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758729AbXLTQF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 11:05:26 -0500
Date: Thu, 20 Dec 2007 17:05:24 +0100
From: Jan Kara <jack@suse.cz>
To: Bj?rn Steinbrink <B.Steinbrink@gmx.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Krzysztof Oledzki <olel@ans.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Osterried <osterried@jesse.de>, protasnb@gmail.com,
       bugme-daemon@bugzilla.kernel.org
Subject: Re: [Bug 9182] Critical memory leak (dirty pages)
Message-ID: <20071220160524.GC764@atrey.karlin.mff.cuni.cz>
References: <20071215221935.306A5108068@picon.linux-foundation.org> <Pine.LNX.4.64.0712152358240.14491@bizon.gios.gov.pl> <20071215203539.d6f71e96.akpm@linux-foundation.org> <Pine.LNX.4.64.0712161016290.25065@bizon.gios.gov.pl> <20071216015112.d0ab08a1.akpm@linux-foundation.org> <Pine.LNX.4.64.0712161440030.25065@bizon.gios.gov.pl> <alpine.LFD.0.9999.0712190903350.21557@woody.linux-foundation.org> <20071220141217.GA4745@atjola.homenet> <20071220150453.GB764@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071220150453.GB764@atrey.karlin.mff.cuni.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > On 2007.12.19 09:44:50 -0800, Linus Torvalds wrote:
> > > 
> > > 
> > > On Sun, 16 Dec 2007, Krzysztof Oledzki wrote:
> > > > 
> > > > I'll confirm this tomorrow but it seems that even switching to data=ordered
> > > > (AFAIK default o ext3) is indeed enough to cure this problem.
> > > 
> > > Ok, do we actually have any ext3 expert following this? I have no idea 
> > > about what the journalling code does, but I have painful memories of ext3 
> > > doing really odd buffer-head-based IO and totally bypassing all the normal 
> > > page dirty logic.
> > > 
> > > Judging by the symptoms (sorry for not following this well, it came up 
> > > while I was mostly away travelling), something probably *does* clear the 
> > > dirty bit on the pages, but the dirty *accounting* is not done properly, 
> > > so the kernel keeps thinking it has dirty pages.
> > > 
> > > Now, a simple "grep" shows that ext3 does not actually do any 
> > > ClearPageDirty() or similar on its own, although maybe I missed some other 
> > > subtle way this can happen. And the *normal* VFS routines that do 
> > > ClearPageDirty should all be doing the proper accounting.
> > > 
> > > So I see a couple of possible cases:
> > > 
> > >  - actually clearing the PG_dirty bit somehow, without doing the 
> > >    accounting.
> > > 
> > >    This looks very unlikely. PG_dirty is always cleared by some variant of 
> > >    "*ClearPageDirty()", and that bit definition isn't used for anything 
> > >    else in the whole kernel judging by "grep" (the page allocator tests 
> > >    the bit, that's it).
> > 
> > OK, so I looked for PG_dirty anyway.
> > 
> > In 46d2277c796f9f4937bfa668c40b2e3f43e93dd0 you made try_to_free_buffers
> > bail out if the page is dirty.
> > 
> > Then in 3e67c0987d7567ad666641164a153dca9a43b11d, Andrew fixed
> > truncate_complete_page, because it called cancel_dirty_page (and thus
> > cleared PG_dirty) after try_to_free_buffers was called via
> > do_invalidatepage.
> > 
> > Now, if I'm not mistaken, we can end up as follows.
> > 
> > truncate_complete_page()
> >   cancel_dirty_page() // PG_dirty cleared, decr. dirty pages
> >   do_invalidatepage()
> >     ext3_invalidatepage()
> >       journal_invalidatepage()
> >         journal_unmap_buffer()
> >           __dispose_buffer()
> >             __journal_unfile_buffer()
> >               __journal_temp_unlink_buffer()
> >                 mark_buffer_dirty(); // PG_dirty set, incr. dirty pages
> > 
> > If journal_unmap_buffer then returns 0, try_to_free_buffers is not
> > called and neither is cancel_dirty_page, so the dirty pages accounting
> > is not decreased again.
>   Yes, this can happen. The call to mark_buffer_dirty() is a fallout
> from journal_unfile_buffer() trying to sychronise JBD private dirty bit
> (jbddirty) with the standard dirty bit. We could actually clear the
> jbddirty bit before calling journal_unfile_buffer() so that this doesn't
> happen but since Linus changed remove_from_pagecache() to not care about
> redirtying the page I guess it's not needed any more...
  Oops, sorry, I spoke to soon. After thinking more about it, I think we
cannot clear the dirty bit (at least not jbddirty) in all cases and in
fact moving cancel_dirty_page() after do_invalidatepage() call only
hides the real problem.
  Let's recap what JBD/ext3 code requires in case of truncation.  A
life-cycle of a journaled buffer looks as follows: When we want to write
some data to it, it gets attached to the running transaction. When the
transaction is committing, the buffer is written to the journal.
Sometime later, the buffer is written to it's final place in the
filesystem - this is called checkpoint - and can be released.
  Now suppose a write to the buffer happens in one transaction and you
truncate the buffer in the next one. You cannot just free the buffer
immediately - it can for example happen, that the transaction in which
the write happened hasn't committed yet. So we just leave the dirty
buffer there and it should be cleaned up later when the committing
transaction writes the data where it needs...
  The problem is that when the commit code writes the buffer, it
eventually calls try_to_free_buffers() but as Nick pointed out,
->mapping is set to NULL by that time so we don't even call
cancel_dirty_page() and so the number of dirty pages is not properly
decreased. Of course, we could decrease the number of dirty pages after
we return from do_invalidatepage when clearing ->mapping but that would
make dirty accounting imprecise - we really still have those dirty data
which need writeout. But it's probably the best workaround I can
currently think of.

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
