Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1759368AbYLQL02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759368AbYLQL02 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 06:26:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752058AbYLQLZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 06:25:57 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:50183 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbYLQLZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 06:25:56 -0500
Date: Wed, 17 Dec 2008 12:27:23 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: jdike@addtoit.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] get rid of the last symlink in uml build
Message-ID: <20081217112723.GA5027@uranus.ravnborg.org>
References: <20081217061250.GX28946@ZenIV.linux.org.uk> <20081217072620.GA3551@uranus.ravnborg.org> <20081217083734.GA28946@ZenIV.linux.org.uk> <20081217085539.GA4152@uranus.ravnborg.org> <20081217091058.GB28946@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081217091058.GB28946@ZenIV.linux.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2008 at 09:10:58AM +0000, Al Viro wrote:
> On Wed, Dec 17, 2008 at 09:55:39AM +0100, Sam Ravnborg wrote:
> 
> > > AFAICS, having archprepare depend on user_constants.h and kern_constants.h
> > > would do just fine.  Note that we don't care how these two are ordered;
> > > it's asm-offsets.h that can't be created without user_constants.h.
> > 
> > Agreed.
> > 
> > Previously we had some race issues in the arch Makefile when they used
> > the prepare target and they were workaround in various ways.
> > This was why we introduced archprepare in the first place IIRC.
> > And I also recall that um was starnge but this is all cleaned up now - good.
> 
> FWIW, how do you plan to deal with include/asm once everything gets moved
> to arch/*/include/asm?
> 
> Right now O=... builds create asm-offsets.h in $(objtree)/include/asm; do
> you plan to take it to $(objtree)/arch/$(ARCH)/include/asm?
I plan to take it somewhere else - but I have only thought that I want
to avoid mixing generated files with source files.

This also depends on what we decide to do with asm-generic.

Arnd suggested to let kbuild geneate a set of wrapper files so we
was backward compatible with the files that do 

.. something ...
#include <asm-generic/...>
.. somthing more ..

and also files that just do:
#include <asm-generic/...>

Where the latter could simply be dropped as we would then search the
directory with the wrapper files first.
If we do something like that then we could save asm-offsets.h there.

In other words - hand wawing for now. I will revisit this when the rest
has moved. And there is really nothing preventing the last archs to move.

> Another bloody annoying thing is dangling include2/asm on such builds, along
> with include/asm-x86 created on non-O=.. ones.
I sent Andi a patch where we also update the symlink so he could switch
source directory but keep output directory.
But in lack of feedback I have not included in in kbuild.

diff --git a/Makefile b/Makefile
index 9a49960..8273148 100644
--- a/Makefile
+++ b/Makefile
@@ -934,8 +934,8 @@ ifneq ($(KBUILD_SRC),)
 	fi;
 	$(Q)if [ ! -d include2 ]; then                                  \
 	    mkdir -p include2;                                          \
-	    ln -fsn $(srctree)/include/asm-$(SRCARCH) include2/asm;     \
 	fi
+	$(Q)ln -fsn $(srctree)/include/asm-$(SRCARCH) include2/asm
 endif
 
 # prepare2 creates a makefile if using a separate output directory

I will include it in kbuild soon.

> If/when we stop doing that and just put asm-offsets.h into arch/*/include/asm
> we'll need to update the rule for kern_constants.h to
> $(SHARED_HEADERS)/kern_constants.h:
> 	$(Q)mkdir -p $(dir $@)
> 	$(Q)echo '#include "../asm/asm-offsets.h"' >$@
> Not a big deal, just something that'll need to be taken care of when we
> switch...
Yes - I will try to remember.

	Sam
