Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119Ab0BIFyx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 00:54:53 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:5291 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998Ab0BIFyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 00:54:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=nnHOY9pMAltglgcR8AsGg+3Dv8dHQqXgbVRis8Ng7pRR1yfdT2LYcTV5ieBtP10Ok8
         J1bIoOBqgUzZeP+gU/ArQ08CxLGQWgxKXV1l5QjBdvt+fHZMf+2BpzVQU74gfP/6Zr6E
         85HXiQTqrYoccCPfr9J1voHjeNL65FoYkB14A=
From: Luca Barbieri <luca@luca-barbieri.com>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, Luca Barbieri <luca@luca-barbieri.com>
Subject: [PATCH] Make sparse work with inline spinlocks and rwlocks
Date: Tue,  9 Feb 2010 06:53:38 +0100
Message-Id: <1265694818-11224-1-git-send-email-luca@luca-barbieri.com>
X-Mailer: git-send-email 1.6.6.1.476.g01ddb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently sparse does not work with inline spinlock and rwlock functions.
The problem is that they do not use the __acquires/__releases out-of-line
functions, but use inline functions with no sparse annotations.

This patch adds the appropriate annotations to make it work properly.

Please consider merging into tip and/or sending to Linus.

Signed-off-by: Luca Barbieri <luca@luca-barbieri.com>
---
 include/linux/rwlock.h   |   20 ++++++++++----------
 include/linux/spinlock.h |   13 ++++++++-----
 2 files changed, 18 insertions(+), 15 deletions(-)

diff --git a/include/linux/rwlock.h b/include/linux/rwlock.h
index 71e0b00..bc2994e 100644
--- a/include/linux/rwlock.h
+++ b/include/linux/rwlock.h
@@ -29,25 +29,25 @@ do {								\
 #endif
 
 #ifdef CONFIG_DEBUG_SPINLOCK
- extern void do_raw_read_lock(rwlock_t *lock);
+ extern void do_raw_read_lock(rwlock_t *lock) __acquires(lock);
 #define do_raw_read_lock_flags(lock, flags) do_raw_read_lock(lock)
  extern int do_raw_read_trylock(rwlock_t *lock);
- extern void do_raw_read_unlock(rwlock_t *lock);
- extern void do_raw_write_lock(rwlock_t *lock);
+ extern void do_raw_read_unlock(rwlock_t *lock) __releases(lock);
+ extern void do_raw_write_lock(rwlock_t *lock) __acquires(lock);
 #define do_raw_write_lock_flags(lock, flags) do_raw_write_lock(lock)
  extern int do_raw_write_trylock(rwlock_t *lock);
- extern void do_raw_write_unlock(rwlock_t *lock);
+ extern void do_raw_write_unlock(rwlock_t *lock) __releases(lock);
 #else
-# define do_raw_read_lock(rwlock)	arch_read_lock(&(rwlock)->raw_lock)
+# define do_raw_read_lock(rwlock)	do {__acquire(lock); arch_read_lock(&(rwlock)->raw_lock); } while (0)
 # define do_raw_read_lock_flags(lock, flags) \
-		arch_read_lock_flags(&(lock)->raw_lock, *(flags))
+		do {__acquire(lock); arch_read_lock_flags(&(lock)->raw_lock, *(flags)); } while (0)
 # define do_raw_read_trylock(rwlock)	arch_read_trylock(&(rwlock)->raw_lock)
-# define do_raw_read_unlock(rwlock)	arch_read_unlock(&(rwlock)->raw_lock)
-# define do_raw_write_lock(rwlock)	arch_write_lock(&(rwlock)->raw_lock)
+# define do_raw_read_unlock(rwlock)	do {arch_read_unlock(&(rwlock)->raw_lock); __release(lock); } while (0)
+# define do_raw_write_lock(rwlock)	do {__acquire(lock); arch_write_lock(&(rwlock)->raw_lock); } while (0)
 # define do_raw_write_lock_flags(lock, flags) \
-		arch_write_lock_flags(&(lock)->raw_lock, *(flags))
+		do {__acquire(lock); arch_write_lock_flags(&(lock)->raw_lock, *(flags)); } while (0)
 # define do_raw_write_trylock(rwlock)	arch_write_trylock(&(rwlock)->raw_lock)
-# define do_raw_write_unlock(rwlock)	arch_write_unlock(&(rwlock)->raw_lock)
+# define do_raw_write_unlock(rwlock)	do {arch_write_unlock(&(rwlock)->raw_lock); __release(lock); } while (0)
 #endif
 
 #define read_can_lock(rwlock)		arch_read_can_lock(&(rwlock)->raw_lock)
diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
index 8608821..89fac6a 100644
--- a/include/linux/spinlock.h
+++ b/include/linux/spinlock.h
@@ -128,19 +128,21 @@ static inline void smp_mb__after_lock(void) { smp_mb(); }
 #define raw_spin_unlock_wait(lock)	arch_spin_unlock_wait(&(lock)->raw_lock)
 
 #ifdef CONFIG_DEBUG_SPINLOCK
- extern void do_raw_spin_lock(raw_spinlock_t *lock);
+ extern void do_raw_spin_lock(raw_spinlock_t *lock) __acquires(lock);
 #define do_raw_spin_lock_flags(lock, flags) do_raw_spin_lock(lock)
  extern int do_raw_spin_trylock(raw_spinlock_t *lock);
- extern void do_raw_spin_unlock(raw_spinlock_t *lock);
+ extern void do_raw_spin_unlock(raw_spinlock_t *lock) __releases(lock);
 #else
-static inline void do_raw_spin_lock(raw_spinlock_t *lock)
+static inline void do_raw_spin_lock(raw_spinlock_t *lock) __acquires(lock)
 {
+	__acquire(lock);
 	arch_spin_lock(&lock->raw_lock);
 }
 
 static inline void
-do_raw_spin_lock_flags(raw_spinlock_t *lock, unsigned long *flags)
+do_raw_spin_lock_flags(raw_spinlock_t *lock, unsigned long *flags) __acquires(lock)
 {
+	__acquire(lock);
 	arch_spin_lock_flags(&lock->raw_lock, *flags);
 }
 
@@ -149,9 +151,10 @@ static inline int do_raw_spin_trylock(raw_spinlock_t *lock)
 	return arch_spin_trylock(&(lock)->raw_lock);
 }
 
-static inline void do_raw_spin_unlock(raw_spinlock_t *lock)
+static inline void do_raw_spin_unlock(raw_spinlock_t *lock) __releases(lock)
 {
 	arch_spin_unlock(&lock->raw_lock);
+	__release(lock);
 }
 #endif
 
-- 
1.6.6.1.476.g01ddb

