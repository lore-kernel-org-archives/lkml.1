Return-Path: <linux-kernel-owner+w=401wt.eu-S1756211AbZFWFEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211AbZFWFEf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 01:04:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752420AbZFWFE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 01:04:28 -0400
Received: from anchor-post-1.mail.demon.net ([195.173.77.132]:57774 "EHLO
	anchor-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751124AbZFWFE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 01:04:28 -0400
To: torvalds@linux-foundation.org, hpa@zytor.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, alain@knaff.lu
Subject: [PATCH 2/3] bzip2/lzma: Remove nasty uncompressed size hack in pre-boot environment
Message-Id: <E1MIyBK-0003bb-Dr@dylan.lougher.demon.co.uk>
From: Phillip Lougher <phillip@lougher.demon.co.uk>
Date: Tue, 23 Jun 2009 06:04:30 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

decompress_bunzip2 and decompress_unlzma have a nasty hack that subtracts
4 from the input length if being called in the pre-boot environment.

This is a nasty hack because it relies on the fact that
flush = NULL only when called from the pre-boot environment
(i.e. arch/x86/boot/compressed/misc.c).  initramfs.c/do_mounts_rd.c pass
in a flush buffer (flush != NULL).

This hack prevents the decompressors from being used with flush = NULL by
other callers unless knowledge of the hack is propagated to them.

This patch removes the hack by making decompress (called only from the
pre-boot environment) a wrapper function that subtracts 4 from the input
length before calling the decompressor.

Signed-off-by: Phillip Lougher <phillip@lougher.demon.co.uk>
---
 lib/decompress_bunzip2.c |   22 ++++++++++++++++------
 lib/decompress_unlzma.c  |   21 ++++++++++++++++-----
 2 files changed, 32 insertions(+), 11 deletions(-)

diff --git a/lib/decompress_bunzip2.c b/lib/decompress_bunzip2.c
index 708e2a8..d3dc9f2 100644
--- a/lib/decompress_bunzip2.c
+++ b/lib/decompress_bunzip2.c
@@ -45,9 +45,11 @@
 */
 
 
-#ifndef STATIC
+#ifdef STATIC
+#define PREBOOT
+#else
 #include <linux/decompress/bunzip2.h>
-#endif /* !STATIC */
+#endif /* STATIC */
 
 #include <linux/decompress/mm.h>
 #include <linux/slab.h>
@@ -681,9 +683,7 @@ STATIC int INIT bunzip2(unsigned char *buf, int len,
 	set_error_fn(error_fn);
 	if (flush)
 		outbuf = malloc(BZIP2_IOBUF_SIZE);
-	else
-		len -= 4; /* Uncompressed size hack active in pre-boot
-			     environment */
+
 	if (!outbuf) {
 		error("Could not allocate output bufer");
 		return -1;
@@ -733,4 +733,14 @@ exit_0:
 	return i;
 }
 
-#define decompress bunzip2
+#ifdef PREBOOT
+STATIC int INIT decompress(unsigned char *buf, int len,
+			int(*fill)(void*, unsigned int),
+			int(*flush)(void*, unsigned int),
+			unsigned char *outbuf,
+			int *pos,
+			void(*error_fn)(char *x))
+{
+	return bunzip2(buf, len - 4, fill, flush, outbuf, pos, error_fn);
+}
+#endif
diff --git a/lib/decompress_unlzma.c b/lib/decompress_unlzma.c
index 32123a1..d3f9468 100644
--- a/lib/decompress_unlzma.c
+++ b/lib/decompress_unlzma.c
@@ -29,7 +29,9 @@
  *Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#ifndef STATIC
+#ifdef STATIC
+#define PREBOOT
+#else
 #include <linux/decompress/unlzma.h>
 #endif /* STATIC */
 
@@ -543,9 +545,7 @@ STATIC inline int INIT unlzma(unsigned char *buf, int in_len,
 	int ret = -1;
 
 	set_error_fn(error_fn);
-	if (!flush)
-		in_len -= 4; /* Uncompressed size hack active in pre-boot
-				environment */
+
 	if (buf)
 		inbuf = buf;
 	else
@@ -645,4 +645,15 @@ exit_0:
 	return ret;
 }
 
-#define decompress unlzma
+#ifdef PREBOOT
+STATIC int INIT decompress(unsigned char *buf, int in_len,
+			      int(*fill)(void*, unsigned int),
+			      int(*flush)(void*, unsigned int),
+			      unsigned char *output,
+			      int *posp,
+			      void(*error_fn)(char *x)
+	)
+{
+	return unlzma(buf, in_len - 4, fill, flush, output, posp, error_fn);
+}
+#endif
-- 
1.6.1.2

