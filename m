Return-Path: <linux-kernel-owner+w=401wt.eu-S1755820AbZDKPkF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755820AbZDKPkF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 11:40:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754952AbZDKPjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 11:39:52 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:59700 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843AbZDKPjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 11:39:52 -0400
Date: Sat, 11 Apr 2009 16:39:33 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Jike Song <albcamus@gmail.com>, David Howells <dhowells@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>, torvalds@osdl.org,
       akpm@linux-foundation.org, linux-am33-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] MN10300: Move arch headers to arch dir
Message-ID: <20090411153933.GU26366@ZenIV.linux.org.uk>
References: <19057.1239370935@redhat.com> <20090410192529.GA25551@uranus.ravnborg.org> <df9815e70904102042r2cd2e3e3ue6159f348e4c192e@mail.gmail.com> <20090411054516.GA29493@uranus.ravnborg.org> <20090411064300.GT26366@ZenIV.linux.org.uk> <20090411075549.GA30873@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090411075549.GA30873@uranus.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 11, 2009 at 09:55:49AM +0200, Sam Ravnborg wrote:
> > How about a single directory for *all* generated headers?  Only linux/version.h
> > has many places including it and even that can be dealt with for a moment with
> > linux/version.h consisting of #include <gen/version.h>.  The rest doesn't
> > need anything like that even for transition period - too few includes to care.
> 
> So you suggest: include/gen/

Yes.

> asm-offsets.h, mach-types.h and version.h is the ones with the highest count.
> And version.h is an exported header which we cannot move in our exported
> set of headers. Fortunately I have just checked in a patch so we can specify
> an alternative destination when exporting so this should deal with version.h.
> 
> asm-offsets.h and mach-types.h require a small helper file as you suggest,
> otherwise it would be a _huge_ patch.

OK...  I suspect that many asm-offsets.h users might end up killable, but
removal and replacement are not too different wrt patch size.

> We can later migrate more generated files to this location.
> (autoconf.h, config/* etc).

autoconf.h is *trivial* to move.  What we have is

Makefile:                   -include include/linux/autoconf.h
Makefile:       $(Q)test -e include/linux/autoconf.h -a -e $@ || (              \
Makefile:       echo "         include/linux/autoconf.h or $@ are missing.";    \
Makefile:                  include/linux/autoconf.h include/linux/version.h      \
arch/cris/arch-v32/kernel/head.S:#include <linux/autoconf.h>
arch/cris/kernel/asm-offsets.c:#include <linux/autoconf.h>
arch/cris/kernel/vmlinux.lds.S:#include <linux/autoconf.h>
arch/ia64/kvm/asm-offsets.c:#include <linux/autoconf.h>
drivers/accessibility/braille/braille_console.c:#include <linux/autoconf.h>
drivers/hid/hid-lg.h:#include <linux/autoconf.h>
drivers/platform/x86/compal-laptop.c:#include <linux/autoconf.h>
include/linux/mmdebug.h:#include <linux/autoconf.h>
scripts/basic/fixdep.c:         if (strrcmp(s, "include/linux/autoconf.h") &&
scripts/kconfig/confdata.c:             name = "include/linux/autoconf.h";
scripts/mkcompile_h:if [ -r $TARGET -a ! -O include/linux/autoconf.h ]; then

and direct includes should be removed anyway - we already have -include in
flags.  So it's 8 removals in one patch and 7 replacements in another (a
bit more, since there are comments to update).  bounds.h is even easier:

.gitignore:include/linux/bounds.h
Kbuild:bounds-file := include/linux/bounds.h
Makefile:                  include/linux/bounds.h include/asm*/asm-offsets.h     \
include/linux/mmzone.h:#include <linux/bounds.h>
include/linux/page-flags.h:#include <linux/bounds.h>

utsrelease.h is a bit heavier - 19 instances.  compile.h - 6 instances.
ia64 nr-irqs.h - 4 instances.  

I'm not sure about include/config, actually - it's also not that much, but
it might be better to merge separately.

Note, BTW, that include/gen kills include/asm and include2/ (on O= builds),
leaving us only with $(objtree)/source symlink and a couple of nonsense ones
(arch/{i386,x86_64}/boot/bzImage -> ../../x86/boot/bzImage; do we still need
them, anyway?)  IIRC, you wanted to get rid of symlinks...
