Return-Path: <linux-kernel-owner+w=401wt.eu-S932298AbZHCPN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932298AbZHCPN7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 11:13:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932157AbZHCPN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 11:13:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:51075 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755055AbZHCPN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 11:13:57 -0400
Message-ID: <4A76FE93.8080907@kernel.org>
Date: Tue, 04 Aug 2009 00:13:23 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3 UPDATED] x86, percpu: Add 'percpu_read_stable()' interface
 for cacheable accesses
References: <20090731195705.GA12270@elte.hu> <alpine.LFD.2.01.0908011214330.3304@localhost.localdomain> <4A76421E.3040005@kernel.org> <alpine.LFD.2.01.0908021913130.3352@localhost.localdomain> <4A7670E0.4030605@kernel.org> <4A767203.5090802@zytor.com> <4A767325.20604@kernel.org> <20090803060408.GA20762@elte.hu> <4A767EE4.20702@zytor.com> <20090803061608.GA21564@elte.hu> <20090803070051.GA25425@elte.hu>
In-Reply-To: <20090803070051.GA25425@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 03 Aug 2009 15:13:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Tolvards <torvalds@linux-foundation.org>

This is very useful for some common things like 'get_current()' and
'get_thread_info()', which can be used multiple times in a function, and
where the result is cacheable.

tj: Added the magical undocumented "P" modifier to UP __percpu_arg()
    to force gcc to dereference the pointer value passed in via the
    "p" input constraint.  Without this, percpu_read_stable() returns
    the address of the percpu variable.  Also added comment explaining
    the difference between percpu_read() and percpu_read_stable().

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
It was the missing magic 'P'.  Patch titles have been updated as
requested.  The next two patches are the same except for the subject
update.  The updated patches are available in the following git tree.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git x86-percpu

Please note that the tree is rebased and needs to be forcibly pulled
into x86/percpu.  Thanks.

 arch/x86/include/asm/current.h     |    2 +-
 arch/x86/include/asm/percpu.h      |   26 +++++++++++++++++++-------
 arch/x86/include/asm/thread_info.h |    2 +-
 3 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/current.h b/arch/x86/include/asm/current.h
index c68c361..4d447b7 100644
--- a/arch/x86/include/asm/current.h
+++ b/arch/x86/include/asm/current.h
@@ -11,7 +11,7 @@ DECLARE_PER_CPU(struct task_struct *, current_task);

 static __always_inline struct task_struct *get_current(void)
 {
-	return percpu_read(current_task);
+	return percpu_read_stable(current_task);
 }

 #define current get_current()
diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
index 103f1dd..04eacef 100644
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
@@ -49,7 +49,7 @@
 #define __percpu_arg(x)		"%%"__stringify(__percpu_seg)":%P" #x
 #define __my_cpu_offset		percpu_read(this_cpu_off)
 #else
-#define __percpu_arg(x)		"%" #x
+#define __percpu_arg(x)		"%P" #x
 #endif

 /*
@@ -104,36 +104,48 @@ do {							\
 	}						\
 } while (0)

-#define percpu_from_op(op, var)				\
+#define percpu_from_op(op, var, constraint)		\
 ({							\
 	typeof(var) ret__;				\
 	switch (sizeof(var)) {				\
 	case 1:						\
 		asm(op "b "__percpu_arg(1)",%0"		\
 		    : "=q" (ret__)			\
-		    : "m" (var));			\
+		    : constraint);			\
 		break;					\
 	case 2:						\
 		asm(op "w "__percpu_arg(1)",%0"		\
 		    : "=r" (ret__)			\
-		    : "m" (var));			\
+		    : constraint);			\
 		break;					\
 	case 4:						\
 		asm(op "l "__percpu_arg(1)",%0"		\
 		    : "=r" (ret__)			\
-		    : "m" (var));			\
+		    : constraint);			\
 		break;					\
 	case 8:						\
 		asm(op "q "__percpu_arg(1)",%0"		\
 		    : "=r" (ret__)			\
-		    : "m" (var));			\
+		    : constraint);			\
 		break;					\
 	default: __bad_percpu_size();			\
 	}						\
 	ret__;						\
 })

-#define percpu_read(var)	percpu_from_op("mov", per_cpu__##var)
+/*
+ * percpu_read() makes gcc load the percpu variable every time it is
+ * accessed while percpu_read_stable() allows the value to be cached.
+ * percpu_read_stable() is more efficient and can be used if its value
+ * is guaranteed to be valid across cpus.  The current users include
+ * get_current() and get_thread_info() both of which are actually
+ * per-thread variables implemented as per-cpu variables and thus
+ * stable for the duration of the respective task.
+ */
+#define percpu_read(var)	percpu_from_op("mov", per_cpu__##var,	\
+					       "m" (per_cpu__##var))
+#define percpu_read_stable(var)	percpu_from_op("mov", per_cpu__##var,	\
+					       "p" (&per_cpu__##var))
 #define percpu_write(var, val)	percpu_to_op("mov", per_cpu__##var, val)
 #define percpu_add(var, val)	percpu_to_op("add", per_cpu__##var, val)
 #define percpu_sub(var, val)	percpu_to_op("sub", per_cpu__##var, val)
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index fad7d40..a1bb5a1 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -213,7 +213,7 @@ DECLARE_PER_CPU(unsigned long, kernel_stack);
 static inline struct thread_info *current_thread_info(void)
 {
 	struct thread_info *ti;
-	ti = (void *)(percpu_read(kernel_stack) +
+	ti = (void *)(percpu_read_stable(kernel_stack) +
 		      KERNEL_STACK_OFFSET - THREAD_SIZE);
 	return ti;
 }
-- 
1.6.0.2

