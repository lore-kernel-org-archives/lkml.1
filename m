Return-Path: <linux-kernel-owner+w=401wt.eu-S934356AbZJMVLM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934356AbZJMVLM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 17:11:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934195AbZJMVLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 17:11:11 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:24571 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934193AbZJMVLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 17:11:10 -0400
Date: Tue, 13 Oct 2009 14:09:15 -0700
From: Randy Dunlap <randy.dunlap@ORACLE.COM>
To: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
       paulus@samba.org, acme@redhat.com, a.p.zijlstra@chello.nl,
       efault@gmx.de, randy.dunlap@ORACLE.COM, fweisbec@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
Cc: tip-bot for Ingo Molnar <mingo@elte.hu>, linux-tip-commits@vger.kernel.org,
       acme@redhat.com, paulus@samba.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, fweisbec@gmail.com,
       tglx@linutronix.de
Subject: Re: [tip:perf/urgent] perf tools: Fix the NO_64BIT build on pure
 64-bit systems
Message-Id: <20091013140915.96cfe060.randy.dunlap@oracle.com>
In-Reply-To: <tip-55621ccf2b7a8afe39df8c80f55b28424fd07d13@git.kernel.org>
References: <tip-55621ccf2b7a8afe39df8c80f55b28424fd07d13@git.kernel.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4AD4EC9D.01A2:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Oct 2009 08:34:16 GMT tip-bot for Ingo Molnar wrote:

> Commit-ID:  55621ccf2b7a8afe39df8c80f55b28424fd07d13
> Gitweb:     http://git.kernel.org/tip/55621ccf2b7a8afe39df8c80f55b28424fd07d13
> Author:     Ingo Molnar <mingo@elte.hu>
> AuthorDate: Mon, 12 Oct 2009 09:57:25 +0200
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Mon, 12 Oct 2009 10:00:27 +0200
> 
> perf tools: Fix the NO_64BIT build on pure 64-bit systems
> 
> Randy Dunlap reported that 'make NO_64BIT=1' fails to build
> a pure 32-b it binary on 64-bit/64-bit x86 systems.
> 
> The reason is that we dont pass in the -m32 and GCC defaults
> to -m64.
> 
> So pass it in - and also extend the warning message about libelf
> dependencies - glibc-dev[el] is needed as well beyond the libelf
> library.

Ingo, thanks, I finally got this working, after installing more 32-bit
libs etc., like Kyle said that I would need to do.

The error message is still a little misleading/confusing:
Makefile:426: *** No libelf.h/libelf found, please install libelf-dev/elfutils-libelf-devel and glibc-dev[el].  Stop.

when elfutils-libelf-devel.i586 is installed but glibc-devel.i[56]86 is not
installed.  gcc failed with:
In file included from /usr/include/features.h:376,
                 from /usr/include/sys/types.h:27,
                 from /usr/include/libelf.h:53,
                 from elfdeveltest.c:1:
/usr/include/gnu/stubs.h:7:27: error: gnu/stubs-32.h: No such file or directory


> Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> LKML-Reference: Message-Id: <20091005131729.78444bfb.randy.dunlap@oracle.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  tools/perf/Makefile |   21 ++++++++++++++-------
>  1 files changed, 14 insertions(+), 7 deletions(-)
> 
> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> index 5881943..742a32e 100644
> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
> @@ -157,11 +157,18 @@ uname_R := $(shell sh -c 'uname -r 2>/dev/null || echo not')
>  uname_P := $(shell sh -c 'uname -p 2>/dev/null || echo not')
>  uname_V := $(shell sh -c 'uname -v 2>/dev/null || echo not')
>  
> -# If we're on a 64-bit kernel, use -m64
> -ifndef NO_64BIT
> -	ifneq ($(patsubst %64,%,$(uname_M)),$(uname_M))
> -	  M64 := -m64
> -	endif
> +#
> +# Add -m32 for cross-builds:
> +#
> +ifdef NO_64BIT
> +  MBITS := -m32
> +else
> +  #
> +  # If we're on a 64-bit kernel, use -m64:
> +  #
> +  ifneq ($(patsubst %64,%,$(uname_M)),$(uname_M))
> +    MBITS := -m64
> +  endif
>  endif
>  
>  # CFLAGS and LDFLAGS are for the users to override from the command line.
> @@ -194,7 +201,7 @@ EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wold-style-definition
>  EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wstrict-prototypes
>  EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wdeclaration-after-statement
>  
> -CFLAGS = $(M64) -ggdb3 -Wall -Wextra -std=gnu99 -Werror -O6 -fstack-protector-all -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS)
> +CFLAGS = $(MBITS) -ggdb3 -Wall -Wextra -std=gnu99 -Werror -O6 -fstack-protector-all -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS)
>  LDFLAGS = -lpthread -lrt -lelf -lm
>  ALL_CFLAGS = $(CFLAGS)
>  ALL_LDFLAGS = $(LDFLAGS)
> @@ -416,7 +423,7 @@ ifeq ($(uname_S),Darwin)
>  endif
>  
>  ifneq ($(shell sh -c "(echo '\#include <libelf.h>'; echo 'int main(void) { Elf * elf = elf_begin(0, ELF_C_READ_MMAP, 0); return (long)elf; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -o /dev/null $(ALL_LDFLAGS) > /dev/null 2>&1 && echo y"), y)
> -	msg := $(error No libelf.h/libelf found, please install libelf-dev/elfutils-libelf-devel);
> +	msg := $(error No libelf.h/libelf found, please install libelf-dev/elfutils-libelf-devel and glibc-dev[el]);
>  endif
>  
>  ifdef NO_DEMANGLE


---
~Randy
