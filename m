Return-Path: <linux-kernel-owner+w=401wt.eu-S1762355AbXHCN4I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762355AbXHCN4I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 09:56:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761331AbXHCNzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 09:55:55 -0400
Received: from perninha.conectiva.com.br ([200.140.247.100]:37663 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758087AbXHCNzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 09:55:55 -0400
Date: Fri, 3 Aug 2007 10:55:46 -0300
From: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
To: ak@suse.de
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] x86_64: convert mm_context_t semaphore to a mutex
Message-ID: <20070803105546.28e5217d@localhost>
Organization: Mandriva
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i586-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Luiz Fernando N. Capitulino <lcapitulino@mandriva.com.br>
---
 arch/x86_64/kernel/ldt.c    |   14 +++++++-------
 arch/x86_64/kernel/ptrace.c |    4 ++--
 include/asm-x86_64/mmu.h    |    4 ++--
 3 files changed, 11 insertions(+), 11 deletions(-)

Index: linux-2.6-lcpt/arch/x86_64/kernel/ldt.c
===================================================================
--- linux-2.6-lcpt.orig/arch/x86_64/kernel/ldt.c
+++ linux-2.6-lcpt/arch/x86_64/kernel/ldt.c
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
Index: linux-2.6-lcpt/arch/x86_64/kernel/ptrace.c
===================================================================
--- linux-2.6-lcpt.orig/arch/x86_64/kernel/ptrace.c
+++ linux-2.6-lcpt/arch/x86_64/kernel/ptrace.c
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
Index: linux-2.6-lcpt/include/asm-x86_64/mmu.h
===================================================================
--- linux-2.6-lcpt.orig/include/asm-x86_64/mmu.h
+++ linux-2.6-lcpt/include/asm-x86_64/mmu.h
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
 


-- 
Luiz Fernando N. Capitulino
