Return-Path: <linux-kernel-owner+w=401wt.eu-S1753362AbYKOQxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362AbYKOQxt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 11:53:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751476AbYKOQxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 11:53:38 -0500
Received: from fallback.mail.ru ([194.67.57.14]:18702 "EHLO mx4.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751424AbYKOQxh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 11:53:37 -0500
Date: Sat, 15 Nov 2008 19:47:12 +0300
From: Evgeniy Dushistov <dushistov@mail.ru>
To: Andrew Morton <akpm@linux-foundation.org>,
       Roel Kluin <roel.kluin@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] ufs: sector_t cannot be negative
Message-ID: <20081115164712.GA25570@rain>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	Roel Kluin <roel.kluin@gmail.com>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Spam: Not detected
X-Mras: OK
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roel Kluin <roel.kluin@gmail.com>

unsigned i_block,fragment cannot be negative

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Signed-off-by: Evgeniy Dushistov <dushistov@mail.ru>

---

diff --git a/fs/ufs/inode.c b/fs/ufs/inode.c
index 39f8778..168e551 100644
--- a/fs/ufs/inode.c
+++ b/fs/ufs/inode.c
@@ -56,9 +56,7 @@ static int ufs_block_to_path(struct inode *inode, sector_t i_block, sector_t off
 
 
 	UFSD("ptrs=uspi->s_apb = %d,double_blocks=%ld \n",ptrs,double_blocks);
-	if (i_block < 0) {
-		ufs_warning(inode->i_sb, "ufs_block_to_path", "block < 0");
-	} else if (i_block < direct_blocks) {
+	if (i_block < direct_blocks) {
 		offsets[n++] = i_block;
 	} else if ((i_block -= direct_blocks) < indirect_blocks) {
 		offsets[n++] = UFS_IND_BLOCK;
@@ -440,8 +438,6 @@ int ufs_getfrag_block(struct inode *inode, sector_t fragment, struct buffer_head
 	lock_kernel();
 
 	UFSD("ENTER, ino %lu, fragment %llu\n", inode->i_ino, (unsigned long long)fragment);
-	if (fragment < 0)
-		goto abort_negative;
 	if (fragment >
 	    ((UFS_NDADDR + uspi->s_apb + uspi->s_2apb + uspi->s_3apb)
 	     << uspi->s_fpbshift))
@@ -504,10 +500,6 @@ abort:
 	unlock_kernel();
 	return err;
 
-abort_negative:
-	ufs_warning(sb, "ufs_get_block", "block < 0");
-	goto abort;
-
 abort_too_big:
 	ufs_warning(sb, "ufs_get_block", "block > big");
 	goto abort;

-- 
/Evgeniy

