Return-Path: <linux-kernel-owner+w=401wt.eu-S1753859AbYIWXMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859AbYIWXMm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 19:12:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751751AbYIWXMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 19:12:34 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52484 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388AbYIWXMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 19:12:33 -0400
Date: Tue, 23 Sep 2008 19:11:51 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org, agk@redhat.com,
       mbroz@redhat.com, chris@arachsys.com
Subject: Re: [PATCH] Memory management livelock
In-Reply-To: <20080923154905.50d4b0fa.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0809231902010.19496@hs20-bc2-1.build.redhat.com>
References: <20080911101616.GA24064@agk.fab.redhat.com>
 <Pine.LNX.4.64.0809221705480.15511@hs20-bc2-1.build.redhat.com>
 <Pine.LNX.4.64.0809231817390.11559@hs20-bc2-1.build.redhat.com>
 <20080923154905.50d4b0fa.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 23 Sep 2008, Andrew Morton wrote:

> On Tue, 23 Sep 2008 18:34:20 -0400 (EDT)
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
> > > On Mon, 22 Sep 2008 17:10:04 -0400 (EDT)
> > > Mikulas Patocka <mpatocka@xxxxxxxxxx> wrote:
> > > 
> > > > The bug happens when one process is doing sequential buffered writes to
> > > > a block device (or file) and another process is attempting to execute
> > > > sync(), fsync() or direct-IO on that device (or file). This syncing
> > > > process will wait indefinitelly, until the first writing process
> > > > finishes.
> > > >
> > > > For example, run these two commands:
> > > > dd if=/dev/zero of=/dev/sda1 bs=65536 &
> > > > dd if=/dev/sda1 of=/dev/null bs=4096 count=1 iflag=direct
> > > >
> > > > The bug is caused by sequential walking of address space in
> > > > write_cache_pages and wait_on_page_writeback_range: if some other
> > > > process is constantly making dirty and writeback pages while these
> > > > functions run, the functions will wait on every new page, resulting in
> > > > indefinite wait.
> > > 
> > > Shouldn't happen. All the data-syncing functions should have an upper
> > > bound on the number of pages which they attempt to write. In the
> > > example above, we end up in here:
> > > 
> > > int __filemap_fdatawrite_range(struct address_space *mapping, loff_t
> > > start,
> > > loff_t end, int sync_mode)
> > > {
> > > int ret;
> > > struct writeback_control wbc = {
> > > .sync_mode = sync_mode,
> > > .nr_to_write = mapping->nrpages * 2, <<--
> > > .range_start = start,
> > > .range_end = end,
> > > };
> > > 
> > > so generic_file_direct_write()'s filemap_write_and_wait() will attempt
> > > to write at most 2* the number of pages which are in cache for that inode.
> > 
> > See write_cache_pages:
> > 
> > if (wbc->sync_mode != WB_SYNC_NONE)
> >         wait_on_page_writeback(page);	(1)
> > if (PageWriteback(page) ||
> >     !clear_page_dirty_for_io(page)) {
> >         unlock_page(page);		(2)
> >         continue;
> > }
> > ret = (*writepage)(page, wbc, data);
> > if (unlikely(ret == AOP_WRITEPAGE_ACTIVATE)) {
> >         unlock_page(page);
> >         ret = 0;
> > }
> > if (ret || (--(wbc->nr_to_write) <= 0))
> >         done = 1;
> > 
> > --- so if it goes by points (1) and (2), the counter is not decremented, 
> > yet the function waits for the page. If there is constant stream of 
> > writeback pages being generated, it waits on each on them --- that is, 
> > forever. I have seen livelock in this function. For you that example with 
> > two dd's, one buffered write and the other directIO read doesn't work? For 
> > me it livelocks here.
> > 
> > wait_on_page_writeback_range is another example where the livelock 
> > happened, there is no protection at all against starvation.
> 
> um, OK.  So someone else is initiating IO for this inode and this
> thread *never* gets to initiate any writeback.  That's a bit of a
> surprise.
> 
> How do we fix that?  Maybe decrement nt_to_write for these pages as
> well?

And what do you want to do with wait_on_page_writeback_range? When I 
solved that livelock in write_cache_pages(), I got another livelock in 
wait_on_page_writeback_range.

> > BTW. that .nr_to_write = mapping->nrpages * 2 looks like a dangerous thing 
> > to me.
> > 
> > Imagine this case: You have two pages with indices 4 and 5 dirty in a 
> > file. You call fsync(). It sets nr_to_write to 4.
> > 
> > Meanwhile, another process makes pages 0, 1, 2, 3 dirty.
> > 
> > The fsync() process goes to write_cache_pages, writes the first 4 dirty 
> > pages and exits because it goes over the limit.
> > 
> > result --- you violate fsync() semantics, pages that were dirty before 
> > call to fsync() are not written when fsync() exits.
> 
> yup, that's pretty much unfixable, really, unless new locks are added
> which block threads which are writing to unrelated sections of the
> file, and that could hurt some workloads quite a lot, I expect.

It is fixable with the patch I sent --- it doesn't take any locks unless 
the starvation happens. Then, you don't have to use .nr_to_write for 
fsync anymore.

Another solution could be to record in page structure jiffies when the 
page entered dirty state and writeback state. The start writeback/wait on 
writeback functions could then trivially ignore pages that were 
dirtied/writebacked while the function was in progress.

> Hopefully high performance applications are instantiating the file
> up-front and are using sync_file_range() to prevent these sorts of
> things from happening.  But they probably aren't.

--- for databases it is pretty much possible that one thread is writing 
already journaled data (so it doesn't care when the data are really 
written) and another thread is calling fsync() on the same inode 
simultaneously --- so fsync() could mistakenly write the data generated by 
the first thread and ignore the data generated by the second thread, that 
it should really write.

Mikulas
