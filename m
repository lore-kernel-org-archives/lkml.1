Return-Path: <linux-kernel-owner+w=401wt.eu-S1765408AbZCNB4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765408AbZCNB4X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 21:56:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755873AbZCNBVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 21:21:50 -0400
Received: from kroah.org ([198.145.64.141]:35729 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754976AbZCNBVS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 21:21:18 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 18:10:45 2009
Message-Id: <20090314011045.451648868@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 18:11:12 -0700
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
       alan@lxorguk.ukuu.org.uk,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [patch 095/114] ext4: Implement range_cyclic in ext4_da_writepages instead of write_cache_pages
References: <20090314010937.416083662@mini.kroah.org>
Content-Disposition: inline; filename=ext4-implement-range_cyclic-in-ext4_da_writepages-instead-of-write_cache_pages.patch
In-Reply-To: <20090314011649.GA26170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

(cherry picked from commit 2acf2c261b823d9d9ed954f348b97620297a36b5)

With delayed allocation we lock the page in write_cache_pages() and
try to build an in memory extent of contiguous blocks.  This is needed
so that we can get large contiguous blocks request.  If range_cyclic
mode is enabled, write_cache_pages() will loop back to the 0 index if
no I/O has been done yet, and try to start writing from the beginning
of the range.  That causes an attempt to take the page lock of lower
index page while holding the page lock of higher index page, which can
cause a dead lock with another writeback thread.

The solution is to implement the range_cyclic behavior in
ext4_da_writepages() instead.

http://bugzilla.kernel.org/show_bug.cgi?id=12579

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/inode.c |   21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2402,6 +2402,7 @@ static int ext4_da_writepages(struct add
 	struct inode *inode = mapping->host;
 	int no_nrwrite_index_update;
 	long pages_written = 0, pages_skipped;
+	int range_cyclic, cycled = 1, io_done = 0;
 	int needed_blocks, ret = 0, nr_to_writebump = 0;
 	struct ext4_sb_info *sbi = EXT4_SB(mapping->host->i_sb);
 
@@ -2439,9 +2440,15 @@ static int ext4_da_writepages(struct add
 	if (wbc->range_start == 0 && wbc->range_end == LLONG_MAX)
 		range_whole = 1;
 
-	if (wbc->range_cyclic)
+	range_cyclic = wbc->range_cyclic;
+	if (wbc->range_cyclic) {
 		index = mapping->writeback_index;
-	else
+		if (index)
+			cycled = 0;
+		wbc->range_start = index << PAGE_CACHE_SHIFT;
+		wbc->range_end  = LLONG_MAX;
+		wbc->range_cyclic = 0;
+	} else
 		index = wbc->range_start >> PAGE_CACHE_SHIFT;
 
 	mpd.wbc = wbc;
@@ -2455,6 +2462,7 @@ static int ext4_da_writepages(struct add
 	wbc->no_nrwrite_index_update = 1;
 	pages_skipped = wbc->pages_skipped;
 
+retry:
 	while (!ret && wbc->nr_to_write > 0) {
 
 		/*
@@ -2497,6 +2505,7 @@ static int ext4_da_writepages(struct add
 			pages_written += mpd.pages_written;
 			wbc->pages_skipped = pages_skipped;
 			ret = 0;
+			io_done = 1;
 		} else if (wbc->nr_to_write)
 			/*
 			 * There is no more writeout needed
@@ -2505,6 +2514,13 @@ static int ext4_da_writepages(struct add
 			 */
 			break;
 	}
+	if (!io_done && !cycled) {
+		cycled = 1;
+		index = 0;
+		wbc->range_start = index << PAGE_CACHE_SHIFT;
+		wbc->range_end  = mapping->writeback_index - 1;
+		goto retry;
+	}
 	if (pages_skipped != wbc->pages_skipped)
 		printk(KERN_EMERG "This should not happen leaving %s "
 				"with nr_to_write = %ld ret = %d\n",
@@ -2512,6 +2528,7 @@ static int ext4_da_writepages(struct add
 
 	/* Update index */
 	index += pages_written;
+	wbc->range_cyclic = range_cyclic;
 	if (wbc->range_cyclic || (range_whole && wbc->nr_to_write > 0))
 		/*
 		 * set the writeback_index so that range_cyclic


