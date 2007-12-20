Return-Path: <linux-kernel-owner+w=401wt.eu-S1758636AbXLTBTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758636AbXLTBTd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 20:19:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752944AbXLTBT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 20:19:26 -0500
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:35204 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751339AbXLTBTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 20:19:25 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=VR7MCfG1IfQUfoi8YGMEC9VyqiX8h2vFm6mkgGgMnLgm88qAzISDvjRNWoyd8dA5scxkUGlu4MPMWDLLUD9tERWagPx3osXpYe6fDGF64+lNlOqotxoQdP6e/srWn1q+6QjwuL2S4kf4Dm7TPW9WXTTG3dNUoAsAfDenRWQzSsU=  ;
X-YMail-OSG: oQXb1dMVM1l0ZJpHZ6UdNZxNGJ7k4i73L_e4wlUXtNYOG1qjikukpFpJpcPWoCziIwk5lTrEJA--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Jan Kara <jack@suse.cz>
Subject: Re: [Bug 9182] Critical memory leak (dirty pages)
Date: Thu, 20 Dec 2007 12:19:13 +1100
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Krzysztof Oledzki <olel@ans.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Osterried <osterried@jesse.de>, protasnb@gmail.com,
       bugme-daemon@bugzilla.kernel.org
References: <20071215221935.306A5108068@picon.linux-foundation.org> <alpine.LFD.0.9999.0712190903350.21557@woody.linux-foundation.org> <20071220010508.GA19332@atrey.karlin.mff.cuni.cz>
In-Reply-To: <20071220010508.GA19332@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712201219.13873.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 December 2007 12:05, Jan Kara wrote:
> > On Sun, 16 Dec 2007, Krzysztof Oledzki wrote:
> > > I'll confirm this tomorrow but it seems that even switching to
> > > data=ordered (AFAIK default o ext3) is indeed enough to cure this
> > > problem.
> >
> > Ok, do we actually have any ext3 expert following this? I have no idea
> > about what the journalling code does, but I have painful memories of ext3
> > doing really odd buffer-head-based IO and totally bypassing all the
> > normal page dirty logic.
> >
> > Judging by the symptoms (sorry for not following this well, it came up
> > while I was mostly away travelling), something probably *does* clear the
> > dirty bit on the pages, but the dirty *accounting* is not done properly,
> > so the kernel keeps thinking it has dirty pages.
> >
> > Now, a simple "grep" shows that ext3 does not actually do any
> > ClearPageDirty() or similar on its own, although maybe I missed some
> > other subtle way this can happen. And the *normal* VFS routines that do
> > ClearPageDirty should all be doing the proper accounting.
> >
> > So I see a couple of possible cases:
> >
> >  - actually clearing the PG_dirty bit somehow, without doing the
> >    accounting.
> >
> >    This looks very unlikely. PG_dirty is always cleared by some variant
> > of "*ClearPageDirty()", and that bit definition isn't used for anything
> > else in the whole kernel judging by "grep" (the page allocator tests the
> > bit, that's it).
> >
> >    And there aren't that many hits for ClearPageDirty, and they all seem
> >    to do the proper "dec_zone_page_state(page, NR_FILE_DIRTY);" etc if
> > the mapping has dirty state accounting.
> >
> >    The exceptions seem to be:
> >     - the page freeing path, but that path checks that "mapping" is NULL
> >       (so no accounting), and would complain loudly if it wasn't
> >     - the swap state stuff ("move_from_swap_cache()"), but that should
> >       only ever trigger for swap cache pages (we have a BUG_ON() in that
> >       path), and those don't do dirty accounting anyway.
> >     - pageout(), but again only for pages that have a NULL mapping.
> >
> >  - ext3 might be clearing (probably indirectly) the "page->mapping" thing
> >    or similar, which in turn will make the VFS think that even a dirty
> >    page isn't actually to be accounted for - so when the page *turned*
> >    dirty, it was accounted as a dirty page, but then, when it was
> > cleaned, the accounting wasn't reversed because ->mapping had become
> > NULL.
> >
> >    This would be some interaction with the truncation logic, and quite
> >    frankly, that should be all shared with the non-journal case, so I
> > find this all very unlikely.
> >
> > However, that second case is interesting, because the pageout case
> > actually has a comment like this:
> >
> > 	/*
> > 	 * Some data journaling orphaned pages can have
> > 	 * page->mapping == NULL while being dirty with clean buffers.
> > 	 */
> >
> > which really sounds like the case in question.
> >
> > I may know the VM, but that special case was added due to insane
> > journaling filesystems, and I don't know what insane things they do.
> > Which is why I'm wondering if there is any ext3 person who knows the
> > journaling code?
>
>   Yes, I'm looking into the problem... I think those orphan pages
> without mapping are created because we cannot drop truncated
> buffers/pages immediately.  There can be a committing transaction that
> still needs the data in those buffers and until it commits we have to
> keep the pages (and even maybe write them to disk etc.). But eventually,
> we should write the buffers, call try_to_free_buffers() which calls
> cancel_dirty_page() and everything should be happy... in theory ;)

If mapping is NULL, then try_to_free_buffers won't call cancel_dirty_page,
I think?

I don't know whether ext3 can be changed to not require/allow these dirty
pages, but I would rather Linus's dirty page accounting fix to go into that
path (the /* can this still happen? */ in try_to_free_buffers()), if possible.

Then you could also have a WARN_ON in __remove_from_page_cache().
