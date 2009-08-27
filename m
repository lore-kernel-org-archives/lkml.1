Return-Path: <linux-kernel-owner+w=401wt.eu-S1751054AbZH0REE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751054AbZH0REE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 13:04:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751006AbZH0RED
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 13:04:03 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:34833 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750829AbZH0REC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 13:04:02 -0400
Subject: [PATCH 1/2] kmemleak: Inform kmemleak about kernel stack allocation
To: x86@kernel.org, linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Date: Thu, 27 Aug 2009 18:02:53 +0100
Message-ID: <20090827170253.27901.33997.stgit@pc1117.cambridge.arm.com>
In-Reply-To: <20090827165927.27901.97270.stgit@pc1117.cambridge.arm.com>
References: <20090827165927.27901.97270.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.15-rc2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Aug 2009 17:02:53.0535 (UTC) FILETIME=[3771FEF0:01CA2738]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Traversing all the tasks in the system for scanning the kernel stacks
requires locking which increases the kernel latency considerably. This
patch informs kmemleak about newly allocated or freed stacks so that
they are treated as any other allocated object. Subsequent patch will
remove the explicit stack scanning from mm/kmemleak.c.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
---
 arch/x86/include/asm/thread_info.h |    7 ++++++-
 arch/x86/kernel/process.c          |    2 ++
 kernel/fork.c                      |    7 ++++++-
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index fad7d40..f26432a 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -162,7 +162,12 @@ struct thread_info {
 #define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
 
 #define alloc_thread_info(tsk)						\
-	((struct thread_info *)__get_free_pages(THREAD_FLAGS, THREAD_ORDER))
+({									\
+	struct thread_info *ti = (struct thread_info *)			\
+		__get_free_pages(THREAD_FLAGS, THREAD_ORDER);		\
+	kmemleak_alloc(ti, THREAD_SIZE, 1, THREAD_FLAGS);		\
+	ti;								\
+})
 
 #ifdef CONFIG_X86_32
 
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 071166a..a9972db 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -9,6 +9,7 @@
 #include <linux/pm.h>
 #include <linux/clockchips.h>
 #include <linux/random.h>
+#include <linux/kmemleak.h>
 #include <trace/power.h>
 #include <asm/system.h>
 #include <asm/apic.h>
@@ -55,6 +56,7 @@ void free_thread_xstate(struct task_struct *tsk)
 void free_thread_info(struct thread_info *ti)
 {
 	free_thread_xstate(ti->task);
+	kmemleak_free(ti);
 	free_pages((unsigned long)ti, get_order(THREAD_SIZE));
 }
 
diff --git a/kernel/fork.c b/kernel/fork.c
index e6c04d4..ece8199 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -62,6 +62,7 @@
 #include <linux/fs_struct.h>
 #include <linux/magic.h>
 #include <linux/perf_counter.h>
+#include <linux/kmemleak.h>
 
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
@@ -104,16 +105,20 @@ static struct kmem_cache *task_struct_cachep;
 #ifndef __HAVE_ARCH_THREAD_INFO_ALLOCATOR
 static inline struct thread_info *alloc_thread_info(struct task_struct *tsk)
 {
+	struct thread_info *ti;
 #ifdef CONFIG_DEBUG_STACK_USAGE
 	gfp_t mask = GFP_KERNEL | __GFP_ZERO;
 #else
 	gfp_t mask = GFP_KERNEL;
 #endif
-	return (struct thread_info *)__get_free_pages(mask, THREAD_SIZE_ORDER);
+	ti = (struct thread_info *)__get_free_pages(mask, THREAD_SIZE_ORDER);
+	kmemleak_alloc(ti, THREAD_SIZE, 1, mask);
+	return ti;
 }
 
 static inline void free_thread_info(struct thread_info *ti)
 {
+	kmemleak_free(ti);
 	free_pages((unsigned long)ti, THREAD_SIZE_ORDER);
 }
 #endif

