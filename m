Return-Path: <linux-kernel-owner+w=401wt.eu-S1751017AbXBNUfH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751017AbXBNUfH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 15:35:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751015AbXBNUfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 15:35:07 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:57285 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982AbXBNUfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 15:35:05 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@osdl.org>,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch 16/21] Xen-paravirt: Add code into head.S to handle being booted by Xen
References: <20070213221729.772002682@goop.org>
	<20070213221830.707197267@goop.org>
Date: Wed, 14 Feb 2007 13:33:13 -0700
In-Reply-To: <20070213221830.707197267@goop.org> (Jeremy Fitzhardinge's
	message of "Tue, 13 Feb 2007 14:17:45 -0800")
Message-ID: <m1sld8pjhy.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

There need to be alignment directives for the page aligned chunks.

Placing the page aligned chunks in a special section is nice in that
it ensures the linker packs everything tightly but should be
completely unnecessary if the alignment is correct.

>  
> ===================================================================
> --- a/arch/i386/kernel/head.S
> +++ b/arch/i386/kernel/head.S
> @@ -519,6 +519,10 @@ 1:
>  	jmp	1b
>  #endif
>  
> +#ifdef CONFIG_XEN
> +#include "../xen/xen-head.S"
> +#endif
> +	
>  /*
>   * Real beginning of normal "text" segment
>   */
> @@ -528,7 +532,7 @@ ENTRY(_stext)
>  /*
>   * BSS section
>   */
> -.section ".bss.page_aligned","w"
> +.section ".bss.page_aligned"
>  ENTRY(swapper_pg_dir)
>  	.fill 1024,4,0
>  ENTRY(empty_zero_page)
> @@ -598,7 +602,8 @@ ENTRY(boot_gdt_table)
>  /*
>   * The Global Descriptor Table contains 28 quadwords, per-CPU.
>   */
> -	.align L1_CACHE_BYTES
> +	.section ".data.page_aligned"
> +	.align PAGE_SIZE_asm
>  ENTRY(cpu_gdt_table)
>  	.quad 0x0000000000000000	/* NULL descriptor */
>  	.quad 0x0000000000000000	/* 0x0b reserved */
> @@ -647,3 +652,6 @@ ENTRY(cpu_gdt_table)
>  	.quad 0x0000000000000000	/* 0xf0 - unused */
>  	.quad 0x0000000000000000 /* 0xf8 - GDT entry 31: double-fault TSS */
>  
> +	/* Be sure this is zeroed to avoid false validations in Xen */
> +	.fill PAGE_SIZE_asm / 8 - GDT_ENTRIES,8,0
> +	.previous

> ===================================================================
> --- a/arch/i386/kernel/vmlinux.lds.S
> +++ b/arch/i386/kernel/vmlinux.lds.S
> @@ -93,6 +93,7 @@ SECTIONS
>  
>    . = ALIGN(4096);
>    .data.page_aligned : AT(ADDR(.data.page_aligned) - LOAD_OFFSET) {
> +	*(.data.page_aligned)
>  	*(.data.idt)
>    }
>  

> --- /dev/null
> +++ b/arch/i386/xen/xen-head.S
> @@ -0,0 +1,29 @@
> +/* Xen-specific pieces of head.S, intended to be included in the right
> +	place in head.S */
> +
> +#include <linux/elfnote.h>
> +#include <asm/boot.h>
> +#include <xen/interface/elfnote.h>
> +
> +ENTRY(startup_xen)
> +	movl %esi,xen_start_info
> +	jmp startup_paravirt
> +	
> +.pushsection ".bss.page_aligned"
> +ENTRY(hypercall_page)
> +	.skip 0x1000
> +.popsection
> +
> +	ELFNOTE(Xen, XEN_ELFNOTE_GUEST_OS,       .asciz, "linux")
> +	ELFNOTE(Xen, XEN_ELFNOTE_GUEST_VERSION,  .asciz, "2.6")
> +	ELFNOTE(Xen, XEN_ELFNOTE_XEN_VERSION,    .asciz, "xen-3.0")
> +	ELFNOTE(Xen, XEN_ELFNOTE_VIRT_BASE,      .long,  __PAGE_OFFSET)
> +	ELFNOTE(Xen, XEN_ELFNOTE_ENTRY,          .long,  startup_xen)
> +	ELFNOTE(Xen, XEN_ELFNOTE_HYPERCALL_PAGE, .long,  hypercall_page)
> + ELFNOTE(Xen, XEN_ELFNOTE_FEATURES, .asciz,
> "!writable_page_tables|pae_pgdir_above_4gb")
> +#ifdef CONFIG_X86_PAE
> +	ELFNOTE(Xen, XEN_ELFNOTE_PAE_MODE,       .asciz, "yes")
> +#else
> +	ELFNOTE(Xen, XEN_ELFNOTE_PAE_MODE,       .asciz, "no")
> +#endif
> +	ELFNOTE(Xen, XEN_ELFNOTE_LOADER,         .asciz, "generic")
