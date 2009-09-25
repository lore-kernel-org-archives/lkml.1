Return-Path: <linux-kernel-owner+w=401wt.eu-S1751962AbZIYFJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962AbZIYFJ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 01:09:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751194AbZIYFJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 01:09:27 -0400
Received: from mga03.intel.com ([143.182.124.21]:31128 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936AbZIYFJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 01:09:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,449,1249282800"; 
   d="scan'208";a="191512906"
Date: Fri, 25 Sep 2009 13:09:18 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Arjan van de Ven <arjan@infradead.org>, Jens Axboe <jens.axboe@oracle.com>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Mason <chris.mason@oracle.com>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Jan Kara <jack@suse.cz>
Subject: Re: [RFC] page-writeback: move indoes from one superblock together
Message-ID: <20090925050918.GA25501@localhost>
References: <1253775260.10618.10.camel@sli10-desk.sh.intel.com> <20090924100136.GA25778@localhost> <20090924123519.GF23126@kernel.dk> <20090924132252.GA696@localhost> <20090924132949.GH23126@kernel.dk> <20090924134625.GA2507@localhost> <20090924155217.5ad0de4b@infradead.org> <20090924140919.GA3103@localhost> <20090925041619.GB9464@discord.disaster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090925041619.GB9464@discord.disaster>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 25, 2009 at 12:16:19PM +0800, Dave Chinner wrote:
> On Thu, Sep 24, 2009 at 10:09:19PM +0800, Wu Fengguang wrote:
> > On Thu, Sep 24, 2009 at 09:52:17PM +0800, Arjan van de Ven wrote:
> > > On Thu, 24 Sep 2009 21:46:25 +0800
> > > Wu Fengguang <fengguang.wu@intel.com> wrote:
> > > > 
> > > > Note that dirty_time may not be unique, so need some workaround.  And
> > > > the resulted rbtree implementation may not be more efficient than
> > > > several list traversals even for a very large list (as long as
> > > > superblocks numbers are low).
> > > > 
> > > > The good side is, once sb+dirty_time rbtree is implemented, it should
> > > > be trivial to switch the key to sb+inode_number (also may not be
> > > > unique), and to do location ordered writeback ;)
> > > 
> > > would you want to sort by dirty time, or by inode number?
> > > (assuming inode number is loosely related to location on disk)
> > 
> > Sort by inode number; dirty time will also be considered when judging
> > whether the traversed inode is old enough(*) to be eligible for writeback.
> 
> Even if the inode number is directly related to location on disk
> (like for XFS), there is no guarantee that the data or related
> metadata (indirect blocks) writeback location is in any way related
> to the inode number. e.g when using the 32 bit allocator on XFS
> (default for > 1TB filesystems), there is _zero correlation_ between
> the inode number and the data location. Hence writeback by inode
> number will not improve writeback patterns at all.

The location ordering is mainly an optimization for _small files_.
So no indirect blocks. A good filesystem will put metadata+data as
close as possible for small files. Is that true for XFS?

> Only the filesystem knows what the best writeback pattern really is;
> any change is going to affect filesystems differently.
> 
> > The more detailed algorithm would be:
> > 
> > - put inodes to rbtree with key sb+inode_number
> > - in each per-5s writeback, traverse a range of 1/5 rbtree
> > - in each traverse, sync inodes that is dirtied more than 5s ago
> >
> > So the user visible result would be
> > - on every 5s, roughly a 1/5 disk area will be visited
> > - for each dirtied inode, it will be synced after 5-30s
> 
> Personally, I'd prefer that writeback calls a vector that says
> "writeback inodes older than N" and implement something like the
> above as the generic mechanism. That way filesystems can override
> the generic algorithm if there is a better way to track and write
> back dirty inodes for that filesystem.

We have wbc->older_than_this. Is it good enough for XFS?

Thanks,
Fengguang
