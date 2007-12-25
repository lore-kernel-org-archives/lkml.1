Return-Path: <linux-kernel-owner+w=401wt.eu-S1753678AbXLYPLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678AbXLYPLs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2007 10:11:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751443AbXLYPLj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Dec 2007 10:11:39 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:61328 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031AbXLYPLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2007 10:11:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=MpnqEPO/6s9cZPCt1/L8N4lXxbMaa31wCcBb1D1/mKPwfQddEMTxCHAnedYMrHWvsjTs0QM2QWn/Nt8n+fJ/im8ufPtiJvygkjn0HfyCj0Z+XbOJHPHYd/K4nlx5XzvRO+avvIytfB9yxvHb/U8FlEpO9gdYrUp/eETx29HlTek=
Date: Tue, 25 Dec 2007 16:13:19 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Ben Fennema <bfennema@falcon.csc.calpoly.edu>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/6] udf: convert UDF_SB_ALLOC_PARTMAPS macro to
	udf_sb_alloc_partition_maps function
Message-ID: <20071225151314.GE24373@joi>
References: <1198455022-27674-1-git-send-email-marcin.slusarz@gmail.com> <1198455022-27674-4-git-send-email-marcin.slusarz@gmail.com> <20071225115946.GB8296@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071225115946.GB8296@infradead.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 25, 2007 at 11:59:46AM +0000, Christoph Hellwig wrote:
> On Mon, Dec 24, 2007 at 01:10:19AM +0100, marcin.slusarz@gmail.com wrote:
> > @@ -53,6 +53,7 @@
> >  #include <linux/vfs.h>
> >  #include <linux/vmalloc.h>
> >  #include <asm/byteorder.h>
> > +#include <linux/errno.h>
>
> linux/*.h always before asm/*.h
>
> > +static int __must_check udf_sb_alloc_partition_maps(struct super_block *sb, __u32 count)
>
> I think __must_check is primarily for public APIs.  But if it really
> helps you here I won't complain.
>
> Also please use u32 over __u32 (dito for the other similar types)
>
> > +{
> > +	struct udf_sb_info *sbi = UDF_SB(sb);
> > +	sbi->s_partmaps = kzalloc(sizeof(struct udf_part_map) * count, GFP_KERNEL);
> > +	if (sbi->s_partmaps != NULL)
> > +		sbi->s_partitions = count;
> > +	else {
> > +		sbi->s_partitions = 0;
> > +		udf_error(sb, __FUNCTION__, "Unable to allocate space for %d partition maps", count);
> > +	}
> > +	return sbi->s_partmaps != NULL ? 0 : -ENOMEM;
> > +}
>
> But please don't introduce new overlong lines in entirely new functions.
>
> Also the code look rather odd, I'd rather write it as:
>
> static int udf_sb_alloc_partition_maps(struct super_block *sb, u32 count)
> {
> 	struct udf_sb_info *sbi = UDF_SB(sb);
>
> 	sbi->s_partmaps = kcalloc(count, sizeof(struct udf_part_map),
> 				  GFP_KERNEL);
> 	if (!sbi->s_partmaps) {
> 		udf_error(sb, __FUNCTION__,
> 			  "Unable to allocate space for %d partition maps",
> 			  count);
> 		sbi->s_partitions = 0;
> 		return -ENOMEM;
> 	}
>
> 	sbi->s_partitions = count;
> 	return 0;
> }

Ok, updated batch below:
--
- convert UDF_SB_ALLOC_PARTMAPS macro to udf_sb_alloc_partition_maps function
- convert kmalloc + memset to kcalloc
- check if kcalloc failed (partially)

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
CC: Ben Fennema <bfennema@falcon.csc.calpoly.edu>
CC: Jan Kara <jack@suse.cz>
CC: Christoph Hellwig <hch@infradead.org>
---
 fs/udf/super.c  |   25 +++++++++++++++++++++++--
 fs/udf/udf_sb.h |   13 -------------
 2 files changed, 23 insertions(+), 15 deletions(-)

diff --git a/fs/udf/super.c b/fs/udf/super.c
index 246868c..3f5b632 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -52,6 +52,7 @@
 #include <linux/buffer_head.h>
 #include <linux/vfs.h>
 #include <linux/vmalloc.h>
+#include <linux/errno.h>
 #include <asm/byteorder.h>

 #include <linux/udf_fs.h>
@@ -226,6 +227,24 @@ static void __exit exit_udf_fs(void)
 module_init(init_udf_fs)
 module_exit(exit_udf_fs)

+static int udf_sb_alloc_partition_maps(struct super_block *sb, u32 count)
+{
+	struct udf_sb_info *sbi = UDF_SB(sb);
+
+	sbi->s_partmaps = kcalloc(count, sizeof(struct udf_part_map),
+				  GFP_KERNEL);
+	if (!sbi->s_partmaps) {
+		udf_error(sb, __FUNCTION__,
+			  "Unable to allocate space for %d partition maps",
+			  count);
+		sbi->s_partitions = 0;
+		return -ENOMEM;
+	}
+
+	sbi->s_partitions = count;
+	return 0;
+}
+
 /*
  * udf_parse_options
  *
@@ -1037,7 +1056,9 @@ static int udf_load_logicalvol(struct super_block *sb, struct buffer_head *bh,

 	lvd = (struct logicalVolDesc *)bh->b_data;

-	UDF_SB_ALLOC_PARTMAPS(sb, le32_to_cpu(lvd->numPartitionMaps));
+	i = udf_sb_alloc_partition_maps(sb, le32_to_cpu(lvd->numPartitionMaps));
+	if (i != 0)
+		return i;

 	for (i = 0, offset = 0;
 	     i < sbi->s_partitions && offset < le32_to_cpu(lvd->mapTableLength);
@@ -1242,7 +1263,7 @@ static int udf_process_sequence(struct super_block *sb, long block,
 			if (i == VDS_POS_PRIMARY_VOL_DESC) {
 				udf_load_pvoldesc(sb, bh);
 			} else if (i == VDS_POS_LOGICAL_VOL_DESC) {
-				udf_load_logicalvol(sb, bh, fileset);
+				udf_load_logicalvol(sb, bh, fileset); /* TODO: check return value */
 			} else if (i == VDS_POS_PARTITION_DESC) {
 				struct buffer_head *bh2 = NULL;
 				if (udf_load_partdesc(sb, bh)) {
diff --git a/fs/udf/udf_sb.h b/fs/udf/udf_sb.h
index 92e6d75..4d3bd77 100644
--- a/fs/udf/udf_sb.h
+++ b/fs/udf/udf_sb.h
@@ -43,19 +43,6 @@ static inline struct udf_sb_info *UDF_SB(struct super_block *sb)

 struct logicalVolIntegrityDescImpUse *udf_sb_lvidiu(struct udf_sb_info *sbi);

-#define UDF_SB_ALLOC_PARTMAPS(X,Y)\
-{\
-	struct udf_sb_info *sbi = UDF_SB(X);\
-	sbi->s_partmaps = kmalloc(sizeof(struct udf_part_map) * Y, GFP_KERNEL);\
-	if (sbi->s_partmaps != NULL) {\
-		sbi->s_partitions = Y;\
-		memset(sbi->s_partmaps, 0x00, sizeof(struct udf_part_map) * Y);\
-	} else {\
-		sbi->s_partitions = 0;\
-		udf_error(X, __FUNCTION__, "Unable to allocate space for %d partition maps", Y);\
-	}\
-}
-
 #define UDF_SB_ALLOC_BITMAP(X,Y,Z)\
 {\
 	struct udf_sb_info *sbi = UDF_SB(X);\
--
1.5.3.4

