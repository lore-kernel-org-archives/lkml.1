Return-Path: <linux-kernel-owner+w=401wt.eu-S1754479AbZLRAoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479AbZLRAoi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 19:44:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbZLRAog
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 19:44:36 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:39896 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbZLRAof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 19:44:35 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 18 Dec 2009 09:41:27 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, cl@linux-foundation.org,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "mingo@elte.hu" <mingo@elte.hu>
Subject: [RFC 1/4] uninline mm accessor.
Message-Id: <20091218094127.4fbfb986.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20091218093849.8ba69ad9.kamezawa.hiroyu@jp.fujitsu.com>
References: <20091216120011.3eecfe79.kamezawa.hiroyu@jp.fujitsu.com>
	<20091216101107.GA15031@basil.fritz.box>
	<20091216191312.f4655dac.kamezawa.hiroyu@jp.fujitsu.com>
	<20091216102806.GC15031@basil.fritz.box>
	<28c262360912160231r18db8478sf41349362360cab8@mail.gmail.com>
	<20091216193315.14a508d5.kamezawa.hiroyu@jp.fujitsu.com>
	<20091218093849.8ba69ad9.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Uninline all mm_accessor.

==
Index: mmotm-mm-accessor/include/linux/mm_accessor.h
===================================================================
--- mmotm-mm-accessor.orig/include/linux/mm_accessor.h
+++ mmotm-mm-accessor/include/linux/mm_accessor.h
@@ -1,68 +1,36 @@
 #ifndef __LINUX_MM_ACCESSOR_H
 #define __LINUX_MM_ACCESSOR_H
 
-static inline void mm_read_lock(struct mm_struct *mm)
-{
-	down_read(&mm->mmap_sem);
-}
-
-static inline int mm_read_trylock(struct mm_struct *mm)
-{
-	return down_read_trylock(&mm->mmap_sem);
-}
-
-static inline void mm_read_unlock(struct mm_struct *mm)
-{
-	up_read(&mm->mmap_sem);
-}
-
-static inline void mm_write_lock(struct mm_struct *mm)
-{
-	down_write(&mm->mmap_sem);
-}
-
-static inline void mm_write_unlock(struct mm_struct *mm)
-{
-	up_write(&mm->mmap_sem);
-}
-
-static inline int mm_write_trylock(struct mm_struct *mm)
-{
-	return down_write_trylock(&mm->mmap_sem);
-}
-
-static inline int mm_is_locked(struct mm_struct *mm)
-{
-	return rwsem_is_locked(&mm->mmap_sem);
-}
-
-static inline void mm_write_to_read_lock(struct mm_struct *mm)
-{
-	downgrade_write(&mm->mmap_sem);
-}
-
-static inline void mm_write_lock_nested(struct mm_struct *mm, int x)
-{
-	down_write_nested(&mm->mmap_sem, x);
-}
-
-static inline void mm_lock_init(struct mm_struct *mm)
-{
-	init_rwsem(&mm->mmap_sem);
-}
-
-static inline void mm_lock_prefetch(struct mm_struct *mm)
-{
-	prefetchw(&mm->mmap_sem);
-}
-
-static inline void mm_nest_spin_lock(spinlock_t *s, struct mm_struct *mm)
-{
-	spin_lock_nest_lock(s, &mm->mmap_sem);
-}
-
-static inline void mm_read_might_lock(struct mm_struct *mm)
-{
-	might_lock_read(&mm->mmap_sem);
-}
+void mm_read_lock(struct mm_struct *mm);
+
+int mm_read_trylock(struct mm_struct *mm);
+
+void mm_read_unlock(struct mm_struct *mm);
+
+void mm_write_lock(struct mm_struct *mm);
+
+void mm_write_unlock(struct mm_struct *mm);
+
+int mm_write_trylock(struct mm_struct *mm);
+
+int mm_is_locked(struct mm_struct *mm);
+
+void mm_write_to_read_lock(struct mm_struct *mm);
+
+void mm_write_lock_nested(struct mm_struct *mm, int x);
+
+void mm_lock_init(struct mm_struct *mm);
+
+void mm_lock_prefetch(struct mm_struct *mm);
+
+void mm_nest_spin_lock(spinlock_t *s, struct mm_struct *mm);
+
+void mm_read_might_lock(struct mm_struct *mm);
+
+int mm_version_check(struct mm_struct *mm);
+
+struct vm_area_struct *get_cached_vma(struct mm_struct *mm);
+void set_cached_vma(struct vm_area_struct *vma);
+void clear_cached_vma(struct task_struct *task);
+
 #endif
Index: mmotm-mm-accessor/mm/mm_accessor.c
===================================================================
--- /dev/null
+++ mmotm-mm-accessor/mm/mm_accessor.c
@@ -0,0 +1,80 @@
+#include <linux/mm_types.h>
+#include <linux/module.h>
+
+void mm_read_lock(struct mm_struct *mm)
+{
+	down_read(&mm->mmap_sem);
+}
+EXPORT_SYMBOL(mm_read_lock);
+
+int mm_read_trylock(struct mm_struct *mm)
+{
+	return down_read_trylock(&mm->mmap_sem);
+}
+EXPORT_SYMBOL(mm_read_trylock);
+
+void mm_read_unlock(struct mm_struct *mm)
+{
+	up_read(&mm->mmap_sem);
+}
+EXPORT_SYMBOL(mm_read_unlock);
+
+void mm_write_lock(struct mm_struct *mm)
+{
+	down_write(&mm->mmap_sem);
+}
+EXPORT_SYMBOL(mm_write_lock);
+
+void mm_write_unlock(struct mm_struct *mm)
+{
+	up_write(&mm->mmap_sem);
+}
+EXPORT_SYMBOL(mm_write_unlock);
+
+int mm_write_trylock(struct mm_struct *mm)
+{
+	return down_write_trylock(&mm->mmap_sem);
+}
+EXPORT_SYMBOL(mm_write_trylock);
+
+int mm_is_locked(struct mm_struct *mm)
+{
+	return rwsem_is_locked(&mm->mmap_sem);
+}
+EXPORT_SYMBOL(mm_is_locked);
+
+void mm_write_to_read_lock(struct mm_struct *mm)
+{
+	downgrade_write(&mm->mmap_sem);
+}
+EXPORT_SYMBOL(mm_write_to_read_lock);
+
+void mm_write_lock_nested(struct mm_struct *mm, int x)
+{
+	down_write_nested(&mm->mmap_sem, x);
+}
+EXPORT_SYMBOL(mm_write_lock_nested);
+
+void mm_lock_init(struct mm_struct *mm)
+{
+	init_rwsem(&mm->mmap_sem);
+}
+EXPORT_SYMBOL(mm_lock_init);
+
+void mm_lock_prefetch(struct mm_struct *mm)
+{
+	prefetchw(&mm->mmap_sem);
+}
+EXPORT_SYMBOL(mm_lock_prefetch);
+
+void mm_nest_spin_lock(spinlock_t *s, struct mm_struct *mm)
+{
+	spin_lock_nest_lock(s, &mm->mmap_sem);
+}
+EXPORT_SYMBOL(mm_nest_spin_lock);
+
+void mm_read_might_lock(struct mm_struct *mm)
+{
+	might_lock_read(&mm->mmap_sem);
+}
+EXPORT_SYMBOL(mm_read_might_lock);
Index: mmotm-mm-accessor/mm/Makefile
===================================================================
--- mmotm-mm-accessor.orig/mm/Makefile
+++ mmotm-mm-accessor/mm/Makefile
@@ -8,7 +8,7 @@ mmu-$(CONFIG_MMU)	:= fremap.o highmem.o 
 			   vmalloc.o pagewalk.o
 
 obj-y			:= bootmem.o filemap.o mempool.o oom_kill.o fadvise.o \
-			   maccess.o page_alloc.o page-writeback.o \
+			   maccess.o page_alloc.o page-writeback.o mm_accessor.o \
 			   readahead.o swap.o truncate.o vmscan.o shmem.o \
 			   prio_tree.o util.o mmzone.o vmstat.o backing-dev.o \
 			   page_isolation.o mm_init.o mmu_context.o \

