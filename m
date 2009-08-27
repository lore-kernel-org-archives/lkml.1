Return-Path: <linux-kernel-owner+w=401wt.eu-S1754596AbZH0BUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596AbZH0BUS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 21:20:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754576AbZH0BUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 21:20:17 -0400
Received: from verein.lst.de ([213.95.11.210]:39429 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754575AbZH0BUQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 21:20:16 -0400
Date: Thu, 27 Aug 2009 03:19:43 +0200
From: Christoph Hellwig <hch@lst.de>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: chris.mason@oracle.com, jack@suse.cz, tytso@mit.edu, adilger@sun.com,
       swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp, mfasheh@suse.com,
       joel.becker@oracle.com
Subject: Re: [PATCH] notes on volatile write caches vs fdatasync
Message-ID: <20090827011942.GA10541@lst.de>
References: <20090827011624.GA10405@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090827011624.GA10405@lst.de>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No actually a patch, sorry ;-)

On Thu, Aug 27, 2009 at 03:16:24AM +0200, Christoph Hellwig wrote:
> There are two related issues when dealing with volatile write caches,
> the popular and beaten to death one are write barriers to guarantee
> write ordering and stable storage for log writes.  For this post
> I assume naively this works perfectly for all filesystems supporting it.
> 
> The second issue are plain cache flush.  Yes, they happen to be the
> base for the barrier implementation on all common disks in Linux, but
> there are cases where we need to issue them even without a log barrier.
> 
> Think about a plain write into a file that is already fully allocated.
> Or the O_DIRECT version of them same.  If we do an fdatasync after these
> we really do expect the write to really be on disk, not just in the disk
> cache, right?  The same is true for O_SYNC, but I ignore it for this
> write out as with Jan's patch series O_SYNC writes will be implemented
> by a range-fdatasync after the actual write, so after that this sync
> section covers it, too.
> 
> It appears the following Linux filesystems implement barrier support:
> 
>  - btrfs
>  - ext3
>  - ext4
>  - gfs2
>  - nilfs2
>  - ocfs2
>  - reiserfs
>  - xfs
> 
> Interestingly of those only ext4, reiserfs and xfs do contain direct
> calls to blkdev_issue_flush.  And unless a filesystem really creates
> a transaction for every write and forces that out on fdatasync it seems
> like all others do not actually have a chance to guarantee a cache
> flush on fdatasync.
> 
> I have tested btrfs, ext3, ext4, reiserfs, and xfs with a simple test
> program that just does a buffered write into a file, and then calls
> fdatasync.  All of the above filesystems issue a barrier request
> when the file blocks aren't allocated yet (for ext3 and reiserfs
> only when barriers are explicitly enabled, of course).
> 
> That's not the case anymore when all blocks are already allocated.
> As expected by the above grep results reiserfs and xfs still issue a
> barrier in that case.  Btrfs also performs a cache flush in every
> case which at first seems unexpected due to the lack of any
> blkdev_issue_flush call, but given that btrfs is a COW filesystem
> it actually has to allocate blocks even for an overwrite.
> Ext3 expectedly does not issue a cache flush in that case, but ext4
> unexpectedly does not issue a cache flush either.  The reason for that
> is that it only issues the cache flush if the inode was dirty but
> not at all if that is not the case.
---end quoted text---
