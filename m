Return-Path: <linux-kernel-owner+w=401wt.eu-S1757525AbYEKUqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757525AbYEKUqb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 16:46:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753450AbYEKUqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 16:46:22 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:63807 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbYEKUqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 16:46:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mime-version:content-type:content-disposition:user-agent:from;
        b=HUiljKjPWGzCsRLPDjWk+wM2BfbAqgUFCdLo3EupOlVW62N84hiBi2tRzM4zgEsBeNhV6t03rLgKG8pnKudm1ury7+G8wFB/thMxqhm3/kGhEOsQvSJMaYfQqCcyW9FPSOlXAUeaPAjNeI/DLCi3RE6dk6kBTUBeQ8WQenmhJV4=
Date: Sun, 11 May 2008 22:46:14 +0200
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Error in save_stack_trace() on x86_64?
Message-ID: <20080511204614.GA26910@damson.getinternet.no>
Reply-To: 48274FF2.8040202@linux.intel.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 11, 2008 at 9:58 PM, Arjan van de Ven <arjan@linux.intel.com> wrote:
> Vegard Nossum wrote: in userspace this trace looks correct.
> 
> > No, it is happening from kernel code. As you can see from the original
> > backtrace, the regs->ip (RIP) (regs taken from the very same
> > do_page_fault()) points at add_uevent_var, which is a kernel function.
> > 
> > 
> > >  if it happens in kernel space... I wonder if the separate exception
> stack
> > > thing
> > >  is hurting us with the stacks not being properly connected...
> > >  (but oopses and the like seem to come out just fine so I kinda doubt
> you're
> > > hitting that)
> > > 
> > > 
> > 
> > Thanks for looking into this.
>  
>  do you happen to have something that I maybe can reproduce?
>  (if you have that it would save me a ton of time in reproducing)
>  

Here's a very dirty hack that reproduces it for me. I'm sorry I don't have
the logs to show it, but it works correctly on 32-bit, but not on 64-bit.

I guess you should also make sure that:

CONFIG_DEBUG_INFO=y
CONFIG_FRAME_POINTER=y
CONFIG_STACKTRACE=y

Thanks.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while the programmer was not looking is intellectually dishonest as it disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036


 arch/x86/mm/fault.c |   17 +++++++++++++++++
 init/main.c         |   12 ++++++++++++
 lib/Kconfig.debug   |    1 +
 3 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index fd7e179..559a5f3 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -25,6 +25,7 @@
 #include <linux/kprobes.h>
 #include <linux/uaccess.h>
 #include <linux/kdebug.h>
+#include <linux/stacktrace.h>
 
 #include <asm/system.h>
 #include <asm/desc.h>
@@ -602,6 +603,22 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
 	if (notify_page_fault(regs))
 		return;
 
+	dump_stack();
+
+	struct stack_trace trace;
+	unsigned long entries[16];
+	trace.nr_entries = 0;
+	trace.entries = entries;
+	trace.max_entries = 16;
+	trace.skip = 0;
+	printk(KERN_EMERG "saved stack trace:\n");
+	save_stack_trace(&trace);
+	print_stack_trace(&trace, 0);
+	printk(KERN_EMERG "end saved stack trace\n");
+
+	while(1)
+		halt();
+
 	/*
 	 * We fault-in kernel-space virtual memory on-demand. The
 	 * 'reference' page table is init_mm.pgd.
diff --git a/init/main.c b/init/main.c
index ddada7a..d9fb240 100644
--- a/init/main.c
+++ b/init/main.c
@@ -531,6 +531,16 @@ void __init __weak thread_info_cache_init(void)
 {
 }
 
+void noinline trigger_page_fault(void) {
+	struct page *p = alloc_pages(GFP_KERNEL, 0);
+	unsigned long addr = page_address(p);
+	set_memory_4k(addr, 0);
+	int level;
+	pte_t *pte = lookup_address(addr, &level);
+	set_pte(pte, __pte(pte_val(*pte) & ~_PAGE_PRESENT));
+	*(char*) addr = 0;
+}
+
 asmlinkage void __init start_kernel(void)
 {
 	char * command_line;
@@ -680,6 +690,8 @@ asmlinkage void __init start_kernel(void)
 
 	acpi_early_init(); /* before LAPIC and SMP init */
 
+	trigger_page_fault();
+
 	/* Do the rest non-__init'ed, we're now alive */
 	rest_init();
 }
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index d2099f4..3fc1247 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -419,6 +419,7 @@ config DEBUG_LOCKING_API_SELFTESTS
 
 config STACKTRACE
 	bool
+	default y
 	depends on DEBUG_KERNEL
 	depends on STACKTRACE_SUPPORT
 
-- 
1.5.4.1

