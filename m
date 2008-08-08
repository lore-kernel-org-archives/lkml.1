Return-Path: <linux-kernel-owner+w=401wt.eu-S1756730AbYHHOKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730AbYHHOKq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 10:10:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753483AbYHHOKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 10:10:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46276 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751720AbYHHOKh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 10:10:37 -0400
Date: Fri, 8 Aug 2008 10:09:38 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Huang Ying <ying.huang@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH -v2 3/8] kexec jump: check code size in control page
Message-ID: <20080808140938.GE3840@redhat.com>
References: <1218178356.22039.76.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1218178356.22039.76.camel@caritas-dev.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2008 at 02:52:36PM +0800, Huang Ying wrote:
> Kexec/Kexec-jump require code size in control page is less than
> PAGE_SIZE/2. This patch add link-time checking for this.
> 
> ASSERT() of ld link script is used as the link-time checking
> mechanism.
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> 
> ---
>  arch/x86/kernel/machine_kexec_32.c     |    2 +-
>  arch/x86/kernel/relocate_kernel_32.S   |   10 +++++++---
>  arch/x86/kernel/vmlinux_32.lds.S       |    2 ++
>  arch/x86/kernel/vmlinux_check_32.lds.S |    7 +++++++
>  include/asm-x86/kexec.h                |    4 ++++
>  5 files changed, 21 insertions(+), 4 deletions(-)
> 
> --- a/arch/x86/kernel/machine_kexec_32.c
> +++ b/arch/x86/kernel/machine_kexec_32.c
> @@ -138,7 +138,7 @@ void machine_kexec(struct kimage *image)
>  	}
>  
>  	control_page = page_address(image->control_code_page);
> -	memcpy(control_page, relocate_kernel, PAGE_SIZE/2);
> +	memcpy(control_page, relocate_kernel, KEXEC_CONTROL_CODE_MAX_SIZE);
>  
>  	relocate_kernel_ptr = control_page;
>  	page_list[PA_CONTROL_PAGE] = __pa(control_page);
> --- a/arch/x86/kernel/relocate_kernel_32.S
> +++ b/arch/x86/kernel/relocate_kernel_32.S
> @@ -20,10 +20,11 @@
>  #define PAGE_ATTR (_PAGE_PRESENT | _PAGE_RW | _PAGE_ACCESSED | _PAGE_DIRTY)
>  #define PAE_PGD_ATTR (_PAGE_PRESENT)
>  
> -/* control_page + PAGE_SIZE/2 ~ control_page + PAGE_SIZE * 3/4 are
> - * used to save some data for jumping back
> +/* control_page + KEXEC_CONTROL_CODE_MAX_SIZE
> + * ~ control_page + PAGE_SIZE * 3/4 are used to save some data for
> + * jumping back
>   */

Hi Huang,

Above comment is not very clear. Can you please elaborate it. I thought
that PAGE_SIZE/2 is used for control code and rest half is shared between
kjump data and stack. What is PAGE_SIZE *3/4?


> -#define DATA(offset)		(PAGE_SIZE/2+(offset))
> +#define DATA(offset)		(KEXEC_CONTROL_CODE_MAX_SIZE+(offset))
>  
>  /* Minimal CPU state */
>  #define ESP			DATA(0x0)
> @@ -376,3 +377,6 @@ swap_pages:
>  	popl	%ebx
>  	popl	%ebp
>  	ret
> +
> +	.globl kexec_control_code_size
> +.set kexec_control_code_size, . - relocate_kernel
> --- a/include/asm-x86/kexec.h
> +++ b/include/asm-x86/kexec.h
> @@ -41,6 +41,10 @@
>  # define PAGES_NR		17
>  #endif
>  
> +#ifdef CONFIG_X86_32
> +# define KEXEC_CONTROL_CODE_MAX_SIZE	2048
> +#endif
> +
>  #ifndef __ASSEMBLY__
>  
>  #include <linux/string.h>
> --- a/arch/x86/kernel/vmlinux_32.lds.S
> +++ b/arch/x86/kernel/vmlinux_32.lds.S
> @@ -209,3 +209,5 @@ SECTIONS
>  
>    DWARF_DEBUG
>  }
> +
> +#include "vmlinux_check_32.lds.S"
> --- /dev/null
> +++ b/arch/x86/kernel/vmlinux_check_32.lds.S
> @@ -0,0 +1,7 @@
> +/*
> + * Link time checks
> + */
> +
> +#include <asm/kexec.h>
> +
> +ASSERT(kexec_control_code_size <= KEXEC_CONTROL_CODE_MAX_SIZE, "kexec control code size is too big")

Will it make sense to move it into vmlinux_32.lds.S itself? Creating a separate
file for a single check seems superfluous.

Thanks
Vivek
