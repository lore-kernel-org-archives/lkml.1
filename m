Return-Path: <linux-kernel-owner+w=401wt.eu-S1757944AbXGXSx0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757944AbXGXSx0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 14:53:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751403AbXGXSxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 14:53:18 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:2051 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbXGXSxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 14:53:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=ByntyAK6VEOTOaL/v7oDKQ2o67NNsgWxVEt2LXVy6Tvjf6FN1f+9HpIXHM4239si6yXmOAuzVkc7snow2qnUaO19jwK54eb/uc1J8M3AO6MKeasCf3PUo66a89CBm13itoU+KOqOGNEnKNIVWJk4+qFu6t3tJpU2TupMhVwQnMI=
Date: Tue, 24 Jul 2007 22:53:07 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH] UDF: fix UID and GID mount option ignorance
Message-ID: <20070724185307.GA7397@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix weird behaviour of UDF mounting procedure.
To get UID changed (for now) we have to type

	mount -t udf -o uid=some_user,uid=ignore /dev/device /mnt/moun_point

and specifying two uid at once is strange a bit. So with the patch we are able
to mount without additional 'uid=ignore' option. The same for GID option is done.

This patch will not break current mount scheme (with two option).

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Andrew, Jan comments?

Btw this does fix (I hope) the following

	[BUG 6124] mount of UDF fs ignores UID and GID options
        http://bugzilla.kernel.org/show_bug.cgi?id=6124


 fs/udf/inode.c  |   10 ++++++----
 fs/udf/super.c  |    2 ++
 fs/udf/udf_sb.h |    2 ++
 3 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 0d2c416..1652b2c 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -1127,13 +1127,15 @@ static void udf_fill_inode(struct inode *inode, struct buffer_head *bh)
 	}
 
 	inode->i_uid = le32_to_cpu(fe->uid);
-	if (inode->i_uid == -1 || UDF_QUERY_FLAG(inode->i_sb,
-						 UDF_FLAG_UID_IGNORE))
+	if (inode->i_uid == -1 ||
+	    UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_UID_IGNORE) ||
+	    UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_UID_SET))
 		inode->i_uid = UDF_SB(inode->i_sb)->s_uid;
 
 	inode->i_gid = le32_to_cpu(fe->gid);
-	if (inode->i_gid == -1 || UDF_QUERY_FLAG(inode->i_sb,
-						 UDF_FLAG_GID_IGNORE))
+	if (inode->i_gid == -1 ||
+	    UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_GID_IGNORE) ||
+	    UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_GID_SET))
 		inode->i_gid = UDF_SB(inode->i_sb)->s_gid;
 
 	inode->i_nlink = le16_to_cpu(fe->fileLinkCount);
diff --git a/fs/udf/super.c b/fs/udf/super.c
index 7b30964..382be7b 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -366,11 +366,13 @@ static int udf_parse_options(char *options, struct udf_options *uopt)
 			if (match_int(args, &option))
 				return 0;
 			uopt->gid = option;
+			uopt->flags |= (1 << UDF_FLAG_GID_SET);
 			break;
 		case Opt_uid:
 			if (match_int(args, &option))
 				return 0;
 			uopt->uid = option;
+			uopt->flags |= (1 << UDF_FLAG_UID_SET);
 			break;
 		case Opt_umask:
 			if (match_octal(args, &option))
diff --git a/fs/udf/udf_sb.h b/fs/udf/udf_sb.h
index 3e937d3..3c29820 100644
--- a/fs/udf/udf_sb.h
+++ b/fs/udf/udf_sb.h
@@ -24,6 +24,8 @@
 #define UDF_FLAG_UID_IGNORE     12    /* use sb uid instead of on disk uid */
 #define UDF_FLAG_GID_FORGET     13
 #define UDF_FLAG_GID_IGNORE     14
+#define UDF_FLAG_UID_SET	15
+#define UDF_FLAG_GID_SET	16
 
 #define UDF_PART_FLAG_UNALLOC_BITMAP	0x0001
 #define UDF_PART_FLAG_UNALLOC_TABLE	0x0002
