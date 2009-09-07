Return-Path: <linux-kernel-owner+w=401wt.eu-S1758849AbZIGFZ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758849AbZIGFZ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 01:25:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753490AbZIGFZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 01:25:58 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:32914 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753284AbZIGFZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 01:25:57 -0400
Message-ID: <4AA49946.2000804@snapgear.com>
Date: Mon, 07 Sep 2009 15:25:26 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Tim Abbott <tabbott@ksplice.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, Greg Ungerer <gerg@uclinux.org>
Subject: Re: [PATCH] m68knommu: Clean up linker script using new linker script
 macros.
References: <1252293044-13102-1-git-send-email-tabbott@ksplice.com>
In-Reply-To: <1252293044-13102-1-git-send-email-tabbott@ksplice.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tim,

Tim Abbott wrote:
> Signed-off-by: Tim Abbott <tabbott@ksplice.com>
> Cc: Greg Ungerer <gerg@uclinux.org>
> ---
>  arch/m68knommu/kernel/vmlinux.lds.S |   37 +++++++---------------------------
>  1 files changed, 8 insertions(+), 29 deletions(-)
> 
> diff --git a/arch/m68knommu/kernel/vmlinux.lds.S b/arch/m68knommu/kernel/vmlinux.lds.S
> index b7fe505..979acb5 100644
> --- a/arch/m68knommu/kernel/vmlinux.lds.S
> +++ b/arch/m68knommu/kernel/vmlinux.lds.S
> @@ -8,6 +8,8 @@
>   */
>  
>  #include <asm-generic/vmlinux.lds.h>
> +#include <asm/page.h>
> +#include <asm/thread_info.h>
>  
>  #if defined(CONFIG_RAMKERNEL)
>  #define	RAM_START	CONFIG_KERNELBASE
> @@ -147,40 +149,17 @@ SECTIONS {
>  		. = ALIGN(4);
>  		_sdata = . ;
>  		DATA_DATA
> -		. = ALIGN(32);
> -		*(.data.cacheline_aligned)
> -		. = ALIGN(8192) ;
> -		*(.data.init_task)
> +		CACHELINE_ALIGNED_DATA(32)
> +		INIT_TASK_DATA(THREAD_SIZE)
>  		_edata = . ;
>  	} > DATA
>  
>  	.init : {
> -		. = ALIGN(4096);
> +		. = ALIGN(PAGE_SIZE);

This fails for me with:

   LD      vmlinux
/usr/local/bin/m68k-uclinux-ld:arch/m68knommu/kernel/vmlinux.lds:287: 
syntax error

due to PAGE_SIZE evaluating to:

   . = ALIGN((1UL << (12)));

The linker doesn't like the 'UL' suffix.

Regards
Greg



>  		__init_begin = .;
> -		_sinittext = .;
> -		INIT_TEXT
> -		_einittext = .;
> -		INIT_DATA
> -		. = ALIGN(16);
> -		__setup_start = .;
> -		*(.init.setup)
> -		__setup_end = .;
> -		__initcall_start = .;
> -		INITCALLS
> -		__initcall_end = .;
> -		__con_initcall_start = .;
> -		*(.con_initcall.init)
> -		__con_initcall_end = .;
> -		__security_initcall_start = .;
> -		*(.security_initcall.init)
> -		__security_initcall_end = .;
> -#ifdef CONFIG_BLK_DEV_INITRD
> -		. = ALIGN(4);
> -		__initramfs_start = .;
> -		*(.init.ramfs)
> -		__initramfs_end = .;
> -#endif
> -		. = ALIGN(4096);
> +		INIT_TEXT_SECTION(PAGE_SIZE)
> +		INIT_DATA_SECTION(16)
> +		. = ALIGN(PAGE_SIZE);
>  		__init_end = .;
>  	} > INIT
>  

-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
