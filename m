Return-Path: <linux-kernel-owner+w=401wt.eu-S1752363AbZKCF60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363AbZKCF60 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 00:58:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751467AbZKCF60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 00:58:26 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:36942 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332AbZKCF6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 00:58:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rdAi7EZDspXdTRihri+cwYS+m1DwjxDhWqeKHkC1KZuKWU6lMMn42+VTTNvu1JN2xb
         ZzbHP3df53+y1B9Brv9BwFzrqvJ405cWD8zT6E0Ul6dJFlsUdvTEeOv/qkLWYhBm7nHF
         vWc75J9EHVHgPQU5rQgnePPmuO8BOtBJu149c=
Date: Tue, 3 Nov 2009 13:58:47 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Stefani Seibold <stefani@seibold.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] fix X86_64 procfs provide stack information for threads
Message-ID: <20091103055847.GA10629@hack.redhat.com>
References: <1257158829.5199.26.camel@wall-e>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257158829.5199.26.camel@wall-e>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 02, 2009 at 11:47:09AM +0100, Stefani Seibold wrote:
>This patch fix two issues in the procfs stack information on X86_64
>linux. 
>
>The 32 bit loader compat_do_execve did not store stack start (this was
>figured out by alexey).
>
>The stack information on a X64_64 kernel always show 0 kbyte stack
>usage, because of a miss implemented KSTK_ESP macro which always return
>-1. The new implementation returns now the right value. 
>
>The patch is against 2.6.32-rc5-git5.
>
>Andrew would you so kind to apply this patch?
>
>Greetings,
>Stefani
>
>Signed-off-by: Stefani Seibold <stefani@seibold.net>
>---
> arch/x86/include/asm/processor.h |    9 ++++++++-
> arch/x86/kernel/process_64.c     |    8 ++++++++
> fs/compat.c                      |    2 ++
> 3 files changed, 18 insertions(+), 1 deletion(-)
>
>--- linux-2.6.32-rc5/fs/compat.c	2009-10-16 02:41:50.000000000 +0200
>+++ linux-2.6.32-rc5.new/fs/compat.c	2009-11-02 09:00:52.871909633 +0100
>@@ -1532,6 +1532,8 @@
> 	if (retval < 0)
> 		goto out;
> 
>+	current->stack_start = current->mm->start_stack;
>+
> 	/* execve succeeded */
> 	current->fs->in_exec = 0;
> 	current->in_execve = 0;
>--- linux-2.6.32-rc5/arch/x86/include/asm/processor.h	2009-10-16 02:41:50.000000000 +0200
>+++ linux-2.6.32-rc5.new/arch/x86/include/asm/processor.h	2009-11-02 10:39:47.177909657 +0100
>@@ -29,6 +29,7 @@
> #include <linux/threads.h>
> #include <linux/math64.h>
> #include <linux/init.h>
>+//#include <linux/sched.h>

Hey, what is this? :)

Except this, this patch looks fine for me:

Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>

> 
> /*
>  * Default implementation of macro that returns current
>@@ -1000,7 +1001,13 @@
> #define thread_saved_pc(t)	(*(unsigned long *)((t)->thread.sp - 8))
> 
> #define task_pt_regs(tsk)	((struct pt_regs *)(tsk)->thread.sp0 - 1)
>-#define KSTK_ESP(tsk)		-1 /* sorry. doesn't work for syscall. */
>+
>+#ifdef CONFIG_IA32_EMULATION
>+extern unsigned long KSTK_ESP(struct task_struct *task);
>+#else
>+#define KSTK_ESP(task)		((task)->thread.usersp)
>+#endif
>+
> #endif /* CONFIG_X86_64 */
> 
> extern void start_thread(struct pt_regs *regs, unsigned long new_ip,
>--- linux-2.6.32-rc5/arch/x86/kernel/process_64.c	2009-10-16 02:41:50.000000000 +0200
>+++ linux-2.6.32-rc5.new/arch/x86/kernel/process_64.c	2009-11-02 10:48:23.614936810 +0100
>@@ -664,3 +669,11 @@
> 	return do_arch_prctl(current, code, addr);
> }
> 
>+#ifdef CONFIG_IA32_EMULATION
>+unsigned long KSTK_ESP(struct task_struct *task)
>+{
>+	return (test_tsk_thread_flag(task, TIF_IA32)) ? \
>+			(task_pt_regs(task)->sp) : \
>+			((task)->thread.usersp);
>+}
>+#endif
>
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/

-- 
Live like a child, think like the god.
 
