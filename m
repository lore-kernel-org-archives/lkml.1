Return-Path: <linux-kernel-owner+w=401wt.eu-S1758815AbXHWCsF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758815AbXHWCsF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 22:48:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758250AbXHWCro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 22:47:44 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:42185 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758216AbXHWCrl (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 22:47:41 -0400
Date: Thu, 23 Aug 2007 12:47:23 +1000
From: David Chinner <dgc@sgi.com>
To: Chris Mason <chris.mason@oracle.com>
Cc: Fengguang Wu <wfg@mail.ustc.edu.cn>, Andrew Morton <akpm@osdl.org>,
       Ken Chen <kenchen@google.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 0/6] writeback time order/delay fixes take 3
Message-ID: <20070823024723.GN61154114@sgi.com>
References: <386910467.21100@ustc.edu.cn> <20070821202314.335e86ec@think.oraclecorp.com> <387745522.02814@ustc.edu.cn> <20070822084201.2c4eceb6@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070822084201.2c4eceb6@think.oraclecorp.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2007 at 08:42:01AM -0400, Chris Mason wrote:
> I think we should assume a full scan of s_dirty is impossible in the
> presence of concurrent writers.  We want to be able to pick a start
> time (right now) and find all the inodes older than that start time.
> New things will come in while we're scanning.  But perhaps that's what
> you're saying...
> 
> At any rate, we've got two types of lists now.  One keeps track of age
> and the other two keep track of what is currently being written.  I
> would try two things:
> 
> 1) s_dirty stays a list for FIFO.  s_io becomes a radix tree that
> indexes by inode number (or some arbitrary field the FS can set in the
> inode).  Radix tree tags are used to indicate which things in s_io are
> already in progress or are pending (hand waving because I'm not sure
> exactly).
> 
> inodes are pulled off s_dirty and the corresponding slot in s_io is
> tagged to indicate IO has started.  Any nearby inodes in s_io are also
> sent down.

the problem with this approach is that it only looks at inode locality.
Data locality is ignored completely here and the data for all the
inodes that are close together could be splattered all over the drive.
In that case, clustering by inode location is exactly the wrong
thing to do.

For example, XFs changes allocation strategy at 1TB for 32bit inode
filesystems which makes the data get placed way away from the inodes.
i.e. inodes in AGs below 1TB, all data in AGs > 1TB. clustering
by inode number for data writeback is mostly useless in the >1TB
case.

The inode32 for <1Tb and inode64 allocators both try to keep data
close to the inode (i.e. in the same AG) so clustering by inode number
might work better here.

Also, it might be worthwhile allowing the filesystem to supply a
hint or mask for "closeness" for inode clustering. This would help
the gernic code only try to cluster inode writes to inodes that
fall into the same cluster as the first inode....

> > Notes:
> > (1) I'm not sure inode number is correlated to disk location in
> >     filesystems other than ext2/3/4. Or parent dir?
> 
> In general, it is a better assumption than sorting by time.  It may
> make sense to one day let the FS provide a clustering hint
> (corresponding to the first block in the file?), but for starters it
> makes sense to just go with the inode number.

Perhaps multiple hints are needed - one for data locality and one
for inode cluster locality.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
