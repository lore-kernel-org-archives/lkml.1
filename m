Return-Path: <linux-kernel-owner+w=401wt.eu-S1762853AbYB0XwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762853AbYB0XwT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 18:52:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755648AbYB0XwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 18:52:10 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:10760 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755337AbYB0XwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 18:52:08 -0500
Date: Wed, 27 Feb 2008 15:50:33 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrea Arcangeli <andrea@qumranet.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH] reserve RAM below PHYSICAL_START
Message-Id: <20080227155033.e1fef26b.randy.dunlap@oracle.com>
In-Reply-To: <20080227003325.GS28483@v2.random>
References: <20080227003325.GS28483@v2.random>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Feb 2008 01:33:25 +0100 Andrea Arcangeli wrote:

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
> 
> Let me know if this can be merged, thanks!
> 
> 
> Signed-off-by: Andrea Arcangeli <andrea@qumranet.com>
> 
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
> +	  This makes the kernel use only RAM above __PHYSICAL_START.
> +	  All memory below __PHYSICAL_START will be left unused and
> +	  marked as "reserved RAM" in /proc/iomem. The few special
> +	  pages that can't be relocated at addresses above
> +	  __PHYSICAL_START and that can't be guaranteed to be unused
> +	  by the running kernel, will be marked "reserved RAM failed"

No comma.

> +	  in /proc/iomem. Those may or may be not used by the kernel
> +	  (for example smp trampoline pages would only be used if

                       SMP

> +	  CPU hotplug is enabled).
> +
> +          The "reserved RAM" can be mapped by virtualization software

Indent above with tab + 2 spaces, please.

> +	  with /dev/mem to create a 1:1 mapping between guest physical
> +	  (bus) address and host physical (bus) address. This will
> +	  allow pci passthrough with DMA for the guest using the ram

                PCI                                              RAM

> +	  with the 1:1 mapping. The only detail to take care of is the
> +	  ram marked "reserved RAM failed". The virtualization

          RAM

> +	  software must create for the guest an e820 map that only
> +	  includes the "reserved RAM" regions but if the guest touches
> +	  memory with guest physical address in the "reserved RAM
> +	  failed" ranges (linux guest will do that even if the ram

                          Linux                                RAM

> +	  isn't present in the e820 map), it should provide that as
> +	  ram and map it with a non linear mapping. This should allow

          RAM                   non-linear

> +	  any linux kernel to run fine and hopefully any other OS too.

              Linux

> +
>  config PHYSICAL_START
> -	hex "Physical address where the kernel is loaded" if (EMBEDDED || CRASH_DUMP)
> +	hex "Physical address where the kernel is loaded" if (EMBEDDED || CRASH_DUMP || RESERVE_PHYSICAL_START)
>  	default "0x1000000" if X86_NUMAQ
>  	default "0x200000" if X86_64
>  	default "0x100000"


---
~Randy
