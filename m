Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967863Ab0B0HWr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 02:22:47 -0500
Received: from bosmailout12.eigbox.net ([66.96.189.12]:35195 "EHLO
	bosmailout12.eigbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754285Ab0B0HWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 02:22:43 -0500
X-Greylist: delayed 1896 seconds by postgrey-1.27 at vger.kernel.org; Sat, 27 Feb 2010 02:22:43 EST
X-EN-OrigOutIP: 10.20.18.9
X-EN-IMPSID: mur51d0010BkY8i01ur591
Message-ID: <4B88BC95.9080406@jaysonking.com>
Date: Sat, 27 Feb 2010 00:32:53 -0600
From: "Jayson R. King" <dev@jaysonking.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Thunderbird/3.0.1
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Stable team <stable@kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
CC: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       Mingming Cao <cmm@us.ibm.com>, "Theodore Ts'o" <tytso@mit.edu>,
       linux-ext4@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Jayson King <dev@jaysonking.com>
Subject: [06/11] ext4: Retry block allocation if we have free blocks left
References: <4B88BA1B.4050500@jaysonking.com>
In-Reply-To: <4B88BA1B.4050500@jaysonking.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-EN-UserInfo: 06af1bc540adb20c3d2d7097199478a6:08dd1976e651f6e3791fbe97eaa5f898
X-EN-AuthUser: jaysonking@jaysonking.com
X-EN-OrigIP: 69.150.131.230
X-EN-OrigHost: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Date: Mon Sep 8 23:05:34 2008 -0400
Subject: ext4: Retry block allocation if we have free blocks left

commit df22291ff0fde0d350cf15dac3e5cc33ac528875 upstream.

When we truncate files, the meta-data blocks released are not reused
untill we commit the truncate transaction.  That means delayed get_block
request will return ENOSPC even if we have free blocks left.  Force a
journal commit and retry block allocation if we get ENOSPC with free
blocks left.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Jayson R. King <dev@jaysonking.com>

---
 fs/ext4/inode.c |   81 ++++++++++++++++++++++++++++++++--------------
 1 file changed, 57 insertions(+), 24 deletions(-)

diff -urNp linux-2.6.27.orig/fs/ext4/inode.c linux-2.6.27/fs/ext4/inode.c
--- linux-2.6.27.orig/fs/ext4/inode.c	2010-02-26 14:23:46.597252740 -0600
+++ linux-2.6.27/fs/ext4/inode.c	2010-02-26 14:24:08.405252691 -0600
@@ -1661,6 +1661,7 @@ struct mpage_da_data {
 	struct writeback_control *wbc;
 	int io_done;
 	long pages_written;
+	int retval;
 };
 
 /*
@@ -1858,6 +1859,24 @@ static void ext4_da_block_invalidatepage
 	return;
 }
 
+static void ext4_print_free_blocks(struct inode *inode)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
+	printk(KERN_EMERG "Total free blocks count %lld\n",
+			ext4_count_free_blocks(inode->i_sb));
+	printk(KERN_EMERG "Free/Dirty block details\n");
+	printk(KERN_EMERG "free_blocks=%lld\n",
+			percpu_counter_sum(&sbi->s_freeblocks_counter));
+	printk(KERN_EMERG "dirty_blocks=%lld\n",
+			percpu_counter_sum(&sbi->s_dirtyblocks_counter));
+	printk(KERN_EMERG "Block reservation details\n");
+	printk(KERN_EMERG "i_reserved_data_blocks=%lu\n",
+			EXT4_I(inode)->i_reserved_data_blocks);
+	printk(KERN_EMERG "i_reserved_meta_blocks=%lu\n",
+			EXT4_I(inode)->i_reserved_meta_blocks);
+	return;
+}
+
 /*
  * mpage_da_map_blocks - go through given space
  *
@@ -1872,7 +1891,7 @@ static int  mpage_da_map_blocks(struct m
 	int err = 0;
 	struct buffer_head new;
 	struct buffer_head *lbh = &mpd->lbh;
-	sector_t next = lbh->b_blocknr;
+	sector_t next;
 
 	/*
 	 * We consider only non-mapped and non-allocated blocks
@@ -1882,6 +1901,7 @@ static int  mpage_da_map_blocks(struct m
 	new.b_state = lbh->b_state;
 	new.b_blocknr = 0;
 	new.b_size = lbh->b_size;
+	next = lbh->b_blocknr;
 	/*
 	 * If we didn't accumulate anything
 	 * to write simply return
@@ -1898,6 +1918,13 @@ static int  mpage_da_map_blocks(struct m
 		 */
 		if (err == -EAGAIN)
 			return 0;
+
+		if (err == -ENOSPC &&
+				ext4_count_free_blocks(mpd->inode->i_sb)) {
+			mpd->retval = err;
+			return 0;
+		}
+
 		/*
 		 * get block failure will cause us
 		 * to loop in writepages. Because
@@ -1915,8 +1942,7 @@ static int  mpage_da_map_blocks(struct m
 		printk(KERN_EMERG "This should not happen.!! "
 					"Data will be lost\n");
 		if (err == -ENOSPC) {
-			printk(KERN_CRIT "Total free blocks count %lld\n",
-				ext4_count_free_blocks(mpd->inode->i_sb));
+			ext4_print_free_blocks(mpd->inode);
 		}
 		/* invlaidate all the pages */
 		ext4_da_block_invalidatepages(mpd, next,
@@ -2141,39 +2167,36 @@ static int __mpage_da_writepage(struct p
  */
 static int mpage_da_writepages(struct address_space *mapping,
 			       struct writeback_control *wbc,
-			       get_block_t get_block)
+			       struct mpage_da_data *mpd)
 {
-	struct mpage_da_data mpd;
 	long to_write;
 	int ret;
 
-	if (!get_block)
+	if (!mpd->get_block)
 		return generic_writepages(mapping, wbc);
 
-	mpd.wbc = wbc;
-	mpd.inode = mapping->host;
-	mpd.lbh.b_size = 0;
-	mpd.lbh.b_state = 0;
-	mpd.lbh.b_blocknr = 0;
-	mpd.first_page = 0;
-	mpd.next_page = 0;
-	mpd.get_block = get_block;
-	mpd.io_done = 0;
-	mpd.pages_written = 0;
+	mpd->lbh.b_size = 0;
+	mpd->lbh.b_state = 0;
+	mpd->lbh.b_blocknr = 0;
+	mpd->first_page = 0;
+	mpd->next_page = 0;
+	mpd->io_done = 0;
+	mpd->pages_written = 0;
+	mpd->retval = 0;
 
 	to_write = wbc->nr_to_write;
 
-	ret = write_cache_pages(mapping, wbc, __mpage_da_writepage, &mpd);
+	ret = write_cache_pages(mapping, wbc, __mpage_da_writepage, mpd);
 
 	/*
 	 * Handle last extent of pages
 	 */
-	if (!mpd.io_done && mpd.next_page != mpd.first_page) {
-		if (mpage_da_map_blocks(&mpd) == 0)
-			mpage_da_submit_io(&mpd);
+	if (!mpd->io_done && mpd->next_page != mpd->first_page) {
+		if (mpage_da_map_blocks(mpd) == 0)
+			mpage_da_submit_io(mpd);
 	}
 
-	wbc->nr_to_write = to_write - mpd.pages_written;
+	wbc->nr_to_write = to_write - mpd->pages_written;
 	return ret;
 }
 
@@ -2420,6 +2443,7 @@ static int ext4_da_writepages(struct add
 {
 	handle_t *handle = NULL;
 	loff_t range_start = 0;
+	struct mpage_da_data mpd;
 	struct inode *inode = mapping->host;
 	int needed_blocks, ret = 0, nr_to_writebump = 0;
 	long to_write, pages_skipped = 0;
@@ -2467,6 +2491,9 @@ static int ext4_da_writepages(struct add
 	range_start =  wbc->range_start;
 	pages_skipped = wbc->pages_skipped;
 
+	mpd.wbc = wbc;
+	mpd.inode = mapping->host;
+
 restart_loop:
 	to_write = wbc->nr_to_write;
 	while (!ret && to_write > 0) {
@@ -2502,11 +2529,17 @@ restart_loop:
 				goto out_writepages;
 			}
 		}
-
 		to_write -= wbc->nr_to_write;
-		ret = mpage_da_writepages(mapping, wbc,
-					  ext4_da_get_block_write);
+
+		mpd.get_block = ext4_da_get_block_write;
+		ret = mpage_da_writepages(mapping, wbc, &mpd);
+
 		ext4_journal_stop(handle);
+
+		if (mpd.retval == -ENOSPC)
+			jbd2_journal_force_commit_nested(sbi->s_journal);
+
+		/* reset the retry count */
 		if (ret == MPAGE_DA_EXTENT_TAIL) {
 			/*
 			 * got one extent now try with
