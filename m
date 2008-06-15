Return-Path: <linux-kernel-owner+w=401wt.eu-S1755852AbYFOXJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755852AbYFOXJ5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 19:09:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751428AbYFOXJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 19:09:47 -0400
Received: from ozlabs.org ([203.10.76.45]:58051 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699AbYFOXJq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 19:09:46 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18517.39513.867328.171299@cargo.ozlabs.ibm.com>
Date: Mon, 16 Jun 2008 08:40:25 +1000
From: Paul Mackerras <paulus@samba.org>
To: Andrea Righi <righi.andrea@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       balbir@linux.vnet.ibm.com, Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       yamamoto@valinux.co.jp, menage@google.com, linux-kernel@vger.kernel.org,
       xemul@openvz.org, kamezawa.hiroyu@jp.fujitsu.com,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH -mm] PAGE_ALIGN(): correctly handle 64-bit values on 32-bit architectures (v2)
In-Reply-To: <1213543436-15254-1-git-send-email-righi.andrea@gmail.com>
References: <1213543436-15254-1-git-send-email-righi.andrea@gmail.com>
X-Mailer: VM 7.19 under Emacs 22.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Righi writes:

> Also move the PAGE_ALIGN() definitions out of include/asm-*/page.h in
> include/linux/mm.h.

I'd rather see it in some other place than this, because
include/linux/mm.h is a large header that includes quite a lot of
other stuff.  What's wrong with leaving it in each arch's page.h and
only changing it on those archs that have both 32-bit and 64-bit
variants?  Or perhaps there is some other, lower-level header in
include/linux where it could go?

> diff --git a/arch/powerpc/boot/of.c b/arch/powerpc/boot/of.c
> index 61d9899..6bc72b1 100644
> --- a/arch/powerpc/boot/of.c
> +++ b/arch/powerpc/boot/of.c
> @@ -8,6 +8,7 @@
>   */
>  #include <stdarg.h>
>  #include <stddef.h>
> +#include <linux/mm.h>
>  #include "types.h"
>  #include "elf.h"
>  #include "string.h"
> diff --git a/arch/powerpc/boot/page.h b/arch/powerpc/boot/page.h
> index 14eca30..aa42298 100644
> --- a/arch/powerpc/boot/page.h
> +++ b/arch/powerpc/boot/page.h
> @@ -28,7 +28,4 @@
>  /* align addr on a size boundary - adjust address up if needed */
>  #define _ALIGN(addr,size)     _ALIGN_UP(addr,size)
>  
> -/* to align the pointer to the (next) page boundary */
> -#define PAGE_ALIGN(addr)	_ALIGN(addr, PAGE_SIZE)
> -
>  #endif				/* _PPC_BOOT_PAGE_H */

These parts are NAKed, because arch/powerpc/boot is a separate program
that doesn't use the kernel include files.

> diff --git a/include/asm-powerpc/page.h b/include/asm-powerpc/page.h
> index cffdf0e..e088545 100644
> --- a/include/asm-powerpc/page.h
> +++ b/include/asm-powerpc/page.h
> @@ -119,9 +119,6 @@ extern phys_addr_t kernstart_addr;
>  /* align addr on a size boundary - adjust address up if needed */
>  #define _ALIGN(addr,size)     _ALIGN_UP(addr,size)
>  
> -/* to align the pointer to the (next) page boundary */
> -#define PAGE_ALIGN(addr)	_ALIGN(addr, PAGE_SIZE)
> -
>  /*
>   * Don't compare things with KERNELBASE or PAGE_OFFSET to test for
>   * "kernelness", use is_kernel_addr() - it should do what you want.

We had already come across this issue on powerpc, and we fixed it by
making sure that the type of PAGE_MASK was int, not unsigned int.
However, I have no objection to using the ALIGN() macro from
include/linux/kernel.h instead.

Paul.
