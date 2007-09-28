Return-Path: <linux-kernel-owner+w=401wt.eu-S1755605AbXI1HaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755605AbXI1HaS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 03:30:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751658AbXI1HaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 03:30:05 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48188 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545AbXI1HaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 03:30:00 -0400
Date: Fri, 28 Sep 2007 08:29:53 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Hansen <haveblue@us.ibm.com>, laurent.riffard@free.fr,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       reiserfs-devel@vger.kernel.org
Subject: [RFC][PATCH] stop abusing filp_open in reiserfs journal code
Message-ID: <20070928072953.GA29031@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dave Hansen <haveblue@us.ibm.com>, laurent.riffard@free.fr,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	reiserfs-devel@vger.kernel.org
References: <20070927022220.c76a7a6e.akpm@linux-foundation.org> <46FC021F.8060109@free.fr> <20070927124833.d2691813.akpm@linux-foundation.org> <20070927202607.GA3812@infradead.org> <1190926419.7344.27.camel@localhost> <20070927210423.GA6117@infradead.org> <1190928434.7344.31.camel@localhost> <20070927145125.1346901f.akpm@linux-foundation.org> <20070928071635.GA28841@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070928071635.GA28841@infradead.org>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

And here's a patch to stop the filp abuse in the journal code.  An additional
benefit is that the block device is now properly claimed when opened by
device number.


Index: linux-2.6/fs/reiserfs/journal.c
===================================================================
--- linux-2.6.orig/fs/reiserfs/journal.c	2007-09-28 09:18:50.000000000 +0200
+++ linux-2.6/fs/reiserfs/journal.c	2007-09-28 09:28:36.000000000 +0200
@@ -2544,11 +2544,9 @@ static int release_journal_dev(struct su
 
 	result = 0;
 
-	if (journal->j_dev_file != NULL) {
-		result = filp_close(journal->j_dev_file, NULL);
-		journal->j_dev_file = NULL;
-		journal->j_dev_bd = NULL;
-	} else if (journal->j_dev_bd != NULL) {
+	if (journal->j_dev_bd != NULL) {
+		if (journal->j_dev_bd->bd_dev != super->s_dev)
+			bd_release(journal->j_dev_bd);
 		result = blkdev_put(journal->j_dev_bd);
 		journal->j_dev_bd = NULL;
 	}
@@ -2573,7 +2571,6 @@ static int journal_init_dev(struct super
 	result = 0;
 
 	journal->j_dev_bd = NULL;
-	journal->j_dev_file = NULL;
 	jdev = SB_ONDISK_JOURNAL_DEVICE(super) ?
 	    new_decode_dev(SB_ONDISK_JOURNAL_DEVICE(super)) : super->s_dev;
 
@@ -2590,35 +2587,34 @@ static int journal_init_dev(struct super
 					 "cannot init journal device '%s': %i",
 					 __bdevname(jdev, b), result);
 			return result;
-		} else if (jdev != super->s_dev)
+		} else if (jdev != super->s_dev) {
+			result = bd_claim(journal->j_dev_bd, journal);
+			if (result) {
+				blkdev_put(journal->j_dev_bd);
+				return result;
+			}
+
 			set_blocksize(journal->j_dev_bd, super->s_blocksize);
+		}
+
 		return 0;
 	}
 
-	journal->j_dev_file = filp_open(jdev_name, 0, 0);
-	if (!IS_ERR(journal->j_dev_file)) {
-		struct inode *jdev_inode = journal->j_dev_file->f_mapping->host;
-		if (!S_ISBLK(jdev_inode->i_mode)) {
-			reiserfs_warning(super, "journal_init_dev: '%s' is "
-					 "not a block device", jdev_name);
-			result = -ENOTBLK;
-			release_journal_dev(super, journal);
-		} else {
-			/* ok */
-			journal->j_dev_bd = I_BDEV(jdev_inode);
-			set_blocksize(journal->j_dev_bd, super->s_blocksize);
-			reiserfs_info(super,
-				      "journal_init_dev: journal device: %s\n",
-				      bdevname(journal->j_dev_bd, b));
-		}
-	} else {
-		result = PTR_ERR(journal->j_dev_file);
-		journal->j_dev_file = NULL;
+	journal->j_dev_bd = open_bdev_excl(jdev_name, 0, journal);
+	if (IS_ERR(journal->j_dev_bd)) {
+		result = PTR_ERR(journal->j_dev_bd);
+		journal->j_dev_bd = NULL;
 		reiserfs_warning(super,
 				 "journal_init_dev: Cannot open '%s': %i",
 				 jdev_name, result);
+		return result;
 	}
-	return result;
+
+	set_blocksize(journal->j_dev_bd, super->s_blocksize);
+	reiserfs_info(super,
+		      "journal_init_dev: journal device: %s\n",
+		      bdevname(journal->j_dev_bd, b));
+	return 0;
 }
 
 /*
Index: linux-2.6/include/linux/reiserfs_fs_sb.h
===================================================================
--- linux-2.6.orig/include/linux/reiserfs_fs_sb.h	2007-09-28 09:24:27.000000000 +0200
+++ linux-2.6/include/linux/reiserfs_fs_sb.h	2007-09-28 09:24:31.000000000 +0200
@@ -177,7 +177,6 @@ struct reiserfs_journal {
 	struct reiserfs_journal_cnode *j_last;	/* newest journal block */
 	struct reiserfs_journal_cnode *j_first;	/*  oldest journal block.  start here for traverse */
 
-	struct file *j_dev_file;
 	struct block_device *j_dev_bd;
 	int j_1st_reserved_block;	/* first block on s_dev of reserved area journal */
 


