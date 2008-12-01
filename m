Return-Path: <linux-kernel-owner+w=401wt.eu-S1753488AbYLAXXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488AbYLAXXS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 18:23:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751528AbYLAXXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 18:23:08 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:4473 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247AbYLAXXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 18:23:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=XGwalsmNp9CR3z4MNJzbPbwyyU/SIMuTBO9vsm7E6WZTS+CRxNSZqd34e+ot+aAgbY
         WsK2PmEyi+flDMg4eVoSs3Fvj/W4Epv93yf9Kn3a8OpHqyATxe5j4Mh0lGbCKbLu1UQw
         oAtSVZH/HRCiNF3v84T/ZVxRB5Rs3Kq2ez8Uk=
Date: Tue, 2 Dec 2008 00:22:31 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Laurent Riffard <laurent.riffard@free.fr>, Jan Kara <jack@suse.cz>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] udf: fix default mode and dmode options handling
Message-ID: <20081201232227.GA7925@joi>
References: <20081128213620.2ec593d4.sfr@canb.auug.org.au> <49332545.5020604@free.fr> <20081201001854.GA9881@joi> <49343AC2.3010808@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49343AC2.3010808@free.fr>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2008 at 08:28:02PM +0100, Laurent Riffard wrote:
> >> With next-2008-11-28, I was unable to mount an UDF-formatted DVD-RW:
> > Can you check whether attached patch fixes it?
> Current kernel is next-20081128 + reiser4 patches + your patch: it seems to works well now.
> (...)
> Tested-by: Laurent Riffard <laurent.riffard@free.fr>

Thanks!

Jan, please apply this patch:

---
From: Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH] udf: fix default mode and dmode options handling

On x86 (and several other archs) mode_t is defined as "unsigned short"
and comparing unsigned shorts to negative ints is broken (because short
is promoted to int and then compared). Fix it.

Reported-and-tested-by: Laurent Riffard <laurent.riffard@free.fr>
Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
---
 fs/udf/inode.c  |    4 ++--
 fs/udf/super.c  |    8 ++++----
 fs/udf/udf_sb.h |    2 ++
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 6612a27..2d7e56a 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -1222,10 +1222,10 @@ static void udf_fill_inode(struct inode *inode, struct buffer_head *bh)
 	iinfo->i_lenExtents = inode->i_size;
 
 	if (fe->icbTag.fileType != ICBTAG_FILE_TYPE_DIRECTORY &&
-			sbi->s_fmode != -1)
+			sbi->s_fmode != UDF_INVALID_MODE)
 		inode->i_mode = sbi->s_fmode;
 	else if (fe->icbTag.fileType == ICBTAG_FILE_TYPE_DIRECTORY &&
-			sbi->s_dmode != -1)
+			sbi->s_dmode != UDF_INVALID_MODE)
 		inode->i_mode = sbi->s_dmode;
 	else
 		inode->i_mode = udf_convert_permissions(fe);
diff --git a/fs/udf/super.c b/fs/udf/super.c
index e5d121d..8deaa61 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -284,9 +284,9 @@ static int udf_show_options(struct seq_file *seq, struct vfsmount *mnt)
 		seq_printf(seq, ",gid=%u", sbi->s_gid);
 	if (sbi->s_umask != 0)
 		seq_printf(seq, ",umask=%o", sbi->s_umask);
-	if (sbi->s_fmode != -1)
+	if (sbi->s_fmode != UDF_INVALID_MODE)
 		seq_printf(seq, ",mode=%o", sbi->s_fmode);
-	if (sbi->s_dmode != -1)
+	if (sbi->s_dmode != UDF_INVALID_MODE)
 		seq_printf(seq, ",dmode=%o", sbi->s_dmode);
 	if (UDF_QUERY_FLAG(sb, UDF_FLAG_SESSION_SET))
 		seq_printf(seq, ",session=%u", sbi->s_session);
@@ -1894,8 +1894,8 @@ static int udf_fill_super(struct super_block *sb, void *options, int silent)
 	uopt.uid = -1;
 	uopt.gid = -1;
 	uopt.umask = 0;
-	uopt.fmode = -1;
-	uopt.dmode = -1;
+	uopt.fmode = UDF_INVALID_MODE;
+	uopt.dmode = UDF_INVALID_MODE;
 
 	sbi = kzalloc(sizeof(struct udf_sb_info), GFP_KERNEL);
 	if (!sbi)
diff --git a/fs/udf/udf_sb.h b/fs/udf/udf_sb.h
index 5d32c60..158221e 100644
--- a/fs/udf/udf_sb.h
+++ b/fs/udf/udf_sb.h
@@ -48,6 +48,8 @@
 #define UDF_SPARABLE_MAP15		0x1522U
 #define UDF_METADATA_MAP25		0x2511U
 
+#define UDF_INVALID_MODE		((mode_t)-1)
+
 #pragma pack(1) /* XXX(hch): Why?  This file just defines in-core structures */
 
 struct udf_meta_data {
-- 
1.5.6.4

