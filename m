Return-Path: <linux-kernel-owner+w=401wt.eu-S932159AbZG1X5F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932159AbZG1X5F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 19:57:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754549AbZG1XuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:50:10 -0400
Received: from kroah.org ([198.145.64.141]:35798 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754525AbZG1XuF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:50:05 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jul 28 16:41:56 2009
Message-Id: <20090728234156.742096252@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 28 Jul 2009 16:41:05 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jiro SEKIBA <jir@unicus.jp>,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [patch 36/71] nilfs2: fix disorder in cp count on error during deleting checkpoints
References: <20090728234029.868717854@mini.kroah.org>
Content-Disposition: inline; filename=nilfs2-fix-disorder-in-cp-count-on-error-during-deleting-checkpoints.patch
In-Reply-To: <20090728234756.GA11917@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jiro SEKIBA <jir@unicus.jp>

commit d9a0a345ab7a58a30ec38e5bb7401a28714914d2 upstream.

This fixes a bug that checkpoint count gets wrong on errors when
deleting a series of checkpoints.

The count error is persistent since the checkpoint count is stored on
disk.  Some userland programs refer to the count via ioctl, and this
bugfix is needed to prevent malfunction of such programs.

Signed-off-by: Jiro SEKIBA <jir@unicus.jp>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nilfs2/cpfile.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/fs/nilfs2/cpfile.c
+++ b/fs/nilfs2/cpfile.c
@@ -311,7 +311,7 @@ int nilfs_cpfile_delete_checkpoints(stru
 		ret = nilfs_cpfile_get_checkpoint_block(cpfile, cno, 0, &cp_bh);
 		if (ret < 0) {
 			if (ret != -ENOENT)
-				goto out_header;
+				break;
 			/* skip hole */
 			ret = 0;
 			continue;
@@ -344,7 +344,7 @@ int nilfs_cpfile_delete_checkpoints(stru
 					continue;
 				printk(KERN_ERR "%s: cannot delete block\n",
 				       __func__);
-				goto out_header;
+				break;
 			}
 		}
 
@@ -362,7 +362,6 @@ int nilfs_cpfile_delete_checkpoints(stru
 		kunmap_atomic(kaddr, KM_USER0);
 	}
 
- out_header:
 	brelse(header_bh);
 
  out_sem:


