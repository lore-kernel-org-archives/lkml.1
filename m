Return-Path: <linux-kernel-owner+w=401wt.eu-S934390AbZARQoO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934390AbZARQoO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 11:44:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933760AbZARQjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 11:39:47 -0500
Received: from hera.kernel.org ([140.211.167.34]:37547 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932988AbZARQjp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 11:39:45 -0500
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, linux-kernel@vger.kernel.org, brgerst@gmail.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 12/12] x86-64: Use absolute displacements for per-cpu accesses.
Date: Mon, 19 Jan 2009 01:39:19 +0900
Message-Id: <1232296759-2253-13-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1232296759-2253-1-git-send-email-tj@kernel.org>
References: <1232296759-2253-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 18 Jan 2009 16:39:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Brian Gerst <brgerst@gmail.com>

Accessing memory through %gs should not use rip-relative addressing.
Adding a P prefix for the argument tells gcc to not add (%rip) to
the memory references.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/include/asm/percpu.h |   26 +++++++++++++-------------
 arch/x86/include/asm/system.h |    2 +-
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
index 03aa4b0..165d527 100644
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
@@ -39,10 +39,10 @@
 #include <linux/stringify.h>
 
 #ifdef CONFIG_SMP
-#define __percpu_seg_str	"%%"__stringify(__percpu_seg)":"
+#define __percpu_arg(x)		"%%"__stringify(__percpu_seg)":%P" #x
 #define __my_cpu_offset		percpu_read(this_cpu_off)
 #else
-#define __percpu_seg_str
+#define __percpu_arg(x)		"%" #x
 #endif
 
 /* For arch-specific code, we can use direct single-insn ops (they
@@ -58,22 +58,22 @@ do {							\
 	}						\
 	switch (sizeof(var)) {				\
 	case 1:						\
-		asm(op "b %1,"__percpu_seg_str"%0"	\
+		asm(op "b %1,"__percpu_arg(0)		\
 		    : "+m" (var)			\
 		    : "ri" ((T__)val));			\
 		break;					\
 	case 2:						\
-		asm(op "w %1,"__percpu_seg_str"%0"	\
+		asm(op "w %1,"__percpu_arg(0)		\
 		    : "+m" (var)			\
 		    : "ri" ((T__)val));			\
 		break;					\
 	case 4:						\
-		asm(op "l %1,"__percpu_seg_str"%0"	\
+		asm(op "l %1,"__percpu_arg(0)		\
 		    : "+m" (var)			\
 		    : "ri" ((T__)val));			\
 		break;					\
 	case 8:						\
-		asm(op "q %1,"__percpu_seg_str"%0"	\
+		asm(op "q %1,"__percpu_arg(0)		\
 		    : "+m" (var)			\
 		    : "r" ((T__)val));			\
 		break;					\
@@ -86,22 +86,22 @@ do {							\
 	typeof(var) ret__;				\
 	switch (sizeof(var)) {				\
 	case 1:						\
-		asm(op "b "__percpu_seg_str"%1,%0"	\
+		asm(op "b "__percpu_arg(1)",%0"		\
 		    : "=r" (ret__)			\
 		    : "m" (var));			\
 		break;					\
 	case 2:						\
-		asm(op "w "__percpu_seg_str"%1,%0"	\
+		asm(op "w "__percpu_arg(1)",%0"		\
 		    : "=r" (ret__)			\
 		    : "m" (var));			\
 		break;					\
 	case 4:						\
-		asm(op "l "__percpu_seg_str"%1,%0"	\
+		asm(op "l "__percpu_arg(1)",%0"		\
 		    : "=r" (ret__)			\
 		    : "m" (var));			\
 		break;					\
 	case 8:						\
-		asm(op "q "__percpu_seg_str"%1,%0"	\
+		asm(op "q "__percpu_arg(1)",%0"		\
 		    : "=r" (ret__)			\
 		    : "m" (var));			\
 		break;					\
@@ -122,9 +122,9 @@ do {							\
 #define x86_test_and_clear_bit_percpu(bit, var)				\
 ({									\
 	int old__;							\
-	asm volatile("btr %1,"__percpu_seg_str"%c2\n\tsbbl %0,%0"	\
-		     : "=r" (old__)					\
-		     : "dIr" (bit), "i" (&per_cpu__##var) : "memory");	\
+	asm volatile("btr %2,"__percpu_arg(1)"\n\tsbbl %0,%0"		\
+		     : "=r" (old__), "+m" (per_cpu__##var)		\
+		     : "dIr" (bit));					\
 	old__;								\
 })
 
diff --git a/arch/x86/include/asm/system.h b/arch/x86/include/asm/system.h
index 4399aac..d1dc27d 100644
--- a/arch/x86/include/asm/system.h
+++ b/arch/x86/include/asm/system.h
@@ -94,7 +94,7 @@ do {									\
 	     "call __switch_to\n\t"					  \
 	     ".globl thread_return\n"					  \
 	     "thread_return:\n\t"					  \
-	     "movq "__percpu_seg_str"%P[current_task],%%rsi\n\t"	  \
+	     "movq "__percpu_arg([current_task])",%%rsi\n\t"		  \
 	     "movq %P[thread_info](%%rsi),%%r8\n\t"			  \
 	     LOCK_PREFIX "btr  %[tif_fork],%P[ti_flags](%%r8)\n\t"	  \
 	     "movq %%rax,%%rdi\n\t" 					  \
-- 
1.6.0.2

