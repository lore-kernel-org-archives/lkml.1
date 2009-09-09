Return-Path: <linux-kernel-owner+w=401wt.eu-S1753473AbZIIRJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473AbZIIRJ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 13:09:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753178AbZIIRJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 13:09:25 -0400
Received: from mail-px0-f194.google.com ([209.85.216.194]:61512 "EHLO
	mail-px0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919AbZIIRJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 13:09:25 -0400
X-Greylist: delayed 327 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Sep 2009 13:09:25 EDT
Message-ID: <4AA7DFF7.6010001@monstr.eu>
Date: Wed, 09 Sep 2009 19:03:51 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Tim Abbott <tabbott@ksplice.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, microblaze-uclinux@itee.uq.edu.au
Subject: Re: [PATCH] microblaze: Cleanup linker script using new linker script
 macros.
References: <1252293010-13038-1-git-send-email-tabbott@ksplice.com>
In-Reply-To: <1252293010-13038-1-git-send-email-tabbott@ksplice.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tim,

Tim Abbott wrote:
> I wasn't able to further clean up the linker script using the
> INIT_DATA_SECTION macro because of the FIXME comment for the
> .init.ramfs section; when that is resolved we should convert
> microblaze to use INIT_DATA_SECTION.
> 
> Signed-off-by: Tim Abbott <tabbott@ksplice.com>
> Cc: Michal Simek <monstr@monstr.eu>
> Cc: microblaze-uclinux@itee.uq.edu.au
> Cc: Sam Ravnborg <sam@ravnborg.org>

If you want to add this patch through microblaze tree, please let me know.

Tested-by: Michal Simek <monstr@monstr.eu>

Thanks,
Michal


> ---
>  arch/microblaze/kernel/vmlinux.lds.S |   39 +++++++---------------------------
>  1 files changed, 8 insertions(+), 31 deletions(-)
> 
> diff --git a/arch/microblaze/kernel/vmlinux.lds.S b/arch/microblaze/kernel/vmlinux.lds.S
> index d34d38d..5e95ee0 100644
> --- a/arch/microblaze/kernel/vmlinux.lds.S
> +++ b/arch/microblaze/kernel/vmlinux.lds.S
> @@ -13,6 +13,8 @@ OUTPUT_ARCH(microblaze)
>  ENTRY(_start)
>  
>  #include <asm-generic/vmlinux.lds.h>
> +#include <asm/page.h>
> +#include <asm/thread_info.h>
>  
>  jiffies = jiffies_64 + 4;
>  
> @@ -39,12 +41,7 @@ SECTIONS {
>  
>  	. = ALIGN(16);
>  	RODATA
> -	. = ALIGN(16);
> -	__ex_table : {
> -		__start___ex_table = .;
> -		*(__ex_table)
> -		__stop___ex_table = .;
> -	}
> +	EXCEPTION_TABLE(16)
>  
>  	/*
>  	 * sdata2 section can go anywhere, but must be word aligned
> @@ -61,12 +58,7 @@ SECTIONS {
>  	}
>  
>  	_sdata = . ;
> -	.data ALIGN (4096) : { /* page aligned when MMU used - origin 0x4 */
> -		DATA_DATA
> -		CONSTRUCTORS
> -	}
> -	. = ALIGN(32);
> -	.data.cacheline_aligned : { *(.data.cacheline_aligned) }
> +	RW_DATA_SECTION(32, PAGE_SIZE, THREAD_SIZE)
>  	_edata = . ;
>  
>  	/* Reserve some low RAM for r0 based memory references */
> @@ -74,10 +66,6 @@ SECTIONS {
>  	r0_ram = . ;
>  	. = . +  4096;	/* a page should be enough */
>  
> -	/* The initial task */
> -	. = ALIGN(8192);
> -	.data.init_task : { *(.data.init_task) }
> -
>  	/* Under the microblaze ABI, .sdata and .sbss must be contiguous */
>  	. = ALIGN(8);
>  	.sdata : {
> @@ -96,12 +84,7 @@ SECTIONS {
>  
>  	__init_begin = .;
>  
> -	. = ALIGN(4096);
> -	.init.text : {
> -		_sinittext = . ;
> -		INIT_TEXT
> -		_einittext = .;
> -	}
> +	INIT_TEXT_SECTION(PAGE_SIZE)
>  
>  	.init.data : {
>  		INIT_DATA
> @@ -115,21 +98,15 @@ SECTIONS {
>  	}
>  
>  	.init.setup : {
> -		__setup_start = .;
> -		*(.init.setup)
> -		__setup_end = .;
> +		INIT_SETUP(0)
>  	}
>  
>  	.initcall.init : {
> -		__initcall_start = .;
> -		INITCALLS
> -		__initcall_end = .;
> +		INIT_CALLS
>  	}
>  
>  	.con_initcall.init : {
> -		__con_initcall_start = .;
> -		*(.con_initcall.init)
> -		__con_initcall_end = .;
> +		CON_INITCALL
>  	}
>  
>  	SECURITY_INIT


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
