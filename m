Return-Path: <linux-kernel-owner+w=401wt.eu-S1753459AbZGXQMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459AbZGXQMy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 12:12:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753440AbZGXQMv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 12:12:51 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:51203 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753414AbZGXQMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 12:12:50 -0400
Subject: [PATCH 7/8] kmemleak: Inform kmemleak about kernel stack allocation
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, 24 Jul 2009 17:12:41 +0100
Message-ID: <20090724161240.5752.6828.stgit@pc1117.cambridge.arm.com>
In-Reply-To: <20090724161026.5752.52503.stgit@pc1117.cambridge.arm.com>
References: <20090724161026.5752.52503.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.15-rc1-9-gd8846
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Jul 2009 16:12:41.0408 (UTC) FILETIME=[92086400:01CA0C79]
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
Cc: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/thread_info.h |    7 ++++++-
 arch/x86/kernel/process.c          |    1 +
 kernel/fork.c                      |    7 ++++++-
 3 files changed, 13 insertions(+), 2 deletions(-)

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
index 994dd6a..ac43992 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -55,6 +55,7 @@ void free_thread_xstate(struct task_struct *tsk)
 void free_thread_info(struct thread_info *ti)
 {
 	free_thread_xstate(ti->task);
+	kmemleak_free(ti);
 	free_pages((unsigned long)ti, get_order(THREAD_SIZE));
 }
 
diff --git a/kernel/fork.c b/kernel/fork.c
index 9b42695..47ebc8e 100644
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

