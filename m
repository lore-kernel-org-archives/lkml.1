Return-Path: <linux-kernel-owner+w=401wt.eu-S933000AbZGPSUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933000AbZGPSUn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 14:20:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932964AbZGPSUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 14:20:43 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:50628 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932614AbZGPSUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 14:20:42 -0400
Date: Thu, 16 Jul 2009 14:20:13 -0400 (EDT)
From: Tim Abbott <tabbott@ksplice.com>
X-X-Sender: tabbott@vinegar-pot.mit.edu
To: Sam Ravnborg <sam@ravnborg.org>
cc: linux-kernel@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
       David Howells <dhowells@redhat.com>,
       Anders Kaseorg <andersk@ksplice.com>
Subject: Re: [PATCH] Restructure BSS linker script macros.
In-Reply-To: <alpine.DEB.1.10.0907121820360.23364@vinegar-pot.mit.edu>
Message-ID: <alpine.DEB.1.10.0907151750020.16617@vinegar-pot.mit.edu>
References: <alpine.DEB.1.10.0907121820360.23364@vinegar-pot.mit.edu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam, David,

Have you had a chance to look at this patch yet?  The lost ALIGN(4) in the 
mn10300 linker script that this fixes is a regression introduced by commit 
2e8b5a09ebf1f98f02c1988a48415e89d4c25168 (between 2.6.30 and 2.6.31-rc1) 
that we probably want to fix for 2.6.31.  (That should be the only 
functional effect of this patch.)

	-Tim Abbott

On Sun, 12 Jul 2009, Tim Abbott wrote:

> The BSS section macros in vmlinux.lds.h currently place the .sbss
> input section outside the bounds of [__bss_start, __bss_end].  On all
> architectures except for microblaze that handle both .sbss and
> __bss_start/__bss_end, this is wrong: the .sbss input section is
> within the range [__bss_start, __bss_end].  Relatedly, the example
> code at the top of the file actually has __bss_start/__bss_end defined
> twice; I believe the right fix here is to define them in the
> BSS_SECTION macro but not in the BSS macro.
> 
> Another problem with the current macros is that several
> architectures have an ALIGN(4) or some other small number just before
> __bss_stop in their linker scripts.  The BSS_SECTION macro currently
> hardcodes this to 4; while it should really be an argument.  It also
> ignores its sbss_align argument; fix that.
> 
> mn10300 is the only user at present of any of the macros touched by
> this patch.  It looks like mn10300 actually was incorrectly converted
> to use the new BSS() macro (the alignment of 4 prior to conversion was
> a __bss_stop alignment, but the argument to the BSS macro is a start
> alignment).  So fix this as well.
> 
> I'd like acks from Sam and David on this one.  Also CCing Paul, since
> he has a patch from me which will need to be updated to use
> BSS_SECTION(0, PAGE_SIZE, 4) once this gets merged.
> 
> Signed-off-by: Tim Abbott <tabbott@ksplice.com>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Cc: Paul Mundt <lethal@linux-sh.org>
> Cc: David Howells <dhowells@redhat.com>
> ---
>  arch/mn10300/kernel/vmlinux.lds.S |    2 +-
>  include/asm-generic/vmlinux.lds.h |   19 +++++++++----------
>  2 files changed, 10 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/mn10300/kernel/vmlinux.lds.S b/arch/mn10300/kernel/vmlinux.lds.S
> index c96ba3d..f4aa079 100644
> --- a/arch/mn10300/kernel/vmlinux.lds.S
> +++ b/arch/mn10300/kernel/vmlinux.lds.S
> @@ -107,7 +107,7 @@ SECTIONS
>    __init_end = .;
>    /* freed after init ends here */
>  
> -  BSS(4)
> +  BSS_SECTION(0, PAGE_SIZE, 4)
>  
>    _end = . ;
>  
> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> index a553f10..6ad76bf 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -30,9 +30,7 @@
>   *	EXCEPTION_TABLE(...)
>   *	NOTES
>   *
> - *	__bss_start = .;
> - *	BSS_SECTION(0, 0)
> - *	__bss_stop = .;
> + *	BSS_SECTION(0, 0, 0)
>   *	_end = .;
>   *
>   *	/DISCARD/ : {
> @@ -489,7 +487,8 @@
>   * bss (Block Started by Symbol) - uninitialized data
>   * zeroed during startup
>   */
> -#define SBSS								\
> +#define SBSS(sbss_align)						\
> +	. = ALIGN(sbss_align);						\
>  	.sbss : AT(ADDR(.sbss) - LOAD_OFFSET) {				\
>  		*(.sbss)						\
>  		*(.scommon)						\
> @@ -498,12 +497,10 @@
>  #define BSS(bss_align)							\
>  	. = ALIGN(bss_align);						\
>  	.bss : AT(ADDR(.bss) - LOAD_OFFSET) {				\
> -		VMLINUX_SYMBOL(__bss_start) = .;			\
>  		*(.bss.page_aligned)					\
>  		*(.dynbss)						\
>  		*(.bss)							\
>  		*(COMMON)						\
> -		VMLINUX_SYMBOL(__bss_stop) = .;				\
>  	}
>  
>  /*
> @@ -735,8 +732,10 @@
>  		INIT_RAM_FS						\
>  	}
>  
> -#define BSS_SECTION(sbss_align, bss_align)				\
> -	SBSS								\
> +#define BSS_SECTION(sbss_align, bss_align, stop_align)			\
> +	. = ALIGN(sbss_align);						\
> +	VMLINUX_SYMBOL(__bss_start) = .;				\
> +	SBSS(sbss_align)						\
>  	BSS(bss_align)							\
> -	. = ALIGN(4);
> -
> +	. = ALIGN(stop_align);						\
> +	VMLINUX_SYMBOL(__bss_stop) = .;
> -- 
> 1.6.3.3
> 
