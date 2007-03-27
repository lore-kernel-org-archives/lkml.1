Return-Path: <linux-kernel-owner+w=401wt.eu-S1753232AbXC0G4K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232AbXC0G4K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 02:56:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753289AbXC0G4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 02:56:09 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:41280 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232AbXC0G4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 02:56:08 -0400
To: akpm@linux-foundation.org
CC: a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-reply-to: <20070326153153.817b6a82.akpm@linux-foundation.org> (message from
	Andrew Morton on Mon, 26 Mar 2007 15:31:53 -0700)
Subject: Re: [patch resend v4] update ctime and mtime for mmaped write
References: <E1HVZyn-0008T8-00@dorka.pomaz.szeredi.hu>
	<20070326140036.f3352f81.akpm@linux-foundation.org>
	<E1HVwy4-0002UD-00@dorka.pomaz.szeredi.hu> <20070326153153.817b6a82.akpm@linux-foundation.org>
Message-Id: <E1HW5am-0003Mc-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 27 Mar 2007 08:55:40 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > This patch makes writing to shared memory mappings update st_ctime and
> > > > st_mtime as defined by SUSv3:
> > > 
> > > Boy this is complicated.
> > 
> > You tell me?
> > 
> > > Is there a simpler way of doing all this?  Say, we define a new page flag
> > > PG_dirtiedbywrite and we do SetPageDirtiedByWrite() inside write() and
> > > ClearPageDirtiedByWrite() whenever we propagate pte-dirtiness into
> > > page-dirtiness.  Then, when performing writeback we look to see if any of
> > > the dirty pages are !PageDirtiedByWrite() and, if so, we update [mc]time to
> > > current-time.
> > 
> > I don't think a page flag gains anything over the address_space flag
> > that this patch already has.
> > 
> > The complexity is not about keeping track of the "data modified
> > through mmap" state, but about msync() guarantees, that POSIX wants.
> > 
> > And these requirements do in fact make some sense: msync() basically
> > means:
> > 
> >   "I want the data written through mmaps to be visible to the world"
> > 
> > And that obviously includes updating the timestamps.
> > 
> > So how do we know if the data was modified between two msync()
> > invocations?  The only sane way I can think of is to walk the page
> > tables in msync() and test/clear the pte dirty bit.
> 
> clear_page_dirty_for_io() already does that.
> 
> So we should be able to test PageDirtiedByWrite() after running
> clear_page_dirty_for_io() to discover whether this page was dirtied via
> MAP_SHARED, and then update the inode times if so.

What do you need the page flag for?  The "modified through mmap" info
is there in the ptes.  And from the ptes it can be transfered to a
per-address_space flag.  Nobody is interested through which page was
the file modified.

Anyway, that's just MS_SYNC.  MS_ASYNC doesn't walk the pages, yet it
should update the timestamp.  That's the difficult one.

Miklos
