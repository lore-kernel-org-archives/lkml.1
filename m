Return-Path: <linux-kernel-owner+w=401wt.eu-S1752832AbYBCSh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832AbYBCSh7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 13:37:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753415AbYBCSho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 13:37:44 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:30475 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343AbYBCShn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 13:37:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=RnC7CFkoWjV5R+rPBvbqk9UFHARXxXKiNHXgZDzWUpz7UoVUnBH0WEaUd/YV3tGD5rNUfLy5FgG3YtzEPwO9ErQShVZ8ZoXM5tSQtdAL+HXT1up/8o8AmeeQ+2lI6F83HqtgN3f/fZJgmu7aO8QK59drwnub8hBRzJzul+Slb7Y=
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jan Kara <jack@suse.cz>, Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH 3/6] udf: convert udf_stamp_to_time to return struct timespec
Date: Sun,  3 Feb 2008 19:36:08 +0100
Message-Id: <1202063771-18172-4-git-send-email-marcin.slusarz@gmail.com>
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
 fs/udf/inode.c   |   49 ++++++++++++++++++++++++++-----------------------
 fs/udf/super.c   |    9 ++-------
 fs/udf/udfdecl.h |    4 ++--
 fs/udf/udftime.c |   17 +++++++----------
 4 files changed, 37 insertions(+), 42 deletions(-)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 2578677..252efe0 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -1151,20 +1151,6 @@ static void __udf_read_inode(struct inode *inode)
 	brelse(bh);
 }
 
-static void udf_fill_inode_time(struct timespec *tspec,
-				const timestamp *tstamp,
-				struct udf_sb_info *sbi)
-{
-	time_t convtime;
-	long convtime_usec;
-	if (udf_stamp_to_time(&convtime, &convtime_usec,
-				lets_to_cpu(*tstamp))) {
-		tspec->tv_sec = convtime;
-		tspec->tv_nsec = convtime_usec * 1000;
-	} else
-		*tspec = sbi->s_record_time;
-}
-
 static void udf_fill_inode(struct inode *inode, struct buffer_head *bh)
 {
 	struct fileEntry *fe;
@@ -1256,10 +1242,17 @@ static void udf_fill_inode(struct inode *inode, struct buffer_head *bh)
 		inode->i_blocks = le64_to_cpu(fe->logicalBlocksRecorded) <<
 			(inode->i_sb->s_blocksize_bits - 9);
 
-		udf_fill_inode_time(&inode->i_atime, &fe->accessTime, sbi);
-		udf_fill_inode_time(&inode->i_mtime, &fe->modificationTime,
-				    sbi);
-		udf_fill_inode_time(&inode->i_ctime, &fe->attrTime, sbi);
+		if (!udf_stamp_to_time(&inode->i_atime,
+					lets_to_cpu(fe->accessTime)))
+			inode->i_atime = sbi->s_record_time;
+
+		if (!udf_stamp_to_time(&inode->i_mtime,
+					lets_to_cpu(fe->modificationTime)))
+			inode->i_mtime = sbi->s_record_time;
+
+		if (!udf_stamp_to_time(&inode->i_ctime,
+					lets_to_cpu(fe->attrTime)))
+			inode->i_ctime = sbi->s_record_time;
 
 		iinfo->i_unique = le64_to_cpu(fe->uniqueID);
 		iinfo->i_lenEAttr = le32_to_cpu(fe->lengthExtendedAttr);
@@ -1269,11 +1262,21 @@ static void udf_fill_inode(struct inode *inode, struct buffer_head *bh)
 		inode->i_blocks = le64_to_cpu(efe->logicalBlocksRecorded) <<
 		    (inode->i_sb->s_blocksize_bits - 9);
 
-		udf_fill_inode_time(&inode->i_atime, &efe->accessTime, sbi);
-		udf_fill_inode_time(&inode->i_mtime, &efe->modificationTime,
-				    sbi);
-		udf_fill_inode_time(&iinfo->i_crtime, &efe->createTime, sbi);
-		udf_fill_inode_time(&inode->i_ctime, &efe->attrTime, sbi);
+		if (!udf_stamp_to_time(&inode->i_atime,
+					lets_to_cpu(efe->accessTime)))
+			inode->i_atime = sbi->s_record_time;
+
+		if (!udf_stamp_to_time(&inode->i_mtime,
+					lets_to_cpu(efe->modificationTime)))
+			inode->i_mtime = sbi->s_record_time;
+
+		if (!udf_stamp_to_time(&iinfo->i_crtime,
+					lets_to_cpu(efe->createTime)))
+			iinfo->i_crtime = sbi->s_record_time;
+
+		if (!udf_stamp_to_time(&inode->i_ctime,
+					lets_to_cpu(efe->attrTime)))
+			inode->i_ctime = sbi->s_record_time;
 
 		iinfo->i_unique = le64_to_cpu(efe->uniqueID);
 		iinfo->i_lenEAttr = le32_to_cpu(efe->lengthExtendedAttr);
diff --git a/fs/udf/super.c b/fs/udf/super.c
index 0dcee12..9f565a9 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -909,24 +909,19 @@ static int udf_find_fileset(struct super_block *sb,
 static void udf_load_pvoldesc(struct super_block *sb, struct buffer_head *bh)
 {
 	struct primaryVolDesc *pvoldesc;
-	time_t recording;
-	long recording_usec;
 	struct ustr instr;
 	struct ustr outstr;
 
 	pvoldesc = (struct primaryVolDesc *)bh->b_data;
 
-	if (udf_stamp_to_time(&recording, &recording_usec,
+	if (udf_stamp_to_time(&UDF_SB(sb)->s_record_time,
 			      lets_to_cpu(pvoldesc->recordingDateAndTime))) {
 		kernel_timestamp ts;
 		ts = lets_to_cpu(pvoldesc->recordingDateAndTime);
-		udf_debug("recording time %ld/%ld, %04u/%02u/%02u"
+		udf_debug("recording time %04u/%02u/%02u"
 			  " %02u:%02u (%x)\n",
-			  recording, recording_usec,
 			  ts.year, ts.month, ts.day, ts.hour,
 			  ts.minute, ts.typeAndTimezone);
-		UDF_SB(sb)->s_record_time.tv_sec = recording;
-		UDF_SB(sb)->s_record_time.tv_nsec = recording_usec * 1000;
 	}
 
 	if (!udf_build_ustr(&instr, pvoldesc->volIdent, 32))
diff --git a/fs/udf/udfdecl.h b/fs/udf/udfdecl.h
index 375be1b..508be85 100644
--- a/fs/udf/udfdecl.h
+++ b/fs/udf/udfdecl.h
@@ -204,7 +204,7 @@ extern short_ad *udf_get_fileshortad(uint8_t *, int, uint32_t *, int);
 extern uint16_t udf_crc(const uint8_t *, uint32_t, uint16_t);
 
 /* udftime.c */
-extern time_t *udf_stamp_to_time(time_t *, long *, kernel_timestamp);
-extern kernel_timestamp *udf_time_to_stamp(kernel_timestamp *, struct timespec);
+extern struct timespec *udf_stamp_to_time(struct timespec *dest, kernel_timestamp src);
+extern kernel_timestamp *udf_time_to_stamp(kernel_timestamp *dest, struct timespec src);
 
 #endif				/* __UDF_DECL_H */
diff --git a/fs/udf/udftime.c b/fs/udf/udftime.c
index ce59573..12fae6c 100644
--- a/fs/udf/udftime.c
+++ b/fs/udf/udftime.c
@@ -85,7 +85,7 @@ extern struct timezone sys_tz;
 #define SECS_PER_HOUR	(60 * 60)
 #define SECS_PER_DAY	(SECS_PER_HOUR * 24)
 
-time_t *udf_stamp_to_time(time_t *dest, long *dest_usec, kernel_timestamp src)
+struct timespec *udf_stamp_to_time(struct timespec *dest, kernel_timestamp src)
 {
 	int yday;
 	uint8_t type = src.typeAndTimezone >> 12;
@@ -97,23 +97,20 @@ time_t *udf_stamp_to_time(time_t *dest, long *dest_usec, kernel_timestamp src)
 		offset = (offset >> 4);
 		if (offset == -2047) /* unspecified offset */
 			offset = 0;
-	} else {
+	} else
 		offset = 0;
-	}
 
 	if ((src.year < EPOCH_YEAR) ||
 	    (src.year >= EPOCH_YEAR + MAX_YEAR_SECONDS)) {
-		*dest = -1;
-		*dest_usec = -1;
 		return NULL;
 	}
-	*dest = year_seconds[src.year - EPOCH_YEAR];
-	*dest -= offset * 60;
+	dest->tv_sec = year_seconds[src.year - EPOCH_YEAR];
+	dest->tv_sec -= offset * 60;
 
 	yday = ((__mon_yday[__isleap(src.year)][src.month - 1]) + src.day - 1);
-	*dest += (((yday * 24) + src.hour) * 60 + src.minute) * 60 + src.second;
-	*dest_usec = src.centiseconds * 10000 +
-			src.hundredsOfMicroseconds * 100 + src.microseconds;
+	dest->tv_sec += (((yday * 24) + src.hour) * 60 + src.minute) * 60 + src.second;
+	dest->tv_nsec = 1000 * (src.centiseconds * 10000 +
+			src.hundredsOfMicroseconds * 100 + src.microseconds);
 	return dest;
 }
 
-- 
1.5.3.7

