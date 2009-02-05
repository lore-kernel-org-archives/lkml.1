Return-Path: <linux-kernel-owner+w=401wt.eu-S1759127AbZBEAct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759127AbZBEAct (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 19:32:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754383AbZBEAcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 19:32:39 -0500
Received: from gate.crashing.org ([63.228.1.57]:60479 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753957AbZBEAci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 19:32:38 -0500
Subject: Re: [PATCH 2/3] powerpc: Make it possible to safely select
 CONFIG_FRAME_POINTER
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Steven Rostedt <srostedt@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
In-Reply-To: <20090204150838.GB30027@oksana.dev.rtsoft.ru>
References: <20090204150755.GA24163@oksana.dev.rtsoft.ru>
	 <20090204150838.GB30027@oksana.dev.rtsoft.ru>
Content-Type: text/plain
Date: Thu, 05 Feb 2009 11:31:29 +1100
Message-Id: <1233793889.4612.33.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-02-04 at 18:08 +0300, Anton Vorontsov wrote:
> Remove -fno-omit-frame-pointer flag from CFLAGS.
> Remove -fno-omit-frame-pointer workarounds.

But what about -pg -requires -fno-omit-frame-pointer ?

Ben.

> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> ---
>  arch/powerpc/Makefile                    |   10 ++++++----
>  arch/powerpc/kernel/Makefile             |   10 +++++-----
>  arch/powerpc/platforms/powermac/Makefile |    2 +-
>  lib/Kconfig.debug                        |    8 ++++----
>  4 files changed, 16 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/powerpc/Makefile b/arch/powerpc/Makefile
> index 72d17f5..627aa7f 100644
> --- a/arch/powerpc/Makefile
> +++ b/arch/powerpc/Makefile
> @@ -120,10 +120,12 @@ ifeq ($(CONFIG_6xx),y)
>  KBUILD_CFLAGS		+= -mcpu=powerpc
>  endif
>  
> -# Work around a gcc code-gen bug with -fno-omit-frame-pointer.
> -ifeq ($(CONFIG_FUNCTION_TRACER),y)
> -KBUILD_CFLAGS		+= -mno-sched-epilog
> -endif
> +# Remove -fno-omit-frame-pointer flag. There are two reasons:
> +# 1. On powerpc we always have frame pointers.
> +# 2. Some gcc versions might generate wrong code with -fno-omit-frame-pointer
> +#    flag. So, if for some reason you're going to remove this line, then add
> +#    -mno-sched-epilog to workaround the gcc bug.
> +KBUILD_CFLAGS := $(subst -fno-omit-frame-pointer,,$(KBUILD_CFLAGS))
>  
>  cpu-as-$(CONFIG_4xx)		+= -Wa,-m405
>  cpu-as-$(CONFIG_6xx)		+= -Wa,-maltivec
> diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
> index 8d1a419..a97f215 100644
> --- a/arch/powerpc/kernel/Makefile
> +++ b/arch/powerpc/kernel/Makefile
> @@ -14,14 +14,14 @@ endif
>  
>  ifdef CONFIG_FUNCTION_TRACER
>  # Do not trace early boot code
> -CFLAGS_REMOVE_cputable.o = -pg -mno-sched-epilog
> -CFLAGS_REMOVE_prom_init.o = -pg -mno-sched-epilog
> -CFLAGS_REMOVE_btext.o = -pg -mno-sched-epilog
> -CFLAGS_REMOVE_prom.o = -pg -mno-sched-epilog
> +CFLAGS_REMOVE_cputable.o = -pg
> +CFLAGS_REMOVE_prom_init.o = -pg
> +CFLAGS_REMOVE_btext.o = -pg
> +CFLAGS_REMOVE_prom.o = -pg
>  
>  ifdef CONFIG_DYNAMIC_FTRACE
>  # dynamic ftrace setup.
> -CFLAGS_REMOVE_ftrace.o = -pg -mno-sched-epilog
> +CFLAGS_REMOVE_ftrace.o = -pg
>  endif
>  
>  endif
> diff --git a/arch/powerpc/platforms/powermac/Makefile b/arch/powerpc/platforms/powermac/Makefile
> index 50f1693..0eb8781 100644
> --- a/arch/powerpc/platforms/powermac/Makefile
> +++ b/arch/powerpc/platforms/powermac/Makefile
> @@ -2,7 +2,7 @@ CFLAGS_bootx_init.o  		+= -fPIC
>  
>  ifdef CONFIG_FUNCTION_TRACER
>  # Do not trace early boot code
> -CFLAGS_REMOVE_bootx_init.o = -pg -mno-sched-epilog
> +CFLAGS_REMOVE_bootx_init.o = -pg
>  endif
>  
>  obj-y				+= pic.o setup.o time.o feature.o pci.o \
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 29044f5..657126c 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -402,7 +402,7 @@ config LOCKDEP
>  	bool
>  	depends on DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT
>  	select STACKTRACE
> -	select FRAME_POINTER if !X86 && !MIPS && !PPC
> +	select FRAME_POINTER if !X86 && !MIPS
>  	select KALLSYMS
>  	select KALLSYMS_ALL
>  
> @@ -583,7 +583,7 @@ config FRAME_POINTER
>  	bool "Compile the kernel with frame pointers"
>  	depends on DEBUG_KERNEL && \
>  		(CRIS || M68K || M68KNOMMU || FRV || UML || S390 || \
> -		 AVR32 || SUPERH || BLACKFIN || MN10300) || \
> +		 AVR32 || SUPERH || BLACKFIN || MN10300 || PPC) || \
>  		ARCH_WANT_FRAME_POINTERS
>  	default y if (DEBUG_INFO && UML) || ARCH_WANT_FRAME_POINTERS
>  	help
> @@ -771,13 +771,13 @@ config FAULT_INJECTION_STACKTRACE_FILTER
>  	depends on FAULT_INJECTION_DEBUG_FS && STACKTRACE_SUPPORT
>  	depends on !X86_64
>  	select STACKTRACE
> -	select FRAME_POINTER if !PPC
> +	select FRAME_POINTER
>  	help
>  	  Provide stacktrace filter for fault-injection capabilities
>  
>  config LATENCYTOP
>  	bool "Latency measuring infrastructure"
> -	select FRAME_POINTER if !MIPS && !PPC
> +	select FRAME_POINTER if !MIPS
>  	select KALLSYMS
>  	select KALLSYMS_ALL
>  	select STACKTRACE

