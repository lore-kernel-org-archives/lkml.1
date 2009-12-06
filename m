Return-Path: <linux-kernel-owner+w=401wt.eu-S1758190AbZLGAM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758190AbZLGAM0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:12:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758075AbZLGAMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:12:24 -0500
Received: from kroah.org ([198.145.64.141]:34135 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758018AbZLGAMX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:12:23 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:40 2009
Message-Id: <20091207000640.857498164@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 15:59:37 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [001/119] nilfs2: fix kernel oops in error case of nilfs_ioctl_move_blocks
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=nilfs2-fix-kernel-oops-in-error-case-of-nilfs_ioctl_move_blocks.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

commit 5399dd1fc8f5e812db931225ef5f67d89f3b1a56 upstream.

This fixes a kernel oops reported by Markus Trippelsdorf in the email
titled "[NILFS users] kernel Oops while running nilfs_cleanerd".

The oops was caused by a bug of error path in
nilfs_ioctl_move_blocks() function, which was inlined in
nilfs_ioctl_clean_segments().

nilfs_ioctl_move_blocks checks duplication of blocks which will be
moved in garbage collection.  But, the check should have be done
within nilfs_ioctl_move_inode_block() to prevent list corruption among
buffers storing the target blocks.

To fix the kernel oops, this moves forward the duplication check
before the list insertion.

I also tested this for stable trees [2.6.30, 2.6.31].

Reported-by: Markus Trippelsdorf <markus@trippelsdorf.de>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nilfs2/ioctl.c |   30 +++++++++++++-----------------
 1 file changed, 13 insertions(+), 17 deletions(-)

--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -297,7 +297,18 @@ static int nilfs_ioctl_move_inode_block(
 			       (unsigned long long)vdesc->vd_vblocknr);
 		return ret;
 	}
-	bh->b_private = vdesc;
+	if (unlikely(!list_empty(&bh->b_assoc_buffers))) {
+		printk(KERN_CRIT "%s: conflicting %s buffer: ino=%llu, "
+		       "cno=%llu, offset=%llu, blocknr=%llu, vblocknr=%llu\n",
+		       __func__, vdesc->vd_flags ? "node" : "data",
+		       (unsigned long long)vdesc->vd_ino,
+		       (unsigned long long)vdesc->vd_cno,
+		       (unsigned long long)vdesc->vd_offset,
+		       (unsigned long long)vdesc->vd_blocknr,
+		       (unsigned long long)vdesc->vd_vblocknr);
+		brelse(bh);
+		return -EEXIST;
+	}
 	list_add_tail(&bh->b_assoc_buffers, buffers);
 	return 0;
 }
@@ -335,24 +346,10 @@ static int nilfs_ioctl_move_blocks(struc
 	list_for_each_entry_safe(bh, n, &buffers, b_assoc_buffers) {
 		ret = nilfs_gccache_wait_and_mark_dirty(bh);
 		if (unlikely(ret < 0)) {
-			if (ret == -EEXIST) {
-				vdesc = bh->b_private;
-				printk(KERN_CRIT
-				       "%s: conflicting %s buffer: "
-				       "ino=%llu, cno=%llu, offset=%llu, "
-				       "blocknr=%llu, vblocknr=%llu\n",
-				       __func__,
-				       vdesc->vd_flags ? "node" : "data",
-				       (unsigned long long)vdesc->vd_ino,
-				       (unsigned long long)vdesc->vd_cno,
-				       (unsigned long long)vdesc->vd_offset,
-				       (unsigned long long)vdesc->vd_blocknr,
-				       (unsigned long long)vdesc->vd_vblocknr);
-			}
+			WARN_ON(ret == -EEXIST);
 			goto failed;
 		}
 		list_del_init(&bh->b_assoc_buffers);
-		bh->b_private = NULL;
 		brelse(bh);
 	}
 	return nmembs;
@@ -360,7 +357,6 @@ static int nilfs_ioctl_move_blocks(struc
  failed:
 	list_for_each_entry_safe(bh, n, &buffers, b_assoc_buffers) {
 		list_del_init(&bh->b_assoc_buffers);
-		bh->b_private = NULL;
 		brelse(bh);
 	}
 	return ret;


