Return-Path: <linux-kernel-owner+w=401wt.eu-S1760340AbZBXV7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760340AbZBXV7g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 16:59:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753543AbZBXV7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 16:59:20 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:49862 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402AbZBXV7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 16:59:20 -0500
Subject: [RFC][PATCH] rwsem: rwsem_is_{read,write}_locked
From: Peter Zijlstra <peterz@infradead.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: David Howells <dhowells@redhat.com>, Matthew Wilcox <matthew@wil.cx>,
       Ingo Molnar <mingo@elte.hu>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 24 Feb 2009 22:58:36 +0100
Message-Id: <1235512716.4645.2397.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph requested an extended is_locked interface for rwsems. I think
the below ought to do, then again, I might have missed something.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/alpha/include/asm/rwsem.h   |    5 -----
 arch/ia64/include/asm/rwsem.h    |    5 -----
 arch/powerpc/include/asm/rwsem.h |    5 -----
 arch/s390/include/asm/rwsem.h    |    5 -----
 arch/sh/include/asm/rwsem.h      |    5 -----
 arch/sparc/include/asm/rwsem.h   |    5 -----
 arch/x86/include/asm/rwsem.h     |    5 -----
 arch/xtensa/include/asm/rwsem.h  |    5 -----
 include/linux/rwsem-spinlock.h   |    5 +++++
 include/linux/rwsem.h            |   16 ++++++++++++++++
 10 files changed, 21 insertions(+), 40 deletions(-)

diff --git a/arch/alpha/include/asm/rwsem.h b/arch/alpha/include/asm/rwsem.h
index 1570c0b..fdc8dc3 100644
--- a/arch/alpha/include/asm/rwsem.h
+++ b/arch/alpha/include/asm/rwsem.h
@@ -250,10 +250,5 @@ static inline long rwsem_atomic_update(long val, struct rw_semaphore *sem)
 #endif
 }
 
-static inline int rwsem_is_locked(struct rw_semaphore *sem)
-{
-	return (sem->count != 0);
-}
-
 #endif /* __KERNEL__ */
 #endif /* _ALPHA_RWSEM_H */
diff --git a/arch/ia64/include/asm/rwsem.h b/arch/ia64/include/asm/rwsem.h
index fbee74b..4b4bfa5 100644
--- a/arch/ia64/include/asm/rwsem.h
+++ b/arch/ia64/include/asm/rwsem.h
@@ -174,9 +174,4 @@ __downgrade_write (struct rw_semaphore *sem)
 #define rwsem_atomic_add(delta, sem)	atomic64_add(delta, (atomic64_t *)(&(sem)->count))
 #define rwsem_atomic_update(delta, sem)	atomic64_add_return(delta, (atomic64_t *)(&(sem)->count))
 
-static inline int rwsem_is_locked(struct rw_semaphore *sem)
-{
-	return (sem->count != 0);
-}
-
 #endif /* _ASM_IA64_RWSEM_H */
diff --git a/arch/powerpc/include/asm/rwsem.h b/arch/powerpc/include/asm/rwsem.h
index 24cd928..27d1acf 100644
--- a/arch/powerpc/include/asm/rwsem.h
+++ b/arch/powerpc/include/asm/rwsem.h
@@ -164,10 +164,5 @@ static inline int rwsem_atomic_update(int delta, struct rw_semaphore *sem)
 	return atomic_add_return(delta, (atomic_t *)(&sem->count));
 }
 
-static inline int rwsem_is_locked(struct rw_semaphore *sem)
-{
-	return (sem->count != 0);
-}
-
 #endif	/* __KERNEL__ */
 #endif	/* _ASM_POWERPC_RWSEM_H */
diff --git a/arch/s390/include/asm/rwsem.h b/arch/s390/include/asm/rwsem.h
index 9d2a179..d9ab6c6 100644
--- a/arch/s390/include/asm/rwsem.h
+++ b/arch/s390/include/asm/rwsem.h
@@ -378,10 +378,5 @@ static inline long rwsem_atomic_update(long delta, struct rw_semaphore *sem)
 	return new;
 }
 
-static inline int rwsem_is_locked(struct rw_semaphore *sem)
-{
-	return (sem->count != 0);
-}
-
 #endif /* __KERNEL__ */
 #endif /* _S390_RWSEM_H */
diff --git a/arch/sh/include/asm/rwsem.h b/arch/sh/include/asm/rwsem.h
index 1987f3e..5aded81 100644
--- a/arch/sh/include/asm/rwsem.h
+++ b/arch/sh/include/asm/rwsem.h
@@ -179,10 +179,5 @@ static inline int rwsem_atomic_update(int delta, struct rw_semaphore *sem)
 	return atomic_add_return(delta, (atomic_t *)(&sem->count));
 }
 
-static inline int rwsem_is_locked(struct rw_semaphore *sem)
-{
-	return (sem->count != 0);
-}
-
 #endif /* __KERNEL__ */
 #endif /* _ASM_SH_RWSEM_H */
diff --git a/arch/sparc/include/asm/rwsem.h b/arch/sparc/include/asm/rwsem.h
index 1dc129a..a3f43c9 100644
--- a/arch/sparc/include/asm/rwsem.h
+++ b/arch/sparc/include/asm/rwsem.h
@@ -74,11 +74,6 @@ static inline void rwsem_atomic_add(int delta, struct rw_semaphore *sem)
 	atomic_add(delta, (atomic_t *)(&sem->count));
 }
 
-static inline int rwsem_is_locked(struct rw_semaphore *sem)
-{
-	return (sem->count != 0);
-}
-
 #endif /* __KERNEL__ */
 
 #endif /* _SPARC64_RWSEM_H */
diff --git a/arch/x86/include/asm/rwsem.h b/arch/x86/include/asm/rwsem.h
index ca7517d..a22dc3b 100644
--- a/arch/x86/include/asm/rwsem.h
+++ b/arch/x86/include/asm/rwsem.h
@@ -256,10 +256,5 @@ static inline int rwsem_atomic_update(int delta, struct rw_semaphore *sem)
 	return tmp + delta;
 }
 
-static inline int rwsem_is_locked(struct rw_semaphore *sem)
-{
-	return (sem->count != 0);
-}
-
 #endif /* __KERNEL__ */
 #endif /* _ASM_X86_RWSEM_H */
diff --git a/arch/xtensa/include/asm/rwsem.h b/arch/xtensa/include/asm/rwsem.h
index e39edf5..e960d99 100644
--- a/arch/xtensa/include/asm/rwsem.h
+++ b/arch/xtensa/include/asm/rwsem.h
@@ -160,9 +160,4 @@ static inline int rwsem_atomic_update(int delta, struct rw_semaphore *sem)
 	return atomic_add_return(delta, (atomic_t *)(&sem->count));
 }
 
-static inline int rwsem_is_locked(struct rw_semaphore *sem)
-{
-	return (sem->count != 0);
-}
-
 #endif	/* _XTENSA_RWSEM_H */
diff --git a/include/linux/rwsem-spinlock.h b/include/linux/rwsem-spinlock.h
index 6c3c0f6..00c76f7 100644
--- a/include/linux/rwsem-spinlock.h
+++ b/include/linux/rwsem-spinlock.h
@@ -74,5 +74,10 @@ static inline int rwsem_is_locked(struct rw_semaphore *sem)
 	return (sem->activity != 0);
 }
 
+static inline int rwsem_is_write_locked(struct rw_semaphore *sem)
+{
+	return (sem->activity < 0);
+}
+
 #endif /* __KERNEL__ */
 #endif /* _LINUX_RWSEM_SPINLOCK_H */
diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
index efd348f..9d7531b 100644
--- a/include/linux/rwsem.h
+++ b/include/linux/rwsem.h
@@ -20,8 +20,24 @@ struct rw_semaphore;
 #include <linux/rwsem-spinlock.h> /* use a generic implementation */
 #else
 #include <asm/rwsem.h> /* use an arch-specific implementation */
+
+static inline int rwsem_is_locked(struct rw_semaphore *sem)
+{
+	return (sem->count != 0);
+}
+
+static inline int rwsem_is_write_locked(struct rw_semaphore *sem)
+{
+	return (sem->count & RWSEM_ACTIVE_MASK) == RWSEM_ACTIVE_MASK;
+}
+
 #endif
 
+static inline int rwsem_is_read_locked(struct rw_semaphore *sem)
+{
+	return rwsem_is_locked(sem) && !rwsem_is_write_locked(sem);
+}
+
 /*
  * lock for reading
  */


