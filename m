Return-Path: <linux-kernel-owner+w=401wt.eu-S1760239AbXEaQuM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760239AbXEaQuM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 12:50:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754283AbXEaQt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 12:49:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:57146 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752737AbXEaQt4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 12:49:56 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: trenn@suse.de
Subject: Re: [PATCH] ACPI Debug - for test, devel and possibly even for production kernels
Date: Thu, 31 May 2007 12:49:12 -0400
User-Agent: KMail/1.9.5
Cc: linux-acpi <linux-acpi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, penberg@cs.helsinki.fi
References: <1180624839.10908.71.camel@queen.suse.de>
In-Reply-To: <1180624839.10908.71.camel@queen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705311249.12762.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The name of this patch is really "split ACPI function tracing
out of CONFIG_ACPI_DEBUG to a new Kconfig build option"

I agree that tracing should be its own build option.

I don't agree that enabling CONFIG_ACPI_DEBUG by default
is what you want to do in a production kernel, but that
isn't what this patch does, and I'm not going to stand
in your way if you want to ship debug kernels by default.

> we only make use of a small subset of current ACPI tables.
> ACPI spreads more and more over different parts of the kernel and it's
> likely that this will hold on.

There are two types of "ACPI tables", those with contents defined by
the ACPI spec, and those where ACPI is just acting as the "envelope"
to deliver a table from another spec to the OS.

We already use all the tables defined by the ACPI spec.
It is unlikely that this patch will have any effect on the "envelope" tables.

So I don't think you're going to see growing utility of CONFIG_ACPI_DEBUG
over time, you're going to see what it does immediately.

> ACPI_DEBUG=y is a powerful debug facility, that can ease up bug
> communication with less (ACPI) experienced bug submitters and can shed
> some light behind ACPI magic.
> 
> I've done some measurements and found out that most of the performance
> costs are due the function tracing support in the ACPICA debug
> subsystem.
> 
> This patch offers the possibility to compile out ACPI function tracing
> support which is of none use for ordinary kernel debugging (is only used
> for Intel internal debugging AFAIK), but takes most of the performance
> costs.

I agree that function tracing is never used by people who can't build a kernel --
and so it is fine to make it an additional build option.

> (This should efficiently be the same as the proposed big patch a year
> ago from Pekka Enberg, just a bit smaller and should make ACPICA and
> kernel/linux people happy:
> http://marc.info/?l=linux-kernel&m=113699535303722&w=2
> )
> 
> 
> Kernel image size (compiled on x86_64):
> Full acpi debug:
> 1618277 bytes (+3.1%, +48k)
> acpi debug function trace compiled out:
> 1605359 bytes (+2.3%, +35k)
> acpi debug not compiled in at all
> 1569803 bytes (100%)
> 
> 
> Speed measures on one specific machine (x86_64, laptop):
> 
> A) ACPI_DEBUG compiled in
> B) ACPI_DEBUG compiled in, but Function trace compiled out
> C) ACPI_DEBUG compiled out
> D) ACPI_DEBUG compiled out (control run)
> 
> The time has been taken at following functions:
> 
> 1) drivers/acpi/bus.c:acpi_early_init (load tables and initialize
>                                        ACPI namespace)
> 2) drivers/acpi/bus.c:acpi_init (some more initialisation
>                                  -> enable ACPI HW mode
>                                  -> read PIC/APIC table, ...)
> 3) drivers/acpi/scan.c:scan_init (Enumerate devices in the
>                                   ACPI namespace)
> 
> register driver for acpi drivers:
> 4)  ec
> 5)  pci_root
> 6)  pci_link
> 
> -----------------------------------------------------------------------
>   |      A         |       B        |       C        |     D          | 
> -----------------------------------------------------------------------
> 1 | 434711 (+1.0%) | 432652 (+0.4%) |  430522 (100%) |  430512 (-0.00%)
> -----------------------------------------------------------------------
> 2 |  69156 (+3.7%) |  67007 (+0.4%) |   66696 (100%) |   66703 (+0.01%)
> -----------------------------------------------------------------------
> 3 |   8769(+63.3%) |   7363(+37.1%) |    5369 (100%) |    5369 ( 0.00%)
> -----------------------------------------------------------------------

37% sounds like a lot.

The ACPI interpreter is not supposed to be in performace critical sections,
but at the same time, it isn't supposed to be a pig either.

> 4 |  15999 (+0.7%) |  15950 (+0.4%) |   15879 (100%) |   15878 (-0.01%)
> -----------------------------------------------------------------------
> 5 |   9492(+75.4%) |   7657(+41.5%) |    5411 (100%) |    5405 (-0.11%)
> -----------------------------------------------------------------------
> 6 |   1717(+64.0%) |   1494(+42.6%) |    1047 (100%) |    1046 (-0.10%)
> -----------------------------------------------------------------------
> All measured values are in us. TSC was used to obtain the values.
> do_gettimeofday did only provide valid values after hpet got setup
> (after pci_link).
> 
> I wonder why only the short time taking measures show that extreme
> performance loss, maybe someone has an idea. However if you summarize
> all additional time with ACPI_DEBUG without function trace, you get
> about +5 ms boot time (which may vary from machine to machine...).
> This should be acceptable for test and develop kernels.
> If nothing bad happens in Beta phase I'd like to include this one into
> the final OpenSUSE kernel to get detailed bug reports.
> It would be great if others with their latest test/devel kernels follow,
> so that even ordinary users can easily provide essential, detailed debug
> information easily(e.g. Linus' Compaq and Andrew's Vaio are well known
> on the acpi list, others do not have the luck to get that much of
> support and they do not have the knowledge to compile kernel and so
> on...).
> 
> I can also add a file "Documentation/acpi_debug" and add some debug
> hints if this one gets accepted...
> 
> This one should not be really dangerous. If the patch is ok, can Len
> still merge this in .22 time?

.22 after -rc3?  No.  I don't see a problem with a final version
shipping in .23, however.

> If not, can you take it for some testing, Andrew?

It would be better for andrew to get it through acpi-test.

I'll be happy to include an updated version of this patch there.

Note that the testing that it is going to get will be small:

1. people who don't enable CONFIG_ACPI_DEBUG
	no change
2. people who enable CONFIG_ACPI_DEBUG
	will lose function tracing if they don't ask for it
	will lose AML Debug-object messages unless they
		set the flag to get them back.

> Thanks,
> 
>    Thomas
> 
> 
> 
> Split ACPI_DEBUG into function trace enabled and not enabled.
> 
> Function trace is most of the ACPI_DEBUG costs, but is
> not much of use for kernel ACPI debugging.
> 
> Size of kernel image increased on test compile:
> + 48k  (Full ACPI_DEBUG)
> + 35k  (ACPI_DEBUG with function trace compiled out)
> 
> Performance without function trace is also much better.
> 
> Also remove ACPI_LV_DEBUG_OBJECT from default debug level as
> a lot vendors let Store (value, debug) in their code and this
> might confuse users when it pops up in syslog.

This, is an incompatible change, as one of the benefits of
CONFIG_ACPI_DEBUG is to get the AML debug-object messages.
After this patch, those will silently go away.

The patch needs to document the boot-time flag to make
those messages come back.

> ---
>  drivers/acpi/Kconfig    |    8 ++++++++
>  include/acpi/acmacros.h |   23 +++++++++++++++++++++++
>  include/acpi/acoutput.h |    4 ++--
>  3 files changed, 33 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6.22-rc3/drivers/acpi/Kconfig
> ===================================================================
> --- linux-2.6.22-rc3.orig/drivers/acpi/Kconfig
> +++ linux-2.6.22-rc3/drivers/acpi/Kconfig
> @@ -280,6 +280,14 @@ config ACPI_DEBUG
>  	  of verbosity. Saying Y enables these statements. This will increase
>  	  your kernel size by around 50K.
>  
> +config ACPI_DEBUG_FUNC_TRACE
> +	bool "Additionally enable ACPI function tracing"
> +	default n
> +	depends on ACPI_DEBUG
> +	help
> +	  ACPI Debug Statements slow down ACPI processing. Function trace
> +	  is about half of the penalty and is rarely useful.

help text needs update -- it should say what tracing does,
not if SuSE customers frequently use it or not...

>  config ACPI_EC
>  	bool
>  	default y
> Index: linux-2.6.22-rc3/include/acpi/acmacros.h
> ===================================================================
> --- linux-2.6.22-rc3.orig/include/acpi/acmacros.h
> +++ linux-2.6.22-rc3/include/acpi/acmacros.h
> @@ -486,6 +486,8 @@
>  #define ACPI_FUNCTION_NAME(name)
>  #endif
>  
> +#ifdef DEBUG_FUNC_TRACE
> +
>  #define ACPI_FUNCTION_TRACE(a)          ACPI_FUNCTION_NAME(a) \
>  			  acpi_ut_trace(ACPI_DEBUG_PARAMETERS)
>  #define ACPI_FUNCTION_TRACE_PTR(a,b)    ACPI_FUNCTION_NAME(a) \
> @@ -563,6 +565,27 @@
>  
>  #endif				/* ACPI_SIMPLE_RETURN_MACROS */
>  
> +#else /* !DEBUG_FUNC_TRACE */
> +
> +#define ACPI_FUNCTION_TRACE(a)
> +#define ACPI_FUNCTION_TRACE_PTR(a,b)
> +#define ACPI_FUNCTION_TRACE_U32(a,b)
> +#define ACPI_FUNCTION_TRACE_STR(a,b)
> +#define ACPI_FUNCTION_EXIT
> +#define ACPI_FUNCTION_STATUS_EXIT(s)
> +#define ACPI_FUNCTION_VALUE_EXIT(s)
> +#define ACPI_FUNCTION_TRACE(a)
> +#define ACPI_FUNCTION_ENTRY()
> +
> +#define return_VOID                     return
> +#define return_ACPI_STATUS(s)           return(s)
> +#define return_VALUE(s)                 return(s)
> +#define return_UINT8(s)                 return(s)
> +#define return_UINT32(s)                return(s)
> +#define return_PTR(s)                   return(s)
> +
> +#endif /* DEBUG_FUNC_TRACE */

These non-defines already appear later in the file.
Perhaps you can use an expression to make them appear just once instead of twice?

>  /* Conditional execution */
>  
>  #define ACPI_DEBUG_EXEC(a)              a
> Index: linux-2.6.22-rc3/include/acpi/acoutput.h
> ===================================================================
> --- linux-2.6.22-rc3.orig/include/acpi/acoutput.h
> +++ linux-2.6.22-rc3/include/acpi/acoutput.h
> @@ -178,8 +178,8 @@
>  
>  /* Defaults for debug_level, debug and normal */
>  
> -#define ACPI_DEBUG_DEFAULT          (ACPI_LV_INIT | ACPI_LV_WARN | ACPI_LV_ERROR | ACPI_LV_DEBUG_OBJECT)
> -#define ACPI_NORMAL_DEFAULT         (ACPI_LV_INIT | ACPI_LV_WARN | ACPI_LV_ERROR | ACPI_LV_DEBUG_OBJECT)
> +#define ACPI_DEBUG_DEFAULT          (ACPI_LV_INIT | ACPI_LV_WARN | ACPI_LV_ERROR)
> +#define ACPI_NORMAL_DEFAULT         (ACPI_LV_INIT | ACPI_LV_WARN | ACPI_LV_ERROR)
>  #define ACPI_DEBUG_ALL              (ACPI_LV_AML_DISASSEMBLE | ACPI_LV_ALL_EXCEPTIONS | ACPI_LV_ALL)
>  
>  #endif				/* __ACOUTPUT_H__ */
> 
> 
