Return-Path: <linux-kernel-owner+w=401wt.eu-S1754381AbXLASvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381AbXLASvp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 13:51:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752706AbXLASvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 13:51:31 -0500
Received: from mx2-2.mail.ru ([194.67.23.122]:25263 "EHLO mx2.mail.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752686AbXLASva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 13:51:30 -0500
Date: Sat, 1 Dec 2007 21:47:34 +0300
From: Evgeniy Dushistov <dushistov@mail.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Bailey <dsbailey@pacbell.net>, linux-kernel@vger.kernel.org
Subject: [PATCH] ufs: fix nexstep dir block size
Message-ID: <20071201184734.GA12099@rain>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	Dave Bailey <dsbailey@pacbell.net>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes regression, introduced since 2.6.16.
NextStep variant of UFS as OpenStep uses directory block size
equals to 1024. Without this change, ufs_check_page fails in many
cases.

Signed-off-by: Evgeniy Dushistov <dushistov@mail.ru>
Cc: Dave Bailey <dsbailey@pacbell.net>

---

diff --git a/fs/ufs/dir.c b/fs/ufs/dir.c
index 30f8c2b..e4263c1 100644
--- a/fs/ufs/dir.c
+++ b/fs/ufs/dir.c
@@ -179,7 +179,7 @@ bad_entry:
 	goto fail;
 Eend:
 	p = (struct ufs_dir_entry *)(kaddr + offs);
-	ufs_error (sb, "ext2_check_page",
+	ufs_error (sb, __FUNCTION__,
 		   "entry in directory #%lu spans the page boundary"
 		   "offset=%lu",
 		   dir->i_ino, (page->index<<PAGE_CACHE_SHIFT)+offs);
diff --git a/fs/ufs/super.c b/fs/ufs/super.c
index c78c04f..0072cb3 100644
--- a/fs/ufs/super.c
+++ b/fs/ufs/super.c
@@ -755,13 +755,13 @@ static int ufs_fill_super(struct super_block *sb, void *data, int silent)
 		break;
 	
 	case UFS_MOUNT_UFSTYPE_NEXTSTEP:
-		/*TODO: check may be we need set special dir block size?*/
 		UFSD("ufstype=nextstep\n");
 		uspi->s_fsize = block_size = 1024;
 		uspi->s_fmask = ~(1024 - 1);
 		uspi->s_fshift = 10;
 		uspi->s_sbsize = super_block_size = 2048;
 		uspi->s_sbbase = 0;
+		uspi->s_dirblksize = 1024;
 		flags |= UFS_DE_OLD | UFS_UID_OLD | UFS_ST_OLD | UFS_CG_OLD;
 		if (!(sb->s_flags & MS_RDONLY)) {
 			if (!silent)
@@ -771,13 +771,13 @@ static int ufs_fill_super(struct super_block *sb, void *data, int silent)
 		break;
 	
 	case UFS_MOUNT_UFSTYPE_NEXTSTEP_CD:
-		/*TODO: check may be we need set special dir block size?*/
 		UFSD("ufstype=nextstep-cd\n");
 		uspi->s_fsize = block_size = 2048;
 		uspi->s_fmask = ~(2048 - 1);
 		uspi->s_fshift = 11;
 		uspi->s_sbsize = super_block_size = 2048;
 		uspi->s_sbbase = 0;
+		uspi->s_dirblksize = 1024;
 		flags |= UFS_DE_OLD | UFS_UID_OLD | UFS_ST_OLD | UFS_CG_OLD;
 		if (!(sb->s_flags & MS_RDONLY)) {
 			if (!silent)

-- 
/Evgeniy

