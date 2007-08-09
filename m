Return-Path: <linux-kernel-owner+w=401wt.eu-S939138AbXHILNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939138AbXHILNS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 07:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932189AbXHILNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 07:13:10 -0400
Received: from server001.webpack.hosteurope.de ([80.237.130.9]:57359 "EHLO
	server001.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932209AbXHILNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 07:13:08 -0400
X-Greylist: delayed 1823 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Aug 2007 07:13:08 EDT
From: Andi Drebes <lists-receive@programmierforen.de>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] cramfs: Error message about endianess
Date: Thu, 9 Aug 2007 12:42:38 +0200
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708091242.38235.lists-receive@programmierforen.de>
X-bounce-key: webpack.hosteurope.de;lists-receive@programmierforen.de;1186657988;06fd989f;
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The README file in the cramfs subdirectory says:

"All data is currently in host-endian format; neither mkcramfs nor the
kernel ever do swabbing."

If somebody tries to mount a cramfs with the wrong endianess,
cramfs only complains about a wrong magic but doesn't inform
the user that only the endianess isn't right.

The following patch adds an error message to the cramfs sources.
If a user tries to mount a cramfs with the wrong endianess using the
patched sources, cramfs will display the message "cramfs: wrong
endianess".

I'm currently not subscribed to the list, so please CC me for any comments.

Tested on an i386 box. Diffed against Linus' git-tree.

Signed-off-by: Andi Drebes <lists-receive@programmierforen.de>
---
diff --git a/fs/cramfs/inode.c b/fs/cramfs/inode.c
index 3d194a2..34c9b91 100644
--- a/fs/cramfs/inode.c
+++ b/fs/cramfs/inode.c
@@ -258,12 +258,21 @@ static int cramfs_fill_super(struct super_block *sb, void *data, int silent)
 
 	/* Do sanity checks on the superblock */
 	if (super.magic != CRAMFS_MAGIC) {
+		/* check for wrong endianess */
+		if(super.magic == CRAMFS_MAGIC_WEND) {
+			if (!silent)
+				printk(KERN_ERR "cramfs: wrong endianess\n");
+			goto out;
+		}
+	
 		/* check at 512 byte offset */
 		mutex_lock(&read_mutex);
 		memcpy(&super, cramfs_read(sb, 512, sizeof(super)), sizeof(super));
 		mutex_unlock(&read_mutex);
 		if (super.magic != CRAMFS_MAGIC) {
-			if (!silent)
+			if(super.magic == CRAMFS_MAGIC_WEND && !silent)
+				printk(KERN_ERR "cramfs: wrong endianess\n");
+			else if (!silent)
 				printk(KERN_ERR "cramfs: wrong magic\n");
 			goto out;
 		}
diff --git a/include/linux/cramfs_fs.h b/include/linux/cramfs_fs.h
index 1dba681..3be4e5a 100644
--- a/include/linux/cramfs_fs.h
+++ b/include/linux/cramfs_fs.h
@@ -4,6 +4,7 @@
 #include <linux/types.h>
 
 #define CRAMFS_MAGIC		0x28cd3d45	/* some random number */
+#define CRAMFS_MAGIC_WEND	0x453dcd28	/* magic number with the wrong endianess */
 #define CRAMFS_SIGNATURE	"Compressed ROMFS"
 
 /*
