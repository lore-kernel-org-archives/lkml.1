Return-Path: <linux-kernel-owner+w=401wt.eu-S1755934AbYH0SOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934AbYH0SOa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 14:14:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755353AbYH0SOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 14:14:11 -0400
Received: from lazybastard.de ([212.112.238.170]:60818 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755212AbYH0SOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 14:14:09 -0400
Date: Wed, 27 Aug 2008 20:13:38 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] nilfs2: continuous snapshotting file system
Message-ID: <20080827181338.GC1371@logfs.org>
References: <20080826101618.GA17261@logfs.org> <200808261654.AA00216@capsicum.lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200808261654.AA00216@capsicum.lab.ntt.co.jp>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 August 2008 01:54:30 +0900, Ryusuke Konishi wrote:
> 
> Yeah, it was very tough battle :)
> Read is OK.  But write was hard.  I looked at the vfs code over again and
> again.
> We've implemented NILFS without bringing specific changes into vfs.
> However, if we can find common basis for LFSes, I'm grad to cooperate 
> with you.
> Though I don't know whether exporting inode_lock is the case or not ;)

Well, I was looking more for something like a list of problems and
solutions.  Partially because I am plain curious and partially because I
know those are the problem areas of any log-structured filesystem and
they deserve special attention in a review.

In logfs, garbage collection may read (and write) any inode and any
block from any file.  And since garbage collection may be called from
writepage() and write_inode(), the fun included:

P: iget() on the inode being currently written back and locked.
S: Split I_LOCK into I_LOCK and I_SYNC.  Has been merged upstream.

P: iget() on an inode in I_FREEING or I_WILL_FREE state.
S: Add inodes to a list in drop_inode() and remove them again in
   destroy_inode().  iget() in GC context is wrapped in a method that
   checks said list first and return an inode from the list when
   applicable.  Used to hold inode_lock to prevent races, but a
   logfs-local lock is actually sufficient.

If either of the two problems above is solved by calling
ilookup5_nowait() I bet you a fiver that a race with data corruption is
lurking somewhere in the area.

P: find_get_page() or some variant on a page handed to
   logfs_writepage().
S: Use the one available page flag, PG_owner_priv_1 to mark pages that
   are waiting for the single-threaded logfs write path.  If any page GC
   needs is locked, check for PG_owner_priv_1 and if it is set, just use
   the page anyway.  Whoever has set the flag cannot clear it until GC
   has finished.
   If the flag is not set, the page might still be somewhere in the
   logfs write path - before setting the page.  So simply do the check
   in a loop, call schedule() each time, knock on wood and keep your
   fingers crossed that the page will either become unlocked and set
   PG_owner_priv_1 sometime soon.  I'm not proud of this solution but
   know no better one.

So something like the above for nilfs would be useful.  And maybe, just
to be on the safe side, try the following testcase overnight:
- Create tiny filesystem (32M or so).
- Fill filesystem 100% with a single file.
- Rewrite random parts of the file in an endless loop.

Or even better, combine this testcase with some automated system crashes
and do an fsck every time the system comes back up. ;)

Jörn

-- 
Geld macht nicht glücklich.
Glück macht nicht satt.
