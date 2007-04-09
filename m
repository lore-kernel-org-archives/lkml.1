Return-Path: <linux-kernel-owner+w=401wt.eu-S1753146AbXDIMpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146AbXDIMpZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 08:45:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753150AbXDIMpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 08:45:25 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:14002 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753146AbXDIMpY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 08:45:24 -0400
Message-ID: <461A35BD.30506@sw.ru>
Date: Mon, 09 Apr 2007 16:46:53 +0400
From: Pavel Emelianov <xemul@sw.ru>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>, Paul Menage <menage@google.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>
CC: devel@openvz.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kirill Korotaev <dev@sw.ru>, Chandra Seetharaman <sekharan@us.ibm.com>,
       Cedric Le Goater <clg@fr.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Rohit Seth <rohitseth@google.com>,
       Linux Containers <containers@lists.osdl.org>
Subject: [PATCH 3/8] Add container pointer on mm_struct
References: <461A3010.90403@sw.ru>
In-Reply-To: <461A3010.90403@sw.ru>
Content-Type: multipart/mixed;
 boundary="------------040602010801010902060101"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040602010801010902060101
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Naturally mm_struct determines the resource consumer in memory
accounting. So each mm_struct should have a pointer on container
it belongs to. When a new task is created its mm_struct is
assigned to the container this task belongs to.

--------------040602010801010902060101
Content-Type: text/plain;
 name="diff-rss-container-on-mm-struct"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="diff-rss-container-on-mm-struct"

diff -upr linux-2.6.20.orig/include/linux/sched.h linux-2.6.20-2/include/linux/sched.h
--- linux-2.6.20.orig/include/linux/sched.h	2007-04-09 11:26:06.000000000 +0400
+++ linux-2.6.20-2/include/linux/sched.h	2007-04-09 11:26:06.000000000 +0400
@@ -373,6 +373,9 @@ struct mm_struct {
 	/* aio bits */
 	rwlock_t		ioctx_list_lock;
 	struct kioctx		*ioctx_list;
+#ifdef CONFIG_RSS_CONTAINER
+	struct rss_container	*rss_container;
+#endif
 };
 
 struct sighand_struct {
diff -upr linux-2.6.20.orig/kernel/fork.c linux-2.6.20-2/kernel/fork.c
--- linux-2.6.20.orig/kernel/fork.c	2007-04-09 11:26:06.000000000 +0400
+++ linux-2.6.20-2/kernel/fork.c	2007-04-09 11:26:06.000000000 +0400
@@ -57,6 +57,8 @@
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
 
+#include <linux/rss_container.h>
+
 /*
  * Protected counters by write_lock_irq(&tasklist_lock)
  */
@@ -325,7 +327,7 @@ static inline void mm_free_pgd(struct mm
 
 #include <linux/init_task.h>
 
-static struct mm_struct * mm_init(struct mm_struct * mm)
+static struct mm_struct * mm_init(struct mm_struct *mm, struct task_struct *tsk)
 {
 	atomic_set(&mm->mm_users, 1);
 	atomic_set(&mm->mm_count, 1);
@@ -340,11 +342,14 @@ static struct mm_struct * mm_init(struct
 	mm->ioctx_list = NULL;
 	mm->free_area_cache = TASK_UNMAPPED_BASE;
 	mm->cached_hole_size = ~0UL;
+	mm_init_container(mm, tsk);
 
 	if (likely(!mm_alloc_pgd(mm))) {
 		mm->def_flags = 0;
 		return mm;
 	}
+
+	mm_free_container(mm);
 	free_mm(mm);
 	return NULL;
 }
@@ -359,7 +364,7 @@ struct mm_struct * mm_alloc(void)
 	mm = allocate_mm();
 	if (mm) {
 		memset(mm, 0, sizeof(*mm));
-		mm = mm_init(mm);
+		mm = mm_init(mm, current);
 	}
 	return mm;
 }
@@ -373,6 +378,7 @@ void fastcall __mmdrop(struct mm_struct 
 {
 	BUG_ON(mm == &init_mm);
 	mm_free_pgd(mm);
+	mm_free_container(mm);
 	destroy_context(mm);
 	free_mm(mm);
 }
@@ -493,7 +499,7 @@ static struct mm_struct *dup_mm(struct t
 	mm->token_priority = 0;
 	mm->last_interval = 0;
 
-	if (!mm_init(mm))
+	if (!mm_init(mm, tsk))
 		goto fail_nomem;
 
 	if (init_new_context(tsk, mm))
@@ -520,6 +526,7 @@ fail_nocontext:
 	 * because it calls destroy_context()
 	 */
 	mm_free_pgd(mm);
+	mm_free_container(mm);
 	free_mm(mm);
 	return NULL;
 }


--------------040602010801010902060101--
