Return-Path: <linux-kernel-owner+w=401wt.eu-S1753505AbYCRNni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505AbYCRNni (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 09:43:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752618AbYCRNn2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 09:43:28 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:41419 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514AbYCRNn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 09:43:27 -0400
Date: Tue, 18 Mar 2008 14:43:26 +0100
From: Jan Kara <jack@suse.cz>
To: David Chinner <dgc@sgi.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: BUG: drop_pagecache_sb vs kjournald lockup
Message-ID: <20080318134326.GA6558@atrey.karlin.mff.cuni.cz>
References: <20080318112843.GJ95344431@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080318112843.GJ95344431@sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 2.6.25-rc3, 4p ia64, ext3 root drive.
> 
> I was running an XFS stress test on one of the XFS partitions on
> the machine (zero load on the root ext3 drive), when the system
> locked up in kjournald with this on the console:
> 
> BUG: spinlock lockup on CPU#2, kjournald/2150, a000000100e022e0
> 
  <snip traces>

> Looks like everything is backed up on the inode_lock.  Why? Looks
> like drop_pagecache_sb() is doing something ..... suboptimal.
> 
> static void drop_pagecache_sb(struct super_block *sb)
> {
>         struct inode *inode;
> 
>         spin_lock(&inode_lock);
>         list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
>                 if (inode->i_state & (I_FREEING|I_WILL_FREE))
>                         continue;
>                 __invalidate_mapping_pages(inode->i_mapping, 0, -1, true);
>         }
>         spin_unlock(&inode_lock);
> }
> 
> It holds the inode_lock for an amazingly long time, and calls a
> function that ends up in ->release_page which can issue
> transactions.
> 
> Given that transactions can then mark an inode dirty or the
> kjournald might need to mark an inode dirty while holding
> transaction locks, the implementation of drop_pagecache_sb seems to
> be just a little dangerous....
> 
> Anyone know the reason why drop_pagecache_sb() uses such a brute-force
> mechanism to free up clean page cache pages?
  Yes, we know that drop_pagecache_sb() has locking issues but since it
is intended to be used for debugging purposes only, nobody cared enough
to fix it. Completely untested patch below if you dare to try ;)

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
---

From: Jan Kara <jack@suse.cz>
Date: Tue, 18 Mar 2008 14:38:06 +0100
Subject: [PATCH] Fix drop_pagecache_sb() to not call __invalidate_mapping_pages() under
inode_lock.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/drop_caches.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/fs/drop_caches.c b/fs/drop_caches.c
index 59375ef..f5aae26 100644
--- a/fs/drop_caches.c
+++ b/fs/drop_caches.c
@@ -14,15 +14,21 @@ int sysctl_drop_caches;
 
 static void drop_pagecache_sb(struct super_block *sb)
 {
-	struct inode *inode;
+	struct inode *inode, *toput_inode = NULL;
 
 	spin_lock(&inode_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
 		if (inode->i_state & (I_FREEING|I_WILL_FREE))
 			continue;
+		__iget(inode);
+		spin_unlock(&inode_lock);
 		__invalidate_mapping_pages(inode->i_mapping, 0, -1, true);
+		iput(toput_inode);
+		toput_inode = inode;
+		spin_lock(&inode_lock);
 	}
 	spin_unlock(&inode_lock);
+	iput(toput_inode);
 }
 
 void drop_pagecache(void)
-- 
1.5.2.4

