Return-Path: <linux-kernel-owner+w=401wt.eu-S1756164AbZFWGD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164AbZFWGD6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 02:03:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751670AbZFWGDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 02:03:51 -0400
Received: from lon1-post-1.mail.demon.net ([195.173.77.148]:57495 "EHLO
	lon1-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751576AbZFWGDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 02:03:51 -0400
X-Greylist: delayed 3450 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Jun 2009 02:03:50 EDT
To: torvalds@linux-foundation.org, hpa@zytor.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, alain@knaff.lu
Subject: [PATCH 3/3] lzma/gzip: Fix potential oops when input data is truncated
Message-Id: <E1MIyD5-0003bg-Sy@dylan.lougher.demon.co.uk>
From: Phillip Lougher <phillip@lougher.demon.co.uk>
Date: Tue, 23 Jun 2009 06:06:19 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the lzma/gzip decompressors are called with insufficient input
data (len > 0 & fill = NULL), they will attempt to call the fill
function to obtain more data, leading to a kernel oops.

Signed-off-by: Phillip Lougher <phillip@lougher.demon.co.uk>
---
 lib/decompress_inflate.c |    8 ++++++++
 lib/decompress_unlzma.c  |   10 +++++++++-
 2 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/lib/decompress_inflate.c b/lib/decompress_inflate.c
index bfe605a..aeae9ba 100644
--- a/lib/decompress_inflate.c
+++ b/lib/decompress_inflate.c
@@ -27,6 +27,11 @@
 
 #define GZIP_IOBUF_SIZE (16*1024)
 
+static int nofill(void *buffer, unsigned int len)
+{
+	return -1;
+}
+
 /* Included from initramfs et al code */
 STATIC int INIT gunzip(unsigned char *buf, int len,
 		       int(*fill)(void*, unsigned int),
@@ -76,6 +81,9 @@ STATIC int INIT gunzip(unsigned char *buf, int len,
 		goto gunzip_nomem4;
 	}
 
+	if (!fill)
+		fill = nofill;
+
 	if (len == 0)
 		len = fill(zbuf, GZIP_IOBUF_SIZE);
 
diff --git a/lib/decompress_unlzma.c b/lib/decompress_unlzma.c
index d3f9468..08776f3 100644
--- a/lib/decompress_unlzma.c
+++ b/lib/decompress_unlzma.c
@@ -82,6 +82,11 @@ struct rc {
 #define RC_MODEL_TOTAL_BITS 11
 
 
+static int nofill(void *buffer, unsigned int len)
+{
+	return -1;
+}
+
 /* Called twice: once at startup and once in rc_normalize() */
 static void INIT rc_read(struct rc *rc)
 {
@@ -97,7 +102,10 @@ static inline void INIT rc_init(struct rc *rc,
 				       int (*fill)(void*, unsigned int),
 				       char *buffer, int buffer_size)
 {
-	rc->fill = fill;
+	if (fill)
+		rc->fill = fill;
+	else
+		rc->fill = nofill;
 	rc->buffer = (uint8_t *)buffer;
 	rc->buffer_size = buffer_size;
 	rc->buffer_end = rc->buffer + rc->buffer_size;
-- 
1.6.1.2

