Return-Path: <linux-kernel-owner+w=401wt.eu-S1755600AbYCNFSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600AbYCNFSz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 01:18:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752238AbYCNFSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 01:18:48 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:20739 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585AbYCNFSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 01:18:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=cv5Nn6VvZYjBP4iN0Bd0bn+pK+Zza3Ur36TDt8P9h0s1eTgLhdO4FVisB47Pmqp7CW101AhvnyIB0Od/357PIm4HlhAc9/WKpkkwXbeDSG4qu/KN/vJ9kGHLipPCxXVcRESy76n0xdKt/OZ7z+VxscFNx9CY+qKo4eBvPuWmOoc=
Subject: [PATCH 01/10] Add macros similar to min/max/min_t/max_t.
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 13 Mar 2008 22:18:45 -0700
Message-Id: <1205471926.19712.12.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also, change the variable names used in the min/max macros to avoid shadowed
variable warnings when min/max min_t/max_t are nested.

Small formatting changes to make all the macros have a similar form.

[akpm@linux-foundation.org: coding-style fixes]
[akpm@linux-foundation.org: fix v4l build]
Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
Andrew, I'll send you an incremental patch for the patch in -mm,
this is just so people can see the final form/users.

 drivers/media/video/bt8xx/bttvp.h    |    2 -
 drivers/media/video/usbvideo/vicam.c |    6 ---
 include/linux/kernel.h               |   63 ++++++++++++++++++++++++----------
 3 files changed, 45 insertions(+), 26 deletions(-)

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
index 2df44e7..c74460c 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -335,33 +335,60 @@ static inline int __attribute__ ((format (printf, 1, 2))) pr_debug(const char *
 #endif /* __LITTLE_ENDIAN */
 
 /*
- * min()/max() macros that also do
+ * min()/max()/clamp() macros that also do
  * strict type-checking.. See the
  * "unnecessary" pointer comparison.
  */
-#define min(x,y) ({ \
-	typeof(x) _x = (x);	\
-	typeof(y) _y = (y);	\
-	(void) (&_x == &_y);		\
-	_x < _y ? _x : _y; })
-
-#define max(x,y) ({ \
-	typeof(x) _x = (x);	\
-	typeof(y) _y = (y);	\
-	(void) (&_x == &_y);		\
-	_x > _y ? _x : _y; })
+#define min(x, y) ({				\
+	typeof(x) _min1 = (x);			\
+	typeof(y) _min2 = (y);			\
+	(void) (&_min1 == &_min2);		\
+	_min1 < _min2 ? _min1 : _min2; })
+
+#define max(x, y) ({				\
+	typeof(x) _max1 = (x);			\
+	typeof(y) _max2 = (y);			\
+	(void) (&_max1 == &_max2);		\
+	_max1 > _max2 ? _max1 : _max2; })
+
+#define clamp(val, min, max) ({			\
+	typeof(val) __val = (val);		\
+	typeof(min) __min = (min);		\
+	typeof(max) __max = (max);		\
+	(void) (&__val == &__min);		\
+	(void) (&__val == &__max);		\
+	__val = __val < __min ? __min: __val;	\
+	__val > __max ? __max: __val; })
 
 /*
  * ..and if you can't take the strict
  * types, you can specify one yourself.
  *
- * Or not use min/max at all, of course.
+ * Or not use min/max/clamp at all, of course.
  */
-#define min_t(type,x,y) \
-	({ type __x = (x); type __y = (y); __x < __y ? __x: __y; })
-#define max_t(type,x,y) \
-	({ type __x = (x); type __y = (y); __x > __y ? __x: __y; })
-
+#define min_t(type, x, y) ({			\
+	type __min1 = (x);			\
+	type __min2 = (y);			\
+	__min1 < __min2 ? __min1: __min2; })
+
+#define max_t(type, x, y) ({			\
+	type __max1 = (x);			\
+	type __max2 = (y);			\
+	__max1 > __max2 ? __max1: __max2; })
+
+#define clamp_t(type, val, min, max) ({		\
+	type __val = (val);			\
+	type __min = (min);			\
+	type __max = (max);			\
+	__val = __val < __min ? __min: __val;	\
+	__val > __max ? __max: __val; })
+
+#define clamp_val(val, min, max) ({		\
+	typeof(val) __val = (val);		\
+	typeof(val) __min = (min);		\
+	typeof(val) __max = (max);		\
+	__val = __val < __min ? __min: __val;	\
+	__val > __max ? __max: __val; })
 
 /**
  * container_of - cast a member of a structure out to the containing structure
-- 
1.5.4.4.653.g7cf1e


