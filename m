Return-Path: <linux-kernel-owner+w=401wt.eu-S1752951AbXI1K3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951AbXI1K3n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 06:29:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750878AbXI1K3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 06:29:36 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47877 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750863AbXI1K3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 06:29:35 -0400
Date: Fri, 28 Sep 2007 03:29:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Artem Bityutskiy <dedekind@yandex.ru>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Write-back from inside FS - need suggestions
Message-Id: <20070928032931.4bb29752.akpm@linux-foundation.org>
In-Reply-To: <46FCC686.3050009@yandex.ru>
References: <46FCC686.3050009@yandex.ru>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Sep 2007 12:16:54 +0300 Artem Bityutskiy <dedekind@yandex.ru> wrote:

> Hi,
> 
> we are writing anew flash FS (UBIFS) and need some advise/suggestion.
> Brief FS info and the code are available at
> http://www.linux-mtd.infradead.org/doc/ubifs.html.
> 
> At any point of time we may have a plenty of cached stuff which have to
> be written back later to the flash media: dirty pages an dirty inodes.
> This is what we call "liability" - current set of dirty pages and
> inodes UBIFS must be able to write back on demand.
> 
> The problem is that we cannot do accurate flash space accounting due
> to several reasons:
> 1. Wastage - some smal random amount of flash space at ends or
>   eraseblocks cannot be used.
> 2. Compression - we do not know how well will the pages be compressed,
>   so we do not know how much flash space will they consume.
> 
> So, if our current liability is X, we do not know exactly how much
> flash space (Y) it will take. All we can do is to introduce some
> pessimistic, worst-case function Y = F(X). This pessimistic function
> assumes that pages won't be compressible, and it assumes worst-case
> wastage. In real life it is hardly going to happen, but possible.
> The functiion is really bad and may lead to huge over-estimations
> like 40%.
> 
> So, if we are, say, in ->prepare_write(), we have to decide whether
> there is enough flash space to write-back this page later. We do not
> want to fail with -ENOSPC when,say, pdflush writes the page back. So
> we use our pessimistic function F(X) to decide whether we have enough
> space or not. If there is a plenty of flash space, the F(X) says "yes",
> and just we proceed. The question is what do we do if F(X) says "no"?
> 
> If we just return -ENOSPC, the flash space utilization becomes too
> poor, just because F() is really rough. We do have space in most
> real-life cases. All we have to do in this case is to lessen our
> liability. IOW, we have to flush few dirty inodes/pages, then we'd
> be able to proceed.
> 
> So my question is: how can we flush _few_ oldest dirty pages/inodes
> while we are inside UBIFS (e.g., in ->prepare_write(), ->mkdir(),
> ->link(), etc)?
> 
> I failed to find VFS calls which would do this. Stuff like
> sync_sb_inodes() is not exactly what we need. Should we implement
> a similar function? Since we have to call it from inside UBIFS, which
> means we are holding i_mutex and the inode is locked, the function
> has to be smart enough not to wait on this inode, but wait on other
> inodes if needed.
> 
> A solution like kicking pdflush to do the job and wait on a waitqueue
> would probably also work, but I'd prefer to do this from the context
> of current task.
> 
> Should we have our own list of inodes and call write_inode_now() for
> dirty ones? But I'd prefer to let VFS pick oldest victims.
> 
> So I'm asking for ideas which would work and be acceptable by the
> community later.
> 

This is precisely the problem which needs to be solved for delayed
allocation on ext2/3/4.  This is because it is infeasible to work out how
much disk space an ext2 pagecache page will take to write out (it will
require zero to three indirect blocks as well).

When I did delalloc-for-ext2, umm, six years ago I did
maximally-pessimistic in-memory space accounting and I think I just ran a
superblock-wide sync operation when ENOSPC was about to happen.  That
caused all the pessimistic reservations to be collapsed into real ones,
releasing space.  So as the disk neared a real ENOSPC, the syncs becaome
more frequent.  But the overhead was small.

I expect that a similar thing was done in the ext4 delayed allocation
patches - you should take a look at that and see what can be
shared/generalised/etc.

ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/ext4-patches/LATEST/broken-out/

Although, judging by the comment in here:

ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/ext4-patches/LATEST/broken-out/ext4-delayed-allocation.patch

+ * TODO:
+ *   MUST:
+ *     - flush dirty pages in -ENOSPC case in order to free reserved blocks

things need a bit more work.  Hopefully that's a dead comment.

<looks>

omigod, that thing has gone and done a clone-and-own on half the VFS.
Anyway, I doubt if you'll be able to find a design description anyway
but you should spend some time picking it apart.  It is the same problem..

