Return-Path: <linux-kernel-owner+w=401wt.eu-S1754684AbZG0Uo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684AbZG0Uo2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 16:44:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754595AbZG0Uo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 16:44:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:58727 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583AbZG0Uo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 16:44:27 -0400
Date: Mon, 27 Jul 2009 16:44:24 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: John Reiser <jreiser@bitwagon.com>
cc: Steven Rostedt <srostedt@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Sam Ravnborg <sam@ravnborg.org>, Tejun Heo <tj@kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: ftrace: __start_mcount_loc should be .init.rodata
In-Reply-To: <4A6DF0B6.7080402@bitwagon.com>
Message-ID: <alpine.DEB.2.00.0907271641260.30108@gandalf.stny.rr.com>
References: <4A6DF0B6.7080402@bitwagon.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




On Mon, 27 Jul 2009, John Reiser wrote:

> __start_mcount_loc[] is unused after init, yet occupies RAM forever
> as part of .rodata.  152kiB is typical on a 64-bit architecture.  Instead,
> __start_mcount_loc should be in the interval [__init_begin, __init_end)
> so that the space is reclaimed after init.

Are you sure about that?

> 
> __start_mcount_loc[] is generated during the load portion
> of kernel build, and is used only by ftrace_init().  ftrace_init is declared
> '__init' and is in .init.text, which is freed after init.
> __start_mcount_loc is placed into .rodata by a call to MCOUNT_REC inside
> the RO_DATA macro of include/asm-generic/vmlinux.lds.h.  The array *is*
> read-only, but more importantly it is not used after init.  So the call to
> MCOUNT_REC should be moved from RO_DATA to INIT_DATA.
> 
> This patch has been tested on x86_64 with CONFIG_DEBUG_PAGEALLOC=y
> which verifies that the address range never is accessed after init.
> 
> [Please cc: me if replying only to the linux-kernel list.]
> 
> Signed off by: John Reiser <jreiser@BitWagon.com>
> 
> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> index 6ad76bf..98b37cf 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -91,7 +91,8 @@
>  #endif
> 
>  #ifdef CONFIG_FTRACE_MCOUNT_RECORD
> -#define MCOUNT_REC()	VMLINUX_SYMBOL(__start_mcount_loc) = .; \
> +#define MCOUNT_REC()	. = ALIGN(8);				\
> +			VMLINUX_SYMBOL(__start_mcount_loc) = .; \
>  			*(__mcount_loc)				\
>  			VMLINUX_SYMBOL(__stop_mcount_loc) = .;
>  #else
> @@ -331,7 +332,6 @@
>  	/* __*init sections */						\
>  	__init_rodata : AT(ADDR(__init_rodata) - LOAD_OFFSET) {		\

Isn't this in __init_rodata? Doesn't this get removed too?

I may be confused by all the uses of "init" in this file.

-- Steve


>  		*(.ref.rodata)						\
> -		MCOUNT_REC()						\
>  		DEV_KEEP(init.rodata)					\
>  		DEV_KEEP(exit.rodata)					\
>  		CPU_KEEP(init.rodata)					\
> @@ -455,6 +455,7 @@
>  	MEM_DISCARD(init.data)						\
>  	KERNEL_CTORS()							\
>  	*(.init.rodata)							\
> +	MCOUNT_REC()							\
>  	DEV_DISCARD(init.rodata)					\
>  	CPU_DISCARD(init.rodata)					\
>  	MEM_DISCARD(init.rodata)
> 
> -- 
> 
> 
