Return-Path: <linux-kernel-owner+w=401wt.eu-S1760745AbZJODZJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760745AbZJODZJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 23:25:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757672AbZJODZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 23:25:08 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:46697 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757139AbZJODZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 23:25:07 -0400
Date: Thu, 15 Oct 2009 05:24:29 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, arjan@linux.jf.intel.com,
       linux-kernel@vger.kernel.org, chinang.ma@intel.com
Subject: Re: [patch 2/2] x86_64: align RODATA kernel section to 2MB with
	CONFIG_DEBUG_RODATA
Message-ID: <20091015032429.GA10068@merkur.ravnborg.org>
References: <20091014214654.423040927@sbs-t61.sc.intel.com> <20091014220254.190119924@sbs-t61.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091014220254.190119924@sbs-t61.sc.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Index: tree/arch/x86/include/asm/sections.h
> ===================================================================
> --- tree.orig/arch/x86/include/asm/sections.h
> +++ tree/arch/x86/include/asm/sections.h
> @@ -2,7 +2,13 @@
>  #define _ASM_X86_SECTIONS_H
>  
>  #include <asm-generic/sections.h>
> +#include <asm/uaccess.h>
>  
>  extern char __brk_base[], __brk_limit[];
> +extern struct exception_table_entry __stop___ex_table[];
> +
> +#if defined(CONFIG_X86_64) && defined(CONFIG_DEBUG_RODATA)
> +extern char __end_rodata_hpage_align[];
> +#endif
>  
>  #endif	/* _ASM_X86_SECTIONS_H */
> Index: tree/arch/x86/kernel/vmlinux.lds.S
> ===================================================================
> --- tree.orig/arch/x86/kernel/vmlinux.lds.S
> +++ tree/arch/x86/kernel/vmlinux.lds.S
> @@ -41,6 +41,21 @@ ENTRY(phys_startup_64)
>  jiffies_64 = jiffies;
>  #endif
>  
> +#if defined(CONFIG_X86_64) && defined(CONFIG_DEBUG_RODATA)
> +
> +#define X64_ALIGN_DEBUG_RODATA_BEGIN	. = ALIGN(HPAGE_SIZE);
> +
> +#define X64_ALIGN_DEBUG_RODATA_END				\
> +		. = ALIGN(HPAGE_SIZE);				\
> +		__end_rodata_hpage_align = .;
This symbol is only defined if CONFIG_DEBUG_RODATA is defined, but (see below).

> +
> +#else
> +
> +#define X64_ALIGN_DEBUG_RODATA_BEGIN
> +#define X64_ALIGN_DEBUG_RODATA_END
> +
> +#endif

A coment describing the purpose of
this would be nice.

> +
>  PHDRS {
>  	text PT_LOAD FLAGS(5);          /* R_E */
>  	data PT_LOAD FLAGS(7);          /* RWE */
> @@ -90,7 +105,9 @@ SECTIONS
>  
>  	EXCEPTION_TABLE(16) :text = 0x9090
>  
> +	X64_ALIGN_DEBUG_RODATA_BEGIN
>  	RO_DATA(PAGE_SIZE)
> +	X64_ALIGN_DEBUG_RODATA_END
>  
>  	/* Data */
>  	.data : AT(ADDR(.data) - LOAD_OFFSET) {
> Index: tree/arch/x86/mm/init_64.c
> ===================================================================
> --- tree.orig/arch/x86/mm/init_64.c
> +++ tree/arch/x86/mm/init_64.c
> @@ -726,9 +726,13 @@ void set_kernel_text_ro(void)
>  
>  void mark_rodata_ro(void)
>  {
> -	unsigned long start = PFN_ALIGN(_text), end = PFN_ALIGN(__end_rodata);
> +	unsigned long start = PFN_ALIGN(_text);
>  	unsigned long rodata_start =
>  		((unsigned long)__start_rodata + PAGE_SIZE - 1) & PAGE_MASK;
> +	unsigned long end = (unsigned long) &__end_rodata_hpage_align;
Here the symbol seems to be referenced unconditionally.

	Sam
