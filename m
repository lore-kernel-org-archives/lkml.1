Return-Path: <linux-kernel-owner+w=401wt.eu-S1755148AbYE2DI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148AbYE2DI4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 23:08:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752493AbYE2DIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 23:08:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41599 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751710AbYE2DIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 23:08:44 -0400
Date: Wed, 28 May 2008 20:08:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@samba.org>, Paul Mundt <lethal@linux-sh.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 1/3] make page-aligned data and bss less fragile
Message-Id: <20080528200800.3af52ca6.akpm@linux-foundation.org>
In-Reply-To: <483D8292.40808@goop.org>
References: <483D8292.40808@goop.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 May 2008 17:04:34 +0100 Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Making a variable page-aligned by using
> __attribute__((section(".data.page_aligned"))) is fragile because if
> sizeof(variable) is not also a multiple of page size, it leaves
> variables in the remainder of the section unaligned.
> 
> This patch introduces two new qualifiers, __page_aligned_data and
> __page_aligned_bss to set the section *and* the alignment of
> variables.  This makes page-aligned variables more robust because the
> linker will make sure they're aligned properly.  Unfortunately it
> requires *all* page-aligned data to use these macros...
> 
> It also updates arch/x86's use of page-aligned variables, since its
> the heaviest user of them in the kernel.  The change to
> arch/x86/xen/mmu.c fixes an actual bug, but the rest are cleanups
> and to set a precident.
> 
> [ I don't know if this would be easier to manage by splitting the
>   x86 part out from the common part. Two following patches apply to
>   powerpc and sh; they're purely decorative. ]

If the arch people like these patches then we could merge this bit:

> --- a/include/linux/linkage.h
> +++ b/include/linux/linkage.h
> @@ -1,6 +1,7 @@
>  #ifndef _LINUX_LINKAGE_H
>  #define _LINUX_LINKAGE_H
>  
> +#include <linux/compiler.h>
>  #include <asm/linkage.h>
>  
>  #define notrace __attribute__((no_instrument_function))
> @@ -18,6 +19,13 @@
>  #ifndef asmregparm
>  # define asmregparm
>  #endif
> +
> +/*
> + * Mark a variable page aligned, and put it in an appropriate page
> + * aligned section.
> + */
> +#define __page_aligned_data	__section(.data.page_aligned) __aligned(PAGE_SIZE)
> +#define __page_aligned_bss	__section(.bss.page_aligned) __aligned(PAGE_SIZE)
>  
>  /*
>   * This is used by architectures to keep arguments on the stack
> 

Into mainline now, so we can trickle the other three patches into the
architecture trees.
