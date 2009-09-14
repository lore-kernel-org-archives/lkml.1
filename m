Return-Path: <linux-kernel-owner+w=401wt.eu-S1755288AbZINI7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288AbZINI7k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 04:59:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755129AbZINI7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 04:59:39 -0400
Received: from miranda.se.axis.com ([193.13.178.8]:51258 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754828AbZINI7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 04:59:38 -0400
Date: Mon, 14 Sep 2009 10:59:22 +0200
From: Jesper Nilsson <Jesper.Nilsson@axis.com>
To: Tim Abbott <tabbott@ksplice.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       dev-etrax <dev-etrax@axis.com>
Subject: Re: [PATCH] cris: Cleanup linker script using new linker script
	macros.
Message-ID: <20090914085922.GG4592@axis.com>
References: <1252292793-12674-1-git-send-email-tabbott@ksplice.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252292793-12674-1-git-send-email-tabbott@ksplice.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 07, 2009 at 05:06:33AM +0200, Tim Abbott wrote:
> Signed-off-by: Tim Abbott <tabbott@ksplice.com>
> Cc: Mikael Starvik <starvik@axis.com>
> Cc: Jesper Nilsson <jesper.nilsson@axis.com>
> Cc: dev-etrax@axis.com
> ---
>  arch/cris/kernel/vmlinux.lds.S |   41 +++++++--------------------------------
>  1 files changed, 8 insertions(+), 33 deletions(-)
> 
> diff --git a/arch/cris/kernel/vmlinux.lds.S b/arch/cris/kernel/vmlinux.lds.S
> index 0d2adfc..bb44ae5 100644
> --- a/arch/cris/kernel/vmlinux.lds.S
> +++ b/arch/cris/kernel/vmlinux.lds.S
> @@ -51,61 +51,40 @@ SECTIONS
>  	_etext = . ;			/* End of text section. */
>  	__etext = .;
>  
> -	. = ALIGN(4);			/* Exception table. */
> -	__start___ex_table = .;
> -	__ex_table : { *(__ex_table) }
> -	__stop___ex_table = .;
> +	EXCEPTION_TABLE(4)
>  
>  	RODATA
>  
>  	. = ALIGN (4);
>  	___data_start = . ;
>  	__Sdata = . ;
> -	.data : {			/* Data */
> -		DATA_DATA
> -	}
> +	RW_DATA_SECTION(0, PAGE_SIZE, PAGE_SIZE)

This causes some problems, and I'm not ldscript guru enough to immediately
grasp the problem. What I get is this:

...
  LD      vmlinux
arch/cris/kernel/vmlinux.lds:326 cannot move location counter backwards (from c017e000 to 00000000)
make[1]: *** [vmlinux] Error 1
make: *** [sub-make] Error 2

I've dropped that part of the patch, and I'll try to
boot test the rest of the patch this week.

>  	__edata = . ;			/* End of data section. */
>  	_edata = . ;
>  
> -	. = ALIGN(PAGE_SIZE);	/* init_task and stack, must be aligned. */
> -	.data.init_task : { *(.data.init_task) }
> -
>  	. = ALIGN(PAGE_SIZE);		/* Init code and data. */
>  	__init_begin = .;
> -	.init.text : {
> -		   _sinittext = .;
> -		   INIT_TEXT
> -		   _einittext = .;
> -	}
> +	INIT_TEXT_SECTION(PAGE_SIZE)
>  	.init.data : { INIT_DATA }
> -	. = ALIGN(16);
> -	__setup_start = .;
> -	.init.setup : { *(.init.setup) }
> -	__setup_end = .;
> +	.init.setup : { INIT_SETUP(16) }
>  #ifdef CONFIG_ETRAX_ARCH_V32
>  	__start___param = .;
>  	__param : { *(__param) }
>  	__stop___param = .;
>  #endif
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
>  	SECURITY_INIT
>  
>  #ifdef CONFIG_ETRAX_ARCH_V10
>  #ifdef CONFIG_BLK_DEV_INITRD
>  	.init.ramfs : {
> -		__initramfs_start = .;
> -		*(.init.ramfs)
> -		__initramfs_end = .;
> +		INIT_RAM_FS
>  	}
>  #endif
>  #endif
> @@ -130,11 +109,7 @@ SECTIONS
>  	__init_end = .;
>  
>  	__data_end = . ;		/* Move to _edata ? */
> -	__bss_start = .;		/* BSS. */
> -	.bss : {
> -		*(COMMON)
> -		*(.bss)
> -	}
> +	BSS_SECTION(0, 0, 0)
>  
>  	. =  ALIGN (0x20);
>  	_end = .;
> -- 
> 1.6.3.3

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
