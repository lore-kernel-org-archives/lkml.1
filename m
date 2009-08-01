Return-Path: <linux-kernel-owner+w=401wt.eu-S1752120AbZHAT30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120AbZHAT30 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 15:29:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752046AbZHAT3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 15:29:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38621 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751917AbZHAT3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 15:29:25 -0400
Date: Sat, 1 Aug 2009 12:28:01 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>
Subject: Re: [GIT PULL] Additional x86 fixes for 2.6.31-rc5
In-Reply-To: <20090731195705.GA12270@elte.hu>
Message-ID: <alpine.LFD.2.01.0908011214330.3304@localhost.localdomain>
References: <200907311813.n6VIDe9S023442@voreg.hos.anvin.org> <alpine.LFD.2.01.0907311218080.3161@localhost.localdomain> <20090731195705.GA12270@elte.hu>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Hmm.

I just noticed another issue on x86 code generation, since I was looking 
at assembly language generation due to the do_sigaltstack() kernel stack 
info leak thing.

Our "get_current()" seriously sucks now that it's a per-cpu variable.

Look at the code generated for something like

	current->sas_ss_sp = (unsigned long) ss_sp;
	current->sas_ss_size = ss_size;

and notice how the code really really sucks:

        movq %gs:per_cpu__current_task,%rcx
        movq    %rdx, 1152(%rcx)
        movq %gs:per_cpu__current_task,%rdx
        movq    %rax, 1160(%rdx)

because it reloads that silly per-cpu variable every time, because the 
assembler has a constraint of

	"m" (per_cpu__current_task)

and so gcc is worried that the stores will invalidate the result of the 
load from the per-cpu variable.

I don't know how to fix that _well_, but here's a not-so-very-pretty patch 
that seems to shave off 4.5kB from my kernel, and gives gcc much better 
scheduling for 'current' and 'thread_info' because now it can load them 
early - and cache them - even in the presense of stores.

It uses a "p" (&var) constraint instead of a "m" (var) one, to make gcc 
think there is no actual "load" from memory. This obviously _only_ works 
for percpu variables that are stable within a thread, but 'current' and 
'kernel_stack' should be that way.

End result: the above horror becomes a more reasonable

        movq %gs:per_cpu__current_task,%rax
        movq    %rcx, 1152(%rax)
        movq    %rdx, 1160(%rax)

instead (it still doesn't cache it over the whole function, but it's 
certainly better).

NOTE! I did not test that it all worked. I only looked at the asm, and 
checked out the improvements. All the ones I looked at looked reasonable.

Worthwhile? You be the judge.

There's another detail that may be worth looking at: we often get 
'current' and 'thread_info' together, and they are _not_ in the same 
cache-line. It might be worth defining them together in the per-cpu data, 
and making sure they are in the same cacheline too. In general, we should 
probably look at which per-pcu variables are hot and read-only, and try to 
gathe them all together.

		Linus

---
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 1 Aug 2009 11:50:54 -0700
Subject: [PATCH] x86-64: Add 'percpu_read_stable()' interface for cacheable accesses

This is very useful for some common things like 'get_current()' and
'get_thread_info()', which can be used multiple times in a function, and
where the result is cacheable.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 arch/x86/include/asm/current.h     |    2 +-
 arch/x86/include/asm/percpu.h      |   13 +++++++------
 arch/x86/include/asm/thread_info.h |    2 +-
 3 files changed, 9 insertions(+), 8 deletions(-)

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
index 103f1dd..3fd619b 100644
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
@@ -104,36 +104,37 @@ do {							\
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
+#define percpu_read(var)	percpu_from_op("mov", per_cpu__##var,"m" (per_cpu__##var))
+#define percpu_read_stable(var)	percpu_from_op("mov", per_cpu__##var,"p" (&per_cpu__##var))
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
