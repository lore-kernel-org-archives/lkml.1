Return-Path: <linux-kernel-owner+w=401wt.eu-S1756282AbXHSSFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282AbXHSSFo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 14:05:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753824AbXHSSFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 14:05:37 -0400
Received: from mx28.mail.ru ([194.67.23.67]:31543 "EHLO mx28.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753585AbXHSSFg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 14:05:36 -0400
Date: Sun, 19 Aug 2007 22:04:46 +0400
From: Evgeniy Dushistov <dushistov@mail.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] ufs fix sun state
Message-ID: <20070819180445.GA1814@rain>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Different types of ufs hold state in different places,
to hide complexity of this, there is ufs_get_fs_state,
it returns state according to "UFS_SB(sb)->s_flags",
but during mount ufs_get_fs_state is called,
before setting s_flags, this cause message for
ufs types like sun ufs: "fs need fsck",
and remount in readonly state.

This patch depend on other patches that now in -mm branch.


Signed-off-by: Evgeniy Dushistov <dushistov@mail.ru>

---

Index: linux-2.6.23-rc3-git1/fs/ufs/super.c
===================================================================
--- linux-2.6.23-rc3-git1.orig/fs/ufs/super.c
+++ linux-2.6.23-rc3-git1/fs/ufs/super.c
@@ -934,7 +934,7 @@ magic_found:
 		flags |=  UFS_ST_SUN;
 	}
 
-
+	sbi->s_flags = flags;/*after that line some functions use s_flags*/
 	ufs_print_super_stuff(sb, usb1, usb2, usb3);
 
 	/*
@@ -1065,8 +1065,6 @@ magic_found:
 	    UFS_MOUNT_UFSTYPE_44BSD)
 		uspi->s_maxsymlinklen =
 		    fs32_to_cpu(sb, usb3->fs_un2.fs_44.fs_maxsymlinklen);
-	
-	sbi->s_flags = flags;
 
 	inode = iget(sb, UFS_ROOTINO);
 	if (!inode || is_bad_inode(inode))

-- 
/Evgeniy

