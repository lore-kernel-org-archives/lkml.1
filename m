Return-Path: <linux-kernel-owner+w=401wt.eu-S1760135AbZCZSLX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760135AbZCZSLX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 14:11:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752855AbZCZSLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 14:11:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51697 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754529AbZCZSLM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 14:11:12 -0400
Date: Thu, 26 Mar 2009 19:11:06 +0100
From: Jan Kara <jack@suse.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>
Subject: Re: ext3 IO latency measurements (was: Linux 2.6.29)
Message-ID: <20090326181106.GC17159@duck.suse.cz>
References: <20090324041249.1133efb6.akpm@linux-foundation.org> <20090325123744.GK23439@duck.suse.cz> <20090325150041.GM32307@mit.edu> <alpine.LFD.2.00.0903251008120.3032@localhost.localdomain> <20090325185824.GO32307@mit.edu> <alpine.LFD.2.00.0903251341050.3032@localhost.localdomain> <20090325215137.GQ32307@mit.edu> <alpine.LFD.2.00.0903251613300.3032@localhost.localdomain> <20090325235041.GA11024@duck.suse.cz> <20090326090630.GA9369@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Qxx1br4bt0+wmkIi"
Content-Disposition: inline
In-Reply-To: <20090326090630.GA9369@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Qxx1br4bt0+wmkIi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu 26-03-09 10:06:30, Ingo Molnar wrote:
> 
> * Jan Kara <jack@suse.cz> wrote:
> 
> > > So tell me again how the VM can rely on the filesystem not 
> > > blocking at random points.
> >
> >   I can write a patch to make writepage() in the non-"mmapped 
> > creation" case non-blocking on journal. But I'll also have to find 
> > out whether it really helps something. But it's probably worth 
> > trying...
> 
> _all_ the problems i ever had with ext3 were 'collateral damage' 
> type of things: simple writes (sometimes even reads) getting 
> serialized on some large [but reasonable] dirtying activity 
> elsewhere - even if the system was still well within its 
> hard-dirty-limit threshold.
> 
> So it sure sounds like an area worth improving, and it's not that 
> hard to reproduce either. Take a system with enough RAM but only a 
> single disk, and do this in a kernel tree:
> 
>   sync
>   echo 3 > /proc/sys/vm/drop_caches
> 
>   while :; do
>     date
>     make mrproper      2>/dev/null >/dev/null
>     make defconfig     2>/dev/null >/dev/null
>     make -j32 bzImage  2>/dev/null >/dev/null
>   done &
  I've played with it a bit. I don't have a fast enough machine so that a
compile would feed my SATA drive fast enough (and I also have just 2 GB of
memory) but copying kernel tree there and back seemed to load it reasonably.
  I've tried a kernel with and without attached patch which makes writepage
not start a transaction when not needed.
 
> Plain old kernel build, no distcc and no icecream. Wait a few 
> minutes for the system to reach equilibrium. There's no tweaking 
> anywhere, kernel, distro and filesystem defaults used everywhere:
> 
>  aldebaran:/home/mingo/linux/linux> ./compile-test 
>  Thu Mar 26 10:33:03 CET 2009
>  Thu Mar 26 10:35:24 CET 2009
>  Thu Mar 26 10:36:48 CET 2009
>  Thu Mar 26 10:38:54 CET 2009
>  Thu Mar 26 10:41:22 CET 2009
>  Thu Mar 26 10:43:41 CET 2009
>  Thu Mar 26 10:46:02 CET 2009
>  Thu Mar 26 10:48:28 CET 2009
> 
> And try to use the system while this workload is going on. Use Vim 
> to edit files in this kernel tree. Use plain _cat_ - and i hit 
> delays all the time - and it's not the CPU scheduler but all IO 
> related.
  So I observed long delays when VIM was saving a file but in all cases it
was hanging in fsync() which was committing a large transaction (this was
both with and without patch) - not a big surprise. Working on the machine
seemed a bit better when the patch was applied - in the kernel with the
patch VIM at least didn't hang when just writing into the file.
  Reads are measurably better with the patch - the test with cat you
describe below took ~0.5s per file without the patch and always less than
0.02s with the patch. So it seems to help something. Can you check on your
machine whether you see some improvements? Thanks.

> I have such an ext3 based system where i can do such tests and where 
> i dont mind crashes and data corruption either, so if you send me 
> experimental patches against latet -git i can try them immediately. 
> The system has 16 CPUs, 12GB of RAM and a single disk.
> 
> Btw., i had this test going on that box while i wrote some simple 
> scripts in Vim - and it was a horrible experience. The worst wait 
> was well above one minute - Vim just hung there indefinitely. Not 
> even Ctrl-Z was possible. I captured one such wait, it was hanging 
> right here:
> 
>  aldebaran:~/linux/linux> cat /proc/3742/stack
>  [<ffffffff8034790a>] log_wait_commit+0xbd/0x110
>  [<ffffffff803430b2>] journal_stop+0x1df/0x20d
>  [<ffffffff8034421f>] journal_force_commit+0x28/0x2d
>  [<ffffffff80331c69>] ext3_force_commit+0x2b/0x2d
>  [<ffffffff80328b56>] ext3_write_inode+0x3e/0x44
>  [<ffffffff802ebb9d>] __sync_single_inode+0xc1/0x2ad
>  [<ffffffff802ebed6>] __writeback_single_inode+0x14d/0x15a
>  [<ffffffff802ebf0c>] sync_inode+0x29/0x34
>  [<ffffffff80327453>] ext3_sync_file+0xa7/0xb4
>  [<ffffffff802ef17d>] vfs_fsync+0x78/0xaf
>  [<ffffffff802ef1eb>] do_fsync+0x37/0x4d
>  [<ffffffff802ef228>] sys_fsync+0x10/0x14
>  [<ffffffff8020bd1b>] system_call_fastpath+0x16/0x1b
>  [<ffffffffffffffff>] 0xffffffffffffffff
> 
> It took about 120 seconds for it to recover.
> 
> And it's not just sys_fsync(). The script i wrote tests file read 
> latencies. I have created 1000 files with the same size (all copies 
> of kernel/sched.c ;-), and tested their cache-cold plain-cat 
> performance via:
> 
>   for ((i=0;i<1000;i++)); do
>     printf "file #%4d, plain reading it took: " $i
>     /usr/bin/time -f "%e seconds."  cat $i >/dev/null
>   done
> 
> I.e. plain, supposedly high-prio reads. The result is very common 
> hickups in read latencies:
> 
> file # 579 (253560 bytes), reading it took: 0.08 seconds.
> file # 580 (253560 bytes), reading it took: 0.05 seconds.
> file # 581 (253560 bytes), reading it took: 0.01 seconds.
> file # 582 (253560 bytes), reading it took: 0.01 seconds.
> file # 583 (253560 bytes), reading it took: 4.61 seconds.
> file # 584 (253560 bytes), reading it took: 1.29 seconds.
> file # 585 (253560 bytes), reading it took: 3.01 seconds.
> file # 586 (253560 bytes), reading it took: 7.74 seconds.
> file # 587 (253560 bytes), reading it took: 3.22 seconds.
> file # 588 (253560 bytes), reading it took: 0.05 seconds.
> file # 589 (253560 bytes), reading it took: 0.36 seconds.
> file # 590 (253560 bytes), reading it took: 7.39 seconds.
> file # 591 (253560 bytes), reading it took: 7.58 seconds.
> file # 592 (253560 bytes), reading it took: 7.90 seconds.
> file # 593 (253560 bytes), reading it took: 8.78 seconds.
> file # 594 (253560 bytes), reading it took: 8.01 seconds.
> file # 595 (253560 bytes), reading it took: 7.47 seconds.
> file # 596 (253560 bytes), reading it took: 11.52 seconds.
> file # 597 (253560 bytes), reading it took: 10.33 seconds.
> file # 598 (253560 bytes), reading it took: 8.56 seconds.
> file # 599 (253560 bytes), reading it took: 7.58 seconds.
  <snip>

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--Qxx1br4bt0+wmkIi
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-ext3-Avoid-starting-a-transaction-in-writepage-when.patch"

>From 1bf84d0f6162196b4c0d83e9db1ee11507a8f91f Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Thu, 26 Mar 2009 13:08:04 +0100
Subject: [PATCH] ext3: Avoid starting a transaction in writepage when not necessary

We don't have to start a transaction in writepage() when all the blocks
are a properly allocated. Even in ordered mode either the data has been
written via write() and they are thus already added to transaction's list
or the data was written via mmap and then it's random in which transaction
they get written anyway.

This should help VM to pageout dirty memory without blocking on transaction
commits.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext3/inode.c |   19 ++++++++++++++-----
 1 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index e230f7a..61bce1a 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -1420,6 +1420,10 @@ static int bput_one(handle_t *handle, struct buffer_head *bh)
 	return 0;
 }
 
+static int buffer_unmapped(handle_t *handle, struct buffer_head *bh)
+{
+	return !buffer_mapped(bh);
+}
 /*
  * Note that we always start a transaction even if we're not journalling
  * data.  This is to preserve ordering: any hole instantiation within
@@ -1490,6 +1494,16 @@ static int ext3_ordered_writepage(struct page *page,
 	if (ext3_journal_current_handle())
 		goto out_fail;
 
+	if (!page_has_buffers(page)) {
+		create_empty_buffers(page, inode->i_sb->s_blocksize,
+				(1 << BH_Dirty)|(1 << BH_Uptodate));
+	} else if (!walk_page_buffers(NULL, page_buffers(page), 0, PAGE_CACHE_SIZE, NULL, buffer_unmapped)) {
+		/* Provide NULL instead of get_block so that we catch bugs if buffers weren't really mapped */
+		return block_write_full_page(page, NULL, wbc);
+	}
+	page_bufs = page_buffers(page);
+
+
 	handle = ext3_journal_start(inode, ext3_writepage_trans_blocks(inode));
 
 	if (IS_ERR(handle)) {
@@ -1497,11 +1511,6 @@ static int ext3_ordered_writepage(struct page *page,
 		goto out_fail;
 	}
 
-	if (!page_has_buffers(page)) {
-		create_empty_buffers(page, inode->i_sb->s_blocksize,
-				(1 << BH_Dirty)|(1 << BH_Uptodate));
-	}
-	page_bufs = page_buffers(page);
 	walk_page_buffers(handle, page_bufs, 0,
 			PAGE_CACHE_SIZE, NULL, bget_one);
 
-- 
1.6.0.2


--Qxx1br4bt0+wmkIi--
