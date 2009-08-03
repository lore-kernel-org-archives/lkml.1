Return-Path: <linux-kernel-owner+w=401wt.eu-S1751637AbZHCFJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751637AbZHCFJX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 01:09:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751236AbZHCFJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 01:09:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:38623 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751218AbZHCFJW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 01:09:22 -0400
Message-ID: <4A7670E0.4030605@kernel.org>
Date: Mon, 03 Aug 2009 14:08:48 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] x86: Add 'percpu_read_stable()' interface for cacheable
 accesses
References: <200907311813.n6VIDe9S023442@voreg.hos.anvin.org> <alpine.LFD.2.01.0907311218080.3161@localhost.localdomain> <20090731195705.GA12270@elte.hu> <alpine.LFD.2.01.0908011214330.3304@localhost.localdomain> <4A76421E.3040005@kernel.org> <alpine.LFD.2.01.0908021913130.3352@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0908021913130.3352@localhost.localdomain>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 03 Aug 2009 05:09:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Tolvards <torvalds@linux-foundation.org>

This is very useful for some common things like 'get_current()' and
'get_thread_info()', which can be used multiple times in a function, and
where the result is cacheable.

tj: added comment explaining the difference between percpu_read() and
    percpu_read_stable()

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
Three patches queued in my pending tree.

The second patch is a possible bug I've spotted while prepping the
third one.  The last one puts current_task and kernel_stack into the
same cacheline as suggested by Linus.  I'll hold for a few days for
response and then push them to linux-next.

Ingo, these patches might as well go through x86 tree.  If you think
that would be better, please let me know.

Thanks.

 arch/x86/include/asm/current.h     |    2 +-
 arch/x86/include/asm/percpu.h      |   22 ++++++++++++++++------
 arch/x86/include/asm/thread_info.h |    2 +-
 3 files changed, 18 insertions(+), 8 deletions(-)

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
index a18c038..b421780 100644
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
@@ -104,36 +104,46 @@ do {							\
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
+#define percpu_read(var)	percpu_from_op("mov", per_cpu__##var,"m" (per_cpu__##var))
+#define percpu_read_stable(var)	percpu_from_op("mov", per_cpu__##var,"p" (&per_cpu__##var))
 #define percpu_write(var, val)	percpu_to_op("mov", per_cpu__##var, val)
 #define percpu_add(var, val)	percpu_to_op("add", per_cpu__##var, val)
 #define percpu_sub(var, val)	percpu_to_op("sub", per_cpu__##var, val)
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index b078352..9fee589 100644
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

