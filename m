Return-Path: <linux-kernel-owner+w=401wt.eu-S934216AbXLTOYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934216AbXLTOYc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 09:24:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932934AbXLTOM0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 09:12:26 -0500
Received: from mail.gmx.net ([213.165.64.20]:43862 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932891AbXLTOMX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 09:12:23 -0500
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX19TFr18PmNTjlmbErLaOWPSZ3oskGAbzkLhFQUFfd
	HyW8OX9fFK5m4H
Date: Thu, 20 Dec 2007 15:12:17 +0100
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Krzysztof Oledzki <olel@ans.pl>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Osterried <osterried@jesse.de>, protasnb@gmail.com,
       bugme-daemon@bugzilla.kernel.org
Subject: Re: [Bug 9182] Critical memory leak (dirty pages)
Message-ID: <20071220141217.GA4745@atjola.homenet>
References: <20071215221935.306A5108068@picon.linux-foundation.org> <Pine.LNX.4.64.0712152358240.14491@bizon.gios.gov.pl> <20071215203539.d6f71e96.akpm@linux-foundation.org> <Pine.LNX.4.64.0712161016290.25065@bizon.gios.gov.pl> <20071216015112.d0ab08a1.akpm@linux-foundation.org> <Pine.LNX.4.64.0712161440030.25065@bizon.gios.gov.pl> <alpine.LFD.0.9999.0712190903350.21557@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.0.9999.0712190903350.21557@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007.12.19 09:44:50 -0800, Linus Torvalds wrote:
> 
> 
> On Sun, 16 Dec 2007, Krzysztof Oledzki wrote:
> > 
> > I'll confirm this tomorrow but it seems that even switching to data=ordered
> > (AFAIK default o ext3) is indeed enough to cure this problem.
> 
> Ok, do we actually have any ext3 expert following this? I have no idea 
> about what the journalling code does, but I have painful memories of ext3 
> doing really odd buffer-head-based IO and totally bypassing all the normal 
> page dirty logic.
> 
> Judging by the symptoms (sorry for not following this well, it came up 
> while I was mostly away travelling), something probably *does* clear the 
> dirty bit on the pages, but the dirty *accounting* is not done properly, 
> so the kernel keeps thinking it has dirty pages.
> 
> Now, a simple "grep" shows that ext3 does not actually do any 
> ClearPageDirty() or similar on its own, although maybe I missed some other 
> subtle way this can happen. And the *normal* VFS routines that do 
> ClearPageDirty should all be doing the proper accounting.
> 
> So I see a couple of possible cases:
> 
>  - actually clearing the PG_dirty bit somehow, without doing the 
>    accounting.
> 
>    This looks very unlikely. PG_dirty is always cleared by some variant of 
>    "*ClearPageDirty()", and that bit definition isn't used for anything 
>    else in the whole kernel judging by "grep" (the page allocator tests 
>    the bit, that's it).

OK, so I looked for PG_dirty anyway.

In 46d2277c796f9f4937bfa668c40b2e3f43e93dd0 you made try_to_free_buffers
bail out if the page is dirty.

Then in 3e67c0987d7567ad666641164a153dca9a43b11d, Andrew fixed
truncate_complete_page, because it called cancel_dirty_page (and thus
cleared PG_dirty) after try_to_free_buffers was called via
do_invalidatepage.

Now, if I'm not mistaken, we can end up as follows.

truncate_complete_page()
  cancel_dirty_page() // PG_dirty cleared, decr. dirty pages
  do_invalidatepage()
    ext3_invalidatepage()
      journal_invalidatepage()
        journal_unmap_buffer()
          __dispose_buffer()
            __journal_unfile_buffer()
              __journal_temp_unlink_buffer()
                mark_buffer_dirty(); // PG_dirty set, incr. dirty pages

If journal_unmap_buffer then returns 0, try_to_free_buffers is not
called and neither is cancel_dirty_page, so the dirty pages accounting
is not decreased again.

As try_to_free_buffers got its ext3 hack back in
ecdfc9787fe527491baefc22dce8b2dbd5b2908d, maybe
3e67c0987d7567ad666641164a153dca9a43b11d should be reverted? (Except for
the accounting fix in cancel_dirty_page, of course).


On a side note, before 8368e328dfe1c534957051333a87b3210a12743b the task
io accounting for cancelled writes happened always happened if the page
was dirty, regardless of page->mapping. This was also already true for
the old test_clear_page_dirty code, and the commit log for
8368e328dfe1c534957051333a87b3210a12743b doesn't mention that semantic
change either, so maybe the "if (account_size)" block should be moved
out of the if "(mapping && ...)" block?

Björn - not sending patches because he needs sleep and wouldn't have a
        damn clue about what to write as a commit message anyway
