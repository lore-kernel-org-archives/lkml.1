Return-Path: <linux-kernel-owner+w=401wt.eu-S1763385AbYDVWO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763385AbYDVWO3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 18:14:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759041AbYDVWN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 18:13:57 -0400
Received: from wr-out-0506.google.com ([64.233.184.224]:8682 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758202AbYDVWN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 18:13:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=WLGCtHArL/NwG+6TfXADCRaqM7DQpvaHLYdDBp076VE+VTldFNPbb964YK4ELPPz/05989cxaUsncEAXs00au72And4eQwyFXbL3qdYs4cs9CHuUJJtFVYmT3vil8h8NhUAKE6aIbF3wA9Hk6d+unHVmvGEyukf5/95OzPeYPHs=
Subject: Re: [PATCH V2] use canary at end of stack to indicate overruns at
	oops time
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>,
       linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Joe Perches <joe@perches.com>
In-Reply-To: <480E5ACF.7010105@sandeen.net>
References: <480D5F27.1030101@redhat.com>  <480E5ACF.7010105@sandeen.net>
Content-Type: text/plain
Date: Tue, 22 Apr 2008 15:14:20 -0700
Message-Id: <1208902460.24124.17.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-04-22 at 16:38 -0500, Eric Sandeen wrote:

> ... unless the stack overrun is so bad that it corrupts some other
> thread.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> Index: linux-2.6.25/arch/x86/mm/fault.c
> ===================================================================
> --- linux-2.6.25.orig/arch/x86/mm/fault.c
> +++ linux-2.6.25/arch/x86/mm/fault.c
> @@ -25,6 +25,7 @@
>  #include <linux/kprobes.h>
>  #include <linux/uaccess.h>
>  #include <linux/kdebug.h>
> +#include <linux/magic.h>
>  
>  #include <asm/system.h>
>  #include <asm/desc.h>
> @@ -581,6 +582,8 @@ void __kprobes do_page_fault(struct pt_r
>  	unsigned long address;
>  	int write, si_code;
>  	int fault;
> +	unsigned long *stackend;
> +
>  #ifdef CONFIG_X86_64
>  	unsigned long flags;
>  #endif
> @@ -850,6 +853,10 @@ no_context:
>  
>  	show_fault_oops(regs, error_code, address);
>  
> + 	stackend = end_of_stack(tsk);
> +	if (*stackend != STACK_END_MAGIC)
> +		printk(KERN_ALERT "Thread overran stack, or stack corrupted\n");
> +
>  	tsk->thread.cr2 = address;
>  	tsk->thread.trap_no = 14;
>  	tsk->thread.error_code = error_code;
> Index: linux-2.6.25/include/linux/magic.h
> ===================================================================
> --- linux-2.6.25.orig/include/linux/magic.h
> +++ linux-2.6.25/include/linux/magic.h
> @@ -42,4 +42,5 @@
>  #define FUTEXFS_SUPER_MAGIC	0xBAD1DEA
>  #define INOTIFYFS_SUPER_MAGIC	0x2BAD1DEA
>  
> +#define STACK_END_MAGIC		0x57AC6E9D
>  #endif /* __LINUX_MAGIC_H__ */
> Index: linux-2.6.25/kernel/fork.c
> ===================================================================
> --- linux-2.6.25.orig/kernel/fork.c
> +++ linux-2.6.25/kernel/fork.c
> @@ -53,6 +53,7 @@
>  #include <linux/tty.h>
>  #include <linux/proc_fs.h>
>  #include <linux/blkdev.h>
> +#include <linux/magic.h>
>  
>  #include <asm/pgtable.h>
>  #include <asm/pgalloc.h>
> @@ -167,6 +168,8 @@ static struct task_struct *dup_task_stru
>  {
>  	struct task_struct *tsk;
>  	struct thread_info *ti;
> +	unsigned long *stackend;
> +
>  	int err;
>  
>  	prepare_to_copy(orig);
> @@ -192,6 +195,8 @@ static struct task_struct *dup_task_stru
>  	}
>  
>  	setup_thread_stack(tsk, orig);
> +	stackend = end_of_stack(tsk);
> +	*stackend = STACK_END_MAGIC;	/* for overflow detection */
>  
>  #ifdef CONFIG_CC_STACKPROTECTOR
>  	tsk->stack_canary = get_random_int();
> Index: linux-2.6.25/kernel/exit.c
> ===================================================================
> --- linux-2.6.25.orig/kernel/exit.c
> +++ linux-2.6.25/kernel/exit.c
> @@ -823,12 +823,9 @@ static void check_stack_usage(void)
>  {
>  	static DEFINE_SPINLOCK(low_water_lock);
>  	static int lowest_to_date = THREAD_SIZE;
> -	unsigned long *n = end_of_stack(current);
>  	unsigned long free;
>  
> -	while (*n == 0)
> -		n++;
> -	free = (unsigned long)n - (unsigned long)end_of_stack(current);
> +	free = stack_not_used(current);
>  
>  	if (free >= lowest_to_date)
>  		return;
> Index: linux-2.6.25/kernel/sched.c
> ===================================================================
> --- linux-2.6.25.orig/kernel/sched.c
> +++ linux-2.6.25/kernel/sched.c
> @@ -5188,12 +5188,7 @@ void sched_show_task(struct task_struct 
>  		printk(KERN_CONT " %016lx ", thread_saved_pc(p));
>  #endif
>  #ifdef CONFIG_DEBUG_STACK_USAGE
> -	{
> -		unsigned long *n = end_of_stack(p);
> -		while (!*n)
> -			n++;
> -		free = (unsigned long)n - (unsigned long)end_of_stack(p);
> -	}
> +	free = stack_not_used(p);
>  #endif

Maybe remove the #ifdef CONFIG_DEBUG_STACK_USAGE block and move it into
stack_not_used...call it debug_stack_not_used.

>  	printk(KERN_CONT "%5lu %5d %6d\n", free,
>  		task_pid_nr(p), task_pid_nr(p->real_parent));
> Index: linux-2.6.25/include/linux/sched.h
> ===================================================================
> --- linux-2.6.25.orig/include/linux/sched.h
> +++ linux-2.6.25/include/linux/sched.h
> @@ -1893,6 +1893,19 @@ static inline unsigned long *end_of_stac
>  
>  #endif
>  
> +#ifdef CONFIG_DEBUG_STACK_USAGE
> +static inline unsigned long stack_not_used(struct task_struct *p)
> +{
> +	unsigned long *n = end_of_stack(p);
> +
> +	do { 	/* Skip over canary */
> +		n++;
> +	} while (!*n);
> +
> +	return (unsigned long)n - (unsigned long)end_of_stack(p);
> +}
> +#endif
> +

static inline unsigned long debug_stack_not_used(struct task_struct *p)
{
#ifdef CONFIG_DEBUG_STACK_USAGE
	unsigned long *n = end_of_stack(p);

	do { 	/* Skip over canary */
		n++;
	} while (!*n);

	return (unsigned long)n - (unsigned long)end_of_stack(p);
#else
	return $(large_value)....maybe or just some known value.
#endif
}

Also, do you expect this to ever be used outside of sched.c?  Maybe just
leave it as a static function there rather than an inline in the header.

Harvey

