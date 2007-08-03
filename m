Return-Path: <linux-kernel-owner+w=401wt.eu-S932246AbXHCN4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932246AbXHCN4j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 09:56:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761737AbXHCNz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 09:55:58 -0400
Received: from perninha.conectiva.com.br ([200.140.247.100]:37666 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761475AbXHCNz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 09:55:56 -0400
Date: Fri, 3 Aug 2007 10:55:40 -0300
From: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: [PATCH] i386: convert mm_context_t semaphore to a mutex
Message-ID: <20070803105540.4f85ae09@localhost>
Organization: Mandriva
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i586-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Luiz Fernando N. Capitulino <lcapitulino@mandriva.com.br>
---
 arch/i386/kernel/i386_ksyms.c |    1 +
 arch/i386/kernel/ldt.c        |   14 +++++++-------
 arch/i386/kernel/ptrace.c     |    4 ++--
 include/asm-i386/mmu.h        |    4 ++--
 4 files changed, 12 insertions(+), 11 deletions(-)

--- linux-2.6-lcpt.orig/arch/i386/kernel/ldt.c
+++ linux-2.6-lcpt/arch/i386/kernel/ldt.c
@@ -94,13 +94,13 @@ int init_new_context(struct task_struct 
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
@@ -132,7 +132,7 @@ static int read_ldt(void __user * ptr, u
 	if (bytecount > LDT_ENTRY_SIZE*LDT_ENTRIES)
 		bytecount = LDT_ENTRY_SIZE*LDT_ENTRIES;
 
-	down(&mm->context.sem);
+	mutex_lock(&mm->context.lock);
 	size = mm->context.size*LDT_ENTRY_SIZE;
 	if (size > bytecount)
 		size = bytecount;
@@ -140,7 +140,7 @@ static int read_ldt(void __user * ptr, u
 	err = 0;
 	if (copy_to_user(ptr, mm->context.ldt, size))
 		err = -EFAULT;
-	up(&mm->context.sem);
+	mutex_unlock(&mm->context.lock);
 	if (err < 0)
 		goto error_return;
 	if (size != bytecount) {
@@ -196,7 +196,7 @@ static int write_ldt(void __user * ptr, 
 			goto out;
 	}
 
-	down(&mm->context.sem);
+	mutex_lock(&mm->context.lock);
 	if (ldt_info.entry_number >= mm->context.size) {
 		error = alloc_ldt(&current->mm->context, ldt_info.entry_number+1, 1);
 		if (error < 0)
@@ -223,7 +223,7 @@ install:
 	error = 0;
 
 out_unlock:
-	up(&mm->context.sem);
+	mutex_unlock(&mm->context.lock);
 out:
 	return error;
 }
--- linux-2.6-lcpt.orig/arch/i386/kernel/ptrace.c
+++ linux-2.6-lcpt/arch/i386/kernel/ptrace.c
@@ -166,7 +166,7 @@ static unsigned long convert_eip_to_line
 
 		seg &= ~7UL;
 
-		down(&child->mm->context.sem);
+		mutex_lock(&child->mm->context.lock);
 		if (unlikely((seg >> 3) >= child->mm->context.size))
 			addr = -1L; /* bogus selector, access would fault */
 		else {
@@ -180,7 +180,7 @@ static unsigned long convert_eip_to_line
 				addr &= 0xffff;
 			addr += base;
 		}
-		up(&child->mm->context.sem);
+		mutex_unlock(&child->mm->context.lock);
 	}
 	return addr;
 }
--- linux-2.6-lcpt.orig/include/asm-i386/mmu.h
+++ linux-2.6-lcpt/include/asm-i386/mmu.h
@@ -1,7 +1,7 @@
 #ifndef __i386_MMU_H
 #define __i386_MMU_H
 
-#include <asm/semaphore.h>
+#include <linux/mutex.h>
 /*
  * The i386 doesn't have a mmu context, but
  * we put the segment information here.
@@ -10,7 +10,7 @@
  */
 typedef struct { 
 	int size;
-	struct semaphore sem;
+	struct mutex lock;
 	void *ldt;
 	void *vdso;
 } mm_context_t;
--- linux-2.6-lcpt.orig/arch/i386/kernel/i386_ksyms.c
+++ linux-2.6-lcpt/arch/i386/kernel/i386_ksyms.c
@@ -1,4 +1,5 @@
 #include <linux/module.h>
+#include <asm/semaphore.h>
 #include <asm/checksum.h>
 #include <asm/desc.h>
 


-- 
Luiz Fernando N. Capitulino
