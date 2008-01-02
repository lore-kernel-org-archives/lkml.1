Return-Path: <linux-kernel-owner+w=401wt.eu-S1759237AbYABUrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759237AbYABUrn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 15:47:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753336AbYABUrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 15:47:36 -0500
Received: from mx2-2.mail.ru ([194.67.23.122]:28824 "EHLO mx2.mail.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753307AbYABUrf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 15:47:35 -0500
Date: Wed, 2 Jan 2008 23:47:04 +0300
From: Evgeniy Dushistov <dushistov@mail.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven <stevenaaus@yahoo.com>, linux-kernel@vger.kernel.org
Subject: [PATCH]: ufs: fix symlink creation on ufs2
Message-ID: <20080102204649.GA16373@rain>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	Steven <stevenaaus@yahoo.com>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If create symlink on UFS2 filesystem under Linux,
it looks wrong under other OSes, because of max symlink length
field was not initialized properly, and data blocks were not
used to save short symlink names.

Signed-off-by: Evgeniy Dushistov <dushistov@mail.ru>
Cc: Steven <stevenaaus@yahoo.com>

---

diff --git a/fs/ufs/super.c b/fs/ufs/super.c
index 0072cb3..14605c0 100644
--- a/fs/ufs/super.c
+++ b/fs/ufs/super.c
@@ -131,6 +131,8 @@ static void ufs_print_super_stuff(struct super_block *sb,
 		printk(KERN_INFO"  cs_nffree(Num of free frags): %llu\n",
 		       (unsigned long long)
 		       fs64_to_cpu(sb, usb3->fs_un1.fs_u2.cs_nffree));
+		printk(KERN_INFO"  fs_maxsymlinklen: %u\n",
+		       usb3->fs_un2.fs_44.fs_maxsymlinklen);
 	} else {
 		printk(" sblkno:      %u\n", fs32_to_cpu(sb, usb1->fs_sblkno));
 		printk(" cblkno:      %u\n", fs32_to_cpu(sb, usb1->fs_cblkno));
@@ -1060,8 +1062,8 @@ magic_found:
 	uspi->s_bpf = uspi->s_fsize << 3;
 	uspi->s_bpfshift = uspi->s_fshift + 3;
 	uspi->s_bpfmask = uspi->s_bpf - 1;
-	if ((sbi->s_mount_opt & UFS_MOUNT_UFSTYPE) ==
-	    UFS_MOUNT_UFSTYPE_44BSD)
+	if ((sbi->s_mount_opt & UFS_MOUNT_UFSTYPE) == UFS_MOUNT_UFSTYPE_44BSD ||
+	    (sbi->s_mount_opt & UFS_MOUNT_UFSTYPE) == UFS_MOUNT_UFSTYPE_UFS2)
 		uspi->s_maxsymlinklen =
 		    fs32_to_cpu(sb, usb3->fs_un2.fs_44.fs_maxsymlinklen);
 
-- 
/Evgeniy

