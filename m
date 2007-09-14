Return-Path: <linux-kernel-owner+w=401wt.eu-S1757663AbXINFIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757663AbXINFIA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 01:08:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751847AbXINFHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 01:07:51 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36340 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751879AbXINFHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 01:07:50 -0400
Date: Thu, 13 Sep 2007 22:07:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RESEND] i386 and x86_64: randomize brk()
Message-Id: <20070913220725.f7fb5374.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0709111416390.7343@jikos.suse.cz>
References: <Pine.LNX.4.64.0709111416390.7343@jikos.suse.cz>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Sep 2007 14:17:24 +0200 (CEST) Jiri Kosina <jkosina@suse.cz> wrote:

> From: Jiri Kosina <jkosina@suse.cz>
> 
> i386 and x86_64: randomize brk()
> 
> This patch randomizes the location of the heap (brk) for i386 and x86_64.
> The range is randomized in the range starting at current brk location up
> to 0x02000000 offset for both architectures. This, together with
> pie-executable-randomization.patch and
> pie-executable-randomization-fix.patch, should make the address space
> randomization on i386 and x86_64 complete.
> 
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> 
> diff --git a/arch/i386/kernel/process.c b/arch/i386/kernel/process.c
> index 8466471..8e0624d 100644
> --- a/arch/i386/kernel/process.c
> +++ b/arch/i386/kernel/process.c
> @@ -949,3 +949,17 @@ unsigned long arch_align_stack(unsigned long sp)
>  		sp -= get_random_int() % 8192;
>  	return sp & ~0xf;
>  }
> +
> +unsigned long arch_randomize_brk(unsigned long brk)
> +{
> +	unsigned long new_brk;
> +	unsigned long range_end;
> +
> +	range_end = brk + 0x02000000;
> +	new_brk = randomize_range(brk, range_end, 0);
> +	if (new_brk)
> +		return new_brk;
> +	else
> +		return brk;
> +}
> +
> diff --git a/arch/x86_64/kernel/process.c b/arch/x86_64/kernel/process.c
> index 2842f50..b20f0eb 100644
> --- a/arch/x86_64/kernel/process.c
> +++ b/arch/x86_64/kernel/process.c
> @@ -902,3 +902,17 @@ unsigned long arch_align_stack(unsigned long sp)
>  		sp -= get_random_int() % 8192;
>  	return sp & ~0xf;
>  }
> +
> +unsigned long arch_randomize_brk(unsigned long brk)
> +{
> +	unsigned long new_brk;
> +	unsigned long range_end;
> +
> +	range_end = brk + 0x02000000;
> +	new_brk = randomize_range(brk, range_end, 0);
> +	if (new_brk)
> +		return new_brk;
> +	else
> +		return brk;
> +}
> +
> diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
> index d65f1d9..7afec71 100644
> --- a/fs/binfmt_elf.c
> +++ b/fs/binfmt_elf.c
> @@ -47,6 +47,9 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs);
>  static int load_elf_library(struct file *);
>  static unsigned long elf_map (struct file *, unsigned long, struct elf_phdr *, int, int, unsigned long);
>  
> +/* overriden by architectures supporting brk randomization */
> +unsigned long __weak arch_randomize_brk(unsigned long brk) { return brk; }
> +
>  /*
>   * If we don't support core dumping, then supply a NULL so we
>   * don't even try.
> @@ -1073,6 +1076,10 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
>  	current->mm->end_data = end_data;
>  	current->mm->start_stack = bprm->p;
>  
> +	if (current->flags & PF_RANDOMIZE)
> +		current->mm->brk = current->mm->start_brk = 
> +			arch_randomize_brk(current->mm->brk);
> +
>  	if (current->personality & MMAP_PAGE_ZERO) {
>  		/* Why this, you ask???  Well SVr4 maps page 0 as read-only,
>  		   and some applications "depend" upon this behavior.

We need a prototype of arch_randomize_brk() in scope for all callers and
implementations, so that the compiler can perform the appropriate
typechecking.

--- a/include/linux/mm.h~i386-and-x86_64-randomize-brk-fix
+++ a/include/linux/mm.h
@@ -1017,6 +1017,7 @@ out:
 extern int do_munmap(struct mm_struct *, unsigned long, size_t);
 
 extern unsigned long do_brk(unsigned long, unsigned long);
+extern unsigned long arch_randomize_brk(unsigned long brk);
 
 /* filemap.c */
 extern unsigned long page_unuse(struct page *);
_

