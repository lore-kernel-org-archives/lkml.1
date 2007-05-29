Return-Path: <linux-kernel-owner+w=401wt.eu-S1761686AbXE2NVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761686AbXE2NVQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 09:21:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760040AbXE2NUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 09:20:33 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:26479 "EHLO
	viefep33-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759581AbXE2NUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 09:20:31 -0400
Message-Id: <20070529130106.638361789@chello.nl>
References: <20070529125248.877196281@chello.nl>
User-Agent: quilt/0.45-1
Date: Tue, 29 May 2007 14:52:49 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Bill Huey <billh@gnuppy.monkey.org>,
       Jason Baron <jbaron@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 1/5] fix raw_spinlock_t vs lockdep
Content-Disposition: inline; filename=raw_spinlock_fix.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

raw_spinlock_t should not use lockdep (and doesn't) since lockdep itself relies
on it.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/spinlock_types.h    |    4 ++--
 include/linux/spinlock_types_up.h |    9 +--------
 2 files changed, 3 insertions(+), 10 deletions(-)

Index: linux-2.6-git/include/linux/spinlock_types_up.h
===================================================================
--- linux-2.6-git.orig/include/linux/spinlock_types_up.h
+++ linux-2.6-git/include/linux/spinlock_types_up.h
@@ -12,14 +12,10 @@
  * Released under the General Public License (GPL).
  */
 
-#if defined(CONFIG_DEBUG_SPINLOCK) || \
-	defined(CONFIG_DEBUG_LOCK_ALLOC)
+#ifdef CONFIG_DEBUG_SPINLOCK
 
 typedef struct {
 	volatile unsigned int slock;
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-	struct lockdep_map dep_map;
-#endif
 } raw_spinlock_t;
 
 #define __RAW_SPIN_LOCK_UNLOCKED { 1 }
@@ -34,9 +30,6 @@ typedef struct { } raw_spinlock_t;
 
 typedef struct {
 	/* no debug version on UP */
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-	struct lockdep_map dep_map;
-#endif
 } raw_rwlock_t;
 
 #define __RAW_RW_LOCK_UNLOCKED { }
Index: linux-2.6-git/include/linux/spinlock_types.h
===================================================================
--- linux-2.6-git.orig/include/linux/spinlock_types.h
+++ linux-2.6-git/include/linux/spinlock_types.h
@@ -9,14 +9,14 @@
  * Released under the General Public License (GPL).
  */
 
-#include <linux/lockdep.h>
-
 #if defined(CONFIG_SMP)
 # include <asm/spinlock_types.h>
 #else
 # include <linux/spinlock_types_up.h>
 #endif
 
+#include <linux/lockdep.h>
+
 typedef struct {
 	raw_spinlock_t raw_lock;
 #if defined(CONFIG_PREEMPT) && defined(CONFIG_SMP)

--

