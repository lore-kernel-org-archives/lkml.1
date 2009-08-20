Return-Path: <linux-kernel-owner+w=401wt.eu-S1754664AbZHTQ1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664AbZHTQ1c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 12:27:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753237AbZHTQ1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 12:27:32 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41796 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240AbZHTQ1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 12:27:31 -0400
Date: Thu, 20 Aug 2009 12:27:29 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       Evgeniy Polyakov <zbr@ioremap.net>, ocfs2-devel@oss.oracle.com,
       Joel Becker <joel.becker@oracle.com>, Felix Blyakher <felixb@sgi.com>,
       xfs@oss.sgi.com, Anton Altaparmakov <aia21@cantab.net>,
       linux-ntfs-dev@lists.sourceforge.net,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-ext4@vger.kernel.org, tytso@mit.edu
Subject: Re: [PATCH 07/17] vfs: Introduce new helpers for syncing after
	writing to O_SYNC file or IS_SYNC inode
Message-ID: <20090820162729.GA24659@infradead.org>
References: <1250697884-22288-1-git-send-email-jack@suse.cz> <1250697884-22288-8-git-send-email-jack@suse.cz> <20090819162638.GE6150@infradead.org> <20090820121531.GC16486@duck.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090820121531.GC16486@duck.novell.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 20, 2009 at 02:15:31PM +0200, Jan Kara wrote:
> On Wed 19-08-09 12:26:38, Christoph Hellwig wrote:
> > Looks good to me.  Eventually we should use those SYNC_ flags also all
> > through the fsync codepath, but I'll see if I can incorporate that in my
> > planned fsync rewrite.
>   Yes, I thought I'll leave that for later. BTW it should be fairly easy to
> teach generic_sync_file() to do fdatawait() before calling ->fsync() if the
> filesystem sets some flag in inode->i_mapping (or somewhere else) as is
> needed for XFS, btrfs, etc.

Maybe you can help brain storming, but I still can't see any way in that
the

  - write data
  - write inode
  - wait for data

actually is a benefit in terms of semantics (I agree that it could be
faster in theory, but even that is debatable with todays seek latencies
in disks)

Think about a simple non-journaling filesystem like ext2:

 (1) block get allocated during ->write before putting data in
      - this dirties the inode because we update i_block/i_size/etc
 (2) we call fsync (or the O_SNC handling code for that matter)
      - we start writeout of the data, which takes forever because the
	file is very large
      - then we write out the inode, including the i_size/i_blocks
	update
      - due to some reason this gets reordered before the data writeout
	finishes (without that happening there would be no benefit to
	this ordering anyway)
 (3) no we call filemap_fdatawait to wait for data I/O to finish


Now the system crashes between (2) and (3).  After that we we do have
stale data in the inode in the area not written yet.

Is there some case between that simple filesystem and the i_size update
from I/O completion handler in XFS/ext4 where this behaviour actually
buys us anything?  Any ext3 magic maybe?
