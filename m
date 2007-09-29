Return-Path: <linux-kernel-owner+w=401wt.eu-S1757001AbXI2Kj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757001AbXI2Kj7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 06:39:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751950AbXI2Kjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 06:39:51 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44472 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751707AbXI2Kju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 06:39:50 -0400
Date: Sat, 29 Sep 2007 03:39:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Artem Bityutskiy <dedekind@yandex.ru>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, tytso@mit.edu
Subject: Re: Write-back from inside FS - need suggestions
Message-Id: <20070929033939.6ee65e19.akpm@linux-foundation.org>
In-Reply-To: <46FE2167.8000800@yandex.ru>
References: <46FCC686.3050009@yandex.ru>
	<46FE2167.8000800@yandex.ru>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Sep 2007 12:56:55 +0300 Artem Bityutskiy <dedekind@yandex.ru> wrote:

> Andrew Morton wrote:
> > This is precisely the problem which needs to be solved for delayed
> > allocation on ext2/3/4.  This is because it is infeasible to work out how
> > much disk space an ext2 pagecache page will take to write out (it will
> > require zero to three indirect blocks as well).
> >
> > When I did delalloc-for-ext2, umm, six years ago I did
> > maximally-pessimistic in-memory space accounting and I think I just ran a
> > superblock-wide sync operation when ENOSPC was about to happen.  That
> > caused all the pessimistic reservations to be collapsed into real ones,
> > releasing space.  So as the disk neared a real ENOSPC, the syncs becaome
> > more frequent.  But the overhead was small.
> >
> > I expect that a similar thing was done in the ext4 delayed allocation
> > patches - you should take a look at that and see what can be
> > shared/generalised/etc.
> >
> > ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/ext4-patches/LATEST/broken-out/
> >
> > Although, judging by the comment in here:
> >
> > ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/ext4-patches/LATEST/broken-out/ext4-delayed-allocation.patch
> >
> > + * TODO:
> > + *   MUST:
> > + *     - flush dirty pages in -ENOSPC case in order to free reserved blocks
> >
> > things need a bit more work.  Hopefully that's a dead comment.
> >
> > <looks>
> >
> > omigod, that thing has gone and done a clone-and-own on half the VFS.
> > Anyway, I doubt if you'll be able to find a design description anyway
> > but you should spend some time picking it apart.  It is the same problem..
> 
> (For some reasons I haven't got your answer in my mailbox, found it in
> archives)
> 
> Thank you for these pointers. I was looking at ext4 code and found haven't
> found what they do in these cases. 

I don't think it's written yet.  Not in those patches, at least.

> I think I need some hints to realize
> what's going on there. Our FS is so different from traditional ones
> - e.g., we do not use buffer heads, we do not have block device
> underneath, etc, so I even doubt I can borrow anything from ext4.

Common ideas need to be found and implemented in the VFS.  The ext4 patches
do it all in the fs which is just wrong.

The tracking of reservations (or worst-case utilisation) is surely common
across these two implementations?  Quite possibly the ENOSPC-time forced
writeback is too.

> I have impression that I just have to implement my own list of
> inodes and my own victim-picking policies. Although I still think it
> should better be done on VFS level, because it has all these LRU lists,
> and I'd duplicate things.

I'd have thought that a suitable wrapper around a suitably-modified
sync_sb_inodes() would be appropriate for both filesystems?

