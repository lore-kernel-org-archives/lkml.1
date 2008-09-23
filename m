Return-Path: <linux-kernel-owner+w=401wt.eu-S1755183AbYIWWep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183AbYIWWep (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 18:34:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751205AbYIWWeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 18:34:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43009 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958AbYIWWef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 18:34:35 -0400
Date: Tue, 23 Sep 2008 18:34:20 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-mm@vger.kernel.org
cc: Alasdair G Kergon <agk@redhat.com>, Milan Broz <mbroz@redhat.com>,
       Chris Webb <chris@arachsys.com>
Subject: Re: [PATCH] Memory management livelock
In-Reply-To: <Pine.LNX.4.64.0809221705480.15511@hs20-bc2-1.build.redhat.com>
Message-ID: <Pine.LNX.4.64.0809231817390.11559@hs20-bc2-1.build.redhat.com>
References: <20080911101616.GA24064@agk.fab.redhat.com>
 <Pine.LNX.4.64.0809221705480.15511@hs20-bc2-1.build.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 22 Sep 2008 17:10:04 -0400 (EDT)
> Mikulas Patocka <mpatocka@xxxxxxxxxx> wrote:
> 
> > The bug happens when one process is doing sequential buffered writes to
> > a block device (or file) and another process is attempting to execute
> > sync(), fsync() or direct-IO on that device (or file). This syncing
> > process will wait indefinitelly, until the first writing process
> > finishes.
> >
> > For example, run these two commands:
> > dd if=/dev/zero of=/dev/sda1 bs=65536 &
> > dd if=/dev/sda1 of=/dev/null bs=4096 count=1 iflag=direct
> >
> > The bug is caused by sequential walking of address space in
> > write_cache_pages and wait_on_page_writeback_range: if some other
> > process is constantly making dirty and writeback pages while these
> > functions run, the functions will wait on every new page, resulting in
> > indefinite wait.
> 
> Shouldn't happen. All the data-syncing functions should have an upper
> bound on the number of pages which they attempt to write. In the
> example above, we end up in here:
> 
> int __filemap_fdatawrite_range(struct address_space *mapping, loff_t
> start,
> loff_t end, int sync_mode)
> {
> int ret;
> struct writeback_control wbc = {
> .sync_mode = sync_mode,
> .nr_to_write = mapping->nrpages * 2, <<--
> .range_start = start,
> .range_end = end,
> };
> 
> so generic_file_direct_write()'s filemap_write_and_wait() will attempt
> to write at most 2* the number of pages which are in cache for that inode.

See write_cache_pages:

if (wbc->sync_mode != WB_SYNC_NONE)
        wait_on_page_writeback(page);	(1)
if (PageWriteback(page) ||
    !clear_page_dirty_for_io(page)) {
        unlock_page(page);		(2)
        continue;
}
ret = (*writepage)(page, wbc, data);
if (unlikely(ret == AOP_WRITEPAGE_ACTIVATE)) {
        unlock_page(page);
        ret = 0;
}
if (ret || (--(wbc->nr_to_write) <= 0))
        done = 1;

--- so if it goes by points (1) and (2), the counter is not decremented, 
yet the function waits for the page. If there is constant stream of 
writeback pages being generated, it waits on each on them --- that is, 
forever. I have seen livelock in this function. For you that example with 
two dd's, one buffered write and the other directIO read doesn't work? For 
me it livelocks here.

wait_on_page_writeback_range is another example where the livelock 
happened, there is no protection at all against starvation.


BTW. that .nr_to_write = mapping->nrpages * 2 looks like a dangerous thing 
to me.

Imagine this case: You have two pages with indices 4 and 5 dirty in a 
file. You call fsync(). It sets nr_to_write to 4.

Meanwhile, another process makes pages 0, 1, 2, 3 dirty.

The fsync() process goes to write_cache_pages, writes the first 4 dirty 
pages and exits because it goes over the limit.

result --- you violate fsync() semantics, pages that were dirty before 
call to fsync() are not written when fsync() exits.

> I'd say that either a) that logic got broken or b) you didn't wait long
> enough, and we might need to do something to make it not wait so long.
> 
> But before we patch anything we should fully understand what is
> happening and why the current anti-livelock code isn't working in this
> case.

Mikulas
