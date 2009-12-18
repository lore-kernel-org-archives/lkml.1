Return-Path: <linux-kernel-owner+w=401wt.eu-S1755278AbZLRAqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278AbZLRAqr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 19:46:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754351AbZLRAqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 19:46:45 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50545 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754341AbZLRAqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 19:46:44 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 18 Dec 2009 09:43:36 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, cl@linux-foundation.org,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "mingo@elte.hu" <mingo@elte.hu>
Subject: [RFC 2/4] add mm event counter
Message-Id: <20091218094336.cb479a36.kamezawa.hiroyu@jp.fujitsu.com>
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

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Add version counter to mm_struct. It's updated when
write_lock is held and released. And this patch also adds
task->mm_version. By this, mm_semaphore can provides some
operation like seqlock.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 include/linux/mm_types.h |    1 +
 include/linux/sched.h    |    2 +-
 mm/mm_accessor.c         |   29 ++++++++++++++++++++++++++---
 3 files changed, 28 insertions(+), 4 deletions(-)

Index: mmotm-mm-accessor/include/linux/mm_types.h
===================================================================
--- mmotm-mm-accessor.orig/include/linux/mm_types.h
+++ mmotm-mm-accessor/include/linux/mm_types.h
@@ -216,6 +216,7 @@ struct mm_struct {
 	atomic_t mm_count;			/* How many references to "struct mm_struct" (users count as 1) */
 	int map_count;				/* number of VMAs */
 	struct rw_semaphore mmap_sem;
+	int version;
 	spinlock_t page_table_lock;		/* Protects page tables and some counters */
 
 	struct list_head mmlist;		/* List of maybe swapped mm's.	These are globally strung
Index: mmotm-mm-accessor/include/linux/sched.h
===================================================================
--- mmotm-mm-accessor.orig/include/linux/sched.h
+++ mmotm-mm-accessor/include/linux/sched.h
@@ -1276,7 +1276,7 @@ struct task_struct {
 	struct plist_node pushable_tasks;
 
 	struct mm_struct *mm, *active_mm;
-
+	int mm_version;
 /* task state */
 	int exit_state;
 	int exit_code, exit_signal;
Index: mmotm-mm-accessor/mm/mm_accessor.c
===================================================================
--- mmotm-mm-accessor.orig/mm/mm_accessor.c
+++ mmotm-mm-accessor/mm/mm_accessor.c
@@ -1,15 +1,20 @@
-#include <linux/mm_types.h>
+#include <linux/sched.h>
 #include <linux/module.h>
 
 void mm_read_lock(struct mm_struct *mm)
 {
 	down_read(&mm->mmap_sem);
+	if (current->mm == mm && current->mm_version != mm->version)
+		current->mm_version = mm->version;
 }
 EXPORT_SYMBOL(mm_read_lock);
 
 int mm_read_trylock(struct mm_struct *mm)
 {
-	return down_read_trylock(&mm->mmap_sem);
+	int ret = down_read_trylock(&mm->mmap_sem);
+	if (ret && current->mm == mm && current->mm_version != mm->version)
+		current->mm_version = mm->version;
+	return ret;
 }
 EXPORT_SYMBOL(mm_read_trylock);
 
@@ -22,18 +27,24 @@ EXPORT_SYMBOL(mm_read_unlock);
 void mm_write_lock(struct mm_struct *mm)
 {
 	down_write(&mm->mmap_sem);
+	mm->version++;
 }
 EXPORT_SYMBOL(mm_write_lock);
 
 void mm_write_unlock(struct mm_struct *mm)
 {
+	mm->version++;
 	up_write(&mm->mmap_sem);
 }
 EXPORT_SYMBOL(mm_write_unlock);
 
 int mm_write_trylock(struct mm_struct *mm)
 {
-	return down_write_trylock(&mm->mmap_sem);
+	int ret = down_write_trylock(&mm->mmap_sem);
+
+	if (ret)
+		mm->version++;
+	return ret;
 }
 EXPORT_SYMBOL(mm_write_trylock);
 
@@ -45,6 +56,7 @@ EXPORT_SYMBOL(mm_is_locked);
 
 void mm_write_to_read_lock(struct mm_struct *mm)
 {
+	mm->version++;
 	downgrade_write(&mm->mmap_sem);
 }
 EXPORT_SYMBOL(mm_write_to_read_lock);
@@ -78,3 +90,14 @@ void mm_read_might_lock(struct mm_struct
 	might_lock_read(&mm->mmap_sem);
 }
 EXPORT_SYMBOL(mm_read_might_lock);
+
+/*
+ * Called when mm is accessed without read-lock or for chekcing
+ * per-thread cached value is stale or not.
+ */
+int mm_version_check(struct mm_struct *mm)
+{
+	if ((current->mm == mm) && (current->mm_version != mm->version))
+		return 0;
+	return 1;
+}

