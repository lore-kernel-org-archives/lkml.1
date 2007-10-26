Return-Path: <linux-kernel-owner+w=401wt.eu-S1761963AbXJZXjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761963AbXJZXjQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 19:39:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761482AbXJZXiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 19:38:46 -0400
Received: from mx3.palmsource.com ([12.7.175.31]:58109 "EHLO
	mx3.access-company.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757782AbXJZXin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 19:38:43 -0400
X-Greylist: delayed 664 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Oct 2007 19:38:43 EDT
Subject: [PATCH 2/2 ] Add support LZO in mkcramfs tool
From: vince kim <vince.kim@access-company.com>
Reply-To: vince.kim@access-company.com
To: Vince Kim <Vince.Kim@access-company.com>, linux-kernel@vger.kernel.org
Cc: "Richard Purdie [rpurdie"@openedhand.com
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: ACCESS-AMERICA
Date: Fri, 26 Oct 2007 16:26:00 -0700
Message-Id: <1193441160.17726.18.camel@vince-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
X-Proofpoint-Virus-Version: vendor=fsecure engine=4.65.5502:2.3.11,1.2.37,4.0.164 definitions=2007-10-26_10:2007-10-26,2007-10-26,2007-10-26 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx engine=3.1.0-0708230000 definitions=main-0710260095
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support LZO compression in mkcramfs tool, so it can
generate a cramfs image compress with LZO.
To compile mkcramfs with this patch, liblzo2-dev package must be
installed.

The patch is created against mkcramfs tool ver 1.1 which can be found
at:
http://sourceforge.net/projects/cramfs/

I added command line option "-l" , so to create a cramfs image with LZO
compression, "-l" must be specified at the command line. 

Of course, separate kernel patch is required to mount cramfs image
compressed with LZO
.
Thanks,

Vince Kyong-jin Kim

diff -Naur cramfs-1.1/GNUmakefile cramfs-1.1_lzo/GNUmakefile
--- cramfs-1.1 /GNUmakefile      2002-02-22 16:52:41.000000000 -0800
+++ cramfs-1.1_lzo/GNUmakefile  2007-10-26 13:38:01.000000000 -0700
@@ -1,12 +1,15 @@
CC = gcc
CFLAGS = -W -Wall -O2 -g
CPPFLAGS = -I.
-LDLIBS = -lz 
+LDLIBS = -lz -llzo2
PROGS = mkcramfs cramfsck

all: $(PROGS)

+mkcramfs: lzo_compress.o
+
+
distclean clean:
-       rm -f $(PROGS)
+       rm -f $(PROGS) *.o

.PHONY: all clean 
diff -Naur cramfs-1.1/linux/cramfs_fs.h cramfs-1.1_lzo/linux/cramfs_fs.h
--- cramfs-1.1/linux/cramfs_fs.h        2002-02-20 00:03:32.000000000
-0800
+++ cramfs-1.1_lzo/linux/cramfs_fs.h    2007-10-26 13:38:01.000000000
-0700
@@ -79,6 +79,7 @@
#define CRAMFS_FLAG_HOLES              0x00000100      /* support for
holes */
#define CRAMFS_FLAG_WRONG_SIGNATURE    0x00000200      /* reserved */
#define CRAMFS_FLAG_SHIFTED_ROOT_OFFSET        0x00000400      /*
shifted root fs */ 
+#define CRAMFS_FLAG_LZO_COMPRESSION     0x00000800     /* LZO
compression is used */

/*
  * Valid values in super.flags.  Currently we refuse to mount
@@ -88,11 +89,17 @@
#define CRAMFS_SUPPORTED_FLAGS ( 0x000000ff \ 
                                | CRAMFS_FLAG_HOLES \
                                | CRAMFS_FLAG_WRONG_SIGNATURE \
-                               | CRAMFS_FLAG_SHIFTED_ROOT_OFFSET )
+                               | CRAMFS_FLAG_SHIFTED_ROOT_OFFSET \ 
+                               | CRAMFS_FLAG_LZO_COMPRESSION )
+
+/* function pointer for uncompress function */
+int (* cramfs_uncompress_block) ();

/* Uncompression interfaces to the underlying zlib */ 
-int cramfs_uncompress_block(void *dst, int dstlen, void *src, int
srclen);
+int cramfs_uncompress_block_zlib(void *dst, int dstlen, void *src, int
srclen);
int cramfs_uncompress_init(void);
int cramfs_uncompress_exit(void); 

+/* Uncompression interfaces to the underlying lzo */
+int cramfs_uncompress_block_lzo(void *dst, int dstlen, void *src, int
srclen);
#endif
diff -Naur cramfs-1.1/lzo_compress.c cramfs-1.1_lzo/lzo_compress.c 
--- cramfs-1.1/lzo_compress.c   1969-12-31 16:00:00.000000000 -0800
+++ cramfs-1.1_lzo/lzo_compress.c       2007-10-26 13:58:38.000000000
-0700
@@ -0,0 +1,54 @@
+#include <stdio.h>
+#include <stdint.h >
+#include <asm/types.h>
+#include <lzo/lzo1x.h>
+
+
+extern void *lzo_mem;
+extern void *lzo_compress_buf;
+extern int page_size;
+
+int cramfs_lzo_cmpr(unsigned char *data_in, unsigned char *cpage_out, 
+                         uint32_t sourcelen, uint32_t *dstlen)
+{
+       uint32_t compress_size;
+       int ret;
+
+
+       ret = lzo1x_999_compress(data_in, sourcelen, (void
*)lzo_compress_buf, &compress_size, (void *)lzo_mem); 
+
+       if (ret != LZO_E_OK || compress_size > *dstlen )
+               return -1;
+
+       memcpy(cpage_out, (void *)lzo_compress_buf, compress_size);
+       *dstlen = compress_size;
+
+       return 0; 
+
+}
+
+int cramfs_lzo_init(void)
+{
+       lzo_mem = malloc(LZO1X_999_MEM_COMPRESS);
+       if (!lzo_mem)
+               return -1;
+
+       /* Worst case LZO compression size from their FAQ */ 
+
+       lzo_compress_buf = malloc(page_size + (page_size / 64) + 16 +
3);
+       if (!lzo_compress_buf) {
+               free(lzo_mem);
+               lzo_mem = NULL;
+               return -1;
+       }
+
+       return 0;
+}
+
+void cramfs_lzo_exit(void)
+{
+       free(lzo_compress_buf);
+       free(lzo_mem);
+}
+
+
diff -Naur cramfs-1.1/mkcramfs.c cramfs-1.1_lzo/mkcramfs.c 
--- cramfs-1.1/mkcramfs.c       2002-02-20 00:03:32.000000000 -0800
+++ cramfs-1.1_lzo/mkcramfs.c   2007-10-26 13:57:15.000000000 -0700
@@ -76,6 +76,11 @@
static long total_blocks = 0, total_nodes = 1; /* pre-count the root
node */ 
static int image_length = 0;

+/* For LZO compression */
+void *lzo_mem = NULL;
+void *lzo_compress_buf = NULL;
+int page_size = PAGE_CACHE_SIZE;
+
/*
  * If opt_holes is set, then mkcramfs can create explicit holes in the 
  * data, which saves 26 bytes per hole (which is a lot smaller a
@@ -91,6 +96,7 @@
static int opt_holes = 0;
static int opt_pad = 0;
static int opt_verbose = 0;
+static int opt_lzo = 0;
static char *opt_image = NULL; 
static char *opt_name = NULL;

@@ -128,6 +134,7 @@
                " -E         make all warnings errors (non-zero exit
status)\n"
                " -e edition set edition number (part of fsid)\n" 
                " -i file    insert a file image into the filesystem
(requires >= 2.4.0)\n"
+               " -l         use LZO compression instead of ZLIB\n"
                " -n name    set name of cramfs filesystem\n" 
                " -p         pad by %d bytes for boot code\n"
                " -s         sort directory entries (old option,
ignored)\n"
@@ -153,6 +160,10 @@
        }
        fprintf(stderr, "\n"); 
        va_end(arg_ptr);
+       if (lzo_compress_buf)
+               free(lzo_compress_buf);
+       if (lzo_mem)
+               free(lzo_mem);
        exit(status);
}

@@ -386,6 +397,8 @@
                super->flags |= CRAMFS_FLAG_HOLES;
        if (image_length > 0)
                super->flags |= CRAMFS_FLAG_SHIFTED_ROOT_OFFSET;
+       if (opt_lzo)
+               super->flags |= CRAMFS_FLAG_LZO_COMPRESSION; 
        super->size = size;
        memcpy(super->signature, CRAMFS_SIGNATURE,
sizeof(super->signature));

@@ -595,9 +608,18 @@
                        input = blksize;
                size -= input; 
                if (!(opt_holes && is_zero (uncompressed, input))) {
-                       err = compress2(base + curr, &len, uncompressed,
input, Z_BEST_COMPRESSION);
-                       if (err != Z_OK) { 
-                               die(MKFS_ERROR, 0, "compression error: %
s", zError(err));
+                       if (opt_lzo) {
+                               /* Use LZO compression */
+                               err= cramfs_lzo_cmpr(uncompressed,base +
curr,input, &len); 
+                               if (err < 0)
+                                       die(MKFS_ERROR, 0, "LZO
compression error: %s");
+                       }
+                       else {
+                               /* Use default ZLIB compression */ 
+                               err = compress2(base + curr, &len,
uncompressed, input, Z_BEST_COMPRESSION);
+                               if (err != Z_OK) {
+                                       die(MKFS_ERROR, 0, "compression
error: %s", zError(err)); 
+                               }
                        }
                        curr += len;
                }
@@ -699,7 +721,7 @@
                progname = argv[0];

        /* command line options */ 
-       while ((c = getopt(argc, argv, "hEe:i:n:psvz")) != EOF) {
+       while ((c = getopt(argc, argv, "hEe:i:ln:psvz")) != EOF) {
                switch (c) {
                case 'h': 
                        usage(MKFS_OK);
@@ -720,6 +742,10 @@
                        image_length = st.st_size; /* may be padded
later */
                        fslen_ub += (image_length + 3); /* 3 is for
padding */ 
                        break;
+               case 'l':
+                       opt_lzo = 1;
+                       printf("LZO compression is used istead of ZLIB
\n");
+                       break; 
                case 'n':
                        opt_name = optarg;
                        break;
@@ -751,7 +777,11 @@
        if (fd < 0) {
                die(MKFS_USAGE, 1, "open failed: %s", outfile); 
        }
-
+       if (opt_lzo) {
+
+               if ( cramfs_lzo_init() < 0 )
+                       die(MKFS_ERROR, 1, "cramfs_lzo_init failed");
+       }
        root_entry = calloc(1, sizeof(struct entry)); 
        if (!root_entry) {
                die(MKFS_ERROR, 1, "calloc failed");
@@ -867,7 +897,8 @@
        if (opt_errors &&
            (warn_namelen||warn_skip||warn_size||warn_uid||warn_gid||
warn_dev)) 
                exit(MKFS_ERROR);
-
+       if (opt_lzo)
+               cramfs_lzo_exit();
        exit(MKFS_OK);
}

