Return-Path: <linux-kernel-owner+w=401wt.eu-S1764117AbYD0UTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764117AbYD0UTx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 16:19:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759636AbYD0UTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 16:19:45 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:42885 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759528AbYD0UTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 16:19:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=YF6G24w53K9PTfoOaPdaLbZdEyl116Oa6JitI+iXYt6uXzXjqdv1VtVvw6Dfvy+ZHbJUL4fhwTANQPgP8UERO8hrjWD6Ybq4hhxfutY181EkNSDtauuG+yzwcKmYFYtOsgrw8INwkb5RVIaflrxlHGBOUCxn8ikeDoFTeCHNwX8=
Subject: [PATCH] bitops: simplify generic bit finding functions
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 27 Apr 2008 13:19:51 -0700
Message-Id: <1209327591.14173.74.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need for a sentinal if we explicitly catch the no bits/all bits set
cases, make it clear they are special cases returning size/BITS_PER_LONG.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/linux/bitops.h |   93 ++++++++++++++++++++----------------------------
 1 files changed, 39 insertions(+), 54 deletions(-)

diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index 48bde60..d9eb58a 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -127,18 +127,17 @@ extern unsigned long __find_first_bit(const unsigned long *addr,
 static __always_inline unsigned long
 find_first_bit(const unsigned long *addr, unsigned long size)
 {
-	/* Avoid a function call if the bitmap size is a constant */
-	/* and not bigger than BITS_PER_LONG. */
-
-	/* insert a sentinel so that __ffs returns size if there */
-	/* are no set bits in the bitmap */
-	if (__builtin_constant_p(size) && (size < BITS_PER_LONG))
-		return __ffs((*addr) | (1ul << size));
-
-	/* the result of __ffs(0) is undefined, so it needs to be */
-	/* handled separately */
-	if (__builtin_constant_p(size) && (size == BITS_PER_LONG))
-		return ((*addr) == 0) ? BITS_PER_LONG : __ffs(*addr);
+	/*
+	 * Avoid a function call if the bitmap size is a constant and not
+	 * bigger than BITS_PER_LONG.  Ensure we return size if there are
+	 * no set bits.
+	 */
+	if (__builtin_constant_p(size) && (size <= BITS_PER_LONG)) {
+		if (*addr == 0)
+			return (size < BITS_PER_LONG) ? size : BITS_PER_LONG;
+		else
+			return __ffs(*addr);
+	}
 
 	/* size is not constant or too big */
 	return __find_first_bit(addr, size);
@@ -157,20 +156,17 @@ extern unsigned long __find_first_zero_bit(const unsigned long *addr,
 static __always_inline unsigned long
 find_first_zero_bit(const unsigned long *addr, unsigned long size)
 {
-	/* Avoid a function call if the bitmap size is a constant */
-	/* and not bigger than BITS_PER_LONG. */
-
-	/* insert a sentinel so that __ffs returns size if there */
-	/* are no set bits in the bitmap */
-	if (__builtin_constant_p(size) && (size < BITS_PER_LONG)) {
-		return __ffs(~(*addr) | (1ul << size));
+	/*
+	 * Avoid a function call if the bitmap size is a constant and not
+	 * bigger than BITS_PER_LONG.  Ensure we return size if all bits set.
+	 */
+	if (__builtin_constant_p(size) && (size <= BITS_PER_LONG)) {
+		if ((~(*addr)) == 0)
+			return (size < BITS_PER_LONG) ? size : BITS_PER_LONG;
+		else
+			return __ffs(~(*addr));
 	}
 
-	/* the result of __ffs(0) is undefined, so it needs to be */
-	/* handled separately */
-	if (__builtin_constant_p(size) && (size == BITS_PER_LONG))
-		return (~(*addr) == 0) ? BITS_PER_LONG : __ffs(~(*addr));
-
 	/* size is not constant or too big */
 	return __find_first_zero_bit(addr, size);
 }
@@ -192,22 +188,17 @@ find_next_bit(const unsigned long *addr, unsigned long size,
 {
 	unsigned long value;
 
-	/* Avoid a function call if the bitmap size is a constant */
-	/* and not bigger than BITS_PER_LONG. */
-
-	/* insert a sentinel so that __ffs returns size if there */
-	/* are no set bits in the bitmap */
-	if (__builtin_constant_p(size) && (size < BITS_PER_LONG)) {
+	/*
+	 * Avoid a function call if the bitmap size is a constant and not
+	 * bigger than BITS_PER_LONG.  Ensure we return size if there are
+	 * no set bits.
+	 */
+	if (__builtin_constant_p(size) && (size <= BITS_PER_LONG)) {
 		value = (*addr) & ((~0ul) << offset);
-		value |= (1ul << size);
-		return __ffs(value);
-	}
-
-	/* the result of __ffs(0) is undefined, so it needs to be */
-	/* handled separately */
-	if (__builtin_constant_p(size) && (size == BITS_PER_LONG)) {
-		value = (*addr) & ((~0ul) << offset);
-		return (value == 0) ? BITS_PER_LONG : __ffs(value);
+		if (value == 0)
+			return (size < BITS_PER_LONG) ? size : BITS_PER_LONG;
+		else
+			return __ffs(value);
 	}
 
 	/* size is not constant or too big */
@@ -229,22 +220,16 @@ find_next_zero_bit(const unsigned long *addr, unsigned long size,
 {
 	unsigned long value;
 
-	/* Avoid a function call if the bitmap size is a constant */
-	/* and not bigger than BITS_PER_LONG. */
-
-	/* insert a sentinel so that __ffs returns size if there */
-	/* are no set bits in the bitmap */
-	if (__builtin_constant_p(size) && (size < BITS_PER_LONG)) {
-		value = (~(*addr)) & ((~0ul) << offset);
-		value |= (1ul << size);
-		return __ffs(value);
-	}
-
-	/* the result of __ffs(0) is undefined, so it needs to be */
-	/* handled separately */
-	if (__builtin_constant_p(size) && (size == BITS_PER_LONG)) {
+	/*
+	 * Avoid a function call if the bitmap size is a constant and not
+	 * bigger than BITS_PER_LONG.  Ensure we return size if all bits set.
+	 */
+	if (__builtin_constant_p(size) && (size <= BITS_PER_LONG)) {
 		value = (~(*addr)) & ((~0ul) << offset);
-		return (value == 0) ? BITS_PER_LONG : __ffs(value);
+		if (value == 0)
+			return (size < BITS_PER_LONG) ? size : BITS_PER_LONG;
+		else
+			return __ffs(value);
 	}
 
 	/* size is not constant or too big */
-- 
1.5.5.1.270.g89765



