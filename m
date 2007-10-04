Return-Path: <linux-kernel-owner+w=401wt.eu-S1762733AbXJDXXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762733AbXJDXXA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 19:23:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762617AbXJDXWu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 19:22:50 -0400
Received: from mail.zelnet.ru ([80.92.97.13]:50959 "EHLO mail.zelnet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762595AbXJDXWs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 19:22:48 -0400
Message-ID: <470575BB.3020400@namesys.com>
Date: Fri, 05 Oct 2007 03:22:35 +0400
From: Edward Shishkin <edward@namesys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060411
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       "Vladimir V. Saveliev" <vs@clusterfs.com>
CC: Jan Engelhardt <jengelh@computergmbh.de>,
       Martin Vogt <vogt@itwm.fraunhofer.de>, reiserfs-devel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Subject: [patch] reiserfs: do not repair wrong journal params
References: <46CD92B6.5090900@itwm.fraunhofer.de> <Pine.LNX.4.64.0708231625360.32316@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0708231625360.32316@fbirervta.pbzchgretzou.qr>
X-Enigmail-Version: 0.86.0.0
X-Enigmail-Supports: pgp-inline, pgp-mime
Content-Type: multipart/mixed;
 boundary="------------050904090803070105000303"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050904090803070105000303
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Jan Engelhardt wrote:

>On Aug 23 2007 15:59, Martin Vogt wrote:
>  
>
...

>>Even if knoppix should not be used as a rescue/live CD, then
>>the reiserfs module should not try to correct something,
>>this should be done by another tool.(fsck.reiserfs or a module option...)
>>    
>>

The attached patch fixes this badness.

Thanks,
Edward.

--------------050904090803070105000303
Content-Type: text/x-patch;
 name="reiserfs-do-not-repair-journal-params.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="reiserfs-do-not-repair-journal-params.patch"

When mounting a file system with wrong journal params 
do not try to repair them, suggest fsck instead.

Signed-off-by: Edward Shishkin <edward@namesys.com>
---
 linux-2.6.23-rc8-mm2/fs/reiserfs/journal.c |  100 ++++++++++++++++-------------
 1 files changed, 57 insertions(+), 43 deletions(-)

--- linux-2.6.23-rc8-mm2/fs/reiserfs/journal.c.orig
+++ linux-2.6.23-rc8-mm2/fs/reiserfs/journal.c
@@ -2649,6 +2649,61 @@
 	return result;
 }
 
+/**
+ * When creating/tuning a file system user can assign some
+ * journal params within boundaries which depend on the ratio
+ * blocksize/standard_blocksize.
+ *
+ * For blocks >= standard_blocksize transaction size should
+ * be not less then JOURNAL_TRANS_MIN_DEFAULT, and not more
+ * then JOURNAL_TRANS_MAX_DEFAULT.
+ *
+ * For blocks < standard_blocksize these boundaries should be
+ * decreased proportionally.
+ */
+#define REISERFS_STANDARD_BLKSIZE (4096)
+
+static int check_advise_trans_params(struct super_block *p_s_sb,
+				     struct reiserfs_journal *journal)
+{
+        if (journal->j_trans_max) {
+	        /* Non-default journal params.
+		   Do sanity check for them. */
+	        int ratio = 1;
+		if (p_s_sb->s_blocksize < REISERFS_STANDARD_BLKSIZE)
+		        ratio = REISERFS_STANDARD_BLKSIZE / p_s_sb->s_blocksize;
+
+		if (journal->j_trans_max > JOURNAL_TRANS_MAX_DEFAULT / ratio ||
+		    journal->j_trans_max < JOURNAL_TRANS_MIN_DEFAULT / ratio ||
+		    SB_ONDISK_JOURNAL_SIZE(p_s_sb) / journal->j_trans_max <
+		    JOURNAL_MIN_RATIO) {
+		        reiserfs_warning(p_s_sb,
+				 "sh-462: bad transaction max size (%u). FSCK?",
+				 journal->j_trans_max);
+			return 1;
+		}
+		if (journal->j_max_batch != (journal->j_trans_max) *
+		        JOURNAL_MAX_BATCH_DEFAULT/JOURNAL_TRANS_MAX_DEFAULT) {
+		        reiserfs_warning(p_s_sb,
+				"sh-463: bad transaction max batch (%u). FSCK?",
+				journal->j_max_batch);
+			return 1;
+		}
+	} else {
+		/* Default journal params.
+                   The file system was created by old version
+		   of mkreiserfs, so some fields contain zeros,
+		   and we need to advise proper values for them */
+	        if (p_s_sb->s_blocksize != REISERFS_STANDARD_BLKSIZE)
+	                reiserfs_panic(p_s_sb, "sh-464: bad blocksize (%u)",
+				       p_s_sb->s_blocksize);
+		journal->j_trans_max = JOURNAL_TRANS_MAX_DEFAULT;
+		journal->j_max_batch = JOURNAL_MAX_BATCH_DEFAULT;
+		journal->j_max_commit_age = JOURNAL_MAX_COMMIT_AGE;
+	}
+	return 0;
+}
+
 /*
 ** must be called once on fs mount.  calls journal_read for you
 */
@@ -2744,49 +2799,8 @@
 	    le32_to_cpu(jh->jh_journal.jp_journal_max_commit_age);
 	journal->j_max_trans_age = JOURNAL_MAX_TRANS_AGE;
 
-	if (journal->j_trans_max) {
-		/* make sure these parameters are available, assign it if they are not */
-		__u32 initial = journal->j_trans_max;
-		__u32 ratio = 1;
-
-		if (p_s_sb->s_blocksize < 4096)
-			ratio = 4096 / p_s_sb->s_blocksize;
-
-		if (SB_ONDISK_JOURNAL_SIZE(p_s_sb) / journal->j_trans_max <
-		    JOURNAL_MIN_RATIO)
-			journal->j_trans_max =
-			    SB_ONDISK_JOURNAL_SIZE(p_s_sb) / JOURNAL_MIN_RATIO;
-		if (journal->j_trans_max > JOURNAL_TRANS_MAX_DEFAULT / ratio)
-			journal->j_trans_max =
-			    JOURNAL_TRANS_MAX_DEFAULT / ratio;
-		if (journal->j_trans_max < JOURNAL_TRANS_MIN_DEFAULT / ratio)
-			journal->j_trans_max =
-			    JOURNAL_TRANS_MIN_DEFAULT / ratio;
-
-		if (journal->j_trans_max != initial)
-			reiserfs_warning(p_s_sb,
-					 "sh-461: journal_init: wrong transaction max size (%u). Changed to %u",
-					 initial, journal->j_trans_max);
-
-		journal->j_max_batch = journal->j_trans_max *
-		    JOURNAL_MAX_BATCH_DEFAULT / JOURNAL_TRANS_MAX_DEFAULT;
-	}
-
-	if (!journal->j_trans_max) {
-		/*we have the file system was created by old version of mkreiserfs 
-		   so this field contains zero value */
-		journal->j_trans_max = JOURNAL_TRANS_MAX_DEFAULT;
-		journal->j_max_batch = JOURNAL_MAX_BATCH_DEFAULT;
-		journal->j_max_commit_age = JOURNAL_MAX_COMMIT_AGE;
-
-		/* for blocksize >= 4096 - max transaction size is 1024. For block size < 4096
-		   trans max size is decreased proportionally */
-		if (p_s_sb->s_blocksize < 4096) {
-			journal->j_trans_max /= (4096 / p_s_sb->s_blocksize);
-			journal->j_max_batch = (journal->j_trans_max) * 9 / 10;
-		}
-	}
-
+	if (check_advise_trans_params(p_s_sb, journal) != 0)
+	        goto free_and_return;
 	journal->j_default_max_commit_age = journal->j_max_commit_age;
 
 	if (commit_max_age != 0) {

--------------050904090803070105000303--
