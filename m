Return-Path: <linux-kernel-owner+w=401wt.eu-S1765557AbXHFNs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765557AbXHFNs7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 09:48:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761970AbXHFNss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 09:48:48 -0400
Received: from perninha.conectiva.com.br ([200.140.247.100]:42156 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761539AbXHFNsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 09:48:47 -0400
Date: Mon, 6 Aug 2007 10:34:58 -0300
From: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i386: convert mm_context_t semaphore to a mutex
Message-ID: <20070806103458.4b35c90d@localhost>
In-Reply-To: <20070806074608.GA12415@elte.hu>
References: <20070803105540.4f85ae09@localhost>
	<20070806074608.GA12415@elte.hu>
Organization: Mandriva
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i586-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, 6 Aug 2007 09:46:08 +0200
Ingo Molnar <mingo@elte.hu> escreveu:

| 
| >  typedef struct { 
| >  	int size;
| > -	struct semaphore sem;
| > +	struct mutex lock;
| 
| hm, looks good to me but i'm wondering why this was a holdout for such a 
| long time :-) Did you manage to test actual LDT functionality with this 
| patch applied?

 No, I didn't. The only test I did was to run the kernel with this
patch applied.

 I'll manage to test it then. Do you have a test-case or has any
suggestion?

 Oh, btw, I forgot to 'quilt add arch/i386/mm/fault.c' so the
patch I sent was incomplete. Fixed version below. Shame on me.

[PATCH] i386: convert mm_context_t semaphore to a mutex

---
 arch/i386/kernel/i386_ksyms.c |    1 +
 arch/i386/kernel/ldt.c        |   14 +++++++-------
 arch/i386/kernel/ptrace.c     |    4 ++--
 arch/i386/mm/fault.c          |    4 ++--
 include/asm-i386/mmu.h        |    4 ++--
 5 files changed, 14 insertions(+), 13 deletions(-)

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
 
--- linux-2.6-lcpt.orig/arch/i386/mm/fault.c
+++ linux-2.6-lcpt/arch/i386/mm/fault.c
@@ -110,7 +110,7 @@ static inline unsigned long get_segment_
 	   LDT and other horrors are only used in user space. */
 	if (seg & (1<<2)) {
 		/* Must lock the LDT while reading it. */
-		down(&current->mm->context.sem);
+		mutex_lock(&current->mm->context.lock);
 		desc = current->mm->context.ldt;
 		desc = (void *)desc + (seg & ~7);
 	} else {
@@ -123,7 +123,7 @@ static inline unsigned long get_segment_
 	base = get_desc_base((unsigned long *)desc);
 
 	if (seg & (1<<2)) { 
-		up(&current->mm->context.sem);
+		mutex_unlock(&current->mm->context.lock);
 	} else
 		put_cpu();
 


-- 
Luiz Fernando N. Capitulino
