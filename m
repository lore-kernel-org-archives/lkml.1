Return-Path: <linux-kernel-owner+w=401wt.eu-S933470AbXEWKFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933470AbXEWKFg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 06:05:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762340AbXEWKDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 06:03:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55996 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758851AbXEWKDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 06:03:14 -0400
Message-Id: <20070523095807.212984885@chello.nl>
References: <20070523072618.129001605@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 23 May 2007 11:57:17 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Bill Huey <billh@gnuppy.monkey.org>,
       Jason Baron <jbaron@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 1/7] fix raw_spinlock_t vs lockdep
Content-Disposition: inline; filename=raw_spinlock_fix.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

raw_spinlock_t should not use lockdep (and doesn't) since lockdep itself relies
on it.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/spinlock_types.h    |    4 ++--
 include/linux/spinlock_types_up.h |    9 +--------
 2 files changed, 3 insertions(+), 10 deletions(-)

Index: linux-2.6/include/linux/spinlock_types_up.h
===================================================================
--- linux-2.6.orig/include/linux/spinlock_types_up.h	2007-02-20 13:22:26.000000000 +0100
+++ linux-2.6/include/linux/spinlock_types_up.h	2007-05-21 14:42:55.000000000 +0200
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
Index: linux-2.6/include/linux/spinlock_types.h
===================================================================
--- linux-2.6.orig/include/linux/spinlock_types.h	2007-05-21 14:43:19.000000000 +0200
+++ linux-2.6/include/linux/spinlock_types.h	2007-05-21 14:43:31.000000000 +0200
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

