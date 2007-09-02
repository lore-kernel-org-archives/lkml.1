Return-Path: <linux-kernel-owner+w=401wt.eu-S933673AbXIBOSN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933673AbXIBOSN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 10:18:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756770AbXIBOR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 10:17:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57473 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755507AbXIBOR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 10:17:57 -0400
Date: Sun, 2 Sep 2007 16:17:56 +0200
From: Nick Piggin <npiggin@suse.de>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Jason Lunz <lunz@falooley.org>, lkml <linux-kernel@vger.kernel.org>,
       jffs-dev@axis.com, Hugh Dickins <hugh@veritas.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [jffs2] [rfc] fix write deadlock regression
Message-ID: <20070902141756.GC20902@wotan.suse.de>
References: <20070830182354.GA25077@falooley.org> <20070831212636.GB12868@falooley.org> <20070901190602.GA5926@falooley.org> <20070902042012.GA5864@wotan.suse.de> <1188735203.3834.16.camel@shinybook.infradead.org> <20070902132034.GA20902@wotan.suse.de> <1188740884.3834.22.camel@shinybook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1188740884.3834.22.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 02, 2007 at 02:48:04PM +0100, David Woodhouse wrote:
> On Sun, 2007-09-02 at 15:20 +0200, Nick Piggin wrote:
> > OK, but then hasn't the patch just made the deadlock harder to hit,
> > or is there some invariant that says that readpage() will never be
> > invoked if gc was invoked on the same page as we're commit_write()ing?
> 
> > The Q/A comments aren't very sure about this. I guess from the look
> > of it, prepare_write/commit_write make sure the page will be uptodate
> > by the start of commit_write, 
> 
> That's the intention, yes.
> 
> > and you avoid GCing the page in
> > prepare_write because your new page won't have any nodes allocated
> > yet that can possibly be GCed?
> 
> We _might_ GC the page -- it might not be a new page; we might be
> overwriting it. But it's fine if we do. Actually it's slightly
> suboptimal because we'll write out the same data twice -- once in GC and
> then immediately afterward in the write which we were making space for.

But doesn't GC only happen in prepare_write in the case that the
i_size is being extended into a new page?

If you GC the page in prepare_write (when it may be potentially
!uptodate), then I'm sure you would get a deadlock when read_cache_page
finds it non-uptodate and locks it for readpage().


> But that's not the end of the world, and it's not very common.
> 
> > BTW. with write_begin/write_end, you get to control the page lock,
> > so for example if the readpage in prepare_write for partial writes
> > is *only* for the purpose of avoiding this deadlock later, you
> > could possibly avoid the RMW with the new aops. Maybe it would
> > help you with data nodes crossing page boundaries too...
> 
> I'll look at that; thanks.

OK. The patches are in -mm now, but could get in as early as 2.6.24.
If you have any suggestions about the form of the APIs, it would be
good to hear them.

  
> > OK, thanks for looking at it. If you'd care to pass it on to Linus
> > before he releases 2.6.23 in random() % X days time... ;)
> 
> Not before the Kernel Summit now, I suspect. But yes, I'll do that later
> today or in the morning (the linuxconf.eu conference has already
> started).

Thanks,
