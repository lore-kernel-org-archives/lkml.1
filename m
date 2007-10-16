Return-Path: <linux-kernel-owner+w=401wt.eu-S1758214AbXJPAgx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758214AbXJPAgx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 20:36:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765453AbXJPAge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 20:36:34 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:32921 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765400AbXJPAgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 20:36:32 -0400
Subject: Re: [PATCH 2/11] maps3: introduce task_size_of for all arches
From: Dave Hansen <haveblue@us.ibm.com>
To: David Rientjes <rientjes@google.com>
Cc: Matt Mackall <mpm@selenic.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Fengguang Wu <wfg@mail.ustc.edu.cn>
In-Reply-To: <alpine.DEB.0.9999.0710151643260.18722@chino.kir.corp.google.com>
References: <3.290135367@selenic.com>
	 <alpine.DEB.0.9999.0710151643260.18722@chino.kir.corp.google.com>
Content-Type: text/plain
Date: Mon, 15 Oct 2007 17:36:29 -0700
Message-Id: <1192494989.6118.142.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David,

All of your comments looked pretty valid to me.  I've refreshed that
patch.

I haven't even compile-tested this so there may be some fat fingering
somewhere.  I'll run compile tests on it now.

-- Dave


For the /proc/<pid>/pagemap code[1], we need to able to query how
much virtual address space a particular task has.  The trick is
that we do it through /proc and can't use TASK_SIZE since it
references "current" on some arches.  The process opening the
/proc file might be a 32-bit process opening a 64-bit process's
pagemap file.

x86_64 already has a TASK_SIZE_OF() macro:

#define TASK_SIZE_OF(child)     ((test_tsk_thread_flag(child, TIF_IA32)) ? IA32_PAGE_OFFSET : TASK_SIZE64)

I'd like to have that for other architectures.  So, add it
for all the architectures that actually use "current" in 
their TASK_SIZE.  For the others, just add a quick #define
in sched.h to use plain old TASK_SIZE.

1. http://www.linuxworld.com/news/2007/042407-kernel.html

- MIPS portion from Ralf Baechle <ralf@linux-mips.org>

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Matt Mackall <mpm@selenic.com>
---

 lxc-dave/include/asm-ia64/processor.h    |    3 ++-
 lxc-dave/include/asm-mips/processor.h    |    4 ++++
 lxc-dave/include/asm-parisc/processor.h  |    3 ++-
 lxc-dave/include/asm-powerpc/processor.h |    3 ++-
 lxc-dave/include/asm-s390/processor.h    |    3 ++-
 lxc-dave/include/linux/sched.h           |    4 ++++
 6 files changed, 16 insertions(+), 4 deletions(-)

diff -puN include/asm-ia64/processor.h~PATCH_2_11_maps3-_introduce_task_size_of_for_all_arches include/asm-ia64/processor.h
--- lxc/include/asm-ia64/processor.h~PATCH_2_11_maps3-_introduce_task_size_of_for_all_arches	2007-10-15 17:29:22.000000000 -0700
+++ lxc-dave/include/asm-ia64/processor.h	2007-10-15 17:29:22.000000000 -0700
@@ -31,7 +31,8 @@
  * each (assuming 8KB page size), for a total of 8TB of user virtual
  * address space.
  */
-#define TASK_SIZE		(current->thread.task_size)
+#define TASK_SIZE_OF(tsk)	((tsk)->thread.task_size)
+#define TASK_SIZE       	TASK_SIZE_OF(current)
 
 /*
  * This decides where the kernel will search for a free chunk of vm
diff -puN include/asm-mips/processor.h~PATCH_2_11_maps3-_introduce_task_size_of_for_all_arches include/asm-mips/processor.h
--- lxc/include/asm-mips/processor.h~PATCH_2_11_maps3-_introduce_task_size_of_for_all_arches	2007-10-15 17:29:22.000000000 -0700
+++ lxc-dave/include/asm-mips/processor.h	2007-10-15 17:34:12.000000000 -0700
@@ -45,6 +45,8 @@ extern unsigned int vced_count, vcei_cou
  * space during mmap's.
  */
 #define TASK_UNMAPPED_BASE	(PAGE_ALIGN(TASK_SIZE / 3))
+#define TASK_SIZE_OF(tsk)						\
+	(test_tsk_thread_flag(tak, TIF_32BIT_ADDR) ? TASK_SIZE32 : TASK_SIZE)
 #endif
 
 #ifdef CONFIG_64BIT
@@ -65,6 +67,8 @@ extern unsigned int vced_count, vcei_cou
 #define TASK_UNMAPPED_BASE						\
 	(test_thread_flag(TIF_32BIT_ADDR) ?				\
 		PAGE_ALIGN(TASK_SIZE32 / 3) : PAGE_ALIGN(TASK_SIZE / 3))
+#define TASK_SIZE_OF(tsk)						\
+	(test_tsk_thread_flag(TIF_32BIT_ADDR) ? TASK_SIZE32 : TASK_SIZE)
 #endif
 
 #define NUM_FPU_REGS	32
diff -puN include/asm-parisc/processor.h~PATCH_2_11_maps3-_introduce_task_size_of_for_all_arches include/asm-parisc/processor.h
--- lxc/include/asm-parisc/processor.h~PATCH_2_11_maps3-_introduce_task_size_of_for_all_arches	2007-10-15 17:29:22.000000000 -0700
+++ lxc-dave/include/asm-parisc/processor.h	2007-10-15 17:31:39.000000000 -0700
@@ -32,7 +32,8 @@
 #endif
 #define current_text_addr() ({ void *pc; current_ia(pc); pc; })
 
-#define TASK_SIZE               (current->thread.task_size)
+#define TASK_SIZE_OF(tsk)       ((tsk)->thread.task_size)
+#define TASK_SIZE	        TASK_SIZE_OF(current)
 #define TASK_UNMAPPED_BASE      (current->thread.map_base)
 
 #define DEFAULT_TASK_SIZE32	(0xFFF00000UL)
diff -puN include/asm-powerpc/processor.h~PATCH_2_11_maps3-_introduce_task_size_of_for_all_arches include/asm-powerpc/processor.h
--- lxc/include/asm-powerpc/processor.h~PATCH_2_11_maps3-_introduce_task_size_of_for_all_arches	2007-10-15 17:29:22.000000000 -0700
+++ lxc-dave/include/asm-powerpc/processor.h	2007-10-15 17:32:00.000000000 -0700
@@ -99,8 +99,9 @@ extern struct task_struct *last_task_use
  */
 #define TASK_SIZE_USER32 (0x0000000100000000UL - (1*PAGE_SIZE))
 
-#define TASK_SIZE (test_thread_flag(TIF_32BIT) ? \
+#define TASK_SIZE_OF(tsk) (test_tsk_thread_flag(tsk, TIF_32BIT) ? \
 		TASK_SIZE_USER32 : TASK_SIZE_USER64)
+#define TASK_SIZE	  TASK_SIZE_OF(current)
 
 /* This decides where the kernel will search for a free chunk of vm
  * space during mmap's.
diff -puN include/asm-s390/processor.h~PATCH_2_11_maps3-_introduce_task_size_of_for_all_arches include/asm-s390/processor.h
--- lxc/include/asm-s390/processor.h~PATCH_2_11_maps3-_introduce_task_size_of_for_all_arches	2007-10-15 17:29:22.000000000 -0700
+++ lxc-dave/include/asm-s390/processor.h	2007-10-15 17:32:31.000000000 -0700
@@ -73,8 +73,9 @@ extern struct task_struct *last_task_use
 
 #else /* __s390x__ */
 
-# define TASK_SIZE		(test_thread_flag(TIF_31BIT) ? \
+# define TASK_SIZE_OF(tsk)	(test_tsk_thread_flag(tsk, TIF_31BIT) ? \
 					(0x80000000UL) : (0x40000000000UL))
+# define TASK_SIZE		TASK_SIZE_OF(current)
 # define TASK_UNMAPPED_BASE	(TASK_SIZE / 2)
 # define DEFAULT_TASK_SIZE	(0x40000000000UL)
 
diff -puN include/linux/sched.h~PATCH_2_11_maps3-_introduce_task_size_of_for_all_arches include/linux/sched.h
--- lxc/include/linux/sched.h~PATCH_2_11_maps3-_introduce_task_size_of_for_all_arches	2007-10-15 17:29:22.000000000 -0700
+++ lxc-dave/include/linux/sched.h	2007-10-15 17:32:42.000000000 -0700
@@ -1953,6 +1953,10 @@ static inline void inc_syscw(struct task
 }
 #endif
 
+#ifndef TASK_SIZE_OF
+#define TASK_SIZE_OF(tsk)	TASK_SIZE
+#endif
+
 #endif /* __KERNEL__ */
 
 #endif
_


