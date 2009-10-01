Return-Path: <linux-kernel-owner+w=401wt.eu-S1752615AbZJAF4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615AbZJAF4d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 01:56:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751627AbZJAF4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 01:56:33 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:42915 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750714AbZJAF4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 01:56:32 -0400
Message-ID: <4AC44477.8000703@snapgear.com>
Date: Thu, 01 Oct 2009 15:56:07 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Tim Abbott <tabbott@ksplice.com>
CC: Greg Ungerer <gerg@uclinux.org>, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH v2 2/2] m68knommu: Clean up linker script using new linker
 script macros.
References: <1253638615-27009-1-git-send-email-tabbott@ksplice.com> <1253638615-27009-3-git-send-email-tabbott@ksplice.com>
In-Reply-To: <1253638615-27009-3-git-send-email-tabbott@ksplice.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tim,

Tim Abbott wrote:
> Signed-off-by: Tim Abbott <tabbott@ksplice.com>
> Cc: Greg Ungerer <gerg@uclinux.org>

This results in kernels that don't boot for me. I haven't done
any more debugging than to just try booting at this time.

Before this patch applied has:

vmlinux:     file format elf32-m68k

Sections:
Idx Name          Size      VMA       LMA       File off  Algn
   0 .text         00125ff0  40020000  40020000  00002000  2**4
                   CONTENTS, ALLOC, LOAD, READONLY, CODE
   1 .data         00012010  40145ff0  40145ff0  00127ff0  2**4
                   CONTENTS, ALLOC, LOAD, DATA
   2 .init         0000c000  40158000  40158000  0013a000  2**2
                   CONTENTS, ALLOC, LOAD, CODE
   3 .bss          0000a9ec  40164000  40164000  00146000  2**4
                   ALLOC
   4 .comment      00001c56  00000000  00000000  00146000  2**0
                   CONTENTS, READONLY


And after applied:

linux-2.6.x/vmlinux:     file format elf32-m68k

Sections:
Idx Name          Size      VMA       LMA       File off  Algn
   0 .text         00125ff0  40020000  40020000  00002000  2**4
                   CONTENTS, ALLOC, LOAD, READONLY, CODE
   1 .data         00012010  40145ff0  40145ff0  00127ff0  2**4
                   CONTENTS, ALLOC, LOAD, DATA
   2 .init.text    0000aaac  40158000  40158000  0013a000  2**2
                   CONTENTS, ALLOC, LOAD, READONLY, CODE
   3 .init.data    00000b5c  40162aac  40162aac  00144aac  2**2
                   CONTENTS, ALLOC, LOAD, DATA
   4 .init_end     000009f8  40163608  40163608  00145608  2**0
                   ALLOC
   5 .bss          0000a9ec  40164000  40164000  00145608  2**4
                   ALLOC
   6 .comment      00001c56  00000000  00000000  00145608  2**0
                   CONTENTS, READONLY

Does that look like what you would have expected?

I suspect the problem may lie in the binary conversion of this
elf file to a raw binary for booting. This uses objcopy with
"-O binary". The resulting binary files are different in size
with and without the patch by about 2582 bytes. Suspicious
me thinks.

Regards
Greg



> ---
>  arch/m68knommu/kernel/vmlinux.lds.S |   41 +++++++++-------------------------
>  1 files changed, 11 insertions(+), 30 deletions(-)
> 
> diff --git a/arch/m68knommu/kernel/vmlinux.lds.S b/arch/m68knommu/kernel/vmlinux.lds.S
> index 2736a5e..b236133 100644
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
> @@ -147,40 +149,19 @@ SECTIONS {
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
> -	.init : {
> -		. = ALIGN(4096);
> +	.init_begin : {
> +		. = ALIGN(PAGE_SIZE);
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
> +	} > INIT
> +	INIT_TEXT_SECTION(PAGE_SIZE) > INIT
> +	INIT_DATA_SECTION(16) > INIT
> +	.init_end : {
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
