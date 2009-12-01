Return-Path: <linux-kernel-owner+w=401wt.eu-S1754429AbZLAUYK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429AbZLAUYK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 15:24:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753040AbZLAUYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 15:24:09 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:40174 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187AbZLAUYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 15:24:08 -0500
Subject: Re: [PATCH] perf tools: allow cross compiling of perf tools
From: Peter Zijlstra <peterz@infradead.org>
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       "Michael S. Tsirkin" <mst@redhat.com>
In-Reply-To: <1259698310-11025-1-git-send-email-jamie@jamieiles.com>
References: <1259698310-11025-1-git-send-email-jamie@jamieiles.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Dec 2009 21:24:10 +0100
Message-ID: <1259699050.4003.15.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-01 at 20:11 +0000, Jamie Iles wrote:
> For embedded systems we need to cross compile applications on
> the build machine. Use the CROSS_COMPILE variable like the kernel
> itself.
> 
> Additionally, we can't use uname to determine whether we should
> build for 64 bit. Use the -dumpmachine flag of GCC to determine
> the target arch.

Hmm, and here I though Michael already send something similar to this..
but apparently I can't really find it

> Signed-off-by: Jamie Iles <jamie@jamieiles.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  tools/perf/Makefile |   56 ++++++++++++++++++++++++++++++---------------------
>  1 files changed, 33 insertions(+), 23 deletions(-)
> 
> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> index 7e190d5..aed4812 100644
> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
> @@ -150,27 +150,6 @@ PERF-VERSION-FILE: .FORCE-PERF-VERSION-FILE
>  	@$(SHELL_PATH) util/PERF-VERSION-GEN
>  -include PERF-VERSION-FILE
>  
> -uname_S := $(shell sh -c 'uname -s 2>/dev/null || echo not')
> -uname_M := $(shell sh -c 'uname -m 2>/dev/null || echo not')
> -uname_O := $(shell sh -c 'uname -o 2>/dev/null || echo not')
> -uname_R := $(shell sh -c 'uname -r 2>/dev/null || echo not')
> -uname_P := $(shell sh -c 'uname -p 2>/dev/null || echo not')
> -uname_V := $(shell sh -c 'uname -v 2>/dev/null || echo not')
> -
> -#
> -# Add -m32 for cross-builds:
> -#
> -ifdef NO_64BIT
> -  MBITS := -m32
> -else
> -  #
> -  # If we're on a 64-bit kernel, use -m64:
> -  #
> -  ifneq ($(patsubst %64,%,$(uname_M)),$(uname_M))
> -    MBITS := -m64
> -  endif
> -endif
> -
>  # CFLAGS and LDFLAGS are for the users to override from the command line.
>  
>  #
> @@ -239,8 +218,16 @@ lib = lib
>  
>  export prefix bindir sharedir sysconfdir
>  
> -CC = gcc
> -AR = ar
> +# CROSS_COMPILE specify the prefix used for all executables used
> +# during compilation. Only gcc and related bin-utils executables
> +# are prefixed with $(CROSS_COMPILE).
> +# CROSS_COMPILE can be set on the command line
> +# make CROSS_COMPILE=ia64-linux-
> +# Alternatively CROSS_COMPILE can be set in the environment.
> +# Default value for CROSS_COMPILE is not to prefix executables
> +CROSS_COMPILE ?=
> +CC = $(CROSS_COMPILE)gcc
> +AR = $(CROSS_COMPILE)ar
>  RM = rm -f
>  TAR = tar
>  FIND = find
> @@ -252,6 +239,29 @@ PTHREAD_LIBS = -lpthread
>  # explicitly what architecture to check for. Fix this up for yours..
>  SPARSE_FLAGS = -D__BIG_ENDIAN__ -D__powerpc__
>  
> +uname_S := $(shell sh -c 'uname -s 2>/dev/null || echo not')
> +uname_M := $(shell sh -c 'uname -m 2>/dev/null || echo not')
> +uname_O := $(shell sh -c 'uname -o 2>/dev/null || echo not')
> +uname_R := $(shell sh -c 'uname -r 2>/dev/null || echo not')
> +uname_P := $(shell sh -c 'uname -p 2>/dev/null || echo not')
> +uname_V := $(shell sh -c 'uname -v 2>/dev/null || echo not')
> +machine := $(shell sh -c '$(CC) -dumpmachine | cut -d- -f1')
> +
> +#
> +# Add -m32 for cross-builds:
> +# Note: not all architectures have a -m32/-m64 so only define it if we
> +# explicitly force to 32 bits or detect a 64 bit arch.
> +#
> +ifdef FORCE_32BIT
> +  MBITS := -m32
> +else
> +  #
> +  # If we're on a 64-bit kernel, use -m64:
> +  #
> +  ifneq ($(patsubst %64,%,$(machine)),$(machine))
> +    MBITS := -m64
> +  endif
> +endif
>  
> 
>  ### --- END CONFIGURATION SECTION ---


