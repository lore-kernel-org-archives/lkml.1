Return-Path: <linux-kernel-owner+w=401wt.eu-S1761826AbXJDQFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761826AbXJDQFj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 12:05:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758911AbXJDP61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 11:58:27 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45696 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760126AbXJDP6V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 11:58:21 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 20/32] IGET: Stop ISOFS from using read_inode() [try #2]
To: hch@infradead.org, viro@ftp.linux.org.uk, torvalds@osdl.org, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       dhowells@redhat.com
Date: Thu, 04 Oct 2007 16:57:44 +0100
Message-ID: <20071004155744.2814.33093.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071004155602.2814.47731.stgit@warthog.procyon.org.uk>
References: <20071004155602.2814.47731.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stop the ISOFS filesystem from using read_inode().  Make isofs_read_inode()
return an error code, and make isofs_iget() pass it on.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/isofs/inode.c |   25 +++++++++++++++++--------
 1 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/fs/isofs/inode.c b/fs/isofs/inode.c
index 043b470..28d990b 100644
--- a/fs/isofs/inode.c
+++ b/fs/isofs/inode.c
@@ -54,7 +54,7 @@ static void isofs_put_super(struct super_block *sb)
 	return;
 }
 
-static void isofs_read_inode(struct inode *);
+static int isofs_read_inode(struct inode *);
 static int isofs_statfs (struct dentry *, struct kstatfs *);
 
 static struct kmem_cache *isofs_inode_cachep;
@@ -107,7 +107,6 @@ static int isofs_remount(struct super_block *sb, int *flags, char *data)
 static const struct super_operations isofs_sops = {
 	.alloc_inode	= isofs_alloc_inode,
 	.destroy_inode	= isofs_destroy_inode,
-	.read_inode	= isofs_read_inode,
 	.put_super	= isofs_put_super,
 	.statfs		= isofs_statfs,
 	.remount_fs	= isofs_remount,
@@ -1186,7 +1185,7 @@ out_toomany:
 	goto out;
 }
 
-static void isofs_read_inode(struct inode *inode)
+static int isofs_read_inode(struct inode *inode)
 {
 	struct super_block *sb = inode->i_sb;
 	struct isofs_sb_info *sbi = ISOFS_SB(sb);
@@ -1199,6 +1198,7 @@ static void isofs_read_inode(struct inode *inode)
 	unsigned int de_len;
 	unsigned long offset;
 	struct iso_inode_info *ei = ISOFS_I(inode);
+	int ret = -EIO;
 
 	block = ei->i_iget5_block;
 	bh = sb_bread(inode->i_sb, block);
@@ -1216,6 +1216,7 @@ static void isofs_read_inode(struct inode *inode)
 		tmpde = kmalloc(de_len, GFP_KERNEL);
 		if (tmpde == NULL) {
 			printk(KERN_INFO "%s: out of memory\n", __func__);
+			ret = -ENOMEM;
 			goto fail;
 		}
 		memcpy(tmpde, bh->b_data + offset, frag1);
@@ -1259,8 +1260,10 @@ static void isofs_read_inode(struct inode *inode)
 
 	ei->i_section_size = isonum_733(de->size);
 	if (de->flags[-high_sierra] & 0x80) {
-		if(isofs_read_level3_size(inode))
+		ret = isofs_read_level3_size(inode);
+		if (ret < 0)
 			goto fail;
+		ret = -EIO;
 	} else {
 		ei->i_next_section_block = 0;
 		ei->i_next_section_offset = 0;
@@ -1346,16 +1349,16 @@ static void isofs_read_inode(struct inode *inode)
 		/* XXX - parse_rock_ridge_inode() had already set i_rdev. */
 		init_special_inode(inode, inode->i_mode, inode->i_rdev);
 
+	ret = 0;
 out:
 	kfree(tmpde);
 	if (bh)
 		brelse(bh);
-	return;
+	return ret;
 
 out_badread:
 	printk(KERN_WARNING "ISOFS: unable to read i-node block\n");
 fail:
-	make_bad_inode(inode);
 	goto out;
 }
 
@@ -1394,6 +1397,7 @@ struct inode *isofs_iget(struct super_block *sb,
 	unsigned long hashval;
 	struct inode *inode;
 	struct isofs_iget5_callback_data data;
+	long ret;
 
 	if (offset >= 1ul << sb->s_blocksize_bits)
 		return NULL;
@@ -1407,8 +1411,13 @@ struct inode *isofs_iget(struct super_block *sb,
 				&isofs_iget5_set, &data);
 
 	if (inode && (inode->i_state & I_NEW)) {
-		sb->s_op->read_inode(inode);
-		unlock_new_inode(inode);
+		ret = isofs_read_inode(inode);
+		if (ret < 0) {
+			iget_failed(inode);
+			inode = ERR_PTR(ret);
+		} else {
+			unlock_new_inode(inode);
+		}
 	}
 
 	return inode;

