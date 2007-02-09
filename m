Return-Path: <linux-kernel-owner+w=401wt.eu-S1946118AbXBIFN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946118AbXBIFN4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 00:13:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946119AbXBIFN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 00:13:56 -0500
Received: from raven.upol.cz ([158.194.120.4]:52909 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946118AbXBIFNz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 00:13:55 -0500
Date: Fri, 9 Feb 2007 06:22:45 +0100
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: The who needs reviews anyways [PATCH]
Message-ID: <20070209052245.GC28386@flower.upol.cz>
References: <Pine.LNX.4.64.0702082227020.14457@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702082227020.14457@scrub.home>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 08, 2007 at 10:48:51PM +0100, Roman Zippel wrote:
[]
> - printf has other side effects, instead stop pretending we support 
>   something else than bash

More on printf, `sh', tmpfiles.

As we know original problem is: something from binutils is removing
output files on failure. 

> -	  else if [ -x /bin/bash ]; then echo /bin/bash; \
> -	  else echo sh; fi ; fi)
> +	  else if [ -x /bin/bash ]; then echo /bin/bash; fi; fi)
> +ifeq ($(CONFIG_SHELL),)
> +$(error bash is required to build the kernel)
> +endif
> +SHELL := $(CONFIG_SHELL)

here is policy to have `bash' introduced, so due to original
issue, where `root' users ended with removed /dev/null, may policy to have
`non root' user to build kernel be added? Thus

this:
> +# output directory for tests below
> +TMPOUT := $(if $(KBUILD_EXTMOD),$(firstword $(KBUILD_EXTMOD))/)
[]
> +# try-run
> +# Usage: option = $(call try-run, $(CC)...-o "$$TMP",option-ok,otherwise)
> +# Exit code chooses option. "$$TMP" is can be used as temporary file and
> +# is automatically cleaned up.
> +try-run = $(shell set -e;		\
this:
> +	TMP="$(TMPOUT).$$$$.tmp";	\
[]
> +	if ($(1)) >/dev/null 2>&1;	\
> +	then echo "$(2)";		\
> +	else echo "$(3)";		\
> +	fi;				\
this:
> +	rm -f "$$TMP")

may be removed, and to make TMP=/dev/null? And to forget currently about
my silly symlinks, and this crappy sets of output files?

As for `printf', as i've wrote, only in case of % and quotes in
arguments, something else must be added to handle that. But i think, it's
paranoia.

> -as-instr = $(call checker-shell,\
> -   printf "$(1)" | $(CC) $(AFLAGS) -c -xassembler -o $$OUT -,$(2),$(3))

`printf $(1)' is pretty enough.

____
