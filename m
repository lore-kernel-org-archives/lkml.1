Return-Path: <linux-kernel-owner+w=401wt.eu-S1763083AbYAYHuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763083AbYAYHuQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:50:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761377AbYAYHfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:35:46 -0500
Received: from gw.goop.org ([64.81.55.164]:59174 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759998AbYAYHfm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:35:42 -0500
Message-ID: <4799914C.5060709@goop.org>
Date: Thu, 24 Jan 2008 23:35:40 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "Huang, Ying" <ying.huang@intel.com>
CC: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] x86: fix some bugs about EFI runtime code mapping
References: <1201240501.15972.46.camel@caritas-dev.intel.com>
In-Reply-To: <1201240501.15972.46.camel@caritas-dev.intel.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang, Ying wrote:
> This patch fixes some bugs of making EFI runtime code executable.
>
> - Use change_page_attr in i386 too. Because the runtime code may be
>   mapped not through ioremap.
>
> - If there is no _PAGE_NX in __supported_pte_mask, the change_page_attr
>   is not called.
>
> - Make efi_ioremap map pages as PAGE_KERNEL_EXEC, because EFI runtime
>   code may be mapped through efi_ioremap.
>
> Signed-off-by: Huang Ying <ying.huang@intel.com>
>
> ---
>  arch/x86/kernel/efi.c    |   35 ++++++++++++++++++++++++++++++-----
>  arch/x86/kernel/efi_64.c |   26 ++++++--------------------
>  include/asm-x86/efi.h    |    1 -
>  3 files changed, 36 insertions(+), 26 deletions(-)
>
> --- a/arch/x86/kernel/efi.c
> +++ b/arch/x86/kernel/efi.c
> @@ -40,6 +40,8 @@
>  #include <asm/setup.h>
>  #include <asm/efi.h>
>  #include <asm/time.h>
> +#include <asm/cacheflush.h>
> +#include <asm/tlbflush.h>
>  
>  #define EFI_DEBUG	1
>  #define PFX 		"EFI: "
> @@ -379,6 +381,32 @@ void __init efi_init(void)
>  #endif
>  }
>  
> +#if defined(CONFIG_X86_64) || defined(CONFIG_X86_PAE)
> +static void __init runtime_code_page_mkexec(void)
> +{
> +	efi_memory_desc_t *md;
> +	unsigned long end;
> +	void *p;
> +
> +	if (!(__supported_pte_mask & _PAGE_NX))
> +		return;
>   

On 32-bit non-PAE, _PAGE_NX == 0, so this if() statement should be 
sufficient to disable the whole function at compile time without needing 
the outer #if defined wrapper.

    J
