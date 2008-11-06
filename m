Return-Path: <linux-kernel-owner+w=401wt.eu-S1751467AbYKFUNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751467AbYKFUNd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 15:13:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753298AbYKFUM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 15:12:57 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:6210 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268AbYKFUMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 15:12:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Fa7qKlQeluyV1HUOLkVoc7qqollruzS45jz9CaE2L0wkFzO8hfoRAHMIyc/GlB4hIU
         ksOy6xCHWBEd+jMR5X1oDx88zM3FYKJqXot9tks6wlgTRhLfS7c8ybeU8FL3HFpXxoY3
         nqG5ynH/vySYxUvDbeEU3ZVjGMR58/qpM4Dhs=
Date: Thu, 6 Nov 2008 23:15:59 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Steven Rostedt <srostedt@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: next-20081106: today's ftrace episode
Message-ID: <20081106201559.GA17602@x200.localdomain>
References: <20081106173645.e7e79071.sfr@canb.auug.org.au> <20081106194432.GA17188@x200.localdomain> <49134D8E.1070407@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49134D8E.1070407@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2008 at 03:03:26PM -0500, Steven Rostedt wrote:
> Alexey Dobriyan wrote:
>> On m68k-amiga:
>>
>>   CC      arch/m68k/kernel/asm-offsets.s
>> In file included from include/linux/fs.h:287,
>>                  from include/linux/ftrace.h:5,		<===
>>                  from include/linux/hardirq.h:7,
>>                  from include2/asm/system.h:69,
>>                  from include/linux/list.h:7,		<===
>>                  from include/linux/preempt.h:11,
>>                  from include/linux/spinlock.h:50,
>>                  from include/linux/seqlock.h:29,
>>                  from include/linux/time.h:8,
>>                  from include/linux/timex.h:57,
>>                  from include/linux/sched.h:54,
>>                  from arch/m68k/kernel/asm-offsets.c:12:
>> include/linux/wait.h:37: error: field 'task_list' has incomplete type
>> 	...
>>
>> commit 7e5e26a3d8ac4bcadb380073dc9604c07a9a6198 aka "trace: fix hardirq header for non ftrace archs"
>>
>>
>>   
> We only need to include the ftrace.h to declare the ftrace_nmi_enter and  
> exit.
>
> I could separate that out into its own "ftrace_irq.h" file, that  
> hardirq.h can include. That should fix it.
>
> basically all that would be needed in that file is this:
>
> #ifdef CONFIG_DYNAMIC_FTRACE
>    extern void ftrace_nmi_enter(void);
>    extern void ftrace_nmi_exit(void);
> #else
>    static inline void ftrace_nmi_enter(void) { }
>    static inline void ftrace_nmi_exit(void) { }
> #endif /* CONFIG_DYNAMIC_FTRACE */

Oh, this is only for that.

Here is patch that allows m68k to compile, I've came up with.

--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -1,14 +1,12 @@
 #ifndef _LINUX_FTRACE_H
 #define _LINUX_FTRACE_H
 
+#include <linux/kallsyms.h>
+#ifdef CONFIG_FUNCTION_TRACER
 #include <linux/linkage.h>
-#include <linux/fs.h>
 #include <linux/ktime.h>
 #include <linux/init.h>
 #include <linux/types.h>
-#include <linux/kallsyms.h>
-
-#ifdef CONFIG_FUNCTION_TRACER
 
 extern int ftrace_enabled;
 extern int
@@ -236,7 +234,7 @@ static inline void
 ftrace_init_module(unsigned long *start, unsigned long *end) { }
 #endif
 
-
+#ifdef CONFIG_BOOT_TRACER
 struct boot_trace {
 	pid_t			caller;
 	char			func[KSYM_NAME_LEN];
@@ -246,12 +244,10 @@ struct boot_trace {
 	ktime_t			rettime;
 };
 
-#ifdef CONFIG_BOOT_TRACER
 extern void trace_boot(struct boot_trace *it, initcall_t fn);
 extern void start_boot_trace(void);
 extern void stop_boot_trace(void);
 #else
-static inline void trace_boot(struct boot_trace *it, initcall_t fn) { }
 static inline void start_boot_trace(void) { }
 static inline void stop_boot_trace(void) { }
 #endif
--- a/init/main.c
+++ b/init/main.c
@@ -728,6 +728,7 @@ core_param(initcall_debug, initcall_debug, bool, 0644);
 
 int do_one_initcall(initcall_t fn)
 {
+#ifdef CONFIG_BOOT_TRACER
 	int count = preempt_count();
 	ktime_t delta;
 	char msgbuf[64];
@@ -768,6 +769,9 @@ int do_one_initcall(initcall_t fn)
 	}
 
 	return it.result;
+#else
+	return fn();
+#endif
 }
 
 
