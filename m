Return-Path: <linux-kernel-owner+w=401wt.eu-S1756017AbXJJTPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756017AbXJJTPr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 15:15:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752751AbXJJTPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 15:15:40 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:38726 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368AbXJJTPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 15:15:39 -0400
Date: Wed, 10 Oct 2007 13:15:38 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: linux-kernel@vger.kernel.org
Subject: [matthew@wil.cx: Re: [parisc-linux] parisc arch makefile clean-up needed [Was: cleaning up "make headers_install" for various architectures]]
Message-ID: <20071010191538.GF2730@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Sam mipslet 'parisc-linux' in the first mail ... so i replied to the
second mail ... without checking l-k was still cc'd.

----- Forwarded message from Matthew Wilcox <matthew@wil.cx> -----

From: Matthew Wilcox <matthew@wil.cx>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: parisc-linux@lists.parisc-linux.org
Subject: Re: [parisc-linux] parisc arch makefile clean-up needed [Was:
	cleaning up "make headers_install" for various architectures]

On Wed, Oct 10, 2007 at 08:42:25PM +0200, Sam Ravnborg wrote:
> parisc arch Makefile needs some love and care...
> 
> The logic selecting CROSS_COMPILE seems fishy and wrong -
> the error reported by rday is obvious in this respect.

He doesn't have a compiler installed that can target parisc.  It doesn't
seem obvious to me that this should work.

> FINAL_LD is unused - kill it.

OK.

> Building with oldpalo has been broken for a loong time - time to kill it?
> Hint - the "cd ../palo" is not working as expected.
> And use of TOPDIR is deprecated.

OK, killed.  I don't think anyone still uses that.

> The libs-y assignment should learn from the other architectures how to
> get the gcc lib filename:
> $(shell $(CC) $(CFLAGS) -print-libgcc-file-name)

Actually, this looks utterly unstandardised:

arch/cris/Makefile:LIBGCC = $(shell $(CC) $(CFLAGS) -print-file-name=libgcc.a)
arch/h8300/Makefile:LIBGCC := $(shell $(CROSS-COMPILE)$(CC) $(CFLAGS) -print-libgcc-file-name)
arch/m32r/Makefile:LIBGCC       := $(shell $(CC) $(CFLAGS) -print-libgcc-file-name)
arch/parisc/Makefile:libs-y     += arch/parisc/lib/ `$(CC) -print-libgcc-file-name`
arch/sh64/Makefile:LIBGCC := $(shell $(CC) $(CFLAGS) -print-libgcc-file-name)
arch/sh/Makefile:LIBGCC := $(shell $(CC) $(CFLAGS) -print-libgcc-file-name)
arch/xtensa/Makefile:LIBGCC := $(shell $(CC) $(CFLAGS) -print-libgcc-file-name)

How about we set it in the main Makefile, or one of the ones in
scripts/?  That way we don't have to learn why $(shell $(CC) $(CFLAGS)
-print-libgcc-file-name) is superior to `$(CC) -print-libgcc-file-name`

> 
> And this snippet is also wrong:
> PALO := $(shell if which palo; then : ; \
> 	elif [ -x /sbin/palo ]; then echo /sbin/palo; \
> 	fi)
> 
> palo: vmlinux
> 	@if [ -x $PALO ]; then \
> 
> 
> Make does not export variables so $PALO is not the same as $(PALO).
> The latter should be used.

Huh.  Looks like the sense of the test is reversed too.  That should
probably be:

	@if [ ! -x $(PALO) ]; then \

> I did not supply a patch because I do not fully understand the
> logic behind setting CROSS_COMPILE and 64BIT or not.
> But I will be happy to review a patch to fix the issues in the
> parisc Makefile.

One issue is that we don't have native 64-bit userspace on parisc.
And we don't have a toolchain that you can pass -m32/-m64 to; you have
to explicitly build a hppa64-linux-gnu toolchain.  Another thing we try
and make user-friendly is that if you're building the parisc kernel on
a non-parisc machine, you need to use a cross-compiler, so we autodetect
that case for you.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
_______________________________________________
parisc-linux mailing list
parisc-linux@lists.parisc-linux.org
http://lists.parisc-linux.org/mailman/listinfo/parisc-linux

----- End forwarded message -----

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
