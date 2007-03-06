Return-Path: <linux-kernel-owner+w=401wt.eu-S1751019AbXCFTXH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751019AbXCFTXH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 14:23:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751096AbXCFTXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 14:23:07 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:48996 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751031AbXCFTXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 14:23:05 -0500
Date: Tue, 6 Mar 2007 20:23:39 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Deepak Saxena <dsaxena@plexity.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix building kernel under Solaris
Message-ID: <20070306192339.GB19254@uranus.ravnborg.org>
References: <20070306180940.GA3240@plexity.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070306180940.GA3240@plexity.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 06, 2007 at 10:09:40AM -0800, Deepak Saxena wrote:
> 
> Fix varous build breakages that occur when building on a Solaris system
> (SunOS 4.8 to be exact)
> 
> - No asm/types.h
> 
> - lpptest doesn't make sense on a Solaris host (this should really be
>   cross-built..)
> 
> - Need to define __s32 and __s16
> 
> - Need to define Elf32_Section and Elf64_Section
> 
> - Solaris does not provide strsep
> 
> Signed-off-by: Deepak Saxena <dsaxena@mvista.com>
> 
> 
> diff -uNr -X /home/src/dontdiff /home/src/mvista/kernel/PRO5-CLEAN/linux-2.6.18/include/linux/input.h linux-2.6.18_pro500/include/linux/input.h
> --- /home/src/mvista/kernel/PRO5-CLEAN/linux-2.6.18/include/linux/input.h	2007-03-05 21:54:45.000000000 -0800
> +++ linux-2.6.18_pro500/include/linux/input.h	2007-03-05 19:19:01.000000000 -0800
> @@ -16,8 +16,10 @@
>  #include <sys/time.h>
>  #include <sys/ioctl.h>
>  #include <sys/types.h>
> +#ifndef __sun__
>  #include <asm/types.h>
>  #endif
> +#endif
Either we need it - or we do not need it - no?
So we can just kill the include.

>  
>  /*
>   * The event structure itself
> diff -uNr -X /home/src/dontdiff /home/src/mvista/kernel/PRO5-CLEAN/linux-2.6.18/scripts/Makefile linux-2.6.18_pro500/scripts/Makefile
> --- /home/src/mvista/kernel/PRO5-CLEAN/linux-2.6.18/scripts/Makefile	2007-03-05 21:54:43.000000000 -0800
> +++ linux-2.6.18_pro500/scripts/Makefile	2007-03-05 19:54:52.000000000 -0800
> @@ -12,10 +12,12 @@
>  hostprogs-$(CONFIG_VT)           += conmakehash
>  hostprogs-$(CONFIG_PROM_CONSOLE) += conmakehash
>  hostprogs-$(CONFIG_IKCONFIG)     += bin2c
> +HOST_OS := $(shell uname)
> +ifneq ($(HOST_OS),SunOS)
>  ifdef CONFIG_LPPTEST
>  hostprogs-y      += testlpp
>  endif
> -
> +endif
>  always		:= $(hostprogs-y)
testlpp is not in mainline - what is it?
[downloading -mm now]

> --- /home/src/mvista/kernel/PRO5-CLEAN/linux-2.6.18/scripts/mod/file2alias.c	2007-03-05 21:54:42.000000000 -0800
> +++ linux-2.6.18_pro500/scripts/mod/file2alias.c	2007-03-05 19:19:26.000000000 -0800
> @@ -29,6 +29,11 @@
>  
>  #include <ctype.h>
>  
> +#if defined(__sun__)
> +typedef int32_t	__s32;
> +typedef int16_t	__s16;
> +#endif
> +
>  #if defined(__CYGWIN__)
>  typedef __uint32_t	__u32;
>  #else
> diff -uNr -X /home/src/dontdiff /home/src/mvista/kernel/PRO5-CLEAN/linux-2.6.18/scripts/mod/modpost.h linux-2.6.18_pro500/scripts/mod/modpost.h
> --- /home/src/mvista/kernel/PRO5-CLEAN/linux-2.6.18/scripts/mod/modpost.h	2007-03-05 21:54:42.000000000 -0800
> +++ linux-2.6.18_pro500/scripts/mod/modpost.h	2007-03-05 19:13:16.000000000 -0800
> @@ -15,6 +15,11 @@
>  
>  #include "elfconfig.h"
>  
> +#if defined(__sun__)
> +typedef uint16_t Elf32_Section;
> +typedef uint16_t Elf64_Section;
> +#endif
> +
>  #if KERNEL_ELFCLASS == ELFCLASS32
>  
>  #define Elf_Ehdr    Elf32_Ehdr
> diff -uNr -X /home/src/dontdiff /home/src/mvista/kernel/PRO5-CLEAN/linux-2.6.18/scripts/mod/sumversion.c linux-2.6.18_pro500/scripts/mod/sumversion.c
> --- /home/src/mvista/kernel/PRO5-CLEAN/linux-2.6.18/scripts/mod/sumversion.c	2007-03-05 21:54:42.000000000 -0800
> +++ linux-2.6.18_pro500/scripts/mod/sumversion.c	2007-03-05 19:33:55.000000000 -0800
> @@ -1,6 +1,7 @@
>  #if defined(__sun__)
>  #include <netinet/in.h>
>  #include <inttypes.h>
> +#include <limits.h>
>  #elif defined(__CYGWIN__)
>  #include <asm/byteorder.h>	/* For ntohl/htonl */
>  #include <limits.h>
> @@ -421,9 +422,16 @@
>  	*end = '\0';
>  
>  	md4_init(&md);
> +/*
> + * Solaris does not strsep
> + */
> +#ifndef __sun__
>  	while ((fname = strsep(&sources, " ")) != NULL) {
>  		if (!*fname)
>  			continue;
> +#else
> +	for (fname = strtok(sources, " "); fname; fname = strtok(NULL, " ")) {
> +#endif
>  		if (!parse_source_files(fname, &md))
>  			goto release;
>  	}
Why the ifdef - I assume it is always OK to use the latter version?
Please send next diff cc: to me (at least the parts that touches scripts/

	Sam
