Return-Path: <linux-kernel-owner+w=401wt.eu-S932733AbXCKCvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932733AbXCKCvi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 21:51:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932759AbXCKCvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 21:51:38 -0500
Received: from ozlabs.org ([203.10.76.45]:36651 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932733AbXCKCvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 21:51:36 -0500
Subject: Re: [PATCH] Use more gcc extensions in the Linux headers
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>
In-Reply-To: <Pine.LNX.4.61.0703100156490.8799@yvahk01.tjqt.qr>
References: <1173419792.32234.131.camel@localhost.localdomain>
	 <1173481052.32234.137.camel@localhost.localdomain>
	 <Pine.LNX.4.61.0703100156490.8799@yvahk01.tjqt.qr>
Content-Type: text/plain
Date: Sun, 11 Mar 2007 13:50:37 +1100
Message-Id: <1173581437.32234.168.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-03-10 at 02:04 +0100, Jan Engelhardt wrote:
> Getting back at the macro, how would you like to have it merged?

Well, this is what I sent to Linus and Andrew (many thanks to those who
made appropriately whimsical *or* useful comments):

diff -r 1ccdf46b0f41 include/linux/compiler-gcc.h
--- a/include/linux/compiler-gcc.h	Sat Mar 10 09:55:29 2007 +1100
+++ b/include/linux/compiler-gcc.h	Sat Mar 10 11:06:35 2007 +1100
@@ -22,6 +22,9 @@
     __asm__ ("" : "=r"(__ptr) : "0"(ptr));		\
     (typeof(ptr)) (__ptr + (off)); })
 
+/* &a[0] degrades to a pointer: a different type from an array */
+#define __must_be_array(a) \
+  BUILD_BUG_ON_ZERO(__builtin_types_compatible_p(typeof(a), typeof(&a[0])))
 
 #define inline		inline		__attribute__((always_inline))
 #define __inline__	__inline__	__attribute__((always_inline))
diff -r 1ccdf46b0f41 include/linux/compiler-intel.h
--- a/include/linux/compiler-intel.h	Sat Mar 10 09:55:29 2007 +1100
+++ b/include/linux/compiler-intel.h	Sat Mar 10 11:06:25 2007 +1100
@@ -21,4 +21,7 @@
      __ptr = (unsigned long) (ptr);				\
     (typeof(ptr)) (__ptr + (off)); })
 
+/* Intel ECC compiler doesn't support __builtin_types_compatible_p() */
+#define __must_be_array(a) 0
+
 #endif
diff -r 1ccdf46b0f41 include/linux/kernel.h
--- a/include/linux/kernel.h	Sat Mar 10 09:55:29 2007 +1100
+++ b/include/linux/kernel.h	Sat Mar 10 11:06:16 2007 +1100
@@ -35,7 +35,8 @@ extern const char linux_proc_banner[];
 #define ALIGN(x,a)		__ALIGN_MASK(x,(typeof(x))(a)-1)
 #define __ALIGN_MASK(x,mask)	(((x)+(mask))&~(mask))
 
-#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
+#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
+
 #define FIELD_SIZEOF(t, f) (sizeof(((t*)0)->f))
 #define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
 #define roundup(x, y) ((((x) + ((y) - 1)) / (y)) * (y))


