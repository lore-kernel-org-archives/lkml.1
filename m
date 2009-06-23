Return-Path: <linux-kernel-owner+w=401wt.eu-S1752460AbZFWFcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460AbZFWFcS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 01:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751228AbZFWFcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 01:32:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38362 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751080AbZFWFcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 01:32:05 -0400
Date: Mon, 22 Jun 2009 22:32:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org, Jie Zhang <jie.zhang@analog.com>,
       Bernd Schmidt <bernds_cb1@t-online.de>
Subject: Re: [PATCH] FDPIC: add hook for arches to customize program header
 parsing
Message-Id: <20090622223201.34b79adb.akpm@linux-foundation.org>
In-Reply-To: <1245140688-24871-1-git-send-email-vapier@gentoo.org>
References: <1244854869-2563-1-git-send-email-vapier@gentoo.org>
	<1245140688-24871-1-git-send-email-vapier@gentoo.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Jun 2009 04:24:48 -0400 Mike Frysinger <vapier@gentoo.org> wrote:

> From: Jie Zhang <jie.zhang@analog.com>
> 
> The Blackfin port has custom program header flags/addresses for
> automatically loading regions into the dedicated on-chip SRAM.  So add a
> hook for ports to leverage.
> 
> Signed-off-by: Jie Zhang <jie.zhang@analog.com>
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> CC: Bernd Schmidt <bernds_cb1@t-online.de>
> Acked-by: David Howells <dhowells@redhat.com>
> Acked-by: Paul Mundt <lethal@linux-sh.org>
> Acked-by: Greg Ungerer <gerg@uclinux.org>
> ---
> Andrew: could you pick this up ?  same patch as before, just with the
> additional tags added.
> 

I suppose we want to squeeze this into 2.6.31.

> diff --git a/arch/blackfin/include/asm/elf.h b/arch/blackfin/include/asm/elf.h
> index 230e160..aba2506 100644
> --- a/arch/blackfin/include/asm/elf.h
> +++ b/arch/blackfin/include/asm/elf.h
> @@ -124,4 +124,12 @@ do {											\
>  
>  #define SET_PERSONALITY(ex) set_personality(PER_LINUX)
>  
> +struct mm_struct;
> +struct elf_fdpic_params;
> +struct elf32_phdr;
> +extern int elf_fdpic_plat_process_phdr(struct mm_struct *, struct elf_fdpic_params *,
> +                                       struct elf32_phdr *, unsigned long *, unsigned long *);
> +#define ELF_FDPIC_PLAT_PROCESS_PHDR(mm, params, phdr, maddr, disp) \
> +	elf_fdpic_plat_process_phdr(mm, params, phdr, maddr, disp)
> +
>  #endif
> diff --git a/arch/blackfin/kernel/Makefile b/arch/blackfin/kernel/Makefile
> index fd4d432..71c2291 100644
> --- a/arch/blackfin/kernel/Makefile
> +++ b/arch/blackfin/kernel/Makefile
> @@ -15,6 +15,7 @@ else
>      obj-y += time.o
>  endif
>  
> +obj-$(CONFIG_BINFMT_ELF_FDPIC)       += binfmt_elf_fdpic.o
>  obj-$(CONFIG_IPIPE)                  += ipipe.o
>  obj-$(CONFIG_IPIPE_TRACE_MCOUNT)     += mcount.o
>  obj-$(CONFIG_BFIN_GPTIMERS)          += gptimers.o
> diff --git a/arch/blackfin/kernel/binfmt_elf_fdpic.c b/arch/blackfin/kernel/binfmt_elf_fdpic.c
> new file mode 100644
> index 0000000..d8192cf
> --- /dev/null
> +++ b/arch/blackfin/kernel/binfmt_elf_fdpic.c
> @@ -0,0 +1,80 @@
> +/*
> + * FDPIC ELF hooks
> + *
> + * Copyright (c) 2006-2009 Analog Devices Inc.
> + * Licensed under the GPL-2 or later.
> + */
> +
> +#include <linux/mm.h>
> +#include <linux/elf.h>
> +#include <linux/elf-fdpic.h>
> +#include <linux/kernel.h>
> +
> +#include <asm/cacheflush.h>
> +#include <asm/dma.h>
> +
> +int elf_fdpic_plat_process_phdr(struct mm_struct *mm,
> +                                struct elf_fdpic_params *params,
> +                                struct elf32_phdr *phdr,
> +                                unsigned long *maddr, unsigned long *disp)
> +{
> +	/* 0xfeb00000, 0xfec00000, 0xff700000, 0xff800000, 0xff900000
> +	 * and 0xffa00000 are also used in Dynamic linker and GNU ld.
> +	 * They need to be kept synchronized.
> +	 */
> +	unsigned long flag = 0;
> +	const char *type = NULL;
> +
> +	unsigned int e_flags = params->hdr.e_flags;
> +	unsigned long p_vaddr = phdr->p_vaddr;
> +	unsigned long p_flags = phdr->p_flags;
> +
> +	if (((e_flags & EF_BFIN_CODE_IN_L1) || p_vaddr == 0xffa00000) &&
> +	    (p_flags & (PF_W | PF_X)) == PF_X)
> +	{
> +		flag = L1_INST_SRAM;
> +		type = "L1 instruction";
> +
> +	} else if (((e_flags & EF_BFIN_DATA_IN_L1) ||
> +	            p_vaddr == 0xff700000 ||
> +	            p_vaddr == 0xff800000 ||
> +	            p_vaddr == 0xff900000) &&
> +	           (p_flags & (PF_X | PF_W)) == PF_W)
> +	{
> +		if (p_vaddr == 0xff800000) {
> +			flag = L1_DATA_A_SRAM;
> +			type = "L1 Data A";
> +		} else if (p_vaddr == 0xff900000) {
> +			flag = L1_DATA_B_SRAM;
> +			type = "L1 Data B";
> +		} else {
> +			flag = L1_DATA_SRAM;
> +			type = "L1 Data";
> +		}
> +
> +	} else if (p_vaddr == 0xfeb00000 || p_vaddr == 0xfec00000) {
> +		flag = L2_SRAM;
> +		type = "L2";
> +	}
> +
> +	if (flag) {
> +		void *sram_addr = sram_alloc_with_lsl(phdr->p_memsz, flag);
> +		if (sram_addr == NULL) {
> +			printk(KERN_ERR "elf_fdpic: not enough %s sram\n", type);
> +			return -ENOMEM;
> +		}
> +
> +		if (flag & L1_INST_SRAM)
> +			safe_dma_memcpy(sram_addr, (const void *)(*maddr + *disp), phdr->p_memsz);
> +		else
> +			memcpy(sram_addr, (const void *)(*maddr + *disp), phdr->p_memsz);
> +
> +		down_write(&mm->mmap_sem);
> +		do_munmap(mm, *maddr, phdr->p_memsz + *disp);
> +		up_write(&mm->mmap_sem);
> +		*maddr = (unsigned long)sram_addr;
> +		*disp = 0;
> +	}
> +
> +	return 0;
> +}

blah.  Is this a checkpatch stress test or what?

Geeze.

> diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
> index fdb66fa..1bad16c 100644
> --- a/fs/binfmt_elf_fdpic.c
> +++ b/fs/binfmt_elf_fdpic.c
> @@ -1105,6 +1105,13 @@ static int elf_fdpic_map_file_by_direct_mmap(struct elf_fdpic_params *params,
>  		    ELF_FDPIC_FLAG_CONTIGUOUS)
>  			load_addr += PAGE_ALIGN(phdr->p_memsz + disp);
>  
> +#ifndef ELF_FDPIC_PLAT_PROCESS_PHDR
> +# define ELF_FDPIC_PLAT_PROCESS_PHDR(mm, params, phdr, maddr, disp) 0
> +#endif
> +		ret = ELF_FDPIC_PLAT_PROCESS_PHDR(mm, params, phdr, &maddr, &disp);
> +		if (ret)
> +			return ret;
> +

Wouldn't it be simpler to do

#ifdef ELF_FDPIC_PLAT_PROCESS_PHDR
		ret = ELF_FDPIC_PLAT_PROCESS_PHDR(mm, params, phdr, &maddr,
						  &disp);
		if (ret)
			return ret;
#endif

?

If there's any prospect that we'll use ELF_FDPIC_PLAT_PROCESS_PHDR() a
second time from within this file then yes, adding a definition as
you did is appropriate.  But it should be near the top of the file, not
stuck stupidly in the middle of a C function.

