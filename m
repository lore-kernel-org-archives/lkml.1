Return-Path: <linux-kernel-owner+w=401wt.eu-S1757778AbZLPDEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757778AbZLPDEr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 22:04:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752561AbZLPDEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 22:04:46 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50243 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026AbZLPDEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 22:04:45 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 16 Dec 2009 12:01:34 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, cl@linux-foundation.org,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "mingo@elte.hu" <mingo@elte.hu>, andi@firstfloor.org,
       minchan.kim@gmail.com
Subject: [mm][RFC][PATCH 1/11] mm accessor for replacing mmap_sem
Message-Id: <20091216120134.0221457e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20091216120011.3eecfe79.kamezawa.hiroyu@jp.fujitsu.com>
References: <20091216120011.3eecfe79.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

This patch implements mm accessor, functions for get/release mm->mmap_sem.
For doing some work related to mmap_sem (relaxing it or count events etc..),
bare access to mm->mmap_sem is the first obstacle.

This patch is for removing direct access to mm->mmap_sem.
(For debugging, renaming mm->mmap_sem is better. But considering bisection,
 this patch leave it as it is. The last patch of this series will rename it.)

Following patches will replace direct access to mmap_sem to use these
accessors.

Based on Christoph Lameter's original work.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 include/linux/mm_accessor.h |   68 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/mm_types.h    |    3 +
 2 files changed, 71 insertions(+)

Index: mmotm-mm-accessor/include/linux/mm_accessor.h
===================================================================
--- /dev/null
+++ mmotm-mm-accessor/include/linux/mm_accessor.h
@@ -0,0 +1,68 @@
+#ifndef __LINUX_MM_ACCESSOR_H
+#define __LINUX_MM_ACCESSOR_H
+
+static inline void mm_read_lock(struct mm_struct *mm)
+{
+	down_read(&mm->mmap_sem);
+}
+
+static inline int mm_read_trylock(struct mm_struct *mm)
+{
+	return down_read_trylock(&mm->mmap_sem);
+}
+
+static inline void mm_read_unlock(struct mm_struct *mm)
+{
+	up_read(&mm->mmap_sem);
+}
+
+static inline void mm_write_lock(struct mm_struct *mm)
+{
+	down_write(&mm->mmap_sem);
+}
+
+static inline void mm_write_unlock(struct mm_struct *mm)
+{
+	up_write(&mm->mmap_sem);
+}
+
+static inline int mm_write_trylock(struct mm_struct *mm)
+{
+	return down_write_trylock(&mm->mmap_sem);
+}
+
+static inline int mm_is_locked(struct mm_struct *mm)
+{
+	return rwsem_is_locked(&mm->mmap_sem);
+}
+
+static inline void mm_write_to_read_lock(struct mm_struct *mm)
+{
+	downgrade_write(&mm->mmap_sem);
+}
+
+static inline void mm_write_lock_nested(struct mm_struct *mm, int x)
+{
+	down_write_nested(&mm->mmap_sem, x);
+}
+
+static inline void mm_lock_init(struct mm_struct *mm)
+{
+	init_rwsem(&mm->mmap_sem);
+}
+
+static inline void mm_lock_prefetch(struct mm_struct *mm)
+{
+	prefetchw(&mm->mmap_sem);
+}
+
+static inline void mm_nest_spin_lock(spinlock_t *s, struct mm_struct *mm)
+{
+	spin_lock_nest_lock(s, &mm->mmap_sem);
+}
+
+static inline void mm_read_might_lock(struct mm_struct *mm)
+{
+	might_lock_read(&mm->mmap_sem);
+}
+#endif
Index: mmotm-mm-accessor/include/linux/mm_types.h
===================================================================
--- mmotm-mm-accessor.orig/include/linux/mm_types.h
+++ mmotm-mm-accessor/include/linux/mm_types.h
@@ -292,4 +292,7 @@ struct mm_struct {
 /* Future-safe accessor for struct mm_struct's cpu_vm_mask. */
 #define mm_cpumask(mm) (&(mm)->cpu_vm_mask)
 
+/* Functions for accessing mm_struct */
+#include <linux/mm_accessor.h>
+
 #endif /* _LINUX_MM_TYPES_H */

