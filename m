Return-Path: <linux-kernel-owner+w=401wt.eu-S1765003AbXIUUxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765003AbXIUUxu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 16:53:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762679AbXIUUpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 16:45:21 -0400
Received: from ns2.suse.de ([195.135.220.15]:32991 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762944AbXIUUpL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 16:45:11 -0400
From: Andi Kleen <ak@suse.de>
References: <200709211044.901175000@suse.de>
In-Reply-To: <200709211044.901175000@suse.de>
To: lcapitulino@mandriva.com.br, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [27/45] x86_64: convert mm_context_t semaphore to a mutex
Message-Id: <20070921204509.8FF4414EFF@wotan.suse.de>
Date: Fri, 21 Sep 2007 22:45:09 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>

Signed-off-by: Luiz Fernando N. Capitulino <lcapitulino@mandriva.com.br>
Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86_64/kernel/ldt.c    |   14 +++++++-------
 arch/x86_64/kernel/ptrace.c |    4 ++--
 include/asm-x86_64/mmu.h    |    4 ++--
 3 files changed, 11 insertions(+), 11 deletions(-)

Index: linux/arch/x86_64/kernel/ldt.c
===================================================================
--- linux.orig/arch/x86_64/kernel/ldt.c
+++ linux/arch/x86_64/kernel/ldt.c
@@ -98,13 +98,13 @@ int init_new_context(struct task_struct 
 	struct mm_struct * old_mm;
 	int retval = 0;
 
-	init_MUTEX(&mm->context.sem);
+	mutex_init(&mm->context.lock);
 	mm->context.size = 0;
 	old_mm = current->mm;
 	if (old_mm && old_mm->context.size > 0) {
-		down(&old_mm->context.sem);
+		mutex_lock(&old_mm->context.lock);
 		retval = copy_ldt(&mm->context, &old_mm->context);
-		up(&old_mm->context.sem);
+		mutex_unlock(&old_mm->context.lock);
 	}
 	return retval;
 }
@@ -135,7 +135,7 @@ static int read_ldt(void __user * ptr, u
 	if (bytecount > LDT_ENTRY_SIZE*LDT_ENTRIES)
 		bytecount = LDT_ENTRY_SIZE*LDT_ENTRIES;
 
-	down(&mm->context.sem);
+	mutex_lock(&mm->context.lock);
 	size = mm->context.size*LDT_ENTRY_SIZE;
 	if (size > bytecount)
 		size = bytecount;
@@ -143,7 +143,7 @@ static int read_ldt(void __user * ptr, u
 	err = 0;
 	if (copy_to_user(ptr, mm->context.ldt, size))
 		err = -EFAULT;
-	up(&mm->context.sem);
+	mutex_unlock(&mm->context.lock);
 	if (err < 0)
 		goto error_return;
 	if (size != bytecount) {
@@ -195,7 +195,7 @@ static int write_ldt(void __user * ptr, 
 			goto out;
 	}
 
-	down(&mm->context.sem);
+	mutex_lock(&mm->context.lock);
 	if (ldt_info.entry_number >= (unsigned)mm->context.size) {
 		error = alloc_ldt(&current->mm->context, ldt_info.entry_number+1, 1);
 		if (error < 0)
@@ -225,7 +225,7 @@ install:
 	error = 0;
 
 out_unlock:
-	up(&mm->context.sem);
+	mutex_unlock(&mm->context.lock);
 out:
 	return error;
 }
Index: linux/arch/x86_64/kernel/ptrace.c
===================================================================
--- linux.orig/arch/x86_64/kernel/ptrace.c
+++ linux/arch/x86_64/kernel/ptrace.c
@@ -104,7 +104,7 @@ unsigned long convert_rip_to_linear(stru
 
 		seg &= ~7UL;
 
-		down(&child->mm->context.sem);
+		mutex_lock(&child->mm->context.lock);
 		if (unlikely((seg >> 3) >= child->mm->context.size))
 			addr = -1L; /* bogus selector, access would fault */
 		else {
@@ -118,7 +118,7 @@ unsigned long convert_rip_to_linear(stru
 				addr &= 0xffff;
 			addr += base;
 		}
-		up(&child->mm->context.sem);
+		mutex_unlock(&child->mm->context.lock);
 	}
 
 	return addr;
Index: linux/include/asm-x86_64/mmu.h
===================================================================
--- linux.orig/include/asm-x86_64/mmu.h
+++ linux/include/asm-x86_64/mmu.h
@@ -2,7 +2,7 @@
 #define __x86_64_MMU_H
 
 #include <linux/spinlock.h>
-#include <asm/semaphore.h>
+#include <linux/mutex.h>
 
 /*
  * The x86_64 doesn't have a mmu context, but
@@ -14,7 +14,7 @@ typedef struct { 
 	void *ldt;
 	rwlock_t ldtlock; 
 	int size;
-	struct semaphore sem; 
+	struct mutex lock;
 	void *vdso;
 } mm_context_t;
 
