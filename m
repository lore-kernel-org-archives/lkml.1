Return-Path: <linux-kernel-owner+w=401wt.eu-S934655AbZJOGFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934655AbZJOGFs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 02:05:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933429AbZJOGFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 02:05:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38300 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934257AbZJOGE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 02:04:59 -0400
Message-Id: <20091015050048.777261867@suse.de>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Thu, 15 Oct 2009 15:40:30 +1100
From: npiggin@suse.de
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, Ian Kent <raven@themaw.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [patch 4/6] brlock: introduce special brlocks
References: <20091015044026.319860788@suse.de>
Content-Disposition: inline; filename=kernel-introduce-brlock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces special brlocks, these can only be used as global
locks, and use some preprocessor trickery to allow us to retain a more
optimal per-cpu lock implementation. We don't bother working around
lockdep yet.

Signed-off-by: Nick Piggin <npiggin@suse.de>
---
 include/linux/brlock.h |  112 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 112 insertions(+)

Index: linux-2.6/include/linux/brlock.h
===================================================================
--- /dev/null
+++ linux-2.6/include/linux/brlock.h
@@ -0,0 +1,112 @@
+/*
+ * Specialised big-reader spinlock. Can only be declared as global variables
+ * to avoid overhead and keep things simple (and we don't want to start using
+ * these inside dynamically allocated structures).
+ *
+ * Copyright 2009, Nick Piggin, Novell Inc.
+ */
+#ifndef __LINUX_BRLOCK_H
+#define __LINUX_BRLOCK_H
+
+#include <linux/spinlock.h>
+#include <linux/percpu.h>
+#include <asm/atomic.h>
+
+#if defined(CONFIG_SMP) && !defined(CONFIG_LOCKDEP)
+#define DECLARE_BRLOCK(name)						\
+ DECLARE_PER_CPU(spinlock_t, name##_lock);				\
+ static inline void name##_lock_init(void) {				\
+	int i;								\
+	for_each_possible_cpu(i) {					\
+		spinlock_t *lock;					\
+		lock = &per_cpu(name##_lock, i);			\
+		spin_lock_init(lock);					\
+	}								\
+ }									\
+ static inline void name##_rlock(void) {				\
+	spinlock_t *lock;						\
+	lock = &get_cpu_var(name##_lock);				\
+	spin_lock(lock);						\
+ }									\
+ static inline void name##_runlock(void) {				\
+	spinlock_t *lock;						\
+	lock = &__get_cpu_var(name##_lock);				\
+	spin_unlock(lock);						\
+	put_cpu_var(name##_lock);					\
+ }									\
+ extern void name##_wlock(void);					\
+ extern void name##_wunlock(void);					\
+ static inline int name##_atomic_dec_and_rlock(atomic_t *a) {		\
+	int ret;							\
+	spinlock_t *lock;						\
+	lock = &get_cpu_var(name##_lock);				\
+	ret = atomic_dec_and_lock(a, lock);				\
+	if (!ret)							\
+		put_cpu_var(name##_lock);				\
+	return ret;							\
+ }									\
+ extern int name##_atomic_dec_and_wlock__failed(atomic_t *a);		\
+ static inline int name##_atomic_dec_and_wlock(atomic_t *a) {		\
+	if (atomic_add_unless(a, -1, 1))				\
+		return 0;						\
+	return name##_atomic_dec_and_wlock__failed(a);			\
+ }
+
+#define DEFINE_BRLOCK(name)						\
+ DEFINE_PER_CPU(spinlock_t, name##_lock);				\
+ void name##_wlock(void) {						\
+	int i;								\
+	for_each_online_cpu(i) {					\
+		spinlock_t *lock;					\
+		lock = &per_cpu(name##_lock, i);			\
+		spin_lock(lock);					\
+	}								\
+ }									\
+ void name##_wunlock(void) {						\
+	int i;								\
+	for_each_online_cpu(i) {					\
+		spinlock_t *lock;					\
+		lock = &per_cpu(name##_lock, i);			\
+		spin_unlock(lock);					\
+	}								\
+ }									\
+ int name##_atomic_dec_and_wlock__failed(atomic_t *a) {			\
+	name##_wlock();							\
+	if (!atomic_dec_and_test(a)) {					\
+		name##_wunlock();					\
+		return 0;						\
+	}								\
+	return 1;							\
+ }
+
+#else
+
+#define DECLARE_BRLOCK(name)						\
+ spinlock_t name##_lock;						\
+ static inline void name##_lock_init(void) {				\
+	spin_lock_init(&name##_lock);					\
+ }									\
+ static inline void name##_rlock(void) {				\
+	spin_lock(&name##_lock);					\
+ }									\
+ static inline void name##_runlock(void) {				\
+	spin_unlock(&name##_lock);					\
+ }									\
+ static inline void name##_wlock(void) {				\
+	spin_lock(&name##_lock);					\
+ }									\
+ static inline void name##_wunlock(void) {				\
+	spin_unlock(&name##_lock);					\
+ }									\
+ static inline int name##_atomic_dec_and_rlock(atomic_t *a) {		\
+	return atomic_dec_and_lock(a, &name##_lock);			\
+ }									\
+ static inline int name##_atomic_dec_and_wlock(atomic_t *a) {		\
+	return atomic_dec_and_lock(a, &name##_lock);			\
+ }
+
+#define DEFINE_BRLOCK(name)						\
+ spinlock_t name##_lock
+#endif
+
+#endif


