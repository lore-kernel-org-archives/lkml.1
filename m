Return-Path: <linux-kernel-owner+w=401wt.eu-S1754068AbXE3PKE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068AbXE3PKE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 11:10:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752000AbXE3PJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 11:09:55 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:31735 "EHLO
	viefep13-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752087AbXE3PJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 11:09:55 -0400
Message-Id: <20070530125335.349120074@chello.nl>
References: <20070530124903.882133089@chello.nl>
User-Agent: quilt/0.45-1
Date: Wed, 30 May 2007 14:49:04 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Bill Huey <billh@gnuppy.monkey.org>,
       Jason Baron <jbaron@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 1/6] fix raw_spinlock_t vs lockdep
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

