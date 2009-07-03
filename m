Return-Path: <linux-kernel-owner+w=401wt.eu-S1757738AbZGCPeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757738AbZGCPeg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 11:34:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756270AbZGCPe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 11:34:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:47192 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756126AbZGCPe1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 11:34:27 -0400
Date: Fri, 3 Jul 2009 15:33:35 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
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
In-Reply-To: <alpine.LFD.2.01.0907021653030.3210@localhost.localdomain>
References: <alpine.LFD.2.01.0907021653030.3210@localhost.localdomain>
Subject: [tip:perfcounters/urgent] x86: atomic64: Export APIs to modules
Message-ID: <tip-05118ab8859492ac9ddda0154cf90e37b0a4a0b0@git.kernel.org>
Git-Commit-ID: 05118ab8859492ac9ddda0154cf90e37b0a4a0b0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 03 Jul 2009 15:33:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  05118ab8859492ac9ddda0154cf90e37b0a4a0b0
Gitweb:     http://git.kernel.org/tip/05118ab8859492ac9ddda0154cf90e37b0a4a0b0
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Fri, 3 Jul 2009 17:28:57 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 3 Jul 2009 17:28:57 +0200

x86: atomic64: Export APIs to modules

atomic64_t primitives are used by a handful of drivers,
so export the APIs consistently. These were inlined
before.

Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>
LKML-Reference: <alpine.LFD.2.01.0907021653030.3210@localhost.localdomain>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/lib/atomic64_32.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/lib/atomic64_32.c b/arch/x86/lib/atomic64_32.c
index fd28fd3..cd11803 100644
--- a/arch/x86/lib/atomic64_32.c
+++ b/arch/x86/lib/atomic64_32.c
@@ -62,9 +62,17 @@ void atomic64_set(atomic64_t *ptr, u64 new_val)
  */
 u64 atomic64_read(atomic64_t *ptr)
 {
-	u64 old = 1LL << 32;
+	u64 res;

-	return cmpxchg8b(&ptr->counter, old, old);
+	asm volatile(
+		"mov %%ebx, %%eax\n\t"
+		"mov %%ecx, %%edx\n\t"
+		LOCK_PREFIX "cmpxchg8b %1\n"
+			: "+A" (res)
+			: "m" (*ptr)
+		);
+
+	return res;
 }

 /**


---
 arch/x86/lib/atomic64_32.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/arch/x86/lib/atomic64_32.c b/arch/x86/lib/atomic64_32.c
index cd11803..aab898c 100644
--- a/arch/x86/lib/atomic64_32.c
+++ b/arch/x86/lib/atomic64_32.c
@@ -21,6 +21,7 @@ u64 atomic64_cmpxchg(atomic64_t *ptr, u64 old_val, u64 new_val)
 {
 	return cmpxchg8b(&ptr->counter, old_val, new_val);
 }
+EXPORT_SYMBOL(atomic64_cmpxchg);
 
 /**
  * atomic64_xchg - xchg atomic64 variable
@@ -41,6 +42,7 @@ u64 atomic64_xchg(atomic64_t *ptr, u64 new_val)
 
 	return old_val;
 }
+EXPORT_SYMBOL(atomic64_xchg);
 
 /**
  * atomic64_set - set atomic64 variable
@@ -53,6 +55,7 @@ void atomic64_set(atomic64_t *ptr, u64 new_val)
 {
 	atomic64_xchg(ptr, new_val);
 }
+EXPORT_SYMBOL(atomic64_read);
 
 /**
  * atomic64_read - read atomic64 variable
@@ -74,6 +77,7 @@ u64 atomic64_read(atomic64_t *ptr)
 
 	return res;
 }
+EXPORT_SYMBOL(atomic64_read);
 
 /**
  * atomic64_add_return - add and return
@@ -103,21 +107,25 @@ noinline u64 atomic64_add_return(u64 delta, atomic64_t *ptr)
 
 	return new_val;
 }
+EXPORT_SYMBOL(atomic64_add_return);
 
 u64 atomic64_sub_return(u64 delta, atomic64_t *ptr)
 {
 	return atomic64_add_return(-delta, ptr);
 }
+EXPORT_SYMBOL(atomic64_sub_return);
 
 u64 atomic64_inc_return(atomic64_t *ptr)
 {
 	return atomic64_add_return(1, ptr);
 }
+EXPORT_SYMBOL(atomic64_inc_return);
 
 u64 atomic64_dec_return(atomic64_t *ptr)
 {
 	return atomic64_sub_return(1, ptr);
 }
+EXPORT_SYMBOL(atomic64_dec_return);
 
 /**
  * atomic64_add - add integer to atomic64 variable
@@ -130,6 +138,7 @@ void atomic64_add(u64 delta, atomic64_t *ptr)
 {
 	atomic64_add_return(delta, ptr);
 }
+EXPORT_SYMBOL(atomic64_add);
 
 /**
  * atomic64_sub - subtract the atomic64 variable
@@ -142,6 +151,7 @@ void atomic64_sub(u64 delta, atomic64_t *ptr)
 {
 	atomic64_add(-delta, ptr);
 }
+EXPORT_SYMBOL(atomic64_sub);
 
 /**
  * atomic64_sub_and_test - subtract value from variable and test result
@@ -158,6 +168,7 @@ int atomic64_sub_and_test(u64 delta, atomic64_t *ptr)
 
 	return old_val == 0;
 }
+EXPORT_SYMBOL(atomic64_sub_and_test);
 
 /**
  * atomic64_inc - increment atomic64 variable
@@ -169,6 +180,7 @@ void atomic64_inc(atomic64_t *ptr)
 {
 	atomic64_add(1, ptr);
 }
+EXPORT_SYMBOL(atomic64_inc);
 
 /**
  * atomic64_dec - decrement atomic64 variable
@@ -180,6 +192,7 @@ void atomic64_dec(atomic64_t *ptr)
 {
 	atomic64_sub(1, ptr);
 }
+EXPORT_SYMBOL(atomic64_dec);
 
 /**
  * atomic64_dec_and_test - decrement and test
@@ -193,6 +206,7 @@ int atomic64_dec_and_test(atomic64_t *ptr)
 {
 	return atomic64_sub_and_test(1, ptr);
 }
+EXPORT_SYMBOL(atomic64_dec_and_test);
 
 /**
  * atomic64_inc_and_test - increment and test
@@ -206,6 +220,7 @@ int atomic64_inc_and_test(atomic64_t *ptr)
 {
 	return atomic64_sub_and_test(-1, ptr);
 }
+EXPORT_SYMBOL(atomic64_inc_and_test);
 
 /**
  * atomic64_add_negative - add and test if negative
@@ -222,3 +237,4 @@ int atomic64_add_negative(u64 delta, atomic64_t *ptr)
 
 	return old_val < 0;
 }
+EXPORT_SYMBOL(atomic64_add_negative);
