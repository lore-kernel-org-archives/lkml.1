Return-Path: <linux-kernel-owner+w=401wt.eu-S936695AbYEBVcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936695AbYEBVcS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 17:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760548AbYEBVcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 17:32:07 -0400
Received: from lazybastard.de ([212.112.238.170]:58725 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754318AbYEBVcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 17:32:05 -0400
Date: Fri, 2 May 2008 23:31:46 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
       linux-kernel@vger.kernel.org
Subject: Re: LogFS merge
Message-ID: <20080502213146.GD24080@logfs.org>
References: <20080502133234.GA24080@logfs.org> <alpine.LFD.1.10.0805021010040.5994@woody.linux-foundation.org> <20080502202151.GB24080@logfs.org> <alpine.LFD.1.10.0805021328200.5994@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.1.10.0805021328200.5994@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 May 2008 13:33:12 -0700, Linus Torvalds wrote:
> On Fri, 2 May 2008, Jörn Engel wrote:
> > 
> > Currently performance sucks badly on block device flashes (usb stick,
> > etc.) when creating/removing/renaming files.  The combination of logfs
> > and the built-in logic can result in 1-2MB of data written to create a
> > single empty file.  Yuck!
> 
> Can you talk about why, and describe these kinds of things? Is it just 
> because of deep directory trees and having to rebuild the tree from the 
> root up, or is it something else going on?

Logfs has the concept of "levels".  Level 0 contains file data.  Level 1
has indirect blocks, level 2 doubly indirect blocks, etc.  Inodes are
stored in an inode file, which is on level 6 for the inodes, 7 for
indirect blocks, etc.

GC requires that data for each level is kept seperate from data for
other levels.  It is the only make deadlocks impossible, any alternative
will just reduce deadlock likelyhood afaiks.  Both regular files and the
inode file can currently go up to 3x indirect, so you have up to 8
levels open for writing at any given time.

Writing data synchronously requires wandering the entire tree, i.e.
writing a block on level 0, then one on level 1, 2 and 3 if indirect
blocks are required, write the inode at level 6 and again writing blocks
on levels 7, 8 and 9 if the inode number is high.  When creating a file,
both the dentry and the created inode are written synchronously.

So on a block device level, all this translates to several writes, none
of them being adjacent.  Each write is fairly small by itself.  But the
FTL inside your favorite type of consumer flash media will turn any
small write into a write of the complete eraseblock.  So somewhere on an
internal bus, megabytes of data are happily shuffled around.


I have a solution for this, but it would require an incompatible change
to the format.  And right now I have fairly good confidence in the
format wrt. ensuring correctness.  So the plan is to merge logfs as-is
(modulo bugfixes, review fallout, etc.) and handle the changes for this
and other performance problems with compat flags.  And someday rename
the whole mess to log2fs and remove some support for old format
variants.

> > Fragmentation is neither actively avoided nor actively enforced.
> 
> I was more thinking about the fragmentation in terms of how much free 
> space you need for reasonable performance behavior - these kinds of things 
> tend to easily start behaving really badly when the disk fills up and you 
> need to GC all the time just to make room for new erase blocks for the 
> trivial inode mtime/atime updates etc.
> 
> Maybe logfs doesn't have that problem for some reason, but in many cases 
> there are rules like "we will consider the filesystem full when it goes 
> over 90% theoretical fill", and it's interesting to know.

For any flash filesystem there is what I call the "evil workload".  Fill
the filesystem 100% and randomly replace data.  In the best case (jffs2)
the filesystem has to GC one segment worth of free space to write one
block, then GC another segment for the next block, etc.  Non-compressed
log-structured filesystems can cheat their way around that by avoiding
GC and doing hole-plugging instead.  Not sure if any actually do that.

Logfs tries hard to behave the same way on any medium - if only to
increase test coverage and fix bugs for everyone when possible.  And it
has to write indirect blocks, which makes the evil workload worse yet.
However, with just 1-2MiB free, it gets back to jffs2 behaviour or at
least close, as it can GC a couple of segments and collect dirty
indirect blocks, combining updates to those.

So in effect, the question is how fill the filesystem is and how random
the write pattern.  50% full and completely random means on average
logfs has to GC one segment to write one and performance is down to 50%.
90% full and completely random means GC 9 to write 1, so we're at 10%.
90% full, 85% of which remain untouched means 5% get written and 10% are
full, so on average GC 1 to write 2.

I cannot give you a hard limit, but the math is simple enough.

> I did try looking at gitweb to see if I could find some documentation 
> file. I didn't find anything.

Noone else has asked for one before, I believe.

Jörn

-- 
Joern's library part 3:
http://inst.eecs.berkeley.edu/~cs152/fa05/handouts/clark-test.pdf
