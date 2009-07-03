Return-Path: <linux-kernel-owner+w=401wt.eu-S1757890AbZGCOu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757890AbZGCOu3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 10:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753950AbZGCOuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 10:50:22 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:42314 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936AbZGCOuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 10:50:22 -0400
Message-ID: <4A4E1AA2.30002@gmail.com>
Date: Fri, 03 Jul 2009 16:50:10 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: mingo@redhat.com
CC: linux-kernel@vger.kernel.org
Subject: [PATCH -tip] x86: atomic64: inline atomic64_read() 
References: <alpine.LFD.2.01.0907021653030.3210@localhost.localdomain> <tip-9103cab145a93cef13378632b332a824758a2f6f@git.kernel.org>
In-Reply-To: <tip-9103cab145a93cef13378632b332a824758a2f6f@git.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Fri, 03 Jul 2009 16:50:10 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now atomic64_read() is light weight (no register pressure and
small icache), we can inline it again.

Also use "=&A" constraint instead of "+A" to avoid warning
about unitialized 'res' variable. (gcc had to force 0 in eax/edx)


$ size vmlinux.prev vmlinux.after
   text    data     bss     dec     hex filename
4908667  451676 1684868 7045211  6b805b vmlinux.prev
4908651  451676 1684868 7045195  6b804b vmlinux.after

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
 arch/x86/include/asm/atomic_32.h |   15 +++++++++++++++
 arch/x86/lib/atomic64_32.c       |   21 ---------------------
 2 files changed, 15 insertions(+), 21 deletions(-)

diff --git a/arch/x86/include/asm/atomic_32.h b/arch/x86/include/asm/atomic_32.h
index aa045de..0332041 100644
--- a/arch/x86/include/asm/atomic_32.h
+++ b/arch/x86/include/asm/atomic_32.h
@@ -304,6 +304,21 @@ extern void atomic64_set(atomic64_t *ptr, u64 new_val);
  *
  * Atomically reads the value of @ptr and returns it.
  */
+static inline u64 atomic64_read(atomic64_t *ptr)
+{
+	u64 res;
+
+	asm volatile(
+		"mov %%ebx, %%eax\n\t"
+		"mov %%ecx, %%edx\n\t"
+		LOCK_PREFIX "cmpxchg8b %1\n"
+			: "=&A" (res)
+			: "m" (*ptr) 
+		);
+
+	return res;
+}
+
 extern u64 atomic64_read(atomic64_t *ptr);
 
 /**
diff --git a/arch/x86/lib/atomic64_32.c b/arch/x86/lib/atomic64_32.c
index cd11803..cb51226 100644
--- a/arch/x86/lib/atomic64_32.c
+++ b/arch/x86/lib/atomic64_32.c
@@ -55,27 +55,6 @@ void atomic64_set(atomic64_t *ptr, u64 new_val)
 }
 
 /**
- * atomic64_read - read atomic64 variable
- * @ptr:      pointer to type atomic64_t
- *
- * Atomically reads the value of @ptr and returns it.
- */
-u64 atomic64_read(atomic64_t *ptr)
-{
-	u64 res;
-
-	asm volatile(
-		"mov %%ebx, %%eax\n\t"
-		"mov %%ecx, %%edx\n\t"
-		LOCK_PREFIX "cmpxchg8b %1\n"
-			: "+A" (res)
-			: "m" (*ptr)
-		);
-
-	return res;
-}
-
-/**
  * atomic64_add_return - add and return
  * @delta: integer value to add
  * @ptr:   pointer to type atomic64_t
