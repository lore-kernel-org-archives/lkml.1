Return-Path: <linux-kernel-owner+w=401wt.eu-S1754459AbYCLQyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754459AbYCLQyo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 12:54:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751797AbYCLQyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 12:54:36 -0400
Received: from rn-out-0910.google.com ([64.233.170.184]:14470 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695AbYCLQyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 12:54:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=KQG9CXncEcGAanimlWwI6NeQZq5b1JjDVjgln6xKVVF+qwYC+25hRSMimJeR4k0ZeIqGO3lfgSNlC3Yc/4D2Vq/2OU3FXdqJztSlK2slONLFoPu+ams0LuhQxO2QJnwj360k3JlDNAis1EJgddlWzMEW/cWd3K4NxOnYJ7oQ+V0=
Subject: Re: [PATCH 1/6] kernel: add clamp(), clamp_t() and clamp_val()
	macros
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jeff@garzik.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
In-Reply-To: <200803121613.09172.mb@bu3sch.de>
References: <1205269894.22317.32.camel@brick>
	 <200803121613.09172.mb@bu3sch.de>
Content-Type: text/plain
Date: Wed, 12 Mar 2008 09:54:26 -0700
Message-Id: <1205340866.8603.9.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-03-12 at 16:13 +0100, Michael Buesch wrote:
> So why not call it clamp_const()?
> One could even use __builtin_constant_p() and make clamp() use
> either clamp_const() or clamp_nonconst() from above automagically.
> I'd prefer that.

Did you mean something like this?  No more clamp_val, just clamp and
clamp_t.  clamp_t forces all the types, clamp looks at the min and max
args, and if they are constants, uses the type of val instead.  If not
a constant, the strict typechecking is done.

From: Harvey Harrison <harvey.harrison@gmail.com>
Subject: [PATCH] kernel: add clamp(), clamp_t() macros

Adds macros similar to min/max/min_t/max_t.

Also, change the variable names used in the min/max macros to
avoid shadowed variable warnings when min/max min_t/max_t are
nested.

Small formatting changes to make all the macros have a similar
form.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/linux/kernel.h |   68 +++++++++++++++++++++++++++++++++++------------
 1 files changed, 50 insertions(+), 18 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 2df44e7..0d4cb5f 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -335,33 +335,65 @@ static inline int __attribute__ ((format (printf, 1, 2))) pr_debug(const char *
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
+#define clamp(val, min, max) ({				\
+	typeof(val) __val = (val);			\
+							\
+	if (__builtin_constant_p(min)) {		\
+		typeof(val) __min = (min);		\
+		__val = __val < __min ? __min: __val;	\
+	} else {					\
+		typeof(min) __min = (min);		\
+		(void) (&__val == &__min);		\
+		__val = __val < __min ? __min: __val;	\
+	}						\
+							\
+	if (__builtin_constant_p(max)) {		\
+		typeof(val) __max = (max);		\
+		__val > __max ? __max: __val;		\
+	} else {					\
+		typeof(max) __max = (max);		\
+		(void) (&__val == &__max);		\
+		__val > __max ? __max: __val;		\
+	} })
 
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
 
 /**
  * container_of - cast a member of a structure out to the containing structure
-- 
1.5.4.4.592.g32d4c



