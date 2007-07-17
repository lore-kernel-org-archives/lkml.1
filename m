Return-Path: <linux-kernel-owner+w=401wt.eu-S932300AbXGQHur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932300AbXGQHur (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 03:50:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757553AbXGQHtj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 03:49:39 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50990 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755666AbXGQHtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 03:49:36 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] saner typechecking in generic unaligned.h
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Message-Id: <E1IAhoN-0001ij-Ry@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Tue, 17 Jul 2007 08:49:35 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Verify that types would match for assignment (under sizeof, so we are safe from
side effects or any code actually getting generated), then explicitly cast
everywhere to the fixed-sized types.  Kills a bunch of bogus warnings about
constants being truncated (gcc, sparse), finds a pile of endianness problems
hidden by old noise (sparse).

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 include/asm-generic/unaligned.h |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/include/asm-generic/unaligned.h b/include/asm-generic/unaligned.h
index 09ec447..16a466e 100644
--- a/include/asm-generic/unaligned.h
+++ b/include/asm-generic/unaligned.h
@@ -18,7 +18,8 @@
 #define get_unaligned(ptr) \
 	__get_unaligned((ptr), sizeof(*(ptr)))
 #define put_unaligned(x,ptr) \
-	__put_unaligned((__u64)(x), (ptr), sizeof(*(ptr)))
+	((void)sizeof(*(ptr)=(x)),\
+	__put_unaligned((__force __u64)(x), (ptr), sizeof(*(ptr))))
 
 /*
  * This function doesn't actually exist.  The idea is that when
@@ -95,21 +96,21 @@ static inline void __ustw(__u16 val, __u16 *addr)
 	default:				\
 		bad_unaligned_access_length();	\
 	};					\
-	(__typeof__(*(ptr)))val;		\
+	(__force __typeof__(*(ptr)))val;	\
 })
 
 #define __put_unaligned(val, ptr, size)		\
-do {						\
+({						\
 	void *__gu_p = ptr;			\
 	switch (size) {				\
 	case 1:					\
-		*(__u8 *)__gu_p = val;		\
+		*(__u8 *)__gu_p = (__force __u8)val;		\
 	        break;				\
 	case 2:					\
-		__ustw(val, __gu_p);		\
+		__ustw((__force __u16)val, __gu_p);		\
 		break;				\
 	case 4:					\
-		__ustl(val, __gu_p);		\
+		__ustl((__force __u32)val, __gu_p);		\
 		break;				\
 	case 8:					\
 		__ustq(val, __gu_p);		\
@@ -117,6 +118,7 @@ do {						\
 	default:				\
 	    	bad_unaligned_access_length();	\
 	};					\
-} while(0)
+	(void)0;				\
+})
 
 #endif /* _ASM_GENERIC_UNALIGNED_H */
-- 
1.5.3.GIT


