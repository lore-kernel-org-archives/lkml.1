Return-Path: <linux-kernel-owner+w=401wt.eu-S1751474AbZFOBoN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751474AbZFOBoN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 21:44:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750838AbZFOBn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 21:43:59 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:36291 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750832AbZFOBn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 21:43:58 -0400
Message-ID: <4A35A75C.3090309@snapgear.com>
Date: Mon, 15 Jun 2009 11:43:56 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Mike Frysinger <vapier@gentoo.org>
CC: uclinux-dev@uclinux.org, linux-kernel@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org,
       David McCullough <davidm@snapgear.com>,
       Paul Mundt <lethal@linux-sh.org>, Jie Zhang <jie.zhang@analog.com>,
       Bernd Schmidt <bernds_cb1@t-online.de>
Subject: Re: [PATCH/RFC] FDPIC: add hook for arches to customize program header
 parsing
References: <1244854869-2563-1-git-send-email-vapier@gentoo.org>
In-Reply-To: <1244854869-2563-1-git-send-email-vapier@gentoo.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Mike Frysinger wrote:
> From: Jie Zhang <jie.zhang@analog.com>
> 
> The Blackfin port has custom program header flags/addresses for
> automatically loading regions into the dedicated on-chip SRAM.  So add a
> hook for ports to leverage.
> 
> Signed-off-by: Jie Zhang <jie.zhang@analog.com>
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> CC: Bernd Schmidt <bernds_cb1@t-online.de>

Acked-by: Greg Ungerer <gerg@uclinux.org>


>  arch/blackfin/include/asm/elf.h         |    8 +++
>  arch/blackfin/kernel/Makefile           |    1 +
>  arch/blackfin/kernel/binfmt_elf_fdpic.c |   80 +++++++++++++++++++++++++++++++
>  fs/binfmt_elf_fdpic.c                   |    7 +++
>  4 files changed, 96 insertions(+), 0 deletions(-)
>  create mode 100644 arch/blackfin/kernel/binfmt_elf_fdpic.c
> 
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
>  		seg->addr = maddr + disp;
>  		seg->p_vaddr = phdr->p_vaddr;
>  		seg->p_memsz = phdr->p_memsz;

-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
