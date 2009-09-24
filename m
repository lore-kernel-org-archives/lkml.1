Return-Path: <linux-kernel-owner+w=401wt.eu-S1752043AbZIXNqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043AbZIXNqf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 09:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751832AbZIXNqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 09:46:34 -0400
Received: from mga14.intel.com ([143.182.124.37]:46958 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018AbZIXNqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 09:46:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,445,1249282800"; 
   d="scan'208";a="191209870"
Date: Thu, 24 Sep 2009 21:46:25 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: "Li, Shaohua" <shaohua.li@intel.com>, lkml <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Mason <chris.mason@oracle.com>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Jan Kara <jack@suse.cz>
Subject: Re: [RFC] page-writeback: move indoes from one superblock together
Message-ID: <20090924134625.GA2507@localhost>
References: <1253775260.10618.10.camel@sli10-desk.sh.intel.com> <20090924100136.GA25778@localhost> <20090924123519.GF23126@kernel.dk> <20090924132252.GA696@localhost> <20090924132949.GH23126@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090924132949.GH23126@kernel.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 24, 2009 at 09:29:50PM +0800, Jens Axboe wrote:
> On Thu, Sep 24 2009, Wu Fengguang wrote:
> > On Thu, Sep 24, 2009 at 08:35:19PM +0800, Jens Axboe wrote:
> > > On Thu, Sep 24 2009, Wu Fengguang wrote:
> > > > On Thu, Sep 24, 2009 at 02:54:20PM +0800, Li, Shaohua wrote:
> > > > > __mark_inode_dirty adds inode to wb dirty list in random order. If a disk has
> > > > > several partitions, writeback might keep spindle moving between partitions.
> > > > > To reduce the move, better write big chunk of one partition and then move to
> > > > > another. Inodes from one fs usually are in one partion, so idealy move indoes
> > > > > from one fs together should reduce spindle move. This patch tries to address
> > > > > this. Before per-bdi writeback is added, the behavior is write indoes
> > > > > from one fs first and then another, so the patch restores previous behavior.
> > > > > The loop in the patch is a bit ugly, should we add a dirty list for each
> > > > > superblock in bdi_writeback?
> > > > > 
> > > > > Test in a two partition disk with attached fio script shows about 3% ~ 6%
> > > > > improvement.
> > > > 
> > > > A side note: given the noticeable performance gain, I wonder if it
> > > > deserves to generalize the idea to do whole disk location ordered
> > > > writeback. That should benefit many small file workloads more than
> > > > 10%. Because this patch only sorted 2 partitions and inodes in 5s
> > > > time window, while the below patch will roughly divide the disk into
> > > > 5 areas and sort inodes in a larger 25s time window.
> > > > 
> > > >         http://lkml.org/lkml/2007/8/27/45
> > > > 
> > > > Judging from this old patch, the complexity cost would be about 250
> > > > lines of code (need a rbtree).
> > > 
> > > First of all, nice patch, I'll add it to the current tree. I too was
> > 
> > You mean Shaohua's patch? It should be a good addition for 2.6.32.
> 
> Yes indeed, the parent patch.
> 
> > In long term move_expired_inodes() needs some rework.  Because it
> > could be time consuming to move around all the inodes in a large
> > system, and thus hold inode_lock() for too long time (and this patch
> > scales up the locked time).
> 
> It does. As mentioned in my reply, for 100 inodes or less, it will still
> be faster than eg using an rbtree. But the more "reliable" runtime of an
> rbtree based solution is appealing, though. It's not hugely critical,
> though.

Agreed. Desktops are not big worries; servers rarely do many
partitions per disk.

> > So would need to split the list moves into smaller pieces in future,
> > or to change data structure.
> 
> Yes, those are the two options.
> 
> > > pondering using an rbtree for sb+dirty_time insertion and extraction.

Note that dirty_time may not be unique, so need some workaround.  And
the resulted rbtree implementation may not be more efficient than
several list traversals even for a very large list (as long as
superblocks numbers are low).

The good side is, once sb+dirty_time rbtree is implemented, it should
be trivial to switch the key to sb+inode_number (also may not be unique),
and to do location ordered writeback ;)

Thanks,
Fengguang

> > FYI Michael Rubin did some work on a rbtree implementation, just
> > in case you are interested:
> > 
> >         http://lkml.org/lkml/2008/1/15/25
> 
> Thanks, I'll take a look.
> 
> -- 
> Jens Axboe
