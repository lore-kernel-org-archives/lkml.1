Return-Path: <linux-kernel-owner+w=401wt.eu-S1763355AbXEPT4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763355AbXEPT4n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 15:56:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759457AbXEPT4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 15:56:24 -0400
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:50646 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758640AbXEPT4X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 15:56:23 -0400
Subject: Re: 2.6.22-rc1-mm1
From: Richard Purdie <rpurdie@openedhand.com>
To: linux-kernel@vger.kernel.org
In-Reply-To: <20070516100632.391f5459.akpm@linux-foundation.org>
References: <20070515201914.16944e04.akpm@linux-foundation.org>
	 <20070516095018.6f0048bc.randy.dunlap@oracle.com>
	 <1179334843.5854.28.camel@localhost.localdomain>
	 <20070516100632.391f5459.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 16 May 2007 20:55:41 +0100
Message-Id: <1179345341.5854.36.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Convert Reiser4 to use lzo implementation in lib/lzo/ instead of
including its own copy of minilzo.

Signed-off-by: Richard Purdie <rpurdie@openedhand.com>

---
[I've removed the deletion of minilzo.* and lzoconf.h from the LKML
version of this mail since its not very interesting]

 fs/reiser4/Kconfig                    |    1 
 fs/reiser4/Makefile                   |    1 
 fs/reiser4/plugin/compress/Makefile   |    1 
 fs/reiser4/plugin/compress/compress.c |   22 
 fs/reiser4/plugin/compress/lzoconf.h  |  216 ---
 fs/reiser4/plugin/compress/minilzo.c  | 1967 ----------------------------------
 fs/reiser4/plugin/compress/minilzo.h  |   70 -
 7 files changed, 10 insertions(+), 2268 deletions(-)

Index: linux-2.6.21/fs/reiser4/Kconfig
===================================================================
--- linux-2.6.21.orig/fs/reiser4/Kconfig	2007-05-16 18:46:01.000000000 +0100
+++ linux-2.6.21/fs/reiser4/Kconfig	2007-05-16 18:49:09.000000000 +0100
@@ -3,6 +3,7 @@ config REISER4_FS
 	depends on EXPERIMENTAL
 	select ZLIB_INFLATE
 	select ZLIB_DEFLATE
+	select LZO
 	select CRYPTO
 	help
 	  Reiser4 is a filesystem that performs all filesystem operations
Index: linux-2.6.21/fs/reiser4/Makefile
===================================================================
--- linux-2.6.21.orig/fs/reiser4/Makefile	2007-05-16 18:46:01.000000000 +0100
+++ linux-2.6.21/fs/reiser4/Makefile	2007-05-16 20:35:48.000000000 +0100
@@ -70,7 +70,6 @@ reiser4-y := \
 		   plugin/crypto/cipher.o \
 		   plugin/crypto/digest.o \
            \
-		   plugin/compress/minilzo.o \
 		   plugin/compress/compress.o \
 		   plugin/compress/compress_mode.o \
            \
Index: linux-2.6.21/fs/reiser4/plugin/compress/Makefile
===================================================================
--- linux-2.6.21.orig/fs/reiser4/plugin/compress/Makefile	2007-05-16 18:46:01.000000000 +0100
+++ linux-2.6.21/fs/reiser4/plugin/compress/Makefile	2007-05-16 18:48:42.000000000 +0100
@@ -2,5 +2,4 @@ obj-$(CONFIG_REISER4_FS) += compress_plu
 
 compress_plugins-objs :=	\
 	compress.o		\
-	minilzo.o		\
 	compress_mode.o
Index: linux-2.6.21/fs/reiser4/plugin/compress/compress.c
===================================================================
--- linux-2.6.21.orig/fs/reiser4/plugin/compress/compress.c	2007-05-16 18:46:01.000000000 +0100
+++ linux-2.6.21/fs/reiser4/plugin/compress/compress.c	2007-05-16 20:47:45.000000000 +0100
@@ -4,8 +4,8 @@
 #include "../../debug.h"
 #include "../../inode.h"
 #include "../plugin.h"
-#include "minilzo.h"
 
+#include <linux/lzo.h>
 #include <linux/zlib.h>
 #include <linux/types.h>
 #include <linux/hardirq.h>
@@ -226,11 +226,7 @@ gzip1_decompress(coa_t coa, __u8 * src_f
 
 static int lzo1_init(void)
 {
-	int ret;
-	ret = lzo_init();
-	if (ret != LZO_E_OK)
-		warning("edward-848", "lzo_init() failed with ret = %d\n", ret);
-	return ret;
+	return 0;
 }
 
 static int lzo1_overrun(unsigned in_len)
@@ -238,9 +234,6 @@ static int lzo1_overrun(unsigned in_len)
 	return in_len / 64 + 16 + 3;
 }
 
-#define LZO_HEAP_SIZE(size) \
-	sizeof(lzo_align_t) * (((size) + (sizeof(lzo_align_t) - 1)) / sizeof(lzo_align_t))
-
 static coa_t lzo1_alloc(tfm_action act)
 {
 	int ret = 0;
@@ -248,12 +241,12 @@ static coa_t lzo1_alloc(tfm_action act)
 
 	switch (act) {
 	case TFMA_WRITE:	/* compress */
-		coa = reiser4_vmalloc(LZO_HEAP_SIZE(LZO1X_1_MEM_COMPRESS));
+		coa = reiser4_vmalloc(LZO1X_1_MEM_COMPRESS);
 		if (!coa) {
 			ret = -ENOMEM;
 			break;
 		}
-		memset(coa, 0, LZO_HEAP_SIZE(LZO1X_1_MEM_COMPRESS));
+		memset(coa, 0, LZO1X_1_MEM_COMPRESS);
 	case TFMA_READ:		/* decompress */
 		break;
 	default:
@@ -295,12 +288,13 @@ static void
 lzo1_compress(coa_t coa, __u8 * src_first, unsigned src_len,
 	      __u8 * dst_first, unsigned *dst_len)
 {
+	unsigned long dstlen = *dst_len;
 	int result;
 
 	assert("edward-846", coa != NULL);
 	assert("edward-847", src_len != 0);
 
-	result = lzo1x_1_compress(src_first, src_len, dst_first, dst_len, coa);
+	result = lzo1x_1_compress(src_first, src_len, dst_first, &dstlen, coa);
 	if (result != LZO_E_OK) {
 		warning("edward-849", "lzo1x_1_compress failed\n");
 		goto out;
@@ -319,14 +313,16 @@ static void
 lzo1_decompress(coa_t coa, __u8 * src_first, unsigned src_len,
 		__u8 * dst_first, unsigned *dst_len)
 {
+	unsigned long dstlen = *dst_len;
 	int result;
 
 	assert("edward-851", coa == NULL);
 	assert("edward-852", src_len != 0);
 
-	result = lzo1x_decompress(src_first, src_len, dst_first, dst_len, NULL);
+	result = lzo1x_decompress(src_first, src_len, dst_first, &dstlen, NULL);
 	if (result != LZO_E_OK)
 		warning("edward-853", "lzo1x_1_decompress failed\n");
+	*dst_len = dstlen;
 	return;
 }
 


