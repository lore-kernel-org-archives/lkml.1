Return-Path: <linux-kernel-owner+w=401wt.eu-S932368AbXDECou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932368AbXDECou (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 22:44:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932286AbXDECot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 22:44:49 -0400
Received: from ozlabs.org ([203.10.76.45]:43368 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932368AbXDECop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 22:44:45 -0400
Subject: Re: [PATCH] Unified lguest launcher
From: Rusty Russell <rusty@rustcorp.com.au>
To: Glauber de Oliveira Costa <glommer@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization@lists.osdl.org
In-Reply-To: <5d6222a80704040903n49442679p2a6841de69d894c2@mail.gmail.com>
References: <5d6222a80704040903n49442679p2a6841de69d894c2@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 05 Apr 2007 12:44:42 +1000
Message-Id: <1175741082.12230.610.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-04 at 13:03 -0300, Glauber de Oliveira Costa wrote:
> This is a new version of the unified lguest launcher that applies to
> the current tree. According to rusty's suggestion, I'm bothering less
> to be able to load 32 bit kernels on 64-bit machines: changing the
> launcher for such case would be the easy part! In the absence of
> further objections, I'll commit it.
> 
> Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>

Hi Glauber!

The patch looks more than reasonable, but I think we can go further with
the abstraction.  If you could spin it again, I'll apply it.  There may
be more cleanups after that, but I don't want to hold up your progress!

> --- /dev/null
> +++ linux-2.6.20/Documentation/lguest/i386/defines
> @@ -0,0 +1,4 @@
> +# We rely on CONFIG_PAGE_OFFSET to know where to put lguest binary.
> +# Some shells (dash - ubunu) can't handle numbers that big so we cheat.
> +include ../../.config
> +LGUEST_GUEST_TOP := ($(CONFIG_PAGE_OFFSET) - 0x08000000)

The include needs another ../ and seems redundant (the .config is
included from the Makefile anyway).

The shells comment is obsolete and should be deleted too, my bad.

> +++ linux-2.6.20/Documentation/lguest/i386/lguest_defs.h
> @@ -0,0 +1,9 @@
> +#ifndef _LGUEST_DEFS_H_
> +#define _LGUEST_DEFS_H_
> +
> +/* LGUEST_TOP_ADDRESS comes from the Makefile */
> +#define RESERVE_TOP_ADDRESS LGUEST_GUEST_TOP - 1024*1024

Why -1M?  And RESERVE_TOP_ADDRESS isn't used in this patch?

> +static unsigned long map_elf(int elf_fd, const void *hdr, 
>                              unsigned long *page_offset)
>  {
> -       void *addr;
> +#ifndef __x86_64__
> +       const Elf32_Ehdr *ehdr = hdr;
>         Elf32_Phdr phdr[ehdr->e_phnum];
> +#else
> +       const Elf64_Ehdr *ehdr = hdr;
> +       Elf64_Phdr phdr[ehdr->e_phnum];
> +#endif

The way we did this in the module code was to define Elf_Ehdr etc in the
arch-specific headers to avoid ifdefs.  I think it would help this code,
too. 

> +           || ((ehdr->e_machine != EM_386) &&
> +               (ehdr->e_machine != EM_X86_64))

Similarly define ELF_MACHINE?

>                else if (*page_offset != phdr[i].p_vaddr - phdr[i].p_paddr)
> +               else if ((*page_offset != phdr[i].p_vaddr - phdr[i].p_paddr)
> +#ifdef __x86_64__
> +                        && (phdr[i].p_vaddr != VSYSCALL_START)
> +#endif
> +                       )

Hmm, static inline bool is_vsyscall_segment(const Elf_Phdr *) maybe?

> +/* LGUEST_TOP_ADDRESS comes from the Makefile */
> +typedef uint64_t u64;
> +#include "../../../include/asm/lguest_user.h"
> +
> +#define RESERVE_TOP_ADDRESS LGUEST_GUEST_TOP
> +
> +
> +#define BOOT_PGTABLE "boot_level4_pgt"

The comment should refer to LGUEST_GUEST_TOP?

I think the typedef should be in the main code with the others: it
doesn't hurt i386 and it's neater.

I'm not sure the BOOT_PGTABLE define helps us here, either; it might be
clearer just to put it directly into the code.

Cheers!
Rusty.



