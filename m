Return-Path: <linux-kernel-owner+w=401wt.eu-S933045AbZFLQbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933045AbZFLQbn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 12:31:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757704AbZFLQZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 12:25:19 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:39103 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763910AbZFLQZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 12:25:08 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 20/27] Blackfin: punt unused/wrong mutex-dec.h
Date: Fri, 12 Jun 2009 12:24:38 -0400
Message-Id: <1244823885-22410-21-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244823885-22410-1-git-send-email-vapier@gentoo.org>
References: <1244823885-22410-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks like the mutex-dec.h header file was incorrectly copied into the
Blackfin asm path.  Nothing uses it, so punt it.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/include/asm/mutex-dec.h |  112 ---------------------------------
 1 files changed, 0 insertions(+), 112 deletions(-)
 delete mode 100644 arch/blackfin/include/asm/mutex-dec.h

diff --git a/arch/blackfin/include/asm/mutex-dec.h b/arch/blackfin/include/asm/mutex-dec.h
deleted file mode 100644
index 0134151..0000000
--- a/arch/blackfin/include/asm/mutex-dec.h
+++ /dev/null
@@ -1,112 +0,0 @@
-/*
- * include/asm-generic/mutex-dec.h
- *
- * Generic implementation of the mutex fastpath, based on atomic
- * decrement/increment.
- */
-#ifndef _ASM_GENERIC_MUTEX_DEC_H
-#define _ASM_GENERIC_MUTEX_DEC_H
-
-/**
- *  __mutex_fastpath_lock - try to take the lock by moving the count
- *                          from 1 to a 0 value
- *  @count: pointer of type atomic_t
- *  @fail_fn: function to call if the original value was not 1
- *
- * Change the count from 1 to a value lower than 1, and call <fail_fn> if
- * it wasn't 1 originally. This function MUST leave the value lower than
- * 1 even when the "1" assertion wasn't true.
- */
-static inline void
-__mutex_fastpath_lock(atomic_t *count, fastcall void (*fail_fn)(atomic_t *))
-{
-	if (unlikely(atomic_dec_return(count) < 0))
-		fail_fn(count);
-	else
-		smp_mb();
-}
-
-/**
- *  __mutex_fastpath_lock_retval - try to take the lock by moving the count
- *                                 from 1 to a 0 value
- *  @count: pointer of type atomic_t
- *  @fail_fn: function to call if the original value was not 1
- *
- * Change the count from 1 to a value lower than 1, and call <fail_fn> if
- * it wasn't 1 originally. This function returns 0 if the fastpath succeeds,
- * or anything the slow path function returns.
- */
-static inline int
-__mutex_fastpath_lock_retval(atomic_t *count, fastcall int (*fail_fn)(atomic_t *))
-{
-	if (unlikely(atomic_dec_return(count) < 0))
-		return fail_fn(count);
-	else {
-		smp_mb();
-		return 0;
-	}
-}
-
-/**
- *  __mutex_fastpath_unlock - try to promote the count from 0 to 1
- *  @count: pointer of type atomic_t
- *  @fail_fn: function to call if the original value was not 0
- *
- * Try to promote the count from 0 to 1. If it wasn't 0, call <fail_fn>.
- * In the failure case, this function is allowed to either set the value to
- * 1, or to set it to a value lower than 1.
- *
- * If the implementation sets it to a value of lower than 1, then the
- * __mutex_slowpath_needs_to_unlock() macro needs to return 1, it needs
- * to return 0 otherwise.
- */
-static inline void
-__mutex_fastpath_unlock(atomic_t *count, fastcall void (*fail_fn)(atomic_t *))
-{
-	smp_mb();
-	if (unlikely(atomic_inc_return(count) <= 0))
-		fail_fn(count);
-}
-
-#define __mutex_slowpath_needs_to_unlock()		1
-
-/**
- * __mutex_fastpath_trylock - try to acquire the mutex, without waiting
- *
- *  @count: pointer of type atomic_t
- *  @fail_fn: fallback function
- *
- * Change the count from 1 to a value lower than 1, and return 0 (failure)
- * if it wasn't 1 originally, or return 1 (success) otherwise. This function
- * MUST leave the value lower than 1 even when the "1" assertion wasn't true.
- * Additionally, if the value was < 0 originally, this function must not leave
- * it to 0 on failure.
- *
- * If the architecture has no effective trylock variant, it should call the
- * <fail_fn> spinlock-based trylock variant unconditionally.
- */
-static inline int
-__mutex_fastpath_trylock(atomic_t *count, int (*fail_fn)(atomic_t *))
-{
-	/*
-	 * We have two variants here. The cmpxchg based one is the best one
-	 * because it never induce a false contention state.  It is included
-	 * here because architectures using the inc/dec algorithms over the
-	 * xchg ones are much more likely to support cmpxchg natively.
-	 *
-	 * If not we fall back to the spinlock based variant - that is
-	 * just as efficient (and simpler) as a 'destructive' probing of
-	 * the mutex state would be.
-	 */
-#ifdef __HAVE_ARCH_CMPXCHG
-	if (likely(atomic_cmpxchg(count, 1, 0) == 1)) {
-		smp_mb();
-		return 1;
-	}
-	return 0;
-#else
-	return fail_fn(count);
-#endif
-}
-
-#endif
-- 
1.6.3.1

