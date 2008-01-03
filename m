Return-Path: <linux-kernel-owner+w=401wt.eu-S1757276AbYACIbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757276AbYACIbc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 03:31:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754159AbYACIbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 03:31:21 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:40012 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756286AbYACIbS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 03:31:18 -0500
Date: Thu, 3 Jan 2008 09:31:18 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       "William L. Irwin" <sparclinux@vger.kernel.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 01/11] Add basic support for gcc profiler instrumentation
Message-ID: <20080103083118.GB16597@uranus.ravnborg.org>
References: <20080103071609.478486470@goodmis.org> <20080103072226.776141236@goodmis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080103072226.776141236@goodmis.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven.

On Thu, Jan 03, 2008 at 02:16:10AM -0500, Steven Rostedt wrote:
> If CONFIG_MCOUNT is selected and /proc/sys/kernel/mcount_enabled is set to a
> non-zero value the mcount routine will be called everytime we enter a kernel
> function that is not marked with the "notrace" attribute.
> 
> The mcount routine will then call a registered function if a function
> happens to be registered.
> 
> [This code has been highly hacked by Steven Rostedt, so don't
>  blame Arnaldo for all of this ;-) ]
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---
> 
> Index: linux-compile.git/Documentation/stable_api_nonsense.txt
> ===================================================================
> --- linux-compile.git.orig/Documentation/stable_api_nonsense.txt	2008-01-03 01:02:28.000000000 -0500
> +++ linux-compile.git/Documentation/stable_api_nonsense.txt	2008-01-03 01:02:33.000000000 -0500
> @@ -62,6 +62,9 @@ consider the following facts about the L
>        - different structures can contain different fields
>        - Some functions may not be implemented at all, (i.e. some locks
>  	compile away to nothing for non-SMP builds.)
> +      - Parameter passing of variables from function to function can be
> +	done in different ways (the CONFIG_REGPARM option controls
> +	this.)

As CONFIG_REGPARM affects calling convention we should add it to the
list of symbols checked when loading modules (vermagic.h).


>        - Memory within the kernel can be aligned in different ways,
>  	depending on the build options.
>    - Linux runs on a wide range of different processor architectures.
> Index: linux-compile.git/Makefile
> ===================================================================
> --- linux-compile.git.orig/Makefile	2008-01-03 01:02:28.000000000 -0500
> +++ linux-compile.git/Makefile	2008-01-03 01:02:39.000000000 -0500
> @@ -509,11 +509,15 @@ endif
>  
>  include $(srctree)/arch/$(SRCARCH)/Makefile
>  
> +ifdef CONFIG_MCOUNT
> +KBUILD_CFLAGS	+= -pg -fno-omit-frame-pointer -fno-optimize-sibling-calls
> +else
>  ifdef CONFIG_FRAME_POINTER
>  KBUILD_CFLAGS	+= -fno-omit-frame-pointer -fno-optimize-sibling-calls
>  else
>  KBUILD_CFLAGS	+= -fomit-frame-pointer
>  endif
> +endif
Could we please move these relations to Kconfig. So we do not end up in a situation
where CONFIG_FRAME_POINTER is set but the flag is not added.



>  
>  ifdef CONFIG_DEBUG_INFO
>  KBUILD_CFLAGS	+= -g
> Index: linux-compile.git/arch/x86/Kconfig
> ===================================================================
> --- linux-compile.git.orig/arch/x86/Kconfig	2008-01-03 01:02:28.000000000 -0500
> +++ linux-compile.git/arch/x86/Kconfig	2008-01-03 01:02:33.000000000 -0500
> @@ -28,6 +28,12 @@ config GENERIC_CMOS_UPDATE
>  	bool
>  	default y
>  
> +# function tracing might turn this off:
> +config REGPARM
> +	bool
> +	depends on !MCOUNT
> +	default y
> +

Could we please define config REGPARM in _one_ Kconfig file
and let those who want it select it.
If you consider this x86 spacific this should be included in the naming
as in CONFIG_X86_REGPARM - and then the above is OK.

Defining the same config variable in several files is not good (but done too often these days).

> Index: linux-compile.git/lib/mcount/Makefile
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-compile.git/lib/mcount/Makefile	2008-01-03 01:02:33.000000000 -0500
> @@ -0,0 +1,3 @@
> +obj-$(CONFIG_MCOUNT) += libmcount.o
> +
> +libmcount-objs := mcount.o

Preferred syntax is now:
libmcount-y := mcount.o

	Sam
