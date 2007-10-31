Return-Path: <linux-kernel-owner+w=401wt.eu-S1759189AbXJaAkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759189AbXJaAkZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 20:40:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753044AbXJaAkM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 20:40:12 -0400
Received: from mx3.palmsource.com ([12.7.175.31]:57589 "EHLO
	mx3.access-company.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752914AbXJaAkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 20:40:10 -0400
Subject: Re: [PATCH 1/2 ] Add support LZO in cramfs
From: vince kim <vince.kim@access-company.com>
Reply-To: vince.kim@access-company.com
To: Michael Tokarev <mjt@tls.msk.ru>, Vince Kim <Vince.Kim@access-company.com>
Cc: linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@openedhand.com>
In-Reply-To: <1193683508.27074.19.camel@vince-desktop>
References: <1193441153.17726.17.camel@vince-desktop>
	 <47230059.80202@msgid.tls.msk.ru> <1193683508.27074.19.camel@vince-desktop>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: ACCESS-AMERICA
Date: Tue, 30 Oct 2007 17:39:08 -0700
Message-Id: <1193791148.29935.8.camel@vince-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
X-Proofpoint-Virus-Version: vendor=fsecure engine=4.65.5502:2.3.11,1.2.37,4.0.164 definitions=2007-10-30_04:2007-10-30,2007-10-30,2007-10-30 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx engine=3.1.0-0708230000 definitions=main-0710300193
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The function pointer cramfs_uncompress_block is added inside the
cramfs_sb_info struct, so each mountpoint has its own
cramfs_uncompress_block depends on compression type.

I did some test, and verified multiple cramfs images mounted
successfully regardless of compression(either ZLIB or LZO).

Here is the patch.

diff -Naur linux-2.6.23/fs/cramfs/inode.c linux-2.6.23_cramfs_lzo/fs/cramfs/inode.c
--- linux-2.6.23/fs/cramfs/inode.c	2007-10-09 13:31:38.000000000 -0700
+++ linux-2.6.23_cramfs_lzo/fs/cramfs/inode.c	2007-10-30 17:15:34.000000000 -0700
@@ -274,7 +274,17 @@
 		printk(KERN_ERR "cramfs: unsupported filesystem features\n");
 		goto out;
 	}
-
+	
+	/* check flag to see if LZO compression is used */
+	if (super.flags & CRAMFS_FLAG_LZO_COMPRESSION) {
+		sbi->cramfs_uncompress_block = &cramfs_uncompress_block_lzo;
+		printk("cramfs: LZO compression\n");
+	}
+	else {
+		sbi->cramfs_uncompress_block = &cramfs_uncompress_block_zlib;
+		printk("cramfs: ZLIB compression\n");
+	}
+	
 	/* Check that the root inode is in a sane state */
 	if (!S_ISDIR(super.root.mode)) {
 		printk(KERN_ERR "cramfs: root is not a directory\n");
@@ -486,7 +496,7 @@
 			printk(KERN_ERR "cramfs: bad compressed blocksize %u\n", compr_len);
 		else {
 			mutex_lock(&read_mutex);
-			bytes_filled = cramfs_uncompress_block(pgdata,
+			bytes_filled = ((struct cramfs_sb_info *)(sb->s_fs_info))->cramfs_uncompress_block(pgdata,
 				 PAGE_CACHE_SIZE,
 				 cramfs_read(sb, start_offset, compr_len),
 				 compr_len);
diff -Naur linux-2.6.23/fs/cramfs/uncompress.c linux-2.6.23_cramfs_lzo/fs/cramfs/uncompress.c
--- linux-2.6.23/fs/cramfs/uncompress.c	2007-10-09 13:31:38.000000000 -0700
+++ linux-2.6.23_cramfs_lzo/fs/cramfs/uncompress.c	2007-10-26 14:19:01.000000000 -0700
@@ -20,12 +20,16 @@
 #include <linux/vmalloc.h>
 #include <linux/zlib.h>
 #include <linux/cramfs_fs.h>
+#include <linux/lzo.h>
 
 static z_stream stream;
 static int initialized;
 
-/* Returns length of decompressed data. */
-int cramfs_uncompress_block(void *dst, int dstlen, void *src, int srclen)
+/* 
+ * uncompress with ZLIB
+ * Returns length of decompressed data. 
+ */
+int cramfs_uncompress_block_zlib(void *dst, int dstlen, void *src, int srclen)
 {
 	int err;
 
@@ -48,7 +52,26 @@
 	return stream.total_out;
 
 err:
-	printk("Error %d while decompressing!\n", err);
+	printk("ZLIB Error %d while decompressing!\n", err);
+	printk("%p(%d)->%p(%d)\n", src, srclen, dst, dstlen);
+	return 0;
+}
+
+/* 
+ * uncompress with LZO
+ * Returns length of decompressed data. 
+ */
+int cramfs_uncompress_block_lzo(void *dst, int dstlen, void *src, int srclen)
+{
+	int err;
+
+	err = lzo1x_decompress_safe(src,srclen,dst,(unsigned int *)&dstlen);
+        if (err != LZO_E_OK)
+                goto err;
+        return dstlen;
+
+err:
+	printk("LZO Error %d while decompressing!\n", err);
 	printk("%p(%d)->%p(%d)\n", src, srclen, dst, dstlen);
 	return 0;
 }
diff -Naur linux-2.6.23/fs/Kconfig linux-2.6.23_cramfs_lzo/fs/Kconfig
--- linux-2.6.23/fs/Kconfig	2007-10-09 13:31:38.000000000 -0700
+++ linux-2.6.23_cramfs_lzo/fs/Kconfig	2007-10-26 14:19:01.000000000 -0700
@@ -1348,6 +1348,7 @@
 	tristate "Compressed ROM file system support (cramfs)"
 	depends on BLOCK
 	select ZLIB_INFLATE
+	select LZO_DECOMPRESS
 	help
 	  Saying Y here includes support for CramFs (Compressed ROM File
 	  System).  CramFs is designed to be a simple, small, and compressed
diff -Naur linux-2.6.23/include/linux/cramfs_fs.h linux-2.6.23_cramfs_lzo/include/linux/cramfs_fs.h
--- linux-2.6.23/include/linux/cramfs_fs.h	2007-10-09 13:31:38.000000000 -0700
+++ linux-2.6.23_cramfs_lzo/include/linux/cramfs_fs.h	2007-10-26 14:19:01.000000000 -0700
@@ -73,6 +73,7 @@
 #define CRAMFS_FLAG_HOLES		0x00000100	/* support for holes */
 #define CRAMFS_FLAG_WRONG_SIGNATURE	0x00000200	/* reserved */
 #define CRAMFS_FLAG_SHIFTED_ROOT_OFFSET	0x00000400	/* shifted root fs */
+#define CRAMFS_FLAG_LZO_COMPRESSION	0x00000800	/* LZO compression is used */
 
 /*
  * Valid values in super.flags.  Currently we refuse to mount
@@ -82,11 +83,16 @@
 #define CRAMFS_SUPPORTED_FLAGS	( 0x000000ff \
 				| CRAMFS_FLAG_HOLES \
 				| CRAMFS_FLAG_WRONG_SIGNATURE \
-				| CRAMFS_FLAG_SHIFTED_ROOT_OFFSET )
+				| CRAMFS_FLAG_SHIFTED_ROOT_OFFSET \
+				| CRAMFS_FLAG_LZO_COMPRESSION )
+
+/* function pointer for uncompress function */
 
 /* Uncompression interfaces to the underlying zlib */
-int cramfs_uncompress_block(void *dst, int dstlen, void *src, int srclen);
+int cramfs_uncompress_block_zlib(void *dst, int dstlen, void *src, int srclen);
 int cramfs_uncompress_init(void);
 void cramfs_uncompress_exit(void);
 
+/* Uncompression interfaces to the underlying lzo */
+int cramfs_uncompress_block_lzo(void *dst, int dstlen, void *src, int srclen);
 #endif
diff -Naur linux-2.6.23/include/linux/cramfs_fs_sb.h linux-2.6.23_cramfs_lzo/include/linux/cramfs_fs_sb.h
--- linux-2.6.23/include/linux/cramfs_fs_sb.h	2007-10-09 13:31:38.000000000 -0700
+++ linux-2.6.23_cramfs_lzo/include/linux/cramfs_fs_sb.h	2007-10-30 17:17:19.000000000 -0700
@@ -10,6 +10,8 @@
 			unsigned long blocks;
 			unsigned long files;
 			unsigned long flags;
+			/* function pointer to uncompress block */
+			int (* cramfs_uncompress_block) (void *dst, int dstlen, void *src, int srclen);
 };
 
 static inline struct cramfs_sb_info *CRAMFS_SB(struct super_block *sb)


On Mon, 2007-10-29 at 11:45 -0700, vince kim wrote:
> Thanks for your comment.
> I can't hardly imagine there would be a lot of cases to mount two
> different images with different compression, but if they did, then they
> would not work at the same time.
> 
> For modular decompression, it would be out of my scope to modularize lzo
> or zlib. I will think about anyway.
> 
> I used Evolution to submit patch, and it word-wrapped the patch.
> 
> This must be clean.
> 
> diff -Naur linux-2.6.23/fs/cramfs/inode.c linux-2.6.23_cramfs_lzo/fs/cramfs/inode.c
> --- linux-2.6.23/fs/cramfs/inode.c	2007-10-09 13:31:38.000000000 -0700
> +++ linux-2.6.23_cramfs_lzo/fs/cramfs/inode.c	2007-10-26 14:35:59.000000000 -0700
> @@ -31,6 +31,8 @@
>  static const struct inode_operations cramfs_dir_inode_operations;
>  static const struct file_operations cramfs_directory_operations;
>  static const struct address_space_operations cramfs_aops;
> +/* function pointer to uncompress block */
> +static int (* cramfs_uncompress_block) (void *dst, int dstlen, void *src, int srclen);
>  
>  static DEFINE_MUTEX(read_mutex);
>  
> @@ -274,7 +276,17 @@
>  		printk(KERN_ERR "cramfs: unsupported filesystem features\n");
>  		goto out;
>  	}
> -
> +	
> +	/* check flag to see if LZO compression is used */
> +	if (super.flags & CRAMFS_FLAG_LZO_COMPRESSION) {
> +		cramfs_uncompress_block = &cramfs_uncompress_block_lzo;
> +		printk("cramfs: LZO compression\n");
> +	}
> +	else {
> +		cramfs_uncompress_block = &cramfs_uncompress_block_zlib;
> +		printk("cramfs: ZLIB compression\n");
> +	}
> +	
>  	/* Check that the root inode is in a sane state */
>  	if (!S_ISDIR(super.root.mode)) {
>  		printk(KERN_ERR "cramfs: root is not a directory\n");
> diff -Naur linux-2.6.23/fs/cramfs/uncompress.c linux-2.6.23_cramfs_lzo/fs/cramfs/uncompress.c
> --- linux-2.6.23/fs/cramfs/uncompress.c	2007-10-09 13:31:38.000000000 -0700
> +++ linux-2.6.23_cramfs_lzo/fs/cramfs/uncompress.c	2007-10-26 14:19:01.000000000 -0700
> @@ -20,12 +20,16 @@
>  #include <linux/vmalloc.h>
>  #include <linux/zlib.h>
>  #include <linux/cramfs_fs.h>
> +#include <linux/lzo.h>
>  
>  static z_stream stream;
>  static int initialized;
>  
> -/* Returns length of decompressed data. */
> -int cramfs_uncompress_block(void *dst, int dstlen, void *src, int srclen)
> +/* 
> + * uncompress with ZLIB
> + * Returns length of decompressed data. 
> + */
> +int cramfs_uncompress_block_zlib(void *dst, int dstlen, void *src, int srclen)
>  {
>  	int err;
>  
> @@ -48,7 +52,26 @@
>  	return stream.total_out;
>  
>  err:
> -	printk("Error %d while decompressing!\n", err);
> +	printk("ZLIB Error %d while decompressing!\n", err);
> +	printk("%p(%d)->%p(%d)\n", src, srclen, dst, dstlen);
> +	return 0;
> +}
> +
> +/* 
> + * uncompress with LZO
> + * Returns length of decompressed data. 
> + */
> +int cramfs_uncompress_block_lzo(void *dst, int dstlen, void *src, int srclen)
> +{
> +	int err;
> +
> +	err = lzo1x_decompress_safe(src,srclen,dst,(unsigned int *)&dstlen);
> +        if (err != LZO_E_OK)
> +                goto err;
> +        return dstlen;
> +
> +err:
> +	printk("LZO Error %d while decompressing!\n", err);
>  	printk("%p(%d)->%p(%d)\n", src, srclen, dst, dstlen);
>  	return 0;
>  }
> diff -Naur linux-2.6.23/fs/Kconfig linux-2.6.23_cramfs_lzo/fs/Kconfig
> --- linux-2.6.23/fs/Kconfig	2007-10-09 13:31:38.000000000 -0700
> +++ linux-2.6.23_cramfs_lzo/fs/Kconfig	2007-10-26 14:19:01.000000000 -0700
> @@ -1348,6 +1348,7 @@
>  	tristate "Compressed ROM file system support (cramfs)"
>  	depends on BLOCK
>  	select ZLIB_INFLATE
> +	select LZO_DECOMPRESS
>  	help
>  	  Saying Y here includes support for CramFs (Compressed ROM File
>  	  System).  CramFs is designed to be a simple, small, and compressed
> diff -Naur linux-2.6.23/include/linux/cramfs_fs.h linux-2.6.23_cramfs_lzo/include/linux/cramfs_fs.h
> --- linux-2.6.23/include/linux/cramfs_fs.h	2007-10-09 13:31:38.000000000 -0700
> +++ linux-2.6.23_cramfs_lzo/include/linux/cramfs_fs.h	2007-10-26 14:19:01.000000000 -0700
> @@ -73,6 +73,7 @@
>  #define CRAMFS_FLAG_HOLES		0x00000100	/* support for holes */
>  #define CRAMFS_FLAG_WRONG_SIGNATURE	0x00000200	/* reserved */
>  #define CRAMFS_FLAG_SHIFTED_ROOT_OFFSET	0x00000400	/* shifted root fs */
> +#define CRAMFS_FLAG_LZO_COMPRESSION	0x00000800	/* LZO compression is used */
>  
>  /*
>   * Valid values in super.flags.  Currently we refuse to mount
> @@ -82,11 +83,16 @@
>  #define CRAMFS_SUPPORTED_FLAGS	( 0x000000ff \
>  				| CRAMFS_FLAG_HOLES \
>  				| CRAMFS_FLAG_WRONG_SIGNATURE \
> -				| CRAMFS_FLAG_SHIFTED_ROOT_OFFSET )
> +				| CRAMFS_FLAG_SHIFTED_ROOT_OFFSET \
> +				| CRAMFS_FLAG_LZO_COMPRESSION )
> +
> +/* function pointer for uncompress function */
>  
>  /* Uncompression interfaces to the underlying zlib */
> -int cramfs_uncompress_block(void *dst, int dstlen, void *src, int srclen);
> +int cramfs_uncompress_block_zlib(void *dst, int dstlen, void *src, int srclen);
>  int cramfs_uncompress_init(void);
>  void cramfs_uncompress_exit(void);
>  
> +/* Uncompression interfaces to the underlying lzo */
> +int cramfs_uncompress_block_lzo(void *dst, int dstlen, void *src, int srclen);
>  #endif
> 
> 
>   
> 
> On Sat, 2007-10-27 at 13:09 +0400, Michael Tokarev wrote:
> > vince kim wrote:
> > > This is a kernel patch to add support LZO compression in cramfs. 
> > []
> > > --- linux-2.6.23/fs/cramfs/inode.c      2007-10-09 13:31:38.000000000 -0700
> > > +++ linux-2.6.23_cramfs_lzo/fs/cramfs/inode.c    2007-10-26 14:35:59.000000000 -0700
> > > @@ -31,6 +31,8 @@
> > >  static const struct inode_operations cramfs_dir_inode_operations;
> > >  static const struct file_operations cramfs_directory_operations;
> > >  static const struct address_space_operations cramfs_aops; 
> > > +/* function pointer to uncompress block */
> > > +static int (* cramfs_uncompress_block) (void *dst, int dstlen, void *src, int srclen);
> > 
> > Shouldn't this pointer be mountpoint-specific?  I mean,
> > if I've two cramfs images, one using zlib and another
> > using lzo, the two will not work at the same time.
> > 
> > []
> > > --- linux-2.6.23/fs/Kconfig     2007-10-09 13:31:38.000000000 -0700
> > > +++ linux-2.6.23_cramfs_lzo/fs/Kconfig  2007-10-26 14:19:01.000000000 -0700
> > > @@ -1348,6 +1348,7 @@
> > >         tristate "Compressed ROM file system support (cramfs)" 
> > >         depends on BLOCK
> > >         select ZLIB_INFLATE
> > > +       select LZO_DECOMPRESS
> > >         help
> > >           Saying Y here includes support for CramFs (Compressed ROM File
> > >           System).  CramFs is designed to be a simple, small, and compressed 
> > 
> > Hmm.  How about using modular decompressor? I mean,
> > it isn't really necessary for a given config to handle
> > both lzo- and zlib-compressed cramfs images, only one
> > may be needed, so the other compression library becomes
> > a useless dependency.  This is especially important for
> > embedded environments where memory/disk space is limited.
> > Since you're using a pointer-to-function anyway, it can
> > be done fully dynamically, by requesting a module to de-
> > compress the thing at runtime.  Pretty much like it's
> > done f.e. in crypto/ipsec layer currently.
> > 
> > By the way, your patch is word-wrapped.
> > 
> > /mjt
