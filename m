Return-Path: <linux-kernel-owner+w=401wt.eu-S935116AbZDHSmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935116AbZDHSmA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 14:42:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934653AbZDHSlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 14:41:09 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:60197 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934477AbZDHSlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 14:41:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=ZVRbLmvnwRcA7qTlEZmP8wLaUS/4gE8BjhoOm6RcAoQL89JAt1PJ6XDkQRIH1urOMC
         pCCs+ZFpys2PH/s5kJPpqLb2dSM9FM6yuJRVyo/mZ0f54887yurvW6gAw1KXJaZHbls+
         Hv37BEAmWx0j8qf27vos4tVaeEF0A7iwvgpY0=
Date: Wed, 8 Apr 2009 20:40:59 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tony Luck <tony.luck@intel.com>, Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>, tglx@linutronix.de,
       Jason Baron <jbaron@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Jiaying Zhang <jiayingz@google.com>, Michael Rubin <mrubin@google.com>,
       Martin Bligh <mbligh@google.com>, Michael Davidson <md@google.com>
Subject: [PATCH] tracing/syscalls: use a dedicated file header
Message-ID: <20090408184058.GB6017@nowhere>
References: <1236955332-10133-1-git-send-email-fweisbec@gmail.com> <1236955332-10133-2-git-send-email-fweisbec@gmail.com> <12c511ca0904061455k3f8a9cc8r25b7930f257ed922@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <12c511ca0904061455k3f8a9cc8r25b7930f257ed922@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 06, 2009 at 02:55:55PM -0700, Tony Luck wrote:
> On Fri, Mar 13, 2009 at 7:42 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
> > index ab1d772..dfe2a44 100644
> > --- a/include/linux/syscalls.h
> > +++ b/include/linux/syscalls.h
> > @@ -66,6 +66,7 @@ struct perf_counter_hw_event;
> >  #include <asm/signal.h>
> >  #include <linux/quota.h>
> >  #include <linux/key.h>
> > +#include <linux/ftrace.h>
> 
> This causes some unpleasantness in the ia64 build with CONFIG_IA32_SUPPORT=y
> 
>   CC      arch/ia64/ia32/sys_ia32.o
> In file included from arch/ia64/ia32/sys_ia32.c:55:
> arch/ia64/ia32/ia32priv.h:290:1: warning: "elf_check_arch" redefined
> In file included from include/linux/elf.h:7,
>                  from include/linux/module.h:14,
>                  from include/linux/ftrace.h:8,
>                  from include/linux/syscalls.h:68,
>                  from arch/ia64/ia32/sys_ia32.c:18:
> /home/aegl/generic-smp/arch/ia64/include/asm/elf.h:19:1: warning: this
> is the location of the previous definition
> In file included from arch/ia64/ia32/sys_ia32.c:55:
> arch/ia64/ia32/ia32priv.h:295:1: warning: "ELF_CLASS" redefined
> In file included from include/linux/elf.h:7,
>                  from include/linux/module.h:14,
>                  from include/linux/ftrace.h:8,
>                  from include/linux/syscalls.h:68,
>                  from arch/ia64/ia32/sys_ia32.c:18:
> 
> and lots more like this.  Suddenly having elf.h included in a lot of
> the ia32 compat
> files is the root problem.
> 
> What does syscalls.h really need to pull in at this point ... is there
> a way for it to get it without pulling in so much extra stuff?
> 
> -Tony


Tony, can you tell me if the patch below fixes your build?
Thanks!

--
>From fa3a401fde69822b32d04c7aebdef7493bc566a7 Mon Sep 17 00:00:00 2001
From: Frederic Weisbecker <fweisbec@gmail.com>
Date: Wed, 8 Apr 2009 20:26:11 +0200
Subject: [PATCH] tracing/syscalls: use a dedicated file header

Impact: fix a build error on IA64

(fix for 2.6.30)

Building a kernel on ia64 might trigger the following crash:

CC      arch/ia64/ia32/sys_ia32.o
In file included from arch/ia64/ia32/sys_ia32.c:55:
arch/ia64/ia32/ia32priv.h:290:1: warning: "elf_check_arch" redefined
In file included from include/linux/elf.h:7,
                 from include/linux/module.h:14,
                 from include/linux/ftrace.h:8,
                 from include/linux/syscalls.h:68,
                 from arch/ia64/ia32/sys_ia32.c:18:
/home/aegl/generic-smp/arch/ia64/include/asm/elf.h:19:1: warning: this
is the location of the previous definition
In file included from arch/ia64/ia32/sys_ia32.c:55:
arch/ia64/ia32/ia32priv.h:295:1: warning: "ELF_CLASS" redefined
In file included from include/linux/elf.h:7,
                 from include/linux/module.h:14,
                 from include/linux/ftrace.h:8,
                 from include/linux/syscalls.h:68,
                 from arch/ia64/ia32/sys_ia32.c:18:

sys_ia32.c includes linux/syscalls.h which in turn includes linux/ftrace.h
to import the syscalls tracing prototypes.
But including ftrace.h can pull too much things for a low level file,
especially on ia64 where the ia32 private headers conflict with higher level
headers.

Now we isolate the syscall tracing headers in their own lightweight file.

Reported-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/kernel/ftrace.c      |    1 +
 arch/x86/kernel/ptrace.c      |    2 +-
 include/linux/ftrace.h        |   29 -----------------------------
 include/linux/syscalls.h      |    2 +-
 include/trace/syscall.h       |   35 +++++++++++++++++++++++++++++++++++
 kernel/trace/trace_syscalls.c |    2 +-
 6 files changed, 39 insertions(+), 32 deletions(-)
 create mode 100644 include/trace/syscall.h

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 70a10ca..dc871e0 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -12,6 +12,7 @@
 #include <linux/spinlock.h>
 #include <linux/hardirq.h>
 #include <linux/uaccess.h>
+#include <trace/syscall.h>
 #include <linux/ftrace.h>
 #include <linux/percpu.h>
 #include <linux/sched.h>
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index b32a8ee..6318896 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -21,7 +21,7 @@
 #include <linux/audit.h>
 #include <linux/seccomp.h>
 #include <linux/signal.h>
-#include <linux/ftrace.h>
+#include <trace/syscall.h>
 #include <linux/workqueue.h>
 
 #include <asm/uaccess.h>
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 33a2c20..53869be 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -510,33 +510,4 @@ static inline void trace_hw_branch_oops(void) {}
 
 #endif /* CONFIG_HW_BRANCH_TRACER */
 
-/*
- * A syscall entry in the ftrace syscalls array.
- *
- * @name: name of the syscall
- * @nb_args: number of parameters it takes
- * @types: list of types as strings
- * @args: list of args as strings (args[i] matches types[i])
- */
-struct syscall_metadata {
-	const char	*name;
-	int		nb_args;
-	const char	**types;
-	const char	**args;
-};
-
-#ifdef CONFIG_FTRACE_SYSCALLS
-extern void arch_init_ftrace_syscalls(void);
-extern struct syscall_metadata *syscall_nr_to_meta(int nr);
-extern void start_ftrace_syscalls(void);
-extern void stop_ftrace_syscalls(void);
-extern void ftrace_syscall_enter(struct pt_regs *regs);
-extern void ftrace_syscall_exit(struct pt_regs *regs);
-#else
-static inline void start_ftrace_syscalls(void) { }
-static inline void stop_ftrace_syscalls(void) { }
-static inline void ftrace_syscall_enter(struct pt_regs *regs) { }
-static inline void ftrace_syscall_exit(struct pt_regs *regs) { }
-#endif
-
 #endif /* _LINUX_FTRACE_H */
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 471143b..35bbf67 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -66,7 +66,7 @@ struct perf_counter_hw_event;
 #include <asm/signal.h>
 #include <linux/quota.h>
 #include <linux/key.h>
-#include <linux/ftrace.h>
+#include <trace/syscall.h>
 
 #define __SC_DECL1(t1, a1)	t1 a1
 #define __SC_DECL2(t2, a2, ...) t2 a2, __SC_DECL1(__VA_ARGS__)
diff --git a/include/trace/syscall.h b/include/trace/syscall.h
new file mode 100644
index 0000000..27d1d31
--- /dev/null
+++ b/include/trace/syscall.h
@@ -0,0 +1,35 @@
+#ifndef _TRACE_SYSCALL_H
+#define _TRACE_SYSCALL_H
+
+#include <asm/ptrace.h>
+
+/*
+ * A syscall entry in the ftrace syscalls array.
+ *
+ * @name: name of the syscall
+ * @nb_args: number of parameters it takes
+ * @types: list of types as strings
+ * @args: list of args as strings (args[i] matches types[i])
+ */
+struct syscall_metadata {
+	const char	*name;
+	int		nb_args;
+	const char	**types;
+	const char	**args;
+};
+
+#ifdef CONFIG_FTRACE_SYSCALLS
+extern void arch_init_ftrace_syscalls(void);
+extern struct syscall_metadata *syscall_nr_to_meta(int nr);
+extern void start_ftrace_syscalls(void);
+extern void stop_ftrace_syscalls(void);
+extern void ftrace_syscall_enter(struct pt_regs *regs);
+extern void ftrace_syscall_exit(struct pt_regs *regs);
+#else
+static inline void start_ftrace_syscalls(void) { }
+static inline void stop_ftrace_syscalls(void) { }
+static inline void ftrace_syscall_enter(struct pt_regs *regs) { }
+static inline void ftrace_syscall_exit(struct pt_regs *regs) { }
+#endif
+
+#endif /* _TRACE_SYSCALL_H */
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index a2a3af2..5e57964 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -1,5 +1,5 @@
+#include <trace/syscall.h>
 #include <linux/kernel.h>
-#include <linux/ftrace.h>
 #include <asm/syscall.h>
 
 #include "trace_output.h"
-- 
1.6.1



