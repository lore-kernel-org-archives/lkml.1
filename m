Return-Path: <linux-kernel-owner+w=401wt.eu-S1762194AbXKHTLX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762194AbXKHTLX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 14:11:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760420AbXKHTLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 14:11:15 -0500
Received: from mx1.redhat.com ([66.187.233.31]:42601 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759958AbXKHTLO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 14:11:14 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20071108182937.GA26852@uranus.ravnborg.org>
References: <20071108182937.GA26852@uranus.ravnborg.org> <20071108171612.26590.4348.stgit@warthog.procyon.org.uk>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: dhowells@redhat.com, torvalds@osdl.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-am33-list@redhat.com
Subject: Re: [PATCH 0/6] MN10300: Add the MN10300 architecture to Linux kernel [try #4]
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Thu, 08 Nov 2007 19:11:05 +0000
Message-ID: <16966.1194549065@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg <sam@ravnborg.org> wrote:

> 
> arch/mn10300/Makefile:
> 
> 1) Use KBUILD_CFLAGS & KBUILD_AFLAGS & KBUILD_CPPFLAGS - they
> have replaced the former xFLAGS.

Done.  What about ASFLAGS and LDFLAGS?

> 2) Consider using unit-y as replacement for UNIT.
> This enable you to do:
> unit-$(CONFIG_MN10300_UNIT_ASB2303) += asb2303
>
> 3) Same for PROCESSOR => processor-y

That makes sense if I'm not calculating UNIT or PROCESSOR anyway.  However,
see below.

> 4) Drop the symlinks - they are evil...
> Use a structure like:
> include/asm-mn10300/asb2303/proc/*.h

No.  I think all the arch headers should really appear to be #included under
asm/.  That means that the structure would have to be:

	include/asm-mn10300/asb2303/asm/proc/*.h

That then puts all these header files several levels further down, which isn't
that good.

> Then you adjust -I include/asm-mn10300/asb2303
> and no symlinks needed.
> And if you change processor kbuild will notice
> and recompile everything.

That's the only plus, but it's a smaller plus than not interpolating several
levels of almost empty directory into the paths for the proc- and unit-specific
headers.

> No-one else does it this way but mn10300 could show how to do it.

I could.  Or I could do what everyone else does.

Actually, what you perhaps ought to do for a start is to move the individual
include/asm-$ARCH dirs to arch/$ARCH/asm and then you can avoid that symlink
too.

> 5)
> +zImage: vmlinux
> +	$(Q)$(MAKE) $(build)=$(boot) $(KBUILD_IMAGE)
> +
> +all: zImage
> +
> +Image: vmlinux
> +	$(Q)$(MAKE) $(build)=arch/mn10300/boot $@
> 
> This could be done as:
> +Image zImage: vmlinux
> +	$(Q)$(MAKE) $(build)=$(boot) $(boot)/$@

Done.

> And then modify boot/Makefile accordingly

I don't see why it needs modification.  $(KBUILD_IMAGE) == $(boot)/zImage for
the zImage target.

> 6) archdep is long gone - delete the following

Done.

> 7) Please set KBUILD_DEFCONFIG := asb2303_defconfig
> This enable build monkeys(1) to do "make ARCH=mn10300 defconfig"

Done.

> arch/mn10300/boot/Makefile:
> 
> 1) You can safely remove the copyright of Linus..
>    Same goes for other places where his copyright are kept but filecontent
>    is new.

The copyright assignment on some of these files was made by MEI.  I'm not sure
I can change them.

> 2) The Image target is missing (as defined in arch/mn10300/Makefile
>    Can you just kill it?

Yes.  Done.

> arch/mn10300/boot/compressed/Makefile:
> 1) Is -tarditional really needed. We try to kill it all over (slowly)

Apparently not.  Consider it gone.

> 2) Please name the linker script *.lds

Done.

> arch/mn10300/kernel/Makefile:
> +# This next line shouldn't be necessary, but it is.
> +CPPFLAGS += $(CPPFLAGS_$(@F))
> +CPPFLAGS_asm-offsets.s = -D__ASM_OFFSETS_H__
> 
> Please explain why...

I don't remember why.  It doesn't seem to be necessary now, however, so it's
now gone.

> arch/mn10300/oprofile/Makefile:
> +profdrvr-y				:= op_model_null.o
> +
> +oprofile-y				:= $(DRIVER_OBJS) $(profdrvr-y)
> 
> The variable profdrvr seems useless.

Gone.

> arch/mn10300/unit-asb2303/Makefile:
> 
> Please drop this wrong comment:
> +# Note! Dependencies are done automagically by 'make dep', which also
> +# removes any old dependencies. DON'T put your own dependencies here
> +# unless it's something special (ie not a .c file).
> +#
> +# Note 2! The CFLAGS definitions are now in the main makefile...
> +
> 
> Seen in other places where they are equally wrong/outdated.

Gone.

David
