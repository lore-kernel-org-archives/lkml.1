Return-Path: <linux-kernel-owner+w=401wt.eu-S966315AbXIBNUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966315AbXIBNUr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 09:20:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964828AbXIBNUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 09:20:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54397 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965090AbXIBNUh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 09:20:37 -0400
Date: Sun, 2 Sep 2007 15:20:34 +0200
From: Nick Piggin <npiggin@suse.de>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Jason Lunz <lunz@falooley.org>, lkml <linux-kernel@vger.kernel.org>,
       jffs-dev@axis.com, Hugh Dickins <hugh@veritas.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [jffs2] [rfc] fix write deadlock regression
Message-ID: <20070902132034.GA20902@wotan.suse.de>
References: <20070830182354.GA25077@falooley.org> <20070831212636.GB12868@falooley.org> <20070901190602.GA5926@falooley.org> <20070902042012.GA5864@wotan.suse.de> <1188735203.3834.16.camel@shinybook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1188735203.3834.16.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 02, 2007 at 01:13:23PM +0100, David Woodhouse wrote:
> Jason, thank you _so_ much for finding the underlying cause of this.
> 
> On Sun, 2007-09-02 at 06:20 +0200, Nick Piggin wrote:
> > Hmm, thanks for that. It does sound like it is deadlocking via
> > commit_write(). OTOH, it seems like it could be using the page
> > before it is uptodate -- it _may_ only be dealing with uptodate
> > data at that point... but if so, why even read_cache_page at
> > all?
> 
> jffs2_readpage() is synchronous -- there's no chance that the page won't
> be up to date. We're doing this for garbage collection -- if there are
> many log entries covering a single page of data, we want to write out a
> single replacement which covers the whole page, obsoleting the previous
> suboptimal representation of the same data.

OK, but then hasn't the patch just made the deadlock harder to hit,
or is there some invariant that says that readpage() will never be
invoked if gc was invoked on the same page as we're commit_write()ing?

The Q/A comments aren't very sure about this. I guess from the look
of it, prepare_write/commit_write make sure the page will be uptodate
by the start of commit_write, and you avoid GCing the page in
prepare_write because your new page won't have any nodes allocated
yet that can possibly be GCed?

BTW. with write_begin/write_end, you get to control the page lock,
so for example if the readpage in prepare_write for partial writes
is *only* for the purpose of avoiding this deadlock later, you
could possibly avoid the RMW with the new aops. Maybe it would
help you with data nodes crossing page boundaries too...
 

> > However, it is a regression. So unless David can come up with a
> > more satisfactory approach, I guess we'd have to go with your
> > patch. 
> 
> I think Jason's patch is the best answer for the moment. At some point
> in the very near future I want to improve the RAM usage and compression
> ratio by dropping the rule that data nodes may not cross page boundaries
> -- in which case garbage collection will need to do something other than
> reading the page using read_cache_page() and then writing it out again;
> it'll probably need to end up using its own internal buffer. But for
> now, Jason's patch looks good.

OK, thanks for looking at it. If you'd care to pass it on to Linus
before he releases 2.6.23 in random() % X days time... ;)

