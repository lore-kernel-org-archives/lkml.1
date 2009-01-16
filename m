Return-Path: <linux-kernel-owner+w=401wt.eu-S935914AbZAPOT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935914AbZAPOT0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 09:19:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934961AbZAPOQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 09:16:55 -0500
Received: from yw-out-2324.google.com ([74.125.46.31]:51829 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934696AbZAPOQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 09:16:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=cAPKhF1WD8red0khUIf0on0wr9XlNly1PRdZep7wfyW3j1BPvMhGRrlsBxGXWY9Vhq
         aYsPGpxv1jb0fefZez+G80/Me+XilW4FcGqbRzOEH3iDhFJdzPmVp/3T2P+tUNL5oz6w
         vMWWuNNe4XmYVd6iXiEhhmd1cMFJXRH416R/U=
From: Brian Gerst <brgerst@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Brian Gerst <brgerst@gmail.com>
Subject: [PATCH 12/17] x86-64: Use absolute displacements for per-cpu accesses.
Date: Fri, 16 Jan 2009 09:16:31 -0500
Message-Id: <1232115396-26367-12-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.1.rc1
In-Reply-To: <1232115396-26367-11-git-send-email-brgerst@gmail.com>
References: <73c1f2160901160610l57e31a64j56fe9544bd2fd309@mail.gmail.com>
 <1232115396-26367-1-git-send-email-brgerst@gmail.com>
 <1232115396-26367-2-git-send-email-brgerst@gmail.com>
 <1232115396-26367-3-git-send-email-brgerst@gmail.com>
 <1232115396-26367-4-git-send-email-brgerst@gmail.com>
 <1232115396-26367-5-git-send-email-brgerst@gmail.com>
 <1232115396-26367-6-git-send-email-brgerst@gmail.com>
 <1232115396-26367-7-git-send-email-brgerst@gmail.com>
 <1232115396-26367-8-git-send-email-brgerst@gmail.com>
 <1232115396-26367-9-git-send-email-brgerst@gmail.com>
 <1232115396-26367-10-git-send-email-brgerst@gmail.com>
 <1232115396-26367-11-git-send-email-brgerst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Accessing memory through %gs should not use rip-relative addressing.
Adding a P prefix for the argument tells gcc to not add (%rip) to
the memory references.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
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
1.6.1.rc1

