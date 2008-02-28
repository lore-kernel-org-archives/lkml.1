Return-Path: <linux-kernel-owner+w=401wt.eu-S1758496AbYB1ShU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758496AbYB1ShU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 13:37:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751932AbYB1ShI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 13:37:08 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43627 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751565AbYB1ShF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 13:37:05 -0500
Date: Thu, 28 Feb 2008 13:36:04 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: andrea@qumranet.com
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH] reserve RAM below PHYSICAL_START
Message-ID: <20080228183604.GA19901@redhat.com>
References: <20080227003325.GS28483@v2.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080227003325.GS28483@v2.random>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2008 at 01:33:25AM +0100, Andrea Arcangeli wrote:
> Hello,
> 
> this patch allows to prevent linux from using the ram below
> PHYSICAL_START.
> 
> The "reserved RAM" can be mapped by virtualization software with to
> create a 1:1 mapping between guest physical (bus) address and host
> physical (bus) address. This will allow pci passthrough with DMA for
> the guest with current production hardware that misses VT-d. The only
> detail to take care of is the ram marked "reserved RAM failed". The
> virtualization software must create for the guest an e820 map that
> only includes the "reserved RAM" regions but if the guest touches
> memory with guest physical address in the "reserved RAM failed" ranges
> (linux guest will do that even if the ram isn't present in the e820
> map), it should provide that as ram and map it with a not-ident
> mapping. This should allow any linux kernel to run fine with pci
> passthrough and hopefully any other OS too with all VT enabled
> hardware.
> 
> (the virtualization software should do if (pfn_valid(gfn))
> get_page(pfn_to_page(gfn)) instead of get_user_pages and equivalent
> check in the release path)
> 
> The trampoline page marked as "reserved RAM failed" can be easily
> relocated near 640k with an incremental patch to avoid an e820 hole at
> 0x6000 if any bootloader or OS gets confused.
> 
> The end of the patch are just bugfixes. However the limit of the
> reserved ram is 1G... this can also be relaxed with an incremental
> patch later on if needed (currently 1G is enough). Perhaps this has
> other usages.
> 
> Let me know if this can be merged, thanks!
> 

I don't know much about pci passthrough thing, but in a nutshell it
looks like you just want a way to reserve memory in host which is not
used by host and then also reserve a virtual range in host where you
can create another set of mapping for that reserved memory?

Can't you just provide a command line parameter to reserve a section
of memory, the way crashkernel=X@Y parameter does?
 
[..]
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1109,8 +1109,36 @@ config CRASH_DUMP
>  	  (CONFIG_RELOCATABLE=y).
>  	  For more details see Documentation/kdump/kdump.txt
>  
> +config RESERVE_PHYSICAL_START
> +	bool "Reserve all RAM below PHYSICAL_START (EXPERIMENTAL)"
> +	depends on !RELOCATABLE && X86_64
> +	help

What prevents you from doing this for RELOCATABLE kernels?

[..]
>  #ifndef __ASSEMBLY__
>  struct e820entry {
> diff --git a/include/asm-x86/page_64.h b/include/asm-x86/page_64.h
> --- a/include/asm-x86/page_64.h
> +++ b/include/asm-x86/page_64.h
> @@ -29,6 +29,7 @@
>  #define __PAGE_OFFSET           _AC(0xffff810000000000, UL)
>  
>  #define __PHYSICAL_START	CONFIG_PHYSICAL_START
> +#define __PHYSICAL_OFFSET	(__PHYSICAL_START-0x200000)
>  #define __KERNEL_ALIGN		0x200000
>  
>  /*
> @@ -47,7 +48,7 @@
>  #define __PHYSICAL_MASK_SHIFT	46
>  #define __VIRTUAL_MASK_SHIFT	48
>  
> -#define KERNEL_TEXT_SIZE  (40*1024*1024)
> +#define KERNEL_TEXT_SIZE  (40*1024*1024+__PHYSICAL_OFFSET)

Why are you changing this? What is __PHYSICAL_OFFSET? Are you expanding
the kernel text/data region so that you can additionally map this
reserved area? 

If yes, I think probably we should have a separate area altoghether to
map this reserved area than expanding existing kernel text/data region.

Thanks
Vivek
