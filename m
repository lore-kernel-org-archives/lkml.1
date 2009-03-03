Return-Path: <linux-kernel-owner+w=401wt.eu-S1758212AbZCCEyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758212AbZCCEyY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 23:54:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754209AbZCCEyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 23:54:15 -0500
Received: from ns2.suse.de ([195.135.220.15]:39050 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753630AbZCCEyO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 23:54:14 -0500
Date: Tue, 3 Mar 2009 05:54:06 +0100
From: Nick Piggin <npiggin@suse.de>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC][PATCH] x86: make text_poke() atomic
Message-ID: <20090303045406.GD3973@wotan.suse.de>
References: <20090223161312.GA30279@Krystal> <alpine.DEB.2.00.0902231125520.18221@gandalf.stny.rr.com> <20090223173108.GB1441@Krystal> <alpine.DEB.2.00.0902231236340.18221@gandalf.stny.rr.com> <49A82851.5080707@redhat.com> <20090227180724.GA17947@Krystal> <49A83237.40604@redhat.com> <20090227185316.GA19811@Krystal> <49A853CD.3020607@redhat.com> <49AC10E9.1090102@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49AC10E9.1090102@redhat.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 02, 2009 at 12:01:29PM -0500, Masami Hiramatsu wrote:
> ---
> 
> Use map_vm_area() instead of vmap() in text_poke() for avoiding page 
> allocation
> and delayed unmapping, and call vunmap_page_range() and local_flush_tlb()
> directly because this mapping is temporary and local.
> 
> At the result of above change, text_poke() becomes atomic and can be called
> from stop_machine() etc.
> 
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> Cc: Nick Piggin <npiggin@suse.de>
> ---
>  arch/x86/include/asm/alternative.h |    1 +
>  arch/x86/kernel/alternative.c      |   36 
>  +++++++++++++++++++++++++++++-------
>  include/linux/vmalloc.h            |    1 +
>  init/main.c                        |    3 +++
>  mm/vmalloc.c                       |    2 +-
>  5 files changed, 35 insertions(+), 8 deletions(-)
> 
> Index: linux-2.6/arch/x86/include/asm/alternative.h
> ===================================================================
> --- linux-2.6.orig/arch/x86/include/asm/alternative.h
> +++ linux-2.6/arch/x86/include/asm/alternative.h
> @@ -177,6 +177,7 @@ extern void add_nops(void *insns, unsign
>   * The _early version expects the memory to already be RW.
>   */
> 
> +extern void text_poke_init(void);
>  extern void *text_poke(void *addr, const void *opcode, size_t len);
>  extern void *text_poke_early(void *addr, const void *opcode, size_t len);
> 
> Index: linux-2.6/arch/x86/kernel/alternative.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/alternative.c
> +++ linux-2.6/arch/x86/kernel/alternative.c
> @@ -12,6 +12,7 @@
>  #include <asm/nmi.h>
>  #include <asm/vsyscall.h>
>  #include <asm/cacheflush.h>
> +#include <asm/tlbflush.h>
>  #include <asm/io.h>
> 
>  #define MAX_PATCH_LEN (255-1)
> @@ -485,6 +486,16 @@ void *text_poke_early(void *addr, const
>  	return addr;
>  }
> 
> +static struct vm_struct *text_poke_area[2];
> +static DEFINE_SPINLOCK(text_poke_lock);
> +
> +void __init text_poke_init(void)
> +{
> +	text_poke_area[0] = get_vm_area(PAGE_SIZE, VM_ALLOC);
> +	text_poke_area[1] = get_vm_area(2 * PAGE_SIZE, VM_ALLOC);
> +	BUG_ON(!text_poke_area[0] || !text_poke_area[1]);
> +}
> +
>  /**
>   * text_poke - Update instructions on a live kernel
>   * @addr: address to modify
> @@ -501,8 +512,9 @@ void *__kprobes text_poke(void *addr, co
>  	unsigned long flags;
>  	char *vaddr;
>  	int nr_pages = 2;
> -	struct page *pages[2];
> -	int i;
> +	struct page *pages[2], **pgp = pages;
> +	int i, ret;
> +	struct vm_struct *vma;
> 
>  	if (!core_kernel_text((unsigned long)addr)) {
>  		pages[0] = vmalloc_to_page(addr);

This is really good....

> @@ -515,12 +527,22 @@ void *__kprobes text_poke(void *addr, co
>  	BUG_ON(!pages[0]);
>  	if (!pages[1])
>  		nr_pages = 1;
> -	vaddr = vmap(pages, nr_pages, VM_MAP, PAGE_KERNEL);
> -	BUG_ON(!vaddr);
        ^^^^^^^^^^^^^^
This really is nasty bug in text_poke, and I never knew why it was
allowed to live for so long!

Thanks,
Nick
