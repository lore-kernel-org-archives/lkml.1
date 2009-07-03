Return-Path: <linux-kernel-owner+w=401wt.eu-S1758960AbZGCTTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758960AbZGCTTm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 15:19:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758638AbZGCTTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 15:19:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:46464 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758258AbZGCTTV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 15:19:21 -0400
Date: Fri, 3 Jul 2009 19:18:46 GMT
From: tip-bot for Eric Dumazet <eric.dumazet@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, eric.dumazet@gmail.com,
       a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, efault@gmx.de,
       arnd@arndb.de, dhowells@redhat.com, fweisbec@gmail.com,
       akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, eric.dumazet@gmail.com,
       torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       arnd@arndb.de, fweisbec@gmail.com, dhowells@redhat.com,
       akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4A4E1AA2.30002@gmail.com>
References: <4A4E1AA2.30002@gmail.com>
Subject: [tip:perfcounters/urgent] x86: atomic64: Inline atomic64_read() again
Message-ID: <tip-5fc6406e15d35b99cd19ec5f1da5b3cc326db2e3@git.kernel.org>
Git-Commit-ID: 5fc6406e15d35b99cd19ec5f1da5b3cc326db2e3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 03 Jul 2009 19:18:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5fc6406e15d35b99cd19ec5f1da5b3cc326db2e3
Gitweb:     http://git.kernel.org/tip/5fc6406e15d35b99cd19ec5f1da5b3cc326db2e3
Author:     Eric Dumazet <eric.dumazet@gmail.com>
AuthorDate: Fri, 3 Jul 2009 16:50:10 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 3 Jul 2009 21:16:48 +0200

x86: atomic64: Inline atomic64_read() again

Now atomic64_read() is light weight (no register pressure and
small icache), we can inline it again.

Also use "=&A" constraint instead of "+A" to avoid warning
about unitialized 'res' variable. (gcc had to force 0 in eax/edx)

  $ size vmlinux.prev vmlinux.after
     text    data     bss     dec     hex filename
  4908667  451676 1684868 7045211  6b805b vmlinux.prev
  4908651  451676 1684868 7045195  6b804b vmlinux.after

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>
LKML-Reference: <4A4E1AA2.30002@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/atomic_32.h |   22 ++++++++++++++++++++++
 arch/x86/lib/atomic64_32.c       |   21 ---------------------
 2 files changed, 22 insertions(+), 21 deletions(-)

diff --git a/arch/x86/include/asm/atomic_32.h b/arch/x86/include/asm/atomic_32.h
index d7c8849..dc5a667 100644
--- a/arch/x86/include/asm/atomic_32.h
+++ b/arch/x86/include/asm/atomic_32.h
@@ -295,6 +295,28 @@ extern void atomic64_set(atomic64_t *ptr, u64 new_val);
  *
  * Atomically reads the value of @ptr and returns it.
  */
+static inline u64 atomic64_read(atomic64_t *ptr)
+{
+	u64 res;
+
+	/*
+	 * Note, we inline this atomic64_t primitive because
+	 * it only clobbers EAX/EDX and leaves the others
+	 * untouched. We also (somewhat subtly) rely on the
+	 * fact that cmpxchg8b returns the current 64-bit value
+	 * of the memory location we are touching:
+	 */
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
index 1d98c9e..d79f4ac 100644
--- a/arch/x86/lib/atomic64_32.c
+++ b/arch/x86/lib/atomic64_32.c
@@ -69,28 +69,7 @@ void atomic64_set(atomic64_t *ptr, u64 new_val)
 EXPORT_SYMBOL(atomic64_read);
 
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
 EXPORT_SYMBOL(atomic64_read);
-
-/**
  * atomic64_add_return - add and return
  * @delta: integer value to add
  * @ptr:   pointer to type atomic64_t
