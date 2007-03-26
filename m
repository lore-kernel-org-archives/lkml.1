Return-Path: <linux-kernel-owner+w=401wt.eu-S933368AbXCZWcB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933368AbXCZWcB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 18:32:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933408AbXCZWcB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 18:32:01 -0400
Received: from smtp.osdl.org ([65.172.181.24]:55941 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933368AbXCZWcA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 18:32:00 -0400
Date: Mon, 26 Mar 2007 15:31:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch resend v4] update ctime and mtime for mmaped write
Message-Id: <20070326153153.817b6a82.akpm@linux-foundation.org>
In-Reply-To: <E1HVwy4-0002UD-00@dorka.pomaz.szeredi.hu>
References: <E1HVZyn-0008T8-00@dorka.pomaz.szeredi.hu>
	<20070326140036.f3352f81.akpm@linux-foundation.org>
	<E1HVwy4-0002UD-00@dorka.pomaz.szeredi.hu>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Mar 2007 23:43:08 +0200
Miklos Szeredi <miklos@szeredi.hu> wrote:

> > > This patch makes writing to shared memory mappings update st_ctime and
> > > st_mtime as defined by SUSv3:
> > 
> > Boy this is complicated.
> 
> You tell me?
> 
> > Is there a simpler way of doing all this?  Say, we define a new page flag
> > PG_dirtiedbywrite and we do SetPageDirtiedByWrite() inside write() and
> > ClearPageDirtiedByWrite() whenever we propagate pte-dirtiness into
> > page-dirtiness.  Then, when performing writeback we look to see if any of
> > the dirty pages are !PageDirtiedByWrite() and, if so, we update [mc]time to
> > current-time.
> 
> I don't think a page flag gains anything over the address_space flag
> that this patch already has.
> 
> The complexity is not about keeping track of the "data modified
> through mmap" state, but about msync() guarantees, that POSIX wants.
> 
> And these requirements do in fact make some sense: msync() basically
> means:
> 
>   "I want the data written through mmaps to be visible to the world"
> 
> And that obviously includes updating the timestamps.
> 
> So how do we know if the data was modified between two msync()
> invocations?  The only sane way I can think of is to walk the page
> tables in msync() and test/clear the pte dirty bit.

clear_page_dirty_for_io() already does that.

So we should be able to test PageDirtiedByWrite() after running
clear_page_dirty_for_io() to discover whether this page was dirtied via
MAP_SHARED, and then update the inode times if so.

