Return-Path: <linux-kernel-owner+w=401wt.eu-S1765731AbXJZXjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765731AbXJZXjn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 19:39:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761990AbXJZXir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 19:38:47 -0400
Received: from mx3.palmsource.com ([12.7.175.31]:58110 "EHLO
	mx3.access-company.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757910AbXJZXin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 19:38:43 -0400
Subject: [PATCH 1/2 ] Add support LZO in cramfs
From: vince kim <vince.kim@access-company.com>
Reply-To: vince.kim@access-company.com
To: Vince Kim <Vince.Kim@access-company.com>, linux-kernel@vger.kernel.org
Cc: "Richard Purdie [rpurdie"@openedhand.com
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: ACCESS-AMERICA
Date: Fri, 26 Oct 2007 16:25:53 -0700
Message-Id: <1193441153.17726.17.camel@vince-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
X-Proofpoint-Virus-Version: vendor=fsecure engine=4.65.5502:2.3.11,1.2.37,4.0.164 definitions=2007-10-26_10:2007-10-26,2007-10-26,2007-10-26 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=2 spamscore=2 ipscore=0 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx engine=3.1.0-0708230000 definitions=main-0710260095
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a kernel patch to add support LZO compression in cramfs. 
I used LZO kernel library patch done by Richard Purdie
[rpurdie@openedhand.com], and my cramfs patch requires his LZO library
patch.
Richard's LZO kernel library patch can be found at:
http://lwn.net/Articles/238723/

This patch is generated against 2.6.23.

We had some performance gain with cramfs using LZO compression, but the
cramfs image size has been increased by around 10%.
So, if performance is higher priority, you could try this patch.

I will post separate patch for mkcramfs tool to generate cramfs image
using LZO compression.

Thanks,

Vince Kyong-jin Kim [vince.kim@access-company.com]

 
diff -Naur linux-2.6.23/fs/cramfs/inode.c
linux-2.6.23_cramfs_lzo/fs/cramfs/inode.c
--- linux-2.6.23/fs/cramfs/inode.c      2007-10-09 13:31:38.000000000
-0700
+++ linux-2.6.23_cramfs_lzo/fs/cramfs/inode.c    2007-10-26
14:35:59.000000000 -0700
@@ -31,6 +31,8 @@
 static const struct inode_operations cramfs_dir_inode_operations;
 static const struct file_operations cramfs_directory_operations;
 static const struct address_space_operations cramfs_aops; 
+/* function pointer to uncompress block */
+static int (* cramfs_uncompress_block) (void *dst, int dstlen, void
*src, int srclen);

 static DEFINE_MUTEX(read_mutex);

@@ -274,7 +276,17 @@
                printk(KERN_ERR "cramfs: unsupported filesystem features
\n"); 
                goto out;
        }
-
+
+       /* check flag to see if LZO compression is used */
+       if (super.flags & CRAMFS_FLAG_LZO_COMPRESSION) {
+               cramfs_uncompress_block = &cramfs_uncompress_block_lzo; 
+               printk("cramfs: LZO compression\n");
+       }
+       else {
+               cramfs_uncompress_block = &cramfs_uncompress_block_zlib;
+               printk("cramfs: ZLIB compression\n"); 
+       }
+
        /* Check that the root inode is in a sane state */
        if (!S_ISDIR(super.root.mode)) {
                printk(KERN_ERR "cramfs: root is not a directory\n");
diff -Naur linux-2.6.23/fs/cramfs/uncompress.c
linux-2.6.23_cramfs_lzo/fs/cramfs/uncompress.c
--- linux-2.6.23/fs/cramfs/uncompress.c 2007-10-09 13:31:38.000000000
-0700
+++ linux-2.6.23_cramfs_lzo/fs/cramfs/uncompress.c      2007-10-26
14:19: 01.000000000 -0700
@@ -20,12 +20,16 @@
 #include <linux/vmalloc.h>
 #include <linux/zlib.h>
 #include <linux/cramfs_fs.h>
+#include <linux/lzo.h>

 static z_stream stream;
 static int initialized; 

-/* Returns length of decompressed data. */
-int cramfs_uncompress_block(void *dst, int dstlen, void *src, int
srclen)
+/*
+ * uncompress with ZLIB
+ * Returns length of decompressed data.
+ */
+int cramfs_uncompress_block_zlib(void *dst, int dstlen, void *src, int
srclen) 
 {
        int err;

@@ -48,7 +52,26 @@
        return stream.total_out;

 err:
-       printk("Error %d while decompressing!\n", err);
+       printk("ZLIB Error %d while decompressing!\n", err); 
+       printk("%p(%d)->%p(%d)\n", src, srclen, dst, dstlen);
+       return 0;
+}
+
+/*
+ * uncompress with LZO
+ * Returns length of decompressed data.
+ */
+int cramfs_uncompress_block_lzo(void *dst, int dstlen, void *src, int
srclen) 
+{
+       int err;
+
+       err = lzo1x_decompress_safe(src,srclen,dst,(unsigned int
*)&dstlen);
+        if (err != LZO_E_OK)
+                goto err;
+        return dstlen;
+
+err:
+       printk("LZO Error %d while decompressing!\n", err);
        printk("%p(%d)->%p(%d)\n", src, srclen, dst, dstlen);
        return 0;
 }
diff -Naur linux-2.6.23/fs/Kconfig linux-2.6.23_cramfs_lzo/fs/Kconfig 
--- linux-2.6.23/fs/Kconfig     2007-10-09 13:31:38.000000000 -0700
+++ linux-2.6.23_cramfs_lzo/fs/Kconfig  2007-10-26 14:19:01.000000000
-0700
@@ -1348,6 +1348,7 @@
        tristate "Compressed ROM file system support (cramfs)" 
        depends on BLOCK
        select ZLIB_INFLATE
+       select LZO_DECOMPRESS
        help
          Saying Y here includes support for CramFs (Compressed ROM File
          System).  CramFs is designed to be a simple, small, and
compressed 
diff -Naur linux-2.6.23/include/linux/cramfs_fs.h
linux-2.6.23_cramfs_lzo/include/linux/cramfs_fs.h
--- linux-2.6.23/include/linux/cramfs_fs.h      2007-10-09
13:31:38.000000000 -0700
+++ linux-2.6.23_cramfs_lzo/include/linux/cramfs_fs.h    2007-10-26
14:19:01.000000000 -0700
@@ -73,6 +73,7 @@
 #define CRAMFS_FLAG_HOLES              0x00000100      /* support for
holes */
 #define CRAMFS_FLAG_WRONG_SIGNATURE    0x00000200      /* reserved */
 #define CRAMFS_FLAG_SHIFTED_ROOT_OFFSET        0x00000400      /*
shifted root fs */ 
+#define CRAMFS_FLAG_LZO_COMPRESSION    0x00000800      /* LZO
compression is used */

 /*
  * Valid values in super.flags.  Currently we refuse to mount
@@ -82,11 +83,16 @@
 #define CRAMFS_SUPPORTED_FLAGS ( 0x000000ff \ 
                                | CRAMFS_FLAG_HOLES \
                                | CRAMFS_FLAG_WRONG_SIGNATURE \
-                               | CRAMFS_FLAG_SHIFTED_ROOT_OFFSET )
+                               | CRAMFS_FLAG_SHIFTED_ROOT_OFFSET \ 
+                               | CRAMFS_FLAG_LZO_COMPRESSION )
+
+/* function pointer for uncompress function */

 /* Uncompression interfaces to the underlying zlib */
-int cramfs_uncompress_block(void *dst, int dstlen, void *src, int
srclen); 
+int cramfs_uncompress_block_zlib(void *dst, int dstlen, void *src, int
srclen);
 int cramfs_uncompress_init(void);
 void cramfs_uncompress_exit(void);

+/* Uncompression interfaces to the underlying lzo */ 
+int cramfs_uncompress_block_lzo(void *dst, int dstlen, void *src, int
srclen);
 #endif











