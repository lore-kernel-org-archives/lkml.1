Return-Path: <linux-kernel-owner+w=401wt.eu-S1762472AbZFOQPR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762472AbZFOQPR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 12:15:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758550AbZFOQPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 12:15:07 -0400
Received: from tomts10.bellnexxia.net ([209.226.175.54]:52901 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755090AbZFOQPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 12:15:05 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnsFAGMQNkpMQWTN/2dsb2JhbACBT9RuhA0F
Date: Mon, 15 Jun 2009 12:14:59 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       penberg@cs.helsinki.fi, torvalds@linux-foundation.org,
       vegard.nossum@gmail.com, efault@gmx.de, jeremy@goop.org,
       npiggin@suse.de, tglx@linutronix.de, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter: x86: Fix call-chain
	support to use NMI-safe methods
Message-ID: <20090615161459.GA1280@Krystal>
References: <tip-74193ef0ecab92535c8517f082f1f50504526c9b@git.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <tip-74193ef0ecab92535c8517f082f1f50504526c9b@git.kernel.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:12:46 up 107 days, 12:39,  3 users,  load average: 0.51, 0.53,
	0.54
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* tip-bot for Peter Zijlstra (a.p.zijlstra@chello.nl) wrote:
> Commit-ID:  74193ef0ecab92535c8517f082f1f50504526c9b
> Gitweb:     http://git.kernel.org/tip/74193ef0ecab92535c8517f082f1f50504526c9b
> Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
> AuthorDate: Mon, 15 Jun 2009 13:07:24 +0200
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Mon, 15 Jun 2009 15:57:53 +0200
> 
> perf_counter: x86: Fix call-chain support to use NMI-safe methods
> 
> __copy_from_user_inatomic() isn't NMI safe in that it can trigger
> the page fault handler which is another trap and its return path
> invokes IRET which will also close the NMI context.
> 
> Therefore use a GUP based approach to copy the stack frames over.
> 
> We tried an alternative solution as well: we used a forward ported
> version of Mathieu Desnoyers's "NMI safe INT3 and Page Fault" patch
> that modifies the exception return path to use an open-coded IRET with
> explicit stack unrolling and TF checking.
> 
> This didnt work as it interacted with faulting user-space instructions,
> causing them not to restart properly, which corrupts user-space
> registers.
> 
> Solving that would probably involve disassembling those instructions
> and backtracing the RIP. But even without that, the code was deemed
> rather complex to the already non-trivial x86 entry assembly code,
> so instead we went for this GUP based method that does a
> software-walk of the pagetables.
> 

Hrm, I'm probably missing something. Normally, you should test for
"in_nmi()" upon return from exception, and only in these cases go for
the open-coded IRET with stack unrolling and ret. I really don't see how
you end up messing up the page fault return to userspace path, as it's
impossible to have in_nmi() set.

Mathieu

> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Nick Piggin <npiggin@suse.de>
> Cc: Pekka Enberg <penberg@cs.helsinki.fi>
> Cc: Vegard Nossum <vegard.nossum@gmail.com>
> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> LKML-Reference: <new-submission>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> 
> ---
>  arch/x86/kernel/cpu/perf_counter.c |   49 ++++++++++++++++++++++++++++-------
>  1 files changed, 39 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
> index 6d5e7cf..e8c68a5 100644
> --- a/arch/x86/kernel/cpu/perf_counter.c
> +++ b/arch/x86/kernel/cpu/perf_counter.c
> @@ -19,6 +19,7 @@
>  #include <linux/kdebug.h>
>  #include <linux/sched.h>
>  #include <linux/uaccess.h>
> +#include <linux/highmem.h>
>  
>  #include <asm/apic.h>
>  #include <asm/stacktrace.h>
> @@ -1617,20 +1618,48 @@ perf_callchain_kernel(struct pt_regs *regs, struct perf_callchain_entry *entry)
>  	entry->kernel = entry->nr - nr;
>  }
>  
> -static int copy_stack_frame(const void __user *fp, struct stack_frame *frame)
> +/*
> + * best effort, GUP based copy_from_user() that assumes IRQ or NMI context
> + */
> +static unsigned long
> +copy_from_user_nmi(void *to, const void __user *from, unsigned long n)
>  {
> +	unsigned long offset, addr = (unsigned long)from;
> +	int type = in_nmi() ? KM_NMI : KM_IRQ0;
> +	unsigned long size, len = 0;
> +	struct page *page;
> +	void *map;
>  	int ret;
>  
> -	if (!access_ok(VERIFY_READ, fp, sizeof(*frame)))
> -		return 0;
> +	do {
> +		ret = __get_user_pages_fast(addr, 1, 0, &page);
> +		if (!ret)
> +			break;
>  
> -	ret = 1;
> -	pagefault_disable();
> -	if (__copy_from_user_inatomic(frame, fp, sizeof(*frame)))
> -		ret = 0;
> -	pagefault_enable();
> +		offset = addr & (PAGE_SIZE - 1);
> +		size = min(PAGE_SIZE - offset, n - len);
>  
> -	return ret;
> +		map = kmap_atomic(page, type);
> +		memcpy(to, map+offset, size);
> +		kunmap_atomic(map, type);
> +		put_page(page);
> +
> +		len  += size;
> +		to   += size;
> +		addr += size;
> +
> +	} while (len < n);
> +
> +	return len;
> +}
> +
> +static int copy_stack_frame(const void __user *fp, struct stack_frame *frame)
> +{
> +	unsigned long bytes;
> +
> +	bytes = copy_from_user_nmi(frame, fp, sizeof(*frame));
> +
> +	return bytes == sizeof(*frame);
>  }
>  
>  static void
> @@ -1643,7 +1672,7 @@ perf_callchain_user(struct pt_regs *regs, struct perf_callchain_entry *entry)
>  	if (!user_mode(regs))
>  		regs = task_pt_regs(current);
>  
> -	fp   = (void __user *)regs->bp;
> +	fp = (void __user *)regs->bp;
>  
>  	callchain_store(entry, regs->ip);
>  

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
