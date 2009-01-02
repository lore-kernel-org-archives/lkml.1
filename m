Return-Path: <linux-kernel-owner+w=401wt.eu-S1758274AbZABNXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758274AbZABNXe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 08:23:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757305AbZABNXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 08:23:13 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:43737 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757048AbZABNXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 08:23:11 -0500
Date: Fri, 2 Jan 2009 13:23:08 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Marc Koschewski <marc@osknowledge.org>
Cc: Linux-LKLM <linux-kernel@vger.kernel.org>
Subject: Re: reiserfs broken with 2.6.28-17244-gb58602a
Message-ID: <20090102132308.GE28946@ZenIV.linux.org.uk>
References: <20090102083645.GA3635@stiffy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090102083645.GA3635@stiffy>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 02, 2009 at 09:38:11AM +0100, Marc Koschewski wrote:
> Hi!
> 
> I just booted into a 2.6.28-17244-gb58602a kernel that is the currently recent
> git code. The reiserfs fs has some major probs when booting this kernel. I just
> --rebuild-tree 4 partitions which are OK now again. When booting my Gentoo box
> says it cannot create an /etc/mtab~nnnn file and such. When I boot into stock
> 2.6.28, however, anything is OK. I re-tested that 3 times. Anytime I boot into
> the git kernel the messages occur and I shutdown the box via acpid (power
> button) as quick as I can.

Arrgh.  See if that helps:

now that we use ih.key earlier, we need to do all its setup early enough

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
index 145c2d3..1306d4f 100644
--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -1782,6 +1782,12 @@ int reiserfs_new_inode(struct reiserfs_transaction_handle *th,
 		goto out_bad_inode;
 	}
 	args.objectid = inode->i_ino = le32_to_cpu(ih.ih_key.k_objectid);
+	if (old_format_only(sb))
+		make_le_item_head(&ih, NULL, KEY_FORMAT_3_5, SD_OFFSET,
+				  TYPE_STAT_DATA, SD_V1_SIZE, MAX_US_INT);
+	else
+		make_le_item_head(&ih, NULL, KEY_FORMAT_3_6, SD_OFFSET,
+				  TYPE_STAT_DATA, SD_SIZE, MAX_US_INT);
 	memcpy(INODE_PKEY(inode), &(ih.ih_key), KEY_SIZE);
 	args.dirid = le32_to_cpu(ih.ih_key.k_dir_id);
 	if (insert_inode_locked4(inode, args.objectid,
@@ -1834,13 +1840,6 @@ int reiserfs_new_inode(struct reiserfs_transaction_handle *th,
 	reiserfs_init_acl_default(inode);
 	reiserfs_init_xattr_rwsem(inode);
 
-	if (old_format_only(sb))
-		make_le_item_head(&ih, NULL, KEY_FORMAT_3_5, SD_OFFSET,
-				  TYPE_STAT_DATA, SD_V1_SIZE, MAX_US_INT);
-	else
-		make_le_item_head(&ih, NULL, KEY_FORMAT_3_6, SD_OFFSET,
-				  TYPE_STAT_DATA, SD_SIZE, MAX_US_INT);
-
 	/* key to search for correct place for new stat data */
 	_make_cpu_key(&key, KEY_FORMAT_3_6, le32_to_cpu(ih.ih_key.k_dir_id),
 		      le32_to_cpu(ih.ih_key.k_objectid), SD_OFFSET,
