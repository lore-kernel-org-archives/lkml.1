Return-Path: <linux-kernel-owner+w=401wt.eu-S1758514AbYCYSMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758514AbYCYSMh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 14:12:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753211AbYCYSM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 14:12:29 -0400
Received: from styx.suse.cz ([82.119.242.94]:48566 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752846AbYCYSM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 14:12:29 -0400
Date: Tue, 25 Mar 2008 19:12:27 +0100
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Chinner <dgc@sgi.com>, Fengguang Wu <wfg@mail.ustc.edu.cn>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] vfs: Fix lock inversion in drop_pagecache_sb()
Message-ID: <20080325181227.GE5125@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix longstanding lock inversion in drop_pagecache_sb by dropping inode_lock
before calling __invalidate_mapping_pages(). We just have to make sure
inode won't go away from under us by keeping reference to it and putting
the reference only after we have safely resumed the scan of the inode
list. A bit tricky but not too bad...

Signed-off-by: Jan Kara <jack@suse.cz>
CC: Fengguang Wu <wfg@mail.ustc.edu.cn>
CC: David Chinner <dgc@sgi.com>

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

