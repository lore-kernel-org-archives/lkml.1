Return-Path: <linux-kernel-owner+w=401wt.eu-S1762072AbZAWGbL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762072AbZAWGbL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 01:31:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755189AbZAWGRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 01:17:05 -0500
Received: from kroah.org ([198.145.64.141]:36444 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761247AbZAWGQ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 01:16:59 -0500
Date: Thu, 22 Jan 2009 22:14:58 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Nick Piggin <npiggin@suse.de>
Subject: [patch 39/40] fs: sync_sb_inodes fix
Message-ID: <20090123061458.GM2922@kroah.com>
References: <20090123001330.046404396@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fs-sync_sb_inodes-fix.patch"
In-Reply-To: <20090123001908.GA7397@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Nick Piggin <npiggin@suse.de>

commit 38f21977663126fef53f5585e7f1653d8ebe55c4 upstream.

Fix data integrity semantics required by sys_sync, by iterating over all
inodes and waiting for any writeback pages after the initial writeout.
Comments explain the exact problem.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/fs-writeback.c |   60 +++++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 53 insertions(+), 7 deletions(-)

--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -440,6 +440,7 @@ void generic_sync_sb_inodes(struct super
 				struct writeback_control *wbc)
 {
 	const unsigned long start = jiffies;	/* livelock avoidance */
+	int sync = wbc->sync_mode == WB_SYNC_ALL;
 
 	spin_lock(&inode_lock);
 	if (!wbc->for_kupdate || list_empty(&sb->s_io))
@@ -516,7 +517,49 @@ void generic_sync_sb_inodes(struct super
 		if (!list_empty(&sb->s_more_io))
 			wbc->more_io = 1;
 	}
-	spin_unlock(&inode_lock);
+
+	if (sync) {
+		struct inode *inode, *old_inode = NULL;
+
+		/*
+		 * Data integrity sync. Must wait for all pages under writeback,
+		 * because there may have been pages dirtied before our sync
+		 * call, but which had writeout started before we write it out.
+		 * In which case, the inode may not be on the dirty list, but
+		 * we still have to wait for that writeout.
+		 */
+		list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
+			struct address_space *mapping;
+
+			if (inode->i_state & (I_FREEING|I_WILL_FREE))
+				continue;
+			mapping = inode->i_mapping;
+			if (mapping->nrpages == 0)
+				continue;
+			__iget(inode);
+			spin_unlock(&inode_lock);
+			/*
+			 * We hold a reference to 'inode' so it couldn't have
+			 * been removed from s_inodes list while we dropped the
+			 * inode_lock.  We cannot iput the inode now as we can
+			 * be holding the last reference and we cannot iput it
+			 * under inode_lock. So we keep the reference and iput
+			 * it later.
+			 */
+			iput(old_inode);
+			old_inode = inode;
+
+			filemap_fdatawait(mapping);
+
+			cond_resched();
+
+			spin_lock(&inode_lock);
+		}
+		spin_unlock(&inode_lock);
+		iput(old_inode);
+	} else
+		spin_unlock(&inode_lock);
+
 	return;		/* Leave any unwritten inodes on s_io */
 }
 EXPORT_SYMBOL_GPL(generic_sync_sb_inodes);
@@ -596,13 +639,16 @@ void sync_inodes_sb(struct super_block *
 		.range_start	= 0,
 		.range_end	= LLONG_MAX,
 	};
-	unsigned long nr_dirty = global_page_state(NR_FILE_DIRTY);
-	unsigned long nr_unstable = global_page_state(NR_UNSTABLE_NFS);
 
-	wbc.nr_to_write = nr_dirty + nr_unstable +
-			(inodes_stat.nr_inodes - inodes_stat.nr_unused) +
-			nr_dirty + nr_unstable;
-	wbc.nr_to_write += wbc.nr_to_write / 2;		/* Bit more for luck */
+	if (!wait) {
+		unsigned long nr_dirty = global_page_state(NR_FILE_DIRTY);
+		unsigned long nr_unstable = global_page_state(NR_UNSTABLE_NFS);
+
+		wbc.nr_to_write = nr_dirty + nr_unstable +
+			(inodes_stat.nr_inodes - inodes_stat.nr_unused);
+	} else
+		wbc.nr_to_write = LONG_MAX; /* doesn't actually matter */
+
 	sync_sb_inodes(sb, &wbc);
 }
 

