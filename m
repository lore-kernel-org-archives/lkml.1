Return-Path: <linux-kernel-owner+w=401wt.eu-S1765255AbXE2SyK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765255AbXE2SyK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 14:54:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764865AbXE2Sxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 14:53:41 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:42265 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764814AbXE2Sxj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 14:53:39 -0400
Date: Tue, 29 May 2007 20:54:38 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [patch 1/6] Use EXTRA_RWDATA in architectures
Message-ID: <20070529185438.GB5846@uranus.ravnborg.org>
References: <20070529183725.179570071@polymtl.ca> <20070529183758.910835109@polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070529183758.910835109@polymtl.ca>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mathieu
> Adds a place to declare rw data that will not be far from the .data content,
> therefore limiting the impact on cache of data declared in sections part of the
> EXTRA_RWDATA.

No comments on the aim of the path - but a few implementation comments.

I'm glad to see asm-generic/vmlinux.lds.h used - thanks.
The general naming is USAGE_{DATA|TEXT}
To keep with this albait vague then established naming scheme
please consider using: EXTRARW_DATA


> Index: linux-2.6-lttng/arch/h8300/kernel/vmlinux.lds.S
> ===================================================================
> --- linux-2.6-lttng.orig/arch/h8300/kernel/vmlinux.lds.S	2007-05-15 18:41:05.000000000 -0400
> +++ linux-2.6-lttng/arch/h8300/kernel/vmlinux.lds.S	2007-05-15 18:44:20.000000000 -0400
> @@ -105,7 +105,9 @@
>  	. = ALIGN(0x4) ;
>  		*(.data)
>  	. = ALIGN(0x4) ;
> -		*(.data.*)	
> +		*(.data.*)
> +	. = ALIGN(0x4) ;
> +	EXTRA_RWDATA

The usage of ALIGN seems a bit arbitary. If there is a requirement to align
data for EXTRA_RWDATA usage then pass alignment requirment as parameter or do
alignment in the define.


> Index: linux-2.6-lttng/arch/ia64/kernel/vmlinux.lds.S
> ===================================================================
> --- linux-2.6-lttng.orig/arch/ia64/kernel/vmlinux.lds.S	2007-05-15 18:41:05.000000000 -0400
> +++ linux-2.6-lttng/arch/ia64/kernel/vmlinux.lds.S	2007-05-15 18:44:20.000000000 -0400
> @@ -214,7 +214,7 @@
>  
>    data : { } :data
>    .data : AT(ADDR(.data) - LOAD_OFFSET)
> -	{ *(.data) *(.data1) *(.gnu.linkonce.d*) CONSTRUCTORS }
> +	{ *(.data) *(.data1) *(.gnu.linkonce.d*) EXTRA_RWDATA CONSTRUCTORS }
>  
Try to think of linker scripts a C-files.
In C you would never do like this:

-	int i; struct type foo;
+	int i; struct type foo; struct type2 bar;

You would certainly place the new variable on a new line and maybe
fix the bad code-style in another patch.
My point is that you should not continue the bad-taste style used here
but just add EXTRA_RWDATA on a single line.

If no-one beats me I plan to go through all linker scrip files and add
some sanity with respect to indent style etc. so they start to follow
C-style for indent.


> Index: linux-2.6-lttng/arch/xtensa/kernel/vmlinux.lds.S
> ===================================================================
> --- linux-2.6-lttng.orig/arch/xtensa/kernel/vmlinux.lds.S	2007-05-15 18:41:05.000000000 -0400
> +++ linux-2.6-lttng/arch/xtensa/kernel/vmlinux.lds.S	2007-05-15 18:44:20.000000000 -0400
> @@ -144,7 +144,7 @@
>    _fdata = .;
>    .data :
>    {
> -    *(.data) CONSTRUCTORS
> +    *(.data) EXTRA_RWDATA CONSTRUCTORS
>      . = ALIGN(XCHAL_ICACHE_LINESIZE);
>      *(.data.cacheline_aligned)

again..
>    }
> Index: linux-2.6-lttng/include/asm-generic/vmlinux.lds.h
> ===================================================================
> --- linux-2.6-lttng.orig/include/asm-generic/vmlinux.lds.h	2007-05-15 18:44:11.000000000 -0400
> +++ linux-2.6-lttng/include/asm-generic/vmlinux.lds.h	2007-05-15 18:44:20.000000000 -0400
> @@ -143,6 +143,8 @@
>  									\
>  	. = ALIGN(4096);
>  
> +#define EXTRA_RWDATA
> +
Please add comment that describe the purpose of EXTRA_RWDATA - verbatim
copy from changlog is almost enough.

	Sam
