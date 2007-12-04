Return-Path: <linux-kernel-owner+w=401wt.eu-S1755063AbXLDSwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755063AbXLDSwV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 13:52:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754418AbXLDSus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 13:50:48 -0500
Received: from mx1.redhat.com ([66.187.233.31]:56374 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754397AbXLDSur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 13:50:47 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 2/8] put together equal pieces of system.h
Date: Tue,  4 Dec 2007 14:06:22 -0200
Message-Id: <11967843983411-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11967843943958-git-send-email-gcosta@redhat.com>
References: <11967843881946-git-send-email-gcosta@redhat.com> <11967843943958-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch puts together pieces of system_{32,64}.h that
looks like the same. It's the first step towards integration
of this file.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 arch/x86/kernel/process_64.c |    2 +-
 include/asm-x86/system.h     |   70 ++++++++++++++++++++++++++++++++++++++++++
 include/asm-x86/system_32.h  |   59 -----------------------------------
 include/asm-x86/system_64.h  |   12 -------
 4 files changed, 71 insertions(+), 72 deletions(-)

diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 6309b27..8924790 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -106,7 +106,7 @@ void exit_idle(void)
  * We use this if we don't have any better
  * idle routine..
  */
-static void default_idle(void)
+void default_idle(void)
 {
 	current_thread_info()->status &= ~TS_POLLING;
 	/*
diff --git a/include/asm-x86/system.h b/include/asm-x86/system.h
index 692562b..6e9491d 100644
--- a/include/asm-x86/system.h
+++ b/include/asm-x86/system.h
@@ -1,5 +1,75 @@
+#ifndef _ASM_X86_SYSTEM_H_
+#define _ASM_X86_SYSTEM_H_
+
+#include <asm/asm.h>
+
 #ifdef CONFIG_X86_32
 # include "system_32.h"
 #else
 # include "system_64.h"
 #endif
+
+#ifdef __KERNEL__
+#define _set_base(addr, base) do { unsigned long __pr; \
+__asm__ __volatile__ ("movw %%dx,%1\n\t" \
+	"rorl $16,%%edx\n\t" \
+	"movb %%dl,%2\n\t" \
+	"movb %%dh,%3" \
+	:"=&d" (__pr) \
+	:"m" (*((addr)+2)), \
+	 "m" (*((addr)+4)), \
+	 "m" (*((addr)+7)), \
+	 "0" (base) \
+	); } while (0)
+
+#define _set_limit(addr, limit) do { unsigned long __lr; \
+__asm__ __volatile__ ("movw %%dx,%1\n\t" \
+	"rorl $16,%%edx\n\t" \
+	"movb %2,%%dh\n\t" \
+	"andb $0xf0,%%dh\n\t" \
+	"orb %%dh,%%dl\n\t" \
+	"movb %%dl,%2" \
+	:"=&d" (__lr) \
+	:"m" (*(addr)), \
+	 "m" (*((addr)+6)), \
+	 "0" (limit) \
+	); } while (0)
+
+#define set_base(ldt, base) _set_base(((char *)&(ldt)) , (base))
+#define set_limit(ldt, limit) _set_limit(((char *)&(ldt)) , ((limit)-1))
+
+/*
+ * Save a segment register away
+ */
+#define savesegment(seg, value) \
+	asm volatile("mov %%" #seg ",%0":"=rm" (value))
+
+static inline unsigned long get_limit(unsigned long segment)
+{
+	unsigned long __limit;
+	__asm__("lsll %1,%0"
+		:"=r" (__limit):"r" (segment));
+	return __limit+1;
+}
+#endif /* __KERNEL__ */
+
+static inline void clflush(void *__p)
+{
+	asm volatile("clflush %0" : "+m" (*(char __force *)__p));
+}
+
+#define nop() __asm__ __volatile__ ("nop")
+
+void disable_hlt(void);
+void enable_hlt(void);
+
+extern int es7000_plat;
+void cpu_idle_wait(void);
+
+extern unsigned long arch_align_stack(unsigned long sp);
+extern void free_init_pages(char *what, unsigned long begin, unsigned long end);
+
+void default_idle(void);
+void __show_registers(struct pt_regs *, int all);
+
+#endif
diff --git a/include/asm-x86/system_32.h b/include/asm-x86/system_32.h
index 27e106d..717aeb9 100644
--- a/include/asm-x86/system_32.h
+++ b/include/asm-x86/system_32.h
@@ -34,34 +34,6 @@ extern struct task_struct * FASTCALL(__switch_to(struct task_struct *prev, struc
 		      "2" (prev), "d" (next));				\
 } while (0)
 
-#define _set_base(addr,base) do { unsigned long __pr; \
-__asm__ __volatile__ ("movw %%dx,%1\n\t" \
-	"rorl $16,%%edx\n\t" \
-	"movb %%dl,%2\n\t" \
-	"movb %%dh,%3" \
-	:"=&d" (__pr) \
-	:"m" (*((addr)+2)), \
-	 "m" (*((addr)+4)), \
-	 "m" (*((addr)+7)), \
-         "0" (base) \
-        ); } while(0)
-
-#define _set_limit(addr,limit) do { unsigned long __lr; \
-__asm__ __volatile__ ("movw %%dx,%1\n\t" \
-	"rorl $16,%%edx\n\t" \
-	"movb %2,%%dh\n\t" \
-	"andb $0xf0,%%dh\n\t" \
-	"orb %%dh,%%dl\n\t" \
-	"movb %%dl,%2" \
-	:"=&d" (__lr) \
-	:"m" (*(addr)), \
-	 "m" (*((addr)+6)), \
-	 "0" (limit) \
-        ); } while(0)
-
-#define set_base(ldt,base) _set_base( ((char *)&(ldt)) , (base) )
-#define set_limit(ldt,limit) _set_limit( ((char *)&(ldt)) , ((limit)-1) )
-
 /*
  * Load a segment. Fall back on loading the zero
  * segment if something goes wrong..
@@ -83,12 +55,6 @@ __asm__ __volatile__ ("movw %%dx,%1\n\t" \
 		".previous"			\
 		: :"rm" (value))
 
-/*
- * Save a segment register away
- */
-#define savesegment(seg, value) \
-	asm volatile("mov %%" #seg ",%0":"=rm" (value))
-
 
 static inline void native_clts(void)
 {
@@ -161,11 +127,6 @@ static inline void native_wbinvd(void)
 	asm volatile("wbinvd": : :"memory");
 }
 
-static inline void clflush(void *__p)
-{
-	asm volatile("clflush %0" : "+m" (*(char __force *)__p));
-}
-
 #ifdef CONFIG_PARAVIRT
 #include <asm/paravirt.h>
 #else
@@ -190,15 +151,6 @@ static inline void clflush(void *__p)
 
 #endif	/* __KERNEL__ */
 
-static inline unsigned long get_limit(unsigned long segment)
-{
-	unsigned long __limit;
-	__asm__("lsll %1,%0"
-		:"=r" (__limit):"r" (segment));
-	return __limit+1;
-}
-
-#define nop() __asm__ __volatile__ ("nop")
 
 /*
  * Force strict CPU ordering.
@@ -305,16 +257,5 @@ static inline unsigned long get_limit(unsigned long segment)
  * disable hlt during certain critical i/o operations
  */
 #define HAVE_DISABLE_HLT
-void disable_hlt(void);
-void enable_hlt(void);
-
-extern int es7000_plat;
-void cpu_idle_wait(void);
-
-extern unsigned long arch_align_stack(unsigned long sp);
-extern void free_init_pages(char *what, unsigned long begin, unsigned long end);
-
-void default_idle(void);
-void __show_registers(struct pt_regs *, int all);
 
 #endif
diff --git a/include/asm-x86/system_64.h b/include/asm-x86/system_64.h
index 4cb2384..f340060 100644
--- a/include/asm-x86/system_64.h
+++ b/include/asm-x86/system_64.h
@@ -134,13 +134,6 @@ static inline void write_cr8(unsigned long val)
 
 #endif	/* __KERNEL__ */
 
-static inline void clflush(volatile void *__p)
-{
-	asm volatile("clflush %0" : "+m" (*(char __force *)__p));
-}
-
-#define nop() __asm__ __volatile__ ("nop")
-
 #ifdef CONFIG_SMP
 #define smp_mb()	mb()
 #define smp_rmb()	barrier()
@@ -170,9 +163,4 @@ static inline void clflush(volatile void *__p)
 
 #include <linux/irqflags.h>
 
-void cpu_idle_wait(void);
-
-extern unsigned long arch_align_stack(unsigned long sp);
-extern void free_init_pages(char *what, unsigned long begin, unsigned long end);
-
 #endif
-- 
1.4.4.2

