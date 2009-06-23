Return-Path: <linux-kernel-owner+w=401wt.eu-S1755688AbZFWFBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755688AbZFWFBS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 01:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753531AbZFWFBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 01:01:05 -0400
Received: from lon1-post-2.mail.demon.net ([195.173.77.149]:36518 "EHLO
	lon1-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751220AbZFWFBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 01:01:05 -0400
To: torvalds@linux-foundation.org, hpa@zytor.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, alain@knaff.lu
Subject: [PATCH 1/3] bzip2/lzma/gzip: Fix comments describing decompressor API
Message-Id: <E1MIy82-0003bQ-DA@dylan.lougher.demon.co.uk>
From: Phillip Lougher <phillip@lougher.demon.co.uk>
Date: Tue, 23 Jun 2009 06:01:06 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix and improve comments in decompress/generic.h that describe the
decompressor API.  Also remove an unused definition, and rename INBUF_LEN
in lib/decompress_inflate.c to conform to bzip2/lzma naming.

Signed-off-by: Phillip Lougher <phillip@lougher.demon.co.uk>
---
 include/linux/decompress/generic.h |   32 +++++++++++++++++++-------------
 lib/decompress_inflate.c           |    8 ++++----
 2 files changed, 23 insertions(+), 17 deletions(-)

diff --git a/include/linux/decompress/generic.h b/include/linux/decompress/generic.h
index 6dfb856..0c7111a 100644
--- a/include/linux/decompress/generic.h
+++ b/include/linux/decompress/generic.h
@@ -1,31 +1,37 @@
 #ifndef DECOMPRESS_GENERIC_H
 #define DECOMPRESS_GENERIC_H
 
-/* Minimal chunksize to be read.
- *Bzip2 prefers at least 4096
- *Lzma prefers 0x10000 */
-#define COMPR_IOBUF_SIZE	4096
-
 typedef int (*decompress_fn) (unsigned char *inbuf, int len,
 			      int(*fill)(void*, unsigned int),
-			      int(*writebb)(void*, unsigned int),
-			      unsigned char *output,
+			      int(*flush)(void*, unsigned int),
+			      unsigned char *outbuf,
 			      int *posp,
 			      void(*error)(char *x));
 
 /* inbuf   - input buffer
  *len     - len of pre-read data in inbuf
- *fill    - function to fill inbuf if empty
- *writebb - function to write out outbug
+ *fill    - function to fill inbuf when empty
+ *flush   - function to write out outbuf
+ *outbuf  - output buffer
  *posp    - if non-null, input position (number of bytes read) will be
  *	  returned here
  *
- *If len != 0, the inbuf is initialized (with as much data), and fill
- *should not be called
- *If len = 0, the inbuf is allocated, but empty. Its size is IOBUF_SIZE
- *fill should be called (repeatedly...) to read data, at most IOBUF_SIZE
+ *If len != 0, inbuf should contain all the necessary input data, and fill
+ *should be NULL
+ *If len = 0, inbuf can be NULL, in which case the decompressor will allocate
+ *the input buffer.  If inbuf != NULL it must be at least XXX_IOBUF_SIZE bytes.
+ *fill will be called (repeatedly...) to read data, at most XXX_IOBUF_SIZE
+ *bytes should be read per call.  Replace XXX with the appropriate decompressor
+ *name, i.e. LZMA_IOBUF_SIZE.
+ *
+ *If flush = NULL, outbuf must be large enough to buffer all the expected
+ *output.  If flush != NULL, the output buffer will be allocated by the
+ *decompressor (outbuf = NULL), and the flush function will be called to
+ *flush the output buffer at the appropriate time (decompressor and stream
+ *dependent).
  */
 
+
 /* Utility routine to detect the decompression method */
 decompress_fn decompress_method(const unsigned char *inbuf, int len,
 				const char **name);
diff --git a/lib/decompress_inflate.c b/lib/decompress_inflate.c
index e36b296..bfe605a 100644
--- a/lib/decompress_inflate.c
+++ b/lib/decompress_inflate.c
@@ -25,7 +25,7 @@
 #include <linux/decompress/mm.h>
 #include <linux/slab.h>
 
-#define INBUF_LEN (16*1024)
+#define GZIP_IOBUF_SIZE (16*1024)
 
 /* Included from initramfs et al code */
 STATIC int INIT gunzip(unsigned char *buf, int len,
@@ -55,7 +55,7 @@ STATIC int INIT gunzip(unsigned char *buf, int len,
 	if (buf)
 		zbuf = buf;
 	else {
-		zbuf = malloc(INBUF_LEN);
+		zbuf = malloc(GZIP_IOBUF_SIZE);
 		len = 0;
 	}
 	if (!zbuf) {
@@ -77,7 +77,7 @@ STATIC int INIT gunzip(unsigned char *buf, int len,
 	}
 
 	if (len == 0)
-		len = fill(zbuf, INBUF_LEN);
+		len = fill(zbuf, GZIP_IOBUF_SIZE);
 
 	/* verify the gzip header */
 	if (len < 10 ||
@@ -113,7 +113,7 @@ STATIC int INIT gunzip(unsigned char *buf, int len,
 	while (rc == Z_OK) {
 		if (strm->avail_in == 0) {
 			/* TODO: handle case where both pos and fill are set */
-			len = fill(zbuf, INBUF_LEN);
+			len = fill(zbuf, GZIP_IOBUF_SIZE);
 			if (len < 0) {
 				rc = -1;
 				error("read error");
-- 
1.6.1.2

