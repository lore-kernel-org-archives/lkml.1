Return-Path: <linux-kernel-owner+w=401wt.eu-S937138AbXLTR0H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937138AbXLTR0H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 12:26:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932188AbXLTRZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 12:25:54 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:45229 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932098AbXLTRZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 12:25:53 -0500
Date: Thu, 20 Dec 2007 18:25:51 +0100
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Bj?rn Steinbrink <B.Steinbrink@gmx.de>, Krzysztof Oledzki <olel@ans.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Osterried <osterried@jesse.de>, protasnb@gmail.com,
       bugme-daemon@bugzilla.kernel.org
Subject: Re: [Bug 9182] Critical memory leak (dirty pages)
Message-ID: <20071220172551.GE764@atrey.karlin.mff.cuni.cz>
References: <20071215221935.306A5108068@picon.linux-foundation.org> <Pine.LNX.4.64.0712152358240.14491@bizon.gios.gov.pl> <20071215203539.d6f71e96.akpm@linux-foundation.org> <Pine.LNX.4.64.0712161016290.25065@bizon.gios.gov.pl> <20071216015112.d0ab08a1.akpm@linux-foundation.org> <Pine.LNX.4.64.0712161440030.25065@bizon.gios.gov.pl> <alpine.LFD.0.9999.0712190903350.21557@woody.linux-foundation.org> <20071220141217.GA4745@atjola.homenet> <alpine.LFD.0.9999.0712200753040.21557@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.9999.0712200753040.21557@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 20 Dec 2007, Bj?rn Steinbrink wrote:
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
> 
> Good, this seems to be the exact path that actually triggers it. I got to 
> journal_unmap_buffer(), but was too lazy to actually then bother to follow 
> it all the way down - I decided that I didn't actually really even care 
> what the low-level FS layer did, I had already convinced myself that it 
> obviously must be dirtying the page some way, since that matched the 
> symptoms exactly (ie only the journaling case was impacted, and this was 
> all about the journal).
> 
> But perhaps more importantly: regardless of what the low-level filesystem 
> did at that point, the VM accounting shouldn't care, and should be robust 
> in the face of a low-level filesystem doing strange and wonderful things. 
> But thanks for bothering to go through the whole history and figure out 
> what exactly is up.
  As I wrote in my previous email, this solution works but hides the
fact that the page really *has* dirty data in it and *is* pinned in memory
until the commit code gets to writing it. So in theory it could disturb
the writeout logic by having more dirty data in memory than vm thinks it
has. Not that I'd have a better fix now but I wanted to point out this
problem.

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
