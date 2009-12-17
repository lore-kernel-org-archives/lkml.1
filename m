Return-Path: <linux-kernel-owner+w=401wt.eu-S1763334AbZLQA62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763334AbZLQA62 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 19:58:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761478AbZLQA6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 19:58:17 -0500
Received: from kroah.org ([198.145.64.141]:44485 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758187AbZLQAyg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 19:54:36 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 16:47:07 2009
Message-Id: <20091217004707.607176768@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 16:45:56 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       WANG Cong <amwang@redhat.com>, Eugene Teo <eteo@redhat.com>,
       Roman Zippel <zippel@linux-m68k.org>, Al Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@lst.de>, Alexey Dobriyan <adobriyan@gmail.com>,
       Dave Anderson <anderson@redhat.com>
Subject: [05/18] hfs: fix a potential buffer overflow
In-Reply-To: <20091217005306.GA6230@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Amerigo Wang <amwang@redhat.com>

commit ec81aecb29668ad71f699f4e7b96ec46691895b6 upstream.

A specially-crafted Hierarchical File System (HFS) filesystem could cause
a buffer overflow to occur in a process's kernel stack during a memcpy()
call within the hfs_bnode_read() function (at fs/hfs/bnode.c:24).  The
attacker can provide the source buffer and length, and the destination
buffer is a local variable of a fixed length.  This local variable (passed
as "&entry" from fs/hfs/dir.c:112 and allocated on line 60) is stored in
the stack frame of hfs_bnode_read()'s caller, which is hfs_readdir().
Because the hfs_readdir() function executes upon any attempt to read a
directory on the filesystem, it gets called whenever a user attempts to
inspect any filesystem contents.

[amwang@redhat.com: modify this patch and fix coding style problems]
Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Eugene Teo <eteo@redhat.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Dave Anderson <anderson@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/hfs/catalog.c |    4 ++++
 fs/hfs/dir.c     |   11 +++++++++++
 fs/hfs/super.c   |    7 ++++++-
 3 files changed, 21 insertions(+), 1 deletion(-)

--- a/fs/hfs/catalog.c
+++ b/fs/hfs/catalog.c
@@ -289,6 +289,10 @@ int hfs_cat_move(u32 cnid, struct inode 
 	err = hfs_brec_find(&src_fd);
 	if (err)
 		goto out;
+	if (src_fd.entrylength > sizeof(entry) || src_fd.entrylength < 0) {
+		err = -EIO;
+		goto out;
+	}
 
 	hfs_bnode_read(src_fd.bnode, &entry, src_fd.entryoffset,
 			    src_fd.entrylength);
--- a/fs/hfs/dir.c
+++ b/fs/hfs/dir.c
@@ -79,6 +79,11 @@ static int hfs_readdir(struct file *filp
 		filp->f_pos++;
 		/* fall through */
 	case 1:
+		if (fd.entrylength > sizeof(entry) || fd.entrylength < 0) {
+			err = -EIO;
+			goto out;
+		}
+
 		hfs_bnode_read(fd.bnode, &entry, fd.entryoffset, fd.entrylength);
 		if (entry.type != HFS_CDR_THD) {
 			printk(KERN_ERR "hfs: bad catalog folder thread\n");
@@ -109,6 +114,12 @@ static int hfs_readdir(struct file *filp
 			err = -EIO;
 			goto out;
 		}
+
+		if (fd.entrylength > sizeof(entry) || fd.entrylength < 0) {
+			err = -EIO;
+			goto out;
+		}
+
 		hfs_bnode_read(fd.bnode, &entry, fd.entryoffset, fd.entrylength);
 		type = entry.type;
 		len = hfs_mac2asc(sb, strbuf, &fd.key->cat.CName);
--- a/fs/hfs/super.c
+++ b/fs/hfs/super.c
@@ -386,8 +386,13 @@ static int hfs_fill_super(struct super_b
 	/* try to get the root inode */
 	hfs_find_init(HFS_SB(sb)->cat_tree, &fd);
 	res = hfs_cat_find_brec(sb, HFS_ROOT_CNID, &fd);
-	if (!res)
+	if (!res) {
+		if (fd.entrylength > sizeof(rec) || fd.entrylength < 0) {
+			res =  -EIO;
+			goto bail;
+		}
 		hfs_bnode_read(fd.bnode, &rec, fd.entryoffset, fd.entrylength);
+	}
 	if (res) {
 		hfs_find_exit(&fd);
 		goto bail_no_root;


