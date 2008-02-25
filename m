Return-Path: <linux-kernel-owner+w=401wt.eu-S1757168AbYBYEn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757168AbYBYEn2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 23:43:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753779AbYBYEnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 23:43:19 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:57381 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361AbYBYEnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 23:43:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=vm8kI5c89o/z5WS6d3/rC5VsmE15P5JlujPrPKvkruEJ3sNEHsIpkTbQDcZ0aGYX5awA0bevKayF9CWW71U+9jX81PcoLjjttQF8yLqLKdIedp3KLhAOICjQZnqcH/Or9ST8Ecn2xbKAdl+4ZvRFrqPPJC+LxCBx3reRgAHJitE=
Subject: [PATCH] video: add a clamp() macro to kernel.h and replace two
	existing defs
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 24 Feb 2008 20:43:23 -0800
Message-Id: <1203914603.1767.25.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clamps a value to be within a given range with strict typechecking.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
akpm: I've submitted a clamp_t version previously for use in libata.
You may want to just roll this into that one so clamp/clamp_t go in
together.

 drivers/media/video/bt8xx/bttvp.h    |    2 --
 drivers/media/video/usbvideo/vicam.c |    6 ------
 include/linux/kernel.h               |   13 +++++++++++++
 3 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/media/video/bt8xx/bttvp.h b/drivers/media/video/bt8xx/bttvp.h
index 1305d31..b38e3a0 100644
--- a/drivers/media/video/bt8xx/bttvp.h
+++ b/drivers/media/video/bt8xx/bttvp.h
@@ -82,8 +82,6 @@
 /* Limits scaled width, which must be a multiple of 4. */
 #define MAX_HACTIVE (0x3FF & -4)
 
-#define clamp(x, low, high) min (max (low, x), high)
-
 #define BTTV_NORMS    (\
 		V4L2_STD_PAL    | V4L2_STD_PAL_N | \
 		V4L2_STD_PAL_Nc | V4L2_STD_SECAM | \
diff --git a/drivers/media/video/usbvideo/vicam.c b/drivers/media/video/usbvideo/vicam.c
index da1ba02..938a60d 100644
--- a/drivers/media/video/usbvideo/vicam.c
+++ b/drivers/media/video/usbvideo/vicam.c
@@ -70,12 +70,6 @@
 
 #define VICAM_HEADER_SIZE       64
 
-#define clamp( x, l, h )        max_t( __typeof__( x ),         \
-				       ( l ),                   \
-				       min_t( __typeof__( x ),  \
-					      ( h ),            \
-					      ( x ) ) )
-
 /* Not sure what all the bytes in these char
  * arrays do, but they're necessary to make
  * the camera work.
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 47924ce..09ee1e0 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -352,6 +352,19 @@ static inline int __attribute__ ((format (printf, 1, 2))) pr_debug(const char *
 	_x > _y ? _x : _y; })
 
 /*
+ * Clamp a value to within a given range with strict type checking
+ */
+#define clamp(val,min,max) ({ \
+	typeof(val) __val = (val); \
+	typeof(min) __min = (min); \
+	typeof(max) __max = (max); \
+	(void) (&__val == &__min); \
+	(void) (&__val == &__max); \
+	__val = __val < __min ? __min: __val; \
+	__val > __max ? __max: __val; })
+
+
+/*
  * ..and if you can't take the strict
  * types, you can specify one yourself.
  *
-- 
1.5.4.2.200.g99e75



