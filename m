Return-Path: <linux-kernel-owner+w=401wt.eu-S1031566AbXD3Rms@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031566AbXD3Rms (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 13:42:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031569AbXD3Rms
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 13:42:48 -0400
Received: from holomorphy.com ([66.93.40.71]:56412 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031566AbXD3Rmq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 13:42:46 -0400
Date: Mon, 30 Apr 2007 10:43:10 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Christoph Hellwig <hch@infradead.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Chinner <dgc@sgi.com>, Zan Lynx <zlynx@acm.org>,
       Adrian Bunk <bunk@stusta.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [2/6] add config option to vmalloc stacks (was: Re: [-mm patch] i386: enable 4k stacks by default)
Message-ID: <20070430174310.GE19966@holomorphy.com>
References: <20070428191927.GN3468@stusta.de> <1177795118.7828.6.camel@localhost> <20070430035838.GC77450368@melbourne.sgi.com> <20070430091754.24df88df@the-village.bc.nu> <p73wszuyx7h.fsf@bingen.suse.de> <20070430104806.GA14944@infradead.org> <p73slaiys9v.fsf@bingen.suse.de> <20070430173819.GC19966@holomorphy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070430173819.GC19966@holomorphy.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2007 at 10:38:19AM -0700, William Lee Irwin III wrote:
> Here's what I did for i386 for someone concerned about blowing the stack.

Add a config option to vmalloc() task stacks so that stack overflows are
detected without fail, and with a fatal failure mode at that.

Signed-off-by: William Irwin <wli@holomorphy.com>


Index: stack-paranoia/arch/i386/Kconfig.debug
===================================================================
--- stack-paranoia.orig/arch/i386/Kconfig.debug	2007-04-30 10:31:43.878562345 -0700
+++ stack-paranoia/arch/i386/Kconfig.debug	2007-04-30 10:32:56.182682722 -0700
@@ -35,6 +35,15 @@
 
 	  This option will slow down process creation somewhat.
 
+config VMALLOC_STACK
+	bool "vmalloc() the stack"
+	depends on DEBUG_KERNEL
+	help
+	  Allocates the stack physically discontiguously and from high
+	  memory. Furthermore an unmapped guard page follows the stack.
+	  This is not for end-users. It's intended to trigger fatal
+	  system errors under various forms of stack abuse.
+
 comment "Page alloc debug is incompatible with Software Suspend on i386"
 	depends on DEBUG_KERNEL && SOFTWARE_SUSPEND
 
Index: stack-paranoia/arch/i386/kernel/process.c
===================================================================
--- stack-paranoia.orig/arch/i386/kernel/process.c	2007-04-30 10:26:15.979876464 -0700
+++ stack-paranoia/arch/i386/kernel/process.c	2007-04-30 10:32:56.178682494 -0700
@@ -25,6 +25,7 @@
 #include <linux/stddef.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
+#include <linux/workqueue.h>
 #include <linux/user.h>
 #include <linux/a.out.h>
 #include <linux/interrupt.h>
@@ -322,6 +323,58 @@
 	show_trace(NULL, regs, &regs->esp);
 }
 
+#ifdef CONFIG_VMALLOC_STACK
+struct thread_info *alloc_thread_info(struct task_struct *unused)
+{
+	int i;
+	struct page *pages[THREAD_SIZE/PAGE_SIZE], **tmp = pages;
+	struct vm_struct *area;
+
+	/*
+	 * passing VM_IOREMAP for the sake of alignment is why
+	 * all this is done by hand.
+	 */
+	area = get_vm_area(THREAD_SIZE, VM_IOREMAP);
+	if (!area)
+		return NULL;
+	for (i = 0; i < THREAD_SIZE/PAGE_SIZE; ++i) {
+		pages[i] = alloc_page(GFP_HIGHUSER);
+		if (!pages[i])
+			goto out_free_pages;
+	}
+	/* implicitly transfer page refcounts to the vm_struct */
+	if (map_vm_area(area, PAGE_KERNEL, &tmp))
+		goto out_remove_area;
+	/* it may be worth poisoning, save thread_info proper */
+	return (struct thread_info *)area->addr;
+out_remove_area:
+	remove_vm_area(area);
+out_free_pages:
+	do {
+		__free_page(pages[--i]);
+	} while (i >= 0);
+	return NULL;
+}
+
+static void work_free_thread_info(struct work_struct *work)
+{
+	int i;
+	void *p = work;
+
+	for (i = 0; i < THREAD_SIZE/PAGE_SIZE; ++i)
+		__free_page(vmalloc_to_page(p + PAGE_SIZE*i));
+	vfree(p);
+}
+
+void free_thread_info(struct thread_info *info)
+{
+	struct work_struct *work = (struct work_struct *)info;
+
+	INIT_WORK(work, work_free_thread_info);
+	schedule_work(work);
+}
+#endif
+
 /*
  * This gets run with %ebx containing the
  * function to call, and %edx containing
Index: stack-paranoia/include/asm-i386/module.h
===================================================================
--- stack-paranoia.orig/include/asm-i386/module.h	2007-04-30 10:31:43.882562573 -0700
+++ stack-paranoia/include/asm-i386/module.h	2007-04-30 10:32:56.182682722 -0700
@@ -74,6 +74,13 @@
 #define MODULE_STACKSIZE "64KSTACKS "
 #endif
 
-#define MODULE_ARCH_VERMAGIC MODULE_PROC_FAMILY MODULE_STACKSIZE
+#ifdef CONFIG_VMALLOC_STACK
+#define MODULE_VMALLOC_STACK "VMALLOCSTACKS "
+#else
+#define MODULE_VMALLOC_STACK ""
+#endif
+
+#define MODULE_ARCH_VERMAGIC MODULE_PROC_FAMILY MODULE_STACKSIZE \
+		MODULE_VMALLOC_STACK
 
 #endif /* _ASM_I386_MODULE_H */
Index: stack-paranoia/include/asm-i386/thread_info.h
===================================================================
--- stack-paranoia.orig/include/asm-i386/thread_info.h	2007-04-30 10:31:43.882562573 -0700
+++ stack-paranoia/include/asm-i386/thread_info.h	2007-04-30 10:32:56.182682722 -0700
@@ -102,6 +102,11 @@
 }
 
 /* thread information allocation */
+#ifdef CONFIG_VMALLOC_STACK
+struct task_struct;
+struct thread_info *alloc_thread_info(struct task_struct *);
+void free_thread_info(struct thread_info *);
+#else /* !CONFIG_VMALLOC_STACK */
 #ifdef CONFIG_DEBUG_STACK_USAGE
 #define alloc_thread_info(tsk) kzalloc(THREAD_SIZE, GFP_KERNEL)
 #else
@@ -109,6 +114,7 @@
 #endif
 
 #define free_thread_info(info)	kfree(info)
+#endif /* !CONFIG_VMALLOC_STACK */
 
 #else /* !__ASSEMBLY__ */
 
