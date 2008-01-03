Return-Path: <linux-kernel-owner+w=401wt.eu-S1755054AbYACA4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054AbYACA4l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 19:56:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754825AbYACAuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 19:50:24 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58364 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759785AbYACAuR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 19:50:17 -0500
From: Andi Kleen <ak@suse.de>
References: <20080103149.088038000@suse.de>
In-Reply-To: <20080103149.088038000@suse.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] [20/20] x86: Print which shared library/executable faulted in segfault etc. messages
Message-Id: <20080103005016.4DA4C14D40@wotan.suse.de>
Date: Thu,  3 Jan 2008 01:50:16 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


They now look like

hal-resmgr[13791]: segfault at 3c rip 2b9c8caec182 rsp 7fff1e825d30 error 4 in libacl.so.1.1.0[2b9c8caea000+6000]

This makes it easier to pinpoint bugs to specific libraries. 

And printing the offset into a mapping also always allows to find the 
correct fault point in a library even with randomized mappings. Previously
there was no way to actually find the correct code address inside
the randomized mapping.

Relies on earlier patch to shorten the printk formats.

They are often now longer than 80 characters, but I think that's worth 
it.

Patch for i386 and x86-64.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/kernel/signal_32.c |    7 +++++--
 arch/x86/kernel/signal_64.c |    7 +++++--
 arch/x86/kernel/traps_32.c  |    7 +++++--
 arch/x86/mm/fault_32.c      |    4 +++-
 include/linux/mm.h          |    1 +
 mm/memory.c                 |   27 +++++++++++++++++++++++++++
 6 files changed, 46 insertions(+), 7 deletions(-)

Index: linux/include/linux/mm.h
===================================================================
--- linux.orig/include/linux/mm.h
+++ linux/include/linux/mm.h
@@ -1145,6 +1145,7 @@ extern int randomize_va_space;
 #endif
 
 const char * arch_vma_name(struct vm_area_struct *vma);
+void print_vma_addr(char *prefix, unsigned long rip);
 
 struct page *sparse_mem_map_populate(unsigned long pnum, int nid);
 pgd_t *vmemmap_pgd_populate(unsigned long addr, int node);
Index: linux/mm/memory.c
===================================================================
--- linux.orig/mm/memory.c
+++ linux/mm/memory.c
@@ -2746,3 +2746,30 @@ int access_process_vm(struct task_struct
 
 	return buf - old_buf;
 }
+
+/*
+ * Print the name of a VMA.
+ */
+void print_vma_addr(char *prefix, unsigned long ip)
+{
+	struct mm_struct *mm = current->mm;
+	struct vm_area_struct *vma;
+	down_read(&mm->mmap_sem);
+	vma = find_vma(mm, ip);
+	if (vma && vma->vm_file) {
+		struct file *f = vma->vm_file;
+		char *buf = (char *)__get_free_page(GFP_KERNEL);
+		if (buf) {
+			char *p, *s;
+			p = d_path(f->f_dentry, f->f_vfsmnt, buf, PAGE_SIZE);
+			s = strrchr(p, '/');
+			if (s)
+				p = s+1;
+			printk("%s%s[%lx+%lx]", prefix, p,
+					vma->vm_start,
+					vma->vm_end - vma->vm_start);
+			free_page((unsigned long)buf);
+		}
+	}
+	up_read(&current->mm->mmap_sem);
+}
Index: linux/arch/x86/kernel/signal_32.c
===================================================================
--- linux.orig/arch/x86/kernel/signal_32.c
+++ linux/arch/x86/kernel/signal_32.c
@@ -198,12 +198,15 @@ asmlinkage int sys_sigreturn(unsigned lo
 	return ax;
 
 badframe:
-	if (show_unhandled_signals && printk_ratelimit())
+	if (show_unhandled_signals && printk_ratelimit()) {
 		printk("%s%s[%d] bad frame in sigreturn frame:%p ip:%lx"
-		       " sp:%lx oeax:%lx\n",
+		       " sp:%lx oeax:%lx",
 		    task_pid_nr(current) > 1 ? KERN_INFO : KERN_EMERG,
 		    current->comm, task_pid_nr(current), frame, regs->ip,
 		    regs->sp, regs->orig_ax);
+		print_vma_addr(" in ", regs->ip);
+		printk("\n");
+	}
 
 	force_sig(SIGSEGV, current);
 	return 0;
Index: linux/arch/x86/kernel/signal_64.c
===================================================================
--- linux.orig/arch/x86/kernel/signal_64.c
+++ linux/arch/x86/kernel/signal_64.c
@@ -481,9 +481,12 @@ do_notify_resume(struct pt_regs *regs, v
 void signal_fault(struct pt_regs *regs, void __user *frame, char *where)
 { 
 	struct task_struct *me = current; 
-	if (show_unhandled_signals && printk_ratelimit())
-		printk("%s[%d] bad frame in %s frame:%p ip:%lx sp:%lx orax:%lx\n",
+	if (show_unhandled_signals && printk_ratelimit()) {
+		printk("%s[%d] bad frame in %s frame:%p ip:%lx sp:%lx orax:%lx",
 	       me->comm,me->pid,where,frame,regs->ip,regs->sp,regs->orig_ax);
+		print_vma_addr(" in ", regs->ip);
+		printk("\n");
+	}
 
 	force_sig(SIGSEGV, me); 
 } 
Index: linux/arch/x86/kernel/traps_32.c
===================================================================
--- linux.orig/arch/x86/kernel/traps_32.c
+++ linux/arch/x86/kernel/traps_32.c
@@ -673,11 +673,14 @@ void __kprobes do_general_protection(str
 	current->thread.error_code = error_code;
 	current->thread.trap_no = 13;
 	if (show_unhandled_signals && unhandled_signal(current, SIGSEGV) &&
-	    printk_ratelimit())
+	    printk_ratelimit()) {
 		printk(KERN_INFO
-		    "%s[%d] general protection ip:%lx sp:%lx error:%lx\n",
+		    "%s[%d] general protection ip:%lx sp:%lx error:%lx",
 		    current->comm, task_pid_nr(current),
 		    regs->ip, regs->sp, error_code);
+		print_vma_addr(" in ", regs->ip);
+		printk("\n");
+	}
 
 	force_sig(SIGSEGV, current);
 	return;
Index: linux/arch/x86/mm/fault_32.c
===================================================================
--- linux.orig/arch/x86/mm/fault_32.c
+++ linux/arch/x86/mm/fault_32.c
@@ -550,10 +550,12 @@ bad_area_nosemaphore:
 		if (show_unhandled_signals && unhandled_signal(tsk, SIGSEGV) &&
 		    printk_ratelimit()) {
 			printk("%s%s[%d]: segfault at %lx ip %08lx "
-			    "sp %08lx error %lx\n",
+			    "sp %08lx error %lx",
 			    task_pid_nr(tsk) > 1 ? KERN_INFO : KERN_EMERG,
 			    tsk->comm, task_pid_nr(tsk), address, regs->ip,
 			    regs->sp, error_code);
+			print_vma_addr(" in ", regs->ip);
+			printk("\n");
 		}
 		tsk->thread.cr2 = address;
 		/* Kernel addresses are always protection faults */
