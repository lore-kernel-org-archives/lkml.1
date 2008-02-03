Return-Path: <linux-kernel-owner+w=401wt.eu-S1751783AbYBCShp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751783AbYBCShp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 13:37:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753265AbYBCShY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 13:37:24 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:22791 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244AbYBCShV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 13:37:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=PBSsz6sZBZKD+JBZqgQy7PWr8FvhEq+1nsk5W5pmNusqoARlf68N1MUzE7e70K4Yjq1tSxN6umNfDOUQ+Pw1AEbLir2E2gEs4XMBMNshkc0c6ANfdJTjM17ofDmQ91r/rGUOuEe1N+BugDNyk9PMyE7DOKsty0dLL7SIii3KN94=
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jan Kara <jack@suse.cz>, Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH 2/6] udf: create function for conversion from timestamp to timespec
Date: Sun,  3 Feb 2008 19:36:07 +0100
Message-Id: <1202063771-18172-3-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1202063771-18172-1-git-send-email-marcin.slusarz@gmail.com>
References: <1202063771-18172-1-git-send-email-marcin.slusarz@gmail.com>
From: marcin.slusarz@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Jan Kara <jack@suse.cz>
---
 fs/udf/inode.c |   79 ++++++++++++++++---------------------------------------
 1 files changed, 23 insertions(+), 56 deletions(-)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 531443d..2578677 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -1151,12 +1151,24 @@ static void __udf_read_inode(struct inode *inode)
 	brelse(bh);
 }
 
+static void udf_fill_inode_time(struct timespec *tspec,
+				const timestamp *tstamp,
+				struct udf_sb_info *sbi)
+{
+	time_t convtime;
+	long convtime_usec;
+	if (udf_stamp_to_time(&convtime, &convtime_usec,
+				lets_to_cpu(*tstamp))) {
+		tspec->tv_sec = convtime;
+		tspec->tv_nsec = convtime_usec * 1000;
+	} else
+		*tspec = sbi->s_record_time;
+}
+
 static void udf_fill_inode(struct inode *inode, struct buffer_head *bh)
 {
 	struct fileEntry *fe;
 	struct extendedFileEntry *efe;
-	time_t convtime;
-	long convtime_usec;
 	int offset;
 	struct udf_sb_info *sbi = UDF_SB(inode->i_sb);
 	struct udf_inode_info *iinfo = UDF_I(inode);
@@ -1244,29 +1256,10 @@ static void udf_fill_inode(struct inode *inode, struct buffer_head *bh)
 		inode->i_blocks = le64_to_cpu(fe->logicalBlocksRecorded) <<
 			(inode->i_sb->s_blocksize_bits - 9);
 
-		if (udf_stamp_to_time(&convtime, &convtime_usec,
-				      lets_to_cpu(fe->accessTime))) {
-			inode->i_atime.tv_sec = convtime;
-			inode->i_atime.tv_nsec = convtime_usec * 1000;
-		} else {
-			inode->i_atime = sbi->s_record_time;
-		}
-
-		if (udf_stamp_to_time(&convtime, &convtime_usec,
-				      lets_to_cpu(fe->modificationTime))) {
-			inode->i_mtime.tv_sec = convtime;
-			inode->i_mtime.tv_nsec = convtime_usec * 1000;
-		} else {
-			inode->i_mtime = sbi->s_record_time;
-		}
-
-		if (udf_stamp_to_time(&convtime, &convtime_usec,
-				      lets_to_cpu(fe->attrTime))) {
-			inode->i_ctime.tv_sec = convtime;
-			inode->i_ctime.tv_nsec = convtime_usec * 1000;
-		} else {
-			inode->i_ctime = sbi->s_record_time;
-		}
+		udf_fill_inode_time(&inode->i_atime, &fe->accessTime, sbi);
+		udf_fill_inode_time(&inode->i_mtime, &fe->modificationTime,
+				    sbi);
+		udf_fill_inode_time(&inode->i_ctime, &fe->attrTime, sbi);
 
 		iinfo->i_unique = le64_to_cpu(fe->uniqueID);
 		iinfo->i_lenEAttr = le32_to_cpu(fe->lengthExtendedAttr);
@@ -1276,37 +1269,11 @@ static void udf_fill_inode(struct inode *inode, struct buffer_head *bh)
 		inode->i_blocks = le64_to_cpu(efe->logicalBlocksRecorded) <<
 		    (inode->i_sb->s_blocksize_bits - 9);
 
-		if (udf_stamp_to_time(&convtime, &convtime_usec,
-				      lets_to_cpu(efe->accessTime))) {
-			inode->i_atime.tv_sec = convtime;
-			inode->i_atime.tv_nsec = convtime_usec * 1000;
-		} else {
-			inode->i_atime = sbi->s_record_time;
-		}
-
-		if (udf_stamp_to_time(&convtime, &convtime_usec,
-				      lets_to_cpu(efe->modificationTime))) {
-			inode->i_mtime.tv_sec = convtime;
-			inode->i_mtime.tv_nsec = convtime_usec * 1000;
-		} else {
-			inode->i_mtime = sbi->s_record_time;
-		}
-
-		if (udf_stamp_to_time(&convtime, &convtime_usec,
-				      lets_to_cpu(efe->createTime))) {
-			iinfo->i_crtime.tv_sec = convtime;
-			iinfo->i_crtime.tv_nsec = convtime_usec * 1000;
-		} else {
-			iinfo->i_crtime = sbi->s_record_time;
-		}
-
-		if (udf_stamp_to_time(&convtime, &convtime_usec,
-				      lets_to_cpu(efe->attrTime))) {
-			inode->i_ctime.tv_sec = convtime;
-			inode->i_ctime.tv_nsec = convtime_usec * 1000;
-		} else {
-			inode->i_ctime = sbi->s_record_time;
-		}
+		udf_fill_inode_time(&inode->i_atime, &efe->accessTime, sbi);
+		udf_fill_inode_time(&inode->i_mtime, &efe->modificationTime,
+				    sbi);
+		udf_fill_inode_time(&iinfo->i_crtime, &efe->createTime, sbi);
+		udf_fill_inode_time(&inode->i_ctime, &efe->attrTime, sbi);
 
 		iinfo->i_unique = le64_to_cpu(efe->uniqueID);
 		iinfo->i_lenEAttr = le32_to_cpu(efe->lengthExtendedAttr);
-- 
1.5.3.7

