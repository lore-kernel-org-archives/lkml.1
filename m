Return-Path: <linux-kernel-owner+w=401wt.eu-S1750861AbZLaFEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750861AbZLaFEr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 00:04:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750732AbZLaFEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 00:04:46 -0500
Received: from mga14.intel.com ([143.182.124.37]:34653 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720AbZLaFEp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 00:04:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="228018771"
Date: Thu, 31 Dec 2009 13:04:41 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Jan Kara <jack@suse.cz>, Steve Rago <sar@nec-labs.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jens.axboe" <jens.axboe@oracle.com>,
       Peter Staubach <staubach@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] improve the performance of large sequential write NFS
	workloads
Message-ID: <20091231050441.GB19627@localhost>
References: <20091219122033.GA11360@localhost> <1261232747.1947.194.camel@serenity> <20091222015907.GA6223@localhost> <1261578107.2606.11.camel@localhost> <20091223180551.GD3159@quack.suse.cz> <1261595574.6775.2.camel@localhost> <20091224025228.GA12477@localhost> <1261656281.3596.1.camel@localhost> <20091225055617.GA8595@localhost> <1262190168.7332.6.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1262190168.7332.6.camel@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trond,

On Thu, Dec 31, 2009 at 12:22:48AM +0800, Trond Myklebust wrote:

> it ignores the commit request if the caller is just doing a
> WB_SYNC_NONE background flush, waiting instead for the ensuing
> WB_SYNC_ALL request...

I'm afraid this will block balance_dirty_pages() until explicit
sync/fsync calls: COMMITs are bad, however if we don't send them
regularly, NR_UNSTABLE_NFS will grow large and block
balance_dirty_pages() as well as throttle_vm_writeout()..

        > +int nfs_commit_unstable_pages(struct address_space *mapping,
        > +               struct writeback_control *wbc)
        > +{
        > +       struct inode *inode = mapping->host;
        > +       int flags = FLUSH_SYNC;
        > +       int ret;
        > +
==>     > +       /* Don't commit if this is just a non-blocking flush */
==>     > +       if (wbc->sync_mode != WB_SYNC_ALL) {
==>     > +               mark_inode_unstable_pages(inode);
==>     > +               return 0;
==>     > +       }
        > +       if (wbc->nonblocking)
        > +               flags = 0;
        > +       ret = nfs_commit_inode(inode, flags);
        > +       if (ret > 0)
        > +               return 0;
        > +       return ret;
        > +}

The NFS protocol provides no painless way to reclaim unstable pages
other than the COMMIT (or sync write)..  This leaves us in a dilemma.

We may reasonably reduce the number of COMMITs, and possibly even
delay them for a while (and hope the server have writeback the pages
before the COMMIT, somehow fragile).

What we can obviously do is to avoid sending a COMMIT
- if there are already an ongoing COMMIT for the same inode
- or when there are ongoing WRITE for the inode
  (are there easy way to detect this?)

What do you think?

Thanks,
Fengguang
---
 fs/nfs/inode.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- linux.orig/fs/nfs/inode.c	2009-12-25 09:25:38.000000000 +0800
+++ linux/fs/nfs/inode.c	2009-12-25 10:13:06.000000000 +0800
@@ -105,8 +105,11 @@ int nfs_write_inode(struct inode *inode,
 		ret = filemap_fdatawait(inode->i_mapping);
 		if (ret == 0)
 			ret = nfs_commit_inode(inode, FLUSH_SYNC);
-	} else
+	} else if (!radix_tree_tagged(&NFS_I(inode)->nfs_page_tree,
+				      NFS_PAGE_TAG_LOCKED))
 		ret = nfs_commit_inode(inode, 0);
+	else
+		ret = -EAGAIN;
 	if (ret >= 0)
 		return 0;
 	__mark_inode_dirty(inode, I_DIRTY_DATASYNC);
