Return-Path: <linux-kernel-owner+w=401wt.eu-S1753849AbXLDSyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849AbXLDSyT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 13:54:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755022AbXLDSwD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 13:52:03 -0500
Received: from mx1.redhat.com ([66.187.233.31]:53329 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754978AbXLDSv7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 13:51:59 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 7/8] move switch_to macro to system.h
Date: Tue,  4 Dec 2007 14:06:27 -0200
Message-Id: <11967844221894-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11967844173360-git-send-email-gcosta@redhat.com>
References: <11967843881946-git-send-email-gcosta@redhat.com> <11967843943958-git-send-email-gcosta@redhat.com> <11967843983411-git-send-email-gcosta@redhat.com> <11967844032081-git-send-email-gcosta@redhat.com> <11967844071346-git-send-email-gcosta@redhat.com> <11967844123402-git-send-email-gcosta@redhat.com> <11967844173360-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves the switch_to() macro to system.h

As those macros are fundamentally different between i386 and x86_64,
they are enclosed around an ifdef.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 include/asm-x86/system.h    |   61 +++++++++++++++++++++++++++++++++++++++++++
 include/asm-x86/system_32.h |   31 ----------------------
 include/asm-x86/system_64.h |   37 --------------------------
 3 files changed, 61 insertions(+), 68 deletions(-)

diff --git a/include/asm-x86/system.h b/include/asm-x86/system.h
index ecb782b..da4bcd1 100644
--- a/include/asm-x86/system.h
+++ b/include/asm-x86/system.h
@@ -6,8 +6,69 @@
 #include <linux/kernel.h>
 
 #ifdef CONFIG_X86_32
+#define AT_VECTOR_SIZE_ARCH 2 /* entries in ARCH_DLINFO */
+
+struct task_struct; /* one of the stranger aspects of C forward declarations */
+extern struct task_struct *FASTCALL(__switch_to(struct task_struct *prev,
+						struct task_struct *next));
+
+/*
+ * Saving eflags is important. It switches not only IOPL between tasks,
+ * it also protects other tasks from NT leaking through sysenter etc.
+ */
+#define switch_to(prev, next, last) do {				\
+	unsigned long esi, edi;						\
+	asm volatile("pushfl\n\t"		/* Save flags */	\
+		     "pushl %%ebp\n\t"					\
+		     "movl %%esp,%0\n\t"	/* save ESP */		\
+		     "movl %5,%%esp\n\t"	/* restore ESP */	\
+		     "movl $1f,%1\n\t"		/* save EIP */		\
+		     "pushl %6\n\t"		/* restore EIP */	\
+		     "jmp __switch_to\n"				\
+		     "1:\t"						\
+		     "popl %%ebp\n\t"					\
+		     "popfl"						\
+		     :"=m" (prev->thread.esp), "=m" (prev->thread.eip),	\
+		      "=a" (last), "=S" (esi), "=D" (edi)		\
+		     :"m" (next->thread.esp), "m" (next->thread.eip),	\
+		      "2" (prev), "d" (next));				\
+} while (0)
+
 # include "system_32.h"
 #else
+#define __SAVE(reg, offset) "movq %%" #reg ",(14-" #offset ")*8(%%rsp)\n\t"
+#define __RESTORE(reg, offset) "movq (14-" #offset ")*8(%%rsp),%%" #reg "\n\t"
+
+/* frame pointer must be last for get_wchan */
+#define SAVE_CONTEXT    "pushf ; pushq %%rbp ; movq %%rsi,%%rbp\n\t"
+#define RESTORE_CONTEXT "movq %%rbp,%%rsi ; popq %%rbp ; popf\t"
+
+#define __EXTRA_CLOBBER  \
+	, "rcx", "rbx", "rdx", "r8", "r9", "r10", "r11", \
+	  "r12", "r13", "r14", "r15"
+
+/* Save restore flags to clear handle leaking NT */
+#define switch_to(prev, next, last) \
+	asm volatile(SAVE_CONTEXT					  \
+	     "movq %%rsp,%P[threadrsp](%[prev])\n\t" /* save RSP */	  \
+	     "movq %P[threadrsp](%[next]),%%rsp\n\t" /* restore RSP */	  \
+	     "call __switch_to\n\t"					  \
+	     ".globl thread_return\n"					  \
+	     "thread_return:\n\t"					  \
+	     "movq %%gs:%P[pda_pcurrent],%%rsi\n\t"			  \
+	     "movq %P[thread_info](%%rsi),%%r8\n\t"			  \
+	     LOCK_PREFIX "btr  %[tif_fork],%P[ti_flags](%%r8)\n\t"	  \
+	     "movq %%rax,%%rdi\n\t" 					  \
+	     "jc   ret_from_fork\n\t"					  \
+	     RESTORE_CONTEXT						  \
+	     : "=a" (last)					  	  \
+	     : [next] "S" (next), [prev] "D" (prev),			  \
+	       [threadrsp] "i" (offsetof(struct task_struct, thread.rsp)),\
+	       [ti_flags] "i" (offsetof(struct thread_info, flags)),	  \
+	       [tif_fork] "i" (TIF_FORK),			  	  \
+	       [thread_info] "i" (offsetof(struct task_struct, stack)),   \
+	       [pda_pcurrent] "i" (offsetof(struct x8664_pda, pcurrent))  \
+	     : "memory", "cc" __EXTRA_CLOBBER)
 # include "system_64.h"
 #endif
 
diff --git a/include/asm-x86/system_32.h b/include/asm-x86/system_32.h
index 1201880..83af464 100644
--- a/include/asm-x86/system_32.h
+++ b/include/asm-x86/system_32.h
@@ -5,37 +5,6 @@
 #include <asm/cpufeature.h>
 #include <asm/cmpxchg.h>
 
-#ifdef __KERNEL__
-#define AT_VECTOR_SIZE_ARCH 2 /* entries in ARCH_DLINFO */
-
-struct task_struct;	/* one of the stranger aspects of C forward declarations.. */
-extern struct task_struct * FASTCALL(__switch_to(struct task_struct *prev, struct task_struct *next));
-
-/*
- * Saving eflags is important. It switches not only IOPL between tasks,
- * it also protects other tasks from NT leaking through sysenter etc.
- */
-#define switch_to(prev,next,last) do {					\
-	unsigned long esi,edi;						\
-	asm volatile("pushfl\n\t"		/* Save flags */	\
-		     "pushl %%ebp\n\t"					\
-		     "movl %%esp,%0\n\t"	/* save ESP */		\
-		     "movl %5,%%esp\n\t"	/* restore ESP */	\
-		     "movl $1f,%1\n\t"		/* save EIP */		\
-		     "pushl %6\n\t"		/* restore EIP */	\
-		     "jmp __switch_to\n"				\
-		     "1:\t"						\
-		     "popl %%ebp\n\t"					\
-		     "popfl"						\
-		     :"=m" (prev->thread.esp),"=m" (prev->thread.eip),	\
-		      "=a" (last),"=S" (esi),"=D" (edi)			\
-		     :"m" (next->thread.esp),"m" (next->thread.eip),	\
-		      "2" (prev), "d" (next));				\
-} while (0)
-
-#endif	/* __KERNEL__ */
-
-
 #include <linux/irqflags.h>
 
 /*
diff --git a/include/asm-x86/system_64.h b/include/asm-x86/system_64.h
index 80be206..89af856 100644
--- a/include/asm-x86/system_64.h
+++ b/include/asm-x86/system_64.h
@@ -4,43 +4,6 @@
 #include <asm/segment.h>
 #include <asm/cmpxchg.h>
 
-#ifdef __KERNEL__
-
-#define __SAVE(reg,offset) "movq %%" #reg ",(14-" #offset ")*8(%%rsp)\n\t"
-#define __RESTORE(reg,offset) "movq (14-" #offset ")*8(%%rsp),%%" #reg "\n\t"
-
-/* frame pointer must be last for get_wchan */
-#define SAVE_CONTEXT    "pushf ; pushq %%rbp ; movq %%rsi,%%rbp\n\t"
-#define RESTORE_CONTEXT "movq %%rbp,%%rsi ; popq %%rbp ; popf\t"
-
-#define __EXTRA_CLOBBER  \
-	,"rcx","rbx","rdx","r8","r9","r10","r11","r12","r13","r14","r15"
-
-/* Save restore flags to clear handle leaking NT */
-#define switch_to(prev,next,last) \
-	asm volatile(SAVE_CONTEXT						    \
-		     "movq %%rsp,%P[threadrsp](%[prev])\n\t" /* save RSP */	  \
-		     "movq %P[threadrsp](%[next]),%%rsp\n\t" /* restore RSP */	  \
-		     "call __switch_to\n\t"					  \
-		     ".globl thread_return\n"					\
-		     "thread_return:\n\t"					    \
-		     "movq %%gs:%P[pda_pcurrent],%%rsi\n\t"			  \
-		     "movq %P[thread_info](%%rsi),%%r8\n\t"			  \
-		     LOCK_PREFIX "btr  %[tif_fork],%P[ti_flags](%%r8)\n\t"	  \
-		     "movq %%rax,%%rdi\n\t" 					  \
-		     "jc   ret_from_fork\n\t"					  \
-		     RESTORE_CONTEXT						    \
-		     : "=a" (last)					  	  \
-		     : [next] "S" (next), [prev] "D" (prev),			  \
-		       [threadrsp] "i" (offsetof(struct task_struct, thread.rsp)), \
-		       [ti_flags] "i" (offsetof(struct thread_info, flags)),\
-		       [tif_fork] "i" (TIF_FORK),			  \
-		       [thread_info] "i" (offsetof(struct task_struct, stack)), \
-		       [pda_pcurrent] "i" (offsetof(struct x8664_pda, pcurrent))   \
-		     : "memory", "cc" __EXTRA_CLOBBER)
-
-#endif	/* __KERNEL__ */
-
 #include <linux/irqflags.h>
 
 #endif
-- 
1.4.4.2

