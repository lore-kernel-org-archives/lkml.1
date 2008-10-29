Return-Path: <linux-kernel-owner+w=401wt.eu-S1754851AbYJ2Qcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851AbYJ2Qcw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 12:32:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754326AbYJ2Qci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 12:32:38 -0400
Received: from ti-out-0910.google.com ([209.85.142.188]:31146 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754204AbYJ2Qch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 12:32:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=l5JgapT8pGFCJjEkqI5EoJBWdEqVb0q9w2UB1sbpKsc4L2dOhvpx4LMq9OHxnRYVTB
         9Cm9k2n3JKjhSguPODGWbuUeYTrZe/XqzrrnB7XwM51U6Y62EA+mKY9xCcIxMET05Ath
         qZI/c/9V2KunDeCBX1iykyKsfhwqc+hz6XT7g=
From: Jike Song <albcamus@gmail.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, Jike Song <albcamus@gmail.com>
Subject: [PATCH] x86: fix inline assembly constraints
Date: Thu, 30 Oct 2008 00:32:17 +0800
Message-Id: <1225297937-2917-2-git-send-email-albcamus@gmail.com>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <1225297937-2917-1-git-send-email-albcamus@gmail.com>
References: <1225297937-2917-1-git-send-email-albcamus@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In atomic_set_mask, *addr should be both read and written.

Signed-off-by: Jike Song <albcamus@gmail.com>
---
 arch/x86/include/asm/atomic_32.h |    8 ++++----
 arch/x86/include/asm/atomic_64.h |    7 ++++---
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/atomic_32.h b/arch/x86/include/asm/atomic_32.h
index ad5b9f6..23a7c7f 100644
--- a/arch/x86/include/asm/atomic_32.h
+++ b/arch/x86/include/asm/atomic_32.h
@@ -242,12 +242,12 @@ static inline int atomic_add_unless(atomic_t *v, int a, int u)
 
 /* These are x86-specific, used by some header files */
 #define atomic_clear_mask(mask, addr)				\
-	asm volatile(LOCK_PREFIX "andl %0,%1"			\
-		     : : "r" (~(mask)), "m" (*(addr)) : "memory")
+	asm volatile(LOCK_PREFIX "andl %1, %0"			\
+		     : "+m" (*(addr)) : "r" (~(mask)) : "memory")
 
 #define atomic_set_mask(mask, addr)				\
-	asm volatile(LOCK_PREFIX "orl %0,%1"				\
-		     : : "r" (mask), "m" (*(addr)) : "memory")
+	asm volatile(LOCK_PREFIX "orl %1, %0"			\
+		     : "+m" (*(addr)) : "r" (mask) : "memory")
 
 /* Atomic operations are already serializing on x86 */
 #define smp_mb__before_atomic_dec()	barrier()
diff --git a/arch/x86/include/asm/atomic_64.h b/arch/x86/include/asm/atomic_64.h
index fa59212..31b34f3 100644
--- a/arch/x86/include/asm/atomic_64.h
+++ b/arch/x86/include/asm/atomic_64.h
@@ -451,12 +451,13 @@ static inline void atomic_or_long(unsigned long *v1, unsigned long v2)
 
 /* These are x86-specific, used by some header files */
 #define atomic_clear_mask(mask, addr)					\
-	asm volatile(LOCK_PREFIX "andl %0,%1"				\
-		     : : "r" (~(mask)), "m" (*(addr)) : "memory")
+	asm volatile(LOCK_PREFIX "andl %1, %0"				\
+		     : "+m" (*(addr)) : "r" (~(mask)) : "memory")
 
 #define atomic_set_mask(mask, addr)					\
-	asm volatile(LOCK_PREFIX "orl %0,%1"				\
+	asm volatile(LOCK_PREFIX "orl %1, %0"				\
 		     : : "r" ((unsigned)(mask)), "m" (*(addr))		\
+		     : "+m" (*(addr)) : "r" ((unsigned)(mask))		\
 		     : "memory")
 
 /* Atomic operations are already serializing on x86 */
-- 
1.6.0.1

