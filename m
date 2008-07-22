Return-Path: <linux-kernel-owner+w=401wt.eu-S1756042AbYGVCDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042AbYGVCDx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 22:03:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754119AbYGVCDp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 22:03:45 -0400
Received: from gate.crashing.org ([63.228.1.57]:42852 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991AbYGVCDo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 22:03:44 -0400
Subject: Re: [PATCH v4] elf loader support for auxvec base platform string
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Nathan Lynch <ntl@pobox.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       roland@redhat.com, John Reiser <jreiser@BitWagon.com>
In-Reply-To: <20080721184846.GU9594@localdomain>
References: <1216166331-14810-1-git-send-email-ntl@pobox.com>
	 <1216166331-14810-2-git-send-email-ntl@pobox.com>
	 <1216276539.7740.309.camel@pasglop>
	 <20080717000951.5f8cab37.akpm@linux-foundation.org>
	 <20080717221932.GL9594@localdomain>
	 <20080717154218.8981035c.akpm@linux-foundation.org>
	 <20080721184846.GU9594@localdomain>
Content-Type: text/plain
Date: Tue, 22 Jul 2008 12:03:11 +1000
Message-Id: <1216692191.11027.177.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-07-21 at 13:48 -0500, Nathan Lynch wrote:
> Some IBM POWER-based platforms have the ability to run in a
> mode which mostly appears to the OS as a different processor from the
> actual hardware.  For example, a Power6 system may appear to be a
> Power5+, which makes the AT_PLATFORM value "power5+".  This means that
> programs are restricted to the ISA supported by Power5+;
> Power6-specific instructions are treated as illegal.
> 
> However, some applications (virtual machines, optimized libraries) can
> benefit from knowledge of the underlying CPU model.  A new aux vector
> entry, AT_BASE_PLATFORM, will denote the actual hardware.  For
> example, on a Power6 system in Power5+ compatibility mode, AT_PLATFORM
> will be "power5+" and AT_BASE_PLATFORM will be "power6".  The idea is
> that AT_PLATFORM indicates the instruction set supported, while
> AT_BASE_PLATFORM indicates the underlying microarchitecture.
> 
> If the architecture has defined ELF_BASE_PLATFORM, copy that value to
> the user stack in the same manner as ELF_PLATFORM.
> 
> Signed-off-by: Nathan Lynch <ntl@pobox.com>

Andrew, I'll merge that after John patch shows up if you give me your
Ack :-)

Cheers,
Ben.

> ---
> 
> Andrew Morton wrote:
> > OK.
> > 
> > But it conflicts directly with the already-queued
> > execve-filename-document-and-export-via-auxiliary-vector.patch (which
> > various potential reviewers blithely deleted - don't come complaining
> > to me!):
> > 
> 
> Rebased to -mm to resolve conflicts with
> execve-filename-document-and-export-via-auxiliary-vector.patch, and
> changed AT_BASE_PLATFORM to lowest unclaimed value (24).
> 
> 
>  fs/binfmt_elf.c        |   28 ++++++++++++++++++++++++++++
>  include/linux/auxvec.h |    6 +++++-
>  2 files changed, 33 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
> index bad7d87..180f92b 100644
> --- a/fs/binfmt_elf.c
> +++ b/fs/binfmt_elf.c
> @@ -131,6 +131,15 @@ static int padzero(unsigned long elf_bss)
>  #define STACK_ALLOC(sp, len) ({ sp -= len ; sp; })
>  #endif
>  
> +#ifndef ELF_BASE_PLATFORM
> +/*
> + * AT_BASE_PLATFORM indicates the "real" hardware/microarchitecture.
> + * If the arch defines ELF_BASE_PLATFORM (in asm/elf.h), the value
> + * will be copied to the user stack in the same manner as AT_PLATFORM.
> + */
> +#define ELF_BASE_PLATFORM NULL
> +#endif
> +
>  static int
>  create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
>  		unsigned long load_addr, unsigned long interp_load_addr)
> @@ -142,7 +151,9 @@ create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
>  	elf_addr_t __user *envp;
>  	elf_addr_t __user *sp;
>  	elf_addr_t __user *u_platform;
> +	elf_addr_t __user *u_base_platform;
>  	const char *k_platform = ELF_PLATFORM;
> +	const char *k_base_platform = ELF_BASE_PLATFORM;
>  	int items;
>  	elf_addr_t *elf_info;
>  	int ei_index = 0;
> @@ -172,6 +183,19 @@ create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
>  			return -EFAULT;
>  	}
>  
> +	/*
> +	 * If this architecture has a "base" platform capability
> +	 * string, copy it to userspace.
> +	 */
> +	u_base_platform = NULL;
> +	if (k_base_platform) {
> +		size_t len = strlen(k_base_platform) + 1;
> +
> +		u_base_platform = (elf_addr_t __user *)STACK_ALLOC(p, len);
> +		if (__copy_to_user(u_base_platform, k_base_platform, len))
> +			return -EFAULT;
> +	}
> +
>  	/* Create the ELF interpreter info */
>  	elf_info = (elf_addr_t *)current->mm->saved_auxv;
>  	/* update AT_VECTOR_SIZE_BASE if the number of NEW_AUX_ENT() changes */
> @@ -209,6 +233,10 @@ create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
>  		NEW_AUX_ENT(AT_PLATFORM,
>  			    (elf_addr_t)(unsigned long)u_platform);
>  	}
> +	if (k_base_platform) {
> +		NEW_AUX_ENT(AT_BASE_PLATFORM,
> +			    (elf_addr_t)(unsigned long)u_base_platform);
> +	}
>  	if (bprm->interp_flags & BINPRM_FLAGS_EXECFD) {
>  		NEW_AUX_ENT(AT_EXECFD, bprm->interp_data);
>  	}
> diff --git a/include/linux/auxvec.h b/include/linux/auxvec.h
> index 0da17d1..d7afa9d 100644
> --- a/include/linux/auxvec.h
> +++ b/include/linux/auxvec.h
> @@ -26,9 +26,13 @@
>  
>  #define AT_SECURE 23   /* secure mode boolean */
>  
> +#define AT_BASE_PLATFORM 24	/* string identifying real platform, may
> +				 * differ from AT_PLATFORM. */
> +
>  #define AT_EXECFN  31	/* filename of program */
> +
>  #ifdef __KERNEL__
> -#define AT_VECTOR_SIZE_BASE 17 /* NEW_AUX_ENT entries in auxiliary table */
> +#define AT_VECTOR_SIZE_BASE 18 /* NEW_AUX_ENT entries in auxiliary table */
>    /* number of "#define AT_.*" above, minus {AT_NULL, AT_IGNORE, AT_NOTELF} */
>  #endif
>  

