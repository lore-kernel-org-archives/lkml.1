Return-Path: <linux-kernel-owner+w=401wt.eu-S1754005AbZBQKZD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005AbZBQKZD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 05:25:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752803AbZBQKYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 05:24:46 -0500
Received: from ns.suse.de ([195.135.220.2]:44756 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752708AbZBQKYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 05:24:45 -0500
Date: Tue, 17 Feb 2009 11:24:43 +0100
From: Nick Piggin <npiggin@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Edward Shishkin <edward.shishkin@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ryan Hope <rmh3093@gmail.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org,
       ReiserFS Mailing List <reiserfs-devel@vger.kernel.org>
Subject: Re: [patch 2/4] vfs: add set_page_dirty_notag
Message-ID: <20090217102443.GA26402@wotan.suse.de>
References: <18837.24581.181196.569183@edward.zelnet.ru> <1234530519.6519.46.camel@twins> <49957C43.7050701@gmail.com> <1234534150.6519.101.camel@twins> <18838.49922.215481.399653@edward.zelnet.ru> <1234645893.4695.8.camel@laptop> <18841.60432.329341.514726@edward.zelnet.ru> <1234861781.4744.21.camel@laptop> <20090217093805.GB31323@wotan.suse.de> <1234865116.4744.46.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234865116.4744.46.camel@laptop>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 17, 2009 at 11:05:16AM +0100, Peter Zijlstra wrote:
> On Tue, 2009-02-17 at 10:38 +0100, Nick Piggin wrote:
> 
> > It is a great shame that filesystems are not properly notified
> > that a page may become dirty before the actual set_page_dirty
> > event (which is not allowed to fail and is called after the
> > page is already dirty).
> 
> Not quite true, for example the set_page_dirty() done by the write fault
> code is done _before_ the page becomes dirty.
> 
> This before/after thing was the reason for that horrid file corruption
> bug that dragged on for a few weeks back in .19 (IIRC).

Yeah, there are actually races though. The page can become cleaned
before set_page_dirty is reached, and there are also nasty races with
truncate.

 
> > This is a big problem I have with fsblock simply in trying to
> > make the memory allocation robust. page_mkwrite unfortunately
> > is racy and I've fixed problems there... the big problem though
> > is get_user_pages. Fixing that properly seems to require fixing
> > callers so it is not really realistic in the short term.
> 
> Right, I'm just not sure what we can do, even with a
> prepage_page_dirty() function, what are you going to do, fail the fault?

Oh, for regular page fault functions using page_mkwrite, they
definitely want to fail the fault with a SIGBUS, and actually XFS
already does that (for fsblock robust memory allocations you
would also want to fail OOM on metadata allocation failure). What
is the other option? Silently fail the write?

For XFS purpose (ie. -ENOSPC handling), the current code is reasonable
although there could be some truncate races with block allocation. But
mostly probably works. For something like fsblock it can be much more
common to have the metadata refcount reach 0 and freed before spd is
called. In that case the code actually goes into a bug situation so it
is a bit more critical.

But no that's the "easy" part. The hard part is get_user_pages
because the caller can hold onto the page indefinitely simply with a
refcount, and go along happily dirtying it at any stage (actually
writing to the page memory) before actually calling set_page_dirty.

The "cleanest" way to fix this from VM point of view is probably to
force gup callers to hold the page locked for the duration to
prevent truncation or writeout after the filesystem notification.
Don't know if that would be very popular, however.
