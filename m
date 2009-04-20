Return-Path: <linux-kernel-owner+w=401wt.eu-S1753316AbZDTCuN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316AbZDTCuN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 22:50:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752486AbZDTCt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 22:49:58 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54433 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbZDTCt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 22:49:57 -0400
Date: Mon, 20 Apr 2009 03:49:54 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Paul Mundt <lethal@linux-sh.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT] kbuild
Message-ID: <20090420024954.GW26366@ZenIV.linux.org.uk>
References: <20090419092555.GA19213@uranus.ravnborg.org> <20090419223959.GB12054@linux-sh.org> <20090419234501.GA6475@uranus.ravnborg.org> <alpine.LFD.2.00.0904191745390.2199@localhost.localdomain> <20090420014158.GV26366@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090420014158.GV26366@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 20, 2009 at 02:41:58AM +0100, Al Viro wrote:
> On Sun, Apr 19, 2009 at 05:52:32PM -0700, Linus Torvalds wrote:
> > 
> > 
> > On Mon, 20 Apr 2009, Sam Ravnborg wrote:
> > > 
> > > You will soon see a path from me where I fix sh too.
> > 
> > Can we do a global 'sed s:asm/asm-offsets.h:generated/asm-offsets.h:g' 
> > thing too? And then get rid of the include/asm symlink?
> > 
> > That asm-offsets.h mess is scary. I don't quite know why kvm on ia64 seems 
> > to do it's own asm-offsets.h file, for example. And arch/blackfin/Makefile 
> > mentions arch/$(ARCH)/include/asm/asm-offsets.h (but does it actually do 
> > one?).
> 
> We'll need to update uml as well (contents of shared/kern_constants.h)

BTW, while we are at it...  There's a way to deal with arch/um without
that kind of contortions, provided that we are willing to use -idirafter.

For the current tree the minimal patch would be just this, and after that
we can simply replace all kern_constants.h includes with asm/asm-offsets.h
or generated/asm-offsets.h.  And remove kern_constants.h completely once
that is done.

Moreover, once include/generated gets in, we can move user_constants.h
over there and lose the "add -I$(SHARED_HEADERS) to ARCH_INCLUDE for
O=... builds bit" in arch/um/Makefile as well.


diff --git a/arch/um/Makefile b/arch/um/Makefile
index 0728def..dce2d7f 100644
--- a/arch/um/Makefile
+++ b/arch/um/Makefile
@@ -47,7 +47,7 @@ KBUILD_AFLAGS += $(ARCH_INCLUDE)
 
 USER_CFLAGS = $(patsubst $(KERNEL_DEFINES),,$(patsubst -D__KERNEL__,,\
 	$(patsubst -I%,,$(KBUILD_CFLAGS)))) $(ARCH_INCLUDE) $(MODE_INCLUDE) \
-	$(filter -I%,$(CFLAGS)) -D_FILE_OFFSET_BITS=64
+	$(filter -I%,$(CFLAGS)) -D_FILE_OFFSET_BITS=64 -idirafter include
 
 include $(srctree)/$(ARCH_DIR)/Makefile-$(SUBARCH)
 
@@ -150,6 +150,6 @@ $(SHARED_HEADERS)/user_constants.h: $(ARCH_DIR)/sys-$(SUBARCH)/user-offsets.s
 
 $(SHARED_HEADERS)/kern_constants.h:
 	$(Q)mkdir -p $(dir $@)
-	$(Q)echo '#include "../../../../include/asm/asm-offsets.h"' >$@
+	$(Q)echo '#include <asm/asm-offsets.h>' >$@
 
 export SUBARCH USER_CFLAGS CFLAGS_NO_HARDENING OS HEADER_ARCH DEV_NULL_PATH
