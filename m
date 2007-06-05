Return-Path: <linux-kernel-owner+w=401wt.eu-S1764286AbXFEKU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764286AbXFEKU1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 06:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763486AbXFEKUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 06:20:15 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:40776 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762901AbXFEKUO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 06:20:14 -0400
Message-ID: <466538C9.8080104@sw.ru>
Date: Tue, 05 Jun 2007 14:19:53 +0400
From: Vasily Averin <vvs@sw.ru>
User-Agent: Thunderbird 1.5.0.10 (X11/20060911)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, devel@openvz.org,
       linux-ext4@vger.kernel.org, Stephen Tweedie <sct@redhat.com>,
       adilger@clusterfs.com
Subject: [PATCH] [RESEND] ext[34] orphan list check on destroy_inode
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Customers claims to ext3-related errors, investigation showed that ext3 orphan
list has been corrupted and have the reference to non-ext3 inode. The following
debug helps to understand the reasons of this issue.

Signed-off-by:	Vasily Averin <vvs@sw.ru>

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 6e30629..e986376 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -459,6 +459,13 @@ static struct inode *ext3_alloc_inode(struct super_block *sb)

 static void ext3_destroy_inode(struct inode *inode)
 {
+	if (!list_empty(&(EXT3_I(inode)->i_orphan))) {
+		printk("EXT3 Inode %p: orphan list check failed!\n",
+			EXT3_I(inode));
+		print_hex_dump(KERN_INFO, DUMP_PREFIX_ADDRESS,
+				EXT3_I(inode), sizeof(struct ext3_inode_info));
+		dump_stack();
+	}
 	kmem_cache_free(ext3_inode_cachep, EXT3_I(inode));
 }

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index cb9afdd..935420d 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -510,6 +510,13 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)

 static void ext4_destroy_inode(struct inode *inode)
 {
+	if (!list_empty(&(EXT4_I(inode)->i_orphan))) {
+		printk("EXT4 Inode %p: orphan list check failed!\n",
+			EXT4_I(inode));
+		print_hex_dump(KERN_INFO, DUMP_PREFIX_ADDRESS,
+				EXT4_I(inode), sizeof(struct ext4_inode_info));
+		dump_stack();
+	}
 	kmem_cache_free(ext4_inode_cachep, EXT4_I(inode));
 }


