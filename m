Return-Path: <linux-kernel-owner+w=401wt.eu-S935896AbXGZQqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935896AbXGZQqd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 12:46:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764844AbXGZQqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 12:46:24 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48577 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764942AbXGZQqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 12:46:23 -0400
Date: Thu, 26 Jul 2007 17:46:19 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: rmk@arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: [PATCH] arm unaligned.h annotations
Message-ID: <20070726164619.GO27237@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

	Have put_unaligned() warn if types would be wrong
for assignment, slap force-casts where needed.  Cast the
result of get_unaligned to typeof(*ptr).  With that in
place we get proper typechecking, both from gcc and from sparse,
including that for bitwise types.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/include/asm-arm/unaligned.h b/include/asm-arm/unaligned.h
index 795b9e5..8431f6e 100644
--- a/include/asm-arm/unaligned.h
+++ b/include/asm-arm/unaligned.h
@@ -60,24 +60,24 @@ extern int __bug_unaligned_x(const void *ptr);
 		__get_unaligned_4_be((__p+4)))
 
 #define __get_unaligned_le(ptr)						\
-	({								\
+	((__force typeof(*(ptr)))({					\
 		const __u8 *__p = (const __u8 *)(ptr);			\
 		__builtin_choose_expr(sizeof(*(ptr)) == 1, *__p,	\
 		  __builtin_choose_expr(sizeof(*(ptr)) == 2, __get_unaligned_2_le(__p),	\
 		  __builtin_choose_expr(sizeof(*(ptr)) == 4, __get_unaligned_4_le(__p),	\
 		  __builtin_choose_expr(sizeof(*(ptr)) == 8, __get_unaligned_8_le(__p),	\
 		    (void)__bug_unaligned_x(__p)))));			\
-	})
+	}))
 
 #define __get_unaligned_be(ptr)						\
-	({								\
+	((__force typeof(*(ptr)))({					\
 		const __u8 *__p = (const __u8 *)(ptr);			\
 		__builtin_choose_expr(sizeof(*(ptr)) == 1, *__p,	\
 		  __builtin_choose_expr(sizeof(*(ptr)) == 2, __get_unaligned_2_be(__p),	\
 		  __builtin_choose_expr(sizeof(*(ptr)) == 4, __get_unaligned_4_be(__p),	\
 		  __builtin_choose_expr(sizeof(*(ptr)) == 8, __get_unaligned_8_be(__p),	\
 		    (void)__bug_unaligned_x(__p)))));			\
-	})
+	}))
 
 
 static inline void __put_unaligned_2_le(__u32 __v, register __u8 *__p)
@@ -131,15 +131,16 @@ static inline void __put_unaligned_8_be(const unsigned long long __v, register _
  */
 #define __put_unaligned_le(val,ptr)					\
 	({							\
+		(void)sizeof(*(ptr) = (val));			\
 		switch (sizeof(*(ptr))) {			\
 		case 1:						\
 			*(ptr) = (val);				\
 			break;					\
-		case 2: __put_unaligned_2_le((val),(__u8 *)(ptr));	\
+		case 2: __put_unaligned_2_le((__force u16)(val),(__u8 *)(ptr));	\
 			break;					\
-		case 4:	__put_unaligned_4_le((val),(__u8 *)(ptr));	\
+		case 4:	__put_unaligned_4_le((__force u32)(val),(__u8 *)(ptr));	\
 			break;					\
-		case 8:	__put_unaligned_8_le((val),(__u8 *)(ptr)); \
+		case 8:	__put_unaligned_8_le((__force u64)(val),(__u8 *)(ptr)); \
 			break;					\
 		default: __bug_unaligned_x(ptr);		\
 			break;					\
@@ -149,15 +150,16 @@ static inline void __put_unaligned_8_be(const unsigned long long __v, register _
 
 #define __put_unaligned_be(val,ptr)					\
 	({							\
+		(void)sizeof(*(ptr) = (val));			\
 		switch (sizeof(*(ptr))) {			\
 		case 1:						\
 			*(ptr) = (val);				\
 			break;					\
-		case 2: __put_unaligned_2_be((val),(__u8 *)(ptr));	\
+		case 2: __put_unaligned_2_be((__force u16)(val),(__u8 *)(ptr));	\
 			break;					\
-		case 4:	__put_unaligned_4_be((val),(__u8 *)(ptr));	\
+		case 4:	__put_unaligned_4_be((__force u32)(val),(__u8 *)(ptr));	\
 			break;					\
-		case 8:	__put_unaligned_8_be((val),(__u8 *)(ptr)); \
+		case 8:	__put_unaligned_8_be((__force u64)(val),(__u8 *)(ptr)); \
 			break;					\
 		default: __bug_unaligned_x(ptr);		\
 			break;					\
