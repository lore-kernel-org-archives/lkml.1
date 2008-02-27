Return-Path: <linux-kernel-owner+w=401wt.eu-S1754627AbYB0PqL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627AbYB0PqL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 10:46:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751642AbYB0Pp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 10:45:57 -0500
Received: from krynn.se.axis.com ([193.13.178.10]:44119 "EHLO
	krynn.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895AbYB0Ppz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 10:45:55 -0500
Date: Wed, 27 Feb 2008 16:45:41 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] CRIS: Correct usage of __user for copy to and from user space in lib/usercopy and uaccess.h
Message-ID: <20080227154541.GA1644@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function __copy_user_zeroing in arch/lib/usercopy.c had the wrong
parameter set as __user, and in include/asm-cris/uaccess.h, it was
not set at all for some of the calling functions.

This will cut the number of warnings quite dramatically when using sparse.

While we're here, remove useless CVS log and correct confusing typo.
---
 arch/cris/arch-v10/lib/usercopy.c |    2 +-
 arch/cris/arch-v32/lib/usercopy.c |    2 +-
 include/asm-cris/uaccess.h        |   53 ++++++------------------------------
 3 files changed, 11 insertions(+), 46 deletions(-)

diff --git a/arch/cris/arch-v10/lib/usercopy.c b/arch/cris/arch-v10/lib/usercopy.c
index b8e6c04..b0a608d 100644
--- a/arch/cris/arch-v10/lib/usercopy.c
+++ b/arch/cris/arch-v10/lib/usercopy.c
@@ -193,7 +193,7 @@ __copy_user (void __user *pdst, const void *psrc, unsigned long pn)
    inaccessible.  */
 
 unsigned long
-__copy_user_zeroing (void __user *pdst, const void *psrc, unsigned long pn)
+__copy_user_zeroing(void *pdst, const void __user *psrc, unsigned long pn)
 {
   /* We want the parameters put in special registers.
      Make sure the compiler is able to make something useful of this.
diff --git a/arch/cris/arch-v32/lib/usercopy.c b/arch/cris/arch-v32/lib/usercopy.c
index 04d0cf3..0b5b70d 100644
--- a/arch/cris/arch-v32/lib/usercopy.c
+++ b/arch/cris/arch-v32/lib/usercopy.c
@@ -161,7 +161,7 @@ __copy_user (void __user *pdst, const void *psrc, unsigned long pn)
    inaccessible.  */
 
 unsigned long
-__copy_user_zeroing (void __user *pdst, const void *psrc, unsigned long pn)
+__copy_user_zeroing(void *pdst, const void __user *psrc, unsigned long pn)
 {
   /* We want the parameters put in special registers.
      Make sure the compiler is able to make something useful of this.
diff --git a/include/asm-cris/uaccess.h b/include/asm-cris/uaccess.h
index 69d48a2..ea11eaf 100644
--- a/include/asm-cris/uaccess.h
+++ b/include/asm-cris/uaccess.h
@@ -1,43 +1,6 @@
 /* 
  * Authors:    Bjorn Wesen (bjornw@axis.com)
  *	       Hans-Peter Nilsson (hp@axis.com)
- *
- * $Log: uaccess.h,v $
- * Revision 1.8  2001/10/29 13:01:48  bjornw
- * Removed unused variable tmp2 in strnlen_user
- *
- * Revision 1.7  2001/10/02 12:44:52  hp
- * Add support for 64-bit put_user/get_user
- *
- * Revision 1.6  2001/10/01 14:51:17  bjornw
- * Added register prefixes and removed underscores
- *
- * Revision 1.5  2000/10/25 03:33:21  hp
- * - Provide implementation for everything else but get_user and put_user;
- *   copying inline to/from user for constant length 0..16, 20, 24, and
- *   clearing for 0..4, 8, 12, 16, 20, 24, strncpy_from_user and strnlen_user
- *   always inline.
- * - Constraints for destination addr in get_user cannot be memory, only reg.
- * - Correct labels for PC at expected fault points.
- * - Nits with assembly code.
- * - Don't use statement expressions without value; use "do {} while (0)".
- * - Return correct values from __generic_... functions.
- *
- * Revision 1.4  2000/09/12 16:28:25  bjornw
- * * Removed comments from the get/put user asm code
- * * Constrains for destination addr in put_user cannot be memory, only reg
- *
- * Revision 1.3  2000/09/12 14:30:20  bjornw
- * MAX_ADDR_USER does not exist anymore
- *
- * Revision 1.2  2000/07/13 15:52:48  bjornw
- * New user-access functions
- *
- * Revision 1.1.1.1  2000/07/10 16:32:31  bjornw
- * CRIS architecture, working draft
- *
- *
- *
  */
 
 /* Asm:s have been tweaked (within the domain of correctness) to give
@@ -209,9 +172,9 @@ extern long __get_user_bad(void);
 /* More complex functions.  Most are inline, but some call functions that
    live in lib/usercopy.c  */
 
-extern unsigned long __copy_user(void *to, const void *from, unsigned long n);
-extern unsigned long __copy_user_zeroing(void *to, const void *from, unsigned long n);
-extern unsigned long __do_clear_user(void *to, unsigned long n);
+extern unsigned long __copy_user(void __user *to, const void *from, unsigned long n);
+extern unsigned long __copy_user_zeroing(void *to, const void __user *from, unsigned long n);
+extern unsigned long __do_clear_user(void __user *to, unsigned long n);
 
 static inline unsigned long
 __generic_copy_to_user(void __user *to, const void *from, unsigned long n)
@@ -253,7 +216,7 @@ strncpy_from_user(char *dst, const char __user *src, long count)
 }
 
 
-/* Note that if these expand awfully if made into switch constructs, so
+/* Note that these expand awfully if made into switch constructs, so
    don't do that.  */
 
 static inline unsigned long
@@ -407,19 +370,21 @@ __constant_clear_user(void __user *to, unsigned long n)
  */
 
 static inline unsigned long
-__generic_copy_from_user_nocheck(void *to, const void *from, unsigned long n)
+__generic_copy_from_user_nocheck(void *to, const void __user *from,
+				 unsigned long n)
 {
 	return __copy_user_zeroing(to,from,n);
 }
 
 static inline unsigned long
-__generic_copy_to_user_nocheck(void *to, const void *from, unsigned long n)
+__generic_copy_to_user_nocheck(void __user *to, const void *from,
+			       unsigned long n)
 {
 	return __copy_user(to,from,n);
 }
 
 static inline unsigned long
-__generic_clear_user_nocheck(void *to, unsigned long n)
+__generic_clear_user_nocheck(void __user *to, unsigned long n)
 {
 	return __do_clear_user(to,n);
 }
-- 
1.5.4.2.133.g3d51e


/^JN - Jesper Nilsson
--
               Jesper Nilsson -- jesper.nilsson@axis.com
