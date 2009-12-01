Return-Path: <linux-kernel-owner+w=401wt.eu-S1753986AbZLAM7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986AbZLAM7Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 07:59:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753268AbZLAM7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 07:59:24 -0500
Received: from cantor.suse.de ([195.135.220.2]:60230 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753080AbZLAM7X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 07:59:23 -0500
Date: Tue, 1 Dec 2009 13:59:20 +0100
From: Jan Kara <jack@suse.cz>
To: Mike Galbraith <gleep@gmx.de>
Cc: James Y Knight <foom@fuhm.net>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: writev data loss bug in (at least) 2.6.31 and 2.6.32pre8 x86-64
Message-ID: <20091201125920.GA12730@quack.suse.cz>
References: <1F5364AE-321E-44E9-8B0D-B8E17597A0DA@fuhm.net>
 <907888CC-F4B2-448F-8F48-B96A566D323B@fuhm.net>
 <1259667765.9614.19.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259667765.9614.19.camel@marge.simson.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 01-12-09 12:42:45, Mike Galbraith wrote:
> On Mon, 2009-11-30 at 19:48 -0500, James Y Knight wrote:
> > On Nov 30, 2009, at 3:55 PM, James Y Knight wrote:
> > 
> > > This test case fails in 2.6.23-2.6.25, because of the bug fixed in 864f24395c72b6a6c48d13f409f986dc71a5cf4a, and now again in at least 2.6.31 and 2.6.32pre8 because of a *different* bug. This test *does not* fail 2.6.26. I have not tested anything between 2.6.26 and 2.6.31.
> > > 
> > > The bug in 2.6.31 is definitely not the same bug as 2.6.23's. This time, the zero'd area of the file doesn't show up immediately upon writing the file. Instead, the kernel waits to mangle the file until it has to flush the buffer to disk. *THEN* it zeros out parts of the file.
> > > 
> > > So, after writing out the new file with writev, and checking the md5sum (which is correct), this test case asks the kernel to flush the cache for that file, and then checks the md5sum again. ONLY THEN is the file corrupted. That is, I won't hesitate to say *incredibly evil* behavior: it took me quite some time to figure out WTH was going wrong with my program before determining it was a kernel bug.
> > > 
> > > This test case is distilled from an actual application which doesn't even intentionally use writev: it just uses C++'s ofstream class to write data to a file. Unfortunately, that class smart and uses writev under the covers. Unfortunately, I guess nobody ever tests linux writev behavior, since it's broken _so_much_of_the_time_. I really am quite astounded to see such a bad track record for such a fundamental core system call....
> > > 
> > > My /tmp is an ext3 filesystem, in case that matters.
> > 
> > Further testing shows that the filesystem type *does* matter. The bug does not exhibit when the test is run on ext2, ext4, vfat, btrfs, jfs, or xfs (and probably all the others too). Only, so far as I can determine, on ext3.
> 
> I bisected it this morning.  Bisected cleanly to...
> 
> 9eaaa2d5759837402ec5eee13b2a97921808c3eb is the first bad commit
> commit 9eaaa2d5759837402ec5eee13b2a97921808c3eb
> Author: Jan Kara <jack@suse.cz>
> Date:   Mon Jul 13 20:26:52 2009 +0200
> 
>     ext3: Fix truncation of symlinks after failed write
> 
>     Contents of long symlinks is written via standard write methods. So when the
>     write fails, we add inode to orphan list. But symlinks don't have .truncate
>     method defined so nobody properly removes them from the orphan list (both on
>     disk and in memory).
> 
>     Fix this by calling ext3_truncate() directly instead of calling vmtruncate()
>     (which is saner anyway since we don't need anything vmtruncate() does except
>     from calling .truncate in these paths).  We also add inode to orphan list only
>     if ext3_can_truncate() is true (currently, it can be false for symlinks when
>     there are no blocks allocated) - otherwise orphan list processing will complain
>     and ext3_truncate() will not remove inode from on-disk orphan list.
> 
>     Signed-off-by: Jan Kara <jack@suse.cz>
> 
> Reverting that in 31.6 (two revert/apply cycles) cured it (which doesn't
> look right at a glance at changelog, but.. shrug).  Doing the same
> in .git does not cure it, so either there's a part two, or something
> went wonky.  I'll probably try to bisect part two, but would appreciate
> a verification before maybe wasting more time.
  Huh, I don't see how that's connected either but OTOH it's touching write
path so it's probably some strange interaction. Anyway, I see it on my
machine as well so I'm investigating. Thanks for CCing me.

									Honza
