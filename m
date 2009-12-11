Return-Path: <linux-kernel-owner+w=401wt.eu-S1762644AbZLKEza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762644AbZLKEza (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 23:55:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762626AbZLKEzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 23:55:25 -0500
Received: from kroah.org ([198.145.64.141]:36780 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760507AbZLKEfz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 23:35:55 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 20:27:45 2009
Message-Id: <20091211042744.228047197@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 20:25:04 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Theodore Tso" <tytso@mit.edu>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [26/90] ext4: check for need init flag in ext4_mb_load_buddy
References: <20091211042438.970725457@linux.site>
Content-Disposition: inline; filename=0026-ext4-check-for-need-init-flag-in-ext4_mb_load_buddy.patch
In-Reply-To: <20091211043502.GA17916@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
(cherry picked from commit f41c0750538667b87a19c93952e5d42fcc069bd7)

We should check for need init flag with the group's alloc_sem held, to
make sure while we are loading the buddy cache and holding a reference
to it, a file system resize can't add new blocks to same group.

The patch also drops the need init flag check in
ext4_mb_regular_allocator() because doing the check without holding
alloc_sem is racy.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/mballoc.c |   39 ++++++++++++++++++---------------------
 1 file changed, 18 insertions(+), 21 deletions(-)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1032,8 +1032,26 @@ ext4_mb_load_buddy(struct super_block *s
 	 * groups mapped by the page is blocked
 	 * till we are done with allocation
 	 */
+repeat_load_buddy:
 	down_read(e4b->alloc_semp);
 
+	if (unlikely(EXT4_MB_GRP_NEED_INIT(grp))) {
+		/* we need to check for group need init flag
+		 * with alloc_semp held so that we can be sure
+		 * that new blocks didn't get added to the group
+		 * when we are loading the buddy cache
+		 */
+		up_read(e4b->alloc_semp);
+		/*
+		 * we need full data about the group
+		 * to make a good selection
+		 */
+		ret = ext4_mb_init_group(sb, group);
+		if (ret)
+			return ret;
+		goto repeat_load_buddy;
+	}
+
 	/*
 	 * the buddy cache inode stores the block bitmap
 	 * and buddy information in consecutive blocks.
@@ -2010,27 +2028,6 @@ repeat:
 			if (grp->bb_free == 0)
 				continue;
 
-			/*
-			 * if the group is already init we check whether it is
-			 * a good group and if not we don't load the buddy
-			 */
-			if (EXT4_MB_GRP_NEED_INIT(grp)) {
-				/*
-				 * we need full data about the group
-				 * to make a good selection
-				 */
-				err = ext4_mb_init_group(sb, group);
-				if (err)
-					goto out;
-			}
-
-			/*
-			 * If the particular group doesn't satisfy our
-			 * criteria we continue with the next group
-			 */
-			if (!ext4_mb_good_group(ac, group, cr))
-				continue;
-
 			err = ext4_mb_load_buddy(sb, group, &e4b);
 			if (err)
 				goto out;


