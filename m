Return-Path: <linux-kernel-owner+w=401wt.eu-S1760176AbYB0W0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760176AbYB0W0A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 17:26:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754648AbYB0WZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 17:25:52 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:38649 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020AbYB0WZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 17:25:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=I5PeHqn51hOoawYJU0RgTMKZ5+Hp+1Vp93DtAZGAAWuoXHpjzaD9zAd/ttmM2ydq6RzpPo11xKE/LvcqixDKzoMPxUnBHAawElObIqPLcWS1iDrReYv4tPhlKVxStulUuKsMdNSiTFNNJ3m5U9LMD8aSz8tF8Kx+t9VLAYIMh6w=
Subject: [PATCH] kernel: add clamp() and clamp_t() macros
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 27 Feb 2008 14:25:48 -0800
Message-Id: <1204151148.20280.12.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds macros similar to min/max/min_t/max_t.

Also, change the variable names used in the min/max macros to
avoid shadowed variable warnings when min/max min_t/max_t are
nested.

Small formatting changes to make all the macros have a similar
form.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Andrew, here's a cleanup of the max/min macros and the introduction
of a clamp/clamp_t macro.  There are users for this in libata (the
FIX macro you've already seen) and in drivers/media which is rolling
its own.

 include/linux/kernel.h |   56 ++++++++++++++++++++++++++++++++---------------
 1 files changed, 38 insertions(+), 18 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 2df44e7..265f0bd 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -335,33 +335,53 @@ static inline int __attribute__ ((format (printf, 1, 2))) pr_debug(const char *
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
+#define min(x,y) ({				\
+	typeof(x) _min1 = (x);			\
+	typeof(y) _min2 = (y);			\
+	(void) (&_min1 == &_min2);		\
+	_min1 < _min2 ? _min1 : _min2; })
+
+#define max(x,y) ({				\
+	typeof(x) _max1 = (x);			\
+	typeof(y) _max2 = (y);			\
+	(void) (&_max1 == &_max2);		\
+	_max1 > _max2 ? _max1 : _max2; })
+
+#define clamp(val,min,max) ({			\
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
+#define min_t(type,x,y) ({			\
+	type __min1 = (x);			\
+	type __min2 = (y);			\
+	__min1 < __min2 ? __min1: __min2; })
+
+#define max_t(type,x,y) ({			\
+	type __max1 = (x);			\
+	type __max2 = (y);			\
+	__max1 > __max2 ? __max1: __max2; })
+
+#define clamp_t(type,val,min,max) ({		\
+	type __val = (val);			\
+	type __min = (min);			\
+	type __max = (max);			\
+	__val = __val < __min ? __min: __val;	\
+	__val > __max ? __max: __val; })
 
 /**
  * container_of - cast a member of a structure out to the containing structure
-- 
1.5.4.3.342.g99e8


