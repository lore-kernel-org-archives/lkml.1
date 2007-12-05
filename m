Return-Path: <linux-kernel-owner+w=401wt.eu-S1754790AbXLERyv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790AbXLERyv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 12:54:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753903AbXLERxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 12:53:32 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54333 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753828AbXLERxb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 12:53:31 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 3/9] unify load_segment macro
Date: Wed,  5 Dec 2007 13:08:27 -0200
Message-Id: <11968673291072-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11968673241599-git-send-email-gcosta@redhat.com>
References: 20071204204931.GC32018@elte.hu <1196867313972-git-send-email-gcosta@redhat.com> <1196867319253-git-send-email-gcosta@redhat.com> <11968673241599-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch unifies the load_segment() macro, making them equal in both
x86_64 and i386 architectures. The common version goes to system.h,
and the old are deleted.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 include/asm-x86/system.h    |   21 +++++++++++++++++++++
 include/asm-x86/system_32.h |   22 ----------------------
 include/asm-x86/system_64.h |   20 --------------------
 3 files changed, 21 insertions(+), 42 deletions(-)

diff --git a/include/asm-x86/system.h b/include/asm-x86/system.h
index 6e9491d..1ac6088 100644
--- a/include/asm-x86/system.h
+++ b/include/asm-x86/system.h
@@ -39,6 +39,27 @@ __asm__ __volatile__ ("movw %%dx,%1\n\t" \
 #define set_limit(ldt, limit) _set_limit(((char *)&(ldt)) , ((limit)-1))
 
 /*
+ * Load a segment. Fall back on loading the zero
+ * segment if something goes wrong..
+ */
+#define loadsegment(seg, value)			\
+	asm volatile("\n"			\
+		"1:\t"				\
+		"movl %k0,%%" #seg "\n"		\
+		"2:\n"				\
+		".section .fixup,\"ax\"\n"	\
+		"3:\t"				\
+		"movl %k1, %%" #seg "\n\t"	\
+		"jmp 2b\n"			\
+		".previous\n"			\
+		".section __ex_table,\"a\"\n\t"	\
+		_ASM_ALIGN "\n\t"		\
+		_ASM_PTR " 1b,3b\n"		\
+		".previous"			\
+		: :"r" (value), "r" (0))
+
+
+/*
  * Save a segment register away
  */
 #define savesegment(seg, value) \
diff --git a/include/asm-x86/system_32.h b/include/asm-x86/system_32.h
index 717aeb9..a0641a3 100644
--- a/include/asm-x86/system_32.h
+++ b/include/asm-x86/system_32.h
@@ -34,28 +34,6 @@ extern struct task_struct * FASTCALL(__switch_to(struct task_struct *prev, struc
 		      "2" (prev), "d" (next));				\
 } while (0)
 
-/*
- * Load a segment. Fall back on loading the zero
- * segment if something goes wrong..
- */
-#define loadsegment(seg,value)			\
-	asm volatile("\n"			\
-		"1:\t"				\
-		"mov %0,%%" #seg "\n"		\
-		"2:\n"				\
-		".section .fixup,\"ax\"\n"	\
-		"3:\t"				\
-		"pushl $0\n\t"			\
-		"popl %%" #seg "\n\t"		\
-		"jmp 2b\n"			\
-		".previous\n"			\
-		".section __ex_table,\"a\"\n\t"	\
-		".align 4\n\t"			\
-		".long 1b,3b\n"			\
-		".previous"			\
-		: :"rm" (value))
-
-
 static inline void native_clts(void)
 {
 	asm volatile ("clts");
diff --git a/include/asm-x86/system_64.h b/include/asm-x86/system_64.h
index f340060..da46059 100644
--- a/include/asm-x86/system_64.h
+++ b/include/asm-x86/system_64.h
@@ -43,26 +43,6 @@
 extern void load_gs_index(unsigned); 
 
 /*
- * Load a segment. Fall back on loading the zero
- * segment if something goes wrong..
- */
-#define loadsegment(seg,value)	\
-	asm volatile("\n"			\
-		"1:\t"				\
-		"movl %k0,%%" #seg "\n"		\
-		"2:\n"				\
-		".section .fixup,\"ax\"\n"	\
-		"3:\t"				\
-		"movl %1,%%" #seg "\n\t" 	\
-		"jmp 2b\n"			\
-		".previous\n"			\
-		".section __ex_table,\"a\"\n\t"	\
-		".align 8\n\t"			\
-		".quad 1b,3b\n"			\
-		".previous"			\
-		: :"r" (value), "r" (0))
-
-/*
  * Clear and set 'TS' bit respectively
  */
 #define clts() __asm__ __volatile__ ("clts")
-- 
1.4.4.2

